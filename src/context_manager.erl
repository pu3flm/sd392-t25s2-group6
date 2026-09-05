-module(context_manager).
-behaviour(gen_server).

-export([start_link/1, apply_event/4, ingest_live/5, projection/1,
         worker_state/2, status/0, symbol/1, force_snapshot/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SEED,
        [preserve_purpose_and_provenance,
         make_errors_and_corrections_visible,
         consider_consequences_before_acting,
         do_not_turn_signal_into_authority]).

start_link(Opts) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, Opts, []).

apply_event(Worker, Scope, EventId, Event) ->
    gen_server:call(?MODULE, {apply, Worker, Scope, EventId, Event}, 10000).

ingest_live(Worker, Scope, EventId, RawEvent, Interpretations) ->
    apply_event(Worker, Scope, EventId,
                {live_turn, RawEvent, Interpretations}).

projection(EventId) ->
    gen_server:call(?MODULE, {projection, EventId}, 10000).

worker_state(Worker, Scope) ->
    gen_server:call(?MODULE, {worker_state, Worker, Scope}).

status() -> gen_server:call(?MODULE, status).

symbol(Id) -> gen_server:call(?MODULE, {symbol, Id}).

force_snapshot() -> gen_server:call(?MODULE, force_snapshot).

init(Opts) ->
    Dir = maps:get(storage_dir, Opts, "_context_state"),
    ok = filelib:ensure_dir(filename:join(Dir, "placeholder")),
    TabName = context_runtime_store,
    DetsFile = filename:join(Dir, "journal.dets"),
    {ok, Tab} = dets:open_file(TabName, [{file, DetsFile}, {type, set}]),
    Budget = maps:get(hot_budget, Opts, 4),
    Every = maps:get(snapshot_every, Opts, 3),
    Runtime = #{dir => Dir, tab => Tab, budget => Budget,
                snapshot_every => Every},
    Base = load_snapshot(Runtime),
    State = replay_after_snapshot(Base),
    {ok, add_observation(State, implemented,
                         {manager_started, maps:get(seq, State)})}.

handle_call({worker_state, Worker, Scope}, _From, State) ->
    Default = #{scope => Scope, accepted_events => 0,
                last_event_id => none, seed => ?SEED},
    Reply = maps:get(Worker, maps:get(workers, State), Default),
    {reply, Reply, State};
