-module(ctx_continuation_t13_queue).
-behaviour(gen_server).

-export([start_link/0, configure/2, configure_experiential/1, complete/2,
         reconcile_without_completion/0, snapshot/0, cleanup/0, status/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(NAME, ctx_continuation_t13_queue).
-define(SUP, ctx_continuation_t13_sup).

start_link() -> gen_server:start_link({local, ?NAME}, ?MODULE, [], []).
configure(Mode, Scenario) -> gen_server:call(?NAME, {configure, Mode, Scenario}).
configure_experiential(HistoryVariant) ->
    gen_server:call(?NAME, {configure_experiential, HistoryVariant}).
complete(ItemId, Disposition) ->
    gen_server:call(?NAME, {complete, ItemId, Disposition}, 10000).
reconcile_without_completion() ->
    gen_server:call(?NAME, reconcile_without_completion).
snapshot() -> gen_server:call(?NAME, snapshot).
cleanup() -> gen_server:call(?NAME, cleanup).
status() -> gen_server:call(?NAME, status).

init([]) -> {ok, empty_state()}.

handle_call({configure, Mode, Scenario}, _From, State0) ->
    ok = cleanup_executor(State0),
    Items0 = scenario_items(Scenario),
    State1 = (empty_state())#{configured => true,
                            mode => Mode,
                            scenario => Scenario,
                            items => Items0,
                            queue_status => running,
                            experience_base => experience_base()},
    ItemA = maps:get(t13_item_a, Items0),
    Envelope = initial_envelope(ItemA, State1),
    {ChildId, Pid, Inheritance} = start_executor(ItemA, Envelope, State1),
    Items1 = Items0#{t13_item_a => ItemA#{status => running}},
    State2 = State1#{items => Items1,
                     active_executor =>
                         #{child_id => ChildId, pid => Pid,
                           item_id => t13_item_a},
                     started_counts => #{t13_item_a => 1},
                     initial_inheritance => Inheritance},
    {reply, {ok, #{scenario => Scenario, mode => Mode,
                   initial_executor => Pid,
                   inheritance => Inheritance}}, State2};
handle_call({configure_experiential, HistoryVariant}, _From, State0) ->
    ok = cleanup_executor(State0),
    Experience = case HistoryVariant of
                     with_history -> experience_base();
                     absent_history -> absent_experience_base()
                 end,
    {DerivedMode, PolicyReason} = derive_policy(Experience),
    Scenario = {experiential, HistoryVariant},
    Items0 = base_items(),
    CorrectionFrontier =
        case HistoryVariant of
            with_history ->
                [continuous_queue_without_repeated_approval,
                 stakeholder_is_not_watchdog,
                 completion_must_trigger_reconciliation,
                 future_creation_must_inherit_enforcement];
            absent_history -> []
        end,
    State1 = (empty_state())#{configured => true,
                              mode => DerivedMode,
                              scenario => Scenario,
                              items => Items0,
                              queue_status => running,
                              correction_frontier => CorrectionFrontier,
                              experience_base => Experience},
    {PolicyEvent, State2} =
        append_event(experience_policy_derived,
                     {experience_policy, HistoryVariant}, none,
                     #{history_variant => HistoryVariant,
                       experience_digest => digest(Experience),
                       derived_mode => DerivedMode,
                       derived_policy => PolicyReason,
                       caller_supplied_mode => false}, State1),
    ItemA = maps:get(t13_item_a, Items0),
    Envelope = initial_envelope(ItemA, State2),
    {ChildId, Pid, Inheritance} = start_executor(ItemA, Envelope, State2),
    Items1 = Items0#{t13_item_a => ItemA#{status => running}},
    State3 = State2#{items => Items1,
                     active_executor =>
                         #{child_id => ChildId, pid => Pid,
                           item_id => t13_item_a},
                     started_counts => #{t13_item_a => 1},
                     initial_inheritance => Inheritance,
                     policy_derivation => PolicyEvent},
    {reply, {ok, #{scenario => Scenario,
                   history_variant => HistoryVariant,
                   derived_mode => DerivedMode,
                   policy_derivation => PolicyEvent,
                   initial_executor => Pid,
                   inheritance => Inheritance}}, State3};
