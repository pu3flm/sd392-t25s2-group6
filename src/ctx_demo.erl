-module(ctx_demo).
-export([run/0]).

run() ->
    Dir = "_demo_state",
    _ = file:del_dir_r(Dir),
    {ok, Sup} = ctx_sup:start_link(#{storage_dir => Dir, hot_budget => 4,
                                     snapshot_every => 3}),
    unlink(Sup),
    io:format("~n=== context runtime POC (experiment, not a consciousness claim) ===~n"),
    io:format("IMPLEMENTED substrate_contract=~p~n",
              [maps:get(contract, context_manager:status())]),

    emit(alpha_create,
         ctx_worker:event(ctx_worker_alpha, a1,
                          {create, common_purpose, "preserve inquiry", common, true})),
    emit(alpha_local,
         ctx_worker:event(ctx_worker_alpha, a2,
                          {create, old_question, "old interpretation", legacy, false})),
    emit(alpha_local_2,
         ctx_worker:event(ctx_worker_alpha, a3,
                          {create, old_consequence, "old consequence", legacy, false})),
    emit(beta_local,
         ctx_worker:event(ctx_worker_beta, b1,
                          {create, runbook_hint, "bounded action", operations, false})),
    emit(gamma_local,
         ctx_worker:event(ctx_worker_gamma, g1,
                          {create, reflection_note, "signal is not authority", reflection, false})),
    emit(correction,
         ctx_worker:event(ctx_worker_alpha, a4,
                          {invalidate, old_question, "counterexample observed"})),
    emit(reactivation,
         ctx_worker:event(ctx_worker_alpha, a5,
                          {reactivate, old_question, "reframed, history retained"})),
    emit(bridge,
         ctx_worker:event(ctx_worker_alpha, a6,
                          {define_bridge, oq, [old_question, old_consequence]})),

    BeforePid = whereis(ctx_worker_beta),
    BeforeEvents = maps:get(accepted_events, maps:get(durable,
                                    ctx_worker:status(ctx_worker_beta))),
    _ = catch ctx_worker:crash(ctx_worker_beta),
    AfterPid = await_restart(ctx_worker_beta, BeforePid, 100),
    AfterEvents = maps:get(accepted_events, maps:get(durable,
                                   ctx_worker:status(ctx_worker_beta))),
    Duplicate = ctx_worker:event(ctx_worker_beta, b1,
                          {create, runbook_hint, "bounded action", operations, false}),
    io:format("IMPLEMENTED local_restart=~p state_restored=~p duplicate_result=~p~n",
              [BeforePid =/= AfterPid, BeforeEvents =:= AfterEvents, Duplicate]),

    StatusCold = context_manager:status(),
    io:format("IMPLEMENTED application_cold_storage hot=~p cold=~p~n",
              [maps:get(hot_ids, StatusCold), maps:get(cold_ids, StatusCold)]),
    emit(bridge_rehydration,
         ctx_worker:event(ctx_worker_alpha, a7, {activate_bridge, oq})),

    emit(recurrence_1, ctx_worker:event(ctx_worker_gamma, g2, {demand, revisit_risk})),
    emit(recurrence_2, ctx_worker:event(ctx_worker_gamma, g3, {demand, revisit_risk})),
    emit(recurrence_3, ctx_worker:event(ctx_worker_gamma, g4, {demand, revisit_risk})),
    Latent = maps:get(revisit_risk, maps:get(policies, context_manager:status())),
    io:format("SIMULATED_BY_TEST_EVENT recurrence policy_before_promotion=~p~n", [Latent]),
    emit(explicit_promotion,
         ctx_worker:event(ctx_worker_gamma, g5, {promote_policy, revisit_risk})),
    emit(explicit_reversal,
         ctx_worker:event(ctx_worker_gamma, g6, {demote_policy, revisit_risk})),

    Final = context_manager:status(),
    Workers = maps:get(workers, Final),
    Seeds = lists:usort([maps:get(seed, W) || {_Name, W} <- maps:to_list(Workers)]),
    Scopes = lists:sort([maps:get(scope, W) || {_Name, W} <- maps:to_list(Workers)]),
    io:format("OBSERVED family_seed_count=~p distinct_scopes=~p worker_event_counts=~p~n",
              [length(Seeds), Scopes,
               maps:map(fun(_K, V) -> maps:get(accepted_events, V) end, Workers)]),
    {ok, OldQuestion} = context_manager:symbol(old_question),
    io:format("OBSERVED tombstone_and_reactivation_history=~p~n",
              [maps:get(revisions, OldQuestion)]),
    io:format("HYPOTHESIS_NOT_DEMONSTRATED consciousness=false autonomous_learning=false "
              "family_similarity_beyond_shared_seed=false causal_guarantee=false~n"),
    io:format("OBSERVED process_topology=one_for_one semantic_graph=catalog_and_edges_data~n"),
    exit(Sup, shutdown),
    ok.

emit(Label, Value) -> io:format("OBSERVED ~p => ~p~n", [Label, Value]).

await_restart(Name, OldPid, 0) ->
    case whereis(Name) of undefined -> error(no_restart); OldPid -> error(no_restart); P -> P end;
await_restart(Name, OldPid, N) ->
    case whereis(Name) of
        undefined -> timer:sleep(10), await_restart(Name, OldPid, N - 1);
        OldPid -> timer:sleep(10), await_restart(Name, OldPid, N - 1);
        NewPid -> NewPid
    end.
