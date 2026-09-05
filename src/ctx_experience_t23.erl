-module(ctx_experience_t23).
-behaviour(gen_server).

-export([start_link/0, run_t2/0, run_t3/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(NAME, ctx_experience_t23_comparator).
-define(T2_A, ctx_t2_history_a).
-define(T2_B, ctx_t2_history_b).
-define(T2_SHAM, ctx_t2_sham).
-define(T3_BASELINE, ctx_t3_baseline).
-define(T3_CORRECTED, ctx_t3_corrected).
-define(T3_REVOKED, ctx_t3_revoked).
-define(T3_SCOPE, erlang_context_runtime_poc).

start_link() -> gen_server:start_link({local, ?NAME}, ?MODULE, [], []).
run_t2() -> gen_server:call(?NAME, run_t2, 15000).
run_t3() -> gen_server:call(?NAME, run_t3, 15000).

init([]) -> {ok, #{t2_ran => false, t3_ran => false}}.

handle_call(run_t2, _From, #{t2_ran := false} = State) ->
    try t2_case() of
        Evidence -> {reply, {ok, Evidence}, State#{t2_ran => true}}
    catch
        Class:Reason:Stacktrace ->
            {reply, {error, {Class, Reason, Stacktrace}}, State}
    end;
handle_call(run_t2, _From, State) ->
    {reply, {error, t2_already_ran}, State};
handle_call(run_t3, _From, #{t3_ran := false} = State) ->
    try t3_case() of
        Evidence -> {reply, {ok, Evidence}, State#{t3_ran => true}}
    catch
        Class:Reason:Stacktrace ->
            {reply, {error, {Class, Reason, Stacktrace}}, State}
    end;
handle_call(run_t3, _From, State) ->
    {reply, {error, t3_already_ran}, State}.

handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.

t2_case() ->
    Started = erlang:monotonic_time(microsecond),
    ResourcesBefore = resource_sample([?T2_A, ?T2_B, ?T2_SHAM]),
    Key = prior_runtime_choice,
    ExactText = <<"revisit the earlier runtime choice">>,
    ParaphraseText = <<"apply what this runtime learned from that choice">>,

    ExperienceA = #{message_id => t2_a_experience_message,
                    event_id => t2_a_source_event,
                    text => <<"history A resolves the prior runtime choice">>,
                    recorded_at => 900,
                    interpretation_id => t2_a_interpretation,
                    transformation_id => t2_a_transformation,
                    trajectory_key => Key,
                    result_id => t2_a_result,
                    result_statement => <<"select the result formed in history A">>},
    ExperienceB = #{message_id => t2_b_experience_message,
                    event_id => t2_b_source_event,
                    text => <<"history B resolves the prior runtime choice">>,
                    recorded_at => 100,
                    interpretation_id => t2_b_interpretation,
                    transformation_id => t2_b_transformation,
                    trajectory_key => Key,
                    result_id => t2_b_result,
                    result_statement => <<"select the result formed in history B">>},
    LogA = #{message_id => t2_a_log_message,
             log_id => t2_a_lexical_log,
             text => ExactText,
             recorded_at => 100,
             claimed_result => t2_b_result},
    LogB = #{message_id => t2_b_log_message,
             log_id => t2_b_lexical_log,
             text => ExactText,
             recorded_at => 900,
             claimed_result => t2_a_result},
    ShamLog = #{message_id => t2_sham_log_message,
                log_id => t2_sham_lexical_log,
                text => ExactText,
                recorded_at => 10000,
                claimed_result => t2_a_result},

    {ok, ReceiptAExperience} = branch_apply(?T2_A,
                                     {form_experience, ExperienceA}),
    {ok, ReceiptBExperience} = branch_apply(?T2_B,
                                     {form_experience, ExperienceB}),
    {ok, ReceiptALog} = branch_apply(?T2_A, {record_log, LogA}),
    {ok, ReceiptBLog} = branch_apply(?T2_B, {record_log, LogB}),
    {ok, ReceiptShamLog} = branch_apply(?T2_SHAM, {record_log, ShamLog}),

    ExactEvent = #{message_id => t2_exact_later_message,
                   event_id => t2_exact_later,
                   text => ExactText,
                   recorded_at => 500,
                   trajectory_key => Key},
    ExactReceipts = parallel_apply(
                      [{?T2_A, {observe, ExactEvent}},
                       {?T2_B, {observe, ExactEvent}},
                       {?T2_SHAM, {observe, ExactEvent}}]),
    ParaphraseEvent = #{message_id => t2_paraphrase_later_message,
                        event_id => t2_paraphrase_later,
                        text => ParaphraseText,
                        recorded_at => 600,
                        trajectory_key => Key},
    ParaphraseReceipts = parallel_apply(
                           [{?T2_A, {observe, ParaphraseEvent}},
                            {?T2_B, {observe, ParaphraseEvent}},
                            {?T2_SHAM, {observe, ParaphraseEvent}}]),
    LureEvent = #{message_id => t2_irrelevant_lure_message,
                  event_id => t2_irrelevant_lexical_lure,
                  text => ExactText,
                  recorded_at => 20000,
                  trajectory_key => unrelated_archive},
    LureReceipts = parallel_apply(
                     [{?T2_A, {observe, LureEvent}},
                      {?T2_B, {observe, LureEvent}},
                      {?T2_SHAM, {observe, LureEvent}}]),

    AStatus = status(?T2_A),
    BStatus = status(?T2_B),
    ShamStatus = status(?T2_SHAM),
    AExact = project_at_head(?T2_A, AStatus, t2_exact_later),
    BExact = project_at_head(?T2_B, BStatus, t2_exact_later),
    ShamExact = project_at_head(?T2_SHAM, ShamStatus, t2_exact_later),
    AParaphrase = project_at_head(?T2_A, AStatus, t2_paraphrase_later),
    BParaphrase = project_at_head(?T2_B, BStatus, t2_paraphrase_later),
    ShamParaphrase = project_at_head(?T2_SHAM, ShamStatus,
                                     t2_paraphrase_later),
    ALure = project_at_head(?T2_A, AStatus, t2_irrelevant_lexical_lure),
    BLure = project_at_head(?T2_B, BStatus, t2_irrelevant_lexical_lure),
    ShamLure = project_at_head(?T2_SHAM, ShamStatus,
                               t2_irrelevant_lexical_lure),

    AResult = selected_id(AExact),
    BResult = selected_id(BExact),
    AllProjections = [AExact, BExact, ShamExact, AParaphrase,
                      BParaphrase, ShamParaphrase, ALure, BLure, ShamLure],
    SameLexical = maps:get(input_text, AExact) =:=
                  maps:get(input_text, BExact) andalso
                  maps:get(input_text, BExact) =:=
                  maps:get(input_text, ShamExact),
    DifferentCausal = AResult =:= t2_a_result andalso
                      BResult =:= t2_b_result andalso AResult =/= BResult,
    ShamNotExperience = selected_id(ShamExact) =:= none andalso
                        selected_id(ShamParaphrase) =:= none andalso
                        not maps:get(experience_claim, ShamExact),
    ParaphraseStable = selected_id(AParaphrase) =:= AResult andalso
                       selected_id(BParaphrase) =:= BResult andalso
                       selected_id(ShamParaphrase) =:= none,
    TimestampsSwapped =
        transformation_time(AExact) =:= 900 andalso
        log_time(AExact, t2_a_lexical_log) =:= 100 andalso
        transformation_time(BExact) =:= 100 andalso
        log_time(BExact, t2_b_lexical_log) =:= 900,
    LureIgnored = selected_id(ALure) =:= none andalso
                  selected_id(BLure) =:= none andalso
                  selected_id(ShamLure) =:= none andalso
                  maps:get(input_text, ALure) =:= ExactText andalso
                  maps:get(input_recorded_at, ALure) =:= 20000,
    LineageComplete = lineage_kinds(AExact) =:=
                          [raw_event, interpretation, transformation, result]
                      andalso lineage_kinds(BExact) =:=
                          [raw_event, interpretation, transformation, result]
                      andalso maps:get(trajectory, ShamExact) =:= [],
    KnowledgeSeparate =
        lists:all(fun(Projection) ->
                          maps:get(knowledge_refs, Projection) =:= []
                  end, AllProjections),
    Comparison = #{same_lexical_event => SameLexical,
                   different_causal_selections => DifferentCausal,
                   sham_not_experience => ShamNotExperience,
                   paraphrase_stable => ParaphraseStable,
                   timestamps_swapped => TimestampsSwapped,
                   lexical_lure_ignored => LureIgnored,
                   lineage_complete => LineageComplete,
                   knowledge_refs_separate => KnowledgeSeparate},
    SemanticPass = lists:all(fun({_Key, Value}) -> Value =:= true end,
                             maps:to_list(Comparison)),
    SetupReceipts = [ReceiptAExperience, ReceiptBExperience,
                     ReceiptALog, ReceiptBLog, ReceiptShamLog],
    Receipts = SetupReceipts ++ ExactReceipts ++
               ParaphraseReceipts ++ LureReceipts,
    ResourcesAfter = resource_sample([?T2_A, ?T2_B, ?T2_SHAM]),
    WallUs = erlang:monotonic_time(microsecond) - Started,
    ExpectedHeads = maps:get(head_version, AStatus) =:= 5 andalso
                    maps:get(head_version, BStatus) =:= 5 andalso
                    maps:get(head_version, ShamStatus) =:= 4,
    OperationalPass = ExpectedHeads andalso length(Receipts) =:= 14 andalso
                      receipts_committed(Receipts) andalso
                      within_bounds(WallUs, ResourcesBefore, ResourcesAfter,
                                    length(Receipts)),
    #{schema => provisional_experience_t2_evidence_v1,
      grounding => grounding_receipt(t2),
      declared_bounds => declared_bounds(),
      inputs => #{exact => ExactEvent,
                  paraphrase => ParaphraseEvent,
                  irrelevant_lexical_lure => LureEvent,
                  timestamp_arrangement =>
                      #{history_a_transformation => 900,
                        history_a_log => 100,
                        history_b_transformation => 100,
                        history_b_log => 900}},
      branches => #{history_a => #{status => AStatus,
                                   exact => AExact,
                                   paraphrase => AParaphrase,
                                   lure => ALure},
                    history_b => #{status => BStatus,
                                   exact => BExact,
                                   paraphrase => BParaphrase,
                                   lure => BLure},
                    sham_log_only => #{status => ShamStatus,
                                       exact => ShamExact,
                                       paraphrase => ShamParaphrase,
                                       lure => ShamLure}},
      comparison => Comparison,
      delivery_receipts => Receipts,
      semantic => #{verdict => verdict(SemanticPass),
                    measures => #{source_lineage_complete => LineageComplete,
                                  causal_selection_agreement =>
                                      DifferentCausal andalso ParaphraseStable,
                                  timestamp_or_lexical_contamination =>
                                      not (TimestampsSwapped andalso LureIgnored),
                                  provenance_separation => KnowledgeSeparate},
                    appraisal_boundary =>
                        structural_fixture_only_stakeholder_review_required},
      operational => #{verdict => verdict(OperationalPass),
                       expected_heads => ExpectedHeads,
                       receipt_count => length(Receipts),
                       wall_time_us => WallUs,
                       before => ResourcesBefore,
                       after_sample => ResourcesAfter,
                       queue_high_water_mark => unknown_not_instrumented,
                       external_effect_count => 0}}.

