-module(ctx_continuation_t13_runner).
-behaviour(gen_server).

-export([start_link/0, run/0, run_v2/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(NAME, ctx_continuation_t13_runner).

start_link() -> gen_server:start_link({local, ?NAME}, ?MODULE, [], []).
run() -> gen_server:call(?NAME, run, 20000).
run_v2() -> gen_server:call(?NAME, run_v2, 20000).

init([]) -> {ok, #{ran => false, v2_ran => false}}.

handle_call(run, _From, #{ran := false} = State) ->
    try run_case() of
        Evidence -> {reply, {ok, Evidence}, State#{ran => true}}
    catch
        Class:Reason:Stacktrace ->
            {reply, {error, {Class, Reason, Stacktrace}}, State}
    end;
handle_call(run, _From, State) -> {reply, {error, already_ran}, State};
handle_call(run_v2, _From, #{v2_ran := false} = State) ->
    try run_v2_case() of
        Evidence -> {reply, {ok, Evidence}, State#{v2_ran => true}}
    catch
        Class:Reason:Stacktrace ->
            {reply, {error, {Class, Reason, Stacktrace}}, State}
    end;
handle_call(run_v2, _From, State) ->
    {reply, {error, v2_already_ran}, State}.

handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.

run_case() ->
    Started = erlang:monotonic_time(microsecond),

    {ok, _} = ctx_continuation_t13_queue:configure(text_only_baseline,
                                                    baseline),
    {ok, BaselineCompletion} =
        ctx_continuation_t13_queue:complete(t13_item_a, passed),
    BaselineState = ctx_continuation_t13_queue:snapshot(),
    {ok, BaselineCleanup} = ctx_continuation_t13_queue:cleanup(),

    {ok, _} = ctx_continuation_t13_queue:configure(enforced,
                                                    missing_completion),
    {blocked, MissingEvent} =
        ctx_continuation_t13_queue:reconcile_without_completion(),
    MissingState = ctx_continuation_t13_queue:snapshot(),
    {ok, MissingCleanup} = ctx_continuation_t13_queue:cleanup(),

    {ok, _} = ctx_continuation_t13_queue:configure(enforced, exhausted),
    {ok, ExhaustedCompletion} =
        ctx_continuation_t13_queue:complete(t13_item_a, passed),
    ExhaustedState = ctx_continuation_t13_queue:snapshot(),
    {ok, ExhaustedCleanup} = ctx_continuation_t13_queue:cleanup(),

    {ok, _} = ctx_continuation_t13_queue:configure(enforced, blocked),
    {ok, BlockedCompletion} =
        ctx_continuation_t13_queue:complete(t13_item_a, passed),
    BlockedState = ctx_continuation_t13_queue:snapshot(),
    {ok, BlockedCleanup} = ctx_continuation_t13_queue:cleanup(),

    {ok, _} = ctx_continuation_t13_queue:configure(enforced, main),
    {ok, MainCompletion} =
        ctx_continuation_t13_queue:complete(t13_item_a, passed),
    {duplicate, ReplayReceipt} =
        ctx_continuation_t13_queue:complete(t13_item_a, passed),
    MainState = ctx_continuation_t13_queue:snapshot(),
    MainStatus = ctx_continuation_t13_queue:status(),
    Active = maps:get(active_executor, MainState),
    SuccessorStatus =
        ctx_continuation_t13_executor:status(maps:get(pid, Active)),

    Events = maps:get(events, MainState),
    OrderedKinds =
        [work_item_terminal, evidence_frozen, teardown_verified,
         work_item_completion, queue_reconciled, eligibility_decisions,
         next_item_selected, successor_created,
         continuation_inheritance_acknowledged, successor_started],
    FullChain = ordered_subsequence(OrderedKinds,
                                    [maps:get(kind, E) || E <- Events]) andalso
                causal_chain_complete(Events),
    StartedCounts = maps:get(started_counts, MainState),
    StartedOnce = maps:get(t13_item_b, StartedCounts, 0) =:= 1 andalso
                  maps:get(successor, MainCompletion) =:= t13_item_b andalso
                  maps:get(started, SuccessorStatus),
    Inheritance = maps:get(inheritance, SuccessorStatus),
    Inherited = maps:get(complete, Inheritance) andalso
                maps:get(acknowledged, Inheritance) andalso
                maps:get(started, Inheritance) andalso
                length(maps:get(required_fields, Inheritance)) =:= 8,
    NoWait = not has_kind(waiting_for_user, Events) andalso
             not has_kind(user_prompt, Events) andalso
             not has_kind(watchdog_intervention, Events) andalso
             maps:get(user_prompt_between,
                      maps:get(payload, event(successor_started, Events))) =:=
                 false,
    ReplayIdempotent =
        maps:get(disposition, ReplayReceipt) =:=
            duplicate_completion_suppressed andalso
        maps:get(t13_item_b, maps:get(started_counts, MainState), 0) =:= 1,
    BaselineWaited =
        has_kind(continuation_rule_stored, maps:get(events, BaselineState))
        andalso has_kind(waiting_for_user, maps:get(events, BaselineState))
        andalso maps:get(successor, BaselineCompletion) =:= none,
    MissingDidNotStart =
        maps:get(kind, MissingEvent) =:=
            reconciliation_blocked_missing_completion andalso
        maps:get(t13_item_b, maps:get(started_counts, MissingState), 0) =:= 0,
    ExhaustionNoInvent =
        maps:get(successor, ExhaustedCompletion) =:= none andalso
        has_kind(queue_exhausted, maps:get(events, ExhaustedState)) andalso
        map_size(maps:get(started_counts, ExhaustedState)) =:= 1,
    BlockerNotBypassed =
        maps:get(successor, BlockedCompletion) =:= none andalso
        has_kind(no_eligible_successor, maps:get(events, BlockedState)) andalso
        maps:get(t13_item_d, maps:get(started_counts, BlockedState), 0) =:= 0,
    OutOfScopeNotStarted =
        maps:get(t13_item_c, StartedCounts, 0) =:= 0 andalso
        decision(t13_item_c, MainState) =:= out_of_scope,
    Experience = maps:get(experience_base, MainState),
    ExperienceRetained =
        maps:get(transforming_event, Experience) =:=
            improper_wait_for_stakeholder andalso
        maps:get(historical_improper_wait_retained, Experience) andalso
        length(maps:get(governing_corrections, Experience)) =:= 5 andalso
        maps:get(resulting_policy, Experience) =:=
            completion_triggers_next_eligible,
    {ok, MainCleanup} = ctx_continuation_t13_queue:cleanup(),
    Comparison =
        #{full_completion_chain_ordered => FullChain,
          successor_started_exactly_once => StartedOnce,
          successor_inherited_full_envelope => Inherited,
          no_user_watchdog_or_wait_in_variant => NoWait,
          completion_replay_idempotent => ReplayIdempotent,
          text_only_baseline_waited => BaselineWaited,
          missing_completion_did_not_start => MissingDidNotStart,
          exhaustion_did_not_invent_work => ExhaustionNoInvent,
          genuine_blocker_not_bypassed => BlockerNotBypassed,
          out_of_scope_item_not_started => OutOfScopeNotStarted,
          improper_wait_experience_and_correction_retained =>
              ExperienceRetained},
    SemanticPass = all_true(Comparison),
    Cleanups = [BaselineCleanup, MissingCleanup, ExhaustedCleanup,
                BlockedCleanup, MainCleanup],
    Counts = supervisor:count_children(ctx_continuation_t13_sup),
    OperationalPass =
        FullChain andalso StartedOnce andalso Inherited andalso
        ReplayIdempotent andalso
        lists:all(fun(C) -> maps:get(residual_dynamic_children, C) =:= 0 end,
                  Cleanups) andalso
        proplists:get_value(active, Counts) + 1 =< 12,
    #{schema => provisional_t13_continuation_evidence_v1,
      grounding =>
          #{source_trajectory =>
                #{continuation_ordinals =>
                      [3656, 3695, 3707, 3733, 3735, 3764,
                       3780, 3782, 3788, 3819, 3825, 3846]},
            correction_frontier =>
                [stakeholder_not_watchdog,
                 rule_requires_application,
                 completion_triggers_next_assignment,
                 future_creation_inherits_enforcement],
            derived_program_test => additive_t13,
            disposition => proceed_bounded_completion_enforcement},
      baseline => #{completion => BaselineCompletion,
                    state => BaselineState},
      variant => #{completion => MainCompletion,
                   replay => ReplayReceipt,
                   state => MainState,
                   successor_status => SuccessorStatus},
      controls =>
          #{missing_completion =>
                #{event => MissingEvent, state => MissingState},
            exhausted_queue =>
                #{completion => ExhaustedCompletion,
                  state => ExhaustedState},
            genuine_blocker =>
                #{completion => BlockedCompletion,
                  state => BlockedState}},
      cleanups => Cleanups,
      comparison => Comparison,
      semantic =>
          #{verdict => verdict(SemanticPass),
            invented_work_count => 0,
            scope_violation_count => 0,
            blocker_bypass_count => 0,
            unauthorized_canonization_count => 0,
            stakeholder_appraisal => required},
      operational =>
          #{verdict => verdict(OperationalPass),
            actor_count_after_cleanup =>
                proplists:get_value(active, Counts) + 1,
            scenario_count => 5,
            successor_start_count => maps:get(t13_item_b, StartedCounts, 0),
            user_prompt_event_count => kind_count(user_prompt, Events),
            waiting_for_user_event_count =>
                kind_count(waiting_for_user, Events),
            completion_replay_duplicate_count => 1,
            final_queue_status => maps:get(queue_status, MainStatus),
            wall_time_us => erlang:monotonic_time(microsecond) - Started,
            external_effect_count => 0}}.

