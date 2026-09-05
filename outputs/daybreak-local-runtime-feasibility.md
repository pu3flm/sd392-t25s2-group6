---
status: independent feasibility appraisal
method: static/read-only
implementation_changes: none
service_operation: none
---

# Independent feasibility appraisal

**[FACT | High]** This appraisal used the expanded specification and current Erlang sources statically. No compilation, execution, live-service calls, tests, or state changes occurred.

## Bottom line

**[JUDGMENT | High]** The proposal is technically feasible as a user-owned, provider-neutral local system. Erlang/OTP is a strong fit for its control plane: causal event handling, supervision, foreground/background isolation, typed coordination, branch ownership, and failure recovery.

**[JUDGMENT | High]** A real online POC is viable if a locally controlled adapter owns the turn sequence—capture event, update runtime, obtain projection, construct the model request, record the response, and return observations. The runtime need not depend on Codex or any one provider.

**[JUDGMENT | High]** The hard problem is not Erlang. It is producing useful symbolic interpretations and projections while proving causal participation, isolation, authority enforcement, and later behavioral change. Those are application and experimental-design problems.

**[JUDGMENT | High]** The current repository is a useful preliminary substrate, not the minimum viable implementation of the expanded proposal. Some OTP and persistence patterns can be reused, but its state model and APIs need substantial redesign.

## 1. What Erlang/OTP provides directly

| Capability | Appraisal |
|---|---|
| Supervised foreground, background, planner, adapter, and evidence processes | **[FACT | High]** OTP supervisors, links, monitors, and restart strategies directly support process failure isolation. |
| Serialized graph transitions | **[FACT | High]** A `gen_server` or partitioned set of state owners can provide explicit write ordering for a POC. |
| Foreground/background concurrency | **[FACT | High]** Lightweight processes allow interlocution to continue while bounded workers wait on model, tool, or storage operations. |
| Typed internal protocols | **[FACT | High]** Pattern matching, records/maps, typespecs, and state machines can implement versioned message envelopes and transition rules. Runtime schema validation remains application work. |
| Timeouts, deadlines, cancellation, monitoring | **[FACT | High]** OTP supplies the primitives, but assignments and messages must carry their semantic deadline and cancellation state. |
| Immutable snapshots and branch overlays | **[FACT | High]** Immutable Erlang terms, persistent data structures, event logs, and separate processes make copy-on-write branch designs practical. |
| Local persistence | **[FACT | High]** DETS, `disk_log`, Mnesia, or external local databases can store event and graph state. None automatically supplies evidentiary integrity. |
| Provider adapters | **[FACT | High]** HTTP clients, ports, Unix sockets, and supervised adapter processes can connect local or remote model clients without making a provider the system of record. |
| Operational topology | **[FACT | High]** OTP can identify actors, supervisors, failures, queues, and receipts. This must remain distinct from the conceptual graph. |

**[JUDGMENT | High]** Erlang is particularly suitable for orchestration and fault containment. It is less suitable by itself for large vector indexes, dense numerical inference, or sophisticated graph analytics; those functions can remain locally controlled behind databases, ports, or services.

**[FACT | High]** OTP does not automatically provide exactly-once external effects, bounded mailboxes, cross-sender total ordering, poison-message quarantine, semantic truth, authorization, tamper-evident evidence, or independent verification.

## 2. Application mechanisms still required

| Proposed concept | Required mechanism |
|---|---|
| Experience base | **[JUDGMENT | High]** An append-only transition model linking prior version, event, alternatives, processing path, result, correction, consequence, and resulting version—not merely timestamped text. |
| Runtime tree | **[JUDGMENT | High]** A versioned graph with branch heads, explicit focal pointers, derivation links, and immutable historical versions. |
| Focal context | **[JUDGMENT | High]** A projection engine that emits a bounded, versioned artifact with purpose, rationale, omissions, provenance, and token/resource budget. |
| Typed messaging | **[JUDGMENT | High]** Validated envelopes containing message/schema version, sender, address/topic, correlation and causal parents, graph version, deadline, epistemic status, authority reference, idempotency key, and expected receipt. |
| Delivery semantics | **[JUDGMENT | High]** Separate durable states for emitted, delivered, interpreted, accepted, committed, and executed, including membership views for fan-out. |
| Background branches | **[JUDGMENT | High]** Branch-specific write ownership. Workers return provisional artifacts or deltas; only the governing writer can promote them after freshness and authority checks. |
| Planner non-displacement | **[JUDGMENT | High]** Priority queues or separate coordinators with reserved capacity for new user events; planners cannot hold the interlocution lock. |
| Isolated POC clones | **[JUDGMENT | High]** An immutable parent snapshot plus a separate overlay log and write capability. Clone output returns only as a reviewable delta. |
| Learning transitions | **[JUDGMENT | High]** Accepted graph/policy changes accompanied by evidence that a later pertinent projection, inference, compression, or eligibility decision changed. Storage alone is insufficient. |
| Authority | **[JUDGMENT | High]** A policy-enforcement component outside the discretionary model path, with authenticated principals and scoped, expiring, revocable grants. |
| External effects | **[JUDGMENT | High]** A separate executor using an outbox/effect ledger, idempotency, result reconciliation, and quarantine. |
| Evidence | **[JUDGMENT | High]** A protected append-only ledger containing code/config/spec identities, state and projection hashes, causal order, receipts, authority decisions, effects, integrity links, and declared omissions. |
| Client neutrality | **[JUDGMENT | High]** A canonical local event/projection protocol plus one adapter per supported model or interface. |

