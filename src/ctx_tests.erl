-module(ctx_tests).
-export([run/0]).

-define(assert(Expr),
        case (Expr) of true -> ok; _ -> error({assertion_failed, ??Expr}) end).
-define(assertEqual(Expected, Actual),
        assert_equal((Expected), (Actual), ??Expected)).
-define(assertNotEqual(NotExpected, Actual),
        assert_not_equal((NotExpected), (Actual), ??Actual)).

run() ->
    Tests = [fun family_divergence_test/0,
             fun restart_and_dedup_test/0,
             fun cold_bridge_and_history_test/0,
             fun latent_policy_test/0,
             fun live_transfer_test/0,
             fun snapshot_journal_recovery_test/0],
    lists:foreach(fun(Test) -> Test(), io:format(".~n") end, Tests),
    io:format("6 deterministic tests passed~n"),
    ok.

assert_equal(Expected, Expected, _Label) -> ok;
assert_equal(Expected, Got, Label) ->
    error({assert_equal_failed, Label, Expected, Got}).

assert_not_equal(Value, Value, Label) ->
    error({assert_not_equal_failed, Label});
assert_not_equal(_NotExpected, _Actual, _Label) -> ok.

family_divergence_test() ->
    with_runtime(4, fun() ->
        {accepted, _} = ctx_worker:event(ctx_worker_alpha, fd1,
                         {create, shared, "shared purpose", common, true}),
        {accepted, _} = ctx_worker:event(ctx_worker_beta, fd2,
                         {create, beta_fact, "beta", beta, false}),
        {accepted, _} = ctx_worker:event(ctx_worker_gamma, fd3,
                         {create, gamma_fact, "gamma", gamma, false}),
        S = context_manager:status(),
        W = maps:get(workers, S),
        Seeds = lists:usort([maps:get(seed, X) || {_K, X} <- maps:to_list(W)]),
        ?assertEqual(1, length(Seeds)),
        ?assertNotEqual(maps:get(scope, maps:get(ctx_worker_beta, W)),
                        maps:get(scope, maps:get(ctx_worker_gamma, W))),
        ?assert(maps:is_key(beta_fact, maps:get(catalog, S))),
        ?assert(maps:is_key(gamma_fact, maps:get(catalog, S)))
    end).

restart_and_dedup_test() ->
    with_runtime(4, fun() ->
        {accepted, _} = ctx_worker:event(ctx_worker_beta, rd1,
                         {create, effect_once, "once", beta, false}),
        OldPid = whereis(ctx_worker_beta),
        OldCount = durable_count(ctx_worker_beta),
        _ = catch ctx_worker:crash(ctx_worker_beta),
        NewPid = wait_new_pid(ctx_worker_beta, OldPid, 100),
        ?assertNotEqual(OldPid, NewPid),
        ?assertEqual(OldCount, durable_count(ctx_worker_beta)),
        {duplicate, _} = ctx_worker:event(ctx_worker_beta, rd1,
                          {create, effect_once, "once", beta, false}),
        ?assertEqual(OldCount, durable_count(ctx_worker_beta)),
        {ok, Node} = context_manager:symbol(effect_once),
        ?assertEqual(1, maps:get(version, Node))
    end).

cold_bridge_and_history_test() ->
    with_runtime(3, fun() ->
        {accepted, _} = ctx_worker:event(ctx_worker_alpha, cb1,
                         {create, legacy_a, "A", legacy, false}),
        {accepted, _} = ctx_worker:event(ctx_worker_alpha, cb2,
                         {create, legacy_b, "B", legacy, false}),
        {accepted, _} = ctx_worker:event(ctx_worker_beta, cb3,
                         {create, current_b, "B now", beta, false}),
        {accepted, _} = ctx_worker:event(ctx_worker_gamma, cb4,
                         {create, current_g, "G now", gamma, false}),
        Cold = maps:get(cold_ids, context_manager:status()),
        ?assert(lists:member(legacy_a, Cold)),
        ?assert(lists:member(legacy_b, Cold)),
        {accepted, _} = ctx_worker:event(ctx_worker_alpha, cb5,
                         {define_bridge, la, [legacy_a, legacy_b]}),
        {accepted, Rehydrated} = ctx_worker:event(ctx_worker_alpha, cb6,
                              {activate_bridge, la}),
        ?assertEqual([legacy_a, legacy_b], maps:get(rehydrated, Rehydrated)),
        {accepted, _} = ctx_worker:event(ctx_worker_alpha, cb7,
                         {invalidate, legacy_a, "wrong"}),
        {accepted, _} = ctx_worker:event(ctx_worker_alpha, cb8,
                         {reactivate, legacy_a, "reframed"}),
        {ok, Node} = context_manager:symbol(legacy_a),
        Actions = [maps:get(action, R) || R <- maps:get(revisions, Node)],
        ?assertEqual([created, invalidated, reactivated], Actions)
    end).

