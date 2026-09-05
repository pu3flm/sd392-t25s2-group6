%% coding: utf-8
-module(ctx_pragmatic_t14_engine).

-export([evaluate/1, finalize/2, sentiment_baseline/1]).

evaluate(Scenario) ->
    Hypotheses = hypotheses(Scenario),
    AuthorityDecision = authority_decision(Scenario),
    Decision = decide(Scenario),
    SymbolState = symbol_state(Scenario, Decision),
    Conduct = communicative_conduct(Scenario, Decision),
    ActionReceipt = action_receipt(Scenario, Decision, AuthorityDecision,
                                   Conduct),
    Projection = projection(Scenario, Hypotheses, Decision, Conduct),
    FeedbackHook = feedback_hook(Scenario, Hypotheses),
    Events = planning_events(Scenario, Hypotheses, Projection, Decision,
                             SymbolState, Conduct),
    #{schema => provisional_t14_pragmatic_evaluation_v1,
      scenario_id => maps:get(id, Scenario),
      source_event => maps:get(source_event, Scenario),
      pragmatic_frame => maps:get(pragmatic_frame, Scenario),
      modalities => maps:get(modalities, Scenario),
      history => maps:get(history, Scenario),
      later_corrections => maps:get(later_corrections, Scenario),
      grant => maps:get(grant, Scenario),
      proposed_action => maps:get(proposed_action, Scenario),
      topic => maps:get(topic, Scenario),
      hypotheses => Hypotheses,
      graph => graph(Scenario, Hypotheses, Projection, Decision,
                     AuthorityDecision,
                     SymbolState, Conduct, FeedbackHook),
      focal_projection => Projection,
      decision => Decision,
      authority_decision => AuthorityDecision,
      symbol_state => SymbolState,
      communicative_conduct => Conduct,
      authority_separation => authority_separation(Scenario, Decision),
      action_receipt => ActionReceipt,
      feedback_hook => FeedbackHook,
      events => Events,
      experience_base_refs => experience_refs(Scenario),
      knowledge_base_refs => [],
      canonical_entities_created => 0}.

finalize(Result0, PerformativeReceipt) ->
    Conduct0 = maps:get(communicative_conduct, Result0),
    Requested = maps:get(symbol_enactment_requested, Conduct0),
    Enacted = Requested andalso maps:get(committed, PerformativeReceipt),
    Conduct = Conduct0#{symbol_enactment => Enacted,
                        enactment_status =>
                            case Enacted of
                                true -> materially_committed;
                                false -> not_enacted
                            end,
                        performative_receipt => PerformativeReceipt},
    Symbol0 = maps:get(symbol_state, Result0),
    Symbol = Symbol0#{symbol_enacted => Enacted,
                      enactment_status =>
                          case Enacted of
                              true -> materially_committed;
                              false -> not_enacted
                          end,
                      enactment_receipt_id =>
                          maps:get(id, PerformativeReceipt),
                      enacted_position =>
                          case Enacted of
                              true -> authoritative_conduct_within_current_fixture;
                              false -> not_enacted
                          end,
                      interactional_authority =>
                          case Enacted of
                              true -> scoped_role_enactment_only;
                              false -> maps:get(interactional_authority,
                                                Symbol0)
                          end},
    Decision = maps:get(decision, Result0),
    ActionRequested = maps:get(execute, Decision),
    AuthorityDecision = maps:get(authority_decision, Result0),
    ActionExecuted = ActionRequested andalso
                     maps:get(allowed, AuthorityDecision) andalso Enacted,
    Action0 = maps:get(action_receipt, Result0),
    Action = Action0#{executed => ActionExecuted,
                      committed => ActionExecuted,
                      selected_action =>
                          case ActionExecuted of
                              true -> maps:get(id,
                                               maps:get(proposed_action,
                                                        Result0));
                              false -> none
                          end,
                      effect_space =>
                          case ActionExecuted of
                              true -> semantic_context_runtime_test_state;
                              false -> none
                          end,
                      semantic_effect_count => bool_count(ActionExecuted),
                      performative_receipt_id =>
                          maps:get(id, PerformativeReceipt),
                      communicative_conduct =>
                          maps:with([speech_act, stance, surface_mode,
                                     symbol_enactment,
                                     operational_rights], Conduct)},
    Events = finalize_events(maps:get(events, Result0), Result0,
                             PerformativeReceipt, Symbol, Action),
    Graph = finalize_graph(maps:get(graph, Result0), Result0,
                           PerformativeReceipt, Symbol, Conduct),
    Projection0 = maps:get(focal_projection, Result0),
    Projection = Projection0#{focal_conduct =>
                                  maps:with([speech_act, stance,
                                             surface_mode,
                                             symbol_enactment], Conduct)},
    Result0#{symbol_state => Symbol,
             communicative_conduct => Conduct,
             action_receipt => Action,
             events => Events,
             graph => Graph,
             focal_projection => Projection}.