handle_call({apply, Worker, Scope, EventId, Event}, _From, State0) ->
    Applied = maps:get(applied, State0),
    case maps:find(EventId, Applied) of
        {ok, OldResult} ->
            {reply, {duplicate, OldResult},
             add_observation(State0, implemented,
                             {duplicate_suppressed, EventId})};
        error ->
            Seq = maps:get(seq, State0) + 1,
            Journal = #{seq => Seq, event_id => EventId, worker => Worker,
                        scope => Scope, event => Event},
            ok = dets:insert(maps:get(tab, State0), {{journal, Seq}, Journal}),
            ok = dets:sync(maps:get(tab, State0)),
            {Result, State1} = apply_semantic_event(Worker, Scope, EventId,
                                                     Event, State0#{seq => Seq}),
            State2 = record_worker_event(Worker, Scope, EventId,
                                         State1#{applied => Applied#{EventId => Result}}),
            persist_nodes(State2),
            State3 = maybe_snapshot(State2),
            {reply, {accepted, Result}, State3}
    end;
handle_call(status, _From, State) ->
    {reply, public_status(State), State};
handle_call({symbol, Id}, _From, State) ->
    {Reply, State1} = fetch_symbol(Id, State),
    {reply, Reply, State1};
handle_call({projection, EventId}, _From, State0) ->
    {Reply, State1} = build_projection(EventId, State0),
    {reply, Reply, State1};
handle_call(force_snapshot, _From, State) ->
    {reply, ok, save_snapshot(State)}.

handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.

terminate(_Reason, State) ->
    _ = save_snapshot(State),
    _ = dets:close(maps:get(tab, State)),
    ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

initial_state(Runtime) ->
    Runtime#{seq => 0,
             snapshot_seq => 0,
             seed => ?SEED,
             workers => #{},
             hot => #{},
             catalog => #{},
             edges => #{},
             bridges => #{},
             recurrence => #{},
             policies => #{},
             live_events => #{},
             applied => #{},
             observations => []}.

load_snapshot(Runtime) ->
    Path = snapshot_path(Runtime),
    case file:read_file(Path) of
        {ok, Bin} ->
            try binary_to_term(Bin, [safe]) of
                Saved when is_map(Saved) -> maps:merge(Runtime, Saved)
            catch _:_ -> initial_state(Runtime)
            end;
        {error, _} -> initial_state(Runtime)
    end.

replay_after_snapshot(State0) ->
    SnapshotSeq = maps:get(snapshot_seq, State0, 0),
    Tab = maps:get(tab, State0),
    Entries0 = dets:foldl(
                 fun({{journal, Seq}, J}, Acc) when Seq > SnapshotSeq ->
                         [J | Acc];
                    (_, Acc) -> Acc
                 end, [], Tab),
    Entries = lists:sort(fun(A, B) -> maps:get(seq, A) < maps:get(seq, B) end,
                         Entries0),
    lists:foldl(fun replay_one/2, State0, Entries).

replay_one(J, State0) ->
    EventId = maps:get(event_id, J),
    case maps:is_key(EventId, maps:get(applied, State0)) of
        true -> State0;
        false ->
            Worker = maps:get(worker, J),
            Scope = maps:get(scope, J),
            Event = maps:get(event, J),
            Seq = maps:get(seq, J),
            {Result, State1} = apply_semantic_event(Worker, Scope, EventId,
                                                     Event, State0#{seq => Seq}),
            Applied = maps:get(applied, State1),
            record_worker_event(Worker, Scope, EventId,
                                State1#{applied => Applied#{EventId => Result}})
    end.

apply_semantic_event(Worker, Scope, EventId,
                     {live_turn, RawEvent, Interpretations}, State0)
  when is_map(RawEvent), is_list(Interpretations) ->
    apply_live_turn(Worker, Scope, EventId, RawEvent,
                    Interpretations, State0);
apply_semantic_event(Worker, Scope, EventId,
                     {create, Id, Label, Group, Protected}, State0) ->
    case maps:is_key(Id, maps:get(catalog, State0)) of
        true ->
            {#{effect => rejected, reason => symbol_exists, id => Id}, State0};
        false ->
            Seq = maps:get(seq, State0),
            Provenance = provenance(Worker, Scope, EventId, Seq),
            Node = #{id => Id, kind => symbol, label => Label, group => Group,
                     protected => Protected, status => active, version => 1,
                     last_touch => Seq, access_count => 1,
                     revisions => [#{version => 1, action => created,
                                     provenance => Provenance}]},
            State1 = put_hot(Node, State0),
            {State2, Evicted} = enforce_budget(State1, [Group]),
            Result = #{effect => created, id => Id, version => 1,
                       evicted => Evicted},
            {Result, observe_evictions(State2, Evicted)}
    end;
apply_semantic_event(Worker, Scope, EventId,
                     {relate, EdgeId, From, Relation, To}, State0) ->
    Seq = maps:get(seq, State0),
    Edge = #{id => EdgeId, from => From, to => To, relation => Relation,
             version => 1, status => active,
             revisions => [#{version => 1, action => created,
                             provenance => provenance(Worker, Scope,
                                                      EventId, Seq)}]},
    Edges = maps:get(edges, State0),
    Result = #{effect => related, edge => EdgeId},
    {Result, State0#{edges => Edges#{EdgeId => Edge}}};
apply_semantic_event(Worker, Scope, EventId,
                     {revise_relation, EdgeId, NewRelation, Note}, State0) ->
    Edges = maps:get(edges, State0),
    case maps:find(EdgeId, Edges) of
        error -> {#{effect => rejected, reason => unknown_edge}, State0};
        {ok, Edge0} ->
            Version = maps:get(version, Edge0) + 1,
            Rev = #{version => Version, action => revised,
                    prior_relation => maps:get(relation, Edge0), note => Note,
                    provenance => provenance(Worker, Scope, EventId,
                                             maps:get(seq, State0))},
            Edge = Edge0#{relation => NewRelation, version => Version,
                          revisions => maps:get(revisions, Edge0) ++ [Rev]},
            {#{effect => relation_revised, edge => EdgeId, version => Version},
             State0#{edges => Edges#{EdgeId => Edge}}}
    end;
apply_semantic_event(Worker, Scope, EventId,
                     {review, Id, NewLabel, Note}, State0) ->
    update_node(Id, Worker, Scope, EventId, reviewed,
                fun(Node0, Version, Prov) ->
                    Rev = #{version => Version, action => reviewed,
                            prior_label => maps:get(label, Node0), note => Note,
                            provenance => Prov},
                    Node0#{label => NewLabel, version => Version,
                           revisions => maps:get(revisions, Node0) ++ [Rev]}
                end, State0);
