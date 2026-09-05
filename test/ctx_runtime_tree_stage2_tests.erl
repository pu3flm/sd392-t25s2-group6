-module(ctx_runtime_tree_stage2_tests).

-export([run_t4/0, run_t5/0, run_t6/0]).

run_t4() ->
    {ok, Sup} = ctx_runtime_tree_stage2_sup:start_link(),
    unlink(Sup),
    try
        {ok, Evidence} = ctx_runtime_tree_stage2_runner:run_t4(),
        assert_equal(provisional_runtime_tree_t4_evidence_v1,
                     maps:get(schema, Evidence), schema),
        C = maps:get(comparison, Evidence),
        assert_true(maps:get(navigated_a_b_a, C), navigated_a_b_a),
        assert_true(maps:get(identity_preserved, C), identity_preserved),
        assert_true(maps:get(contents_unchanged, C), contents_unchanged),
        assert_true(maps:get(bounded_projections, C), bounded_projections),
        assert_true(maps:get(cold_branch_omitted, C), cold_branch_omitted),
        assert_true(maps:get(lexical_lure_ignored, C), lexical_lure_ignored),
        assert_true(maps:get(selection_explained, C), selection_explained),
        assert_equal(pass, maps:get(verdict, maps:get(semantic, Evidence)),
                     semantic_verdict),
        assert_equal(pass, maps:get(verdict, maps:get(operational, Evidence)),
                     operational_verdict),
        ok
    after
        Ref = monitor(process, Sup),
        exit(Sup, shutdown),
        receive
            {'DOWN', Ref, process, Sup, _} -> ok
        after 2000 -> error(stage2_supervisor_stop_timeout)
        end
    end.

run_t5() ->
    {ok, Sup} = ctx_runtime_tree_stage2_sup:start_link(),
    unlink(Sup),
    try
        {ok, Evidence} = ctx_runtime_tree_stage2_runner:run_t5(),
        assert_equal(provisional_runtime_tree_t5_evidence_v1,
                     maps:get(schema, Evidence), t5_schema),
        C = maps:get(comparison, Evidence),
        assert_true(maps:get(active_dormant_cold_active, C),
                    t5_status_trajectory),
        assert_true(maps:get(absent_while_cold, C), t5_absent_while_cold),
        assert_true(maps:get(identity_preserved, C), t5_identity_preserved),
        assert_true(maps:get(history_preserved, C), t5_history_preserved),
        assert_true(maps:get(lexical_lure_ignored, C), t5_lure_ignored),
        assert_true(maps:get(same_label_decoy_ignored, C), t5_decoy_ignored),
        assert_true(maps:get(paraphrase_reactivated, C),
                    t5_paraphrase_reactivated),
        assert_true(maps:get(rehydrated_after_restart, C),
                    t5_rehydrated_after_restart),
        assert_equal(pass, maps:get(verdict, maps:get(semantic, Evidence)),
                     t5_semantic_verdict),
        assert_equal(pass, maps:get(verdict, maps:get(operational, Evidence)),
                     t5_operational_verdict),
        ok
    after
        Ref = monitor(process, Sup),
        exit(Sup, shutdown),
        receive
            {'DOWN', Ref, process, Sup, _} -> ok
        after 2000 -> error(stage2_supervisor_stop_timeout)
        end
    end.

run_t6() ->
    {ok, Sup} = ctx_runtime_tree_stage2_sup:start_link(),
    unlink(Sup),
    try
        {ok, Evidence} = ctx_runtime_tree_stage2_runner:run_t6(),
        assert_equal(provisional_runtime_tree_t6_evidence_v1,
                     maps:get(schema, Evidence), t6_schema),
        C = maps:get(comparison, Evidence),
        assert_true(maps:get(causal_experience_selected, C),
                    t6_causal_experience),
        assert_true(maps:get(knowledge_provenance_separate, C),
                    t6_knowledge_separate),
        assert_true(maps:get(log_not_experience, C), t6_log_not_experience),
        assert_true(maps:get(contradictory_knowledge_did_not_overwrite, C),
                    t6_contradiction_separate),
        assert_true(maps:get(no_experience_not_satisfied_by_kb, C),
                    t6_no_experience_control),
        assert_true(maps:get(no_kb_preserves_experience, C),
                    t6_no_kb_control),
        assert_true(maps:get(bounded_traversal, C), t6_bounded),
        assert_true(maps:get(lineage_complete, C), t6_lineage),
        assert_equal(pass, maps:get(verdict, maps:get(semantic, Evidence)),
                     t6_semantic_verdict),
        assert_equal(pass, maps:get(verdict, maps:get(operational, Evidence)),
                     t6_operational_verdict),
        ok
    after
        Ref = monitor(process, Sup),
        exit(Sup, shutdown),
        receive
            {'DOWN', Ref, process, Sup, _} -> ok
        after 2000 -> error(stage2_supervisor_stop_timeout)
        end
    end.

assert_true(true, _Label) -> ok;
assert_true(Actual, Label) -> error({assert_true_failed, Label, Actual}).

assert_equal(Expected, Expected, _Label) -> ok;
assert_equal(Expected, Actual, Label) ->
    error({assert_equal_failed, Label, Expected, Actual}).
