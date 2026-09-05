-module(ctx_experience_branch).
-behaviour(gen_server).

-export([start_link/2, record_interpretation/6, correct/5, observe/4,
         project/3, status/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

start_link(Name, BranchId) ->
    gen_server:start_link({local, Name}, ?MODULE, [BranchId], []).

record_interpretation(Name, EventId, Topic, Payload,
                      InterpretationId, Statement) ->
    gen_server:call(Name, {record_interpretation, EventId, Topic, Payload,
                           InterpretationId, Statement}).

correct(Name, CorrectionId, InterpretationId, Replacement, Reason) ->
    gen_server:call(Name, {correct, CorrectionId, InterpretationId,
                           Replacement, Reason}).

observe(Name, EventId, Topic, Payload) ->
    gen_server:call(Name, {observe, EventId, Topic, Payload}).

project(Name, Version, EventId) ->
    gen_server:call(Name, {project, Version, EventId}).

status(Name) -> gen_server:call(Name, status).

init([BranchId]) ->
    {ok, #{branch_id => BranchId,
           runtime => ctx_experience_slice:new(BranchId)}}.

handle_call({record_interpretation, EventId, Topic, Payload,
             InterpretationId, Statement}, _From, State0) ->
    update_runtime(
      fun(Runtime) ->
          ctx_experience_slice:record_interpretation(
            Runtime, EventId, Topic, Payload, InterpretationId, Statement)
      end, State0);
handle_call({correct, CorrectionId, InterpretationId, Replacement, Reason},
            _From, State0) ->
    update_runtime(
      fun(Runtime) ->
          ctx_experience_slice:correct(
            Runtime, CorrectionId, InterpretationId, Replacement, Reason)
      end, State0);
handle_call({observe, EventId, Topic, Payload}, _From, State0) ->
    update_runtime(
      fun(Runtime) ->
          ctx_experience_slice:observe(Runtime, EventId, Topic, Payload)
      end, State0);
handle_call({project, Version, EventId}, _From, State) ->
    {reply, ctx_experience_slice:project(
              maps:get(runtime, State), Version, EventId), State};
handle_call(status, _From, State) ->
    Runtime = maps:get(runtime, State),
    {reply, #{branch_id => maps:get(branch_id, State),
              head_version => ctx_experience_slice:head_version(Runtime),
              transitions => ctx_experience_slice:transitions(Runtime)}, State}.

handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.

update_runtime(Fun, State0) ->
    Runtime0 = maps:get(runtime, State0),
    case Fun(Runtime0) of
        {ok, Runtime1} ->
            Version = ctx_experience_slice:head_version(Runtime1),
            {reply, {ok, Version}, State0#{runtime => Runtime1}};
        {error, _} = Error ->
            {reply, Error, State0}
    end.
