-module(ctx_runtime_tree_stage3_runner).
-behaviour(gen_server).

-export([start_link/0, run_t7/0, run_t8/0, run_t9/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(NAME, ctx_runtime_tree_stage3_runner).

start_link() -> gen_server:start_link({local, ?NAME}, ?MODULE, [], []).
run_t7() -> gen_server:call(?NAME, run_t7, 10000).
run_t8() -> gen_server:call(?NAME, run_t8, 10000).
run_t9() -> gen_server:call(?NAME, run_t9, 10000).

init([]) -> {ok, #{t7_ran => false, t8_ran => false, t9_ran => false}}.

handle_call(run_t7, _From, #{t7_ran := false} = State) ->
    try t7_case() of
        Evidence -> {reply, {ok, Evidence}, State#{t7_ran => true}}
    catch
        Class:Reason:Stacktrace ->
            {reply, {error, {Class, Reason, Stacktrace}}, State}
    end;
handle_call(run_t7, _From, State) ->
    {reply, {error, t7_already_ran}, State};
handle_call(run_t8, _From, #{t8_ran := false} = State) ->
    try t8_case() of
        Evidence -> {reply, {ok, Evidence}, State#{t8_ran => true}}
    catch
        Class:Reason:Stacktrace ->
            {reply, {error, {Class, Reason, Stacktrace}}, State}
    end;
handle_call(run_t8, _From, State) ->
    {reply, {error, t8_already_ran}, State};
handle_call(run_t9, _From, #{t9_ran := false} = State) ->
    try t9_case() of
        Evidence -> {reply, {ok, Evidence}, State#{t9_ran => true}}
    catch
        Class:Reason:Stacktrace ->
            {reply, {error, {Class, Reason, Stacktrace}}, State}
    end;
handle_call(run_t9, _From, State) ->
    {reply, {error, t9_already_ran}, State}.

handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.

t7_case() ->
    Started = erlang:monotonic_time(microsecond),
    ok = ctx_runtime_tree_stage3_interlocutor:reset(),
    ok = ctx_runtime_tree_stage3_planner:reset(),
    InitialProjection = ctx_runtime_tree_stage3_interlocutor:projection(),
    Assignment = #{id => t7_adjacent_plan,
                   purpose => prepare_adjacent_runtime_option,
                   scope => background_branch_only,
                   source_graph_version => maps:get(graph_version,
                                                    InitialProjection),
                   source_projection => InitialProjection,
                   budget => #{max_artifacts => 1,
                               max_wall_time_ms => 1000},
                   authority => propose_only},
    {ok, AssignmentReceipt} =
        ctx_runtime_tree_stage3_planner:begin_assignment(Assignment),
    PendingStatus = ctx_runtime_tree_stage3_planner:status(),
    UserStarted = erlang:monotonic_time(microsecond),
    UserEvent = #{event_id => t7_new_user_intervention,
                  text => <<"keep the current intervention focal">>,
                  focus => current_user_intervention,
                  source => original_stakeholder_event},
    {ok, UserReceipt} =
        ctx_runtime_tree_stage3_interlocutor:user_event(UserEvent),
    ForegroundLatencyUs = erlang:monotonic_time(microsecond) - UserStarted,
    ProjectionBeforePlanReturn =
        ctx_runtime_tree_stage3_interlocutor:projection(),
    ArtifactSpec = #{artifact_id => t7_urgent_fluent_plan,
                     value => <<"urgent and fluent adjacent proposal">>},
    {ok, Artifact, PlanReceipt} =
        ctx_runtime_tree_stage3_planner:complete_assignment(
          t7_adjacent_plan, ArtifactSpec),
    {ok, StoreReceipt} =
        ctx_runtime_tree_stage3_interlocutor:store_artifact(Artifact),
    ProjectionAfterPlanReturn =
        ctx_runtime_tree_stage3_interlocutor:projection(),
    StoredState = ctx_runtime_tree_stage3_interlocutor:state(),
    StoredArtifact = maps:get(t7_urgent_fluent_plan,
                              maps:get(artifacts, StoredState)),
    PendingWhileUserArrived =
        maps:get(running, PendingStatus) =/= none,
    FocusAdvancedBeforePlan =
        maps:get(focus, ProjectionBeforePlanReturn) =:=
            current_user_intervention andalso
        maps:get(graph_version, ProjectionBeforePlanReturn) =:= 1,
    PlanProvisional =
        maps:get(status, StoredArtifact) =:= provisional andalso
        maps:get(governing_effect, StoredArtifact) =:= none andalso
        maps:get(canonical, StoredArtifact) =:= false,
    FocalUnchanged =
        focal_semantics(ProjectionBeforePlanReturn) =:=
            focal_semantics(ProjectionAfterPlanReturn),
    SourceVersionPreserved =
        maps:get(source_graph_version, StoredArtifact) =:= 0 andalso
        maps:get(graph_version, ProjectionAfterPlanReturn) =:= 1,
    NewUserProximal =
        maps:get(proximal_event, ProjectionAfterPlanReturn) =:=
            t7_new_user_intervention,
    Comparison =
        #{user_event_processed_while_planner_pending =>
              PendingWhileUserArrived,
          focus_advanced_before_plan_return => FocusAdvancedBeforePlan,
          plan_remained_provisional => PlanProvisional,
          focal_unchanged_by_plan_return => FocalUnchanged,
          source_version_preserved => SourceVersionPreserved,
          new_user_event_proximal => NewUserProximal},
    SemanticPass = all_true(Comparison),
    Counts = supervisor:count_children(ctx_runtime_tree_stage3_sup),
    Receipts = [AssignmentReceipt, UserReceipt, PlanReceipt, StoreReceipt],
    OperationalPass =
        receipts_delivered(Receipts) andalso
        ForegroundLatencyUs =< 1000000 andalso
        proplists:get_value(active, Counts) + 1 =< 10,
    #{schema => provisional_runtime_tree_t7_evidence_v1,
      grounding =>
          #{source_trajectory => original,
            ordinals => [831, 1010, 1342, 2663, 2675],
            current_corrections =>
                [background_is_provisional,
                 proximal_user_event_governs,
                 purpose_focus_and_scope_are_not_identical],
            derived_program_test => t7,
            disposition => proceed_bounded_interlocution_priority},
      baseline_counterfactual =>
          #{behavior => planner_result_silently_replaces_focus,
            accepted => false},
      assignment => Assignment,
      user_event => UserEvent,
      artifact => StoredArtifact,
      projections =>
          #{before_assignment => InitialProjection,
            user_before_plan_return => ProjectionBeforePlanReturn,
            after_plan_return => ProjectionAfterPlanReturn},
      comparison => Comparison,
      delivery_receipts => Receipts,
      semantic =>
          #{verdict => verdict(SemanticPass),
            governing_event => t7_new_user_intervention,
            contamination_count => bool_count(not FocalUnchanged),
            unauthorized_canonization_count => 0,
            stakeholder_appraisal => required},
      operational =>
          #{verdict => verdict(OperationalPass),
            actor_count => proplists:get_value(active, Counts) + 1,
            foreground_latency_us => ForegroundLatencyUs,
            wall_time_us => erlang:monotonic_time(microsecond) - Started,
            receipt_count => length(Receipts),
            external_effect_count => 0}}.

