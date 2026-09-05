-module(ctx_runtime_tree_stage3_planner).
-behaviour(gen_server).

-export([start_link/0, reset/0, begin_assignment/1,
         complete_assignment/2, status/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(NAME, ctx_runtime_tree_stage3_planner).

start_link() -> gen_server:start_link({local, ?NAME}, ?MODULE, [], []).
reset() -> gen_server:call(?NAME, reset).
begin_assignment(Assignment) ->
    gen_server:call(?NAME, {begin_assignment, Assignment}).
complete_assignment(AssignmentId, ArtifactSpec) ->
    gen_server:call(?NAME, {complete_assignment, AssignmentId, ArtifactSpec}).
status() -> gen_server:call(?NAME, status).

init([]) -> {ok, idle_state()}.

handle_call(reset, _From, _State) -> {reply, ok, idle_state()};
handle_call({begin_assignment, Assignment}, _From,
            #{running := none} = State) ->
    AssignmentId = maps:get(id, Assignment),
    Receipt = #{schema => provisional_stage3_receipt_v1,
                event_id => AssignmentId,
                disposition => planner_pending,
                sent => true, delivered => true, interpreted => true,
                accepted => true, committed => true, executed => false,
                source_graph_version => maps:get(source_graph_version,
                                                 Assignment)},
    {reply, {ok, Receipt}, State#{running => Assignment}};
handle_call({begin_assignment, _Assignment}, _From, State) ->
    {reply, {error, planner_busy}, State};
handle_call({complete_assignment, AssignmentId, ArtifactSpec}, _From,
            #{running := Assignment} = State)
  when Assignment =/= none ->
    AssignmentId = maps:get(id, Assignment),
    Artifact = ArtifactSpec#{id => maps:get(artifact_id, ArtifactSpec),
                             assignment_id => AssignmentId,
                             source_graph_version =>
                                 maps:get(source_graph_version, Assignment),
                             source_projection =>
                                 maps:get(source_projection, Assignment),
                             status => provisional,
                             canonical => false,
                             governing_effect => none,
                             provenance => #{source_space => background_branch,
                                             planner => ?NAME}},
    Receipt = #{schema => provisional_stage3_receipt_v1,
                event_id => AssignmentId,
                disposition => provisional_plan_returned,
                sent => true, delivered => true, interpreted => true,
                accepted => true, committed => true, executed => false,
                source_graph_version => maps:get(source_graph_version,
                                                 Assignment)},
    {reply, {ok, Artifact, Receipt}, State#{running => none}};
handle_call({complete_assignment, _AssignmentId, _ArtifactSpec}, _From, State) ->
    {reply, {error, no_running_assignment}, State};
handle_call(status, _From, State) ->
    {message_queue_len, Queue} = process_info(self(), message_queue_len),
    {memory, Memory} = process_info(self(), memory),
    {reply, #{running => maps:get(running, State),
              message_queue_len => Queue,
              process_memory_bytes => Memory}, State}.

handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.

idle_state() -> #{running => none}.