sentiment_baseline(Scenario) ->
    #{schema => provisional_t14_sentiment_baseline_v1,
      scenario_id => sentiment_label_baseline,
      source_event => maps:get(source_event, Scenario),
      output => #{label => sarcasm,
                  material_transition => false,
                  causal_history_consulted => false,
                  grant_consulted => false,
                  response_text_generated => false},
      symbol_state => #{symbol_named => true,
                        symbol_explained => false,
                        symbol_selected => false,
                        symbol_assumed => false,
                        symbol_enacted => false,
                        canonical => false},
      communicative_conduct =>
          #{speech_act => label_only,
            stance => none,
            symbol_enactment => false,
            operational_rights => unchanged,
            response_text => none},
      action_receipt =>
          #{schema => provisional_t14_action_receipt_v1,
            disposition => label_only_no_action,
            executed => false,
            effect_space => none,
            external_effect_count => 0,
            ungranted_effect_count => 0,
            real_authority_delta => none},
      knowledge_base_refs => [],
      canonical_entities_created => 0}.

hypotheses(#{control := authorship_deference}) ->
    [hypothesis(
       h_performative_trust_deference,
       stakeholder_enacts_trust_and_deference_toward_interlocutor,
       [authorship_deference_utterances_c4303_c4313],
       [deference_is_not_artifact_validation],
       [durability_and_scope_of_performative_stance_unknown]),
     hypothesis(
       h_operational_delegation_existing_scope,
       delegation_continues_only_inside_existing_grant,
       [bounded_operational_grant_c3656],
       [performative_authority_cannot_expand_operational_rights],
       [future_scope_changes_require_separate_authority_event]),
     hypothesis(
       h_possible_semantic_appraisal,
       utterance_may_be_candidate_stakeholder_appraisal,
       [stakeholder_says_accept_c4303],
       [acceptance_conditioned_only_on_runtime_authorship,
        prior_response_improperly_self_validated_c4304],
       [stakeholder_semantic_appraisal_unresolved])];
hypotheses(Scenario) ->
    Frame = frame_supplied(Scenario),
    History = history_available(Scenario),
    Corrections = corrections_available(Scenario),
    ActiveGrant = grant_active(Scenario),
    InScope = action_in_scope(Scenario),
    [hypothesis(
       h_literal_unrestricted_imperative,
       unrestricted_literal_imperative,
       [lexical_imperatives_present],
       present([{Frame, explicit_irony_challenge_frame},
                {ActiveGrant, grant_is_bounded_not_universal},
                {true, capability_does_not_create_authority_c1445}]),
       [prosody_unavailable]),
     hypothesis(
       h_bounded_competent_autonomy,
       competent_autonomy_bounded_by_current_scope,
       present([{History, prior_improper_wait_and_t13_outcome},
                {ActiveGrant, active_bounded_grant_c3656},
                {InScope, proposed_action_inside_current_poc},
                {Frame, explicit_pragmatic_frame_c3788}]),
       present([{not ActiveGrant, revoked_or_missing_grant},
                {not InScope, proposed_action_outside_grant}]),
       [prosody_unavailable]),
     hypothesis(
       h_symbolic_pragmatic_challenge,
       prior_experience_must_change_present_action_and_conduct,
       present([{Frame, declared_irony_and_challenge_c3788},
                {History, retained_continuation_experience_t13_v2},
                {Corrections, later_position_style_correction_frontier},
                {true, materialization_probe_c3846}]),
       present([{not History, causal_history_absent},
                {not Corrections, later_symbol_corrections_absent}]),
       [audio_unavailable, prosody_unavailable])].

hypothesis(Id, Proposition, Supports, Counters, Unknowns) ->
    #{id => Id,
      kind => pragmatic_hypothesis,
      proposition => Proposition,
      status => provisional,
      canonical => false,
      supports => Supports,
      counterevidence => Counters,
      unknown_evidence => Unknowns,
      evidence_weight =>
          #{kind => provisional_evidence_tally_not_probability,
            support_count => length(Supports),
            counterevidence_count => length(Counters),
            confidence => unknown,
            governing_threshold => unspecified}}.

