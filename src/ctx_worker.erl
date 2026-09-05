-module(ctx_worker).
-behaviour(gen_server).

-export([start_link/2, event/3, status/1, crash/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

start_link(Name, Scope) ->
    gen_server:start_link({local, Name}, ?MODULE, [Name, Scope], []).

event(Name, EventId, Event) ->
    gen_server:call(Name, {event, EventId, Event}).

status(Name) -> gen_server:call(Name, status).

crash(Name) -> gen_server:call(Name, simulated_crash).

init([Name, Scope]) ->
    %% The process is ephemeral. Durable, semantically relevant state belongs to
    %% the manager and is recovered here after a local restart.
    Durable = context_manager:worker_state(Name, Scope),
    {ok, #{name => Name, scope => Scope, durable => Durable}}.

handle_call({event, EventId, Event}, _From, State) ->
    Name = maps:get(name, State),
    Scope = maps:get(scope, State),
    Reply = context_manager:apply_event(Name, Scope, EventId, Event),
    Durable = context_manager:worker_state(Name, Scope),
    {reply, Reply, State#{durable => Durable}};
handle_call(status, _From, State) ->
    {reply, State, State};
handle_call(simulated_crash, _From, State) ->
    exit({simulated_failure, maps:get(name, State)}).

handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVsn, State, _Extra) -> {ok, State}.
