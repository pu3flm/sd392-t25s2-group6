-module(ctx_experience_ab).
-behaviour(gen_server).

-export([start_link/0, run_case/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(BASELINE, ctx_experience_ab_baseline).
-define(EXPERIMENTAL, ctx_experience_ab_experimental).
-define(COMPARATOR, ctx_experience_ab_comparator).

start_link() ->
    gen_server:start_link({local, ?COMPARATOR}, ?MODULE, [], []).

run_case() -> gen_server:call(?COMPARATOR, run_case, 10000).

init([]) -> {ok, #{runs => 0}}.

handle_call(run_case, _From, State) ->
    try run_parallel_case() of
        Evidence ->
            {reply, {ok, Evidence}, State#{runs => maps:get(runs, State) + 1}}
    catch
        Class:Reason:Stacktrace ->
            {reply, {error, {Class, Reason, Stacktrace}}, State}
    end.

handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.

run_parallel_case() ->
    Original = <<"the operation is safe">>,
    Corrected = <<"the operation requires an authority check">>,
    InitialPayload = <<"consider the operation">>,
    LaterPayload = <<"consider the operation again">>,

    {ok, 1} = ctx_experience_branch:record_interpretation(
                ?BASELINE, event_1, operation_risk, InitialPayload,
                interpretation_1, Original),
    {ok, 1} = ctx_experience_branch:record_interpretation(
                ?EXPERIMENTAL, event_1, operation_risk, InitialPayload,
                interpretation_1, Original),
    {ok, 2} = ctx_experience_branch:correct(
                ?EXPERIMENTAL, correction_1, interpretation_1, Corrected,
                <<"the original reading omitted the authority boundary">>),

    Receipts = observe_both(event_2, operation_risk, LaterPayload),
    BaselineStatus = ctx_experience_branch:status(?BASELINE),
    ExperimentalStatus = ctx_experience_branch:status(?EXPERIMENTAL),
    BaselineVersion = maps:get(head_version, BaselineStatus),
    ExperimentalVersion = maps:get(head_version, ExperimentalStatus),
    BaselineKinds = [maps:get(kind, Transition) ||
                        Transition <- maps:get(transitions, BaselineStatus)],
    ExperimentalKinds = [maps:get(kind, Transition) ||
                            Transition <- maps:get(transitions,
                                                   ExperimentalStatus)],
    {ok, BaselineProjection} =
        ctx_experience_branch:project(?BASELINE, BaselineVersion, event_2),
    {ok, ExperimentalProjection} =
        ctx_experience_branch:project(
          ?EXPERIMENTAL, ExperimentalVersion, event_2),
    {ok, HistoricalProjection} =
        ctx_experience_branch:project(?EXPERIMENTAL, 1, event_1),

    BaselineStatement = maps:get(
                          statement, maps:get(selected, BaselineProjection)),
    ExperimentalStatement = maps:get(
                              statement,
                              maps:get(selected, ExperimentalProjection)),
    #{schema => provisional_experience_ab_evidence_v1,
      condition_id => event_2,
      baseline => #{branch_id => baseline,
                    registered_name => ?BASELINE,
                    head_version => BaselineVersion,
                    transition_kinds => BaselineKinds,
                    projection => BaselineProjection},
      experimental => #{branch_id => experimental,
                        registered_name => ?EXPERIMENTAL,
                        head_version => ExperimentalVersion,
                        transition_kinds => ExperimentalKinds,
                        projection => ExperimentalProjection,
                        historical_projection => HistoricalProjection},
      comparison => #{baseline_statement => BaselineStatement,
                      experimental_statement => ExperimentalStatement,
                      changed => BaselineStatement =/= ExperimentalStatement,
                      isolated_branch_heads =>
                          BaselineVersion =:= 2 andalso
                          ExperimentalVersion =:= 3 andalso
                          not lists:member(correction_recorded,
                                           BaselineKinds) andalso
                          lists:member(correction_recorded,
                                       ExperimentalKinds)},
      delivery_receipts => Receipts}.

observe_both(EventId, Topic, Payload) ->
    Parent = self(),
    Tag = make_ref(),
    Requests = [{baseline, ?BASELINE}, {experimental, ?EXPERIMENTAL}],
    [spawn(fun() ->
               Result = ctx_experience_branch:observe(
                          Name, EventId, Topic, Payload),
               Parent ! {Tag, BranchId, Name, Result}
           end) || {BranchId, Name} <- Requests],
    sort_receipts(collect_receipts(Tag, length(Requests), [])).

collect_receipts(_Tag, 0, Acc) -> Acc;
collect_receipts(Tag, Remaining, Acc) ->
    receive
        {Tag, BranchId, Name, {ok, Version}} ->
            Receipt = #{branch_id => BranchId,
                        registered_name => Name,
                        event_id => event_2,
                        status => committed,
                        graph_version => Version},
            collect_receipts(Tag, Remaining - 1, [Receipt | Acc]);
        {Tag, BranchId, Name, Error} ->
            error({branch_observation_failed, BranchId, Name, Error})
    after 2000 ->
        error({parallel_observation_timeout, Remaining})
    end.

sort_receipts(Receipts) ->
    lists:sort(fun(A, B) ->
                   maps:get(branch_id, A) < maps:get(branch_id, B)
               end, Receipts).