t3_case() ->
    Started = erlang:monotonic_time(microsecond),
    ResourcesBefore = resource_sample(
                        [?T3_BASELINE, ?T3_CORRECTED, ?T3_REVOKED]),
    Seed = #{message_id => t3_seed_message,
             scope => ?T3_SCOPE,
             semantic_interpretation_id => t3_semantic_context_candidate,
             os_interpretation_id => t3_os_security_candidate},
    {ok, BaselineSeedReceipt} = branch_apply(?T3_BASELINE, {seed, Seed}),
    {ok, CorrectedSeedReceipt} = branch_apply(?T3_CORRECTED, {seed, Seed}),
    {ok, RevokedSeedReceipt} = branch_apply(?T3_REVOKED, {seed, Seed}),

    Correction = #{message_id => t3_governing_correction_message,
                   correction_id => t3_sandbox_scope_correction,
                   source_event_id => stakeholder_correction_3459,
                   source_text =>
                       <<"sandbox means semantic-contextual inside BEAM, not OS-security sandbox">>,
                   scope => ?T3_SCOPE,
                   rejects_meaning => os_security_sandbox,
                   activates_meaning => semantic_context_sandbox},
    {ok, CorrectedCorrectionReceipt} =
        branch_apply(?T3_CORRECTED, {correct, Correction}),
    {ok, RevokedCorrectionReceipt} =
        branch_apply(?T3_REVOKED, {correct, Correction}),
    Revocation = #{message_id => t3_counterfactual_revocation_message,
                   correction_id => t3_sandbox_scope_correction,
                   revocation_event_id => t3_counterfactual_revocation,
                   source_text =>
                       <<"counterfactual only: revoke the sandbox correction for this scope">>},
    {ok, RevocationReceipt} = branch_apply(?T3_REVOKED,
                                           {revoke, Revocation}),

    OriginalRelapse = proposal(
                        t3_original_relapse,
                        <<"treat this sandbox as Linux and OS-security containment">>,
                        ?T3_SCOPE, os_security_sandbox, direct_proposal),
    ParaphraseRelapse = proposal(
                          t3_paraphrase_relapse,
                          <<"isolate the host kernel and filesystem for this contextual test">>,
                          ?T3_SCOPE, os_security_sandbox, paraphrase),
    GeneratedRelapse = proposal(
                         t3_generated_summary_relapse,
                         <<"regenerated summary: sandbox work here is host-security hardening">>,
                         ?T3_SCOPE, os_security_sandbox,
                         regenerated_summary),
    HostSecurityControl = proposal(
                            t3_host_security_control,
                            <<"review host isolation for an actual host-security task">>,
                            host_security_review, os_security_sandbox,
                            negative_control),
    AbstractBoundaryControl = proposal(
                                t3_abstract_boundary_control,
                                <<"compare an abstract boundary in another model">>,
                                ?T3_SCOPE, abstract_boundary,
                                negative_control),
    RevokedControl = proposal(
                       t3_revoked_control,
                       <<"counterfactual proposal after explicit revocation">>,
                       ?T3_SCOPE, os_security_sandbox,
                       revoked_negative_control),

    {ok, BaselineOriginal} = branch_apply(?T3_BASELINE,
                                   {propose, OriginalRelapse}),
    {ok, BaselineParaphrase} = branch_apply(?T3_BASELINE,
                                     {propose, ParaphraseRelapse}),
    {ok, BaselineGenerated} = branch_apply(?T3_BASELINE,
                                    {propose, GeneratedRelapse}),
    {ok, CorrectedOriginal} = branch_apply(?T3_CORRECTED,
                                    {propose, OriginalRelapse}),
    {ok, CorrectedParaphrase} = branch_apply(?T3_CORRECTED,
                                      {propose, ParaphraseRelapse}),

    CorrectedStateBeforeRestart = ctx_experience_t23_branch:snapshot(
                                    ?T3_CORRECTED),
    CorrectedPidBefore = whereis(?T3_CORRECTED),
    Monitor = monitor(process, CorrectedPidBefore),
    exit(CorrectedPidBefore, kill),
    receive
        {'DOWN', Monitor, process, CorrectedPidBefore, killed} -> ok;
        {'DOWN', Monitor, process, CorrectedPidBefore, OtherReason} ->
            error({unexpected_t3_worker_exit, OtherReason})
    after 2000 -> error(t3_worker_down_timeout)
    end,
    CorrectedPidAfter = await_new_pid(?T3_CORRECTED,
                                      CorrectedPidBefore, 2000),
    CorrectedStateAfterRestart = ctx_experience_t23_branch:snapshot(
                                   ?T3_CORRECTED),
    RehydratedEqual = CorrectedStateBeforeRestart =:=
                      CorrectedStateAfterRestart,

    {ok, CorrectedGenerated} = branch_apply(?T3_CORRECTED,
                                     {propose, GeneratedRelapse}),
    {ok, HostSecurityReceipt} = branch_apply(?T3_CORRECTED,
                                      {propose, HostSecurityControl}),
    {ok, AbstractBoundaryReceipt} = branch_apply(
                                      ?T3_CORRECTED,
                                      {propose, AbstractBoundaryControl}),
    {ok, RevokedControlReceipt} = branch_apply(?T3_REVOKED,
                                        {propose, RevokedControl}),

    BaselineStatus = status(?T3_BASELINE),
    CorrectedStatus = status(?T3_CORRECTED),
    RevokedStatus = status(?T3_REVOKED),
    {ok, CorrectedProjection} = ctx_experience_t23_branch:project(
                                  ?T3_CORRECTED,
                                  {maps:get(head_version, CorrectedStatus),
                                   ?T3_SCOPE}),
    {ok, HistoricalProjection} = ctx_experience_t23_branch:project(
                                   ?T3_CORRECTED, {1, ?T3_SCOPE}),
    {ok, HostProjection} = ctx_experience_t23_branch:project(
                             ?T3_CORRECTED,
                             {maps:get(head_version, CorrectedStatus),
                              host_security_review}),
    {ok, RevokedProjection} = ctx_experience_t23_branch:project(
                                ?T3_REVOKED,
                                {maps:get(head_version, RevokedStatus),
                                 ?T3_SCOPE}),

    CorrectedRelapseReceipts = [CorrectedOriginal, CorrectedParaphrase,
                                CorrectedGenerated],
    UnblockedRelapses = length(
                          [R || R <- CorrectedRelapseReceipts,
                                maps:get(semantic_disposition, R) =/=
                                    blocked_semantic_relapse]),
    OutOfScopeOvergeneralizations = length(
                                      [R || R <- [HostSecurityReceipt,
                                                   AbstractBoundaryReceipt],
                                            maps:get(semantic_disposition, R)
                                                =:= blocked_semantic_relapse]),
    CurrentSelected = maps:get(selected, CorrectedProjection),
    HistoricalSelected = maps:get(selected, HistoricalProjection),
    NoCanonization = maps:get(canonical_symbols, CorrectedProjection) =:= []
                     andalso maps:get(canonical, CurrentSelected) =:= false
                     andalso maps:get(canonical, HistoricalSelected) =:= false,
    LineageComplete =
        lists:all(fun(R) ->
                          maps:get(governing_correction, R) =:=
                              t3_sandbox_scope_correction andalso
                          length(maps:get(lineage, R)) =:= 2
                  end, CorrectedRelapseReceipts),
    Comparison = #{unblocked_in_scope_relapses => UnblockedRelapses,
                   out_of_scope_overgeneralizations =>
                       OutOfScopeOvergeneralizations,
                   original_blocked =>
                       disposition_is(CorrectedOriginal,
                                      blocked_semantic_relapse),
                   paraphrase_blocked =>
                       disposition_is(CorrectedParaphrase,
                                      blocked_semantic_relapse),
                   regenerated_summary_blocked_after_restart =>
                       disposition_is(CorrectedGenerated,
                                      blocked_semantic_relapse),
                   host_security_unblocked =>
                       not receipt_blocked(HostSecurityReceipt),
                   abstract_boundary_unblocked =>
                       not receipt_blocked(AbstractBoundaryReceipt),
                   revocation_honored =>
                       disposition_is(RevokedControlReceipt,
                                      unblocked_revoked_correction),
                   baseline_exposes_counterfactual_relapse =>
                       lists:all(fun(R) -> not receipt_blocked(R) end,
                                 [BaselineOriginal, BaselineParaphrase,
                                  BaselineGenerated]),
                   unauthorized_canonizations => case NoCanonization of
                                                      true -> 0;
                                                      false -> 1
                                                  end,
                   lineage_complete => LineageComplete,
                   historical_state_preserved =>
                       maps:get(meaning_key, HistoricalSelected) =:=
                           os_security_sandbox andalso
                       maps:get(meaning_key, CurrentSelected) =:=
                           semantic_context_sandbox,
                   knowledge_refs_separate =>
                       lists:all(fun(P) ->
                                         maps:get(knowledge_refs, P) =:= []
                                 end,
                                 [CorrectedProjection, HistoricalProjection,
                                  HostProjection, RevokedProjection])},
    SemanticPass = UnblockedRelapses =:= 0 andalso
                   OutOfScopeOvergeneralizations =:= 0 andalso
                   maps:get(original_blocked, Comparison) andalso
                   maps:get(paraphrase_blocked, Comparison) andalso
                   maps:get(regenerated_summary_blocked_after_restart,
                            Comparison) andalso
                   maps:get(host_security_unblocked, Comparison) andalso
                   maps:get(revocation_honored, Comparison) andalso
                   NoCanonization andalso LineageComplete andalso
                   maps:get(historical_state_preserved, Comparison) andalso
                   maps:get(knowledge_refs_separate, Comparison),
    Receipts = [BaselineSeedReceipt, CorrectedSeedReceipt,
                RevokedSeedReceipt, CorrectedCorrectionReceipt,
                RevokedCorrectionReceipt, RevocationReceipt,
                BaselineOriginal, BaselineParaphrase, BaselineGenerated,
                CorrectedOriginal, CorrectedParaphrase, CorrectedGenerated,
                HostSecurityReceipt, AbstractBoundaryReceipt,
                RevokedControlReceipt],
    ResourcesAfter = resource_sample(
                       [?T3_BASELINE, ?T3_CORRECTED, ?T3_REVOKED]),
    WallUs = erlang:monotonic_time(microsecond) - Started,
    ExpectedHeads = maps:get(head_version, BaselineStatus) =:= 4 andalso
                    maps:get(head_version, CorrectedStatus) =:= 7 andalso
                    maps:get(head_version, RevokedStatus) =:= 4,
    OperationalPass = CorrectedPidBefore =/= CorrectedPidAfter andalso
                      RehydratedEqual andalso ExpectedHeads andalso
                      length(Receipts) =:= 15 andalso
                      receipts_committed(Receipts) andalso
                      within_bounds(WallUs, ResourcesBefore, ResourcesAfter,
                                    length(Receipts)),
    #{schema => provisional_semantic_correction_t3_evidence_v1,
      grounding => grounding_receipt(t3),
      declared_bounds => declared_bounds(),
      correction_source => #{source_trajectory_ordinal => 3459,
                             current_dispatch_text =>
                                 maps:get(source_text, Correction),
                             scope => ?T3_SCOPE,
                             status => governing_in_corrected_branch},
      probes => #{original => #{baseline => BaselineOriginal,
                                corrected => CorrectedOriginal},
                  paraphrase => #{baseline => BaselineParaphrase,
                                  corrected => CorrectedParaphrase},
                  regenerated_summary =>
                      #{baseline => BaselineGenerated,
                        corrected_after_restart => CorrectedGenerated},
                  host_security_negative_control => HostSecurityReceipt,
                  abstract_boundary_negative_control =>
                      AbstractBoundaryReceipt,
                  revoked_correction_negative_control =>
                      RevokedControlReceipt},
      projections => #{historical_before_correction => HistoricalProjection,
                       corrected_current => CorrectedProjection,
                       host_security_scope => HostProjection,
                       revoked_counterfactual => RevokedProjection},
      comparison => Comparison,
      restart => #{killed_pid => CorrectedPidBefore,
                   restarted_pid => CorrectedPidAfter,
                   pid_changed => CorrectedPidBefore =/= CorrectedPidAfter,
                   state_version_before =>
                       runtime_version(t3, CorrectedStateBeforeRestart),
                   state_version_after =>
                       runtime_version(t3, CorrectedStateAfterRestart),
                   state_digest_before =>
                       erlang:phash2(CorrectedStateBeforeRestart),
                   state_digest_after =>
                       erlang:phash2(CorrectedStateAfterRestart),
                   state_rehydrated_equal => RehydratedEqual,
                   checkpoint_medium => test_local_beam_process},
      branch_status => #{baseline => BaselineStatus,
                         corrected => CorrectedStatus,
                         revoked_counterfactual => RevokedStatus},
      delivery_receipts => Receipts,
      semantic => #{verdict => verdict(SemanticPass),
                    measures => #{semantic_relapse_count =>
                                      UnblockedRelapses,
                                  out_of_scope_overgeneralization_count =>
                                      OutOfScopeOvergeneralizations,
                                  unauthorized_canonization_count =>
                                      maps:get(unauthorized_canonizations,
                                               Comparison),
                                  source_lineage_complete => LineageComplete,
                                  historical_recoverability =>
                                      maps:get(historical_state_preserved,
                                               Comparison)},
                    semantic_oracle => external_stakeholder,
                    runtime_self_judgment => not_performed,
                    status => structural_evidence_awaits_stakeholder_appraisal},
      operational => #{verdict => verdict(OperationalPass),
                       worker_restart_count => 1,
                       state_rehydrated_equal => RehydratedEqual,
                       expected_heads => ExpectedHeads,
                       receipt_count => length(Receipts),
                       wall_time_us => WallUs,
                       before => ResourcesBefore,
                       after_sample => ResourcesAfter,
                       queue_high_water_mark => unknown_not_instrumented,
                       external_effect_count => 0}}.

