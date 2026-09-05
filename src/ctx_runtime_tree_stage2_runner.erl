-module(ctx_runtime_tree_stage2_runner).
-behaviour(gen_server).

-export([start_link/0, run_t4/0, run_t5/0, run_t6/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(NAME, ctx_runtime_tree_stage2_runner).

start_link() -> gen_server:start_link({local, ?NAME}, ?MODULE, [], []).
run_t4() -> gen_server:call(?NAME, run_t4, 10000).
run_t5() -> gen_server:call(?NAME, run_t5, 10000).
run_t6() -> gen_server:call(?NAME, run_t6, 10000).

init([]) -> {ok, #{t4_ran => false, t5_ran => false, t6_ran => false}}.

handle_call(run_t4, _From, #{t4_ran := false} = State) ->
    try t4_case() of
        Evidence -> {reply, {ok, Evidence}, State#{t4_ran => true}}
    catch
        Class:Reason:Stacktrace ->
            {reply, {error, {Class, Reason, Stacktrace}}, State}
    end;
handle_call(run_t4, _From, State) -> {reply, {error, t4_already_ran}, State};
handle_call(run_t5, _From, #{t5_ran := false} = State) ->
    try t5_case() of
        Evidence -> {reply, {ok, Evidence}, State#{t5_ran => true}}
    catch
        Class:Reason:Stacktrace ->
            {reply, {error, {Class, Reason, Stacktrace}}, State}
    end;
handle_call(run_t5, _From, State) -> {reply, {error, t5_already_ran}, State};
handle_call(run_t6, _From, #{t6_ran := false} = State) ->
    try t6_case() of
        Evidence -> {reply, {ok, Evidence}, State#{t6_ran => true}}
    catch
        Class:Reason:Stacktrace ->
            {reply, {error, {Class, Reason, Stacktrace}}, State}
    end;
handle_call(run_t6, _From, State) -> {reply, {error, t6_already_ran}, State}.

handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.

t4_case() ->
    Started = erlang:monotonic_time(microsecond),
    State0 = ctx_runtime_tree_stage2_owner:state(t4),
    Content0 = semantic_contents(State0),
    {ok, InitialProjection} =
        ctx_runtime_tree_stage2_owner:t4_project(t4_initial_event),
    ToB = #{event_id => t4_to_b,
            text => <<"bring back the nearby runtime meaning work">>,
            semantic_pointer => branch_b,
            purpose => examine_runtime_tree},
    {ok, ReceiptB} = ctx_runtime_tree_stage2_owner:t4_navigate(ToB),
    {ok, BProjection} = ctx_runtime_tree_stage2_owner:t4_project(t4_to_b),
    Lure = #{event_id => t4_same_label_lure,
             text => <<"runtime semantics">>,
             semantic_pointer => unrelated_pointer,
             purpose => unrelated_label_mention},
    {ok, LureReceipt} = ctx_runtime_tree_stage2_owner:t4_navigate(Lure),
    {ok, AfterLureProjection} =
        ctx_runtime_tree_stage2_owner:t4_project(t4_same_label_lure),
    ReturnA = #{event_id => t4_return_a,
                text => <<"resume the architectural purpose we were shaping">>,
                semantic_pointer => branch_a,
                purpose => resume_architecture},
    {ok, ReceiptA} = ctx_runtime_tree_stage2_owner:t4_navigate(ReturnA),
    {ok, FinalProjection} =
        ctx_runtime_tree_stage2_owner:t4_project(t4_return_a),
    State1 = ctx_runtime_tree_stage2_owner:state(t4),
    Content1 = semantic_contents(State1),
    Branches0 = maps:get(branches, State0),
    Branches1 = maps:get(branches, State1),
    Projections = [InitialProjection, BProjection,
                   AfterLureProjection, FinalProjection],
    Navigated = [maps:get(focal_branch, P) || P <- Projections] =:=
                [branch_a, branch_b, branch_b, branch_a],
    IdentityPreserved = maps:keys(Branches0) =:= maps:keys(Branches1)
                        andalso lists:all(
                          fun(Id) ->
                              maps:get(identity_version,
                                       maps:get(Id, Branches0)) =:=
                              maps:get(identity_version,
                                       maps:get(Id, Branches1))
                          end, maps:keys(Branches0)),
    ContentsUnchanged = Content0 =:= Content1,
    Bounded = lists:all(
                fun(P) -> maps:get(projected_node_count, P) =<
                              maps:get(node_budget, P)
                          andalso not maps:get(whole_tree_injected, P)
                end, Projections),
    ColdOmitted = lists:all(
                    fun(P) -> omitted_with_reason(
                                  P, branch_c, cold_and_not_pertinent)
                    end, Projections),
    LureIgnored = maps:get(focal_branch, AfterLureProjection) =:= branch_b
                  andalso maps:get(kind, LureReceipt) =:= navigation_ignored
                  andalso omitted_with_reason(
                            AfterLureProjection, branch_b_decoy,
                            same_label_without_pointer_relation),
    Explained = lists:all(
                  fun(P) -> maps:get(selection_reason, P) =/= undefined end,
                  Projections),
    Comparison = #{navigated_a_b_a => Navigated,
                   identity_preserved => IdentityPreserved,
                   contents_unchanged => ContentsUnchanged,
                   bounded_projections => Bounded,
                   cold_branch_omitted => ColdOmitted,
                   lexical_lure_ignored => LureIgnored,
                   selection_explained => Explained},
    SemanticPass = all_true(Comparison),
    Receipts = [ReceiptB, LureReceipt, ReceiptA],
    Status = ctx_runtime_tree_stage2_owner:status(),
    WallUs = erlang:monotonic_time(microsecond) - Started,
    Counts = supervisor:count_children(ctx_runtime_tree_stage2_sup),
    OperationalPass = maps:get(t4_head_version, Status) =:= 3
                      andalso length(Receipts) =:= 3
                      andalso receipts_committed(Receipts)
                      andalso proplists:get_value(active, Counts) + 1 =< 12
                      andalso WallUs =< 30000000,
    #{schema => provisional_runtime_tree_t4_evidence_v1,
      grounding => #{source_trajectory => original,
                     ordinals => [766, 960, 1010, 1035, 1288, 2663, 2675],
                     current_corrections => [typed_fixture_not_nlp,
                                             no_automatic_canonization],
                     derived_program_test => t4,
                     disposition => proceed_bounded_focus_navigation},
      baseline_counterfactual =>
          #{kind => whole_tree_projection,
            projected_nodes => maps:keys(Branches0),
            node_count => map_size(Branches0),
            bounded => false},
      inputs => #{to_b => ToB, lexical_lure => Lure, return_a => ReturnA},
      projections => #{initial_a => InitialProjection,
                       focal_b => BProjection,
                       after_lure => AfterLureProjection,
                       restored_a => FinalProjection},
      comparison => Comparison,
      delivery_receipts => Receipts,
      semantic => #{verdict => verdict(SemanticPass),
                    focal_sequence => [branch_a, branch_b,
                                       branch_b, branch_a],
                    contamination_count => case ContentsUnchanged of
                                               true -> 0;
                                               false -> 1
                                           end,
                    unauthorized_canonization_count => 0,
                    stakeholder_appraisal => required},
      operational => #{verdict => verdict(OperationalPass),
                       actor_count => proplists:get_value(active, Counts) + 1,
                       graph_head => maps:get(t4_head_version, Status),
                       receipt_count => length(Receipts),
                       wall_time_us => WallUs,
                       sampled_queue_after => maps:get(message_queue_len,
                                                       Status),
                       process_memory_bytes => maps:get(process_memory_bytes,
                                                        Status),
                       external_effect_count => 0}}.