### Current implementation as a baseline

**[FACT | High]** The current application already demonstrates a single serialized manager, OTP supervision, worker restart structure, event journaling, snapshots, revision arrays, duplicate suppression, provisional interpretations, and hot/cold rehydration. `src/context_manager.erl`; `src/ctx_sup.erl`; `src/ctx_worker.erl`.

**[FACT | High]** `ingest_live/5` requires the caller to supply both the event and its interpretations. `projection/1` returns the event candidates with `selection => none`; there is no model-request or response transition. `src/context_manager.erl:21-26,311-379`.

**[FACT | High]** The implementation has no typed message envelope, membership view, delivery receipt, focal-version transition, planning assignment, background branch, clone, artifact-promotion transition, learning-transition evidence, or external authority gate.

**[FACT | High]** The only `live_vm` implementation artifact is a test module referring to absent `ctxv_store`, `ctxv_layer`, and `ctxv_sup` modules. It is design intent, not functioning code.

**[JUDGMENT | High]** Extending the existing manager without changing its data model would accumulate risk. Global IDs, mutable projection reads, journal-before-validation behavior, generic relations, and a monolithic state map conflict with the expanded requirements. Reusing selected persistence and supervision ideas in a new application namespace would be safer than treating existing state as the governing Experience Base.

## 3. Interfaces and online integration

### Provider-neutral local system

**[JUDGMENT | High]** The sound architecture places a local gateway in front of every governed client:

1. a local capture adapter receives text, audio, tool results, or system events;
2. it submits raw and derived evidence to the Erlang runtime;
3. the runtime commits a graph version and returns a focal projection;
4. the adapter constructs the model request containing that projection;
5. the model response is returned to the runtime before or while it is shown to the user;
6. later observation/correction becomes another immutable event.

**[FACT | High]** This can be implemented with Unix-domain sockets, loopback HTTP, local message buses, supervised ports, or a native Erlang client. The choice does not determine provider ownership.

**[JUDGMENT | High]** A Unix socket or authenticated loopback API is preferable for the first local POC. Exposing raw Erlang distribution gives node-level trust that is much broader than the proposed application authority model.

**[JUDGMENT | High]** Local voice capture can preserve audio hashes, timing, interruption markers, and transcription derivation when the local adapter controls the microphone or receives a suitably rich stream. A provider that exposes only completed text should be represented as a text-derived client with unavailable modalities, not as full raw voice capture.

### This current Codex client

**[FACT | High]** In this task interface, a model can invoke a local tool after receiving the user turn, and the tool result can influence its final response. That permits a limited tool-mediated adapter demonstration.

**[FACT | High]** No automatic pre-turn hook or raw audio/prosodic stream is exposed here to the local Erlang project.

**[JUDGMENT | High]** A local MCP/tool bridge plus an enforced calling convention could demonstrate projection use before the final answer, but it would not provide the strongest proof of pre-model capture, raw voice fidelity, or non-bypassable authority.

**[JUDGMENT | High]** Full causal control for this client would require a supported app-level hook or a separate local bridge/client that owns request construction. This is an adapter-specific limitation, not an architectural or viability limit on the local runtime.

**[FACT | High]** The current agent environment also has broader shell/tool authority than the proposed gate. Therefore it cannot prove a non-bypassable action boundary unless the surrounding host permissions are restricted so the client can reach consequential operations only through the gate.

## 4. Minimum live-PoC architecture and proof criterion

### Minimum architecture

**[JUDGMENT | High]** A credible first implementation needs these bounded components:

- `ingress_gateway`: authenticated local event intake and modality/derivation recording;
- `experience_store`: append-only transition and evidence log;
- `graph_store`: immutable graph versions and branch heads;
- `focus_coordinator`: owns each governed turn and focal transition;
- `projection_service`: bounded selection, rationale, omissions, and serialization;
- `adapter_sup`: one supervised adapter per model client;
- `branch_sup`: temporary background/planning workers using branch overlays;
- `clone_manager`: immutable snapshot ancestry and isolated overlays;
- `authority_gate`: deny-by-default policy evaluation;
- `action_executor`: optional, narrowly whitelisted and idempotent;
- `evidence_view`: observationally read-only export from protected evidence.

