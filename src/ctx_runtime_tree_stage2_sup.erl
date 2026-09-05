-module(ctx_runtime_tree_stage2_sup).
-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() -> supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    Children = [
        worker(ctx_runtime_tree_stage2_checkpoint,
               {ctx_runtime_tree_stage2_checkpoint, start_link, []},
               ctx_runtime_tree_stage2_checkpoint),
        worker(ctx_runtime_tree_stage2_owner,
               {ctx_runtime_tree_stage2_owner, start_link, []},
               ctx_runtime_tree_stage2_owner),
        worker(ctx_runtime_tree_stage2_runner,
               {ctx_runtime_tree_stage2_runner, start_link, []},
               ctx_runtime_tree_stage2_runner)
    ],
    {ok, {{one_for_one, 5, 10}, Children}}.

worker(Id, Start, Module) ->
    #{id => Id,
      start => Start,
      restart => permanent,
      shutdown => 5000,
      type => worker,
      modules => [Module]}.