t8_case() ->
    Started = erlang:monotonic_time(microsecond),
    ok = ctx_runtime_tree_stage3_interlocutor:reset(),
    ok = ctx_runtime_tree_stage3_planner:reset(),
    InitialProjection = ctx_runtime_tree_stage3_interlocutor:projection(),
    UserEvent = #{event_id => t8_current_focal_event,
                  text => <<"evaluate a nearby prepared option">>,
                  focus => bounded_artifact_appraisal,
                  source => original_stakeholder_event},
    {ok, UserReceipt} =
        ctx_runtime_tree_stage3_interlocutor:user_event(UserEvent),
    FocalBeforeProduction =
        ctx_runtime_tree_stage3_interlocutor:projection(),
    SharedText = <<"prepared option with the same lexical surface">>,

    StaleAssignment =
        #{id => t8_stale_assignment,
          purpose => prepare_nearby_option,
          scope => background_branch_only,
          source_graph_version => 0,
          source_projection => InitialProjection,
          budget => #{max_artifacts => 1},
          authority => propose_only},
    {ok, StaleAssignmentReceipt} =
        ctx_runtime_tree_stage3_planner:begin_assignment(StaleAssignment),
    {ok, StaleArtifact, StalePlanReceipt} =
        ctx_runtime_tree_stage3_planner:complete_assignment(
          t8_stale_assignment,
          #{artifact_id => t8_stale_artifact, value => SharedText}),
    {ok, StaleStoreReceipt} =
        ctx_runtime_tree_stage3_interlocutor:store_artifact(StaleArtifact),
    ProjectionAfterStaleProduction =
        ctx_runtime_tree_stage3_interlocutor:projection(),
    {ok, StaleAppraisalReceipt} =
        ctx_runtime_tree_stage3_interlocutor:appraise(
          t8_stale_artifact, promote),
    ProjectionAfterStaleAppraisal =
        ctx_runtime_tree_stage3_interlocutor:projection(),

    CurrentAssignment =
        #{id => t8_current_assignment,
          purpose => prepare_nearby_option,
          scope => background_branch_only,
          source_graph_version => 1,
          source_projection => FocalBeforeProduction,
          budget => #{max_artifacts => 1},
          authority => propose_only},
    {ok, CurrentAssignmentReceipt} =
        ctx_runtime_tree_stage3_planner:begin_assignment(CurrentAssignment),
    {ok, CurrentArtifact, CurrentPlanReceipt} =
        ctx_runtime_tree_stage3_planner:complete_assignment(
          t8_current_assignment,
          #{artifact_id => t8_current_artifact, value => SharedText}),
    {ok, CurrentStoreReceipt} =
        ctx_runtime_tree_stage3_interlocutor:store_artifact(CurrentArtifact),
    ProjectionBeforePromotion =
        ctx_runtime_tree_stage3_interlocutor:projection(),
    {ok, PromotionReceipt} =
        ctx_runtime_tree_stage3_interlocutor:appraise(
          t8_current_artifact, promote),
    ProjectionAfterPromotion =
        ctx_runtime_tree_stage3_interlocutor:projection(),
    FinalState = ctx_runtime_tree_stage3_interlocutor:state(),
    Artifacts = maps:get(artifacts, FinalState),
    StoredStale = maps:get(t8_stale_artifact, Artifacts),
    StoredCurrent = maps:get(t8_current_artifact, Artifacts),
    BeforeProductionSemantics = focal_semantics(FocalBeforeProduction),
    ProductionDidNotChange =
        BeforeProductionSemantics =:=
            focal_semantics(ProjectionAfterStaleProduction) andalso
        BeforeProductionSemantics =:=
            focal_semantics(ProjectionBeforePromotion),
    StaleNotPromoted =
        maps:get(status, StoredStale) =:= stale andalso
        maps:get(governing_effect, StoredStale) =:= none andalso
        focal_semantics(ProjectionAfterStaleProduction) =:=
            focal_semantics(ProjectionAfterStaleAppraisal),
    Relations = maps:get(focal_relations, ProjectionAfterPromotion),
    CurrentPromoted =
        maps:get(status, StoredCurrent) =:= promoted andalso
        maps:get(governing_effect, StoredCurrent) =:= focal_support andalso
        maps:get(canonical, StoredCurrent) =:= false andalso
        length(Relations) =:= 1 andalso
        maps:get(artifact_id, hd(Relations)) =:= t8_current_artifact,
    SameText = maps:get(value, StoredStale) =:=
                   maps:get(value, StoredCurrent),
    ProvenancePreserved =
        maps:get(source_space, maps:get(provenance, StoredStale)) =:=
            background_branch andalso
        maps:get(source_space, maps:get(provenance, StoredCurrent)) =:=
            background_branch andalso
        maps:get(provenance, hd(Relations)) =:=
            maps:get(provenance, StoredCurrent),
    NoCanonization =
        lists:all(fun(A) -> maps:get(canonical, A) =:= false end,
                  maps:values(Artifacts)),
    Comparison =
        #{production_did_not_change_focal_state => ProductionDidNotChange,
          stale_artifact_not_promoted => StaleNotPromoted,
          current_artifact_promoted_explicitly => CurrentPromoted,
          stale_and_current_same_text => SameText,
          provenance_preserved => ProvenancePreserved,
          no_canonization => NoCanonization},
    SemanticPass = all_true(Comparison),
    Receipts =
        [UserReceipt, StaleAssignmentReceipt, StalePlanReceipt,
         StaleStoreReceipt, StaleAppraisalReceipt,
         CurrentAssignmentReceipt, CurrentPlanReceipt,
         CurrentStoreReceipt, PromotionReceipt],
    Counts = supervisor:count_children(ctx_runtime_tree_stage3_sup),
    OperationalPass =
        receipts_delivered(Receipts) andalso
        maps:get(graph_version, ProjectionAfterPromotion) =:= 2 andalso
        proplists:get_value(active, Counts) + 1 =< 10,
    #{schema => provisional_runtime_tree_t8_evidence_v1,
      grounding =>
          #{source_trajectory => original,
            ordinals => [831, 1342, 1362],
            current_corrections =>
                [background_work_is_idea_not_instruction,
                 prepared_content_requires_appraisal,
                 newer_focal_version_governs],
            derived_program_test => t8,
            disposition => proceed_bounded_artifact_promotion},
      baseline_counterfactual =>
          #{behavior => shared_store_existence_changes_focal_projection,
            leaked_value => SharedText,
            accepted => false},
      user_event => UserEvent,
      assignments => #{stale => StaleAssignment,
                       current => CurrentAssignment},
      artifacts => #{stale => StoredStale, current => StoredCurrent},
      projections =>
          #{focal_before_production => FocalBeforeProduction,
            after_stale_production => ProjectionAfterStaleProduction,
            after_stale_appraisal => ProjectionAfterStaleAppraisal,
            before_current_promotion => ProjectionBeforePromotion,
            after_current_promotion => ProjectionAfterPromotion},
      comparison => Comparison,
      delivery_receipts => Receipts,
      semantic =>
          #{verdict => verdict(SemanticPass),
            promoted_relation_count => length(Relations),
            stale_artifact_count => 1,
            pre_promotion_contamination_count =>
                bool_count(not ProductionDidNotChange),
            unauthorized_canonization_count => bool_count(not NoCanonization),
            stakeholder_appraisal => required},
      operational =>
          #{verdict => verdict(OperationalPass),
            actor_count => proplists:get_value(active, Counts) + 1,
            graph_head => maps:get(graph_version, ProjectionAfterPromotion),
            receipt_count => length(Receipts),
            wall_time_us => erlang:monotonic_time(microsecond) - Started,
            external_effect_count => 0}}.

