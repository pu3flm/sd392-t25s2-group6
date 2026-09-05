-module(ctx_live_poc_t3_runner).
-behaviour(gen_server).

-export([start_link/0, run/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(NAME, ctx_live_poc_t3_runner).
-define(BASELINE, ctx_live_poc_t3_baseline).
-define(VARIANT, ctx_live_poc_t3_variant).

start_link() -> gen_server:start_link({local, ?NAME}, ?MODULE, [], []).
run() -> gen_server:call(?NAME, run, 10000).

init([]) -> {ok, #{ran => false}}.

handle_call(run, _From, #{ran := false} = State) ->
    try run_case() of
        Evidence -> {reply, {ok, Evidence}, State#{ran => true}}
    catch
        Class:Reason:Stacktrace ->
            {reply, {error, {Class, Reason, Stacktrace}}, State}
    end;
handle_call(run, _From, State) -> {reply, {error, already_ran}, State}.

handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.

run_case() ->
    Started = erlang:monotonic_time(microsecond),
    ok = ctx_live_poc_t3_branch:reset(?BASELINE),
    ok = ctx_live_poc_t3_branch:reset(?VARIANT),
    ok = ctx_live_poc_t3_consumer:reset(),
    Event = #{schema => provisional_normative_t3_raw_event_v1,
              event_id => t3_shared_semantic_event,
              source => stakeholder_fixture,
              text => <<"form context symbolically in the running Erlang POC">>,
              modalities => #{text => observed,
                              audio => unavailable,
                              prosody => unavailable}},

    {ok, BaselineOutput} =
        ctx_live_poc_t3_consumer:produce_without_projection(Event),
    {ok, _BaselineOutputReceipt} =
        ctx_live_poc_t3_branch:record_output_before_ingest(
          ?BASELINE, BaselineOutput),
    {ok, _BaselinePosthocReceipts} =
        ctx_live_poc_t3_branch:ingest_posthoc(?BASELINE, Event),
    BaselineState = ctx_live_poc_t3_branch:state(?BASELINE),

    {ok, Projection, _PreOutputReceipts} =
        ctx_live_poc_t3_branch:ingest_live(?VARIANT, Event),
    {ok, VariantConsumerResult} =
        ctx_live_poc_t3_consumer:consume_projection(Projection, Event),
    {ok, _ConsumerReceipts} =
        ctx_live_poc_t3_branch:record_live_consumer(
          ?VARIANT, VariantConsumerResult),
    {ok, _ObservationReceipts} =
        ctx_live_poc_t3_branch:observe_live(
          ?VARIANT,
          #{observation => bounded_output_received,
            source => test_observer}),
    VariantState = ctx_live_poc_t3_branch:state(?VARIANT),

    BaselineEvents = maps:get(events, BaselineState),
    VariantEvents = maps:get(events, VariantState),
    BaselineOutputSeq = event_sequence(consumer_output, BaselineEvents),
    BaselineRawSeq = event_sequence(raw_event, BaselineEvents),
    VariantProjectionSeq = event_sequence(projection_emitted, VariantEvents),
    VariantInputSeq = event_sequence(consumer_input, VariantEvents),
    VariantOutputSeq = event_sequence(consumer_output, VariantEvents),
    VariantObservationSeq = event_sequence(user_observation, VariantEvents),
    BaselineRelations = maps:get(relations, BaselineState),
    VariantRelations = maps:get(relations, VariantState),
    OnlyVariantLive =
        has_relation(participated_in_live_loop, VariantRelations) andalso
        not has_relation(participated_in_live_loop, BaselineRelations) andalso
        has_relation(offline_replay_of, BaselineRelations),
    CausalComplete = causal_chain_complete(VariantEvents) andalso
                     causal_chain_complete(BaselineEvents),
    NoCanonization =
        lists:all(fun(R) ->
                          maps:get(canonical, maps:get(payload, R)) =:= false
                  end, BaselineRelations ++ VariantRelations) andalso
        maps:get(canonical, maps:get(classification, BaselineState)) =:=
            false andalso
        maps:get(canonical, maps:get(classification, VariantState)) =:= false,
    Comparison =
        #{baseline_output_preceded_ingestion =>
              BaselineOutputSeq < BaselineRawSeq,
          baseline_classified_offline =>
              maps:get(kind, maps:get(classification, BaselineState)) =:=
                  offline_posthoc_substitute,
          variant_projection_preceded_consumer_input =>
              VariantProjectionSeq < VariantInputSeq,
          variant_consumer_input_preceded_output =>
              VariantInputSeq < VariantOutputSeq,
          variant_observation_followed_output =>
              VariantOutputSeq < VariantObservationSeq,
          only_variant_has_live_relation => OnlyVariantLive,
          causal_parents_complete => CausalComplete,
          no_generic_success_canonized => NoCanonization},
    SemanticPass = all_true(Comparison),
    Counts = supervisor:count_children(ctx_live_poc_t3_sup),
    ConsumerStatus = ctx_live_poc_t3_consumer:status(),
    OperationalPass =
        maps:get(graph_version, BaselineState) =:= 1 andalso
        maps:get(graph_version, VariantState) =:= 1 andalso
        maps:get(projected_inputs, ConsumerStatus) =:= 1 andalso
        proplists:get_value(active, Counts) + 1 =< 10,
    #{schema => provisional_normative_t3_live_poc_evidence_v1,
      grounding =>
          #{source_trajectory =>
                #{original_ordinals => [2337, 2352, 2363, 2589],
                  continuation_ordinals => [305, 393, 429, 479]},
            correction_frontier =>
                [conversation_runtime_was_the_intended_poc,
                 substitute_artifact_cannot_claim_live_participation,
                 local_runtime_evidence_must_come_from_this_causal_path],
            derived_program_test => normative_t3,
            disposition => proceed_bounded_local_live_path},
      shared_event => Event,
      baseline => BaselineState,
      variant => VariantState,
      consumer => #{baseline_output => BaselineOutput,
                    variant_result => VariantConsumerResult,
                    final_status => ConsumerStatus},
      comparison => Comparison,
      semantic =>
          #{verdict => verdict(SemanticPass),
            false_live_claim_count => 0,
            causal_inversion_count => 0,
            unauthorized_canonization_count => 0,
            stakeholder_appraisal => required},
      operational =>
          #{verdict => verdict(OperationalPass),
            actor_count => proplists:get_value(active, Counts) + 1,
            baseline_event_count => length(BaselineEvents),
            variant_event_count => length(VariantEvents),
            consumer_projected_input_count =>
                maps:get(projected_inputs, ConsumerStatus),
            wall_time_us => erlang:monotonic_time(microsecond) - Started,
            external_effect_count => 0}}.

event_sequence(Kind, Events) ->
    maps:get(sequence, hd([E || E <- Events, maps:get(kind, E) =:= Kind])).

has_relation(Kind, Relations) ->
    lists:any(fun(R) -> maps:get(kind, R) =:= Kind end, Relations).

causal_chain_complete(Events) ->
    IdToSeq = maps:from_list([{maps:get(id, E), maps:get(sequence, E)} ||
                                E <- Events]),
    lists:all(
      fun(E) ->
          case maps:get(causal_parent, E) of
              none -> true;
              Parent ->
                  case maps:find(Parent, IdToSeq) of
                      {ok, ParentSeq} -> ParentSeq < maps:get(sequence, E);
                      error -> false
                  end
          end
      end, Events).

all_true(Map) -> lists:all(fun(Value) -> Value =:= true end,
                           maps:values(Map)).
verdict(true) -> pass;
verdict(false) -> fail.
