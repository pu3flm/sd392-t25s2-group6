-module(ctx_experience_slice_tests).

-export([run/0]).

run() ->
    pure_trajectory_test(),
    supervised_parallel_ab_test(),
    ok.

pure_trajectory_test() ->
    Original = <<"the operation is safe">>,
    Corrected = <<"the operation requires an authority check">>,
    LaterPayload = <<"consider the operation again">>,

    State0 = ctx_experience_slice:new(),
    {ok, State1} = ctx_experience_slice:record_interpretation(
                     State0, event_1, operation_risk,
                     <<"consider the operation">>, interpretation_1, Original),

    {ok, UncorrectedState} = ctx_experience_slice:observe(
                               State1, event_2, operation_risk, LaterPayload),
    {ok, UncorrectedProjection} = ctx_experience_slice:project(
                                      UncorrectedState, 2, event_2),
    assert_equal(Original,
                 maps:get(statement, maps:get(selected, UncorrectedProjection)),
                 uncorrected_later_projection),

    {ok, State2} = ctx_experience_slice:correct(
                     State1, correction_1, interpretation_1, Corrected,
                     <<"the original reading omitted the authority boundary">>),
    {ok, State3} = ctx_experience_slice:observe(
                     State2, event_2, operation_risk, LaterPayload),
    {ok, CorrectedProjection} = ctx_experience_slice:project(State3, 3, event_2),
    Selected = maps:get(selected, CorrectedProjection),
    assert_equal(Corrected, maps:get(statement, Selected),
                 correction_changes_later_projection),
    assert_equal(experience_base,
                 maps:get(source_space, maps:get(provenance, Selected)),
                 experience_provenance_is_explicit),
    assert_equal([], maps:get(knowledge_refs, CorrectedProjection),
                 knowledge_base_remains_distinct),
    assert_equal(
      [#{kind => raw_event, id => event_1},
       #{kind => interpretation, id => interpretation_1},
       #{kind => correction, id => correction_1}],
      maps:get(lineage, Selected), correction_lineage),

    {ok, OriginalProjection} = ctx_experience_slice:project(State3, 1, event_1),
    assert_equal(Original,
                 maps:get(statement, maps:get(selected, OriginalProjection)),
                 original_version_remains_available),
    {ok, OriginalEvent} = ctx_experience_slice:event(State3, 1, event_1),
    assert_equal(<<"consider the operation">>, maps:get(payload, OriginalEvent),
                 original_event_remains_available),

    assert_equal(3, ctx_experience_slice:head_version(State3), head_version),
    assert_equal([interpretation_recorded, correction_recorded, event_observed],
                 [maps:get(kind, T) || T <- ctx_experience_slice:transitions(State3)],
                 transition_trajectory),
    ok.

supervised_parallel_ab_test() ->
    {ok, Sup} = ctx_experience_ab_sup:start_link(),
    unlink(Sup),
    try
        {ok, Evidence} = ctx_experience_ab:run_case(),
        Baseline = maps:get(baseline, Evidence),
        Experimental = maps:get(experimental, Evidence),
        Comparison = maps:get(comparison, Evidence),
        BaselineProjection = maps:get(projection, Baseline),
        ExperimentalProjection = maps:get(projection, Experimental),

        assert_equal(baseline, maps:get(branch_id, Baseline), baseline_branch),
        assert_equal(experimental, maps:get(branch_id, Experimental),
                     experimental_branch),
        assert_equal(event_2, maps:get(for_event, BaselineProjection),
                     same_baseline_condition),
        assert_equal(event_2, maps:get(for_event, ExperimentalProjection),
                     same_experimental_condition),
        assert_equal([interpretation_recorded, event_observed],
                     maps:get(transition_kinds, Baseline),
                     baseline_has_no_correction),
        assert_equal([interpretation_recorded, correction_recorded,
                      event_observed],
                     maps:get(transition_kinds, Experimental),
                     correction_confined_to_experimental_branch),
        assert_equal(<<"the operation is safe">>,
                     maps:get(statement, maps:get(selected, BaselineProjection)),
                     baseline_result),
        assert_equal(<<"the operation requires an authority check">>,
                     maps:get(statement,
                              maps:get(selected, ExperimentalProjection)),
                     experimental_result),
        assert_equal(true, maps:get(changed, Comparison), changed_comparison),
        assert_equal(true, maps:get(isolated_branch_heads, Comparison),
                     isolated_branch_heads),
        assert_equal(2, length(maps:get(delivery_receipts, Evidence)),
                     concurrent_delivery_receipts),
        Historical = maps:get(historical_projection, Experimental),
        assert_equal(<<"the operation is safe">>,
                     maps:get(statement, maps:get(selected, Historical)),
                     supervised_history_preserved)
    after
        Ref = monitor(process, Sup),
        exit(Sup, shutdown),
        receive
            {'DOWN', Ref, process, Sup, _} -> ok
        after 2000 -> error(supervisor_stop_timeout)
        end
    end.

assert_equal(Expected, Expected, _Label) -> ok;
assert_equal(Expected, Actual, Label) ->
    error({assert_equal_failed, Label, Expected, Actual}).
