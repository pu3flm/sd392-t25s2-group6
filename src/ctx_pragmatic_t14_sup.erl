-module(ctx_pragmatic_t14_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

-define(NAME, ctx_pragmatic_t14_sup).

start_link() -> supervisor:start_link({local, ?NAME}, ?MODULE, []).

init([]) ->
    Interlocutor = #{id => ctx_pragmatic_t14_interlocutor,
                     start => {ctx_pragmatic_t14_interlocutor,
                               start_link, []},
                     restart => permanent, shutdown => 5000, type => worker,
                     modules => [ctx_pragmatic_t14_interlocutor]},
    Runtime = #{id => ctx_pragmatic_t14_runtime,
                start => {ctx_pragmatic_t14_runtime, start_link, []},
                restart => permanent, shutdown => 5000, type => worker,
                modules => [ctx_pragmatic_t14_runtime]},
    Runner = #{id => ctx_pragmatic_t14_runner,
               start => {ctx_pragmatic_t14_runner, start_link, []},
               restart => permanent, shutdown => 5000, type => worker,
               modules => [ctx_pragmatic_t14_runner]},
    {ok, {{one_for_one, 4, 5}, [Interlocutor, Runtime, Runner]}}.
