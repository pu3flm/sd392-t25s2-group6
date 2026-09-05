-module(ctx_runtime_tree_stage2_owner).
-behaviour(gen_server).

-export([start_link/0, t4_navigate/1, t4_project/1,
         t5_set_status/1, t5_reactivate/1, t5_project/0,
         state/1, status/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(NAME, ctx_runtime_tree_stage2_owner).
-define(CHECKPOINT_KEY, stage2_owner_state).

start_link() -> gen_server:start_link({local, ?NAME}, ?MODULE, [], []).
t4_navigate(Event) -> gen_server:call(?NAME, {t4_navigate, Event}).
t4_project(EventId) -> gen_server:call(?NAME, {t4_project, EventId}).
t5_set_status(Status) -> gen_server:call(?NAME, {t5_set_status, Status}).
t5_reactivate(Event) -> gen_server:call(?NAME, {t5_reactivate, Event}).
t5_project() -> gen_server:call(?NAME, t5_project).
state(Test) -> gen_server:call(?NAME, {state, Test}).
status() -> gen_server:call(?NAME, status).

init([]) ->
    State = case ctx_runtime_tree_stage2_checkpoint:load(?CHECKPOINT_KEY) of
                {ok, Saved} -> Saved;
                error -> #{t4 => ctx_runtime_tree_stage2:t4_new(),
                           t5 => ctx_runtime_tree_stage2:t5_new()}
            end,
    ok = ctx_runtime_tree_stage2_checkpoint:save(?CHECKPOINT_KEY, State),
    {ok, State}.

handle_call({t4_navigate, Event}, _From, State0) ->
    T40 = maps:get(t4, State0),
    case ctx_runtime_tree_stage2:t4_navigate(T40, Event) of
        {ok, T41, Receipt} ->
            State1 = State0#{t4 => T41},
            ok = ctx_runtime_tree_stage2_checkpoint:save(
                   ?CHECKPOINT_KEY, State1),
            {reply, {ok, Receipt}, State1};
        {error, _} = Error -> {reply, Error, State0}
    end;
handle_call({t4_project, EventId}, _From, State) ->
    {reply, ctx_runtime_tree_stage2:t4_project(
              maps:get(t4, State), EventId), State};
handle_call({t5_set_status, Status}, _From, State0) ->
    T50 = maps:get(t5, State0),
    case ctx_runtime_tree_stage2:t5_set_status(T50, Status) of
        {ok, T51, Receipt} ->
            State1 = State0#{t5 => T51},
            ok = ctx_runtime_tree_stage2_checkpoint:save(
                   ?CHECKPOINT_KEY, State1),
            {reply, {ok, Receipt}, State1};
        {error, _} = Error -> {reply, Error, State0}
    end;
handle_call({t5_reactivate, Event}, _From, State0) ->
    T50 = maps:get(t5, State0),
    case ctx_runtime_tree_stage2:t5_reactivate(T50, Event) of
        {ok, T51, Receipt} ->
            State1 = State0#{t5 => T51},
            ok = ctx_runtime_tree_stage2_checkpoint:save(
                   ?CHECKPOINT_KEY, State1),
            {reply, {ok, Receipt}, State1};
        {error, _} = Error -> {reply, Error, State0}
    end;
handle_call(t5_project, _From, State) ->
    {reply, ctx_runtime_tree_stage2:t5_project(maps:get(t5, State)), State};
handle_call({state, Test}, _From, State) ->
    {reply, maps:get(Test, State), State};
handle_call(status, _From, State) ->
    {message_queue_len, Queue} = process_info(self(), message_queue_len),
    {memory, Memory} = process_info(self(), memory),
    T4 = maps:get(t4, State),
    T5 = maps:get(t5, State),
    {reply, #{t4_head_version =>
                  ctx_runtime_tree_stage2:head_version(T4),
              t4_transition_kinds =>
                  [maps:get(kind, T) ||
                      T <- ctx_runtime_tree_stage2:transitions(T4)],
              t5_head_version =>
                  ctx_runtime_tree_stage2:head_version(T5),
              t5_transition_kinds =>
                  [maps:get(kind, T) ||
                      T <- ctx_runtime_tree_stage2:transitions(T5)],
              message_queue_len => Queue,
              process_memory_bytes => Memory}, State}.

handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.
