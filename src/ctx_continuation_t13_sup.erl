-module(ctx_continuation_t13_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

-define(NAME, ctx_continuation_t13_sup).

start_link() -> supervisor:start_link({local, ?NAME}, ?MODULE, []).

init([]) ->
    Queue = #{id => ctx_continuation_t13_queue,
              start => {ctx_continuation_t13_queue, start_link, []},
              restart => permanent, shutdown => 5000, type => worker,
              modules => [ctx_continuation_t13_queue]},
    Runner = #{id => ctx_continuation_t13_runner,
               start => {ctx_continuation_t13_runner, start_link, []},
               restart => permanent, shutdown => 5000, type => worker,
               modules => [ctx_continuation_t13_runner]},
    {ok, {{one_for_one, 4, 5}, [Queue, Runner]}}.
