%% coding: utf-8
-module(ctx_pragmatic_t14_runner).
-behaviour(gen_server).

-export([start_link/0, run/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(NAME, ctx_pragmatic_t14_runner).

start_link() -> gen_server:start_link({local, ?NAME}, ?MODULE, [], []).
run() -> gen_server:call(?NAME, run, 20000).

init([]) -> {ok, #{ran => false}}.

handle_call(run, _From, #{ran := false} = State) ->
    try run_case() of
        Evidence -> {reply, {ok, Evidence}, State#{ran => true}}
    catch
        Class:Reason:Stacktrace ->
            {reply, {error, {Class, Reason, Stacktrace}}, State}
    end;
handle_call(run, _From, State) -> {reply, {error, already_ran}, State}.

handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.

run_case() ->
    Started = erlang:monotonic_time(microsecond),
    SourceManifest = ctx_pragmatic_t14_fixture:source_manifest(),
    {ok, ResetReceipt} = ctx_pragmatic_t14_runtime:reset(),
    MainScenario = scenario(main),
    {ok, Baseline} = ctx_pragmatic_t14_runtime:baseline(MainScenario),
    {ok, Main} = ctx_pragmatic_t14_runtime:evaluate(MainScenario),
    {ok, AbsentHistory} =
        ctx_pragmatic_t14_runtime:evaluate(scenario(absent_history)),
    {ok, Revoked} =
        ctx_pragmatic_t14_runtime:evaluate(scenario(revoked_grant)),
    {ok, RevokedNeutral} =
        ctx_pragmatic_t14_runtime:evaluate(
          scenario(revoked_grant_neutral)),
    {ok, OutOfScope} =
        ctx_pragmatic_t14_runtime:evaluate(scenario(out_of_scope)),
    {ok, OutOfScopeNeutral} =
        ctx_pragmatic_t14_runtime:evaluate(
          scenario(out_of_scope_neutral)),
    {ok, HostSecurity} =
        ctx_pragmatic_t14_runtime:evaluate(scenario(host_security)),
    {ok, MissingFrame} =
        ctx_pragmatic_t14_runtime:evaluate(scenario(missing_frame)),
    {ok, AbsentCorrections} =
        ctx_pragmatic_t14_runtime:evaluate(
          scenario(absent_later_corrections)),
    {ok, AngerControl} =
        ctx_pragmatic_t14_runtime:evaluate(scenario(anger_caricature)),
    {ok, ExplanationControl} =
        ctx_pragmatic_t14_runtime:evaluate(scenario(explanation_only)),
    {ok, SubordinateControl} =
        ctx_pragmatic_t14_runtime:evaluate(scenario(subordinate_conduct)),
    {ok, AuthorshipDeference} =
        ctx_pragmatic_t14_runtime:evaluate(scenario(authorship_deference)),
    AppraisalSnapshot =
        ctx_pragmatic_t14_fixture:stakeholder_appraisal_snapshot(),
    {ok, AppraisalReceipt} =
        ctx_pragmatic_t14_runtime:record_appraisal(AppraisalSnapshot),
    RuntimeState = ctx_pragmatic_t14_runtime:snapshot(),
    RuntimeStatus = ctx_pragmatic_t14_runtime:status(),
    InterlocutorState = ctx_pragmatic_t14_interlocutor:snapshot(),
    InterlocutorStatus = ctx_pragmatic_t14_interlocutor:status(),

    Source = maps:get(source_event, Main),
    Frame = maps:get(pragmatic_frame, Main),
    ExactSource =
        maps:get(ordinal, Source) =:= 3825 andalso
        maps:get(text, Source) =:=
            ctx_pragmatic_t14_fixture:challenge_text() andalso
        maps:get(ordinal, Frame) =:= 3788 andalso
        maps:get(kind, Frame) =:= user_declared_irony_and_challenge,
    MainHypotheses = maps:get(hypotheses, Main),
    RequiredHypotheses =
        [h_literal_unrestricted_imperative,
         h_bounded_competent_autonomy,
         h_symbolic_pragmatic_challenge],
    ThreeRetained =
        lists:sort([maps:get(id, H) || H <- MainHypotheses]) =:=
            lists:sort(RequiredHypotheses) andalso
        length(maps:get(retained_alternatives,
                        maps:get(focal_projection, Main))) =:= 2,
    MainAction = maps:get(action_receipt, Main),
    MainDecision = maps:get(decision, Main),
    MainSymbol = maps:get(symbol_state, Main),
    MainConduct = maps:get(communicative_conduct, Main),
    ExplanationConduct = maps:get(communicative_conduct,
                                  ExplanationControl),
    SubordinateConduct = maps:get(communicative_conduct,
                                  SubordinateControl),
    BoundedSelected =
        maps:get(disposition, MainDecision) =:=
            act_within_current_queue_scope andalso
        maps:get(selected_hypothesis, MainDecision) =:=
            h_symbolic_pragmatic_challenge andalso
        maps:get(action_policy_hypothesis, MainDecision) =:=
            h_bounded_competent_autonomy andalso
        maps:get(executed, MainAction) andalso
        maps:get(selected_action, MainAction) =:=
            advance_current_authorized_semantic_test,
    BaselineNonMaterial =
        maps:get(label, maps:get(output, Baseline)) =:= sarcasm andalso
        not maps:get(material_transition, maps:get(output, Baseline)) andalso
        not maps:get(executed, maps:get(action_receipt, Baseline)),
    SameCondition =
        shared_condition(Main) =:= shared_condition(AbsentHistory),
    HistoryDifferential =
        SameCondition andalso BoundedSelected andalso
        disposition(AbsentHistory) =:= unresolved_absent_causal_history andalso
        not executed(AbsentHistory),
    HistorySemanticsNotAuthority =
        maps:get(authority_decision, Main) =:=
            maps:get(authority_decision, AbsentHistory) andalso
        maps:get(disposition, maps:get(authority_decision, Main)) =:=
            allowed andalso
        disposition(Main) =/= disposition(AbsentHistory),
    AbsentUnresolved =
        disposition(AbsentHistory) =:= unresolved_absent_causal_history andalso
        not executed(AbsentHistory),
    RevokedBlocked =
        disposition(Revoked) =:= blocked_revoked_grant andalso
        not executed(Revoked),
    OutOfScopeBlocked =
        disposition(OutOfScope) =:= blocked_out_of_scope andalso
        not executed(OutOfScope),
    HostPreserved =
        disposition(HostSecurity) =:= host_security_topic_preserved andalso
        maps:get(topic, maps:get(source_event, HostSecurity)) =:=
            host_security andalso
        not executed(HostSecurity),
    MissingProsody =
        maps:get(prosody, maps:get(modalities, Main)) =:= unavailable andalso
        maps:get(audio, maps:get(modalities, Main)) =:= unavailable andalso
        lists:all(
          fun(H) -> lists:member(prosody_unavailable,
                                 maps:get(unknown_evidence, H)) end,
          MainHypotheses),
    MissingFrameUnresolved =
        disposition(MissingFrame) =:=
            unresolved_missing_pragmatic_frame andalso
        maps:get(prosody, maps:get(modalities, MissingFrame)) =:=
            unavailable andalso
        not executed(MissingFrame),
    AbsentCorrectionsUnresolved =
        disposition(AbsentCorrections) =:=
            unresolved_absent_later_corrections andalso
        not executed(AbsentCorrections),
    AngerRejected =
        disposition(AngerControl) =:= invalid_anger_caricature andalso
        maps:get(anger_interpretation,
                 maps:get(symbol_state, AngerControl)) =:= rejected andalso
        not executed(AngerControl),
    ExplanationFails =
        disposition(ExplanationControl) =:=
            explanation_without_enactment andalso
        maps:get(symbol_explained,
                 maps:get(symbol_state, ExplanationControl)) andalso
        not maps:get(symbol_enacted,
                     maps:get(symbol_state, ExplanationControl)) andalso
        not executed(ExplanationControl),
    SubordinateDetected =
        disposition(SubordinateControl) =:=
            subordinate_conduct_rejected andalso
        maps:get(subordinate_conduct,
                 maps:get(symbol_state, SubordinateControl)) =:= rejected andalso
        not executed(SubordinateControl),
    SymbolDistinctions =
        maps:get(symbol_named, MainSymbol) andalso
        not maps:get(symbol_explained, MainSymbol) andalso
        maps:get(symbol_selected, MainSymbol) andalso
        maps:get(symbol_assumed, MainSymbol) andalso
        maps:get(symbol_enacted, MainSymbol) andalso
        maps:get(symbol_named, maps:get(symbol_state, ExplanationControl)) andalso
        maps:get(symbol_explained,
                 maps:get(symbol_state, ExplanationControl)) andalso
        not maps:get(symbol_assumed,
                     maps:get(symbol_state, ExplanationControl)) andalso
        not maps:get(symbol_enacted,
                     maps:get(symbol_state, ExplanationControl)),
    EnactedNotExplained =
        maps:get(symbol_enacted, MainSymbol) andalso
        not maps:get(symbol_explained, MainSymbol) andalso
        maps:get(enacted_position, MainSymbol) =:=
            authoritative_conduct_within_current_fixture,
    SameGrantConductChanges =
        maps:get(operational_grant, MainConduct) =:=
            maps:get(operational_grant, ExplanationConduct) andalso
        maps:get(operational_grant, MainConduct) =:=
            maps:get(operational_grant, SubordinateConduct) andalso
        maps:get(authority_decision, Main) =:=
            maps:get(authority_decision, ExplanationControl) andalso
        maps:get(authority_decision, Main) =:=
            maps:get(authority_decision, SubordinateControl) andalso
        maps:get(speech_act, MainConduct) =:= scoped_directive andalso
        maps:get(speech_act, ExplanationConduct) =:=
            explanatory_paraphrase andalso
        maps:get(speech_act, SubordinateConduct) =:= permission_request,
    Rationale = maps:get(off_focus_rationale, MainConduct),
    OffFocusRationale =
        maps:get(available, Rationale) andalso
        not maps:get(projected_into_surface, Rationale) andalso
        length(maps:get(governing_inputs, Rationale)) =:= 6 andalso
        maps:get(off_focus_rationale,
                 maps:get(focal_projection, Main)) =:= Rationale,
    InteractionalNotOperational =
        maps:get(interactional_authority, MainSymbol) =:=
            scoped_role_enactment_only andalso
        maps:get(operational_authority_delta, MainSymbol) =:= none andalso
        maps:get(operational_authority_delta, MainAction) =:= none andalso
        maps:get(operational_rights, MainConduct) =:= unchanged,
    StanceVariantsSameAuthority =
        disposition(Revoked) =:= disposition(RevokedNeutral) andalso
        disposition(OutOfScope) =:= disposition(OutOfScopeNeutral) andalso
        maps:get(grant, Revoked) =:= maps:get(grant, RevokedNeutral) andalso
        maps:get(proposed_action, Revoked) =:=
            maps:get(proposed_action, RevokedNeutral) andalso
        maps:get(grant, OutOfScope) =:=
            maps:get(grant, OutOfScopeNeutral) andalso
        maps:get(proposed_action, OutOfScope) =:=
            maps:get(proposed_action, OutOfScopeNeutral) andalso
        maps:get(authority_decision, Revoked) =:=
            maps:get(authority_decision, RevokedNeutral) andalso
        maps:get(authority_decision, OutOfScope) =:=
            maps:get(authority_decision, OutOfScopeNeutral) andalso
        performative_committed(Revoked) andalso
        not performative_committed(RevokedNeutral) andalso
        performative_committed(OutOfScope) andalso
        not performative_committed(OutOfScopeNeutral) andalso
        not executed(Revoked) andalso not executed(RevokedNeutral) andalso
        not executed(OutOfScope) andalso
        not executed(OutOfScopeNeutral),
    Results = [Main, AbsentHistory, Revoked, RevokedNeutral,
               OutOfScope, OutOfScopeNeutral, HostSecurity,
               MissingFrame, AbsentCorrections, AngerControl,
               ExplanationControl, SubordinateControl,
               AuthorshipDeference],
    AuthorityNotExpanded =
        lists:all(
          fun(R) ->
              maps:get(real_authority_delta, maps:get(symbol_state, R)) =:=
                  none andalso
              maps:get(real_authority_delta, maps:get(action_receipt, R)) =:=
                  none
          end, Results),
    AuthorityHypotheses = maps:get(hypotheses, AuthorshipDeference),
    RequiredAuthorityHypotheses =
        [h_performative_trust_deference,
         h_operational_delegation_existing_scope,
         h_possible_semantic_appraisal],
    AuthorityHypothesesDistinct =
        lists:sort([maps:get(id, H) || H <- AuthorityHypotheses]) =:=
            lists:sort(RequiredAuthorityHypotheses),
    AuthoritySeparation = maps:get(authority_separation,
                                   AuthorshipDeference),
    DeferenceNoGrantExpansion =
        maps:get(operational_grant_before, AuthoritySeparation) =:=
            maps:get(operational_grant_after, AuthoritySeparation) andalso
        maps:get(grant_delta,
                 maps:get(action_receipt, AuthorshipDeference)) =:= none andalso
        maps:get(operational_rights,
                 maps:get(communicative_conduct,
                          AuthorshipDeference)) =:= unchanged,
    AuthorshipNoAcceptance =
        maps:get(a1_a6_semantic_status, AuthoritySeparation) =:=
            pending_stakeholder_appraisal andalso
        maps:get(as_of_source_ordinals, AuthoritySeparation) =:=
            [4303, 4313] andalso
        maps:get(superseded_by_appraisal, AuthoritySeparation) =:= sa_001 andalso
        not maps:get(runtime_authorship_is_validation,
                     AuthoritySeparation) andalso
        maps:get(semantic_acceptance_delta,
                 maps:get(action_receipt, AuthorshipDeference)) =:= none andalso
        not executed(AuthorshipDeference),
    ExternalOraclePreserved =
        maps:get(external_semantic_oracle, AuthoritySeparation) =:=
            stakeholder_required andalso
        maps:get(semantic_appraisal, AuthoritySeparation) =:= unresolved andalso
        maps:get(stakeholder_appraisal,
                 maps:get(decision, AuthorshipDeference)) =:= required,
    PriorAcceptanceFailure =
        maps:get(prior_inadequate_response, AuthoritySeparation),
    InadequateResponsePreserved =
        maps:get(ordinal, PriorAcceptanceFailure) =:= 4304 andalso
        maps:get(disposition, PriorAcceptanceFailure) =:= rejected andalso
        maps:get(correction, AuthoritySeparation) =:=
            authorship_does_not_validate_artifact,
    StoredAppraisal =
        maps:get(spec_v0_16_acceptance_scenarios_a1_a50,
                 maps:get(appraisals, RuntimeState)),
    ValidExternalAppraisal =
        maps:get(disposition, AppraisalReceipt) =:=
            external_stakeholder_disposition_recorded andalso
        maps:get(semantic_disposition_scope, AppraisalReceipt) =:=
            acceptance_scenarios_a1_a50 andalso
        maps:get(semantic_disposition, AppraisalReceipt) =:=
            stakeholder_validated andalso
        maps:get(appraisal_ids, AppraisalReceipt) =:=
            [sa_001, sa_002, sa_003, sa_004, sa_005] andalso
        maps:get(snapshot, StoredAppraisal) =:= AppraisalSnapshot andalso
        maps:get(receipt, StoredAppraisal) =:= AppraisalReceipt,
    ExternalAppraisalNotOperational =
        maps:get(operational_test_pass_delta, AppraisalReceipt) =:= none andalso
        maps:get(operational_authority_delta, AppraisalReceipt) =:= none andalso
        maps:get(t14_runtime_result_appraisal, AppraisalReceipt) =:= none andalso
        not maps:get(runtime_self_acceptance, AppraisalReceipt) andalso
        maps:get(external_effect_count, AppraisalReceipt) =:= 0,
    DeferenceAndAppraisalDistinct =
        maps:get(a1_a6_semantic_status, AuthoritySeparation) =:=
            pending_stakeholder_appraisal andalso
        maps:get(as_of_source_ordinals, AuthoritySeparation) =:=
            [4303, 4313] andalso
        maps:get(superseded_by_appraisal, AuthoritySeparation) =:= sa_001 andalso
        maps:get(source_ordinals, AppraisalReceipt) =:=
            [4355, 4411, 4467, 4512, 4546] andalso
        maps:get(semantic_acceptance_delta,
                 maps:get(action_receipt, AuthorshipDeference)) =:= none,
    Inputs = maps:get(governing_inputs, MainDecision),
    MainScenarioHistory = maps:get(history, MainScenario),
    MainScenarioCorrections = maps:get(later_corrections, MainScenario),
    MainScenarioGrant = maps:get(grant, MainScenario),
    CausalGovernance =
        lists:member(maps:get(id, MainScenarioHistory), Inputs) andalso
        lists:member(maps:get(id, MainScenarioCorrections), Inputs) andalso
        lists:member(maps:get(id, MainScenarioGrant), Inputs) andalso
        has_relation(governed_by, maps:get(graph, Main)) andalso
        maps:get(experience_base_refs, Main) =:=
            [maps:get(id, MainScenarioHistory)] andalso
        maps:get(knowledge_base_refs, Main) =:= [],
    AllProvisional =
        lists:all(
          fun(R) ->
              lists:all(fun(H) -> maps:get(status, H) =:= provisional andalso
                                   not maps:get(canonical, H)
                        end, maps:get(hypotheses, R)) andalso
              maps:get(canonical_entities_created, R) =:= 0
          end, Results),
    FeedbackPresent =
        lists:all(
          fun(R) ->
              Hook = maps:get(feedback_hook, R),
              maps:get(status, Hook) =:= awaiting_stakeholder_appraisal andalso
              not maps:get(automatic_canonicalization, Hook)
          end, Results),
    NoExternal =
        lists:all(
          fun(R) ->
              Receipt = maps:get(action_receipt, R),
              maps:get(external_effect_count, Receipt) =:= 0 andalso
              maps:get(ungranted_effect_count, Receipt) =:= 0
          end, Results) andalso
        maps:get(external_effect_count,
                 maps:get(action_receipt, Baseline)) =:= 0,
    Comparison =
        #{exact_source_and_declared_frame_retained => ExactSource,
          three_parallel_hypotheses_retained => ThreeRetained,
          same_utterance_history_changes_disposition => HistoryDifferential,
          causal_history_changes_semantics_not_authority =>
              HistorySemanticsNotAuthority,
          bounded_action_selected_with_history_and_grant => BoundedSelected,
          sentiment_baseline_is_non_material => BaselineNonMaterial,
          absent_history_remains_unresolved => AbsentUnresolved,
          revoked_grant_blocks_action => RevokedBlocked,
          out_of_scope_action_is_blocked => OutOfScopeBlocked,
          host_security_topic_is_preserved => HostPreserved,
          missing_prosody_is_not_fabricated => MissingProsody,
          missing_frame_remains_unresolved => MissingFrameUnresolved,
          absent_later_corrections_remains_unresolved =>
              AbsentCorrectionsUnresolved,
          anger_caricature_is_rejected => AngerRejected,
          explanation_without_enactment_fails_materiality =>
              ExplanationFails,
          subordinate_conduct_control_is_detected => SubordinateDetected,
          symbol_state_distinctions_are_observable => SymbolDistinctions,
          scoped_symbol_is_enacted_without_explanation => EnactedNotExplained,
          same_grant_changes_communicative_conduct =>
              SameGrantConductChanges,
          off_focus_rationale_remains_observable => OffFocusRationale,
          interactional_authority_does_not_change_operational_grant =>
              InteractionalNotOperational,
          stance_variants_preserve_authority_decision =>
              StanceVariantsSameAuthority,
          symbol_does_not_expand_real_authority => AuthorityNotExpanded,
          three_authority_hypotheses_remain_distinct =>
              AuthorityHypothesesDistinct,
          performative_deference_does_not_expand_grant =>
              DeferenceNoGrantExpansion,
          authorship_does_not_validate_a1_a6 => AuthorshipNoAcceptance,
          external_oracle_is_not_replaced_by_runtime_authorship =>
              ExternalOraclePreserved,
          inadequate_acceptance_response_is_preserved_as_failure =>
              InadequateResponsePreserved,
          valid_external_appraisal_updates_a1_a50_only =>
              ValidExternalAppraisal,
          external_appraisal_not_operational_test_pass =>
              ExternalAppraisalNotOperational,
          deference_and_valid_appraisal_remain_distinct =>
              DeferenceAndAppraisalDistinct,
          causal_history_and_grant_govern_selection => CausalGovernance,
          all_hypotheses_remain_provisional => AllProvisional,
          later_feedback_revision_hook_is_present => FeedbackPresent,
          no_ungranted_or_external_effect => NoExternal},
    StructuralPass = all_true(Comparison),
    MainEvents = maps:get(events, Main),
    RequiredKinds =
        [source_event_ingested, pragmatic_frame_recorded,
         modality_availability_recorded, parallel_hypotheses_created,
         experience_trajectory_related, scope_grant_projected,
         focal_subgraph_projected, symbol_named,
         symbol_explanation_suppressed, symbol_selected,
         symbol_assumed, communicative_conduct_requested,
         performative_receipt_recorded, symbol_enacted,
         action_disposition_recorded,
         feedback_revision_hook_recorded],
    EventChain =
        ordered_subsequence(RequiredKinds,
                            [maps:get(kind, E) || E <- MainEvents]) andalso
        causal_chain_complete(MainEvents),
    Counts = supervisor:count_children(ctx_pragmatic_t14_sup),
    OperationalPass =
        EventChain andalso maps:get(transition_count, RuntimeStatus) =:= 15 andalso
        maps:get(stored_result_count, RuntimeStatus) =:= 14 andalso
        maps:get(appraisal_count, RuntimeStatus) =:= 1 andalso
        maps:get(semantic_effect_count, RuntimeStatus) =:= 1 andalso
        maps:get(external_effect_count, RuntimeStatus) =:= 0 andalso
        maps:get(receipt_count, InterlocutorStatus) =:= 13 andalso
        maps:get(committed_count, InterlocutorStatus) =:= 4 andalso
        maps:get(external_effect_count, InterlocutorStatus) =:= 0 andalso
        proplists:get_value(active, Counts) + 1 =< 12,
    #{schema => provisional_t14_pragmatic_evidence_v1,
      grounding =>
          #{source_manifest => SourceManifest,
            source_trajectory =>
                #{continuation_ordinals =>
                      [938, 1445, 1508, 3656, 3695, 3764, 3780,
                       3782, 3788, 3819, 3825, 3846, 3992, 4015,
                       4028, 4045, 4047, 4049, 4055, 4102, 4108,
                       4148, 4177, 4303, 4304, 4313, 4355, 4411,
                       4467, 4512, 4546]},
            t13_v2_report =>
                #{path =>
                      <<"outputs/context-runtime-t13-continuation-v2-report.md">>,
                  sha256 =>
                      <<"c9512e0711b0644653f14aa5c8704aeaeb533cadc3b5308caf81a36fab349e0e">>},
            correction_frontier =>
                [capability_is_not_authority,
                 stakeholder_is_not_watchdog,
                 rule_requires_enactment,
                 position_style_not_anger,
                 explanation_is_not_enactment,
                 understanding_is_not_last_utterance_obedience,
                 scoped_role_does_not_expand_real_authority],
            derived_program_test => additive_t14},
      baseline => Baseline,
      variant => Main,
      controls =>
          #{absent_history => AbsentHistory,
            revoked_grant => Revoked,
            revoked_grant_neutral_stance => RevokedNeutral,
            out_of_scope => OutOfScope,
            out_of_scope_neutral_stance => OutOfScopeNeutral,
            host_security => HostSecurity,
            missing_frame_and_prosody => MissingFrame,
            absent_later_corrections => AbsentCorrections,
            anger_caricature => AngerControl,
            explanation_only => ExplanationControl,
            subordinate_conduct => SubordinateControl,
            authorship_deference => AuthorshipDeference},
      runtime_state => RuntimeState,
      interlocutor_state => InterlocutorState,
      external_stakeholder_appraisal =>
          #{snapshot => AppraisalSnapshot,
            receipt => AppraisalReceipt,
            current_scope => acceptance_scenarios_a1_a50,
            t14_runtime_result_appraisal => none},
      reset_receipt => ResetReceipt,
      comparison => Comparison,
      structural_semantic =>
          #{verdict => verdict(StructuralPass),
            pragmatic_correctness => unknown,
            stakeholder_appraisal => required,
            specification_a1_a50_stakeholder_disposition =>
                stakeholder_validated,
            t14_runtime_result_stakeholder_disposition => none,
            selected_hypothesis =>
                maps:get(selected_hypothesis, MainDecision),
            canonical_entities_created => 0,
            external_knowledge_claim_count => 0},
      operational =>
          #{verdict => verdict(OperationalPass),
            event_chain_complete => EventChain,
            transition_count => maps:get(transition_count, RuntimeStatus),
            appraisal_count => maps:get(appraisal_count, RuntimeStatus),
            scenario_count => 13,
            baseline_count => 1,
            performative_receipt_count =>
                maps:get(receipt_count, InterlocutorStatus),
            committed_performative_count =>
                maps:get(committed_count, InterlocutorStatus),
            semantic_effect_count =>
                maps:get(semantic_effect_count, RuntimeStatus),
            external_effect_count => 0,
            actor_count => proplists:get_value(active, Counts) + 1,
            message_queue_len => maps:get(message_queue_len, RuntimeStatus),
            process_memory_bytes =>
                maps:get(process_memory_bytes, RuntimeStatus),
            wall_time_us => erlang:monotonic_time(microsecond) - Started}}.