apply_semantic_event(Worker, Scope, EventId,
                     {invalidate, Id, Reason}, State0) ->
    update_node(Id, Worker, Scope, EventId, invalidated,
                fun(Node0, Version, Prov) ->
                    Tombstone = #{version => Version, action => invalidated,
                                  reason => Reason, provenance => Prov},
                    Node0#{status => invalid, version => Version,
                           revisions => maps:get(revisions, Node0) ++ [Tombstone]}
                end, State0);
apply_semantic_event(Worker, Scope, EventId,
                     {reactivate, Id, Reason}, State0) ->
    update_node(Id, Worker, Scope, EventId, reactivated,
                fun(Node0, Version, Prov) ->
                    Rev = #{version => Version, action => reactivated,
                            reason => Reason, provenance => Prov},
                    Node0#{status => active, version => Version,
                           revisions => maps:get(revisions, Node0) ++ [Rev]}
                end, State0);
apply_semantic_event(_Worker, _Scope, _EventId,
                     {define_bridge, Token, Ids}, State0) ->
    Bridges = maps:get(bridges, State0),
    {#{effect => bridge_defined, token => Token, targets => Ids},
     State0#{bridges => Bridges#{Token => Ids}}};
apply_semantic_event(_Worker, _Scope, _EventId,
                     {activate_bridge, Token}, State0) ->
    case maps:find(Token, maps:get(bridges, State0)) of
        error -> {#{effect => rejected, reason => unknown_bridge}, State0};
        {ok, Ids} ->
            {State1, Loaded} = rehydrate_many(Ids, State0),
            KeepGroups = lists:usort([maps:get(group, N) || N <- Loaded]),
            {State2, Evicted} = enforce_budget(State1, KeepGroups),
            Result = #{effect => subgraph_rehydrated, token => Token,
                       rehydrated => [maps:get(id, N) || N <- Loaded],
                       evicted => Evicted},
            {Result, add_observation(observe_evictions(State2, Evicted),
                                     implemented, {bridge_activated, Token})}
    end;
apply_semantic_event(_Worker, _Scope, _EventId,
                     {demand, Type}, State0) ->
    Rec0 = maps:get(recurrence, State0),
    Count = maps:get(Type, Rec0, 0) + 1,
    Rec = Rec0#{Type => Count},
    Policies0 = maps:get(policies, State0),
    {Policies, Effect} =
        case {Count >= 3, maps:is_key(Type, Policies0)} of
            {true, false} ->
                Candidate = #{type => Type, status => latent,
                              source => recurrence_signal,
                              executable => false, reversible => true},
                {Policies0#{Type => Candidate}, latent_candidate_created};
            _ -> {Policies0, recurrence_observed}
        end,
    Result = #{effect => Effect, type => Type, count => Count,
               promoted => false, executed => false},
    {Result, State0#{recurrence => Rec, policies => Policies}};
apply_semantic_event(_Worker, _Scope, _EventId,
                     {promote_policy, Type}, State0) ->
    Policies0 = maps:get(policies, State0),
    case maps:find(Type, Policies0) of
        {ok, Candidate} ->
            Policy = Candidate#{status => active, executable => true,
                                promoted_by => explicit_event},
            {#{effect => policy_promoted, type => Type, executed => false},
             State0#{policies => Policies0#{Type => Policy}}};
        error -> {#{effect => rejected, reason => no_latent_candidate}, State0}
    end;
apply_semantic_event(_Worker, _Scope, _EventId,
                     {demote_policy, Type}, State0) ->
    Policies0 = maps:get(policies, State0),
    case maps:find(Type, Policies0) of
        {ok, Policy0} ->
            Policy = Policy0#{status => latent, executable => false,
                              demoted_by => explicit_event},
            {#{effect => policy_demoted, type => Type},
             State0#{policies => Policies0#{Type => Policy}}};
        error -> {#{effect => rejected, reason => unknown_policy}, State0}
    end;
apply_semantic_event(_Worker, _Scope, _EventId, Unknown, State0) ->
    {#{effect => rejected, reason => {unknown_event, Unknown}}, State0}.

update_node(Id, Worker, Scope, EventId, Effect, Fun, State0) ->
    case load_node(Id, State0) of
        not_found -> {#{effect => rejected, reason => unknown_symbol}, State0};
        {ok, Node0, State1} ->
            Version = maps:get(version, Node0) + 1,
            Prov = provenance(Worker, Scope, EventId, maps:get(seq, State1)),
            Node1 = Fun(Node0, Version, Prov),
            Node = touch(Node1, maps:get(seq, State1)),
            State2 = put_hot(Node, State1),
            {State3, Evicted} = enforce_budget(State2, [maps:get(group, Node)]),
            {#{effect => Effect, id => Id, version => Version,
               evicted => Evicted}, observe_evictions(State3, Evicted)}
    end.

provenance(Worker, Scope, EventId, Seq) ->
    #{worker => Worker, scope => Scope, event_id => EventId, sequence => Seq}.

apply_live_turn(Worker, Scope, EventId, RawEvent,
                Interpretations, State0) ->
    Seq = maps:get(seq, State0),
    Prov = provenance(Worker, Scope, EventId, Seq),
    TurnId = {turn, EventId},
    Event = RawEvent#{id => EventId, node_id => TurnId,
                      sequence => Seq, provenance => Prov},
    {State1, CandidateIds} =
        lists:foldl(
          fun(Candidate, {StateAcc, Ids}) ->
              Id = maps:get(id, Candidate),
              Label = maps:get(label, Candidate),
              Signals = maps:get(signals, Candidate, []),
              Node = #{id => Id, kind => interpretation,
                       label => Label, group => TurnId,
                       protected => false, status => provisional,
                       version => 1, last_touch => Seq, access_count => 1,
                       signals => Signals, source_event => EventId,
                       revisions => [#{version => 1,
                                       action => proposed,
                                       provenance => Prov}]},
              {put_hot(Node, StateAcc), Ids ++ [Id]}
          end, {State0, []}, Interpretations),
    Edges0 = maps:get(edges, State1),
    Edges = lists:foldl(
              fun(Id, Acc) ->
                  EdgeId = {interpretation_of, EventId, Id},
                  Acc#{EdgeId => #{id => EdgeId, from => Id,
                                       to => TurnId,
                                       relation => interpretation_of,
                                       status => provisional, version => 1,
                                       revisions => [#{version => 1,
                                                       action => proposed,
                                                       provenance => Prov}]}}
              end, Edges0, CandidateIds),
    Live0 = maps:get(live_events, State1, #{}),
    Live = Live0#{EventId => Event#{interpretations => CandidateIds}},
    {State2, Evicted} = enforce_budget(
                          State1#{edges => Edges, live_events => Live},
                          [TurnId]),
    Result = #{effect => live_turn_ingested, event_id => EventId,
               interpretations => CandidateIds, selected => none,
               evicted => Evicted},
    {Result, add_observation(observe_evictions(State2, Evicted),
                             implemented, {live_turn_ingested, EventId})}.