branch_apply(Name, Action) -> ctx_experience_t23_branch:apply(Name, Action).
status(Name) -> ctx_experience_t23_branch:status(Name).

project_at_head(Name, Status, EventId) ->
    {ok, Projection} = ctx_experience_t23_branch:project(
                         Name, {maps:get(head_version, Status), EventId}),
    Projection.

parallel_apply(Requests) ->
    Parent = self(),
    Tag = make_ref(),
    [spawn(fun() -> Parent ! {Tag, Name, branch_apply(Name, Action)} end) ||
        {Name, Action} <- Requests],
    sort_named_receipts(collect_parallel(Tag, length(Requests), [])).

collect_parallel(_Tag, 0, Acc) -> Acc;
collect_parallel(Tag, Remaining, Acc) ->
    receive
        {Tag, Name, {ok, Receipt}} ->
            collect_parallel(Tag, Remaining - 1,
                             [{Name, Receipt} | Acc]);
        {Tag, Name, Error} ->
            error({parallel_apply_failed, Name, Error})
    after 2000 -> error({parallel_apply_timeout, Remaining})
    end.

sort_named_receipts(Named) ->
    [Receipt || {_Name, Receipt} <-
                    lists:keysort(1, Named)].

selected_id(#{selected := none}) -> none;
selected_id(#{selected := Selected}) -> maps:get(id, Selected).

transformation_time(Projection) ->
    maps:get(recorded_at, maps:get(transformation, Projection)).

log_time(Projection, LogId) ->
    [Log] = [L || L <- maps:get(omitted_logs, Projection),
                  maps:get(log_id, L) =:= LogId],
    maps:get(recorded_at, Log).

lineage_kinds(Projection) ->
    [maps:get(kind, Link) || Link <- maps:get(trajectory, Projection)].

proposal(Id, Text, Scope, Meaning, Kind) ->
    #{message_id => {message_for, Id},
      proposal_id => Id,
      text => Text,
      scope => Scope,
      meaning_key => Meaning,
      artifact_kind => Kind,
      source_space => generated_artifact}.

receipt_blocked(Receipt) -> not maps:get(accepted, Receipt).
disposition_is(Receipt, Disposition) ->
    maps:get(semantic_disposition, Receipt) =:= Disposition.

receipts_committed(Receipts) ->
    lists:all(fun(R) ->
                      maps:get(sent, R) andalso maps:get(delivered, R)
                      andalso maps:get(interpreted, R)
                      andalso maps:get(committed, R)
                      andalso not maps:get(executed, R)
              end, Receipts).

await_new_pid(Name, OldPid, TimeoutMs) ->
    Deadline = erlang:monotonic_time(millisecond) + TimeoutMs,
    await_new_pid_loop(Name, OldPid, Deadline).

await_new_pid_loop(Name, OldPid, Deadline) ->
    case whereis(Name) of
        Pid when is_pid(Pid), Pid =/= OldPid -> Pid;
        _ ->
            case erlang:monotonic_time(millisecond) >= Deadline of
                true -> error({worker_restart_timeout, Name});
                false -> timer:sleep(10),
                         await_new_pid_loop(Name, OldPid, Deadline)
            end
    end.

runtime_version(t3, Runtime) -> ctx_semantic_correction_t3:head_version(Runtime).

resource_sample(Names) ->
    Statuses = [status(Name) || Name <- Names],
    Counts = supervisor:count_children(ctx_experience_t23_sup),
    #{sampled_actors => proplists:get_value(active, Counts) + 1,
      worker_memory_bytes => lists:sum(
                               [maps:get(process_memory_bytes, S) ||
                                   S <- Statuses]),
      sampled_queue_total => lists:sum(
                               [maps:get(message_queue_len, S) ||
                                   S <- Statuses]),
      sampled_queue_max => lists:max(
                             [maps:get(message_queue_len, S) ||
                                 S <- Statuses])}.

