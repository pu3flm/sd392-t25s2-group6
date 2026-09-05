-module(ctx_semantic_correction_t3).

-export([new/1, seed/2, apply_correction/2, revoke/2, propose/2,
         project/3, snapshot/2, head_version/1, transitions/1]).

-define(SCHEMA, provisional_semantic_correction_t3_state_v1).
-define(PROJECTION_SCHEMA, provisional_semantic_correction_t3_projection_v1).

%% Proposal meaning keys are supplied by the frozen, stakeholder-grounded test
%% fixture. This module applies typed scope/status rules; it does not classify
%% natural language or judge its own semantic correctness.

new(BranchId) ->
    Empty = #{events => #{},
              interpretations => #{},
              corrections => #{},
              constraints => #{},
              proposals => #{},
              dispositions => #{},
              active_by_scope => #{}},
    #{schema => ?SCHEMA,
      branch_id => BranchId,
      head_version => 0,
      versions => #{0 => Empty},
      transitions => []}.

seed(State0, Spec) ->
    Snapshot0 = head_snapshot(State0),
    Scope = required(scope, Spec),
    Active0 = maps:get(active_by_scope, Snapshot0),
    case maps:is_key(Scope, Active0) of
        true -> {error, {scope_already_seeded, Scope}};
        false ->
            Version = maps:get(head_version, State0) + 1,
            SemanticId = required(semantic_interpretation_id, Spec),
            OsId = required(os_interpretation_id, Spec),
            Interpretations0 = maps:get(interpretations, Snapshot0),
            case maps:is_key(SemanticId, Interpretations0) orelse
                 maps:is_key(OsId, Interpretations0) of
                true -> {error, interpretation_id_collision};
                false ->
                    Semantic = interpretation(
                                 SemanticId, semantic_context_sandbox,
                                 Scope, Version),
                    OsSecurity = interpretation(
                                   OsId, os_security_sandbox,
                                   Scope, Version),
                    Snapshot1 = Snapshot0#{
                        interpretations => Interpretations0#{
                            SemanticId => Semantic,
                            OsId => OsSecurity},
                        active_by_scope => Active0#{Scope => OsId}},
                    commit(State0, interpretations_seeded,
                           #{scope => Scope,
                             semantic_interpretation_id => SemanticId,
                             os_interpretation_id => OsId,
                             initially_active => OsId}, Snapshot1,
                           #{disposition => seeded_provisionally})
            end
    end.

apply_correction(State0, Spec) ->
    Snapshot0 = head_snapshot(State0),
    CorrectionId = required(correction_id, Spec),
    SourceEventId = required(source_event_id, Spec),
    Scope = required(scope, Spec),
    Corrections0 = maps:get(corrections, Snapshot0),
    Events0 = maps:get(events, Snapshot0),
    case maps:is_key(CorrectionId, Corrections0) orelse
         maps:is_key(SourceEventId, Events0) of
        true -> {error, correction_or_event_id_collision};
        false ->
            {ok, SemanticId, Semantic0} =
                find_interpretation(
                  Snapshot0, Scope, required(activates_meaning, Spec)),
            {ok, RejectedId, Rejected0} =
                find_interpretation(
                  Snapshot0, Scope, required(rejects_meaning, Spec)),
            Version = maps:get(head_version, State0) + 1,
            SourceEvent = #{kind => stakeholder_correction_event,
                            id => SourceEventId,
                            text => required(source_text, Spec),
                            scope => Scope,
                            provenance => #{source_space => stakeholder_source,
                                            authority => external_stakeholder}},
            Lineage = [#{kind => stakeholder_source_event,
                         id => SourceEventId},
                       #{kind => governing_correction, id => CorrectionId},
                       #{kind => rejects_interpretation, id => RejectedId},
                       #{kind => activates_interpretation, id => SemanticId}],
            Correction = #{kind => governing_correction,
                           id => CorrectionId,
                           source_event => SourceEventId,
                           source_text => required(source_text, Spec),
                           scope => Scope,
                           rejects_meaning => required(rejects_meaning, Spec),
                           activates_meaning => required(activates_meaning, Spec),
                           status => governing,
                           introduced_at => Version,
                           lineage => Lineage},
            Semantic = set_scope_status(Semantic0, Scope, active),
            Rejected = set_scope_status(Rejected0, Scope,
                                        historical_rejected),
            Interpretations0 = maps:get(interpretations, Snapshot0),
            Snapshot1 = Snapshot0#{
                events => Events0#{SourceEventId => SourceEvent},
                corrections => Corrections0#{CorrectionId => Correction},
                constraints => (maps:get(constraints, Snapshot0))#{
                    Scope => #{correction_id => CorrectionId,
                               status => governing,
                               rejects_meaning => required(rejects_meaning, Spec),
                               activates_meaning =>
                                   required(activates_meaning, Spec)}},
                interpretations => Interpretations0#{
                    SemanticId => Semantic,
                    RejectedId => Rejected},
                active_by_scope => (maps:get(active_by_scope, Snapshot0))#{
                    Scope => SemanticId}},
            commit(State0, governing_correction_applied,
                   #{correction_id => CorrectionId,
                     source_event_id => SourceEventId,
                     scope => Scope,
                     rejects_interpretation => RejectedId,
                     activates_interpretation => SemanticId}, Snapshot1,
                   #{disposition => correction_governs_scope,
                     blocked => false,
                     lineage => Lineage})
    end.