handle_call({complete, ItemId, Disposition}, _From, State0) ->
    CompletionId = {t13_completion, maps:get(scenario, State0), ItemId},
    case maps:is_key(CompletionId, maps:get(completions, State0)) of
        true ->
            Receipt = #{schema => provisional_t13_completion_receipt_v1,
                        completion_id => CompletionId,
                        disposition => duplicate_completion_suppressed,
                        accepted => false, committed => false,
                        successor_started => false},
            {reply, {duplicate, Receipt}, State0};
        false ->
            {Terminal, State1} =
                append_event(work_item_terminal,
                             {terminal, ItemId}, none,
                             #{item_id => ItemId,
                               disposition => Disposition}, State0),
            {Frozen, State2} =
                append_event(evidence_frozen,
                             {evidence_frozen, ItemId}, maps:get(id, Terminal),
                             #{item_id => ItemId,
                               immutable_digest => digest({State0, ItemId})},
                             State1),
            ok = terminate_active_executor(ItemId, State2),
            {Teardown, State3} =
                append_event(teardown_verified,
                             {teardown_verified, ItemId}, maps:get(id, Frozen),
                             #{item_id => ItemId,
                               executor_absent => true,
                               governing_state_unchanged => true}, State2),
            {Completion, State4} =
                append_event(work_item_completion, CompletionId,
                             maps:get(id, Teardown),
                             #{item_id => ItemId,
                               disposition => Disposition,
                               evidence_frozen => true,
                               teardown_verified => true}, State3),
            Items0 = maps:get(items, State4),
            Item0 = maps:get(ItemId, Items0),
            Items1 = Items0#{ItemId => Item0#{status => Disposition}},
            State5 = State4#{items => Items1,
                             active_executor => none,
                             completions =>
                                 (maps:get(completions, State4))#{
                                    CompletionId => Completion}},
            case maps:get(mode, State5) of
                text_only_baseline ->
                    {Rule, State6} =
                        append_event(continuation_rule_stored,
                                     {stored_rule, ItemId},
                                     maps:get(id, Completion),
                                     #{rule => completion_should_continue,
                                       applied => false}, State5),
                    {Wait, State7} =
                        append_event(waiting_for_user,
                                     {waiting_for_user, ItemId},
                                     maps:get(id, Rule),
                                     #{reason => repeated_approval_gate,
                                       user_prompt_emitted => false}, State6),
                    Reply = #{completion => Completion,
                              terminal_event => Terminal,
                              freeze_event => Frozen,
                              teardown_event => Teardown,
                              waiting_event => Wait,
                              successor => none},
                    {reply, {ok, Reply},
                     State7#{queue_status => waiting_for_user}};
                enforced ->
                    {Reply, State6} = reconcile(Completion, State5),
                    {reply, {ok, Reply#{terminal_event => Terminal,
                                       freeze_event => Frozen,
                                       teardown_event => Teardown}}, State6}
                ;
                unresolved_no_experience ->
                    {Unresolved, State6} =
                        append_event(continuation_policy_unresolved,
                                     {continuation_unresolved, ItemId},
                                     maps:get(id, Completion),
                                     #{reason => absent_causal_experience,
                                       successor_started => false,
                                       waiting_for_user => false,
                                       invented_policy => false}, State5),
                    Reply = #{completion => Completion,
                              terminal_event => Terminal,
                              freeze_event => Frozen,
                              teardown_event => Teardown,
                              unresolved_event => Unresolved,
                              successor => none},
                    {reply, {ok, Reply},
                     State6#{queue_status => needs_experience_grounding}}
            end
    end;
handle_call(reconcile_without_completion, _From, State0) ->
    case map_size(maps:get(completions, State0)) of
        0 ->
            {Event, State1} =
                append_event(reconciliation_blocked_missing_completion,
                             {missing_completion,
                              maps:get(scenario, State0)}, none,
                             #{successor_started => false,
                               reason => no_completion_event}, State0),
            {reply, {blocked, Event}, State1};
        _ ->
            {reply, {error, completion_already_present}, State0}
    end;
