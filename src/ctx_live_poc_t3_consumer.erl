-module(ctx_live_poc_t3_consumer).
-behaviour(gen_server).

-export([start_link/0, reset/0, produce_without_projection/1,
         consume_projection/2, status/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(NAME, ctx_live_poc_t3_consumer).

start_link() -> gen_server:start_link({local, ?NAME}, ?MODULE, [], []).
reset() -> gen_server:call(?NAME, reset).
produce_without_projection(Event) ->
    gen_server:call(?NAME, {produce_without_projection, Event}).
consume_projection(Projection, Event) ->
    gen_server:call(?NAME, {consume_projection, Projection, Event}).
status() -> gen_server:call(?NAME, status).

init([]) -> {ok, #{outputs => 0, projected_inputs => 0}}.

handle_call(reset, _From, _State) ->
    {reply, ok, #{outputs => 0, projected_inputs => 0}};
handle_call({produce_without_projection, Event}, _From, State0) ->
    Result = #{schema => provisional_t3_consumer_result_v1,
               output_id => t3_baseline_output,
               output => {bounded_response, maps:get(event_id, Event)},
               projection_id => none,
               source_graph_version => none,
               input_mode => raw_event_without_projection},
    {reply, {ok, Result}, State0#{outputs => maps:get(outputs, State0) + 1}};
handle_call({consume_projection, Projection, Event}, _From, State0) ->
    true = maps:get(graph_version, Projection) > 0,
    true = maps:get(projected_node_count, Projection) =<
           maps:get(node_budget, Projection),
    true = maps:get(source_event, Projection) =:= maps:get(event_id, Event),
    Result = #{schema => provisional_t3_consumer_result_v1,
               output_id => t3_variant_output,
               output =>
                   {bounded_response,
                    maps:get(selected_interpretation, Projection)},
               projection_id => maps:get(projection_id, Projection),
               source_graph_version => maps:get(graph_version, Projection),
               input_mode => bounded_runtime_projection},
    {reply, {ok, Result},
     State0#{outputs => maps:get(outputs, State0) + 1,
             projected_inputs => maps:get(projected_inputs, State0) + 1}};
handle_call(status, _From, State) ->
    {message_queue_len, Queue} = process_info(self(), message_queue_len),
    {memory, Memory} = process_info(self(), memory),
    {reply, State#{message_queue_len => Queue,
                   process_memory_bytes => Memory}, State}.

handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.