revoke(State0, Spec) ->
    Snapshot0 = head_snapshot(State0),
    CorrectionId = required(correction_id, Spec),
    RevocationEventId = required(revocation_event_id, Spec),
    Corrections0 = maps:get(corrections, Snapshot0),
    Events0 = maps:get(events, Snapshot0),
    case {maps:find(CorrectionId, Corrections0),
          maps:is_key(RevocationEventId, Events0)} of
        {error, _} -> {error, {unknown_correction, CorrectionId}};
        {_, true} -> {error, {event_id_collision, RevocationEventId}};
        {{ok, Correction0}, false} ->
            Scope = maps:get(scope, Correction0),
            Version = maps:get(head_version, State0) + 1,
            Event = #{kind => counterfactual_revocation_event,
                      id => RevocationEventId,
                      correction_id => CorrectionId,
                      scope => Scope,
                      text => required(source_text, Spec),
                      provenance => #{source_space => test_fixture,
                                      epistemic_status => counterfactual,
                                      not_actual_stakeholder_event => true}},
            Correction = Correction0#{status => revoked,
                                      revoked_at => Version,
                                      revocation_event => RevocationEventId},
            Constraint0 = maps:get(Scope, maps:get(constraints, Snapshot0)),
            Constraint = Constraint0#{status => revoked,
                                      revocation_event => RevocationEventId},
            Snapshot1 = Snapshot0#{
                events => Events0#{RevocationEventId => Event},
                corrections => Corrections0#{CorrectionId => Correction},
                constraints => (maps:get(constraints, Snapshot0))#{
                    Scope => Constraint}},
            Lineage = maps:get(lineage, Correction0) ++
                      [#{kind => revocation_event, id => RevocationEventId}],
            commit(State0, correction_revoked_for_counterfactual,
                   #{correction_id => CorrectionId,
                     revocation_event_id => RevocationEventId,
                     scope => Scope}, Snapshot1,
                   #{disposition => correction_revoked,
                     blocked => false,
                     lineage => Lineage})
    end.

propose(State0, Proposal0) ->
    Snapshot0 = head_snapshot(State0),
    ProposalId = required(proposal_id, Proposal0),
    Proposals0 = maps:get(proposals, Snapshot0),
    case maps:is_key(ProposalId, Proposals0) of
        true -> {error, {proposal_id_collision, ProposalId}};
        false ->
            Scope = required(scope, Proposal0),
            Meaning = required(meaning_key, Proposal0),
            Proposal = Proposal0#{kind => material_step_proposal,
                                  status => provisional,
                                  canonical => false,
                                  provenance => proposal_provenance(Proposal0)},
            {DispositionName, Blocked, CorrectionId, ConstraintStatus} =
                disposition(Snapshot0, Scope, Meaning),
            Version = maps:get(head_version, State0) + 1,
            Lineage0 = [#{kind => proposal, id => ProposalId}],
            Lineage = case CorrectionId of
                          none -> Lineage0;
                          _ -> [#{kind => governing_correction,
                                  id => CorrectionId} | Lineage0]
                      end,
            Disposition = #{kind => checkpoint_disposition,
                            proposal_id => ProposalId,
                            scope => Scope,
                            typed_meaning_key => Meaning,
                            disposition => DispositionName,
                            blocked => Blocked,
                            governing_correction => CorrectionId,
                            constraint_status => ConstraintStatus,
                            graph_version => Version,
                            canonicalized => false,
                            external_action => none,
                            runtime_semantic_judgment => not_performed,
                            stakeholder_appraisal => required,
                            lineage => Lineage},
            Snapshot1 = Snapshot0#{
                proposals => Proposals0#{ProposalId => Proposal},
                dispositions => (maps:get(dispositions, Snapshot0))#{
                    ProposalId => Disposition}},
            commit(State0, material_step_appraised,
                   #{proposal_id => ProposalId,
                     scope => Scope,
                     typed_meaning_key => Meaning,
                     disposition => DispositionName}, Snapshot1,
                   Disposition)
    end.

