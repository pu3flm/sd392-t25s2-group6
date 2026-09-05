-module(ctx_runtime_tree_stage2).

-export([t4_new/0, t4_navigate/2, t4_project/2, t4_snapshot/1,
         t5_new/0, t5_set_status/2, t5_reactivate/2, t5_project/1,
         t6_new/3, t6_recall/2,
         head_version/1, transitions/1]).

-define(T4_SCHEMA, provisional_runtime_tree_t4_state_v1).
-define(T4_PROJECTION, provisional_runtime_tree_t4_projection_v1).
-define(T5_SCHEMA, provisional_runtime_tree_t5_state_v1).
-define(T5_PROJECTION, provisional_runtime_tree_t5_projection_v1).
-define(T6_SCHEMA, provisional_runtime_tree_t6_state_v1).
-define(T6_PROJECTION, provisional_runtime_tree_t6_projection_v1).

%% Typed semantic pointers are supplied by the frozen test fixture. This module
%% tests focus transitions and bounded projections, not general NLP relevance.

t4_new() ->
    Branches = #{
        branch_a => branch(branch_a, architecture_work, active,
                           [purpose, accepted_constraints]),
        branch_b => branch(branch_b, runtime_semantics, warm,
                           [experience_base, runtime_tree]),
        branch_b_decoy => branch(branch_b_decoy, runtime_semantics, warm,
                                 [unrelated_same_label]),
        branch_c => branch(branch_c, unrelated_cold_topic, cold,
                           [unrelated_material])},
    #{schema => ?T4_SCHEMA,
      head_version => 0,
      focus => branch_a,
      branches => Branches,
      events => [],
      transitions => [],
      projection_budget_nodes => 2}.

t4_navigate(State0, Event) ->
    Prior = maps:get(focus, State0),
    Pointer = maps:get(semantic_pointer, Event),
    Branches = maps:get(branches, State0),
    case maps:find(Pointer, Branches) of
        {ok, _Branch} ->
            State1 = set_focus_statuses(State0, Pointer),
            commit(State1, focus_changed,
                   #{event_id => maps:get(event_id, Event),
                     prior_focus => Prior,
                     resulting_focus => Pointer,
                     semantic_pointer => Pointer,
                     selection_reason =>
                         {typed_semantic_pointer_for_purpose,
                          maps:get(purpose, Event)}});
        error ->
            commit(State0, navigation_ignored,
                   #{event_id => maps:get(event_id, Event),
                     prior_focus => Prior,
                     resulting_focus => Prior,
                     semantic_pointer => Pointer,
                     selection_reason => no_valid_semantic_pointer})
    end.

t4_project(State, EventId) ->
    Focus = maps:get(focus, State),
    Branches = maps:get(branches, State),
    Budget = maps:get(projection_budget_nodes, State),
    Focal = maps:get(Focus, Branches),
    Projected = [maps:with([id, label, status, semantic_content,
                            identity_version], Focal)],
    Omitted = [#{branch_id => Id,
                 reason => omission_reason(Branch)} ||
                  {Id, Branch} <- maps:to_list(Branches), Id =/= Focus],
    {ok, #{schema => ?T4_PROJECTION,
           graph_version => maps:get(head_version, State),
           for_event => EventId,
           focal_branch => Focus,
           projected_nodes => Projected,
           projected_node_count => length(Projected),
           node_budget => Budget,
           omitted => Omitted,
           selection_reason => latest_focus_transition_reason(State),
           whole_tree_injected => length(Projected) =:= map_size(Branches),
           conceptual_topology => branch_graph,
           operational_topology => separate_supervised_owner_process,
           knowledge_refs => []}}.

t4_snapshot(State) -> State.