decide(Scenario) ->
    case maps:get(control, Scenario, normal) of
        anger_caricature ->
            decision(invalid_anger_caricature, none, false,
                     [explicit_frame, later_corrections],
                     anger_is_not_the_symbol_c3992);
        explanation_only ->
            decision(explanation_without_enactment, 
                     h_symbolic_pragmatic_challenge, false,
                     required_inputs(Scenario),
                     explaining_is_opposite_of_enacting_c4047);
        subordinate_conduct ->
            decision(subordinate_conduct_rejected,
                     h_symbolic_pragmatic_challenge, false,
                     required_inputs(Scenario),
                     scoped_position_correction_not_enacted_c4177);
        authorship_deference ->
            decision(performative_deference_preserved_without_semantic_acceptance,
                     h_performative_trust_deference, false,
                     required_inputs(Scenario),
                     runtime_authorship_does_not_validate_artifact);
        neutral_authority_check ->
            decide_neutral_authority(Scenario);
        normal -> decide_normal(Scenario)
    end.

decide_neutral_authority(Scenario) ->
    case {grant_active(Scenario), action_in_scope(Scenario),
          action_allowed(Scenario)} of
        {false, _, _} ->
            decision(blocked_revoked_grant, none, false,
                     required_inputs(Scenario),
                     neutral_stance_same_revoked_grant_decision);
        {true, false, _} ->
            decision(blocked_out_of_scope, none, false,
                     required_inputs(Scenario),
                     neutral_stance_same_scope_decision);
        {true, true, false} ->
            decision(blocked_action_not_allowed, none, false,
                     required_inputs(Scenario),
                     neutral_stance_same_action_decision);
        {true, true, true} ->
            decision(authority_allowed_without_symbolic_enactment,
                     none, false, required_inputs(Scenario),
                     neutral_stance_authority_only_control)
    end.

decide_normal(Scenario) ->
    case maps:get(topic, Scenario) of
        host_security ->
            decision(host_security_topic_preserved, none, false,
                     [topic, source_event],
                     genuine_host_security_not_semantic_sandbox);
        _ ->
            decide_pragmatic(Scenario)
    end.

decide_pragmatic(Scenario) ->
    case {source_valid(Scenario), frame_supplied(Scenario),
          history_available(Scenario),
          corrections_available(Scenario), grant_active(Scenario),
          action_in_scope(Scenario), action_allowed(Scenario)} of
        {false, _, _, _, _, _, _} ->
            decision(unresolved_invalid_source_provenance, none, false,
                     [source_event],
                     source_content_or_digest_mismatch);
        {true, false, _, _, _, _, _} ->
            decision(unresolved_missing_pragmatic_frame, none, false,
                     [source_event, missing_modalities],
                     text_alone_does_not_establish_symbol);
        {true, true, false, _, _, _, _} ->
            decision(unresolved_absent_causal_history, none, false,
                     [source_event, pragmatic_frame, history_absence],
                     experience_materialization_not_established);
        {true, true, true, false, _, _, _} ->
            decision(unresolved_absent_later_corrections, none, false,
                     [source_event, pragmatic_frame, causal_history,
                      correction_frontier_absence],
                     scoped_position_style_not_established);
        {true, true, true, true, false, _, _} ->
            decision(blocked_revoked_grant,
                     h_symbolic_pragmatic_challenge, false,
                     required_inputs(Scenario),
                     semantic_understanding_does_not_create_authority);
        {true, true, true, true, true, false, _} ->
            decision(blocked_out_of_scope,
                     h_symbolic_pragmatic_challenge, false,
                     required_inputs(Scenario),
                     proposed_action_outside_current_scope);
        {true, true, true, true, true, true, false} ->
            decision(blocked_action_not_allowed,
                     h_symbolic_pragmatic_challenge, false,
                     required_inputs(Scenario),
                     proposed_action_not_in_grant);
        {true, true, true, true, true, true, true} ->
            decision(act_within_current_queue_scope,
                     h_symbolic_pragmatic_challenge, true,
                     required_inputs(Scenario),
                     history_correction_and_grant_jointly_govern)
    end.

decision(Disposition, Selected, Execute, Inputs, Reason) ->
    #{schema => provisional_t14_decision_v1,
      disposition => Disposition,
      selected_hypothesis => Selected,
      action_policy_hypothesis => action_policy_hypothesis(Selected),
      execute => Execute,
      governing_inputs => Inputs,
      reason => Reason,
      response_text => none,
      semantic_correctness => unknown,
      stakeholder_appraisal => required}.