**[JUDGMENT | High]** One graph writer and one user are acceptable for the first POC. Distributed consensus, one process per conceptual node, autonomous tooling, and large-scale graph infrastructure are unnecessary.

### Passing proof

**[JUDGMENT | High]** The POC should pass only if protected evidence establishes all of the following:

1. A new locally captured user event `E1` exists before any governed model request, with modality and known losses.
2. At least two provisional interpretations are retained.
3. Processing creates immutable graph version `G1`.
4. Focal projection `P1` identifies `G1`, its selection rationale, omissions, and budget.
5. A locally controlled adapter proves that the actual model request contained `P1` before response `R1`.
6. `R1` and the user’s later acceptance, correction, or rejection are recorded.
7. The observation produces `G2` without rewriting `G1`.
8. A later session or different adapter obtains a projection influenced by the corrected trajectory.
9. A background assignment created from `G1` does not delay a new user event; its result remains provisional and is marked stale if the graph advances.
10. A clone derived from `G2` accepts divergent mutations while the governing source head and protected hashes remain unchanged; return requires a reviewed delta.
11. An ungranted external operation is denied by the gate with no side effect.
12. Every stage has distinct receipts; emission is not reported as commitment or execution.

**[JUDGMENT | High]** The strongest learning proof is an A/B replay against the same pertinent later event: one branch without the accepted learning transition and one with it. The latter must show an explainable changed selection or inference while preserving the original error and correction. Stochastic model-output improvement alone is not sufficient.

## 5. Main risks

### Technical

- **[INFERENCE | High]** A single global manager will eventually become a latency and failure bottleneck. A single writer per user/session or partition is still viable for the POC.
- **[INFERENCE | High]** Large Erlang terms and projections can cause copying, garbage-collection pauses, and mailbox growth.
- **[INFERENCE | High]** External model latency can make planner and interpretation results stale before they return.
- **[INFERENCE | High]** Cross-sender arrival order can be mistaken for causal or semantic order unless causal parents and conflict rules are explicit.
- **[INFERENCE | High]** DETS and ad hoc snapshots are adequate for disposable experiments but weak foundations for schema migration, protected evidence, concurrent access, and corruption recovery.
- **[INFERENCE | High]** Blocking NIFs or uncontrolled external tools can compromise scheduler responsiveness; CPU-heavy or unsafe work should use bounded ports/services.

### Semantic

- **[JUDGMENT | High]** Relevance and identity resolution are the largest functional risks. A technically correct runtime can project the wrong branch, overgeneralize a correction, or compress away a decisive counterexample.
- **[INFERENCE | High]** Candidate interpretations and branches can grow combinatorially without promotion, dormancy, and pruning policies that preserve derivation.
- **[INFERENCE | High]** Background models can contaminate the Experience Base with fluent but unsupported relations unless their output remains provisional.
- **[UNKNOWN | High]** It is not yet demonstrated that experience-trajectory retrieval materially outperforms a simpler versioned memory or retrieval baseline for the intended conversations.
- **[FACT | High]** The runtime can control supplied context and tool access; it cannot inspect, reproduce, or erase a provider model’s hidden activations.

### Security and authority

- **[INFERENCE | High]** Prompt injection can become graph or action injection if textual statements are not kept distinct from instructions and grants.
- **[INFERENCE | High]** Giving a model direct shell, credential, database, or service access bypasses an application-only gate.
- **[INFERENCE | High]** Raw Erlang distribution, shared cookies, broadly writable state, and unvalidated atoms/terms create unnecessary privilege and denial-of-service exposure.
- **[INFERENCE | High]** Clone isolation implemented only as a logical flag is vulnerable to programming errors; stronger capability or process/storage separation is preferable.
- **[INFERENCE | High]** Cross-provider adapters can unintentionally disclose private Experience Base material unless projection policy is principal- and purpose-aware.

### Evidence

- **[JUDGMENT | High]** Self-produced traces can demonstrate internal consistency but not semantic truth or independent assurance.
- **[INFERENCE | High]** Missing capture events, clock disagreement, stale code, mutable inspection, and version mismatch can invalidate causal claims.
- **[FACT | High]** Hash chains can reveal some modification or reordering; they cannot prove that omitted events never occurred or that recorded interpretations were correct.
- **[JUDGMENT | High]** The user’s acceptance oracle must remain external to automatic model evaluation.

### Resources

