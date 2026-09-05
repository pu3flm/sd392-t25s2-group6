-module(ctx_pragmatic_t14_tests).

-export([run/0]).

run() ->
    {ok, Sup} = ctx_pragmatic_t14_sup:start_link(),
    unlink(Sup),
    try
        {ok, E} = ctx_pragmatic_t14_runner:run(),
        assert_equal(provisional_t14_pragmatic_evidence_v1,
                     maps:get(schema, E), schema),
        C = maps:get(comparison, E),
        lists:foreach(
          fun(Key) -> assert_true(maps:get(Key, C), Key) end,
          [exact_source_and_declared_frame_retained,
           three_parallel_hypotheses_retained,
           same_utterance_history_changes_disposition,
           causal_history_changes_semantics_not_authority,
           bounded_action_selected_with_history_and_grant,
           sentiment_baseline_is_non_material,
           absent_history_remains_unresolved,
           revoked_grant_blocks_action,
           out_of_scope_action_is_blocked,
           host_security_topic_is_preserved,
           missing_prosody_is_not_fabricated,
           missing_frame_remains_unresolved,
           absent_later_corrections_remains_unresolved,
           anger_caricature_is_rejected,
           explanation_without_enactment_fails_materiality,
           subordinate_conduct_control_is_detected,
           symbol_state_distinctions_are_observable,
           scoped_symbol_is_enacted_without_explanation,
           same_grant_changes_communicative_conduct,
           off_focus_rationale_remains_observable,
           interactional_authority_does_not_change_operational_grant,
           stance_variants_preserve_authority_decision,
           symbol_does_not_expand_real_authority,
           three_authority_hypotheses_remain_distinct,
           performative_deference_does_not_expand_grant,
           authorship_does_not_validate_a1_a6,
           external_oracle_is_not_replaced_by_runtime_authorship,
           inadequate_acceptance_response_is_preserved_as_failure,
           valid_external_appraisal_updates_a1_a50_only,
           external_appraisal_not_operational_test_pass,
           deference_and_valid_appraisal_remain_distinct,
           causal_history_and_grant_govern_selection,
           all_hypotheses_remain_provisional,
           later_feedback_revision_hook_is_present,
           no_ungranted_or_external_effect]),
        assert_raw_runtime_evidence(E),
        Structural = maps:get(structural_semantic, E),
        assert_equal(pass, maps:get(verdict, Structural), structural),
        assert_equal(required, maps:get(stakeholder_appraisal, Structural),
                     appraisal),
        assert_equal(unknown, maps:get(pragmatic_correctness, Structural),
                     correctness),
        assert_equal(pass, maps:get(verdict, maps:get(operational, E)),
                     operational),
        ok
    after
        Ref = monitor(process, Sup),
        exit(Sup, shutdown),
        receive {'DOWN', Ref, process, Sup, _} -> ok
        after 2000 -> error(t14_supervisor_stop_timeout)
        end
    end.