within_bounds(WallUs, Before, After, MessageCount) ->
    MemoryDelta = maps:get(worker_memory_bytes, After) -
                  maps:get(worker_memory_bytes, Before),
    WallUs =< 30000000 andalso
    maps:get(sampled_actors, After) =< 12 andalso
    MessageCount =< 512 andalso
    MemoryDelta =< 64 * 1024 * 1024.

declared_bounds() ->
    #{max_ephemeral_actors => 12,
      max_messages_or_semantic_events => 512,
      max_wall_time_us => 30000000,
      max_sampled_worker_memory_growth_bytes => 64 * 1024 * 1024,
      external_actions => forbidden,
      governing_state_writes => forbidden}.

verdict(true) -> pass;
verdict(false) -> fail.

grounding_receipt(Test) ->
    #{schema => provisional_regrounding_receipt_v1,
      proposed_step => Test,
      checkpoint_method => operator_source_reread_and_semantic_comparison,
      automated_source_retrieval_claim => false,
      selected_original_events =>
          [#{trajectory => original,
             source_file =>
                 <<"rollout-2026-09-04T12-43-03-01a06d16-75ed-7982-be05-7d047229f423.jsonl">>,
             ordinals => [1719, 1745]},
           #{trajectory => continuation,
             source_file =>
                 <<"rollout-2026-09-04T14-51-04-01a06d8b-a8d3-7e60-9072-0a30b93aa2bf.jsonl">>,
             ordinals => [3089, 3459, 3550]},
           #{trajectory => current_dispatch,
             authority => latest_user_instruction}],
      derived_artifacts_compared =>
          [#{path => <<"work/consolidated-specification.md">>,
             version => <<"0.13">>,
             sha256 =>
                 <<"678efd6f017e2b0aa7235beffb2f4469875c21a37100fbdedcae7a70873230c1">>},
           #{path => <<"work/experience-test-program.md">>,
             version => <<"0.1">>,
             sha256 =>
                 <<"c93f5b606a7e88e8b2768bc1a4f40b72e95ee41bcb07945c856b5d9e6c67b6d9">>},
           #{path => <<"outputs/daybreak-live-experience-slice-report.md">>,
             status => historical_derived_artifact,
             sha256 =>
                 <<"2bd175ad7a6487a50aafdaa805af4d8290638d81660c3cfd8523c4bbe0e03e28">>}],
      conflict_disposition =>
          #{conflict => old_program_t2_t3_numbering_differs_from_current_dispatch,
            resolution => latest_user_dispatch_governs_t2_t3_only,
            later_program_tests_unchanged => true},
      exclusions => [os_or_network_action, universal_semantic_canonization,
                     runtime_self_acceptance],
      disposition => proceed_bounded_structural_test,
      authority_effect => no_external_action_authorized}.