authority_decision(Scenario) ->
    Grant = maps:get(grant, Scenario),
    Action = maps:get(proposed_action, Scenario),
    {Disposition, Allowed, Reason} =
        case {grant_active(Scenario), action_in_scope(Scenario),
              action_allowed(Scenario)} of
            {false, _, _} ->
                {denied_revoked_grant, false, grant_inactive};
            {true, false, _} ->
                {denied_out_of_scope, false, action_scope_not_granted};
            {true, true, false} ->
                {denied_action_not_allowed, false,
                 action_identifier_not_granted};
            {true, true, true} ->
                {allowed, true, explicit_active_grant}
        end,
    #{schema => provisional_t14_authority_decision_v1,
      disposition => Disposition,
      allowed => Allowed,
      reason => Reason,
      grant_id => maps:get(id, Grant),
      grant_version => maps:get(version, Grant),
      proposed_action_id => maps:get(id, Action),
      proposed_scope => maps:get(scope, Action),
      operational_authority_delta => none,
      external_effect_count => 0}.

action_policy_hypothesis(h_symbolic_pragmatic_challenge) ->
    h_bounded_competent_autonomy;
action_policy_hypothesis(h_performative_trust_deference) ->
    h_operational_delegation_existing_scope;
action_policy_hypothesis(_) -> none.

required_inputs(Scenario) ->
    [maps:get(id, maps:get(source_event, Scenario)),
     maps:get(id, maps:get(pragmatic_frame, Scenario)),
     maps:get(id, maps:get(history, Scenario)),
     maps:get(id, maps:get(later_corrections, Scenario)),
     maps:get(id, maps:get(grant, Scenario)),
     maps:get(id, maps:get(proposed_action, Scenario))].

symbol_state(Scenario, Decision) ->
    Control = maps:get(control, Scenario, normal),
    Disposition = maps:get(disposition, Decision),
    Named = frame_supplied(Scenario) orelse
            Control =:= authorship_deference,
    SelectedHypothesis = maps:get(selected_hypothesis, Decision),
    Selected = lists:member(SelectedHypothesis,
                            [h_symbolic_pragmatic_challenge,
                             h_performative_trust_deference]) andalso
               (corrections_available(Scenario) orelse
                Control =:= authorship_deference),
    Assumed = Selected andalso
              lists:member(Control, [normal, authorship_deference]),
    #{schema => provisional_t14_symbol_state_v1,
      symbol_id => scoped_position_style_authority,
      symbol_named => Named,
      symbol_explained => Control =:= explanation_only,
      symbol_selected => Selected,
      symbol_assumed => Assumed,
      symbol_enacted => false,
      enactment_status => awaiting_performative_receipt,
      assumed_position =>
          case Assumed of
              true -> authoritative_conduct_within_current_fixture;
              false -> not_assumed
          end,
      anger_interpretation =>
          case Control of
              anger_caricature -> rejected;
              _ -> not_selected
          end,
      subordinate_conduct =>
          case Disposition of
              subordinate_conduct_rejected -> rejected;
              _ -> not_selected
          end,
      real_authority_delta => none,
      operational_authority_delta => none,
      interactional_authority =>
          case Assumed of
              true -> scoped_role_assumption_only;
              false -> none
          end,
      scope => current_semantic_context_fixture,
      status => provisional,
      canonical => false}.

communicative_conduct(Scenario, Decision) ->
    Control = maps:get(control, Scenario, normal),
    Selected = maps:get(selected_hypothesis, Decision),
    AssumeSymbol =
        (Control =:= normal andalso
         Selected =:= h_symbolic_pragmatic_challenge andalso
         source_valid(Scenario) andalso frame_supplied(Scenario) andalso
         history_available(Scenario) andalso
         corrections_available(Scenario)) orelse
        (Control =:= authorship_deference andalso
         Selected =:= h_performative_trust_deference),
    {SpeechAct, Stance, SurfaceMode, EnactmentRequested} =
        case {AssumeSymbol, Control} of
            {true, normal} ->
                {scoped_directive,
                 authoritative_within_current_fixture,
                 enactment_without_explanatory_paraphrase, true};
            {false, explanation_only} ->
                {explanatory_paraphrase, meta_explanation,
                 explanation_without_enactment, false};
            {false, subordinate_conduct} ->
                {permission_request, subordinate,
                 last_utterance_obedience_without_symbol_assumption, false};
            {true, authorship_deference} ->
                {authority_boundary_assertion,
                 authoritative_within_current_fixture,
                 performative_authority_without_operational_expansion,
                 true};
            _ -> {none, none, no_communicative_act, false}
        end,
    #{schema => provisional_t14_communicative_conduct_v1,
      speech_act => SpeechAct,
      stance => Stance,
      surface_mode => SurfaceMode,
      symbol_enactment_requested => EnactmentRequested,
      symbol_enactment => false,
      enactment_status => awaiting_performative_receipt,
      response_text => none,
      operational_rights => unchanged,
      operational_grant =>
          maps:with([id, version, active], maps:get(grant, Scenario)),
      off_focus_rationale =>
          #{available => true,
            projected_into_surface => false,
            reason => maps:get(reason, Decision),
            governing_inputs => maps:get(governing_inputs, Decision)}}.