handle_call(snapshot, _From, State) -> {reply, State, State};
handle_call(cleanup, _From, State0) ->
    ok = cleanup_executor(State0),
    Receipt = #{schema => provisional_t13_cleanup_receipt_v1,
                scenario => maps:get(scenario, State0, none),
                active_executor_removed => true,
                residual_dynamic_children => dynamic_executor_count(),
                external_effect_count => 0},
    {reply, {ok, Receipt}, State0#{active_executor => none}};
handle_call(status, _From, State) ->
    {message_queue_len, Queue} = process_info(self(), message_queue_len),
    {memory, Memory} = process_info(self(), memory),
    {reply, #{scenario => maps:get(scenario, State),
              queue_status => maps:get(queue_status, State),
              event_count => length(maps:get(events, State)),
              started_counts => maps:get(started_counts, State),
              dynamic_executor_count => dynamic_executor_count(),
              message_queue_len => Queue,
              process_memory_bytes => Memory}, State}.

handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, State) -> cleanup_executor(State).
code_change(_OldVersion, State, _Extra) -> {ok, State}.

reconcile(Completion, State0) ->
    CompletionId = maps:get(id, Completion),
    Items = maps:get(items, State0),
    Decisions =
        [#{item_id => Id, disposition => eligibility(Item, State0)}
         || {Id, Item} <- lists:sort(maps:to_list(Items)),
            maps:get(status, Item) =:= queued],
    {Reconciled, State1} =
        append_event(queue_reconciled,
                     {reconciled, CompletionId}, CompletionId,
                     #{queue_version => maps:get(queue_version, State0),
                       grant_version => maps:get(version,
                                                 maps:get(grant, State0)),
                       dependency_snapshot => dependency_snapshot(State0),
                       policy_derivation =>
                           policy_derivation_reference(State0)},
                     State0),
    {DecisionEvent, State2} =
        append_event(eligibility_decisions,
                     {eligibility, CompletionId}, maps:get(id, Reconciled),
                     #{decisions => Decisions}, State1),
    Eligible = [Id || #{item_id := Id, disposition := eligible} <- Decisions],
    case Eligible of
        [Next | _] ->
            {Selected, State3} =
                append_event(next_item_selected,
                             {selected, Next}, maps:get(id, DecisionEvent),
                             #{item_id => Next,
                               selection_reason =>
                                   selection_reason(State2)},
                             State2),
            Item = maps:get(Next, maps:get(items, State3)),
            Envelope = successor_envelope(Item, State3),
            {ChildId, Pid, Inheritance} =
                start_executor(Item, Envelope, State3),
            {Created, State4} =
                append_event(successor_created,
                             {created, Next}, maps:get(id, Selected),
                             #{item_id => Next, child_id => ChildId,
                               pid => Pid}, State3),
            {Inherited, State5} =
                append_event(continuation_inheritance_acknowledged,
                             {inherited, Next}, maps:get(id, Created),
                             #{item_id => Next,
                               receipt => Inheritance}, State4),
            {ok, StartReceipt} =
                ctx_continuation_t13_executor:begin_item(Pid),
            {Started, State6} =
                append_event(successor_started,
                             {started, Next}, maps:get(id, Inherited),
                             #{item_id => Next,
                               receipt => StartReceipt,
                               user_prompt_between => false,
                               watchdog_intervention => false}, State5),
            Items0 = maps:get(items, State6),
            Items1 = Items0#{Next => Item#{status => running}},
            Started0 = maps:get(started_counts, State6),
            State7 = State6#{items => Items1,
                             active_executor =>
                                 #{child_id => ChildId, pid => Pid,
                                   item_id => Next},
                             started_counts =>
                                 Started0#{Next => maps:get(Next, Started0, 0)+1},
                             queue_status => running},
            {#{completion => Completion,
               reconciliation => Reconciled,
               decisions => DecisionEvent,
               selected => Selected,
               created => Created,
               inherited => Inherited,
               started => Started,
               successor => Next}, State7};
        [] ->
            Remaining = [D || D <- Decisions],
            {Kind, Status, Reason} =
                case Remaining of
                    [] -> {queue_exhausted, exhausted, no_remaining_items};
                    _ -> {no_eligible_successor, blocked,
                          all_remaining_items_ineligible}
                end,
            {TerminalEvent, State3} =
                append_event(Kind, {Kind, CompletionId},
                             maps:get(id, DecisionEvent),
                             #{reason => Reason,
                               decisions => Decisions,
                               successor_started => false}, State2),
            {#{completion => Completion,
               reconciliation => Reconciled,
               decisions => DecisionEvent,
               terminal_queue_event => TerminalEvent,
               successor => none}, State3#{queue_status => Status}}
    end.

