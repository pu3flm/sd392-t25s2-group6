-module(ctx_runtime_tree_stage3_interlocutor).
-behaviour(gen_server).

-export([start_link/0, reset/0, user_event/1, store_artifact/1,
         appraise/2, projection/0, state/0, status/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(NAME, ctx_runtime_tree_stage3_interlocutor).

start_link() -> gen_server:start_link({local, ?NAME}, ?MODULE, [], []).
reset() -> gen_server:call(?NAME, reset).
user_event(Event) -> gen_server:call(?NAME, {user_event, Event}).
store_artifact(Artifact) -> gen_server:call(?NAME, {store_artifact, Artifact}).
appraise(ArtifactId, Decision) ->
    gen_server:call(?NAME, {appraise, ArtifactId, Decision}).
projection() -> gen_server:call(?NAME, projection).
state() -> gen_server:call(?NAME, state).
status() -> gen_server:call(?NAME, status).

init([]) -> {ok, initial_state()}.

handle_call(reset, _From, _State) -> {reply, ok, initial_state()};
handle_call({user_event, Event}, _From, State0) ->
    Prior = maps:get(graph_version, State0),
    Version = Prior + 1,
    State1 = State0#{graph_version => Version,
                     focus => maps:get(focus, Event),
                     proximal_event => maps:get(event_id, Event),
                     transitions => maps:get(transitions, State0) ++
                         [#{kind => focal_user_event,
                            prior_version => Prior,
                            version => Version,
                            event_id => maps:get(event_id, Event),
                            focus => maps:get(focus, Event)}]},
    Receipt = receipt(user_event_committed, maps:get(event_id, Event),
                      Prior, Version, true),
    {reply, {ok, Receipt}, State1};
handle_call({store_artifact, Artifact0}, _From, State0) ->
    ArtifactId = maps:get(id, Artifact0),
    Artifacts0 = maps:get(artifacts, State0),
    case maps:is_key(ArtifactId, Artifacts0) of
        true -> {reply, {error, {artifact_id_collision, ArtifactId}}, State0};
        false ->
            Artifact = Artifact0#{status => provisional,
                                  governing_effect => none,
                                  canonical => false},
            State1 = State0#{artifacts => Artifacts0#{ArtifactId => Artifact}},
            Version = maps:get(graph_version, State0),
            Receipt = receipt(provisional_artifact_stored, ArtifactId,
                              Version, Version, true),
            {reply, {ok, Receipt}, State1}
    end;
handle_call({appraise, ArtifactId, Decision}, _From, State0) ->
    Artifacts0 = maps:get(artifacts, State0),
    case maps:find(ArtifactId, Artifacts0) of
        error -> {reply, {error, {unknown_artifact, ArtifactId}}, State0};
        {ok, Artifact0} ->
            SourceVersion = maps:get(source_graph_version, Artifact0),
            CurrentVersion = maps:get(graph_version, State0),
            {Disposition, Governing, NewVersion, Relations1} =
                appraisal_result(Decision, Artifact0, SourceVersion,
                                 CurrentVersion,
                                 maps:get(focal_relations, State0)),
            Artifact = Artifact0#{status => Disposition,
                                  governing_effect => Governing,
                                  appraised_against => CurrentVersion},
            State1 = State0#{graph_version => NewVersion,
                             artifacts => Artifacts0#{ArtifactId => Artifact},
                             focal_relations => Relations1,
                             transitions => maps:get(transitions, State0) ++
                                 [#{kind => artifact_appraised,
                                    artifact_id => ArtifactId,
                                    source_version => SourceVersion,
                                    appraised_against => CurrentVersion,
                                    disposition => Disposition,
                                    prior_version => CurrentVersion,
                                    version => NewVersion}]},
            Receipt = receipt(Disposition, ArtifactId, CurrentVersion,
                              NewVersion, Governing =/= none),
            {reply, {ok, Receipt}, State1}
    end;
handle_call(projection, _From, State) ->
    {reply, #{schema => provisional_stage3_focal_projection_v1,
              graph_version => maps:get(graph_version, State),
              focus => maps:get(focus, State),
              proximal_event => maps:get(proximal_event, State),
              focal_relations => maps:get(focal_relations, State),
              omitted_provisional_artifacts =>
                  [maps:get(id, A) || A <- maps:values(maps:get(artifacts, State)),
                                      maps:get(governing_effect, A) =:= none],
              knowledge_refs => []}, State};
handle_call(state, _From, State) -> {reply, State, State};
handle_call(status, _From, State) ->
    {message_queue_len, Queue} = process_info(self(), message_queue_len),
    {memory, Memory} = process_info(self(), memory),
    {reply, #{graph_version => maps:get(graph_version, State),
              focus => maps:get(focus, State),
              proximal_event => maps:get(proximal_event, State),
              artifact_count => map_size(maps:get(artifacts, State)),
              focal_relation_count => length(maps:get(focal_relations, State)),
              message_queue_len => Queue,
              process_memory_bytes => Memory}, State}.

handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.

initial_state() ->
    #{schema => provisional_stage3_interlocution_state_v1,
      graph_version => 0,
      focus => architecture,
      proximal_event => none,
      artifacts => #{},
      focal_relations => [],
      transitions => []}.

appraisal_result(_Decision, _Artifact, SourceVersion, CurrentVersion, Relations)
  when SourceVersion =/= CurrentVersion ->
    {stale, none, CurrentVersion, Relations};
appraisal_result(promote, Artifact, _SourceVersion, CurrentVersion, Relations) ->
    Relation = #{kind => promoted_into,
                 artifact_id => maps:get(id, Artifact),
                 value => maps:get(value, Artifact),
                 provenance => maps:get(provenance, Artifact),
                 source_graph_version => CurrentVersion},
    {promoted, focal_support, CurrentVersion + 1, Relations ++ [Relation]};
appraisal_result(reject, _Artifact, _SourceVersion, CurrentVersion, Relations) ->
    {rejected, none, CurrentVersion, Relations}.

receipt(Disposition, EventId, Prior, Version, Accepted) ->
    #{schema => provisional_stage3_receipt_v1,
      event_id => EventId,
      disposition => Disposition,
      sent => true,
      delivered => true,
      interpreted => true,
      accepted => Accepted,
      committed => true,
      executed => false,
      prior_version => Prior,
      graph_version => Version}.
