-module(ctx_live_poc_t3_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

-define(NAME, ctx_live_poc_t3_sup).

start_link() -> supervisor:start_link({local, ?NAME}, ?MODULE, []).

init([]) ->
    Baseline = #{id => ctx_live_poc_t3_baseline,
                 start => {ctx_live_poc_t3_branch, start_link,
                           [ctx_live_poc_t3_baseline, offline_baseline]},
                 restart => permanent, shutdown => 5000, type => worker,
                 modules => [ctx_live_poc_t3_branch]},
    Variant = #{id => ctx_live_poc_t3_variant,
                start => {ctx_live_poc_t3_branch, start_link,
                          [ctx_live_poc_t3_variant, live_variant]},
                restart => permanent, shutdown => 5000, type => worker,
                modules => [ctx_live_poc_t3_branch]},
    Consumer = #{id => ctx_live_poc_t3_consumer,
                 start => {ctx_live_poc_t3_consumer, start_link, []},
                 restart => permanent, shutdown => 5000, type => worker,
                 modules => [ctx_live_poc_t3_consumer]},
    Runner = #{id => ctx_live_poc_t3_runner,
               start => {ctx_live_poc_t3_runner, start_link, []},
               restart => permanent, shutdown => 5000, type => worker,
               modules => [ctx_live_poc_t3_runner]},
    {ok, {{one_for_one, 4, 5}, [Baseline, Variant, Consumer, Runner]}}.
