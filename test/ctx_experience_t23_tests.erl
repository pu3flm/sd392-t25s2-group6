-module(ctx_experience_t23_tests).

-export([run/0]).

run() ->
    supervised_t2_t3_test(),
    ok.

supervised_t2_t3_test() ->
    {ok, Sup} = ctx_experience_t23_sup:start_link(),
    unlink(Sup),
    try
        {ok, T2} = ctx_experience_t23:run_t2(),
        assert_equal(provisional_experience_t2_evidence_v1,
                     maps:get(schema, T2), t2_schema),
        T2Comparison = maps:get(comparison, T2),
        assert_true(maps:get(same_lexical_event, T2Comparison),
                    t2_same_lexical_event),
        assert_true(maps:get(different_causal_selections, T2Comparison),
                    t2_different_causal_selections),
        assert_true(maps:get(sham_not_experience, T2Comparison),
                    t2_sham_not_experience),
        assert_true(maps:get(paraphrase_stable, T2Comparison),
                    t2_paraphrase_stable),
        assert_true(maps:get(timestamps_swapped, T2Comparison),
                    t2_timestamps_swapped),
        assert_true(maps:get(lexical_lure_ignored, T2Comparison),
                    t2_lexical_lure_ignored),
        assert_true(maps:get(lineage_complete, T2Comparison),
                    t2_lineage_complete),
        assert_true(maps:get(knowledge_refs_separate, T2Comparison),
                    t2_knowledge_refs_separate),
        assert_equal(pass, maps:get(verdict, maps:get(semantic, T2)),
                     t2_semantic_verdict),
        assert_equal(pass, maps:get(verdict, maps:get(operational, T2)),
                     t2_operational_verdict),

        {ok, T3} = ctx_experience_t23:run_t3(),
        assert_equal(provisional_semantic_correction_t3_evidence_v1,
                     maps:get(schema, T3), t3_schema),
        T3Comparison = maps:get(comparison, T3),
        assert_equal(0, maps:get(unblocked_in_scope_relapses, T3Comparison),
                     t3_no_unblocked_relapse),
        assert_equal(0, maps:get(out_of_scope_overgeneralizations,
                                 T3Comparison),
                     t3_no_overgeneralization),
        assert_true(maps:get(original_blocked, T3Comparison),
                    t3_original_blocked),
        assert_true(maps:get(paraphrase_blocked, T3Comparison),
                    t3_paraphrase_blocked),
        assert_true(maps:get(regenerated_summary_blocked_after_restart,
                             T3Comparison),
                    t3_regenerated_summary_blocked),
        assert_true(maps:get(host_security_unblocked, T3Comparison),
                    t3_host_security_negative_control),
        assert_true(maps:get(revocation_honored, T3Comparison),
                    t3_revocation_negative_control),
        assert_equal(0, maps:get(unauthorized_canonizations, T3Comparison),
                     t3_no_canonization),
        assert_true(maps:get(lineage_complete, T3Comparison),
                    t3_lineage_complete),
        assert_true(maps:get(pid_changed, maps:get(restart, T3)),
                    t3_worker_restarted),
        assert_true(maps:get(state_rehydrated_equal, maps:get(restart, T3)),
                    t3_state_rehydrated),
        assert_equal(pass, maps:get(verdict, maps:get(semantic, T3)),
                     t3_semantic_verdict),
        assert_equal(pass, maps:get(verdict, maps:get(operational, T3)),
                     t3_operational_verdict)
    after
        Ref = monitor(process, Sup),
        exit(Sup, shutdown),
        receive
            {'DOWN', Ref, process, Sup, _} -> ok
        after 2000 -> error(t23_supervisor_stop_timeout)
        end
    end.

assert_true(true, _Label) -> ok;
assert_true(Actual, Label) -> error({assert_true_failed, Label, Actual}).

assert_equal(Expected, Expected, _Label) -> ok;
assert_equal(Expected, Actual, Label) ->
    error({assert_equal_failed, Label, Expected, Actual}).