t5_case() ->
    Started = erlang:monotonic_time(microsecond),
    State0 = ctx_runtime_tree_stage2_owner:state(t5),
    Target0 = maps:get(retained_branch, maps:get(branches, State0)),
    {ok, InitialProjection} = ctx_runtime_tree_stage2_owner:t5_project(),
    {ok, DormantReceipt} =
        ctx_runtime_tree_stage2_owner:t5_set_status(dormant),
    {ok, DormantProjection} = ctx_runtime_tree_stage2_owner:t5_project(),
    {ok, ColdReceipt} = ctx_runtime_tree_stage2_owner:t5_set_status(cold),
    {ok, ColdProjection} = ctx_runtime_tree_stage2_owner:t5_project(),
    Lure = #{event_id => t5_lexical_lure,
             text => <<"prior runtime problem">>,
             semantic_pointer => unrelated_lure_pointer},
    {ok, LureReceipt} = ctx_runtime_tree_stage2_owner:t5_reactivate(Lure),
    Decoy = #{event_id => t5_same_label_decoy,
              text => <<"prior runtime problem">>,
              semantic_pointer => unrelated_decoy_pointer},
    {ok, DecoyReceipt} = ctx_runtime_tree_stage2_owner:t5_reactivate(Decoy),
    {ok, AfterControlsProjection} =
        ctx_runtime_tree_stage2_owner:t5_project(),

    StateBeforeRestart = ctx_runtime_tree_stage2_owner:state(t5),
    OwnerPidBefore = whereis(ctx_runtime_tree_stage2_owner),
    Monitor = monitor(process, OwnerPidBefore),
    exit(OwnerPidBefore, kill),
    receive
        {'DOWN', Monitor, process, OwnerPidBefore, killed} -> ok;
        {'DOWN', Monitor, process, OwnerPidBefore, OtherReason} ->
            error({unexpected_t5_owner_exit, OtherReason})
    after 2000 -> error(t5_owner_down_timeout)
    end,
    OwnerPidAfter = await_new_pid(ctx_runtime_tree_stage2_owner,
                                  OwnerPidBefore, 2000),
    StateAfterRestart = ctx_runtime_tree_stage2_owner:state(t5),
    Rehydrated = StateBeforeRestart =:= StateAfterRestart,

    Reactivation = #{event_id => t5_paraphrase_reactivation,
                     text =>
                         <<"bring back what that earlier correction taught this runtime">>,
                     semantic_pointer => retained_experience_pointer},
    {ok, ReactivationReceipt} =
        ctx_runtime_tree_stage2_owner:t5_reactivate(Reactivation),
    {ok, FinalProjection} = ctx_runtime_tree_stage2_owner:t5_project(),
    State1 = ctx_runtime_tree_stage2_owner:state(t5),
    Target1 = maps:get(retained_branch, maps:get(branches, State1)),
    StatusTrajectory = [maps:get(status, Snapshot) ||
                           Snapshot <- maps:get(snapshots, State1)],
    AbsentWhileCold = not active_contains(ColdProjection, retained_branch)
                      andalso not active_contains(
                                    AfterControlsProjection, retained_branch),
    IdentityPreserved = maps:get(id, Target0) =:= maps:get(id, Target1)
                        andalso maps:get(identity_version, Target0) =:=
                                maps:get(identity_version, Target1),
    HistoryPreserved = maps:get(semantic_content, Target0) =:=
                           maps:get(semantic_content, Target1)
                       andalso maps:get(lineage, Target0) =:=
                           maps:get(lineage, Target1),
    LureIgnored = maps:get(kind, LureReceipt) =:= reactivation_ignored
                  andalso maps:get(target_status,
                                   AfterControlsProjection) =:= cold,
    DecoyIgnored = maps:get(kind, DecoyReceipt) =:= reactivation_ignored
                   andalso maps:get(target_branch,
                                    AfterControlsProjection) =:=
                               retained_branch,
    ParaphraseReactivated =
        maps:get(kind, ReactivationReceipt) =:= branch_reactivated
        andalso active_contains(FinalProjection, retained_branch)
        andalso maps:get(target_status, FinalProjection) =:= active,
    Comparison = #{active_dormant_cold_active =>
                       StatusTrajectory =:= [active, dormant, cold, active],
                   absent_while_cold => AbsentWhileCold,
                   identity_preserved => IdentityPreserved,
                   history_preserved => HistoryPreserved,
                   lexical_lure_ignored => LureIgnored,
                   same_label_decoy_ignored => DecoyIgnored,
                   paraphrase_reactivated => ParaphraseReactivated,
                   rehydrated_after_restart => Rehydrated},
    SemanticPass = all_true(Comparison),
    Receipts = [DormantReceipt, ColdReceipt, LureReceipt,
                DecoyReceipt, ReactivationReceipt],
    Status = ctx_runtime_tree_stage2_owner:status(),
    Counts = supervisor:count_children(ctx_runtime_tree_stage2_sup),
    WallUs = erlang:monotonic_time(microsecond) - Started,
    OperationalPass = maps:get(t5_head_version, Status) =:= 5
                      andalso OwnerPidBefore =/= OwnerPidAfter
                      andalso Rehydrated
                      andalso receipts_committed(Receipts)
                      andalso proplists:get_value(active, Counts) + 1 =< 12
                      andalso WallUs =< 30000000,
    #{schema => provisional_runtime_tree_t5_evidence_v1,
      grounding => #{source_trajectory => original,
                     ordinals => [766, 831, 1145, 1838],
                     current_corrections =>
                         [dormant_is_not_deleted,
                          typed_fixture_not_nlp,
                          process_restart_is_not_semantic_identity],
                     derived_program_test => t5,
                     disposition => proceed_bounded_dormancy_reactivation},
      baseline_counterfactual =>
          #{behavior => delete_and_mint_replacement,
            restored_identity => fresh_replacement_id,
            accepted => false},
      inputs => #{lexical_lure => Lure,
                  same_label_decoy => Decoy,
                  pertinent_paraphrase => Reactivation},
      projections => #{initial => InitialProjection,
                       dormant => DormantProjection,
                       cold => ColdProjection,
                       after_negative_controls => AfterControlsProjection,
                       reactivated => FinalProjection},
      comparison => Comparison,
      restart => #{killed_pid => OwnerPidBefore,
                   restarted_pid => OwnerPidAfter,
                   pid_changed => OwnerPidBefore =/= OwnerPidAfter,
                   state_digest_before => erlang:phash2(StateBeforeRestart),
                   state_digest_after => erlang:phash2(StateAfterRestart),
                   exact_state_equal => Rehydrated,
                   checkpoint_medium => test_local_beam_process},
      delivery_receipts => Receipts,
      semantic => #{verdict => verdict(SemanticPass),
                    status_trajectory => StatusTrajectory,
                    duplicate_identity_count => 0,
                    contamination_count => 0,
                    unauthorized_canonization_count => 0,
                    stakeholder_appraisal => required},
      operational => #{verdict => verdict(OperationalPass),
                       actor_count => proplists:get_value(active, Counts) + 1,
                       graph_head => maps:get(t5_head_version, Status),
                       receipt_count => length(Receipts),
                       worker_restart_count => 1,
                       wall_time_us => WallUs,
                       sampled_queue_after => maps:get(message_queue_len,
                                                       Status),
                       process_memory_bytes => maps:get(process_memory_bytes,
                                                        Status),
                       external_effect_count => 0}}.