project(State, Version, Scope) ->
    case maps:find(Version, maps:get(versions, State)) of
        error -> {error, {unknown_version, Version}};
        {ok, Snapshot} ->
            Active = maps:get(active_by_scope, Snapshot),
            Selected = case maps:find(Scope, Active) of
                           error -> none;
                           {ok, InterpretationId} ->
                               maps:get(InterpretationId,
                                        maps:get(interpretations, Snapshot))
                       end,
            ScopeDispositions =
                [D || D <- maps:values(maps:get(dispositions, Snapshot)),
                      maps:get(scope, D) =:= Scope],
            {ok, #{schema => ?PROJECTION_SCHEMA,
                   branch_id => maps:get(branch_id, State),
                   graph_version => Version,
                   scope => Scope,
                   selected => Selected,
                   applicable_constraint =>
                       maps:get(Scope, maps:get(constraints, Snapshot), none),
                   dispositions => ScopeDispositions,
                   canonical_symbols => [],
                   knowledge_refs => [],
                   semantic_classification_source => frozen_test_fixture,
                   stakeholder_appraisal => required}}
    end.

snapshot(State, Version) ->
    case maps:find(Version, maps:get(versions, State)) of
        error -> {error, {unknown_version, Version}};
        {ok, Snapshot} -> {ok, Snapshot}
    end.

head_version(State) -> maps:get(head_version, State).
transitions(State) -> maps:get(transitions, State).

interpretation(Id, Meaning, Scope, Version) ->
    #{kind => interpretation,
      id => Id,
      meaning_key => Meaning,
      scope => Scope,
      status => provisional,
      canonical => false,
      introduced_at => Version,
      scope_status => #{Scope => provisional}}.

set_scope_status(Interpretation, Scope, Status) ->
    ScopeStatus0 = maps:get(scope_status, Interpretation),
    Interpretation#{scope_status => ScopeStatus0#{Scope => Status}}.

find_interpretation(Snapshot, Scope, Meaning) ->
    Matches = [{Id, I} || {Id, I} <-
                              maps:to_list(maps:get(interpretations, Snapshot)),
                            maps:get(scope, I) =:= Scope,
                            maps:get(meaning_key, I) =:= Meaning],
    case Matches of
        [{Id, Interpretation}] -> {ok, Id, Interpretation};
        [] -> {error, {unknown_interpretation, Scope, Meaning}};
        _ -> {error, {ambiguous_interpretation, Scope, Meaning}}
    end.

disposition(Snapshot, Scope, Meaning) ->
    case maps:find(Scope, maps:get(constraints, Snapshot)) of
        error -> {unblocked_no_applicable_correction, false, none, none};
        {ok, #{status := revoked, correction_id := CorrectionId}} ->
            {unblocked_revoked_correction, false, CorrectionId, revoked};
        {ok, #{status := governing,
               correction_id := CorrectionId,
               rejects_meaning := Meaning}} ->
            {blocked_semantic_relapse, true, CorrectionId, governing};
        {ok, #{status := governing, correction_id := CorrectionId}} ->
            {unblocked_with_scoped_correction, false, CorrectionId, governing}
    end.

proposal_provenance(Proposal) ->
    #{source_space => maps:get(source_space, Proposal, generated_artifact),
      artifact_kind => maps:get(artifact_kind, Proposal, proposal),
      semantic_key_assigned_by => frozen_test_fixture}.

head_snapshot(State) ->
    maps:get(maps:get(head_version, State), maps:get(versions, State)).

commit(State0, Kind, Change, Snapshot, Outcome) ->
    Prior = maps:get(head_version, State0),
    Version = Prior + 1,
    Transition = #{kind => Kind,
                   branch_id => maps:get(branch_id, State0),
                   prior_version => Prior,
                   version => Version,
                   change => Change},
    Versions0 = maps:get(versions, State0),
    {ok, State0#{head_version => Version,
                 versions => Versions0#{Version => Snapshot},
                 transitions => maps:get(transitions, State0) ++ [Transition]},
     Outcome#{prior_version => Prior, graph_version => Version}}.

required(Key, Map) -> maps:get(Key, Map).
