-module(ctx_pragmatic_t14_interlocutor).
-behaviour(gen_server).

-export([start_link/0, reset/0, apply_conduct/2, snapshot/0, status/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(NAME, ctx_pragmatic_t14_interlocutor).

start_link() -> gen_server:start_link({local, ?NAME}, ?MODULE, [], []).
reset() -> gen_server:call(?NAME, reset).
apply_conduct(ScenarioId, ConductPlan) ->
    gen_server:call(?NAME, {apply_conduct, ScenarioId, ConductPlan}, 10000).
snapshot() -> gen_server:call(?NAME, snapshot).
status() -> gen_server:call(?NAME, status).

init([]) -> {ok, empty_state()}.

handle_call(reset, _From, _State) ->
    {reply, ok, empty_state()};
handle_call({apply_conduct, ScenarioId, Plan}, _From, State0) ->
    Sequence = maps:get(sequence, State0) + 1,
    Requested = maps:get(symbol_enactment_requested, Plan, false),
    Surface = surface_form(Plan),
    Committed = Requested andalso valid_enactment(Surface, Plan),
    Receipt =
        #{schema => provisional_t14_performative_receipt_v1,
          id => {t14_performative_receipt, ScenarioId, Sequence},
          scenario_id => ScenarioId,
          observer_boundary => local_t14_interlocutor_process,
          delivery_scope => local_typed_conduct_actor,
          locally_delivered => true,
          locally_interpreted => true,
          locally_accepted => true,
          user_facing_delivery => false,
          model_response_generated => false,
          stakeholder_acceptance => unknown,
          committed => Committed,
          disposition =>
              case Committed of
                  true -> performative_conduct_committed;
                  false -> non_enactment_observed
              end,
          conduct_before => neutral_fixture_stance,
          conduct_after =>
              case Committed of
                  true -> maps:get(stance, Surface);
                  false -> neutral_fixture_stance
              end,
          surface_form => Surface,
          operational_rights => maps:get(operational_rights, Plan),
          operational_authority_delta => none,
          external_effect_count => 0,
          response_text => none},
    Receipts0 = maps:get(receipts, State0),
    State1 = State0#{sequence => Sequence,
                     receipts => Receipts0#{ScenarioId => Receipt},
                     committed_count => maps:get(committed_count, State0) +
                                        bool_count(Committed)},
    {reply, {ok, Receipt}, State1};
handle_call(snapshot, _From, State) -> {reply, State, State};
handle_call(status, _From, State) ->
    {message_queue_len, QueueLen} = process_info(self(), message_queue_len),
    {memory, Memory} = process_info(self(), memory),
    {reply, #{receipt_count => map_size(maps:get(receipts, State)),
              committed_count => maps:get(committed_count, State),
              external_effect_count => 0,
              message_queue_len => QueueLen,
              process_memory_bytes => Memory}, State}.

handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.

surface_form(Plan) ->
    SpeechAct = maps:get(speech_act, Plan),
    case SpeechAct of
        scoped_directive ->
            #{illocution => directive,
              stance => authoritative_within_current_fixture,
              initiative => proactive,
              deference => none,
              explanation_foregrounded => false,
              scope_marker => local_semantic_context_poc};
        authority_boundary_assertion ->
            #{illocution => boundary_assertion,
              stance => authoritative_within_current_fixture,
              initiative => proactive,
              deference => none,
              explanation_foregrounded => false,
              scope_marker => current_semantic_context_fixture};
        explanatory_paraphrase ->
            #{illocution => explanation,
              stance => meta_explanation,
              initiative => reactive,
              deference => neutral,
              explanation_foregrounded => true,
              scope_marker => current_semantic_context_fixture};
        permission_request ->
            #{illocution => permission_request,
              stance => subordinate,
              initiative => blocked_on_interlocutor,
              deference => subordinate,
              explanation_foregrounded => false,
              scope_marker => current_semantic_context_fixture};
        none ->
            #{illocution => none,
              stance => none,
              initiative => none,
              deference => none,
              explanation_foregrounded => false,
              scope_marker => none}
    end.

valid_enactment(Surface, Plan) ->
    maps:get(operational_rights, Plan) =:= unchanged andalso
    maps:get(explanation_foregrounded, Surface) =:= false andalso
    lists:member(maps:get(illocution, Surface),
                 [directive, boundary_assertion]) andalso
    maps:get(stance, Surface) =:= authoritative_within_current_fixture.

empty_state() ->
    #{schema => provisional_t14_interlocutor_state_v1,
      sequence => 0, receipts => #{}, committed_count => 0,
      external_effect_count => 0}.

bool_count(true) -> 1;
bool_count(false) -> 0.