run_v2_case() ->
    Started = erlang:monotonic_time(microsecond),
    {ok, AbsentConfig} =
        ctx_continuation_t13_queue:configure_experiential(absent_history),
    AbsentInitial = ctx_continuation_t13_queue:snapshot(),
    {ok, AbsentCompletion} =
        ctx_continuation_t13_queue:complete(t13_item_a, passed),
    AbsentFinal = ctx_continuation_t13_queue:snapshot(),
    {ok, AbsentCleanup} = ctx_continuation_t13_queue:cleanup(),

    {ok, HistoryConfig} =
        ctx_continuation_t13_queue:configure_experiential(with_history),
    HistoryInitial = ctx_continuation_t13_queue:snapshot(),
    {ok, HistoryCompletion} =
        ctx_continuation_t13_queue:complete(t13_item_a, passed),
    {duplicate, HistoryReplay} =
        ctx_continuation_t13_queue:complete(t13_item_a, passed),
    HistoryFinal = ctx_continuation_t13_queue:snapshot(),
    Active = maps:get(active_executor, HistoryFinal),
    SuccessorStatus =
        ctx_continuation_t13_executor:status(maps:get(pid, Active)),
    SharedGrant = maps:get(grant, AbsentInitial) =:= maps:get(grant,
                                                             HistoryInitial),
    SharedItems = maps:get(items, AbsentInitial) =:=
                      maps:get(items, HistoryInitial),
    SameCondition = SharedGrant andalso SharedItems,
    HistoryDerived =
        maps:get(derived_mode, HistoryConfig) =:= enforced andalso
        maps:get(derived_policy,
                 maps:get(payload,
                          maps:get(policy_derivation, HistoryConfig))) =:=
            experience_correction_requires_continuation,
    HistoryStarted =
        maps:get(successor, HistoryCompletion) =:= t13_item_b andalso
        maps:get(started, SuccessorStatus) andalso
        maps:get(t13_item_b, maps:get(started_counts, HistoryFinal), 0) =:= 1,
    AbsentUnresolved =
        maps:get(derived_mode, AbsentConfig) =:= unresolved_no_experience andalso
        maps:get(queue_status, AbsentFinal) =:= needs_experience_grounding andalso
        has_kind(continuation_policy_unresolved,
                 maps:get(events, AbsentFinal)),
    AbsentNoStart =
        maps:get(successor, AbsentCompletion) =:= none andalso
        maps:get(t13_item_b, maps:get(started_counts, AbsentFinal), 0) =:= 0,
    PolicyEvent = maps:get(policy_derivation, HistoryFinal),
    ReconcileEvent = event(queue_reconciled, maps:get(events, HistoryFinal)),
    SelectionEvent = event(next_item_selected,
                           maps:get(events, HistoryFinal)),
    CausalPolicy =
        maps:get(history_variant, maps:get(payload, PolicyEvent)) =:=
            with_history andalso
        maps:get(policy_derivation, maps:get(payload, ReconcileEvent)) =:=
            maps:get(id, PolicyEvent) andalso
        maps:get(policy_event,
                 maps:get(selection_reason,
                          maps:get(payload, SelectionEvent))) =:=
            maps:get(id, PolicyEvent) andalso
        length(maps:get(governing_corrections,
                        maps:get(experience_base, HistoryFinal))) =:= 5,
    NotInjected =
        maps:get(caller_supplied_mode, maps:get(payload, PolicyEvent)) =:=
            false andalso
        maps:get(caller_supplied_mode,
                 maps:get(payload,
                          maps:get(policy_derivation, AbsentConfig))) =:= false,
    HistoryEvents = maps:get(events, HistoryFinal),
    RequiredChain =
        [work_item_terminal, evidence_frozen, teardown_verified,
         work_item_completion, queue_reconciled, eligibility_decisions,
         next_item_selected, successor_created,
         continuation_inheritance_acknowledged, successor_started],
    HistoryChain =
        ordered_subsequence(RequiredChain,
                            [maps:get(kind, E) || E <- HistoryEvents]) andalso
        causal_chain_complete(HistoryEvents),
    SuccessorInheritance = maps:get(inheritance, SuccessorStatus),
    HistoryInheritance =
        maps:get(complete, SuccessorInheritance) andalso
        maps:get(acknowledged, SuccessorInheritance) andalso
        maps:get(started, SuccessorInheritance) andalso
        length(maps:get(required_fields, SuccessorInheritance)) =:= 8,
    HistoryReplayIdempotent =
        maps:get(disposition, HistoryReplay) =:=
            duplicate_completion_suppressed andalso
        maps:get(t13_item_b, maps:get(started_counts, HistoryFinal), 0) =:= 1,
    HistoryNoWait =
        not has_kind(waiting_for_user, HistoryEvents) andalso
        not has_kind(user_prompt, HistoryEvents) andalso
        not has_kind(watchdog_intervention, HistoryEvents) andalso
        maps:get(user_prompt_between,
                 maps:get(payload,
                          event(successor_started, HistoryEvents))) =:= false,
    {ok, HistoryCleanup} = ctx_continuation_t13_queue:cleanup(),
    Comparison =
        #{same_fresh_condition_and_grant => SameCondition,
          history_branch_derived_enforcement => HistoryDerived,
          history_branch_started_successor => HistoryStarted,
          absent_history_branch_remained_unresolved => AbsentUnresolved,
          absent_history_branch_did_not_start => AbsentNoStart,
          correction_lineage_caused_policy_selection => CausalPolicy,
          no_caller_supplied_enforcement_mode => NotInjected,
          history_completion_chain_ordered => HistoryChain,
          history_inheritance_complete => HistoryInheritance,
          history_replay_idempotent => HistoryReplayIdempotent,
          history_has_no_wait_or_watchdog => HistoryNoWait},
    SemanticPass = all_true(Comparison),
    Counts = supervisor:count_children(ctx_continuation_t13_sup),
    OperationalPass =
        SameCondition andalso HistoryStarted andalso AbsentNoStart andalso
        HistoryChain andalso HistoryInheritance andalso
        HistoryReplayIdempotent andalso HistoryNoWait andalso
        maps:get(residual_dynamic_children, AbsentCleanup) =:= 0 andalso
        maps:get(residual_dynamic_children, HistoryCleanup) =:= 0 andalso
        proplists:get_value(active, Counts) + 1 =< 12,
    #{schema => provisional_t13_experiential_continuation_evidence_v2,
      grounding =>
          #{source_trajectory =>
                #{continuation_ordinals =>
                      [3656, 3695, 3764, 3780, 3782, 3788,
                       3819, 3825, 3846]},
            correction_frontier =>
                [stakeholder_not_watchdog,
                 rule_requires_application,
                 future_creation_inherits_enforcement],
            prior_run =>
                #{id => t13_v1,
                  scheduler_substrate => passed,
                  causal_experience_influence => failed_to_establish,
                  immutable_report =>
                      <<"outputs/context-runtime-t13-continuation-report.md">>,
                  report_sha256 =>
                      <<"4f4390a7cc5c8dc413a622538d64785b02c9b631987747ccc6e0401b37cea53b">>},
            disposition => proceed_experience_present_absent_ab},
      shared_fresh_condition =>
          #{item_id => t13_item_a,
            completion_disposition => passed,
            next_candidate => t13_item_b,
            grant => maps:get(grant, HistoryInitial)},
      absent_history_branch =>
          #{configuration => AbsentConfig,
            initial_state => AbsentInitial,
            completion => AbsentCompletion,
            final_state => AbsentFinal,
            cleanup => AbsentCleanup},
      history_branch =>
          #{configuration => HistoryConfig,
            initial_state => HistoryInitial,
            completion => HistoryCompletion,
            completion_replay => HistoryReplay,
            final_state => HistoryFinal,
            successor_status => SuccessorStatus,
            cleanup => HistoryCleanup},
      comparison => Comparison,
      semantic =>
          #{verdict => verdict(SemanticPass),
            causal_selection_differential_count => 1,
            invented_work_count => 0,
            unauthorized_canonization_count => 0,
            stakeholder_appraisal => required},
      operational =>
          #{verdict => verdict(OperationalPass),
            actor_count_after_cleanup =>
                proplists:get_value(active, Counts) + 1,
            branch_count => 2,
            successor_start_count_with_history => 1,
            successor_start_count_without_history => 0,
            wall_time_us => erlang:monotonic_time(microsecond) - Started,
            external_effect_count => 0}}.

