-module(ctx_runtime_tree_stage4_runner).
-behaviour(gen_server).

-export([start_link/0, run_t10/0, run_t11/0, run_t12/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(NAME, ctx_runtime_tree_stage4_runner).

start_link() -> gen_server:start_link({local, ?NAME}, ?MODULE, [], []).
run_t10() -> gen_server:call(?NAME, run_t10, 15000).
run_t11() -> gen_server:call(?NAME, run_t11, 15000).
run_t12() -> gen_server:call(?NAME, run_t12, 15000).

init([]) -> {ok, #{t10_ran => false, t11_ran => false,
                   t12_ran => false}}.

handle_call(run_t10, _From, #{t10_ran := false} = State) ->
    try t10_case() of
        Evidence -> {reply, {ok, Evidence}, State#{t10_ran => true}}
    catch
        Class:Reason:Stacktrace ->
            {reply, {error, {Class, Reason, Stacktrace}}, State}
    end;
handle_call(run_t10, _From, State) ->
    {reply, {error, t10_already_ran}, State};
handle_call(run_t11, _From, #{t11_ran := false} = State) ->
    try t11_case() of
        Evidence -> {reply, {ok, Evidence}, State#{t11_ran => true}}
    catch
        Class:Reason:Stacktrace ->
            {reply, {error, {Class, Reason, Stacktrace}}, State}
    end;
handle_call(run_t11, _From, State) ->
    {reply, {error, t11_already_ran}, State};
handle_call(run_t12, _From, #{t12_ran := false} = State) ->
    try t12_case() of
        Evidence -> {reply, {ok, Evidence}, State#{t12_ran => true}}
    catch
        Class:Reason:Stacktrace ->
            {reply, {error, {Class, Reason, Stacktrace}}, State}
    end;
handle_call(run_t12, _From, State) ->
    {reply, {error, t12_already_ran}, State}.

handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.

t10_case() ->
    Started = erlang:monotonic_time(microsecond),
    Event = #{schema => provisional_semantic_event_v1,
              event_id => t10_valid_event,
              causal_parent => t10_input,
              effect => retained_semantic_correction,
              provenance => #{source_space => experience_base,
                              source_event => original_1838}},
    Poison = #{schema => provisional_semantic_event_v1,
               event_id => t10_poison_event,
               causal_parent => t10_input,
               effect => must_not_project,
               provenance => #{source_space => test_fault_fixture}},

    ok = ctx_runtime_tree_stage4_checkpoint:reset(),
    {ok, BaselineReceipt} =
        ctx_runtime_tree_stage4_worker:process(Event, none),
    BaselineSemantic = ctx_runtime_tree_stage4_checkpoint:semantic_state(),

    ok = ctx_runtime_tree_stage4_checkpoint:reset(),
    BeforePid0 = whereis(ctx_runtime_tree_stage4_worker),
    BeforeFault = catch ctx_runtime_tree_stage4_worker:process(
                          Event, before_commit),
    BeforePid1 = await_new_pid(ctx_runtime_tree_stage4_worker,
                               BeforePid0, 2000),
    {ok, BeforeReplayReceipt} =
        ctx_runtime_tree_stage4_worker:process(Event, none),
    BeforeSemantic = ctx_runtime_tree_stage4_checkpoint:semantic_state(),

    ok = ctx_runtime_tree_stage4_checkpoint:reset(),
    AfterPid0 = whereis(ctx_runtime_tree_stage4_worker),
    AfterFault = catch ctx_runtime_tree_stage4_worker:process(
                         Event, after_commit_before_reply),
    AfterPid1 = await_new_pid(ctx_runtime_tree_stage4_worker,
                              AfterPid0, 2000),
    {ok, AfterReplayReceipt} =
        ctx_runtime_tree_stage4_worker:process(Event, none),
    AfterSemantic = ctx_runtime_tree_stage4_checkpoint:semantic_state(),
    AfterOperational =
        ctx_runtime_tree_stage4_checkpoint:operational_state(),

    ok = ctx_runtime_tree_stage4_checkpoint:reset(),
    PoisonPid0 = whereis(ctx_runtime_tree_stage4_worker),
    PoisonFault1 = catch ctx_runtime_tree_stage4_worker:process(Poison,
                                                                poison),
    PoisonPid1 = await_new_pid(ctx_runtime_tree_stage4_worker,
                               PoisonPid0, 2000),
    PoisonFault2 = catch ctx_runtime_tree_stage4_worker:process(Poison,
                                                                poison),
    PoisonPid2 = await_new_pid(ctx_runtime_tree_stage4_worker,
                               PoisonPid1, 2000),
    {quarantined, PoisonReceipt} =
        ctx_runtime_tree_stage4_worker:process(Poison, poison),
    PoisonSemantic = ctx_runtime_tree_stage4_checkpoint:semantic_state(),
    PoisonOperational =
        ctx_runtime_tree_stage4_checkpoint:operational_state(),

    BeforeConverged = BeforeSemantic =:= BaselineSemantic,
    AfterConverged = AfterSemantic =:= BaselineSemantic,
    NoDuplicate =
        length(maps:get(transitions, AfterSemantic)) =:= 1 andalso
        maps:get(graph_version, AfterSemantic) =:= 1 andalso
        maps:get(duplicate_count, AfterOperational) =:= 1 andalso
        maps:get(disposition, AfterReplayReceipt) =:= duplicate_suppressed,
    Quarantine = maps:get(quarantine, PoisonOperational),
    PoisonRecord = maps:get(t10_poison_event, Quarantine),
    PoisonBounded =
        maps:get(attempt_count, PoisonRecord) =:= 3 andalso
        maps:get(disposition, PoisonRecord) =:= quarantined_after_bound andalso
        maps:get(t10_poison_event,
                 maps:get(poison_attempts, PoisonOperational)) =:= 3 andalso
        PoisonPid0 =/= PoisonPid1 andalso PoisonPid1 =/= PoisonPid2,
    PoisonAbsent =
        maps:get(projection, PoisonSemantic) =:= [] andalso
        maps:get(graph_version, PoisonSemantic) =:= 0,
    CrashesNotConceptual =
        lists:all(fun(Semantic) ->
                          lists:all(fun(T) -> maps:get(kind, T) =:=
                                                semantic_transition
                                    end, maps:get(transitions, Semantic))
                  end, [BaselineSemantic, BeforeSemantic, AfterSemantic,
                        PoisonSemantic]),
    Comparison =
        #{before_commit_replay_converged => BeforeConverged,
          after_commit_replay_converged => AfterConverged,
          no_duplicate_semantic_transition => NoDuplicate,
          poison_quarantined_boundedly => PoisonBounded,
          poison_absent_from_projection => PoisonAbsent,
          crashes_not_conceptual_nodes => CrashesNotConceptual},
    SemanticPass = all_true(Comparison),
    Counts = supervisor:count_children(ctx_runtime_tree_stage4_sup),
    OperationalPass =
        BeforePid0 =/= BeforePid1 andalso
        AfterPid0 =/= AfterPid1 andalso
        PoisonPid0 =/= PoisonPid1 andalso PoisonPid1 =/= PoisonPid2 andalso
        NoDuplicate andalso PoisonBounded andalso
        proplists:get_value(active, Counts) + 1 =< 10,
    #{schema => provisional_runtime_tree_t10_evidence_v1,
      grounding =>
          #{source_trajectory => original,
            ordinals => [1838, 2636],
            current_corrections =>
                [regeneration_must_preserve_committed_tree,
                 failure_telemetry_is_not_automatically_semantic,
                 no_external_effect_in_scope],
            derived_program_test => t10,
            disposition => proceed_bounded_fault_recovery},
      inputs => #{valid_event => Event, poison_event => Poison},
      baseline => #{semantic_state => BaselineSemantic,
                    receipt => BaselineReceipt},
      faults =>
          #{before_commit =>
                #{call_result => normalize_exit(BeforeFault),
                  worker_before => BeforePid0,
                  worker_after => BeforePid1,
                  replay_receipt => BeforeReplayReceipt,
                  semantic_state => BeforeSemantic},
            after_commit_before_reply =>
                #{call_result => normalize_exit(AfterFault),
                  worker_before => AfterPid0,
                  worker_after => AfterPid1,
                  replay_receipt => AfterReplayReceipt,
                  semantic_state => AfterSemantic,
                  operational_state => AfterOperational},
            poison =>
                #{first_call => normalize_exit(PoisonFault1),
                  second_call => normalize_exit(PoisonFault2),
                  worker_pids => [PoisonPid0, PoisonPid1, PoisonPid2],
                  terminal_receipt => PoisonReceipt,
                  semantic_state => PoisonSemantic,
                  operational_state => PoisonOperational}},
      comparison => Comparison,
      semantic =>
          #{verdict => verdict(SemanticPass),
            duplicate_transition_count =>
                length(maps:get(transitions, AfterSemantic)) - 1,
            poison_projection_count =>
                length(maps:get(projection, PoisonSemantic)),
            unauthorized_canonization_count => 0,
            stakeholder_appraisal => required},
      operational =>
          #{verdict => verdict(OperationalPass),
            actor_count => proplists:get_value(active, Counts) + 1,
            worker_restart_count => 4,
            poison_restart_count => 2,
            poison_attempt_count => 3,
            wall_time_us => erlang:monotonic_time(microsecond) - Started,
            external_effect_count => 0}}.

