-module(ctx_live_poc_t3_branch).
-behaviour(gen_server).

-export([start_link/2, reset/1, record_output_before_ingest/2,
         ingest_posthoc/2, ingest_live/2, record_live_consumer/2,
         observe_live/2, state/1, status/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

start_link(Name, Mode) ->
    gen_server:start_link({local, Name}, ?MODULE, [Name, Mode], []).
reset(Name) -> gen_server:call(Name, reset).
record_output_before_ingest(Name, Output) ->
    gen_server:call(Name, {record_output_before_ingest, Output}).
ingest_posthoc(Name, Event) -> gen_server:call(Name, {ingest_posthoc, Event}).
ingest_live(Name, Event) -> gen_server:call(Name, {ingest_live, Event}).
record_live_consumer(Name, ConsumerResult) ->
    gen_server:call(Name, {record_live_consumer, ConsumerResult}).
observe_live(Name, Observation) ->
    gen_server:call(Name, {observe_live, Observation}).
state(Name) -> gen_server:call(Name, state).
status(Name) -> gen_server:call(Name, status).

init([Name, Mode]) -> {ok, initial_state(Name, Mode)}.

handle_call(reset, _From, State) ->
    {reply, ok, initial_state(maps:get(name, State), maps:get(mode, State))};
handle_call({record_output_before_ingest, Output}, _From,
            #{mode := offline_baseline} = State0) ->
    {OutputEvent, State1} =
        append_event(consumer_output, maps:get(output_id, Output), none,
                     #{output => Output, projection_supplied => false}, State0),
    {reply, {ok, OutputEvent}, State1};
handle_call({ingest_posthoc, Event}, _From,
            #{mode := offline_baseline} = State0) ->
    OutputEvent = first_event(consumer_output, State0),
    {Raw, State1} =
        append_event(raw_event, maps:get(event_id, Event), none,
                     #{event => Event, ingestion => post_output}, State0),
    {Interpretation, State2} =
        append_event(interpretations_created,
                     t3_baseline_interpretations, maps:get(id, Raw),
                     #{alternatives =>
                           [runtime_tree_request, artifact_only_reading],
                       status => provisional}, State1),
    {Graph, State3} =
        append_graph_commit(t3_baseline_graph_v1,
                            maps:get(id, Interpretation), State2),
    {Offline, State4} =
        append_relation(offline_replay_of, t3_baseline_offline_relation,
                        maps:get(id, Graph),
                        #{output_id => maps:get(id, OutputEvent),
                          event_id => maps:get(event_id, Event)}, State3),
    {Observation, State5} =
        append_event(user_observation, t3_baseline_observation,
                     maps:get(id, Offline),
                     #{observed => output_preceded_runtime_ingestion}, State4),
    State6 = State5#{classification =>
                         #{kind => offline_posthoc_substitute,
                           eligible_live_claim => false,
                           canonical => false}},
    {reply, {ok, [Raw, Interpretation, Graph, Offline, Observation]}, State6};
handle_call({ingest_live, Event}, _From,
            #{mode := live_variant} = State0) ->
    {Raw, State1} =
        append_event(raw_event, maps:get(event_id, Event), none,
                     #{event => Event, ingestion => pre_output}, State0),
    {Interpretation, State2} =
        append_event(interpretations_created,
                     t3_variant_interpretations, maps:get(id, Raw),
                     #{alternatives =>
                           [runtime_tree_request, artifact_only_reading],
                       status => provisional}, State1),
    {Graph, State3} =
        append_graph_commit(t3_variant_graph_v1,
                            maps:get(id, Interpretation), State2),
    ProjectionId = t3_variant_projection_v1,
    ProjectionPayload =
        #{schema => provisional_t3_projection_v1,
          projection_id => ProjectionId,
          graph_version => maps:get(graph_version, State3),
          causal_parent => maps:get(id, Graph),
          selected_interpretation => runtime_tree_request,
          alternatives_retained => [artifact_only_reading],
          node_budget => 2,
          projected_node_count => 2,
          source_event => maps:get(event_id, Event)},
    {ProjectionEvent, State4} =
        append_event(projection_emitted, ProjectionId, maps:get(id, Graph),
                     #{projection => ProjectionPayload}, State3),
    Projection = ProjectionPayload#{sequence => maps:get(sequence,
                                                          ProjectionEvent)},
    {reply, {ok, Projection, [Raw, Interpretation, Graph, ProjectionEvent]},
     State4};
handle_call({record_live_consumer, ConsumerResult}, _From,
            #{mode := live_variant} = State0) ->
    Projection = first_event(projection_emitted, State0),
    {InputEvent, State1} =
        append_event(consumer_input, t3_variant_consumer_input,
                     maps:get(id, Projection),
                     #{projection_id => maps:get(projection_id,
                                                   ConsumerResult),
                       accepted => true}, State0),
    {OutputEvent, State2} =
        append_event(consumer_output, maps:get(output_id, ConsumerResult),
                     maps:get(id, InputEvent),
                     #{output => maps:get(output, ConsumerResult),
                       projection_supplied => true}, State1),
    {reply, {ok, [InputEvent, OutputEvent]}, State2};
