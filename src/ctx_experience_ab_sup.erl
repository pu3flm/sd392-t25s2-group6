-module(ctx_experience_ab_sup).
-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    Baseline = #{id => ctx_experience_ab_baseline,
                 start => {ctx_experience_branch, start_link,
                           [ctx_experience_ab_baseline, baseline]},
                 restart => permanent,
                 shutdown => 5000,
                 type => worker,
                 modules => [ctx_experience_branch]},
    Experimental = #{id => ctx_experience_ab_experimental,
                     start => {ctx_experience_branch, start_link,
                               [ctx_experience_ab_experimental, experimental]},
                     restart => permanent,
                     shutdown => 5000,
                     type => worker,
                     modules => [ctx_experience_branch]},
    Comparator = #{id => ctx_experience_ab_comparator,
                   start => {ctx_experience_ab, start_link, []},
                   restart => permanent,
                   shutdown => 5000,
                   type => worker,
                   modules => [ctx_experience_ab]},
    {ok, {{one_for_one, 3, 10}, [Baseline, Experimental, Comparator]}}.