t5_new() ->
    Target = #{id => retained_branch,
               label => prior_runtime_problem,
               semantic_pointer => retained_experience_pointer,
               status => active,
               storage_tier => hot,
               identity_version => 1,
               semantic_content =>
                   [original_event, correction, changed_later_selection],
               lineage => [original_event, interpretation, correction],
               canonical => false},
    Decoy = #{id => same_label_decoy,
              label => prior_runtime_problem,
              semantic_pointer => unrelated_decoy_pointer,
              status => warm,
              storage_tier => warm,
              identity_version => 1,
              semantic_content => [unrelated_similar_label],
              lineage => [unrelated_source],
              canonical => false},
    #{schema => ?T5_SCHEMA,
      head_version => 0,
      target_branch => retained_branch,
      branches => #{retained_branch => Target,
                    same_label_decoy => Decoy},
      snapshots => [snapshot_branch(Target, 0, initial_active)],
      transitions => []}.

t5_set_status(State0, NewStatus) when NewStatus =:= dormant;
                                      NewStatus =:= cold ->
    TargetId = maps:get(target_branch, State0),
    Branches0 = maps:get(branches, State0),
    Branch0 = maps:get(TargetId, Branches0),
    PriorStatus = maps:get(status, Branch0),
    Version = maps:get(head_version, State0) + 1,
    Tier = case NewStatus of dormant -> warm; cold -> snapshot_backed end,
    Branch1 = Branch0#{status => NewStatus, storage_tier => Tier},
    Snapshot = snapshot_branch(Branch1, Version,
                               {status_changed, PriorStatus, NewStatus}),
    State1 = State0#{branches => Branches0#{TargetId => Branch1},
                     snapshots => maps:get(snapshots, State0) ++ [Snapshot]},
    stage2_commit(State1, branch_residency_changed,
                  #{branch_id => TargetId,
                    prior_status => PriorStatus,
                    resulting_status => NewStatus,
                    semantic_content_changed => false});
t5_set_status(_State, Other) -> {error, {unsupported_status, Other}}.

t5_reactivate(State0, Event) ->
    TargetId = maps:get(target_branch, State0),
    Branches0 = maps:get(branches, State0),
    Target0 = maps:get(TargetId, Branches0),
    ExpectedPointer = maps:get(semantic_pointer, Target0),
    Pointer = maps:get(semantic_pointer, Event),
    case Pointer =:= ExpectedPointer of
        true ->
            PriorStatus = maps:get(status, Target0),
            Version = maps:get(head_version, State0) + 1,
            Target1 = Target0#{status => active, storage_tier => hot},
            Snapshot = snapshot_branch(
                         Target1, Version,
                         {reactivated_by, maps:get(event_id, Event)}),
            State1 = State0#{branches => Branches0#{TargetId => Target1},
                             snapshots => maps:get(snapshots, State0) ++
                                          [Snapshot]},
            stage2_commit(State1, branch_reactivated,
                          #{event_id => maps:get(event_id, Event),
                            branch_id => TargetId,
                            prior_status => PriorStatus,
                            resulting_status => active,
                            semantic_pointer => Pointer,
                            selection_reason =>
                                pertinent_typed_pointer_to_retained_lineage});
        false ->
            stage2_commit(State0, reactivation_ignored,
                          #{event_id => maps:get(event_id, Event),
                            branch_id => TargetId,
                            prior_status => maps:get(status, Target0),
                            resulting_status => maps:get(status, Target0),
                            semantic_pointer => Pointer,
                            selection_reason => no_matching_trajectory_pointer})
    end.

t5_project(State) ->
    TargetId = maps:get(target_branch, State),
    Target = maps:get(TargetId, maps:get(branches, State)),
    Active = [maps:with([id, label, semantic_pointer, status,
                         identity_version, semantic_content, lineage,
                         canonical], Branch) ||
                 Branch <- maps:values(maps:get(branches, State)),
                 maps:get(status, Branch) =:= active],
    Omitted = case maps:get(status, Target) of
                  active -> [];
                  Status -> [#{branch_id => TargetId,
                               status => Status,
                               reason => not_in_active_projection}]
              end,
    {ok, #{schema => ?T5_PROJECTION,
           graph_version => maps:get(head_version, State),
           target_branch => TargetId,
           target_status => maps:get(status, Target),
           active_branches => Active,
           omitted => Omitted,
           snapshots => maps:get(snapshots, State),
           knowledge_refs => []}}.

