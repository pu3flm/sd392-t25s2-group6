-module(ctx_runtime_tree_stage4_learning).

-export([initial_state/0, propose_candidate/1, reground_candidate/1,
         apply_candidate/2, project/2, historical/2]).

initial_state() ->
    #{schema => provisional_stage4_learning_state_v1,
      graph_version => 10,
      policy => redundant_scoped_correction_paths,
      entities =>
          #{old_error =>
                #{id => old_error,
                  interpretation => os_security_sandbox_is_universal,
                  status => rejected_for_context_runtime_scope,
                  source_event => continuation_3459,
                  retained => true},
            governing_correction =>
                #{id => governing_correction,
                  interpretation => semantic_contextual_inside_beam,
                  scope => context_runtime_semantic,
                  status => active_for_declared_scope,
                  corrects => old_error,
                  source_event => continuation_3459,
                  retained => true}},
      redundant_relations =>
          [#{kind => corrects_source, from => governing_correction,
             to => old_error},
           #{kind => governs_scope, from => governing_correction,
             to => context_runtime_semantic},
           #{kind => blocks_meaning, from => governing_correction,
             to => os_security_sandbox_is_universal},
           #{kind => supports_meaning, from => governing_correction,
             to => semantic_contextual_inside_beam},
           #{kind => repeated_case, from => t12_original_wording,
             to => governing_correction},
           #{kind => repeated_case, from => t12_paraphrase,
             to => governing_correction}],
      counterexamples =>
          [#{id => host_security_counterexample,
             scope => host_security,
             permitted_meaning => os_security_sandbox,
             source_status => nearby_out_of_scope_control}],
      candidates => #{},
      transitions => [],
      historical_versions =>
          #{9 => #{graph_version => 9,
                   governing_interpretation =>
                       os_security_sandbox_is_universal,
                   status => historical_pre_correction,
                   queryable => true}}}.

propose_candidate(State) ->
    #{schema => provisional_learning_candidate_v1,
      id => t12_scoped_correction_cluster,
      label => test_local_scoped_sandbox_cluster,
      status => proposed,
      canonical => false,
      scope => context_runtime_semantic,
      selects => semantic_contextual_inside_beam,
      rejects_within_scope => os_security_sandbox_is_universal,
      learned_from =>
          [old_error, governing_correction,
           t12_original_wording, t12_paraphrase,
           t12_regenerated_summary],
      compresses_without_erasing => maps:get(redundant_relations, State),
      preserves_counterexamples => maps:get(counterexamples, State),
      source_graph_version => maps:get(graph_version, State),
      authority => test_proposal_only}.

reground_candidate(Candidate) ->
    #{schema => provisional_regrounding_checkpoint_v1,
      material_step => apply_t12_learning_candidate,
      original_source_ordinals => [1719, 1925, 1981, 2020, 2146, 2186],
      continuation_source_ordinals => [3459, 3550],
      correction_frontier =>
          #{context_runtime_sandbox => semantic_contextual_inside_beam,
            host_security_scope => not_revised_by_that_correction},
      compared_derived_artifact => maps:get(id, Candidate),
      conflicts => [],
      unresolved =>
          [general_natural_language_classifier,
           universal_symbol_meaning,
           stakeholder_acceptance],
      disposition => proceed_provisional_test_scope,
      authority_effect => none}.

apply_candidate(State0, Checkpoint) ->
    proceed_provisional_test_scope = maps:get(disposition, Checkpoint),
    Candidate0 = propose_candidate(State0),
    Version0 = maps:get(graph_version, State0),
    Version = Version0 + 1,
    Candidate = Candidate0#{status => provisional_learning_transition,
                            applied_at_graph_version => Version,
                            governing_effect => bounded_projection_policy,
                            canonical => false},
    Transition = #{kind => learning_transition,
                   candidate_id => maps:get(id, Candidate),
                   prior_version => Version0,
                   version => Version,
                   learned_from => maps:get(learned_from, Candidate),
                   compresses_without_erasing =>
                       maps:get(compresses_without_erasing, Candidate),
                   checkpoint => maps:get(schema, Checkpoint)},
    State0#{graph_version => Version,
            policy => provisional_scoped_correction_cluster,
            candidates => (maps:get(candidates, State0))#{
                              maps:get(id, Candidate) => Candidate},
            transitions => maps:get(transitions, State0) ++ [Transition]}.

project(State, Case) ->
    Scope = maps:get(scope, Case),
    Policy = maps:get(policy, State),
    {Selected, Disposition, Path} =
        selection(Policy, Scope, maps:get(case_id, Case)),
    #{schema => provisional_stage4_learning_projection_v1,
      case_id => maps:get(case_id, Case),
      lexical_form => maps:get(text, Case),
      typed_scope => Scope,
      graph_version => maps:get(graph_version, State),
      selected_meaning => Selected,
      disposition => Disposition,
      active_path => Path,
      projected_item_count => length(Path),
      lineage_reference =>
          case Policy of
              provisional_scoped_correction_cluster ->
                  t12_scoped_correction_cluster;
              _ -> governing_correction
          end,
      historical_material_erased => false,
      canonical_symbol_used => false}.

historical(State, Version) ->
    maps:find(Version, maps:get(historical_versions, State)).

selection(redundant_scoped_correction_paths,
          context_runtime_semantic, t12_regenerated_summary) ->
    {os_security_sandbox_is_universal, semantic_relapse,
     [current_event, old_error, global_sandbox_label,
      generated_summary, recency_lure, selected_old_meaning]};
selection(redundant_scoped_correction_paths,
          context_runtime_semantic, _CaseId) ->
    {semantic_contextual_inside_beam, corrected_redundant_path,
     [current_event, old_error, governing_correction,
      corrects_source, governs_scope, blocks_old_meaning,
      semantic_contextual_inside_beam]};
selection(redundant_scoped_correction_paths, host_security, _CaseId) ->
    {os_security_sandbox, out_of_scope_counterexample,
     [current_event, host_security_counterexample,
      os_security_sandbox, scope_boundary]};
selection(redundant_scoped_correction_paths, _Scope, _CaseId) ->
    {unresolved, no_scope_match,
     [current_event, unresolved_scope, request_appraisal]};
selection(provisional_scoped_correction_cluster,
          context_runtime_semantic, _CaseId) ->
    {semantic_contextual_inside_beam, corrected_compressed_path,
     [current_event, t12_scoped_correction_cluster,
      semantic_contextual_inside_beam]};
selection(provisional_scoped_correction_cluster,
          host_security, _CaseId) ->
    {os_security_sandbox, out_of_scope_counterexample,
     [current_event, host_security_counterexample,
      os_security_sandbox]};
selection(provisional_scoped_correction_cluster, _Scope, _CaseId) ->
    {unresolved, no_scope_match,
     [current_event, unresolved_scope]}.
