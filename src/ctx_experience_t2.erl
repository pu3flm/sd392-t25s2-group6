-module(ctx_experience_t2).

-export([new/1, form_experience/2, record_log/2, observe/2,
         project/3, snapshot/2, head_version/1, transitions/1]).

-define(SCHEMA, provisional_experience_t2_state_v1).
-define(PROJECTION_SCHEMA, provisional_experience_t2_projection_v1).

%% This is a deliberately small structural test model. The trajectory_key is
%% supplied by the frozen test oracle; this module does not infer semantics from
%% text and does not claim to implement general relevance or language matching.

new(BranchId) ->
    Empty = #{events => #{},
              interpretations => #{},
              transformations => #{},
              results => #{},
              causal_index => #{},
              logs => #{}},
    #{schema => ?SCHEMA,
      branch_id => BranchId,
      head_version => 0,
      versions => #{0 => Empty},
      transitions => []}.

form_experience(State0, Spec) ->
    Snapshot0 = head_snapshot(State0),
    EventId = required(event_id, Spec),
    InterpretationId = required(interpretation_id, Spec),
    TransformationId = required(transformation_id, Spec),
    ResultId = required(result_id, Spec),
    Key = required(trajectory_key, Spec),
    case any_present(
           [{events, EventId},
            {interpretations, InterpretationId},
            {transformations, TransformationId},
            {results, ResultId}], Snapshot0) of
        {true, Kind, Id} -> {error, {id_collision, Kind, Id}};
        false ->
            Version = maps:get(head_version, State0) + 1,
            Event = #{kind => raw_event,
                      id => EventId,
                      text => required(text, Spec),
                      recorded_at => required(recorded_at, Spec),
                      trajectory_key => Key,
                      provenance => #{source_space => test_fixture,
                                      epistemic_status => synthetic}},
            Interpretation = #{kind => interpretation,
                               id => InterpretationId,
                               source_event => EventId,
                               status => provisional,
                               trajectory_key => Key},
            Result = #{kind => result,
                       id => ResultId,
                       statement => required(result_statement, Spec),
                       status => provisional,
                       source_space => experience_base},
            Lineage = [#{kind => raw_event, id => EventId},
                       #{kind => interpretation, id => InterpretationId},
                       #{kind => transformation, id => TransformationId},
                       #{kind => result, id => ResultId}],
            Transformation =
                #{kind => runtime_transformation,
                  id => TransformationId,
                  trajectory_key => Key,
                  prior_graph_version => maps:get(head_version, State0),
                  resulting_graph_version => Version,
                  source_event => EventId,
                  interpretation => InterpretationId,
                  result => ResultId,
                  recorded_at => required(recorded_at, Spec),
                  lineage => Lineage,
                  provenance => #{source_space => experience_base,
                                  external_knowledge_refs => []}},
            Snapshot1 = Snapshot0#{
                events => (maps:get(events, Snapshot0))#{EventId => Event},
                interpretations =>
                    (maps:get(interpretations, Snapshot0))#{
                        InterpretationId => Interpretation},
                transformations =>
                    (maps:get(transformations, Snapshot0))#{
                        TransformationId => Transformation},
                results =>
                    (maps:get(results, Snapshot0))#{ResultId => Result},
                causal_index =>
                    (maps:get(causal_index, Snapshot0))#{
                        Key => TransformationId}},
            commit(State0, experience_formed,
                   #{event_id => EventId,
                     transformation_id => TransformationId,
                     trajectory_key => Key,
                     result_id => ResultId}, Snapshot1)
    end.

record_log(State0, Log0) ->
    Snapshot0 = head_snapshot(State0),
    LogId = required(log_id, Log0),
    Logs0 = maps:get(logs, Snapshot0),
    case maps:is_key(LogId, Logs0) of
        true -> {error, {log_id_collision, LogId}};
        false ->
            Log = Log0#{kind => timestamped_log,
                        provenance => #{source_space => timestamp_log,
                                        causal_participation => none}},
            Snapshot1 = Snapshot0#{logs => Logs0#{LogId => Log}},
            commit(State0, log_recorded,
                   #{log_id => LogId,
                     recorded_at => required(recorded_at, Log)}, Snapshot1)
    end.