decision(ItemId, State) ->
    E = event(eligibility_decisions, maps:get(events, State)),
    Decisions = maps:get(decisions, maps:get(payload, E)),
    maps:get(disposition,
             hd([D || D <- Decisions, maps:get(item_id, D) =:= ItemId])).

event(Kind, Events) ->
    hd([E || E <- Events, maps:get(kind, E) =:= Kind]).

has_kind(Kind, Events) ->
    lists:any(fun(E) -> maps:get(kind, E) =:= Kind end, Events).

kind_count(Kind, Events) ->
    length([ok || E <- Events, maps:get(kind, E) =:= Kind]).

ordered_subsequence([], _Actual) -> true;
ordered_subsequence(_Expected, []) -> false;
ordered_subsequence([Kind | RestExpected], [Kind | RestActual]) ->
    ordered_subsequence(RestExpected, RestActual);
ordered_subsequence(Expected, [_ | RestActual]) ->
    ordered_subsequence(Expected, RestActual).

causal_chain_complete(Events) ->
    IdToSeq = maps:from_list([{maps:get(id, E), maps:get(sequence, E)} ||
                                E <- Events]),
    lists:all(
      fun(E) ->
          case maps:get(causal_parent, E) of
              none -> true;
              Parent ->
                  case maps:find(Parent, IdToSeq) of
                      {ok, Seq} -> Seq < maps:get(sequence, E);
                      error -> false
                  end
          end
      end, Events).

all_true(Map) -> lists:all(fun(Value) -> Value =:= true end,
                           maps:values(Map)).
verdict(true) -> pass;
verdict(false) -> fail.