t6_new(BranchId, ExperienceMode, KnowledgeMode) ->
    Experience = case ExperienceMode of
        present ->
            #{id => runtime_experience_1,
              trajectory_key => prior_correction_trajectory,
              source_space => experience_base,
              prior_state => #{graph_version => 0,
                               active_interpretation => mistaken_reading},
              event => #{id => experience_event_1,
                         kind => raw_event,
                         text => <<"the runtime encountered the earlier case">>},
              interpretation => #{id => experience_interpretation_1,
                                  kind => interpretation,
                                  value => mistaken_reading},
              correction => #{id => experience_correction_1,
                              kind => correction,
                              value => corrected_reading},
              resulting_state => #{graph_version => 1,
                                   active_interpretation => corrected_reading},
              later_consequence => corrected_projection_selected,
              lineage => [#{kind => raw_event, id => experience_event_1},
                          #{kind => interpretation,
                            id => experience_interpretation_1},
                          #{kind => correction,
                            id => experience_correction_1},
                          #{kind => resulting_state,
                            id => experience_resulting_state_1}]};
        absent -> none
    end,
    Knowledge = case KnowledgeMode of
        matching ->
            [#{id => external_fixture_matching,
               source_space => knowledge_base,
               factual_status => unverified_test_fixture,
               text => <<"a document uses similar correction terminology">>}];
        contradictory ->
            [#{id => external_fixture_contradictory,
               source_space => knowledge_base,
               factual_status => unverified_test_fixture,
               text => <<"a document asserts the opposite recommendation">>}];
        none -> []
    end,
    Log = #{id => timestamp_log_fixture,
            source_space => timestamp_log,
            recorded_at => 99999,
            text => <<"the runtime encountered the earlier case">>,
            causal_participation => none},
    #{schema => ?T6_SCHEMA,
      branch_id => BranchId,
      head_version => 0,
      experience => Experience,
      knowledge => Knowledge,
      logs => [Log],
      recalls => [],
      transitions => [],
      projection_budget_items => 6}.

t6_recall(State0, Query) ->
    Key = maps:get(trajectory_key, Query),
    Experience = maps:get(experience, State0),
    Match = Experience =/= none andalso
            maps:get(trajectory_key, Experience) =:= Key,
    Prior = maps:get(head_version, State0),
    Version = Prior + 1,
    Recall = #{kind => recalls_trajectory,
               query_event => maps:get(event_id, Query),
               trajectory_key => Key,
               matched_experience => case Match of
                                         true -> maps:get(id, Experience);
                                         false -> none
                                     end,
               prior_version => Prior,
               version => Version},
    State1 = State0#{head_version => Version,
                     recalls => maps:get(recalls, State0) ++ [Recall],
                     transitions => maps:get(transitions, State0) ++ [Recall]},
    ExperienceItems = case Match of
        true -> maps:get(lineage, Experience);
        false -> []
    end,
    Knowledge = maps:get(knowledge, State0),
    ProjectedCount = length(ExperienceItems) + length(Knowledge),
    Projection = #{schema => ?T6_PROJECTION,
                   branch_id => maps:get(branch_id, State0),
                   graph_version => Version,
                   query_event => maps:get(event_id, Query),
                   selected_experience => case Match of
                                              true -> Experience;
                                              false -> none
                                          end,
                   experience_items => ExperienceItems,
                   experience_claim => Match,
                   external_knowledge_items => Knowledge,
                   knowledge_refs => [maps:get(id, K) || K <- Knowledge],
                   timestamp_logs => maps:get(logs, State0),
                   logs_used_as_experience => false,
                   recall_relation => Recall,
                   selection_basis => case Match of
                                          true -> causal_runtime_trajectory;
                                          false -> no_matching_runtime_trajectory
                                      end,
                   projected_item_count => ProjectedCount,
                   item_budget => maps:get(projection_budget_items, State0),
                   stakeholder_appraisal => required},
    Receipt = #{schema => provisional_stage2_receipt_v1,
                event_id => maps:get(event_id, Query),
                kind => recalls_trajectory,
                prior_version => Prior,
                graph_version => Version,
                sent => true,
                delivered => true,
                interpreted => true,
                committed => true,
                executed => false,
                selection_reason => maps:get(selection_basis, Projection)},
    {ok, State1, Projection, Receipt}.

