-module(ctx_sup).
-behaviour(supervisor).

-export([start_link/1, init/1]).

start_link(Opts) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, Opts).

init(Opts) ->
    Manager = #{id => context_manager,
                start => {context_manager, start_link, [Opts]},
                restart => permanent,
                shutdown => 5000,
                type => worker,
                modules => [context_manager]},
    Workers = [worker_spec(ctx_worker_alpha, research),
               worker_spec(ctx_worker_beta, operations),
               worker_spec(ctx_worker_gamma, reflection)],
    {ok, {{one_for_one, 5, 10}, [Manager | Workers]}}.

worker_spec(Name, Scope) ->
    #{id => Name,
      start => {ctx_worker, start_link, [Name, Scope]},
      restart => permanent,
      shutdown => 5000,
      type => worker,
      modules => [ctx_worker]}.
