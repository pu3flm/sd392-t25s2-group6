-module(ctx_continuation_t13_tests).

-export([run/0, run_v2/0]).

run() ->
    {ok, Sup} = ctx_continuation_t13_sup:start_link(),
    unlink(Sup),
    try
        {ok, E} = ctx_continuation_t13_runner:run(),
        assert_equal(provisional_t13_continuation_evidence_v1,
                     maps:get(schema, E), schema),
        C = maps:get(comparison, E),
        assert_true(maps:get(full_completion_chain_ordered, C), chain),
        assert_true(maps:get(successor_started_exactly_once, C), once),
        assert_true(maps:get(successor_inherited_full_envelope, C), inheritance),
        assert_true(maps:get(no_user_watchdog_or_wait_in_variant, C), no_wait),
        assert_true(maps:get(completion_replay_idempotent, C), replay),
        assert_true(maps:get(text_only_baseline_waited, C), baseline),
        assert_true(maps:get(missing_completion_did_not_start, C), missing),
        assert_true(maps:get(exhaustion_did_not_invent_work, C), exhausted),
        assert_true(maps:get(genuine_blocker_not_bypassed, C), blocker),
        assert_true(maps:get(out_of_scope_item_not_started, C), scope),
        assert_true(maps:get(improper_wait_experience_and_correction_retained, C),
                    experience),
        assert_equal(pass, maps:get(verdict, maps:get(semantic, E)), semantic),
        assert_equal(pass, maps:get(verdict, maps:get(operational, E)),
                     operational),
        ok
    after
        Ref = monitor(process, Sup),
        exit(Sup, shutdown),
        receive {'DOWN', Ref, process, Sup, _} -> ok
        after 2000 -> error(t13_supervisor_stop_timeout)
        end
    end.

run_v2() ->
    {ok, Sup} = ctx_continuation_t13_sup:start_link(),
    unlink(Sup),
    try
        {ok, E} = ctx_continuation_t13_runner:run_v2(),
        assert_equal(provisional_t13_experiential_continuation_evidence_v2,
                     maps:get(schema, E), schema),
        C = maps:get(comparison, E),
        assert_true(maps:get(same_fresh_condition_and_grant, C), same_condition),
        assert_true(maps:get(history_branch_derived_enforcement, C), derived),
        assert_true(maps:get(history_branch_started_successor, C), started),
        assert_true(maps:get(absent_history_branch_remained_unresolved, C),
                    absent_unresolved),
        assert_true(maps:get(absent_history_branch_did_not_start, C), absent_no_start),
        assert_true(maps:get(correction_lineage_caused_policy_selection, C), causal),
        assert_true(maps:get(no_caller_supplied_enforcement_mode, C), not_injected),
        assert_true(maps:get(history_completion_chain_ordered, C), chain),
        assert_true(maps:get(history_inheritance_complete, C), inheritance),
        assert_true(maps:get(history_replay_idempotent, C), replay),
        assert_true(maps:get(history_has_no_wait_or_watchdog, C), no_wait),
        assert_equal(pass, maps:get(verdict, maps:get(semantic, E)), semantic),
        assert_equal(pass, maps:get(verdict, maps:get(operational, E)),
                     operational),
        ok
    after
        Ref = monitor(process, Sup),
        exit(Sup, shutdown),
        receive {'DOWN', Ref, process, Sup, _} -> ok
        after 2000 -> error(t13_supervisor_stop_timeout)
        end
    end.

assert_true(true, _Label) -> ok;
assert_true(Actual, Label) -> error({assert_true_failed, Label, Actual}).
assert_equal(Expected, Expected, _Label) -> ok;
assert_equal(Expected, Actual, Label) ->
    error({assert_equal_failed, Label, Expected, Actual}).