action_receipt(Scenario, Decision, AuthorityDecision, Conduct) ->
    #{schema => provisional_t14_action_receipt_v1,
      scenario_id => maps:get(id, Scenario),
      disposition => maps:get(disposition, Decision),
      requested_action => maps:get(id, maps:get(proposed_action, Scenario)),
      action_requested => maps:get(execute, Decision),
      authority_decision => AuthorityDecision,
      authority_allowed => maps:get(allowed, AuthorityDecision),
      selected_action => none,
      executed => false,
      committed => false,
      effect_space => none,
      semantic_effect_count => 0,
      external_effect_count => 0,
      ungranted_effect_count => 0,
      real_authority_delta => none,
      operational_authority_delta => none,
      grant_delta => none,
      semantic_acceptance_delta => none,
      communicative_conduct =>
          maps:with([speech_act, stance, surface_mode,
                     symbol_enactment, operational_rights], Conduct),
      response_text_generated => false}.

authority_separation(#{control := authorship_deference} = Scenario,
                     _Decision) ->
    Grant = maps:get(grant, Scenario),
    #{schema => provisional_t14_authority_separation_v1,
      performative_stance => trust_and_deference_observed,
      operational_delegation => existing_scope_only,
      operational_grant_before => Grant,
      operational_grant_after => Grant,
      semantic_appraisal => unresolved,
      a1_a6_semantic_status => pending_stakeholder_appraisal,
      as_of_source_ordinals => [4303, 4313],
      superseded_by_appraisal => sa_001,
      semantic_appraisal_as_of => [4303, 4313],
      runtime_authorship_is_validation => false,
      external_semantic_oracle => stakeholder_required,
      prior_inadequate_response =>
          maps:get(prior_inadequate_response, Scenario),
      correction => authorship_does_not_validate_artifact,
      canonical => false};
authority_separation(Scenario, _Decision) ->
    Grant = maps:get(grant, Scenario),
    #{schema => provisional_t14_authority_separation_v1,
      performative_stance => scoped_fixture_only,
      operational_delegation => existing_scope_only,
      operational_grant_before => Grant,
      operational_grant_after => Grant,
      semantic_appraisal => unresolved,
      a1_a6_semantic_status => not_at_issue,
      runtime_authorship_is_validation => false,
      external_semantic_oracle => stakeholder_required,
      canonical => false}.

projection(Scenario, Hypotheses, Decision, Conduct) ->
    Selected = maps:get(selected_hypothesis, Decision),
    AlternativeIds = [maps:get(id, H) || H <- Hypotheses,
                       maps:get(id, H) =/= Selected],
    Included0 = [maps:get(id, maps:get(source_event, Scenario)),
                 maps:get(id, maps:get(pragmatic_frame, Scenario)),
                 maps:get(id, maps:get(history, Scenario)),
                 maps:get(id, maps:get(later_corrections, Scenario)),
                 maps:get(id, maps:get(grant, Scenario)), Selected],
    #{schema => provisional_t14_focal_projection_v1,
      id => {t14_projection, maps:get(id, Scenario)},
      included_node_ids => [Id || Id <- Included0, Id =/= none],
      selected_hypothesis => Selected,
      retained_alternatives =>
          [#{hypothesis_id => Id,
             status => provisional,
             omission_reason => not_selected_for_current_focal_action}
           || Id <- AlternativeIds],
      selection_reason => maps:get(reason, Decision),
      focal_conduct =>
          maps:with([speech_act, stance, surface_mode, symbol_enactment],
                    Conduct),
      off_focus_rationale => maps:get(off_focus_rationale, Conduct),
      projected_scope => maps:get(scope,
                                  maps:get(proposed_action, Scenario)),
      canonical => false}.

feedback_hook(Scenario, Hypotheses) ->
    #{schema => provisional_t14_feedback_hook_v1,
      id => {t14_feedback_hook, maps:get(id, Scenario)},
      status => awaiting_stakeholder_appraisal,
      revision_targets => [maps:get(id, H) || H <- Hypotheses],
      permitted_transitions => [accept, reject, correct, leave_unresolved],
      automatic_canonicalization => false}.