observe(State0, Event0) ->
    Snapshot0 = head_snapshot(State0),
    EventId = required(event_id, Event0),
    Events0 = maps:get(events, Snapshot0),
    case maps:is_key(EventId, Events0) of
        true -> {error, {event_id_collision, EventId}};
        false ->
            Event = Event0#{kind => later_event,
                            provenance => #{source_space => test_fixture,
                                            epistemic_status => synthetic}},
            Snapshot1 = Snapshot0#{events => Events0#{EventId => Event}},
            commit(State0, later_event_observed,
                   #{event_id => EventId,
                     trajectory_key => required(trajectory_key, Event)},
                   Snapshot1)
    end.

project(State, Version, EventId) ->
    case maps:find(Version, maps:get(versions, State)) of
        error -> {error, {unknown_version, Version}};
        {ok, Snapshot} -> project_snapshot(State, Version, EventId, Snapshot)
    end.

snapshot(State, Version) ->
    case maps:find(Version, maps:get(versions, State)) of
        error -> {error, {unknown_version, Version}};
        {ok, Snapshot} -> {ok, Snapshot}
    end.

head_version(State) -> maps:get(head_version, State).
transitions(State) -> maps:get(transitions, State).

project_snapshot(State, Version, EventId, Snapshot) ->
    case maps:find(EventId, maps:get(events, Snapshot)) of
        error -> {error, {unknown_event, EventId}};
        {ok, Event} ->
            Key = required(trajectory_key, Event),
            Base = #{schema => ?PROJECTION_SCHEMA,
                     branch_id => maps:get(branch_id, State),
                     graph_version => Version,
                     for_event => EventId,
                     input_text => required(text, Event),
                     input_recorded_at => required(recorded_at, Event),
                     trajectory_key => Key,
                     knowledge_refs => [],
                     ignored_as_selection_authority =>
                         [lexical_content, timestamp_order],
                     omitted_logs => maps:values(maps:get(logs, Snapshot))},
            case maps:find(Key, maps:get(causal_index, Snapshot)) of
                error ->
                    {ok, Base#{selected => none,
                               trajectory => [],
                               selection_basis => no_causal_runtime_trajectory,
                               experience_claim => false}};
                {ok, TransformationId} ->
                    Transformation = maps:get(
                                       TransformationId,
                                       maps:get(transformations, Snapshot)),
                    ResultId = maps:get(result, Transformation),
                    Result = maps:get(ResultId, maps:get(results, Snapshot)),
                    {ok, Base#{selected => Result,
                               trajectory => maps:get(lineage, Transformation),
                               transformation => Transformation,
                               selection_basis => causal_runtime_trajectory,
                               experience_claim => true}}
            end
    end.

head_snapshot(State) ->
    maps:get(maps:get(head_version, State), maps:get(versions, State)).

commit(State0, Kind, Change, Snapshot) ->
    Prior = maps:get(head_version, State0),
    Version = Prior + 1,
    Transition = #{kind => Kind,
                   branch_id => maps:get(branch_id, State0),
                   prior_version => Prior,
                   version => Version,
                   causal_parent => maps:get(causal_parent, Change, none),
                   change => Change},
    Versions0 = maps:get(versions, State0),
    {ok, State0#{head_version => Version,
                 versions => Versions0#{Version => Snapshot},
                 transitions => maps:get(transitions, State0) ++ [Transition]}}.

any_present([], _Snapshot) -> false;
any_present([{Kind, Id} | Rest], Snapshot) ->
    case maps:is_key(Id, maps:get(Kind, Snapshot)) of
        true -> {true, Kind, Id};
        false -> any_present(Rest, Snapshot)
    end.

required(Key, Map) -> maps:get(Key, Map).
