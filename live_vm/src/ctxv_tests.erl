-module(ctxv_tests).
-export([run/0]).

-define(assert(Expr),
        case (Expr) of true -> ok; _ -> error({assertion_failed, ??Expr}) end).
-define(assertEqual(Expected, Actual),
        assert_equal((Expected), (Actual), ??Expected)).
-define(assertNotEqual(NotExpected, Actual),
        assert_not_equal((NotExpected), (Actual), ??Actual)).

run() ->
    Tests = [
        {raw_turn_roundtrip, fun raw_turn_roundtrip_test/0},
        {four_layers_remain_provisional, fun four_layers_test/0},
        {correction_preserves_lineage, fun correction_lineage_test/0},
        {invalid_input_is_not_journaled, fun invalid_input_test/0},
        {identifier_collision_does_not_overwrite, fun collision_test/0},
        {layer_worker_recovers, fun layer_worker_recovery_test/0},
        {store_recovers_from_journal, fun store_recovery_test/0},
        {full_vm_restart_recovers, fun full_restart_test/0},
        {projection_is_read_only, fun projection_read_only_test/0},
        {response_roundtrip, fun response_roundtrip_test/0}
    ],
    lists:foreach(
      fun({Name, Test}) ->
          Test(),
          io:format("ok ~p~n", [Name])
      end, Tests),
    io:format("10 live-context VM tests passed~n"),
    ok.