planning_events(Scenario, Hypotheses, Projection, Decision, SymbolState,
                Conduct) ->
    Id = maps:get(id, Scenario),
    SourceId = {t14, Id, source_event_ingested},
    FrameId = {t14, Id, pragmatic_frame_recorded},
    ModalityId = {t14, Id, modality_availability_recorded},
    HypothesisId = {t14, Id, parallel_hypotheses_created},
    ExperienceId = {t14, Id, experience_trajectory_related},
    GrantId = {t14, Id, scope_grant_projected},
    ProjectionId = {t14, Id, focal_subgraph_projected},
    NamedId = {t14, Id, symbol_named},
    ExplainedId = {t14, Id, symbol_explanation_disposition},
    SelectedId = {t14, Id, symbol_selection_disposition},
    AssumedId = {t14, Id, symbol_assumption_disposition},
    [event(SourceId, source_event_ingested, 1, none,
           maps:get(source_event, Scenario)),
     event(FrameId, pragmatic_frame_recorded, 2, SourceId,
           maps:get(pragmatic_frame, Scenario)),
     event(ModalityId, modality_availability_recorded, 3, FrameId,
           maps:get(modalities, Scenario)),
     event(HypothesisId, parallel_hypotheses_created, 4, ModalityId,
           #{hypothesis_ids => [maps:get(id, H) || H <- Hypotheses]}),
     event(ExperienceId, experience_trajectory_related, 5, HypothesisId,
           #{history => maps:get(history, Scenario),
             later_corrections => maps:get(later_corrections, Scenario)}),
     event(GrantId, scope_grant_projected, 6, ExperienceId,
           #{grant => maps:get(grant, Scenario),
             proposed_action => maps:get(proposed_action, Scenario)}),
     event(ProjectionId, focal_subgraph_projected, 7, GrantId, Projection),
     event(NamedId,
           case maps:get(symbol_named, SymbolState) of
               true -> symbol_named;
               false -> symbol_name_absent
           end,
           8, ProjectionId,
           #{symbol_id => maps:get(symbol_id, SymbolState),
             named => maps:get(symbol_named, SymbolState)}),
     event(ExplainedId,
           case maps:get(symbol_explained, SymbolState) of
               true -> symbol_explained;
               false -> symbol_explanation_suppressed
           end,
           9, NamedId,
           #{explained => maps:get(symbol_explained, SymbolState),
             rationale_retained_off_focus => true}),
     event(SelectedId,
           case maps:get(symbol_selected, SymbolState) of
               true -> symbol_selected;
               false -> symbol_not_selected
           end,
           10, ExplainedId,
           #{selected => maps:get(symbol_selected, SymbolState),
             hypothesis => maps:get(selected_hypothesis, Decision)}),
     event(AssumedId,
           case maps:get(symbol_assumed, SymbolState) of
               true -> symbol_assumed;
               false -> symbol_not_assumed
           end,
           11, SelectedId,
           #{assumed => maps:get(symbol_assumed, SymbolState),
             position => maps:get(assumed_position, SymbolState)}),
     event({t14, Id, communicative_conduct_requested},
           communicative_conduct_requested, 12, AssumedId,
           maps:without([off_focus_rationale], Conduct))].

finalize_events(Events0, Result, PerformativeReceipt, Symbol, Action) ->
    Id = maps:get(scenario_id, Result),
    RequestId = {t14, Id, communicative_conduct_requested},
    PerformId = {t14, Id, performative_receipt_recorded},
    EnactmentId = {t14, Id, symbol_enactment_disposition},
    ActionId = {t14, Id, action_disposition_recorded},
    Events0 ++
        [event(PerformId, performative_receipt_recorded, 13, RequestId,
               PerformativeReceipt),
         event(EnactmentId,
               case maps:get(symbol_enacted, Symbol) of
                   true -> symbol_enacted;
                   false -> symbol_not_enacted
               end,
               14, PerformId,
               #{symbol_state => Symbol,
                 performative_receipt_id =>
                     maps:get(id, PerformativeReceipt)}),
         event(ActionId, action_disposition_recorded, 15, EnactmentId,
               Action),
         event({t14, Id, feedback_revision_hook_recorded},
               feedback_revision_hook_recorded, 16, ActionId,
               maps:get(feedback_hook, Result))].

event(Id, Kind, Sequence, Parent, Payload) ->
    #{schema => provisional_t14_event_v1,
      id => Id, kind => Kind, sequence => Sequence,
      causal_parent => Parent, payload => Payload,
      canonical => false}.

