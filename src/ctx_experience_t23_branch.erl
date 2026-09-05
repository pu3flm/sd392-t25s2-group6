-module(ctx_experience_t23_branch).
-behaviour(gen_server).

-export([start_link/3, apply/2, project/2, snapshot/1, status/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

start_link(Name, Mode, BranchId) ->
    gen_server:start_link({local, Name}, ?MODULE, [Mode, BranchId], []).

apply(Name, Action) -> gen_server:call(Name, {apply, Action}, 5000).
project(Name, Query) -> gen_server:call(Name, {project, Query}, 5000).
snapshot(Name) -> gen_server:call(Name, snapshot, 5000).
status(Name) -> gen_server:call(Name, status, 5000).

init([Mode, BranchId]) ->
    Key = {Mode, BranchId},
    Runtime = case ctx_experience_t23_checkpoint:load(Key) of
                  {ok, Saved} -> Saved;
                  error -> new_runtime(Mode, BranchId)
              end,
    ok = ctx_experience_t23_checkpoint:save(Key, Runtime),
    {ok, #{mode => Mode,
           branch_id => BranchId,
           checkpoint_key => Key,
           runtime => Runtime}}.

handle_call({apply, Action}, _From, State0) ->
    Mode = maps:get(mode, State0),
    Runtime0 = maps:get(runtime, State0),
    case apply_action(Mode, Runtime0, Action) of
        {ok, Runtime1, Outcome} ->
            ok = ctx_experience_t23_checkpoint:save(
                   maps:get(checkpoint_key, State0), Runtime1),
            Receipt = receipt(State0, Runtime0, Runtime1, Action, Outcome),
            {reply, {ok, Receipt}, State0#{runtime => Runtime1}};
        {error, _} = Error ->
            {reply, Error, State0}
    end;
handle_call({project, Query}, _From, State) ->
    {reply, project_runtime(maps:get(mode, State),
                            maps:get(runtime, State), Query), State};
handle_call(snapshot, _From, State) ->
    {reply, maps:get(runtime, State), State};
handle_call(status, _From, State) ->
    Runtime = maps:get(runtime, State),
    {message_queue_len, QueueLength} = process_info(self(), message_queue_len),
    {memory, Memory} = process_info(self(), memory),
    {reply, #{mode => maps:get(mode, State),
              branch_id => maps:get(branch_id, State),
              head_version => head_version(maps:get(mode, State), Runtime),
              transition_kinds =>
                  [maps:get(kind, T) ||
                      T <- transitions(maps:get(mode, State), Runtime)],
              message_queue_len => QueueLength,
              process_memory_bytes => Memory}, State}.

handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.

new_runtime(t2, BranchId) -> ctx_experience_t2:new(BranchId);
new_runtime(t3, BranchId) -> ctx_semantic_correction_t3:new(BranchId).

apply_action(t2, Runtime, {form_experience, Spec}) ->
    normalize(ctx_experience_t2:form_experience(Runtime, Spec),
              #{disposition => experience_formed, blocked => false});
apply_action(t2, Runtime, {record_log, Spec}) ->
    normalize(ctx_experience_t2:record_log(Runtime, Spec),
              #{disposition => log_recorded_without_experience_claim,
                blocked => false});
apply_action(t2, Runtime, {observe, Spec}) ->
    normalize(ctx_experience_t2:observe(Runtime, Spec),
              #{disposition => later_event_recorded, blocked => false});
apply_action(t3, Runtime, {seed, Spec}) ->
    ctx_semantic_correction_t3:seed(Runtime, Spec);
apply_action(t3, Runtime, {correct, Spec}) ->
    ctx_semantic_correction_t3:apply_correction(Runtime, Spec);
apply_action(t3, Runtime, {revoke, Spec}) ->
    ctx_semantic_correction_t3:revoke(Runtime, Spec);
apply_action(t3, Runtime, {propose, Spec}) ->
    ctx_semantic_correction_t3:propose(Runtime, Spec).

normalize({ok, Runtime}, Outcome) -> {ok, Runtime, Outcome};
normalize({error, _} = Error, _Outcome) -> Error.

project_runtime(t2, Runtime, {Version, EventId}) ->
    ctx_experience_t2:project(Runtime, Version, EventId);
project_runtime(t3, Runtime, {Version, Scope}) ->
    ctx_semantic_correction_t3:project(Runtime, Version, Scope).

head_version(t2, Runtime) -> ctx_experience_t2:head_version(Runtime);
head_version(t3, Runtime) -> ctx_semantic_correction_t3:head_version(Runtime).

transitions(t2, Runtime) -> ctx_experience_t2:transitions(Runtime);
transitions(t3, Runtime) -> ctx_semantic_correction_t3:transitions(Runtime).

receipt(State, Runtime0, Runtime1, Action, Outcome) ->
    Spec = element(2, Action),
    Blocked = maps:get(blocked, Outcome, false),
    #{schema => provisional_t23_delivery_receipt_v1,
      message_id => maps:get(message_id, Spec),
      recipient => registered_name(),
      branch_id => maps:get(branch_id, State),
      operation => element(1, Action),
      sent => true,
      delivered => true,
      interpreted => true,
      accepted => not Blocked,
      committed => true,
      executed => false,
      prior_version => head_version(maps:get(mode, State), Runtime0),
      graph_version => head_version(maps:get(mode, State), Runtime1),
      semantic_disposition => maps:get(disposition, Outcome),
      governing_correction => maps:get(governing_correction, Outcome, none),
      lineage => maps:get(lineage, Outcome, [])}.

registered_name() ->
    case process_info(self(), registered_name) of
        {registered_name, Name} -> Name;
        [] -> none
    end.
