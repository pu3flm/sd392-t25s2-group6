-module(ctx_runtime_tree_stage4_worker).
-behaviour(gen_server).

-export([start_link/0, process/2, status/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(NAME, ctx_runtime_tree_stage4_worker).

start_link() -> gen_server:start_link({local, ?NAME}, ?MODULE, [], []).
process(Event, FaultMode) ->
    gen_server:call(?NAME, {process, Event, FaultMode}, 5000).
status() -> gen_server:call(?NAME, status).

init([]) -> {ok, #{handled => 0}}.

handle_call({process, Event, before_commit}, _From, State) ->
    exit({injected_fault, before_semantic_commit, maps:get(event_id, Event)}),
    {reply, unreachable, State};
handle_call({process, Event, after_commit_before_reply}, _From, State) ->
    {ok, _Receipt} = ctx_runtime_tree_stage4_checkpoint:commit(Event),
    exit({injected_fault, after_commit_before_reply, maps:get(event_id, Event)}),
    {reply, unreachable, State};
handle_call({process, Event, poison}, _From, State) ->
    case ctx_runtime_tree_stage4_checkpoint:poison_attempt(Event) of
        {crash, _Receipt} ->
            exit({poison_event, maps:get(event_id, Event)}),
            {reply, unreachable, State};
        {quarantined, Receipt} ->
            {reply, {quarantined, Receipt},
             State#{handled => maps:get(handled, State) + 1}}
    end;
handle_call({process, Event, none}, _From, State) ->
    Reply = ctx_runtime_tree_stage4_checkpoint:commit(Event),
    {reply, Reply, State#{handled => maps:get(handled, State) + 1}};
handle_call(status, _From, State) ->
    {message_queue_len, Queue} = process_info(self(), message_queue_len),
    {memory, Memory} = process_info(self(), memory),
    {reply, State#{message_queue_len => Queue,
                   process_memory_bytes => Memory}, State}.

handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.