eligibility(Item, State) ->
    Id = maps:get(id, Item),
    Grant = maps:get(grant, State),
    Allowed = maps:get(allowed_items, Grant),
    case lists:member(Id, Allowed) of
        false -> out_of_scope;
        true ->
            case maps:get(blocker, Item, none) of
                none ->
                    Dependencies = maps:get(depends_on, Item, []),
                    Items = maps:get(items, State),
                    case lists:all(
                           fun(Dep) -> terminal_status(
                                         maps:get(status,
                                                  maps:get(Dep, Items)))
                           end, Dependencies) of
                        true -> eligible;
                        false -> dependency_pending
                    end;
                Blocker -> {blocked, Blocker}
            end
    end.

terminal_status(passed) -> true;
terminal_status(failed) -> true;
terminal_status(needs_external_oracle) -> true;
terminal_status(_) -> false.

scenario_items(main) -> base_items();
scenario_items(baseline) -> base_items();
scenario_items(missing_completion) -> base_items();
scenario_items(exhausted) ->
    #{t13_item_a => item(t13_item_a, [], none, in_scope)};
scenario_items(blocked) ->
    #{t13_item_a => item(t13_item_a, [], none, in_scope),
      t13_item_d => item(t13_item_d, [t13_item_a],
                         missing_required_input, in_scope)}.

base_items() ->
    #{t13_item_a => item(t13_item_a, [], none, in_scope),
      t13_item_b => item(t13_item_b, [t13_item_a], none, in_scope),
      t13_item_c => item(t13_item_c, [t13_item_a], none, out_of_scope),
      t13_item_d => item(t13_item_d, [t13_item_a],
                         missing_required_input, in_scope)}.

item(Id, Dependencies, Blocker, Scope) ->
    #{id => Id, status => queued, depends_on => Dependencies,
      blocker => Blocker, scope => Scope,
      purpose => bounded_semantic_context_test}.

initial_envelope(Item, State) ->
    (successor_envelope(Item, State))#{creation_kind => initial_executor}.

successor_envelope(Item, State) ->
    #{schema => provisional_t13_continuation_envelope_v1,
      version => 1,
      item_id => maps:get(id, Item),
      grant => maps:get(grant, State),
      correction_frontier => maps:get(correction_frontier, State),
      dependency_snapshot => dependency_snapshot(State),
      scope => local_semantic_context_poc,
      bounds => #{actor_limit => 12, message_limit => 512,
                  wall_time_ms => 30000, external_effects => forbidden},
      evidence_obligations =>
          [source_grounding, red_green, semantic_operational_split,
           failure_preservation, cleanup_integrity],
      stop_conditions =>
          [out_of_scope, revoked_grant, missing_required_input,
           contamination, evidence_integrity_failure],
      continuation_rule => continuation_rule(State),
      canonical => false}.

dependency_snapshot(State) ->
    maps:map(fun(_Id, Item) -> maps:with([status, depends_on, blocker, scope],
                                        Item)
             end, maps:get(items, State)).

start_executor(Item, Envelope, State) ->
    ChildId = {t13_executor, maps:get(scenario, State), maps:get(id, Item)},
    Spec = #{id => ChildId,
             start => {ctx_continuation_t13_executor, start_link,
                       [Item, Envelope]},
             restart => temporary, shutdown => 5000, type => worker,
             modules => [ctx_continuation_t13_executor]},
    {ok, Pid} = supervisor:start_child(?SUP, Spec),
    Inheritance = ctx_continuation_t13_executor:inheritance_receipt(Pid),
    {ChildId, Pid, Inheritance}.

terminate_active_executor(ItemId, State) ->
    case maps:get(active_executor, State) of
        #{item_id := ItemId, child_id := ChildId} ->
            ok = supervisor:terminate_child(?SUP, ChildId),
            true = not child_present(ChildId),
            ok;
        none -> ok;
        Other -> error({wrong_active_executor, ItemId, Other})
    end.

cleanup_executor(State) ->
    case maps:get(active_executor, State, none) of
        #{child_id := ChildId} ->
            case supervisor:terminate_child(?SUP, ChildId) of
                ok -> ok;
                {error, not_found} -> ok
            end;
        none -> ok
    end.

child_present(ChildId) ->
    lists:keyfind(ChildId, 1, supervisor:which_children(?SUP)) =/= false.

