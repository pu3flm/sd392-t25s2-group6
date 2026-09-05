-module(ctx_runtime_tree_stage4_resource).
-behaviour(gen_server).

-export([start_link/0, reset/0, submit_background/1, focal_projection/0,
         reactivate/1, release_pressure/0, state/0, status/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(NAME, ctx_runtime_tree_stage4_resource).

start_link() -> gen_server:start_link({local, ?NAME}, ?MODULE, [], []).
reset() -> gen_server:call(?NAME, reset).
submit_background(Artifact) ->
    gen_server:call(?NAME, {submit_background, Artifact}).
focal_projection() -> gen_server:call(?NAME, focal_projection).
reactivate(Pointer) -> gen_server:call(?NAME, {reactivate, Pointer}).
release_pressure() -> gen_server:call(?NAME, release_pressure).
state() -> gen_server:call(?NAME, state).
status() -> gen_server:call(?NAME, status).

init([]) -> {ok, initial_state()}.

handle_call(reset, _From, _State) -> {reply, ok, initial_state()};
handle_call({submit_background, Artifact0}, _From, State0) ->
    Queue0 = maps:get(background_queue, State0),
    Max = maps:get(max_background_queue, State0),
    Id = maps:get(id, Artifact0),
    Version = maps:get(graph_version, State0),
    case length(Queue0) < Max of
        true ->
            Artifact = Artifact0#{status => provisional,
                                  canonical => false,
                                  governing_effect => none},
            Queue1 = Queue0 ++ [Artifact],
            Receipt = receipt(Id, background_queued, Version, true),
            {reply, {accepted, Receipt},
             State0#{background_queue => Queue1}};
        false ->
            Receipt = receipt(Id, delayed_by_backpressure, Version, false),
            Transition = #{kind => resource_degradation,
                           artifact_id => Id,
                           reason => soft_queue_limit,
                           queue_length => length(Queue0),
                           governing_effect => none},
            {reply, {backpressured, Receipt},
             State0#{degraded => true,
                     backpressure_count =>
                         maps:get(backpressure_count, State0) + 1,
                     operational_transitions =>
                         maps:get(operational_transitions, State0) ++
                             [Transition]}}
    end;
handle_call(focal_projection, _From, State) ->
    Branches = maps:get(branches, State),
    Active = [B || B <- maps:values(Branches),
                   maps:get(status, B) =:= active],
    Queue = maps:get(background_queue, State),
    Projection = #{schema => provisional_stage4_focal_projection_v1,
                   graph_version => maps:get(graph_version, State),
                   node_budget => 2,
                   projected_nodes => Active,
                   projected_node_count => length(Active),
                   protected_focal_present =>
                       lists:any(fun(B) -> maps:get(id, B) =:= focal_branch end,
                                 Active),
                   omitted_background =>
                       [#{id => maps:get(id, A),
                          reason => provisional_background_not_promoted}
                        || A <- Queue],
                   omitted_rejected =>
                       [#{id => maps:get(id, B),
                          reason => rejected_non_governing}
                        || B <- maps:values(Branches),
                           maps:get(status, B) =:= rejected],
                   degraded => maps:get(degraded, State)},
    {reply, Projection, State};
handle_call({reactivate, Pointer}, _From, State0) ->
    Branches0 = maps:get(branches, State0),
    Useful0 = maps:get(useful_dormant_branch, Branches0),
    Version0 = maps:get(graph_version, State0),
    case maps:get(semantic_pointer, Pointer, none) of
        useful_dormant_pointer ->
            Version = Version0 + 1,
            Useful = Useful0#{status => active,
                              reactivated_by => maps:get(event_id, Pointer)},
            Transition = #{kind => branch_reactivated,
                           branch_id => useful_dormant_branch,
                           event_id => maps:get(event_id, Pointer),
                           prior_version => Version0,
                           version => Version},
            Receipt = receipt(maps:get(event_id, Pointer),
                              branch_reactivated, Version, true),
            {reply, {ok, Receipt},
             State0#{graph_version => Version,
                     branches => Branches0#{useful_dormant_branch => Useful},
                     semantic_transitions =>
                         maps:get(semantic_transitions, State0) ++
                             [Transition]}};
        _ ->
            {reply, {ignored,
                     receipt(maps:get(event_id, Pointer),
                             pointer_not_pertinent, Version0, false)}, State0}
    end;
handle_call(release_pressure, _From, State0) ->
    Queue = maps:get(background_queue, State0),
    Preserved = [A#{status => snapshot_backed} || A <- Queue],
    Version = maps:get(graph_version, State0),
    Receipt = receipt(t11_pressure_release, pressure_released,
                      Version, true),
    {reply, {ok, Receipt},
     State0#{background_queue => [],
             background_history =>
                 maps:get(background_history, State0) ++ Preserved,
             degraded => false}};
handle_call(state, _From, State) -> {reply, State, State};
handle_call(status, _From, State) ->
    {message_queue_len, QueueLen} = process_info(self(), message_queue_len),
    {memory, Memory} = process_info(self(), memory),
    {reply, #{graph_version => maps:get(graph_version, State),
              background_queue_length =>
                  length(maps:get(background_queue, State)),
              background_history_count =>
                  length(maps:get(background_history, State)),
              max_background_queue => maps:get(max_background_queue, State),
              backpressure_count => maps:get(backpressure_count, State),
              degraded => maps:get(degraded, State),
              message_queue_len => QueueLen,
              process_memory_bytes => Memory}, State}.

handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.

initial_state() ->
    #{schema => provisional_stage4_resource_state_v1,
      graph_version => 0,
      branches =>
          #{focal_branch =>
                #{id => focal_branch, identity_version => 1,
                  status => active, protected => true, canonical => false,
                  lineage => [t11_focal_source]},
            useful_dormant_branch =>
                #{id => useful_dormant_branch, identity_version => 1,
                  status => dormant, protected => true, canonical => false,
                  lineage => [t11_useful_source]},
            rejected_branch =>
                #{id => rejected_branch, identity_version => 1,
                  status => rejected, protected => true, canonical => false,
                  lineage => [t11_rejected_source, t11_rejection]}},
      max_background_queue => 4,
      background_queue => [],
      background_history => [],
      backpressure_count => 0,
      degraded => false,
      semantic_transitions => [],
      operational_transitions => []}.

receipt(Id, Disposition, Version, Accepted) ->
    #{schema => provisional_stage4_receipt_v1,
      event_id => Id,
      disposition => Disposition,
      sent => true, delivered => true, interpreted => true,
      accepted => Accepted, committed => false, executed => false,
      graph_version => Version}.