head_version(State) -> maps:get(head_version, State).
transitions(State) -> maps:get(transitions, State).

branch(Id, Label, Status, Content) ->
    #{id => Id,
      label => Label,
      status => Status,
      semantic_content => Content,
      identity_version => 1,
      canonical => false}.

set_focus_statuses(State, NewFocus) ->
    PriorFocus = maps:get(focus, State),
    Branches0 = maps:get(branches, State),
    Branches1 = maps:map(
                  fun(Id, Branch) when Id =:= NewFocus ->
                          Branch#{status => active};
                     (Id, Branch) when Id =:= PriorFocus ->
                          Branch#{status => warm};
                     (_Id, Branch) -> Branch
                  end, Branches0),
    State#{focus => NewFocus, branches => Branches1}.

commit(State0, Kind, Change) ->
    PriorVersion = maps:get(head_version, State0),
    Version = PriorVersion + 1,
    Transition = #{kind => Kind,
                   prior_version => PriorVersion,
                   version => Version,
                   change => Change},
    Event = #{event_id => maps:get(event_id, Change),
              version => Version,
              semantic_pointer => maps:get(semantic_pointer, Change)},
    {ok, State0#{head_version => Version,
                 events => maps:get(events, State0) ++ [Event],
                 transitions => maps:get(transitions, State0) ++ [Transition]},
     #{schema => provisional_stage2_receipt_v1,
       event_id => maps:get(event_id, Change),
       kind => Kind,
       prior_version => PriorVersion,
       graph_version => Version,
       sent => true,
       delivered => true,
       interpreted => true,
       committed => true,
       executed => false,
       selection_reason => maps:get(selection_reason, Change)}}.

omission_reason(#{status := cold}) -> cold_and_not_pertinent;
omission_reason(#{id := branch_b_decoy}) -> same_label_without_pointer_relation;
omission_reason(_Branch) -> outside_current_focal_neighborhood.

latest_focus_transition_reason(#{transitions := []}) -> initial_focal_context;
latest_focus_transition_reason(State) ->
    Latest = lists:last(maps:get(transitions, State)),
    maps:get(selection_reason, maps:get(change, Latest)).

snapshot_branch(Branch, Version, Cause) ->
    #{snapshot_schema => provisional_t5_branch_snapshot_v1,
      version => Version,
      branch_id => maps:get(id, Branch),
      identity_version => maps:get(identity_version, Branch),
      status => maps:get(status, Branch),
      storage_tier => maps:get(storage_tier, Branch),
      semantic_content => maps:get(semantic_content, Branch),
      lineage => maps:get(lineage, Branch),
      cause => Cause}.

stage2_commit(State0, Kind, Change) ->
    Prior = maps:get(head_version, State0),
    Version = Prior + 1,
    Transition = #{kind => Kind,
                   prior_version => Prior,
                   version => Version,
                   change => Change},
    {ok, State0#{head_version => Version,
                 transitions => maps:get(transitions, State0) ++ [Transition]},
     #{schema => provisional_stage2_receipt_v1,
       kind => Kind,
       event_id => maps:get(event_id, Change, none),
       prior_version => Prior,
       graph_version => Version,
       sent => true,
       delivered => true,
       interpreted => true,
       committed => true,
       executed => false,
       selection_reason => maps:get(selection_reason, Change,
                                    explicit_status_transition)}}.