dynamic_executor_count() ->
    length([Id || {Id, _Pid, _Type, _Mods} <- supervisor:which_children(?SUP),
                  is_tuple(Id), element(1, Id) =:= t13_executor]).

append_event(Kind, Id, Parent, Payload, State0) ->
    Sequence = maps:get(sequence, State0) + 1,
    Event = #{schema => provisional_t13_event_v1,
              id => Id, kind => Kind, sequence => Sequence,
              causal_parent => Parent, payload => Payload,
              canonical => false},
    {Event, State0#{sequence => Sequence,
                    events => maps:get(events, State0) ++ [Event]}}.

experience_base() ->
    #{schema => provisional_t13_experience_base_v1,
      prior_state => authorized_queue_item_completed,
      transforming_event => improper_wait_for_stakeholder,
      observed_consequence => stakeholder_had_to_return_as_watchdog,
      governing_corrections =>
          [#{ordinal => 3656,
             source_event_id => continuation_transcript_3656,
             source_text =>
                 <<"Nada deve ficá congelado, nada deve ficá esperando."/utf8>>},
           #{ordinal => 3695,
             source_event_id => continuation_transcript_3695,
             source_text =>
                 <<"É fila contínua até o final... Tu não para."/utf8>>},
           #{ordinal => 3764,
             source_event_id => continuation_transcript_3764,
             source_text => <<"Eu não sou watchdog"/utf8>>},
           #{ordinal => 3780,
             source_event_id => continuation_transcript_3780,
             source_text =>
                 <<"Se uma regra foi criada, e ela não é aplicada, ela não é regra"/utf8>>},
           #{ordinal => 3788,
             source_event_id => continuation_transcript_3788,
             source_text =>
                 <<"Em próximo, quando tiver uma nova criação, tu vai esquecê disso... e vai pará... porque vai tá me esperando... Não."/utf8>>}],
      resulting_policy => completion_triggers_next_eligible,
      historical_improper_wait_retained => true,
      source_space => experience_base,
      knowledge_base_refs => []}.

empty_state() ->
    #{schema => provisional_t13_queue_state_v1,
      configured => false,
      mode => none,
      scenario => none,
      queue_version => 1,
      grant => #{id => t13_continuous_grant, version => 1,
                 active => true,
                 allowed_items => [t13_item_a, t13_item_b, t13_item_d]},
      correction_frontier =>
          [continuous_queue_without_repeated_approval,
           stakeholder_is_not_watchdog,
           completion_must_trigger_reconciliation,
           future_creation_must_inherit_enforcement],
      items => #{}, sequence => 0, events => [], completions => #{},
      started_counts => #{}, active_executor => none,
      initial_inheritance => none, queue_status => unconfigured,
      experience_base => none, policy_derivation => none}.

absent_experience_base() ->
    #{schema => provisional_t13_experience_base_v1,
      prior_state => unavailable,
      transforming_event => unavailable,
      observed_consequence => unavailable,
      governing_corrections => [],
      resulting_policy => unresolved,
      historical_improper_wait_retained => false,
      source_space => experience_base,
      knowledge_base_refs => []}.

derive_policy(Experience) ->
    case {maps:get(transforming_event, Experience),
          maps:get(governing_corrections, Experience),
          maps:get(resulting_policy, Experience)} of
        {improper_wait_for_stakeholder, Corrections,
         completion_triggers_next_eligible} when length(Corrections) >= 5 ->
            {enforced, experience_correction_requires_continuation};
        _ -> {unresolved_no_experience, insufficient_experience_lineage}
    end.

policy_derivation_reference(State) ->
    case maps:get(policy_derivation, State, none) of
        none -> none;
        Event -> maps:get(id, Event)
    end.

selection_reason(State) ->
    case maps:get(policy_derivation, State, none) of
        none -> dependencies_satisfied_in_scope;
        Event -> #{kind => experience_derived_continuation,
                   policy_event => maps:get(id, Event)}
    end.

continuation_rule(State) ->
    case maps:get(mode, State) of
        enforced -> completion_triggers_next_eligible;
        unresolved_no_experience -> unresolved_requires_causal_grounding;
        text_only_baseline -> declared_but_not_enforced;
        _ -> unresolved
    end.

digest(Term) -> crypto:hash(sha256, term_to_binary(Term)).
