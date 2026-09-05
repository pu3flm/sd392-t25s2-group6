-module(context_runtime_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_Type, _Args) ->
    Storage = application:get_env(context_runtime, storage_dir, "_context_state"),
    Budget = application:get_env(context_runtime, hot_budget, 4),
    ctx_sup:start_link(#{storage_dir => Storage, hot_budget => Budget}).

stop(_State) -> ok.
