-module(ctx_pragmatic_t14_runtime).
-behaviour(gen_server).

-export([start_link/0, reset/0, evaluate/1, baseline/1, record_appraisal/1,
         snapshot/0, status/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(NAME, ctx_pragmatic_t14_runtime).

start_link() -> gen_server:start_link({local, ?NAME}, ?MODULE, [], []).
reset() -> gen_server:call(?NAME, reset).
evaluate(Scenario) -> gen_server:call(?NAME, {evaluate, Scenario}, 10000).
baseline(Scenario) -> gen_server:call(?NAME, {baseline, Scenario}, 10000).
record_appraisal(Appraisal) ->
    gen_server:call(?NAME, {record_appraisal, Appraisal}, 10000).
snapshot() -> gen_server:call(?NAME, snapshot).
status() -> gen_server:call(?NAME, status).

init([]) -> {ok, empty_state()}.

handle_call(reset, _From, _State) ->
    ok = ctx_pragmatic_t14_interlocutor:reset(),
    {reply, {ok, #{schema => provisional_t14_reset_receipt_v1,
                   reset => true, external_effect_count => 0}},
     empty_state()};
handle_call({baseline, Scenario}, _From, State0) ->
    Result0 = ctx_pragmatic_t14_engine:sentiment_baseline(Scenario),
    {Result, State1} = commit(sentiment_label_baseline, Result0, State0),
    {reply, {ok, Result}, State1};
handle_call({evaluate, Scenario}, _From, State0) ->
    Result0 = ctx_pragmatic_t14_engine:evaluate(Scenario),
    ConductPlan = maps:get(communicative_conduct, Result0),
    {ok, PerformativeReceipt} =
        ctx_pragmatic_t14_interlocutor:apply_conduct(
          maps:get(id, Scenario), ConductPlan),
    Result1 = ctx_pragmatic_t14_engine:finalize(Result0,
                                                PerformativeReceipt),
    {Result, State1} = commit(maps:get(id, Scenario), Result1, State0),
    {reply, {ok, Result}, State1};
handle_call({record_appraisal, Appraisal}, _From, State0) ->
    case valid_external_appraisal(Appraisal) of
        true ->
            Version = maps:get(version, State0) + 1,
            Receipt =
                #{schema => provisional_t14_external_appraisal_receipt_v1,
                  id => {t14_external_appraisal_receipt, Version},
                  disposition => external_stakeholder_disposition_recorded,
                  source_kind => maps:get(kind, Appraisal),
                  source_ledger => maps:get(ledger, Appraisal),
                  source_ledger_sha256 => maps:get(ledger_sha256, Appraisal),
                  specification_version =>
                      maps:get(specification_version, Appraisal),
                  specification_sha256 =>
                      maps:get(specification_sha256, Appraisal),
                  appraisal_ids => maps:get(appraisal_ids, Appraisal),
                  source_ordinals => maps:get(source_ordinals, Appraisal),
                  semantic_disposition_scope =>
                      acceptance_scenarios_a1_a50,
                  semantic_disposition => stakeholder_validated,
                  t14_runtime_result_appraisal => none,
                  operational_test_pass_delta => none,
                  operational_authority_delta => none,
                  runtime_self_acceptance => false,
                  external_effect_count => 0,
                  committed => true,
                  version => Version},
            Appraisals0 = maps:get(appraisals, State0),
            AppraisalId = spec_v0_16_acceptance_scenarios_a1_a50,
            Appraisals = Appraisals0#{AppraisalId =>
                                          #{snapshot => Appraisal,
                                            receipt => Receipt}},
            {reply, {ok, Receipt},
             State0#{version => Version, appraisals => Appraisals}};
        false ->
            {reply, {error, invalid_external_appraisal_snapshot}, State0}
    end;
handle_call(snapshot, _From, State) -> {reply, State, State};
handle_call(status, _From, State) ->
    {message_queue_len, QueueLen} = process_info(self(), message_queue_len),
    {memory, Memory} = process_info(self(), memory),
    {reply, #{transition_count => maps:get(version, State),
              stored_result_count => map_size(maps:get(results, State)),
              appraisal_count => map_size(maps:get(appraisals, State)),
              semantic_effect_count => maps:get(semantic_effect_count, State),
              external_effect_count => 0,
              message_queue_len => QueueLen,
              process_memory_bytes => Memory}, State}.

handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.

commit(Id, Result0, State0) ->
    Version = maps:get(version, State0) + 1,
    Receipt = maps:get(action_receipt, Result0),
    SemanticEffects = maps:get(semantic_effect_count, State0) +
                      maps:get(semantic_effect_count, Receipt, 0),
    Result = Result0#{runtime_transition =>
                          #{schema => provisional_t14_runtime_transition_v1,
                            version => Version,
                            scenario_id => Id,
                            committed => true,
                            external_effect_count => 0}},
    Results0 = maps:get(results, State0),
    {Result, State0#{version => Version,
                     results => Results0#{Id => Result},
                     semantic_effect_count => SemanticEffects}}.

empty_state() ->
    #{schema => provisional_t14_runtime_state_v1,
      version => 0,
      results => #{},
      appraisals => #{},
      semantic_effect_count => 0,
      external_effect_count => 0}.

valid_external_appraisal(Appraisal) ->
    maps:get(schema, Appraisal, none) =:=
        provisional_t14_stakeholder_appraisal_snapshot_v1 andalso
    maps:get(kind, Appraisal, none) =:= external_stakeholder_disposition andalso
    maps:get(ledger, Appraisal, none) =:=
        <<"work/stakeholder-appraisals.md">> andalso
    byte_size(maps:get(ledger_sha256, Appraisal, <<>>)) =:= 64 andalso
    maps:get(specification_version, Appraisal, none) =:= <<"0.16">> andalso
    maps:get(specification_sha256, Appraisal, none) =:=
        <<"b7a2942bf7054acde15d4ab6c36c35a63b799fc22783447a1d4ae42f6380a41a">> andalso
    maps:get(appraisal_ids, Appraisal, []) =:=
        [sa_001, sa_002, sa_003, sa_004, sa_005] andalso
    maps:get(source_ordinals, Appraisal, []) =:=
        [4355, 4411, 4467, 4512, 4546] andalso
    maps:get(accepted_scenario_ranges, Appraisal, []) =:=
        [{a1, a6}, {a7, a12}, {a13, a18},
         {a19, a24}, {a25, a50}] andalso
    maps:get(a1_a50_semantic_disposition, Appraisal, none) =:=
        stakeholder_validated andalso
    maps:get(operational_test_pass_delta, Appraisal, invalid) =:= none andalso
    maps:get(future_or_changed_clause_acceptance, Appraisal, invalid) =:=
        none andalso
    maps:get(runtime_self_acceptance, Appraisal, true) =:= false.