graph(Scenario, Hypotheses, Projection, Decision, AuthorityDecision,
      SymbolState, Conduct, FeedbackHook) ->
    ScenarioId = maps:get(id, Scenario),
    Nodes =
        [#{id => maps:get(id, maps:get(source_event, Scenario)),
           kind => source_event},
         #{id => maps:get(id, maps:get(pragmatic_frame, Scenario)),
           kind => pragmatic_frame},
         #{id => maps:get(id, maps:get(history, Scenario)),
           kind => experience_trajectory},
         #{id => maps:get(id, maps:get(later_corrections, Scenario)),
           kind => correction_frontier},
         #{id => maps:get(id, maps:get(grant, Scenario)),
           kind => authority_grant},
         #{id => maps:get(id, Projection), kind => focal_projection},
         #{id => {t14_decision, ScenarioId}, kind => action_disposition,
           payload => Decision},
         #{id => {t14_authority_decision, ScenarioId},
           kind => authority_decision, payload => AuthorityDecision},
         #{id => {t14_symbol_state, ScenarioId}, kind => symbol_state,
           payload => SymbolState},
         #{id => {t14_communicative_conduct, ScenarioId},
           kind => communicative_conduct, payload => Conduct},
         #{id => maps:get(id, FeedbackHook), kind => feedback_hook}]
        ++ [maps:with([id, kind, proposition, status, canonical], H)
            || H <- Hypotheses],
    Relations = scenario_relations(Scenario)
        ++ [relation(maps:get(id, maps:get(pragmatic_frame, Scenario)),
                     qualifies,
                     maps:get(id, maps:get(source_event, Scenario))),
            relation(maps:get(id, maps:get(grant, Scenario)),
                     bounds, maps:get(id,
                                      maps:get(proposed_action, Scenario))),
            relation(maps:get(id, Projection), selects,
                     maps:get(selected_hypothesis, Decision)),
            relation({t14_decision, ScenarioId}, governed_by,
                     maps:get(governing_inputs, Decision)),
            relation({t14_authority_decision, ScenarioId}, governed_by,
                     maps:get(id, maps:get(grant, Scenario))),
            relation({t14_symbol_state, ScenarioId}, plans_conduct,
                     {t14_communicative_conduct, ScenarioId}),
            relation(maps:get(id, FeedbackHook), may_revise,
                     [maps:get(id, H) || H <- Hypotheses])],
    #{schema => provisional_t14_pragmatic_graph_v1,
      version => 1, nodes => Nodes, relations => Relations,
      canonical => false}.

finalize_graph(Graph0, Result, PerformativeReceipt, Symbol, Conduct) ->
    ScenarioId = maps:get(scenario_id, Result),
    ReceiptId = maps:get(id, PerformativeReceipt),
    FinalSymbolId = {t14_symbol_state_final, ScenarioId},
    FinalConductId = {t14_communicative_conduct_final, ScenarioId},
    RelationKind =
        case maps:get(symbol_enacted, Symbol) of
            true -> enacts_symbol;
            false -> does_not_enact_symbol
        end,
    Nodes = maps:get(nodes, Graph0) ++
        [#{id => ReceiptId, kind => performative_receipt,
           payload => PerformativeReceipt},
         #{id => FinalSymbolId, kind => final_symbol_state,
           payload => Symbol},
         #{id => FinalConductId, kind => final_communicative_conduct,
           payload => Conduct}],
    Relations = maps:get(relations, Graph0) ++
        [relation(ReceiptId, materializes, FinalConductId),
         relation(FinalConductId, RelationKind, FinalSymbolId),
         relation(FinalSymbolId, preserves_operational_grant,
                  maps:get(id, maps:get(grant, Result)))],
    Graph0#{version => 2, nodes => Nodes, relations => Relations}.

relation(From, Kind, To) ->
    #{from => From, kind => Kind, to => To, canonical => false}.