latent_policy_test() ->
    with_runtime(4, fun() ->
        [ctx_worker:event(ctx_worker_gamma, Id, {demand, recurring_review})
         || Id <- [lp1, lp2, lp3]],
        P0 = maps:get(recurring_review, maps:get(policies,
                                                context_manager:status())),
        ?assertEqual(latent, maps:get(status, P0)),
        ?assertEqual(false, maps:get(executable, P0)),
        {accepted, Promote} = ctx_worker:event(ctx_worker_gamma, lp4,
                               {promote_policy, recurring_review}),
        ?assertEqual(false, maps:get(executed, Promote)),
        {accepted, _} = ctx_worker:event(ctx_worker_gamma, lp5,
                         {demote_policy, recurring_review}),
        P1 = maps:get(recurring_review, maps:get(policies,
                                                context_manager:status())),
        ?assertEqual(latent, maps:get(status, P1))
    end).

live_transfer_test() ->
    with_runtime(6, fun() ->
        Raw = #{text => "voice remark", source => realtime_voice,
                temporal_signals => [continuation]},
        Candidates = [#{id => literal_audio_request,
                        label => "literal audio control",
                        signals => [technical_reference]},
                      #{id => symbolic_irony,
                        label => "ironic symbolic continuation",
                        signals => [irony, prior_utterance]}],
        {accepted, Ingested} = context_manager:ingest_live(
                                 ctx_worker_alpha, live_session, lt1,
                                 Raw, Candidates),
        ?assertEqual(none, maps:get(selected, Ingested)),
        {ok, Projection0} = context_manager:projection(lt1),
        ?assertEqual(none, maps:get(selection, Projection0)),
        ?assertEqual(2, length(maps:get(interpretations, Projection0))),
        ?assert(lists:all(fun(N) -> maps:get(status, N) =:= provisional end,
                          maps:get(interpretations, Projection0))),
        {accepted, _} = ctx_worker:event(ctx_worker_alpha, lt2,
                         {invalidate, literal_audio_request,
                          "external observer rejected literal reading"}),
        {ok, Projection1} = context_manager:projection(lt1),
        ById = maps:from_list([{maps:get(id, N), N} ||
                               N <- maps:get(interpretations, Projection1)]),
        ?assertEqual(invalid, maps:get(status,
                                      maps:get(literal_audio_request, ById))),
        ?assertEqual(provisional, maps:get(status,
                          maps:get(symbolic_irony, ById)))
    end).

snapshot_journal_recovery_test() ->
    Dir = temp_dir(),
    {ok, Sup1} = ctx_sup:start_link(#{storage_dir => Dir, hot_budget => 4,
                                      snapshot_every => 2}),
    unlink(Sup1),
    {accepted, _} = ctx_worker:event(ctx_worker_alpha, sj1,
                     {create, durable, "v1", durable_group, false}),
    {accepted, _} = ctx_worker:event(ctx_worker_alpha, sj2,
                     {review, durable, "v2", "correction"}),
    {accepted, _} = ctx_worker:event(ctx_worker_alpha, sj3,
                     {invalidate, durable, "later journal entry"}),
    stop_sup(Sup1),
    {ok, Sup2} = ctx_sup:start_link(#{storage_dir => Dir, hot_budget => 4,
                                      snapshot_every => 2}),
    unlink(Sup2),
    {ok, Node} = context_manager:symbol(durable),
    ?assertEqual(3, maps:get(version, Node)),
    ?assertEqual(invalid, maps:get(status, Node)),
    {duplicate, _} = ctx_worker:event(ctx_worker_alpha, sj3,
                      {invalidate, durable, "later journal entry"}),
    ?assertEqual(3, maps:get(version, element(2, context_manager:symbol(durable)))),
    stop_sup(Sup2),
    ok = file:del_dir_r(Dir).

with_runtime(Budget, Fun) ->
    Dir = temp_dir(),
    {ok, Sup} = ctx_sup:start_link(#{storage_dir => Dir, hot_budget => Budget,
                                     snapshot_every => 3}),
    unlink(Sup),
    try Fun()
    after
        stop_sup(Sup),
        ok = file:del_dir_r(Dir)
    end.

temp_dir() ->
    filename:join("/tmp", "ctx_poc_" ++ integer_to_list(
                    erlang:unique_integer([positive, monotonic]))).

stop_sup(Sup) ->
    Ref = monitor(process, Sup),
    exit(Sup, shutdown),
    receive {'DOWN', Ref, process, Sup, _} -> ok after 2000 -> error(stop_timeout) end.

durable_count(Name) ->
    maps:get(accepted_events, maps:get(durable, ctx_worker:status(Name))).

wait_new_pid(Name, OldPid, 0) ->
    case whereis(Name) of undefined -> error(no_restart); OldPid -> error(no_restart); P -> P end;
wait_new_pid(Name, OldPid, N) ->
    case whereis(Name) of
        undefined -> timer:sleep(10), wait_new_pid(Name, OldPid, N - 1);
        OldPid -> timer:sleep(10), wait_new_pid(Name, OldPid, N - 1);
        Pid -> Pid
    end.