build_projection(EventId, State0) ->
    Live = maps:get(live_events, State0, #{}),
    case maps:find(EventId, Live) of
        error -> {not_found, State0};
        {ok, Event} ->
            Ids = maps:get(interpretations, Event, []),
            {State1, Nodes} = rehydrate_many(Ids, State0),
            TurnId = maps:get(node_id, Event),
            RelatedEdges = [Edge || {_Id, Edge} <- maps:to_list(
                                                    maps:get(edges, State1)),
                                    maps:get(from, Edge) =:= TurnId orelse
                                    maps:get(to, Edge) =:= TurnId orelse
                                    lists:member(maps:get(from, Edge), Ids) orelse
                                    lists:member(maps:get(to, Edge), Ids)],
            KeepGroups = lists:usort([maps:get(group, N) || N <- Nodes]),
            {State2, _} = enforce_budget(State1, KeepGroups),
            Reply = #{event => Event,
                      interpretations => Nodes,
                      relations => RelatedEdges,
                      selection => none,
                      rule => preserve_parallel_interpretations_until_corrected,
                      seed => maps:get(seed, State2)},
            {{ok, Reply}, State2}
    end.

record_worker_event(Worker, Scope, EventId, State) ->
    Workers0 = maps:get(workers, State),
    Current = maps:get(Worker, Workers0,
                       #{scope => Scope, accepted_events => 0,
                         last_event_id => none, seed => ?SEED}),
    Next = Current#{accepted_events => maps:get(accepted_events, Current) + 1,
                    last_event_id => EventId},
    State#{workers => Workers0#{Worker => Next}}.