raw_turn_roundtrip_test() ->
    with_runtime(fun(_Dir) ->
        Session = <<"s-raw">>,
        Text = <<"sentido exato; sem reescrita">>,
        {accepted, _} = ctxv_store:begin_session(Session, #{owner => user}),
        {accepted, _} = ctxv_store:observe_turn(
                          Session, <<"u-1">>, user, Text,
                          #{source => realtime_voice}),
        Before = ctxv_store:status(),
        {ok, Projection} = ctxv_store:project(Session),
        After = ctxv_store:status(),
        [Turn] = maps:get(turns, Projection),
        ?assertEqual(Text, maps:get(text, Turn)),
        ?assertEqual(maps:get(sequence, Before), maps:get(sequence, After)),
        ?assertEqual(maps:get(head_hash, Before), maps:get(head_hash, After))
    end).

four_layers_test() ->
    with_runtime(fun(_Dir) ->
        Session = <<"s-layers">>,
        Turn = <<"u-1">>,
        {accepted, _} = ctxv_store:begin_session(Session, #{}),
        {accepted, _} = ctxv_store:observe_turn(Session, Turn, user,
                          <<"elaborar por quatro planos">>, #{}),
        Layers = [semantic, symbolic, systemic, epistemic],
        lists:foreach(
          fun(Layer) ->
              ItemId = atom_to_binary(Layer),
              {accepted, _} = ctxv_layer:propose(
                                Layer, Session, Turn, ItemId,
                                <<"hipotese provisoria">>, [],
                                #{author => model})
          end, Layers),
        {ok, Projection} = ctxv_store:project(Session),
        Items = maps:get(items, Projection),
        ?assertEqual(Layers, lists:sort([maps:get(layer, I) || I <- Items])),
        ?assert(lists:all(fun(I) -> maps:get(status, I) =:= provisional end,
                          Items))
    end).

correction_lineage_test() ->
    with_runtime(fun(_Dir) ->
        Session = <<"s-correction">>,
        Turn = <<"u-1">>,
        Item = <<"irony">>,
        {accepted, _} = ctxv_store:begin_session(Session, #{}),
        {accepted, _} = ctxv_store:observe_turn(Session, Turn, user,
                          <<"isso foi ironia">>, #{}),
        {accepted, _} = ctxv_layer:propose(symbolic, Session, Turn, Item,
                          <<"leitura literal">>, [], #{}),
        {accepted, _} = ctxv_store:revise_item(
                          Session, <<"a-1">>, Item,
                          <<"leitura ironica">>, <<"correcao externa">>, user),
        {accepted, _} = ctxv_store:assess_item(
                          Session, <<"a-2">>, Item, accept,
                          <<"confirmado pelo observador">>, user),
        {ok, Projection} = ctxv_store:project(Session),
        [Node] = maps:get(items, Projection),
        ?assertEqual(3, maps:get(version, Node)),
        ?assertEqual(accepted, maps:get(status, Node)),
        ?assertEqual(3, length(maps:get(history, Node))),
        ?assertEqual(<<"leitura ironica">>, maps:get(statement, Node))
    end).

invalid_input_test() ->
    with_runtime(fun(_Dir) ->
        Session = <<"s-invalid">>,
        {accepted, _} = ctxv_store:begin_session(Session, #{}),
        Before = ctxv_store:status(),
        {error, empty_text} = ctxv_store:observe_turn(
                                Session, <<"u-1">>, user, <<>>, #{}),
        AfterReject = ctxv_store:status(),
        ?assertEqual(maps:get(sequence, Before), maps:get(sequence, AfterReject)),
        {accepted, _} = ctxv_store:observe_turn(
                          Session, <<"u-1">>, user, <<"valido">>, #{}),
        AfterAccept = ctxv_store:status(),
        ?assertEqual(maps:get(sequence, Before) + 1,
                     maps:get(sequence, AfterAccept))
    end).

collision_test() ->
    with_runtime(fun(_Dir) ->
        Session = <<"s-collision">>,
        Turn = <<"u-1">>,
        Item = <<"same-id">>,
        {accepted, _} = ctxv_store:begin_session(Session, #{}),
        {accepted, _} = ctxv_store:observe_turn(Session, Turn, user,
                          <<"turn">>, #{}),
        {accepted, _} = ctxv_layer:propose(semantic, Session, Turn, Item,
                          <<"original">>, [], #{}),
        {error, {event_id_collision, _}} = ctxv_layer:propose(
                          semantic, Session, Turn, Item,
                          <<"replacement">>, [], #{}),
        {ok, Projection} = ctxv_store:project(Session),
        [Node] = maps:get(items, Projection),
        ?assertEqual(<<"original">>, maps:get(statement, Node)),
        ?assertEqual(1, maps:get(version, Node))
    end).

layer_worker_recovery_test() ->
    with_runtime(fun(_Dir) ->
        Name = ctxv_layer:name(symbolic),
        Old = whereis(Name),
        exit(Old, kill),
        New = await_new_pid(Name, Old, 100),
        ?assertNotEqual(Old, New),
        ?assertEqual(pong, gen_server:call(Name, ping))
    end).

store_recovery_test() ->
    with_runtime(fun(_Dir) ->
        Session = <<"s-store-restart">>,
        {accepted, _} = ctxv_store:begin_session(Session, #{}),
        {accepted, _} = ctxv_store:observe_turn(Session, <<"u-1">>, user,
                          <<"persistir">>, #{}),
        Old = whereis(ctxv_store),
        exit(Old, kill),
        _New = await_new_pid(ctxv_store, Old, 100),
        {ok, Projection} = ctxv_store:project(Session),
        ?assertEqual(1, length(maps:get(turns, Projection))),
        {ok, Verified} = ctxv_store:verify_journal(),
        ?assertEqual(2, maps:get(entries, Verified))
    end).

full_restart_test() ->
    Dir = test_dir(),
    try
        {ok, Sup1} = ctxv_sup:start_link(#{state_dir => Dir, gateway => false}),
        unlink(Sup1),
        Session = <<"s-full-restart">>,
        {accepted, _} = ctxv_store:begin_session(Session, #{}),
        {accepted, _} = ctxv_store:observe_turn(Session, <<"u-1">>, user,
                          <<"antes do fechamento">>, #{}),
        Seq = maps:get(sequence, ctxv_store:status()),
        stop_sup(Sup1),
        {ok, Sup2} = ctxv_sup:start_link(#{state_dir => Dir, gateway => false}),
        unlink(Sup2),
        ?assertEqual(Seq, maps:get(sequence, ctxv_store:status())),
        {ok, Projection} = ctxv_store:project(Session),
        [Turn] = maps:get(turns, Projection),
        ?assertEqual(<<"antes do fechamento">>, maps:get(text, Turn)),
        stop_sup(Sup2)
    after
        ensure_stopped(),
        ok = file:del_dir_r(Dir)
    end.

projection_read_only_test() ->
    with_runtime(fun(_Dir) ->
        Session = <<"s-read-only">>,
        {accepted, _} = ctxv_store:begin_session(Session, #{}),
        {accepted, _} = ctxv_store:observe_turn(Session, <<"u-1">>, user,
                          <<"observar sem tocar">>, #{}),
        Before = ctxv_store:status(),
        [ctxv_store:project(Session) || _ <- lists:seq(1, 20)],
        After = ctxv_store:status(),
        ?assertEqual(Before, After)
    end).

response_roundtrip_test() ->
    with_runtime(fun(_Dir) ->
        Session = <<"s-response">>,
        Turn = <<"u-1">>,
        {accepted, _} = ctxv_store:begin_session(Session, #{}),
        {accepted, _} = ctxv_store:observe_turn(Session, Turn, user,
                          <<"entrada">>, #{}),
        Revision = maps:get(sequence, ctxv_store:status()),
        {accepted, _} = ctxv_store:record_response(
                          Session, <<"r-1">>, Turn,
                          <<"saida modulada">>, Revision),
        {ok, Projection} = ctxv_store:project(Session),
        [Response] = maps:get(responses, Projection),
        ?assertEqual(Revision, maps:get(context_revision, Response)),
        ?assertEqual(<<"saida modulada">>, maps:get(text, Response))
    end).

with_runtime(Fun) ->
    Dir = test_dir(),
    try
        {ok, Sup} = ctxv_sup:start_link(#{state_dir => Dir, gateway => false}),
        unlink(Sup),
        Fun(Dir),
        stop_sup(Sup)
    after
        ensure_stopped(),
        ok = file:del_dir_r(Dir)
    end.

test_dir() ->
    Base = filename:join(["live_vm", "work", "tests"]),
    ok = filelib:ensure_dir(filename:join(Base, "placeholder")),
    filename:join(Base, integer_to_list(
                  erlang:unique_integer([positive, monotonic]))).

stop_sup(Sup) ->
    Ref = monitor(process, Sup),
    exit(Sup, shutdown),
    receive {'DOWN', Ref, process, Sup, _} -> ok
    after 3000 -> error(supervisor_stop_timeout)
    end.

ensure_stopped() ->
    case whereis(ctxv_sup) of
        undefined -> ok;
        Sup -> stop_sup(Sup)
    end.

await_new_pid(Name, Old, 0) ->
    case whereis(Name) of
        P when is_pid(P), P =/= Old -> P;
        _ -> error({restart_timeout, Name})
    end;
await_new_pid(Name, Old, N) ->
    case whereis(Name) of
        P when is_pid(P), P =/= Old -> P;
        _ -> timer:sleep(10), await_new_pid(Name, Old, N - 1)
    end.

assert_equal(Expected, Expected, _Label) -> ok;
assert_equal(Expected, Got, Label) ->
    error({assert_equal_failed, Label, Expected, Got}).

assert_not_equal(Value, Value, Label) ->
    error({assert_not_equal_failed, Label});
assert_not_equal(_NotExpected, _Actual, _Label) -> ok.
