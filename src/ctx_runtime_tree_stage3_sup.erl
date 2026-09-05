-module(ctx_runtime_tree_stage3_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

-define(NAME, ctx_runtime_tree_stage3_sup).

start_link() -> supervisor:start_link({local, ?NAME}, ?MODULE, []).

init([]) ->
    Interlocutor = #{id => ctx_runtime_tree_stage3_interlocutor,
                     start => {ctx_runtime_tree_stage3_interlocutor,
                               start_link, []},
                     restart => permanent,
                     shutdown => 5000,
                     type => worker,
                     modules => [ctx_runtime_tree_stage3_interlocutor]},
    Planner = #{id => ctx_runtime_tree_stage3_planner,
                start => {ctx_runtime_tree_stage3_planner, start_link, []},
                restart => permanent,
                shutdown => 5000,
                type => worker,
                modules => [ctx_runtime_tree_stage3_planner]},
    Runner = #{id => ctx_runtime_tree_stage3_runner,
               start => {ctx_runtime_tree_stage3_runner, start_link, []},
               restart => permanent,
               shutdown => 5000,
               type => worker,
               modules => [ctx_runtime_tree_stage3_runner]},
    {ok, {{one_for_one, 3, 5}, [Interlocutor, Planner, Runner]}}.
