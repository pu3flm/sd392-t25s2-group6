-module(ctx_runtime_tree_stage4_checkpoint).
-behaviour(gen_server).

-export([start_link/0, reset/0, commit/1, poison_attempt/1,
         semantic_state/0, operational_state/0, status/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(NAME, ctx_runtime_tree_stage4_checkpoint).

start_link() -> gen_server:start_link({local, ?NAME}, ?MODULE, [], []).
reset() -> gen_server:call(?NAME, reset).
commit(Event) -> gen_server:call(?NAME, {commit, Event}).
poison_attempt(Event) -> gen_server:call(?NAME, {poison_attempt, Event}).
semantic_state() -> gen_server:call(?NAME, semantic_state).
operational_state() -> gen_server:call(?NAME, operational_state).
status() -> gen_server:call(?NAME, status).

init([]) -> {ok, initial_state()}.

handle_call(reset, _From, _State) -> {reply, ok, initial_state()};
handle_call({commit, Event}, _From, State0) ->
    Id = maps:get(event_id, Event),
    Digest = event_digest(Event),
    Committed0 = maps:get(committed, State0),
    case maps:find(Id, Committed0) of
        error ->
            Prior = maps:get(graph_version, State0),
            Version = Prior + 1,
            Transition = #{kind => semantic_transition,
                           event_id => Id,
                           event_digest => Digest,
                           effect => maps:get(effect, Event),
                           causal_parent => maps:get(causal_parent, Event),
                           prior_version => Prior,
                           version => Version,
                           provenance => maps:get(provenance, Event)},
            State1 = State0#{graph_version => Version,
                             committed => Committed0#{Id =>
                                 #{digest => Digest,
                                   transition => Transition}},
                             transitions =>
                                 maps:get(transitions, State0) ++ [Transition],
                             commit_count => maps:get(commit_count, State0) + 1},
            {reply, {ok, receipt(Id, committed, Prior, Version, true)},
             State1};
        {ok, #{digest := Digest}} ->
            Version = maps:get(graph_version, State0),
            State1 = State0#{duplicate_count =>
                                 maps:get(duplicate_count, State0) + 1},
            {reply, {ok, receipt(Id, duplicate_suppressed,
                                Version, Version, false)}, State1};
        {ok, Existing} ->
            Version = maps:get(graph_version, State0),
            Collision = #{event_id => Id,
                          kind => idempotency_identity_collision,
                          existing_digest => maps:get(digest, Existing),
                          rejected_digest => Digest,
                          disposition => quarantined,
                          governing_effect => none},
            State1 = State0#{quarantine =>
                                 (maps:get(quarantine, State0))#{Id => Collision}},
            {reply, {quarantined,
                     receipt(Id, id_collision_quarantined,
                             Version, Version, false)}, State1}
    end;
handle_call({poison_attempt, Event}, _From, State0) ->
    Id = maps:get(event_id, Event),
    Attempts0 = maps:get(poison_attempts, State0),
    Attempt = maps:get(Id, Attempts0, 0) + 1,
    Attempts1 = Attempts0#{Id => Attempt},
    Version = maps:get(graph_version, State0),
    case Attempt < 3 of
        true ->
            Receipt = (receipt(Id, poison_retry_crash,
                               Version, Version, false))#{attempt => Attempt},
            {reply, {crash, Receipt},
             State0#{poison_attempts => Attempts1}};
        false ->
            Poison = #{event_id => Id,
                       event_digest => event_digest(Event),
                       kind => poison_event,
                       attempt_count => Attempt,
                       disposition => quarantined_after_bound,
                       governing_effect => none,
                       retained => true},
            Receipt = (receipt(Id, poison_quarantined,
                               Version, Version, false))#{attempt => Attempt},
            {reply, {quarantined, Receipt},
             State0#{poison_attempts => Attempts1,
                     quarantine =>
                         (maps:get(quarantine, State0))#{Id => Poison}}}
    end;
handle_call(semantic_state, _From, State) ->
    {reply, #{schema => provisional_stage4_semantic_state_v1,
              graph_version => maps:get(graph_version, State),
              transitions => maps:get(transitions, State),
              projection => [maps:get(effect, T) ||
                                T <- maps:get(transitions, State)]}, State};
handle_call(operational_state, _From, State) ->
    {reply, maps:with([commit_count, duplicate_count, poison_attempts,
                       quarantine], State), State};
handle_call(status, _From, State) ->
    {message_queue_len, Queue} = process_info(self(), message_queue_len),
    {memory, Memory} = process_info(self(), memory),
    {reply, #{graph_version => maps:get(graph_version, State),
              committed_count => map_size(maps:get(committed, State)),
              quarantine_count => map_size(maps:get(quarantine, State)),
              message_queue_len => Queue,
              process_memory_bytes => Memory}, State}.

handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.

initial_state() ->
    #{schema => provisional_stage4_checkpoint_state_v1,
      graph_version => 0,
      committed => #{},
      transitions => [],
      commit_count => 0,
      duplicate_count => 0,
      poison_attempts => #{},
      quarantine => #{}}.

event_digest(Event) -> crypto:hash(sha256, term_to_binary(Event)).

receipt(Id, Disposition, Prior, Version, Accepted) ->
    #{schema => provisional_stage4_receipt_v1,
      event_id => Id,
      disposition => Disposition,
      sent => true, delivered => true, interpreted => true,
      accepted => Accepted,
      committed => Disposition =:= committed,
      executed => false,
      prior_version => Prior,
      graph_version => Version}.
