-module(ctx_live_poc_t3_tests).

-export([run/0]).

run() ->
    {ok, Sup} = ctx_live_poc_t3_sup:start_link(),
    unlink(Sup),
    try
        {ok, E} = ctx_live_poc_t3_runner:run(),
        assert_equal(provisional_normative_t3_live_poc_evidence_v1,
                     maps:get(schema, E), schema),
        C = maps:get(comparison, E),
        assert_true(maps:get(baseline_output_preceded_ingestion, C),
                    baseline_posthoc),
        assert_true(maps:get(baseline_classified_offline, C), baseline_label),
        assert_true(maps:get(variant_projection_preceded_consumer_input, C),
                    projection_before_input),
        assert_true(maps:get(variant_consumer_input_preceded_output, C),
                    input_before_output),
        assert_true(maps:get(variant_observation_followed_output, C),
                    observation_after_output),
        assert_true(maps:get(only_variant_has_live_relation, C), live_relation),
        assert_true(maps:get(causal_parents_complete, C), causal_lineage),
        assert_true(maps:get(no_generic_success_canonized, C), no_canonization),
        assert_equal(pass, maps:get(verdict, maps:get(semantic, E)), semantic),
        assert_equal(pass, maps:get(verdict, maps:get(operational, E)),
                     operational),
        ok
    after
        Ref = monitor(process, Sup),
        exit(Sup, shutdown),
        receive {'DOWN', Ref, process, Sup, _} -> ok
        after 2000 -> error(t3_supervisor_stop_timeout)
        end
    end.

assert_true(true, _Label) -> ok;
assert_true(Actual, Label) -> error({assert_true_failed, Label, Actual}).
assert_equal(Expected, Expected, _Label) -> ok;
assert_equal(Expected, Actual, Label) ->
    error({assert_equal_failed, Label, Expected, Actual}).