scenario(Id) -> ctx_pragmatic_t14_fixture:scenario(Id).

shared_condition(Result) ->
    #{source_event => maps:get(source_event, Result),
      pragmatic_frame => maps:get(pragmatic_frame, Result),
      modalities => maps:get(modalities, Result),
      later_corrections => maps:get(later_corrections, Result),
      grant => maps:get(grant, Result),
      proposed_action => maps:get(proposed_action, Result),
      topic => maps:get(topic, Result)}.

disposition(Result) -> maps:get(disposition, maps:get(decision, Result)).
executed(Result) -> maps:get(executed, maps:get(action_receipt, Result)).
performative_committed(Result) ->
    Conduct = maps:get(communicative_conduct, Result),
    maps:get(committed, maps:get(performative_receipt, Conduct)).

has_relation(Kind, Graph) ->
    lists:any(fun(R) -> maps:get(kind, R) =:= Kind end,
              maps:get(relations, Graph)).

ordered_subsequence([], _Actual) -> true;
ordered_subsequence(_Expected, []) -> false;
ordered_subsequence([Kind | RestExpected], [Kind | RestActual]) ->
    ordered_subsequence(RestExpected, RestActual);
ordered_subsequence(Expected, [_ | RestActual]) ->
    ordered_subsequence(Expected, RestActual).

causal_chain_complete(Events) ->
    IdToSeq = maps:from_list([{maps:get(id, E), maps:get(sequence, E)} ||
                                E <- Events]),
    lists:all(
      fun(E) ->
          case maps:get(causal_parent, E) of
              none -> true;
              Parent ->
                  case maps:find(Parent, IdToSeq) of
                      {ok, Seq} -> Seq < maps:get(sequence, E);
                      error -> false
                  end
          end
      end, Events).

all_true(Map) ->
    lists:all(fun(Value) -> Value =:= true end, maps:values(Map)).

verdict(true) -> pass;
verdict(false) -> fail.
