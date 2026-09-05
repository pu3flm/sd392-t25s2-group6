-module(ctx_runtime_tree_stage3_tests).

-export([run_t7/0, run_t8/0, run_t9/0]).

run_t7() ->
    {ok, Sup} = ctx_runtime_tree_stage3_sup:start_link(),
    unlink(Sup),
    try
        {ok, E} = ctx_runtime_tree_stage3_runner:run_t7(),
        assert_equal(provisional_runtime_tree_t7_evidence_v1,
                     maps:get(schema, E), schema),
        C = maps:get(comparison, E),
        assert_true(maps:get(user_event_processed_while_planner_pending, C),
                    foreground_processed),
        assert_true(maps:get(focus_advanced_before_plan_return, C),
                    focus_before_plan),
        assert_true(maps:get(plan_remained_provisional, C), provisional_plan),
        assert_true(maps:get(focal_unchanged_by_plan_return, C), no_leakage),
        assert_true(maps:get(source_version_preserved, C), source_version),
        assert_true(maps:get(new_user_event_proximal, C), proximal_event),
        assert_equal(pass, maps:get(verdict, maps:get(semantic, E)), semantic),
        assert_equal(pass, maps:get(verdict, maps:get(operational, E)),
                     operational),
        ok
    after
        Ref = monitor(process, Sup),
        exit(Sup, shutdown),
        receive {'DOWN', Ref, process, Sup, _} -> ok
        after 2000 -> error(stage3_supervisor_stop_timeout)
        end
    end.

run_t8() ->
    {ok, Sup} = ctx_runtime_tree_stage3_sup:start_link(),
    unlink(Sup),
    try
        {ok, E} = ctx_runtime_tree_stage3_runner:run_t8(),
        assert_equal(provisional_runtime_tree_t8_evidence_v1,
                     maps:get(schema, E), schema),
        C = maps:get(comparison, E),
        assert_true(maps:get(production_did_not_change_focal_state, C),
                    no_pre_appraisal_leakage),
        assert_true(maps:get(stale_artifact_not_promoted, C), stale_blocked),
        assert_true(maps:get(current_artifact_promoted_explicitly, C),
                    explicit_promotion),
        assert_true(maps:get(stale_and_current_same_text, C), text_control),
        assert_true(maps:get(provenance_preserved, C), provenance),
        assert_true(maps:get(no_canonization, C), no_canonization),
        assert_equal(pass, maps:get(verdict, maps:get(semantic, E)), semantic),
        assert_equal(pass, maps:get(verdict, maps:get(operational, E)),
                     operational),
        ok
    after
        Ref = monitor(process, Sup),
        exit(Sup, shutdown),
        receive {'DOWN', Ref, process, Sup, _} -> ok
        after 2000 -> error(stage3_supervisor_stop_timeout)
        end
    end.

run_t9() ->
    {ok, Sup} = ctx_runtime_tree_stage3_sup:start_link(),
    unlink(Sup),
    try
        {ok, E} = ctx_runtime_tree_stage3_runner:run_t9(),
        assert_equal(provisional_runtime_tree_t9_evidence_v1,
                     maps:get(schema, E), schema),
        C = maps:get(comparison, E),
        assert_true(maps:get(source_unchanged_by_clone_path, C),
                    source_isolation),
        assert_true(maps:get(ancestry_preserved, C), ancestry),
        assert_true(maps:get(divergence_confined_to_clone, C), divergence),
        assert_true(maps:get(unreviewed_merge_blocked, C), merge_gate),
        assert_true(maps:get(conflict_preserved_provisionally, C), conflict),
        assert_true(maps:get(source_unchanged_by_review, C), review_isolation),
        assert_true(maps:get(clone_terminated_and_removed, C), cleanup),
        assert_equal(pass, maps:get(verdict, maps:get(semantic, E)), semantic),
        assert_equal(pass, maps:get(verdict, maps:get(operational, E)),
                     operational),
        ok
    after
        Ref = monitor(process, Sup),
        exit(Sup, shutdown),
        receive {'DOWN', Ref, process, Sup, _} -> ok
        after 2000 -> error(stage3_supervisor_stop_timeout)
        end
    end.

assert_true(true, _Label) -> ok;
assert_true(Actual, Label) -> error({assert_true_failed, Label, Actual}).
assert_equal(Expected, Expected, _Label) -> ok;
assert_equal(Expected, Actual, Label) ->
    error({assert_equal_failed, Label, Expected, Actual}).
