-module(ctx_runtime_tree_stage2_checkpoint).
-behaviour(gen_server).

-export([start_link/0, load/1, save/2, entries/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(NAME, ctx_runtime_tree_stage2_checkpoint).

start_link() -> gen_server:start_link({local, ?NAME}, ?MODULE, [], []).
load(Key) -> gen_server:call(?NAME, {load, Key}).
save(Key, Value) -> gen_server:call(?NAME, {save, Key, Value}).
entries() -> gen_server:call(?NAME, entries).

init([]) -> {ok, #{}}.
handle_call({load, Key}, _From, State) -> {reply, maps:find(Key, State), State};
handle_call({save, Key, Value}, _From, State) ->
    {reply, ok, State#{Key => Value}};
handle_call(entries, _From, State) -> {reply, State, State}.
handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.
