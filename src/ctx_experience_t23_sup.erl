-module(ctx_experience_t23_sup).
-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    Children = [
        worker(ctx_experience_t23_checkpoint,
               {ctx_experience_t23_checkpoint, start_link, []},
               ctx_experience_t23_checkpoint),
        branch(ctx_t2_history_a, t2, history_a),
        branch(ctx_t2_history_b, t2, history_b),
        branch(ctx_t2_sham, t2, sham_log_only),
        branch(ctx_t3_baseline, t3, t3_uncorrected),
        branch(ctx_t3_corrected, t3, t3_corrected),
        branch(ctx_t3_revoked, t3, t3_revoked_counterfactual),
        worker(ctx_experience_t23_comparator,
               {ctx_experience_t23, start_link, []},
               ctx_experience_t23)
    ],
    {ok, {{one_for_one, 5, 10}, Children}}.

branch(Name, Mode, BranchId) ->
    worker(Name,
           {ctx_experience_t23_branch, start_link, [Name, Mode, BranchId]},
           ctx_experience_t23_branch).

worker(Id, Start, Module) ->
    #{id => Id,
      start => Start,
      restart => permanent,
      shutdown => 5000,
      type => worker,
      modules => [Module]}.
