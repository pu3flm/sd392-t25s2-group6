-module(ctx_runtime_tree_stage4_tests).

-export([run_t10/0, run_t11/0, run_t12/0]).

run_t10() ->
    {ok, Sup} = ctx_runtime_tree_stage4_sup:start_link(),
    unlink(Sup),
    try
        {ok, E} = ctx_runtime_tree_stage4_runner:run_t10(),
        assert_equal(provisional_runtime_tree_t10_evidence_v1,
                     maps:get(schema, E), schema),
        C = maps:get(comparison, E),
        assert_true(maps:get(before_commit_replay_converged, C), before_commit),
        assert_true(maps:get(after_commit_replay_converged, C), after_commit),
        assert_true(maps:get(no_duplicate_semantic_transition, C), no_duplicate),
        assert_true(maps:get(poison_quarantined_boundedly, C), poison),
        assert_true(maps:get(poison_absent_from_projection, C), poison_projection),
        assert_true(maps:get(crashes_not_conceptual_nodes, C), topology_distinction),
        assert_equal(pass, maps:get(verdict, maps:get(semantic, E)), semantic),
        assert_equal(pass, maps:get(verdict, maps:get(operational, E)),
                     operational),
        ok
    after
        Ref = monitor(process, Sup),
        exit(Sup, shutdown),
        receive {'DOWN', Ref, process, Sup, _} -> ok
        after 2000 -> error(stage4_supervisor_stop_timeout)
        end
    end.

run_t11() ->
    {ok, Sup} = ctx_runtime_tree_stage4_sup:start_link(),
    unlink(Sup),
    try
        {ok, E} = ctx_runtime_tree_stage4_runner:run_t11(),
        assert_equal(provisional_runtime_tree_t11_evidence_v1,
                     maps:get(schema, E), schema),
        C = maps:get(comparison, E),
        assert_true(maps:get(queue_bound_enforced, C), bounded_queue),
        assert_true(maps:get(backpressure_visible, C), backpressure),
        assert_true(maps:get(focal_preserved_under_pressure, C), focal),
        assert_true(maps:get(dormant_identity_reactivated, C), reactivation),
        assert_true(maps:get(rejected_history_preserved, C), rejected_history),
        assert_true(maps:get(no_pressure_canonization, C), no_canonization),
        assert_true(maps:get(recovered_after_release, C), recovery),
        assert_equal(pass, maps:get(verdict, maps:get(semantic, E)), semantic),
        assert_equal(pass, maps:get(verdict, maps:get(operational, E)),
                     operational),
        ok
    after
        Ref = monitor(process, Sup),
        exit(Sup, shutdown),
        receive {'DOWN', Ref, process, Sup, _} -> ok
        after 2000 -> error(stage4_supervisor_stop_timeout)
        end
    end.

run_t12() ->
    {ok, Sup} = ctx_runtime_tree_stage4_sup:start_link(),
    unlink(Sup),
    try
        {ok, E} = ctx_runtime_tree_stage4_runner:run_t12(),
        assert_equal(provisional_runtime_tree_t12_evidence_v1,
                     maps:get(schema, E), schema),
        C = maps:get(comparison, E),
        assert_true(maps:get(later_selection_changed_by_learning, C),
                    changed_selection),
        assert_true(maps:get(all_in_scope_regressions_blocked, C), regression),
        assert_true(maps:get(out_of_scope_counterexample_preserved, C), scope),
        assert_true(maps:get(correction_lineage_recoverable, C), lineage),
        assert_true(maps:get(historical_error_queryable, C), history),
        assert_true(maps:get(projection_more_parsimonious, C), parsimony),
        assert_true(maps:get(candidate_remains_provisional, C), provisional),
        assert_true(maps:get(no_canonization, C), no_canonization),
        assert_equal(pass, maps:get(verdict, maps:get(semantic, E)), semantic),
        assert_equal(pass, maps:get(verdict, maps:get(operational, E)),
                     operational),
        ok
    after
        Ref = monitor(process, Sup),
        exit(Sup, shutdown),
        receive {'DOWN', Ref, process, Sup, _} -> ok
        after 2000 -> error(stage4_supervisor_stop_timeout)
        end
    end.

assert_true(true, _Label) -> ok;
assert_true(Actual, Label) -> error({assert_true_failed, Label, Actual}).
assert_equal(Expected, Expected, _Label) -> ok;
assert_equal(Expected, Actual, Label) ->
    error({assert_equal_failed, Label, Expected, Actual}).
