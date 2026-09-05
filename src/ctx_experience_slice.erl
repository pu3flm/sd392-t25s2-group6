-module(ctx_experience_slice).

-export([new/0, new/1, record_interpretation/6, correct/5, observe/4,
         project/3, event/3, head_version/1, transitions/1]).

%% Provisional slice schema: whole immutable snapshots are retained per version.
%% This deliberately tests lineage and changed later selection; it is not a
%% storage, indexing, authority, or general runtime-tree commitment.
-define(SCHEMA, provisional_experience_slice_v1).
-define(PROJECTION_SCHEMA, provisional_experience_projection_v1).

new() -> new(standalone).

new(BranchId) ->
    Empty = empty_snapshot(),
    #{schema => ?SCHEMA,
      branch_id => BranchId,
      head_version => 0,
      versions => #{0 => Empty},
      transitions => []}.

record_interpretation(State0, EventId, Topic, Payload,
                      InterpretationId, Statement) ->
    Snapshot0 = head_snapshot(State0),
    Events0 = maps:get(events, Snapshot0),
    Interpretations0 = maps:get(interpretations, Snapshot0),
    case {maps:is_key(EventId, Events0),
          maps:is_key(InterpretationId, Interpretations0)} of
        {true, _} -> {error, {event_id_collision, EventId}};
        {_, true} -> {error, {interpretation_id_collision, InterpretationId}};
        {false, false} ->
            Version = maps:get(head_version, State0) + 1,
            Event = #{kind => raw_event, id => EventId, topic => Topic,
                      payload => Payload, introduced_at => Version},
            Lineage = [#{kind => raw_event, id => EventId},
                       #{kind => interpretation, id => InterpretationId}],
            Interpretation =
                #{kind => interpretation,
                  id => InterpretationId,
                  source_event => EventId,
                  topic => Topic,
                  statement => Statement,
                  status => provisional,
                  revision => 1,
                  provenance => #{source_space => experience_base,
                                  original_event => EventId,
                                  latest_correction => none},
                  lineage => Lineage,
                  history => [#{revision => 1, action => proposed,
                                event_id => EventId,
                                statement => Statement}]},
            Snapshot1 = Snapshot0#{
                events => Events0#{EventId => Event},
                interpretations =>
                    Interpretations0#{InterpretationId => Interpretation},
                active_by_topic =>
                    (maps:get(active_by_topic, Snapshot0))#{
                        Topic => InterpretationId}},
            commit(State0, interpretation_recorded,
                   #{event_id => EventId,
                     interpretation_id => InterpretationId,
                     topic => Topic}, Snapshot1)
    end.

correct(State0, CorrectionId, InterpretationId, Replacement, Reason) ->
    Snapshot0 = head_snapshot(State0),
    Corrections0 = maps:get(corrections, Snapshot0),
    Interpretations0 = maps:get(interpretations, Snapshot0),
    case {maps:is_key(CorrectionId, Corrections0),
          maps:find(InterpretationId, Interpretations0)} of
        {true, _} -> {error, {correction_id_collision, CorrectionId}};
        {false, error} -> {error, {unknown_interpretation, InterpretationId}};
        {false, {ok, Interpretation0}} ->
            Version = maps:get(head_version, State0) + 1,
            Prior = maps:get(statement, Interpretation0),
            Revision = maps:get(revision, Interpretation0) + 1,
            Correction = #{kind => correction,
                           id => CorrectionId,
                           interpretation_id => InterpretationId,
                           prior_statement => Prior,
                           replacement => Replacement,
                           reason => Reason,
                           introduced_at => Version},
            History = maps:get(history, Interpretation0) ++
                      [#{revision => Revision,
                         action => corrected,
                         correction_id => CorrectionId,
                         prior_statement => Prior,
                         statement => Replacement,
                         reason => Reason}],
            Lineage = maps:get(lineage, Interpretation0) ++
                      [#{kind => correction, id => CorrectionId}],
            Interpretation = Interpretation0#{statement => Replacement,
                                               status => active,
                                               revision => Revision,
                                               provenance =>
                                                   (maps:get(provenance,
                                                             Interpretation0))#{
                                                       latest_correction =>
                                                           CorrectionId},
                                               history => History,
                                               lineage => Lineage},
            Snapshot1 = Snapshot0#{
                corrections => Corrections0#{CorrectionId => Correction},
                interpretations =>
                    Interpretations0#{InterpretationId => Interpretation}},
            commit(State0, correction_recorded,
                   #{correction_id => CorrectionId,
                     interpretation_id => InterpretationId}, Snapshot1)
    end.