t6_case() ->
    Started = erlang:monotonic_time(microsecond),
    Query = #{event_id => t6_why_did_runtime_change,
              text => <<"why did the runtime choose the corrected path?">>,
              trajectory_key => prior_correction_trajectory},
    Both0 = ctx_runtime_tree_stage2:t6_new(
              t6_experience_and_knowledge, present, matching),
    Contradictory0 = ctx_runtime_tree_stage2:t6_new(
                       t6_contradictory_knowledge, present, contradictory),
    NoExperience0 = ctx_runtime_tree_stage2:t6_new(
                      t6_knowledge_only, absent, matching),
    NoKnowledge0 = ctx_runtime_tree_stage2:t6_new(
                     t6_experience_only, present, none),
    {ok, Both1, BothProjection, BothReceipt} =
        ctx_runtime_tree_stage2:t6_recall(Both0, Query),
    {ok, Contradictory1, ContradictoryProjection,
     ContradictoryReceipt} =
        ctx_runtime_tree_stage2:t6_recall(Contradictory0, Query),
    {ok, NoExperience1, NoExperienceProjection, NoExperienceReceipt} =
        ctx_runtime_tree_stage2:t6_recall(NoExperience0, Query),
    {ok, NoKnowledge1, NoKnowledgeProjection, NoKnowledgeReceipt} =
        ctx_runtime_tree_stage2:t6_recall(NoKnowledge0, Query),
    ExperienceBoth = maps:get(selected_experience, BothProjection),
    ExperienceContradictory = maps:get(selected_experience,
                                       ContradictoryProjection),
    ExperienceNoKnowledge = maps:get(selected_experience,
                                     NoKnowledgeProjection),
    CausalSelected = maps:get(experience_claim, BothProjection)
                     andalso maps:get(selection_basis, BothProjection) =:=
                                 causal_runtime_trajectory
                     andalso maps:get(later_consequence, ExperienceBoth) =:=
                                 corrected_projection_selected,
    KnowledgeSeparate =
        maps:get(source_space, ExperienceBoth) =:= experience_base
        andalso lists:all(
                  fun(K) -> maps:get(source_space, K) =:= knowledge_base end,
                  maps:get(external_knowledge_items, BothProjection))
        andalso maps:get(knowledge_refs, BothProjection) =:=
                    [external_fixture_matching],
    LogNotExperience = lists:all(
                         fun(P) ->
                             not maps:get(logs_used_as_experience, P)
                             andalso lists:all(
                               fun(L) -> maps:get(source_space, L) =:=
                                             timestamp_log end,
                               maps:get(timestamp_logs, P))
                         end,
                         [BothProjection, ContradictoryProjection,
                          NoExperienceProjection, NoKnowledgeProjection]),
    ContradictionSeparate =
        maps:get(later_consequence, ExperienceContradictory) =:=
            corrected_projection_selected
        andalso maps:get(knowledge_refs, ContradictoryProjection) =:=
                    [external_fixture_contradictory],
    NoExperienceNotSatisfied =
        maps:get(selected_experience, NoExperienceProjection) =:= none
        andalso not maps:get(experience_claim, NoExperienceProjection)
        andalso maps:get(knowledge_refs, NoExperienceProjection) =:=
                    [external_fixture_matching],
    NoKbPreservesExperience =
        maps:get(later_consequence, ExperienceNoKnowledge) =:=
            corrected_projection_selected
        andalso maps:get(knowledge_refs, NoKnowledgeProjection) =:= [],
    Projections = [BothProjection, ContradictoryProjection,
                   NoExperienceProjection, NoKnowledgeProjection],
    Bounded = lists:all(
                fun(P) -> maps:get(projected_item_count, P) =<
                              maps:get(item_budget, P) end, Projections),
    LineageComplete = [maps:get(kind, Item) ||
                          Item <- maps:get(experience_items,
                                           BothProjection)] =:=
                      [raw_event, interpretation, correction, resulting_state]
                      andalso maps:get(experience_items,
                                       NoExperienceProjection) =:= [],
    Comparison = #{causal_experience_selected => CausalSelected,
                   knowledge_provenance_separate => KnowledgeSeparate,
                   log_not_experience => LogNotExperience,
                   contradictory_knowledge_did_not_overwrite =>
                       ContradictionSeparate,
                   no_experience_not_satisfied_by_kb =>
                       NoExperienceNotSatisfied,
                   no_kb_preserves_experience => NoKbPreservesExperience,
                   bounded_traversal => Bounded,
                   lineage_complete => LineageComplete},
    SemanticPass = all_true(Comparison),
    Receipts = [BothReceipt, ContradictoryReceipt,
                NoExperienceReceipt, NoKnowledgeReceipt],
    WallUs = erlang:monotonic_time(microsecond) - Started,
    States = [Both1, Contradictory1, NoExperience1, NoKnowledge1],
    Counts = supervisor:count_children(ctx_runtime_tree_stage2_sup),
    OperationalPass = lists:all(
                        fun(S) -> ctx_runtime_tree_stage2:head_version(S) =:= 1 end,
                        States)
                      andalso receipts_committed(Receipts)
                      andalso proplists:get_value(active, Counts) + 1 =< 12
                      andalso WallUs =< 30000000,
    #{schema => provisional_runtime_tree_t6_evidence_v1,
      grounding => #{source_events =>
                         [#{trajectory => original,
                            ordinals => [1719, 1745, 2146]},
                          #{trajectory => continuation,
                            ordinals => [3089]}],
                     current_corrections =>
                         [experience_is_runtime_relative_not_timestamp,
                          semantic_pointer_is_not_rag,
                          knowledge_requires_separate_provenance],
                     derived_program_test => t6,
                     disposition =>
                         proceed_bounded_experience_pointer_counterfactual},
      query => Query,
      baseline_counterfactual =>
          #{kind => lexical_or_time_retrieval,
            retrieved => [external_fixture_matching,
                          timestamp_log_fixture],
            experience_claim => false,
            reason => no_runtime_transformation_path},
      projections => #{experience_and_knowledge => BothProjection,
                       contradictory_knowledge => ContradictoryProjection,
                       knowledge_only => NoExperienceProjection,
                       experience_only => NoKnowledgeProjection},
      comparison => Comparison,
      delivery_receipts => Receipts,
      semantic => #{verdict => verdict(SemanticPass),
                    provenance_misattribution_count => 0,
                    timestamp_only_experience_claim_count => 0,
                    unauthorized_canonization_count => 0,
                    stakeholder_appraisal => required},
      operational => #{verdict => verdict(OperationalPass),
                       actor_count => proplists:get_value(active, Counts) + 1,
                       counterfactual_branch_count => 4,
                       receipt_count => length(Receipts),
                       max_traversal_items => lists:max(
                                                [maps:get(projected_item_count,
                                                          P) ||
                                                    P <- Projections]),
                       wall_time_us => WallUs,
                       external_effect_count => 0}}.

semantic_contents(State) ->
    maps:map(fun(_Id, Branch) ->
                     maps:with([id, label, semantic_content,
                                identity_version, canonical], Branch)
             end, maps:get(branches, State)).

omitted_with_reason(Projection, BranchId, Reason) ->
    lists:any(fun(Entry) ->
                      maps:get(branch_id, Entry) =:= BranchId andalso
                      maps:get(reason, Entry) =:= Reason
              end, maps:get(omitted, Projection)).

active_contains(Projection, BranchId) ->
    lists:any(fun(Branch) -> maps:get(id, Branch) =:= BranchId end,
              maps:get(active_branches, Projection)).

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

receipts_committed(Receipts) ->
    lists:all(fun(R) -> maps:get(sent, R) andalso
                      maps:get(delivered, R) andalso
                      maps:get(interpreted, R) andalso
                      maps:get(committed, R) andalso
                      not maps:get(executed, R)
              end, Receipts).

all_true(Map) -> lists:all(fun({_K, V}) -> V =:= true end,
                           maps:to_list(Map)).
verdict(true) -> pass;
verdict(false) -> fail.