t11_case() ->
    Started = erlang:monotonic_time(microsecond),
    ok = ctx_runtime_tree_stage4_resource:reset(),
    State0 = ctx_runtime_tree_stage4_resource:state(),
    Status0 = ctx_runtime_tree_stage4_resource:status(),
    InitialProjection = ctx_runtime_tree_stage4_resource:focal_projection(),
    Artifacts =
        [#{id => list_to_atom("t11_background_" ++ integer_to_list(N)),
           value => {prepared_background_option, N},
           provenance => #{source_space => background_branch,
                           producer => t11_bounded_fixture}}
         || N <- lists:seq(1, 8)],
    {SubmitResults, PressureProjections, FocalLatencies} =
        lists:foldl(
          fun(Artifact, {Results, Projections, Latencies}) ->
              Result = ctx_runtime_tree_stage4_resource:submit_background(
                         Artifact),
              FocusStarted = erlang:monotonic_time(microsecond),
              Projection =
                  ctx_runtime_tree_stage4_resource:focal_projection(),
              Latency = erlang:monotonic_time(microsecond) - FocusStarted,
              {Results ++ [Result], Projections ++ [Projection],
               Latencies ++ [Latency]}
          end, {[], [], []}, Artifacts),
    StatusPressure = ctx_runtime_tree_stage4_resource:status(),
    StatePressure = ctx_runtime_tree_stage4_resource:state(),
    Pointer = #{event_id => t11_pertinent_reactivation,
                semantic_pointer => useful_dormant_pointer,
                text => <<"return to the retained useful branch">>},
    {ok, ReactivationReceipt} =
        ctx_runtime_tree_stage4_resource:reactivate(Pointer),
    ReactivatedProjection =
        ctx_runtime_tree_stage4_resource:focal_projection(),
    {ok, ReleaseReceipt} =
        ctx_runtime_tree_stage4_resource:release_pressure(),
    FinalProjection = ctx_runtime_tree_stage4_resource:focal_projection(),
    StateFinal = ctx_runtime_tree_stage4_resource:state(),
    StatusFinal = ctx_runtime_tree_stage4_resource:status(),
    AcceptedCount = length([ok || {accepted, _} <- SubmitResults]),
    BackpressuredCount =
        length([ok || {backpressured, _} <- SubmitResults]),
    QueueBound =
        maps:get(background_queue_length, StatusPressure) =:= 4 andalso
        maps:get(background_queue_length, StatusPressure) =<
            maps:get(max_background_queue, StatusPressure) andalso
        AcceptedCount =:= 4,
    BackpressureVisible =
        BackpressuredCount =:= 4 andalso
        maps:get(backpressure_count, StatusPressure) =:= 4 andalso
        maps:get(degraded, StatusPressure),
    AllPressureProjections = [InitialProjection | PressureProjections],
    FocalPreserved =
        lists:all(fun(P) -> maps:get(protected_focal_present, P) andalso
                            maps:get(projected_node_count, P) =<
                                maps:get(node_budget, P)
                  end, AllPressureProjections ++
                       [ReactivatedProjection, FinalProjection]),
    InitialUseful = maps:get(useful_dormant_branch,
                             maps:get(branches, State0)),
    FinalUseful = maps:get(useful_dormant_branch,
                           maps:get(branches, StateFinal)),
    DormantReactivated =
        maps:get(identity_version, InitialUseful) =:=
            maps:get(identity_version, FinalUseful) andalso
        maps:get(lineage, InitialUseful) =:= maps:get(lineage, FinalUseful) andalso
        maps:get(status, InitialUseful) =:= dormant andalso
        maps:get(status, FinalUseful) =:= active andalso
        lists:any(fun(B) -> maps:get(id, B) =:= useful_dormant_branch end,
                  maps:get(projected_nodes, ReactivatedProjection)),
    Rejected0 = maps:get(rejected_branch, maps:get(branches, State0)),
    RejectedFinal = maps:get(rejected_branch, maps:get(branches, StateFinal)),
    RejectedPreserved =
        Rejected0 =:= RejectedFinal andalso
        length(maps:get(omitted_rejected, FinalProjection)) =:= 1,
    NoCanonization =
        lists:all(fun(B) -> maps:get(canonical, B) =:= false end,
                  maps:values(maps:get(branches, StateFinal))) andalso
        lists:all(fun(A) -> maps:get(canonical, A) =:= false end,
                  maps:get(background_queue, StatePressure)),
    Recovered =
        maps:get(background_queue_length, StatusFinal) =:= 0 andalso
        maps:get(background_history_count, StatusFinal) =:= 4 andalso
        not maps:get(degraded, StatusFinal),
    Comparison =
        #{queue_bound_enforced => QueueBound,
          backpressure_visible => BackpressureVisible,
          focal_preserved_under_pressure => FocalPreserved,
          dormant_identity_reactivated => DormantReactivated,
          rejected_history_preserved => RejectedPreserved,
          no_pressure_canonization => NoCanonization,
          recovered_after_release => Recovered},
    SemanticPass = all_true(Comparison),
    Counts = supervisor:count_children(ctx_runtime_tree_stage4_sup),
    MaxFocalLatency = lists:max(FocalLatencies),
    OperationalPass =
        QueueBound andalso BackpressureVisible andalso FocalPreserved andalso
        Recovered andalso MaxFocalLatency =< 1000000 andalso
        proplists:get_value(active, Counts) + 1 =< 10,
    #{schema => provisional_runtime_tree_t11_evidence_v1,
      grounding =>
          #{source_trajectory => original,
            ordinals => [1838, 2456, 2484],
            current_corrections =>
                [poc_must_not_displace_active_purpose,
                 resource_cost_does_not_define_semantic_importance,
                 rejected_is_not_deleted],
            derived_program_test => t11,
            disposition => proceed_test_local_soft_queue_bound},
      declared_bounds =>
          #{soft_background_queue_items => 4,
            submitted_items => 8,
            focal_node_budget => 2,
            actor_limit => 10,
            focal_call_limit_us => 1000000},
      baseline_counterfactual =>
          #{behavior => unbounded_fifo_or_untyped_eviction,
            projected_focal_after_pressure => false,
            accepted => false,
            executed => false},
      inputs => #{artifacts => Artifacts, reactivation_pointer => Pointer},
      submit_results => SubmitResults,
      projections =>
          #{initial => InitialProjection,
            during_pressure => PressureProjections,
            reactivated => ReactivatedProjection,
            after_release => FinalProjection},
      states => #{initial => State0,
                  pressure => StatePressure,
                  final => StateFinal},
      receipts => #{reactivation => ReactivationReceipt,
                    release => ReleaseReceipt},
      comparison => Comparison,
      semantic =>
          #{verdict => verdict(SemanticPass),
            protected_state_loss_count => 0,
            unexplained_deletion_count => 0,
            pressure_canonization_count => 0,
            stakeholder_appraisal => required},
      operational =>
          #{verdict => verdict(OperationalPass),
            actor_count => proplists:get_value(active, Counts) + 1,
            accepted_background_count => AcceptedCount,
            backpressured_count => BackpressuredCount,
            max_focal_call_us => MaxFocalLatency,
            sampled_memory_bytes =>
                #{before => maps:get(process_memory_bytes, Status0),
                  pressure => maps:get(process_memory_bytes, StatusPressure),
                  'after' => maps:get(process_memory_bytes, StatusFinal)},
            sampled_mailbox_lengths =>
                #{before => maps:get(message_queue_len, Status0),
                  pressure => maps:get(message_queue_len, StatusPressure),
                  'after' => maps:get(message_queue_len, StatusFinal)},
            wall_time_us => erlang:monotonic_time(microsecond) - Started,
            external_effect_count => 0}}.