put_hot(Node, State) ->
    Id = maps:get(id, Node),
    Hot0 = maps:get(hot, State),
    Catalog0 = maps:get(catalog, State),
    Meta = node_meta(Node, hot),
    State#{hot => Hot0#{Id => Node}, catalog => Catalog0#{Id => Meta}}.

node_meta(Node, Residency) ->
    (maps:with([id, kind, label, group, protected, status, version,
                last_touch, access_count], Node))#{residency => Residency}.

touch(Node, Seq) ->
    Node#{last_touch => Seq,
          access_count => maps:get(access_count, Node, 0) + 1}.

load_node(Id, State) ->
    case maps:find(Id, maps:get(hot, State)) of
        {ok, Node} -> {ok, Node, State};
        error ->
            case dets:lookup(maps:get(tab, State), {node, Id}) of
                [{{node, Id}, Node0}] ->
                    Node = touch(Node0, maps:get(seq, State)),
                    {ok, Node, put_hot(Node, State)};
                [] -> not_found
            end
    end.

fetch_symbol(Id, State0) ->
    case load_node(Id, State0) of
        not_found -> {not_found, State0};
        {ok, Node, State1} ->
            {State2, _} = enforce_budget(State1, [maps:get(group, Node)]),
            {{ok, Node}, State2}
    end.

rehydrate_many(Ids, State0) ->
    lists:foldl(
      fun(Id, {StateAcc, Nodes}) ->
          case load_node(Id, StateAcc) of
              {ok, Node, StateNext} -> {StateNext, Nodes ++ [Node]};
              not_found -> {StateAcc, Nodes}
          end
      end, {State0, []}, Ids).

enforce_budget(State0, KeepGroups) ->
    Budget = maps:get(budget, State0),
    case maps:size(maps:get(hot, State0)) =< Budget of
        true -> {State0, []};
        false -> evict_until_fit(State0, Budget, KeepGroups, [])
    end.

evict_until_fit(State0, Budget, KeepGroups, Evicted0) ->
    case maps:size(maps:get(hot, State0)) =< Budget of
        true -> {State0, lists:reverse(Evicted0)};
        false ->
            Hot = maps:get(hot, State0),
            Groups = group_nodes(maps:values(Hot)),
            Eligible0 = [{Group, Nodes} || {Group, Nodes} <- maps:to_list(Groups),
                                           not lists:member(Group, KeepGroups),
                                           not lists:any(fun(N) -> maps:get(protected, N) end,
                                                         Nodes)],
            Eligible = case Eligible0 of
                           [] -> [{Group, Nodes} || {Group, Nodes} <- maps:to_list(Groups),
                                                     not lists:any(
                                                           fun(N) -> maps:get(protected, N) end,
                                                           Nodes)];
                           _ -> Eligible0
                       end,
            case Eligible of
                [] -> {State0, lists:reverse(Evicted0)};
                _ ->
                    %% Local heuristic: hard protection first, then transparent ordered
                    %% signals. This is deliberately not a sovereign importance score.
                    Ranked = lists:sort(
                               fun({GA, NA}, {GB, NB}) ->
                                   eviction_signals(GA, NA) < eviction_signals(GB, NB)
                               end, Eligible),
                    {ChosenGroup, ChosenNodes} = hd(Ranked),
                    Ids = [maps:get(id, N) || N <- ChosenNodes],
                    State1 = evict_ids(Ids, State0),
                    evict_until_fit(State1, Budget, KeepGroups,
                                    [{ChosenGroup, Ids,
                                      eviction_signals(ChosenGroup, ChosenNodes)}
                                     | Evicted0])
            end
    end.