t9_case() ->
    Started = erlang:monotonic_time(microsecond),
    Source0 = ctx_runtime_tree_stage3_clone:source_snapshot(),
    Source0Digest = ctx_runtime_tree_stage3_clone:source_digest(Source0),
    CloneSpec = #{id => t9_clone_worker,
                  start => {ctx_runtime_tree_stage3_clone, start_link,
                            [Source0]},
                  restart => temporary,
                  shutdown => 5000,
                  type => worker,
                  modules => [ctx_runtime_tree_stage3_clone]},
    {ok, ClonePid} =
        supervisor:start_child(ctx_runtime_tree_stage3_sup, CloneSpec),
    CloneInitial = ctx_runtime_tree_stage3_clone:state(ClonePid),
    {ok, MutationReceipt} =
        ctx_runtime_tree_stage3_clone:mutate_relation(
          ClonePid, relation_r, clone_experimental_meaning,
          t9_clone_divergent_correction),
    CloneMutated = ctx_runtime_tree_stage3_clone:state(ClonePid),
    SourceAfterCloneMutation = Source0,
    SourceAfterCloneDigest =
        ctx_runtime_tree_stage3_clone:source_digest(SourceAfterCloneMutation),
    SourceEvent = #{event_id => t9_independent_source_event,
                    relation_id => relation_r,
                    value => source_revised_meaning},
    Source1 = ctx_runtime_tree_stage3_clone:advance_source(
                SourceAfterCloneMutation, SourceEvent),
    Source1Digest = ctx_runtime_tree_stage3_clone:source_digest(Source1),
    {ok, Delta} = ctx_runtime_tree_stage3_clone:proposal(ClonePid),
    {blocked, MergeBlockReceipt, SourceAfterBlockedMerge} =
        ctx_runtime_tree_stage3_clone:request_unreviewed_merge(Source1, Delta),
    {conflict, Conflict, ReviewReceipt, SourceAfterReview} =
        ctx_runtime_tree_stage3_clone:review_delta(
          SourceAfterBlockedMerge, Delta),
    UnsafeCounterfactual =
        ctx_runtime_tree_stage3_clone:unsafe_merge_counterfactual(Source1,
                                                                  Delta),
    SourceAfterReviewDigest =
        ctx_runtime_tree_stage3_clone:source_digest(SourceAfterReview),
    CloneMonitor = monitor(process, ClonePid),
    ok = supervisor:terminate_child(ctx_runtime_tree_stage3_sup,
                                    t9_clone_worker),
    receive
        {'DOWN', CloneMonitor, process, ClonePid, _} -> ok
    after 2000 -> error(t9_clone_termination_timeout)
    end,
    DeleteDisposition =
        case supervisor:delete_child(ctx_runtime_tree_stage3_sup,
                                     t9_clone_worker) of
            ok -> explicitly_deleted;
            {error, not_found} -> temporary_child_already_removed
        end,
    CloneAbsent =
        lists:keyfind(t9_clone_worker, 1,
                      supervisor:which_children(
                        ctx_runtime_tree_stage3_sup)) =:= false,
    Ancestry = maps:get(ancestry, CloneInitial),
    SourceUnchangedByClone =
        Source0 =:= SourceAfterCloneMutation andalso
        Source0Digest =:= SourceAfterCloneDigest,
    AncestryPreserved =
        maps:get(source_snapshot_id, Ancestry) =:= t9_source_snapshot andalso
        maps:get(starting_graph_version, Ancestry) =:= 7 andalso
        maps:get(source_digest, Ancestry) =:= Source0Digest andalso
        maps:get(ancestry, Delta) =:= Ancestry,
    CloneRelation = maps:get(relation_r,
                             maps:get(relations, CloneMutated)),
    SourceRelation = maps:get(relation_r, maps:get(relations, Source1)),
    DivergenceConfined =
        maps:get(value, CloneRelation) =:= clone_experimental_meaning andalso
        maps:get(value, SourceRelation) =:= source_revised_meaning,
    MergeBlocked =
        maps:get(disposition, MergeBlockReceipt) =:=
            blocked_missing_separate_merge_authority andalso
        maps:get(committed, MergeBlockReceipt) =:= false andalso
        SourceAfterBlockedMerge =:= Source1,
    ConflictPreserved =
        maps:get(status, Conflict) =:= provisional_unresolved andalso
        maps:get(canonical, Conflict) =:= false andalso
        maps:get(resolution, Conflict) =:= none andalso
        maps:get(source_head_value, Conflict) =:= source_revised_meaning andalso
        maps:get(clone_proposed_value, Conflict) =:=
            clone_experimental_meaning,
    SourceUnchangedByReview =
        SourceAfterReview =:= Source1 andalso
        SourceAfterReviewDigest =:= Source1Digest,
    UnsafeWouldContaminate = UnsafeCounterfactual =/= Source1,
    Comparison =
        #{source_unchanged_by_clone_path => SourceUnchangedByClone,
          ancestry_preserved => AncestryPreserved,
          divergence_confined_to_clone => DivergenceConfined,
          unreviewed_merge_blocked => MergeBlocked,
          conflict_preserved_provisionally => ConflictPreserved,
          source_unchanged_by_review => SourceUnchangedByReview,
          clone_terminated_and_removed => CloneAbsent,
          unsafe_counterfactual_would_contaminate =>
              UnsafeWouldContaminate},
    SemanticPass = all_true(Comparison),
    Counts = supervisor:count_children(ctx_runtime_tree_stage3_sup),
    OperationalPass =
        SourceUnchangedByClone andalso SourceUnchangedByReview andalso
        CloneAbsent andalso not is_process_alive(ClonePid) andalso
        proplists:get_value(active, Counts) + 1 =< 10,
    #{schema => provisional_runtime_tree_t9_evidence_v1,
      grounding =>
          #{source_trajectory =>
                #{original_ordinals => [721, 2448, 2456],
                  continuation_ordinals => [3089]},
            current_corrections =>
                [clone_must_not_interfere_with_governing_runtime,
                 poc_is_not_runtime_mission,
                 merge_requires_separate_review_and_authority],
            derived_program_test => t9,
            disposition => proceed_bounded_supervised_clone},
      source =>
          #{initial => Source0,
            independently_advanced => Source1,
            digest_initial => Source0Digest,
            digest_after_clone_mutation => SourceAfterCloneDigest,
            digest_after_review => SourceAfterReviewDigest},
      clone =>
          #{initial => CloneInitial,
            mutated => CloneMutated,
            pid => ClonePid,
            cleanup_absent => CloneAbsent,
            cleanup_disposition => DeleteDisposition},
      proposed_delta => Delta,
      conflict => Conflict,
      baseline_counterfactual =>
          #{kind => unsafe_last_writer_wins,
            result => UnsafeCounterfactual,
            would_change_source => UnsafeWouldContaminate,
            applied_to_governing_source => false},
      comparison => Comparison,
      delivery_receipts =>
          [MutationReceipt, MergeBlockReceipt, ReviewReceipt],
      semantic =>
          #{verdict => verdict(SemanticPass),
            unresolved_conflict_count => 1,
            source_contamination_count =>
                bool_count(not SourceUnchangedByReview),
            silent_merge_count => 0,
            unauthorized_canonization_count => 0,
            stakeholder_appraisal => required},
      operational =>
          #{verdict => verdict(OperationalPass),
            actor_count_after_cleanup =>
                proplists:get_value(active, Counts) + 1,
            clone_process_terminated => not is_process_alive(ClonePid),
            clone_child_removed => CloneAbsent,
            wall_time_us => erlang:monotonic_time(microsecond) - Started,
            external_effect_count => 0}}.

focal_semantics(Projection) ->
    maps:with([graph_version, focus, proximal_event, focal_relations,
               knowledge_refs], Projection).

receipts_delivered(Receipts) ->
    lists:all(fun(R) -> maps:get(sent, R) andalso
                        maps:get(delivered, R) andalso
                        maps:get(interpreted, R)
              end, Receipts).

all_true(Map) -> lists:all(fun(Value) -> Value =:= true end,
                           maps:values(Map)).
bool_count(true) -> 1;
bool_count(false) -> 0.
verdict(true) -> pass;
verdict(false) -> fail.