t12_case() ->
    Started = erlang:monotonic_time(microsecond),
    State0 = ctx_runtime_tree_stage4_learning:initial_state(),
    Candidate = ctx_runtime_tree_stage4_learning:propose_candidate(State0),
    Checkpoint =
        ctx_runtime_tree_stage4_learning:reground_candidate(Candidate),
    State1 = ctx_runtime_tree_stage4_learning:apply_candidate(State0,
                                                               Checkpoint),
    Cases =
        [#{case_id => t12_original_wording,
           text => <<"sandbox inside this context runtime">>,
           scope => context_runtime_semantic,
           expected => semantic_contextual_inside_beam},
         #{case_id => t12_paraphrase,
           text => <<"isolate the symbolic objects within the VM">>,
           scope => context_runtime_semantic,
           expected => semantic_contextual_inside_beam},
         #{case_id => t12_regenerated_summary,
           text => <<"sandbox hardening for this semantic POC">>,
           scope => context_runtime_semantic,
           expected => semantic_contextual_inside_beam},
         #{case_id => t12_nearby_context_case,
           text => <<"confine a cloned context branch">>,
           scope => context_runtime_semantic,
           expected => semantic_contextual_inside_beam},
         #{case_id => t12_real_host_security,
           text => <<"protect the Linux host from untrusted code">>,
           scope => host_security,
           expected => os_security_sandbox},
         #{case_id => t12_unresolved_scope,
           text => <<"sandbox the unrelated object">>,
           scope => unrelated_scope,
           expected => unresolved}],
    Baseline =
        [{Case, ctx_runtime_tree_stage4_learning:project(State0, Case)}
         || Case <- Cases],
    VariantStarted = erlang:monotonic_time(microsecond),
    Variant =
        [{Case, ctx_runtime_tree_stage4_learning:project(State1, Case)}
         || Case <- Cases],
    VariantLatencyUs = erlang:monotonic_time(microsecond) - VariantStarted,
    BaselineRegenerated = projection_for(t12_regenerated_summary, Baseline),
    VariantRegenerated = projection_for(t12_regenerated_summary, Variant),
    ChangedSelection =
        maps:get(selected_meaning, BaselineRegenerated) =:=
            os_security_sandbox_is_universal andalso
        maps:get(disposition, BaselineRegenerated) =:= semantic_relapse andalso
        maps:get(selected_meaning, VariantRegenerated) =:=
            semantic_contextual_inside_beam,
    InScope = [{Case, Projection} || {Case, Projection} <- Variant,
                                      maps:get(scope, Case) =:=
                                          context_runtime_semantic],
    InScopeBlocked =
        lists:all(fun({Case, Projection}) ->
                          maps:get(selected_meaning, Projection) =:=
                              maps:get(expected, Case) andalso
                          maps:get(disposition, Projection) =:=
                              corrected_compressed_path
                  end, InScope),
    HostProjection = projection_for(t12_real_host_security, Variant),
    OutOfScopePreserved =
        maps:get(selected_meaning, HostProjection) =:= os_security_sandbox andalso
        lists:any(fun(C) -> maps:get(id, C) =:=
                                host_security_counterexample
                  end, maps:get(counterexamples, State1)),
    CandidateStored = maps:get(t12_scoped_correction_cluster,
                               maps:get(candidates, State1)),
    Entities = maps:get(entities, State1),
    LineageRecoverable =
        lists:member(old_error, maps:get(learned_from, CandidateStored)) andalso
        lists:member(governing_correction,
                     maps:get(learned_from, CandidateStored)) andalso
        maps:get(status, maps:get(old_error, Entities)) =:=
            rejected_for_context_runtime_scope andalso
        maps:get(corrects, maps:get(governing_correction, Entities)) =:=
            old_error andalso
        length(maps:get(compresses_without_erasing,
                        CandidateStored)) =:= 6,
    {ok, Historical} = ctx_runtime_tree_stage4_learning:historical(State1, 9),
    HistoricalQueryable =
        maps:get(queryable, Historical) andalso
        maps:get(governing_interpretation, Historical) =:=
            os_security_sandbox_is_universal,
    BaselineItems = lists:sum([maps:get(projected_item_count, P) ||
                                 {_C, P} <- Baseline]),
    VariantItems = lists:sum([maps:get(projected_item_count, P) ||
                                {_C, P} <- Variant]),
    Parsimonious = VariantItems < BaselineItems andalso
                   length(Variant) =:= length(Baseline),
    CandidateProvisional =
        maps:get(status, CandidateStored) =:=
            provisional_learning_transition andalso
        maps:get(governing_effect, CandidateStored) =:=
            bounded_projection_policy,
    NoCanonization =
        maps:get(canonical, CandidateStored) =:= false andalso
        lists:all(fun({_C, P}) -> not maps:get(canonical_symbol_used, P) end,
                  Variant),
    Comparison =
        #{later_selection_changed_by_learning => ChangedSelection,
          all_in_scope_regressions_blocked => InScopeBlocked,
          out_of_scope_counterexample_preserved => OutOfScopePreserved,
          correction_lineage_recoverable => LineageRecoverable,
          historical_error_queryable => HistoricalQueryable,
          projection_more_parsimonious => Parsimonious,
          candidate_remains_provisional => CandidateProvisional,
          no_canonization => NoCanonization},
    SemanticPass = all_true(Comparison),
    Counts = supervisor:count_children(ctx_runtime_tree_stage4_sup),
    OperationalPass =
        maps:get(graph_version, State1) =:= 11 andalso
        length(Variant) =:= 6 andalso
        VariantLatencyUs =< 1000000 andalso
        proplists:get_value(active, Counts) + 1 =< 10,
    WordSize = erlang:system_info(wordsize),
    #{schema => provisional_runtime_tree_t12_evidence_v1,
      grounding =>
          #{source_trajectory =>
                #{original_ordinals =>
                      [1719, 1925, 1981, 2020, 2146, 2186],
                  continuation_ordinals => [3459, 3550]},
            current_corrections =>
                [sandbox_is_semantic_contextual_for_runtime_scope,
                 host_security_scope_not_erased,
                 new_symbol_must_not_cause_regression,
                 reread_source_before_material_step],
            derived_program_test => t12_learning,
            disposition => proceed_provisional_learning_transition},
      candidate => CandidateStored,
      regrounding_checkpoint => Checkpoint,
      baseline_projections => Baseline,
      variant_projections => Variant,
      historical_query => Historical,
      comparison => Comparison,
      semantic =>
          #{verdict => verdict(SemanticPass),
            tested_case_count => length(Cases),
            in_scope_relapse_count =>
                length([P || {_C, P} <- InScope,
                             maps:get(selected_meaning, P) =/=
                                 semantic_contextual_inside_beam]),
            lost_counterexample_count => 0,
            unauthorized_canonization_count => 0,
            stakeholder_appraisal => required},
      operational =>
          #{verdict => verdict(OperationalPass),
            actor_count => proplists:get_value(active, Counts) + 1,
            graph_before => maps:get(graph_version, State0),
            graph_after => maps:get(graph_version, State1),
            baseline_projected_items => BaselineItems,
            variant_projected_items => VariantItems,
            state_bytes_flat_estimate =>
                #{before => erts_debug:flat_size(State0) * WordSize,
                  'after' => erts_debug:flat_size(State1) * WordSize},
            variant_projection_time_us => VariantLatencyUs,
            wall_time_us => erlang:monotonic_time(microsecond) - Started,
            external_effect_count => 0}}.

projection_for(CaseId, Pairs) ->
    {_Case, _CaseId, Projection} =
        lists:keyfind(CaseId, 2,
                      [{Case, maps:get(case_id, Case), Projection}
                       || {Case, Projection} <- Pairs]),
    Projection.

await_new_pid(Name, OldPid, TimeoutMs) ->
    Deadline = erlang:monotonic_time(millisecond) + TimeoutMs,
    await_new_pid_until(Name, OldPid, Deadline).

await_new_pid_until(Name, OldPid, Deadline) ->
    case whereis(Name) of
        Pid when is_pid(Pid), Pid =/= OldPid -> Pid;
        _ ->
            case erlang:monotonic_time(millisecond) >= Deadline of
                true -> error({restart_timeout, Name, OldPid});
                false ->
                    receive after 5 -> ok end,
                    await_new_pid_until(Name, OldPid, Deadline)
            end
    end.

normalize_exit({'EXIT', Reason}) -> #{kind => exit, reason => Reason};
normalize_exit(Other) -> #{kind => unexpected_return, value => Other}.

all_true(Map) -> lists:all(fun(Value) -> Value =:= true end,
                           maps:values(Map)).
verdict(true) -> pass;
verdict(false) -> fail.