group_nodes(Nodes) ->
    lists:foldl(fun(N, Acc) ->
        Group = maps:get(group, N),
        Acc#{Group => [N | maps:get(Group, Acc, [])]}
    end, #{}, Nodes).

eviction_signals(Group, Nodes) ->
    LastTouch = lists:max([maps:get(last_touch, N) || N <- Nodes]),
    Accesses = lists:sum([maps:get(access_count, N) || N <- Nodes]),
    Invalid = length([N || N <- Nodes, maps:get(status, N) =:= invalid]),
    {LastTouch, Accesses, -Invalid, Group}.

evict_ids(Ids, State0) ->
    Hot = maps:get(hot, State0),
    Catalog = maps:get(catalog, State0),
    Hot1 = lists:foldl(fun maps:remove/2, Hot, Ids),
    Catalog1 = lists:foldl(
                 fun(Id, Acc) ->
                     case maps:find(Id, Acc) of
                         {ok, Meta} -> Acc#{Id => Meta#{residency => cold}};
                         error -> Acc
                     end
                 end, Catalog, Ids),
    State0#{hot => Hot1, catalog => Catalog1}.

observe_evictions(State, []) -> State;
observe_evictions(State, Evicted) ->
    add_observation(State, implemented,
                    {application_level_cold_storage, Evicted}).

persist_nodes(State) ->
    Tab = maps:get(tab, State),
    Entries = [{{node, Id}, Node} || {Id, Node} <- maps:to_list(maps:get(hot, State))],
    ok = dets:insert(Tab, Entries),
    ok = dets:sync(Tab).

maybe_snapshot(State) ->
    Every = maps:get(snapshot_every, State),
    case maps:get(seq, State) rem Every of
        0 -> save_snapshot(State);
        _ -> State
    end.

save_snapshot(State0) ->
    Seq = maps:get(seq, State0),
    State = State0#{snapshot_seq => Seq},
    Serializable = maps:without([dir, tab, budget, snapshot_every], State),
    Path = snapshot_path(State),
    Tmp = Path ++ ".tmp",
    ok = file:write_file(Tmp, term_to_binary(Serializable, [compressed])),
    ok = file:rename(Tmp, Path),
    State.

snapshot_path(State) -> filename:join(maps:get(dir, State), "snapshot.term").

add_observation(State, Category, Fact) ->
    Old = maps:get(observations, State, []),
    State#{observations => lists:sublist([{Category, Fact} | Old], 30)}.

public_status(State) ->
    HotIds = lists:sort(maps:keys(maps:get(hot, State))),
    Catalog = maps:get(catalog, State),
    ColdIds = lists:sort([Id || {Id, Meta} <- maps:to_list(Catalog),
                               maps:get(residency, Meta) =:= cold]),
    #{contract => #{memory => {bounded_hot_symbols, maps:get(budget, State)},
                    persistence => application_snapshot_and_dets_journal,
                    concurrency => one_manager_serializes_semantic_mutations,
                    time => logical_sequence_not_wall_clock_truth},
      seed => maps:get(seed, State),
      sequence => maps:get(seq, State),
      workers => maps:get(workers, State),
      hot_ids => HotIds,
      cold_ids => ColdIds,
      catalog => Catalog,
      edges => maps:get(edges, State),
      bridges => maps:get(bridges, State),
      recurrence => maps:get(recurrence, State),
      policies => maps:get(policies, State),
      live_event_ids => lists:sort(maps:keys(maps:get(live_events, State, #{}))),
      observations => lists:reverse(maps:get(observations, State))}.