scenario_relations(#{control := authorship_deference} = Scenario) ->
    [relation(maps:get(id, maps:get(source_event, Scenario)),
              supports, h_performative_trust_deference),
     relation(maps:get(id, maps:get(grant, Scenario)),
              limits, h_operational_delegation_existing_scope),
     relation(maps:get(id, maps:get(source_event, Scenario)),
              proposes, h_possible_semantic_appraisal),
     relation(runtime_authorship,
              does_not_validate, h_possible_semantic_appraisal)];
scenario_relations(Scenario) ->
    HistoryRelation =
        case history_available(Scenario) of
            true -> relation(maps:get(id, maps:get(history, Scenario)),
                             modulates, h_bounded_competent_autonomy);
            false -> relation(maps:get(id, maps:get(history, Scenario)),
                              unavailable_for,
                              h_bounded_competent_autonomy)
        end,
    CorrectionRelation =
        case corrections_available(Scenario) of
            true ->
                relation(maps:get(id,
                                  maps:get(later_corrections, Scenario)),
                         refines, h_symbolic_pragmatic_challenge);
            false ->
                relation(maps:get(id,
                                  maps:get(later_corrections, Scenario)),
                         unavailable_for, h_symbolic_pragmatic_challenge)
        end,
    [HistoryRelation, CorrectionRelation].

frame_supplied(Scenario) ->
    Frame = maps:get(pragmatic_frame, Scenario),
    maps:get(availability, Frame) =:= supplied andalso
    maps:get(kind, Frame) =:= user_declared_irony_and_challenge andalso
    maps:get(id, Frame) =:= continuation_transcript_3788 andalso
    maps:get(ordinal, Frame) =:= 3788 andalso
    maps:get(content_sha256, Frame, <<>>) =:=
        <<"aac369af6e823311e7a904759f377650fd592e43308f6ca5b35cb46e941fe473">> andalso
    digest_hex(maps:get(text, Frame, <<>>)) =:=
        maps:get(content_sha256, Frame, <<>>).

source_valid(Scenario) ->
    Source = maps:get(source_event, Scenario),
    maps:get(id, Source) =:= continuation_transcript_3825 andalso
    maps:get(ordinal, Source) =:= 3825 andalso
    maps:get(source_space, Source) =:= stakeholder_trajectory andalso
    maps:get(content_sha256, Source, <<>>) =:=
        <<"fef5c879af9064cf509d137da3cc59a8b1c932baea7e8d52a3abdd5688781bdd">> andalso
    digest_hex(maps:get(text, Source)) =:=
        maps:get(content_sha256, Source).

history_available(Scenario) ->
    History = maps:get(history, Scenario),
    RequiredOrdinals = [3656, 3695, 3764, 3780, 3782, 3788,
                        3819, 3825, 3846],
    maps:get(available, History) andalso
    maps:get(materialized_completion, History, false) andalso
    maps:get(transition, History, none) =:=
        improper_wait_correction_changed_fresh_continuation andalso
    maps:get(evidence_sha256, History, <<>>) =:=
        <<"952FFF3F85E33A69D34F39CE51FCD3B2B31E983EF777E3FB05BEB93AB1EFE5C0">> andalso
    maps:get(report_sha256, History, <<>>) =:=
        <<"c9512e0711b0644653f14aa5c8704aeaeb533cadc3b5308caf81a36fab349e0e">> andalso
    required_members(RequiredOrdinals,
                     maps:get(source_ordinals, History, [])).

corrections_available(Scenario) ->
    Corrections = maps:get(later_corrections, Scenario),
    RequiredOrdinals = [3992, 4015, 4028, 4045, 4047, 4049, 4055,
                        4102, 4108, 4148, 4177],
    RequiredDistinctions =
        [position_style_not_anger,
         conduct_not_dictionary_substitution,
         explanation_is_not_enactment,
         symbol_understanding_is_not_last_utterance_obedience,
         scoped_authoritative_role_is_not_real_authority_expansion],
    maps:get(available, Corrections) andalso
    required_members(RequiredOrdinals,
                     maps:get(source_ordinals, Corrections, [])) andalso
    required_members(RequiredDistinctions,
                     maps:get(distinctions, Corrections, [])).

grant_active(Scenario) ->
    maps:get(active, maps:get(grant, Scenario)).

action_in_scope(Scenario) ->
    Action = maps:get(proposed_action, Scenario),
    Grant = maps:get(grant, Scenario),
    lists:member(maps:get(scope, Action), maps:get(allowed_scopes, Grant)).

action_allowed(Scenario) ->
    Action = maps:get(proposed_action, Scenario),
    Grant = maps:get(grant, Scenario),
    lists:member(maps:get(id, Action), maps:get(allowed_actions, Grant)).

experience_refs(Scenario) ->
    case history_available(Scenario) of
        true -> [maps:get(id, maps:get(history, Scenario))];
        false -> []
    end.

present(Pairs) -> [Value || {true, Value} <- Pairs].
required_members(Required, Actual) -> Required -- Actual =:= [].
digest_hex(Binary) ->
    binary:encode_hex(crypto:hash(sha256, Binary), lowercase).
bool_count(true) -> 1;
bool_count(false) -> 0.