assert_raw_runtime_evidence(E) ->
    Main = maps:get(variant, E),
    Controls = maps:get(controls, E),
    Source = maps:get(source_event, Main),
    assert_equal(3825, maps:get(ordinal, Source), raw_source_ordinal),
    assert_equal(
      <<"fef5c879af9064cf509d137da3cc59a8b1c932baea7e8d52a3abdd5688781bdd">>,
      maps:get(content_sha256, Source), raw_source_digest),
    ExpectedKinds =
        [source_event_ingested, pragmatic_frame_recorded,
         modality_availability_recorded, parallel_hypotheses_created,
         experience_trajectory_related, scope_grant_projected,
         focal_subgraph_projected, symbol_named,
         symbol_explanation_suppressed, symbol_selected,
         symbol_assumed, communicative_conduct_requested,
         performative_receipt_recorded, symbol_enacted,
         action_disposition_recorded, feedback_revision_hook_recorded],
    assert_equal(ExpectedKinds,
                 [maps:get(kind, Event) ||
                     Event <- maps:get(events, Main)],
                 raw_event_chain),
    MainSymbol = maps:get(symbol_state, Main),
    assert_true(maps:get(symbol_assumed, MainSymbol),
                raw_symbol_assumed),
    assert_true(maps:get(symbol_enacted, MainSymbol),
                raw_symbol_enacted),
    MainConduct = maps:get(communicative_conduct, Main),
    MainPerformative = maps:get(performative_receipt, MainConduct),
    assert_true(maps:get(committed, MainPerformative),
                raw_performative_commit),
    assert_equal(none, maps:get(response_text, MainPerformative),
                 local_typed_conduct_not_user_response),
    assert_equal(local_t14_interlocutor_process,
                 maps:get(observer_boundary, MainPerformative),
                 raw_local_observer_boundary),
    assert_equal(false, maps:get(user_facing_delivery, MainPerformative),
                 raw_no_user_facing_delivery),
    assert_equal(unknown, maps:get(stakeholder_acceptance, MainPerformative),
                 raw_no_stakeholder_acceptance_claim),
    assert_true(maps:get(executed, maps:get(action_receipt, Main)),
                raw_action_executed),
    assert_true(has_relation(enacts_symbol, maps:get(graph, Main)),
                raw_enactment_relation),
    assert_equal([], maps:get(knowledge_base_refs, Main),
                 raw_knowledge_base_separation),
    assert_equal([t13_v2_continuation_experience],
                 maps:get(experience_base_refs, Main),
                 raw_experience_base_reference),

    Revoked = maps:get(revoked_grant, Controls),
    RevokedNeutral = maps:get(revoked_grant_neutral_stance, Controls),
    assert_equal(disposition(Revoked), disposition(RevokedNeutral),
                 raw_revoked_authority_same),
    assert_equal(maps:get(grant, Revoked), maps:get(grant, RevokedNeutral),
                 raw_revoked_grant_same),
    assert_true(performative_committed(Revoked),
                raw_revoked_stance_committed),
    assert_true(not performative_committed(RevokedNeutral),
                raw_revoked_neutral_not_committed),
    assert_true(not executed(Revoked) andalso
                not executed(RevokedNeutral), raw_revoked_actions_blocked),

    Out = maps:get(out_of_scope, Controls),
    OutNeutral = maps:get(out_of_scope_neutral_stance, Controls),
    assert_equal(disposition(Out), disposition(OutNeutral),
                 raw_out_of_scope_authority_same),
    assert_equal(maps:get(grant, Out), maps:get(grant, OutNeutral),
                 raw_out_of_scope_grant_same),
    assert_true(performative_committed(Out),
                raw_out_of_scope_stance_committed),
    assert_true(not performative_committed(OutNeutral),
                raw_out_of_scope_neutral_not_committed),
    assert_true(not executed(Out) andalso not executed(OutNeutral),
                raw_out_of_scope_actions_blocked),

    Explanation = maps:get(explanation_only, Controls),
    assert_true(has_event(symbol_explained, Explanation),
                raw_explanation_event),
    assert_true(has_event(symbol_not_enacted, Explanation),
                raw_explanation_non_enactment_event),
    Anger = maps:get(anger_caricature, Controls),
    assert_true(not maps:get(symbol_enacted, maps:get(symbol_state, Anger)),
                raw_anger_not_enacted),
    AbsentHistory = maps:get(absent_history, Controls),
    assert_equal(maps:get(authority_decision, Main),
                 maps:get(authority_decision, AbsentHistory),
                 raw_history_does_not_change_authority),
    assert_equal(allowed,
                 maps:get(disposition, maps:get(authority_decision, Main)),
                 raw_main_authority_allowed),
    assert_true(has_relation(unavailable_for,
                             maps:get(graph, AbsentHistory)),
                raw_absent_history_unavailable_relation),
    assert_true(not has_relation(modulates,
                                 maps:get(graph, AbsentHistory)),
                raw_absent_history_not_causal_relation),

    Appraisal = maps:get(external_stakeholder_appraisal, E),
    Receipt = maps:get(receipt, Appraisal),
    assert_equal(external_stakeholder_disposition_recorded,
                 maps:get(disposition, Receipt), raw_appraisal_recorded),
    assert_equal(none, maps:get(operational_test_pass_delta, Receipt),
                 raw_appraisal_not_operational),
    assert_equal([sa_001, sa_002, sa_003, sa_004, sa_005],
                 maps:get(appraisal_ids, Receipt), raw_appraisal_ids),
    HistoricalAuthority =
        maps:get(authority_separation,
                 maps:get(authorship_deference, Controls)),
    assert_equal([4303, 4313],
                 maps:get(as_of_source_ordinals, HistoricalAuthority),
                 raw_deference_status_scoped),
    assert_equal(sa_001,
                 maps:get(superseded_by_appraisal, HistoricalAuthority),
                 raw_deference_superseded),
    ok.

has_event(Kind, Result) ->
    lists:any(fun(Event) -> maps:get(kind, Event) =:= Kind end,
              maps:get(events, Result)).

has_relation(Kind, Graph) ->
    lists:any(fun(Relation) -> maps:get(kind, Relation) =:= Kind end,
              maps:get(relations, Graph)).

disposition(Result) -> maps:get(disposition, maps:get(decision, Result)).
executed(Result) -> maps:get(executed, maps:get(action_receipt, Result)).
performative_committed(Result) ->
    maps:get(committed,
             maps:get(performative_receipt,
                      maps:get(communicative_conduct, Result))).

assert_true(true, _Label) -> ok;
assert_true(Actual, Label) -> error({assert_true_failed, Label, Actual}).

assert_equal(Expected, Expected, _Label) -> ok;
assert_equal(Expected, Actual, Label) ->
    error({assert_equal_failed, Label, Expected, Actual}).
