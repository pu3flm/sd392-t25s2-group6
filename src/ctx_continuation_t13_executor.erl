-module(ctx_continuation_t13_executor).
-behaviour(gen_server).

-export([start_link/2, inheritance_receipt/1, begin_item/1, status/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

start_link(Item, Envelope) -> gen_server:start_link(?MODULE, [Item, Envelope], []).
inheritance_receipt(Pid) -> gen_server:call(Pid, inheritance_receipt).
begin_item(Pid) -> gen_server:call(Pid, begin_item).
status(Pid) -> gen_server:call(Pid, status).

init([Item, Envelope]) ->
    Required = [grant, correction_frontier, dependency_snapshot, scope,
                bounds, evidence_obligations, stop_conditions,
                continuation_rule],
    Complete = lists:all(fun(Key) -> maps:is_key(Key, Envelope) end, Required),
    Receipt = #{schema => provisional_t13_inheritance_receipt_v1,
                item_id => maps:get(id, Item),
                envelope_version => maps:get(version, Envelope),
                envelope_digest => digest(Envelope),
                required_fields => Required,
                complete => Complete,
                acknowledged => Complete,
                started => false,
                external_effect => false},
    {ok, #{item => Item, envelope => Envelope, inheritance => Receipt,
           started => false}}.

handle_call(inheritance_receipt, _From, State) ->
    {reply, maps:get(inheritance, State), State};
handle_call(begin_item, _From, #{started := false} = State0) ->
    Receipt0 = maps:get(inheritance, State0),
    true = maps:get(acknowledged, Receipt0),
    Receipt = Receipt0#{started => true,
                        disposition => grounded_successor_started,
                        action => begin_bounded_semantic_test},
    {reply, {ok, Receipt},
     State0#{started => true, inheritance => Receipt}};
handle_call(begin_item, _From, State) ->
    {reply, {error, already_started}, State};
handle_call(status, _From, State) ->
    {message_queue_len, Queue} = process_info(self(), message_queue_len),
    {memory, Memory} = process_info(self(), memory),
    {reply, #{item_id => maps:get(id, maps:get(item, State)),
              started => maps:get(started, State),
              inheritance => maps:get(inheritance, State),
              message_queue_len => Queue,
              process_memory_bytes => Memory}, State}.

handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.

digest(Term) -> crypto:hash(sha256, term_to_binary(Term)).