- **[INFERENCE | High]** Unbounded event history, alternative interpretations, fan-out, planners, and model calls can exhaust disk, memory, tokens, or attention.
- **[JUDGMENT | High]** The foreground path needs reserved capacity, strict deadlines, bounded queues, and degradation rules that prefer a smaller explicit projection over blocking the interaction.
- **[JUDGMENT | High]** Learning and compression should be scheduled as bounded proposals, not continuous ungoverned optimization.

## 6. Feasibility verdicts

| Scope | Verdict |
|---|---|
| Local text-first live POC | **GO — [JUDGMENT | High confidence]** A locally controlled adapter, single graph writer, event-sourced transitions, focal projection, one background branch, and deny-by-default authority are achievable. |
| Local voice POC with timing/prosody | **CONDITIONAL GO — [JUDGMENT | Medium-High confidence]** Feasible when the local capture adapter has audio/timing access; otherwise missing modalities must be explicit. |
| Runtime tree/context virtualization | **GO — [JUDGMENT | High confidence]** Feasible as externalized, focus-navigated symbolic context. It cannot virtualize hidden neural state, which the specification correctly excludes. |
| Experience Base | **GO AS AN OPERATIONAL MODEL — [JUDGMENT | High confidence]** Event-sourced transformations and later use are implementable. Semantic usefulness remains experimental. |
| Supervised off-focus analysis | **GO — [JUDGMENT | High confidence]** This aligns strongly with OTP, provided branch writes and foreground capacity are isolated. |
| Isolated POC clones | **GO — [JUDGMENT | High confidence]** Immutable parent versions plus overlays and explicit deltas are conventional and testable. |
| Durable learning transitions | **CONDITIONAL GO — [JUDGMENT | Medium-High confidence]** Recording and testing changed selection/inference is feasible; reliably learning the right abstraction is the research risk. |
| Single-user local production service | **FEASIBLE BUT SUBSTANTIAL — [JUDGMENT | Medium confidence]** Requires stronger storage, migration, security, privacy, evidence, action control, and operational tooling. |
| Multi-user or distributed production | **TECHNICALLY FEASIBLE, PREMATURE — [JUDGMENT | Medium confidence]** Identity, isolation, consensus, replication, conflict resolution, and assurance greatly increase complexity. |
| Provider-neutral data/control portability | **GO — [JUDGMENT | High confidence]** Canonical local schemas and adapters can keep ownership outside providers. |
| Identical behavior across providers | **NOT GUARANTEED — [JUDGMENT | High confidence]** Tokenization, system prompts, tool protocols, context limits, and model behavior differ; portable context is achievable, behavioral equivalence is not. |
| Current repository as the completed POC | **NO-GO — [JUDGMENT | High confidence]** It lacks the causal client loop and nearly all expanded coordination, focus, clone, learning, authority, and evidence mechanisms. |
| Current repository as disposable groundwork | **GO — [JUDGMENT | High confidence]** Its supervision, serialization, persistence, and revision experiments provide useful implementation lessons. |

## 7. Unknowns preventing stronger claims

- **[UNKNOWN | High]** Which local capture interfaces will supply raw audio, timing, interruptions, and derivation metadata.
- **[UNKNOWN | High]** Which model clients/providers must be supported first and what request-construction hooks each exposes.
- **[UNKNOWN | High]** Required foreground latency, projection token budget, event rate, retention period, and maximum branch count.
- **[UNKNOWN | High]** The interpretation and relevance algorithms, including whether they use local models, remote models, rules, embeddings, or human appraisal.
- **[UNKNOWN | High]** The acceptable rates and consequences of missed context, wrong identity resolution, false relation promotion, and unnecessary clarification.
- **[UNKNOWN | High]** Which actions, if any, the first POC may execute and which principal owns the gate and credentials.
- **[UNKNOWN | High]** Host threat model, multi-user requirements, encryption needs, backup targets, and privacy rules for raw audio and historical corrections.
- **[UNKNOWN | High]** Required level of evidentiary and reviewer independence.
- **[UNKNOWN | High]** Whether learning success is judged by projection differences, user acceptance, task outcomes, controlled comparisons, or a combination.
- **[UNKNOWN | High]** Whether a local embedded store is sufficient or graph size/query needs require a specialized index.
- **[UNKNOWN | High]** How user-requested deletion should coexist with historical derivation and protected evidence.
- **[UNKNOWN | High]** The actual semantic benefit over simpler baselines; this requires the live POC and comparative trials.

**[JUDGMENT | High]** Candidly, the architecture is ambitious but coherent. Keeping the runtime local and treating every model as a replaceable client is the strongest part of the proposal. Erlang/OTP can make the concurrency, supervision, branch isolation, and causal coordination tractable. Success will depend on disciplined adapters and evidence—not on adding more processes or a more elaborate graph before the first genuinely governed turn is proven.