observe(State0, EventId, Topic, Payload) ->
    Snapshot0 = head_snapshot(State0),
    Events0 = maps:get(events, Snapshot0),
    case maps:is_key(EventId, Events0) of
        true -> {error, {event_id_collision, EventId}};
        false ->
            Version = maps:get(head_version, State0) + 1,
            Event = #{kind => raw_event, id => EventId, topic => Topic,
                      payload => Payload, introduced_at => Version},
            Snapshot1 = Snapshot0#{events => Events0#{EventId => Event}},
            commit(State0, event_observed,
                   #{event_id => EventId, topic => Topic}, Snapshot1)
    end.

project(State, Version, EventId) ->
    case maps:find(Version, maps:get(versions, State)) of
        error -> {error, {unknown_version, Version}};
        {ok, Snapshot} -> project_from_snapshot(State, Version, EventId, Snapshot)
    end.

event(State, Version, EventId) ->
    case maps:find(Version, maps:get(versions, State)) of
        error -> {error, {unknown_version, Version}};
        {ok, Snapshot} ->
            case maps:find(EventId, maps:get(events, Snapshot)) of
                error -> {error, {unknown_event, EventId}};
                {ok, Event} -> {ok, Event}
            end
    end.

head_version(State) -> maps:get(head_version, State).

transitions(State) -> maps:get(transitions, State).

empty_snapshot() ->
    #{events => #{},
      interpretations => #{},
      corrections => #{},
      active_by_topic => #{}}.

head_snapshot(State) ->
    maps:get(maps:get(head_version, State), maps:get(versions, State)).

commit(State0, Kind, Change, Snapshot) ->
    PriorVersion = maps:get(head_version, State0),
    Version = PriorVersion + 1,
    Transition = #{kind => Kind,
                   branch_id => maps:get(branch_id, State0),
                   prior_version => PriorVersion,
                   version => Version,
                   change => Change},
    Versions0 = maps:get(versions, State0),
    Transitions0 = maps:get(transitions, State0),
    {ok, State0#{head_version => Version,
                 versions => Versions0#{Version => Snapshot},
                 transitions => Transitions0 ++ [Transition]}}.

project_from_snapshot(State, Version, EventId, Snapshot) ->
    Events = maps:get(events, Snapshot),
    case maps:find(EventId, Events) of
        error -> {error, {unknown_event, EventId}};
        {ok, Event} ->
            Topic = maps:get(topic, Event),
            Active = maps:get(active_by_topic, Snapshot),
            case maps:find(Topic, Active) of
                error -> {error, {no_interpretation_for_topic, Topic}};
                {ok, InterpretationId} ->
                    Interpretation = maps:get(
                                       InterpretationId,
                                       maps:get(interpretations, Snapshot)),
                    Selected = maps:with(
                                 [kind, id, source_event, topic, statement,
                                  status, revision, provenance, lineage, history],
                                 Interpretation),
                    {ok, #{schema => ?PROJECTION_SCHEMA,
                           branch_id => maps:get(branch_id, State),
                           graph_version => Version,
                           for_event => EventId,
                           topic => Topic,
                           selected => Selected,
                           knowledge_refs => [],
                           selection_reason =>
                               {active_interpretation_for_topic, Topic}}}
            end
    end.