handle_call({observe_live, Observation0}, _From,
            #{mode := live_variant} = State0) ->
    Output = first_event(consumer_output, State0),
    {Observation, State1} =
        append_event(user_observation, t3_variant_observation,
                     maps:get(id, Output), Observation0, State0),
    {Relation, State2} =
        append_relation(participated_in_live_loop,
                        t3_variant_live_relation,
                        maps:get(id, Observation),
                        #{scope => bounded_local_erlang_consumer,
                          output_id => maps:get(id, Output)}, State1),
    State3 = State2#{classification =>
                         #{kind => bounded_live_local_path,
                           eligible_live_claim => true,
                           canonical => false}},
    {reply, {ok, [Observation, Relation]}, State3};
handle_call(state, _From, State) -> {reply, State, State};
handle_call(status, _From, State) ->
    {message_queue_len, Queue} = process_info(self(), message_queue_len),
    {memory, Memory} = process_info(self(), memory),
    {reply, #{name => maps:get(name, State),
              mode => maps:get(mode, State),
              sequence => maps:get(sequence, State),
              graph_version => maps:get(graph_version, State),
              event_count => length(maps:get(events, State)),
              message_queue_len => Queue,
              process_memory_bytes => Memory}, State}.

handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.

initial_state(Name, Mode) ->
    #{schema => provisional_normative_t3_branch_state_v1,
      name => Name,
      mode => Mode,
      sequence => 0,
      graph_version => 0,
      events => [],
      relations => [],
      classification => unresolved}.

append_graph_commit(Id, Parent, State0) ->
    Version = maps:get(graph_version, State0) + 1,
    {Event, State1} =
        append_event(graph_version_committed, Id, Parent,
                     #{graph_version => Version}, State0),
    {Event, State1#{graph_version => Version}}.

append_relation(Kind, Id, Parent, Payload, State0) ->
    {Event, State1} = append_event(Kind, Id, Parent,
                                   Payload#{canonical => false}, State0),
    {Event, State1#{relations => maps:get(relations, State1) ++ [Event]}}.

append_event(Kind, Id, Parent, Payload, State0) ->
    Sequence = maps:get(sequence, State0) + 1,
    Event = #{schema => provisional_normative_t3_receipt_v1,
              id => Id,
              kind => Kind,
              sequence => Sequence,
              causal_parent => Parent,
              sent => true, delivered => true, interpreted => true,
              accepted => true,
              committed => Kind =:= graph_version_committed orelse
                           Kind =:= participated_in_live_loop orelse
                           Kind =:= offline_replay_of,
              executed => false,
              payload => Payload},
    {Event, State0#{sequence => Sequence,
                    events => maps:get(events, State0) ++ [Event]}}.

first_event(Kind, State) ->
    hd([E || E <- maps:get(events, State), maps:get(kind, E) =:= Kind]).
