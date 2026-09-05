-module(ctx_runtime_tree_stage4_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

-define(NAME, ctx_runtime_tree_stage4_sup).

start_link() -> supervisor:start_link({local, ?NAME}, ?MODULE, []).

init([]) ->
    Checkpoint = #{id => ctx_runtime_tree_stage4_checkpoint,
                   start => {ctx_runtime_tree_stage4_checkpoint,
                             start_link, []},
                   restart => permanent, shutdown => 5000, type => worker,
                   modules => [ctx_runtime_tree_stage4_checkpoint]},
    Worker = #{id => ctx_runtime_tree_stage4_worker,
               start => {ctx_runtime_tree_stage4_worker, start_link, []},
               restart => permanent, shutdown => 5000, type => worker,
               modules => [ctx_runtime_tree_stage4_worker]},
    Resource = #{id => ctx_runtime_tree_stage4_resource,
                 start => {ctx_runtime_tree_stage4_resource, start_link, []},
                 restart => permanent, shutdown => 5000, type => worker,
                 modules => [ctx_runtime_tree_stage4_resource]},
    Runner = #{id => ctx_runtime_tree_stage4_runner,
               start => {ctx_runtime_tree_stage4_runner, start_link, []},
               restart => permanent, shutdown => 5000, type => worker,
               modules => [ctx_runtime_tree_stage4_runner]},
    {ok, {{one_for_one, 6, 5}, [Checkpoint, Worker, Resource, Runner]}}.
