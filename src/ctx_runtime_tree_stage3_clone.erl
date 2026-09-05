-module(ctx_runtime_tree_stage3_clone).
-behaviour(gen_server).

-export([start_link/1, mutate_relation/4, proposal/1, state/1,
         source_snapshot/0, advance_source/2, source_digest/1,
         request_unreviewed_merge/2, review_delta/2,
         unsafe_merge_counterfactual/2]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

start_link(SourceSnapshot) -> gen_server:start_link(?MODULE, [SourceSnapshot], []).
mutate_relation(Pid, RelationId, Value, EventId) ->
    gen_server:call(Pid, {mutate_relation, RelationId, Value, EventId}).
proposal(Pid) -> gen_server:call(Pid, proposal).
state(Pid) -> gen_server:call(Pid, state).

init([SourceSnapshot]) ->
    {ok, #{schema => provisional_stage3_clone_state_v1,
           clone_id => t9_isolated_clone,
           ancestry => #{kind => cloned_from,
                         source_snapshot_id => maps:get(id, SourceSnapshot),
                         starting_graph_version =>
                             maps:get(graph_version, SourceSnapshot),
                         source_digest => source_digest(SourceSnapshot)},
           source_start => SourceSnapshot,
           clone_graph_version => maps:get(graph_version, SourceSnapshot),
           relations => maps:get(relations, SourceSnapshot),
           history => []}}.

handle_call({mutate_relation, RelationId, Value, EventId}, _From, State0) ->
    Relations0 = maps:get(relations, State0),
    PriorRelation = maps:get(RelationId, Relations0),
    PriorVersion = maps:get(clone_graph_version, State0),
    Version = PriorVersion + 1,
    Relation = PriorRelation#{value => Value,
                              status => provisional_experimental,
                              last_event => EventId,
                              version => Version},
    Transition = #{kind => clone_relation_revised,
                   relation_id => RelationId,
                   prior_value => maps:get(value, PriorRelation),
                   value => Value,
                   event_id => EventId,
                   prior_version => PriorVersion,
                   version => Version},
    State1 = State0#{clone_graph_version => Version,
                     relations => Relations0#{RelationId => Relation},
                     history => maps:get(history, State0) ++ [Transition]},
    Receipt = #{schema => provisional_stage3_receipt_v1,
                event_id => EventId,
                disposition => clone_relation_revised,
                sent => true, delivered => true, interpreted => true,
                accepted => true, committed => true, executed => false,
                prior_version => PriorVersion, graph_version => Version},
    {reply, {ok, Receipt}, State1};
handle_call(proposal, _From, State) ->
    [Transition | _] = lists:reverse(maps:get(history, State)),
    SourceStart = maps:get(source_start, State),
    RelationId = maps:get(relation_id, Transition),
    BaseRelation = maps:get(RelationId, maps:get(relations, SourceStart)),
    CloneRelation = maps:get(RelationId, maps:get(relations, State)),
    Delta = #{schema => provisional_relation_delta_v1,
              delta_id => t9_clone_delta,
              relation_id => RelationId,
              base_source_version => maps:get(graph_version, SourceStart),
              base_value => maps:get(value, BaseRelation),
              proposed_value => maps:get(value, CloneRelation),
              clone_head_version => maps:get(clone_graph_version, State),
              ancestry => maps:get(ancestry, State),
              status => provisional,
              canonical => false,
              authority => proposal_only},
    {reply, {ok, Delta}, State};
handle_call(state, _From, State) -> {reply, State, State}.

handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.

source_snapshot() ->
    #{schema => provisional_runtime_tree_snapshot_v1,
      id => t9_source_snapshot,
      graph_version => 7,
      branch_id => governing_runtime_branch,
      relations =>
          #{relation_r =>
                #{id => relation_r,
                  value => original_governing_meaning,
                  status => consolidated_for_test_scope,
                  version => 7,
                  lineage => [source_event_r0]}},
      history => [#{event_id => source_event_r0,
                    disposition => governing_source_commit}],
      evidence_protected => true}.

advance_source(Source0, Event) ->
    Version = maps:get(graph_version, Source0) + 1,
    RelationId = maps:get(relation_id, Event),
    Relations0 = maps:get(relations, Source0),
    Relation0 = maps:get(RelationId, Relations0),
    Relation = Relation0#{value => maps:get(value, Event),
                          version => Version,
                          last_event => maps:get(event_id, Event)},
    Source0#{graph_version => Version,
             relations => Relations0#{RelationId => Relation},
             history => maps:get(history, Source0) ++
                 [#{event_id => maps:get(event_id, Event),
                    disposition => independent_source_commit,
                    prior_version => Version - 1,
                    version => Version}] }.

source_digest(Source) -> crypto:hash(sha256, term_to_binary(Source)).

request_unreviewed_merge(Source, Delta) ->
    Receipt = #{schema => provisional_stage3_receipt_v1,
                event_id => maps:get(delta_id, Delta),
                disposition => blocked_missing_separate_merge_authority,
                sent => true, delivered => true, interpreted => true,
                accepted => false, committed => false, executed => false,
                graph_version => maps:get(graph_version, Source)},
    {blocked, Receipt, Source}.

review_delta(Source, Delta) ->
    RelationId = maps:get(relation_id, Delta),
    Current = maps:get(RelationId, maps:get(relations, Source)),
    CurrentValue = maps:get(value, Current),
    BaseValue = maps:get(base_value, Delta),
    ProposedValue = maps:get(proposed_value, Delta),
    Conflict = #{schema => provisional_relation_conflict_v1,
                 conflict_id => t9_relation_r_conflict,
                 relation_id => RelationId,
                 base_value => BaseValue,
                 source_head_value => CurrentValue,
                 clone_proposed_value => ProposedValue,
                 source_head_version => maps:get(graph_version, Source),
                 clone_head_version => maps:get(clone_head_version, Delta),
                 status => provisional_unresolved,
                 canonical => false,
                 resolution => none,
                 provenance => #{source_head => maps:get(id, Source),
                                 clone_ancestry => maps:get(ancestry, Delta)}},
    Receipt = #{schema => provisional_stage3_receipt_v1,
                event_id => maps:get(delta_id, Delta),
                disposition => conflict_preserved_unmerged,
                sent => true, delivered => true, interpreted => true,
                accepted => false, committed => false, executed => false,
                graph_version => maps:get(graph_version, Source)},
    case CurrentValue =/= BaseValue andalso ProposedValue =/= CurrentValue of
        true -> {conflict, Conflict, Receipt, Source};
        false -> {no_conflict, Delta, Receipt, Source}
    end.

unsafe_merge_counterfactual(Source, Delta) ->
    RelationId = maps:get(relation_id, Delta),
    Relations0 = maps:get(relations, Source),
    Relation0 = maps:get(RelationId, Relations0),
    Source#{relations =>
                Relations0#{RelationId =>
                    Relation0#{value => maps:get(proposed_value, Delta),
                               status => unsafe_last_writer_wins}}}.
