---
status: frozen
assessment_cutoff: 2026-09-04T16:47:38-03:00
method: static/read-only artifact and ordinary process/socket metadata inspection
blind_report_read: false
---

# FROZEN — specification-guided Erlang appraisal

Assessment cut-off: 2026-09-04 16:47:38 −03:00.

**[FACT | High]** This appraisal used only static files and ordinary filesystem/process/socket metadata. No tests, compilation, project scripts, Erlang application calls, DETS opens, RPC, or live-node interaction occurred. State-artifact hashes and mtimes were unchanged before and after inspection.

**[FACT | High]** Neither `outputs/daybreak-blind-erlang-report.md` nor `work/audit-freeze.md` was read.

**[UNKNOWN | High]** The exact code executing in the live VM cannot be established non-mutatively. The observed VM began at 15:26:47, while the current `context_manager.beam` was written at 15:38:37. Explicit hot loading is possible but unevidenced.

**[CRITERION-RELATIVE JUDGMENT | High]** Overall, this is a useful Erlang/OTP persistence, supervision, revision-history, and hot/cold-storage substrate prototype. It is not yet a conforming implementation of the supplied Context Runtime because the mandatory model-turn loop, external authority boundary, acceptance-grade evidence, and client integration are absent.

## 1. Intended system

**[FACT | High]** The specification defines a user-owned, provider- and session-neutral service whose system of record is outside any model client. It must preserve raw events, concurrent interpretations, evolving symbolic relations, corrections, rejected branches, intentional structure, provenance, authority, and history.

**[FACT | High]** Its defining behavior is the causally evidenced loop:

`raw event → interpretations → graph version → bounded projection → model input → response/action → user observation → graph revision`

Persistence or post-hoc replay alone does not satisfy this requirement.

**[FACT | High]** Consequential action requires an external, user-owned permission gate, while observability must be claim-relative, non-mutating, provenance-aware, and distinguishable from self-reporting or same-authority review.

## 2. Requirement-by-requirement conformance

| Requirement | Finding | Evidence |
|---|---|---|
| User ownership and provider/session neutrality | **PARTIAL — [JUDGMENT | High]** | **[FACT | High]** A user service and user-owned files exist, but no supported model-client adapters, portability/export contract, tenant identity, or client-neutral protocol exist. The only operational inspection interface is Erlang distribution/RPC. `context-runtime.service:5-13`; `bin/context-runtime-inspect:23-39`. |
| Raw-event representation | **PARTIAL — [JUDGMENT | High]** | **[FACT | High]** A caller-supplied map is stored with event ID, sequence, and asserted provenance. Timing, modality, information loss, raw-audio/transcript derivation, and source authenticity are neither required nor validated. `src/context_manager.erl:21-23,311-317`. |
| Required entity ontology | **PARTIAL — [JUDGMENT | High]** | **[FACT | High]** The state distinguishes symbols, interpretations, live-event maps, generic edges, workers, bridges, recurrence, and policies. Typed branches, actors, intentions, instructions, grants, actions, projections, and protected evidence are absent. `src/context_manager.erl:99-112,159-187,311-355`. |
| Required relation families | **PARTIAL — [JUDGMENT | High]** | **[FACT | High]** Arbitrary relation terms can be stored and revised, but endpoint type, relation semantics, authority meaning, provenance constraints, and the normative distinctions are unenforced. `src/context_manager.erl:177-203`. |
| Version/status/history semantics | **PARTIAL — [JUDGMENT | High]** | **[FACT | High]** Nodes and edges have versions and revision arrays; invalidation/reactivation retains node history. Only `active`, `provisional`, and `invalid` are substantively implemented. `src/context_manager.erl:165-170,188-231`. |
| History preservation under identity reuse | **CONTRADICTED — [JUDGMENT | High]** | **[FACT | High]** A live interpretation ID overwrites an existing node without collision checks; a repeated edge ID passed to `relate` replaces its prior edge with version 1. Both paths can erase lineage. `src/context_manager.erl:177-187,318-347,391-400`. |
| Non-monotonic consolidation | **PARTIAL — [JUDGMENT | High]** | **[FACT | High]** Review, invalidation, reactivation, and latent recurrence exist. Explicit rejection does not produce a typed negative boundary, and invalidating an interpretation does not revise its still-provisional `interpretation_of` edge. `src/context_manager.erl:204-230,251-289,334-345`. |
| Proximity and focus | **PARTIAL — [JUDGMENT | Medium-High]** | **[FACT | High]** Projection is local to one event’s candidate IDs, but there is no active-branch model, relevance process, risk-sensitive omission logic, or selection explanation. `src/context_manager.erl:357-379`. |
| Parallel interpretation and clarification | **PARTIAL — [JUDGMENT | High]** | **[FACT | High]** Multiple caller-generated candidates remain provisional and `selection` is `none`. The runtime itself neither generates interpretations nor asks clarifying questions; ID collisions can collapse alternatives. `src/context_manager.erl:311-355,357-379`. |
| Multimodal and temporal fidelity | **PARTIAL — [JUDGMENT | High]** | **[FACT | High]** Logical sequence and arbitrary supplied signal fields are retained. No missing-modality declaration, observed-versus-simulated distinction, capture timestamp, clock provenance, or anti-fabrication validation exists. `src/context_manager.erl:308-331,542-545`. |
| Learning as relational reconfiguration | **PARTIAL — [JUDGMENT | Medium-High]** | **[FACT | High]** Manual relations, bridges, revision, and recurrence alter stored geometry. Clustering, higher-order symbol formation, demand-driven tool creation, and learning appraisal are absent. `src/context_manager.erl:177-289`. |
| Mandatory live model loop | **ABSENT — [JUDGMENT | High]** | **[FACT | High]** The implementation stores a caller-packaged event plus interpretations and returns a projection. It has no graph-version artifact, model-input injection, response/action record, observation record, or causal turn handshake. Projection explicitly selects nothing. `src/context_manager.erl:21-26,311-379`. |
| Active/warm/cold context | **PARTIAL — [JUDGMENT | High]** | **[FACT | High]** Hot and cold residency plus token-triggered rehydration exist. There is no warm tier, dormant branch state, contextual retrieval, bounded projection, high-risk omission report, or guaranteed budget compliance. `src/context_manager.erl:232-250,391-506`. |
| Persistent service and recovery | **PARTIAL — [JUDGMENT | High]** | **[FACT | High]** DETS journaling, snapshots, replay, an enabled user service, and restart policies exist. Machine-reboot guarantees, schema migration, release identity, backup policy, and demonstrated cross-client continuity do not. `src/context_manager.erl:37-50,114-151,508-531`; `context-runtime.service:5-13`. |
| Conceptual/process topology distinction | **IMPLEMENTED — [JUDGMENT | High]** | **[FACT | High]** The semantic graph is manager-owned data rather than one process per symbol, and the distinction is explicit. `README.md:23-29`; `src/ctx_sup.erl:9-27`. |
| Worker failure isolation/regeneration | **PARTIAL — [JUDGMENT | High]** | **[FACT | High]** Three permanent workers use `one_for_one`; restarted workers reload manager-held state. No poison-event quarantine, work lease, external-effect reconciliation, or exactly-once action protocol exists. `src/ctx_sup.erl:9-27`; `src/ctx_worker.erl:18-33`. |
| Duplicate suppression | **PARTIAL — [JUDGMENT | High]** | **[FACT | High]** Global event-ID deduplication exists. IDs are not namespaced by user/client/session, and a conflicting payload with the same ID is silently treated as the old event rather than reported as a collision. `src/context_manager.erl:57-76`. |
| Active tool/script operation | **ABSENT — [JUDGMENT | High]** | **[FACT | High]** Workers only forward semantic events and expose test/status/crash calls. There is no bounded action executor or result capture. `src/ctx_worker.erl:11-33`. |
| Resource proportionality | **PARTIAL — [JUDGMENT | High]** | **[FACT | High]** Hot symbols have a configurable target budget, but protected/retained groups may exceed it. Journals, dedupe maps, catalogs, live events, projections, labels, mailboxes, and restart loops are otherwise unbounded. `src/context_manager.erl:435-476`; `README.md:71-78`. |
| Capability versus permission | **CONTRADICTED — [JUDGMENT | High]** | **[FACT | High]** The seed states that signals are not authority, but callers self-assert worker/scope and any caller can submit `promote_policy`, making a policy `executable => true`. No authorization is consulted. `src/context_manager.erl:9-13,18-23,269-289,308-309`. |
| External authority gate | **ABSENT — [JUDGMENT | High]** | **[FACT | High]** There are no principals, grants, targets, constraints, expiry, revocation, denial records, or external policy-enforcement point. |
| Delegation/accountability | **ABSENT — [JUDGMENT | High]** | **[FACT | High]** Worker names and scopes are labels, not authenticated identities; no grant/delegator/effect chain exists. |
| Claim-relative observability | **PARTIAL — [JUDGMENT | High]** | **[FACT | High]** Status, local sequence, revision provenance, and a short observations list exist. Claims, observers, intervals, coverage, missing events, code/spec versions, freshness, integrity, and probe budgets are absent. `src/context_manager.erl:533-557`. |
| Non-mutating inspection | **CONTRADICTED — [JUDGMENT | High]** | **[FACT | High]** `status/0` is state-preserving, but the official inspector invokes `projection/1`; projection can rehydrate cold nodes, increment access counts, alter residency, and evict other groups. `bin/context-runtime-inspect:23-34`; `src/context_manager.erl:83-85,357-379,406-433`. |
| Evidence provenance/integrity | **PARTIAL — [JUDGMENT | High]** | **[FACT | High]** Events carry logical sequence and asserted worker/scope provenance. No hash chain, signature, authorization link, timestamp, code/config digest, omission proof, replay proof, or separate evidence store exists. Observations are silently capped at 30. `src/context_manager.erl:65-75,308-309,533-535`. |
| Independent appraisal and acceptance oracle | **ABSENT — [JUDGMENT | High]** | **[FACT | High]** The application models neither independence dimensions nor a protected evidence handoff or stakeholder acceptance decision. |

## 3. Anti-specification violations and exposure paths

1. **Live-loop substitution exposure.** **[JUDGMENT | High]** The project is titled a “Context runtime POC” and calls ingestion/projection a “live path,” but implements only a storage/retrieval segment. Treating its synthetic demo or APIs as the specified live POC would violate anti-specification item 6. `README.md:1-4,15-21`; `src/ctx_demo.erl:4-80`.

2. **History erasure.** **[FACT | High]** Reusing an interpretation ID or edge ID can overwrite the previous object and lineage. This directly exposes anti-specification item 5. `src/context_manager.erl:177-187,318-347`.

3. **Rejected content remains structurally live.** **[FACT | High]** Invalidation changes the node status, but projection still returns that node and its provisional relation. No negative boundary or projection gate prevents a client from using it. `src/context_manager.erl:214-230,334-379`.

4. **Inspection can alter later behavior.** **[FACT | High]** The supplied inspection client uses an API that may change cache residency, access counts, and eviction decisions, contradicting anti-specification item 11.

5. **Capability/permission collapse.** **[FACT | High]** Direct callers choose their claimed worker and scope; promotion requires only a syntactically explicit event, not an authorized grant. Erlang distribution further provides node-level RPC capability outside application policy. This exposes anti-specification item 12.

6. **Manual classification displaced upstream.** **[JUDGMENT | Medium-High]** The caller must supply IDs, labels, signals, groups, protection flags, relation types, and bridge tokens. There is no conversational interpretation layer, so the organizational burden is shifted to a client or user-facing integrator, exposing anti-specification item 3.

7. **Self-labeling as evidence.** **[FACT | High]** The application writes observation category `implemented` merely when the manager starts, a live-turn package is stored, a bridge activates, or eviction occurs. The demo prints `IMPLEMENTED` based on its own synthetic calls. These labels are not claim-relative assurance. `src/context_manager.erl:49-50,248-249,354-355,503-506`; `src/ctx_demo.erl:10-12,48-53`.

8. **Planned tests can be mistaken for capability.** **[FACT | High]** `live_vm/src/ctxv_tests.erl` describes ten desirable tests, including read-only projection and response round-trip, but the referenced `ctxv_store`, `ctxv_layer`, and `ctxv_sup` modules are absent; the file is outside the Makefile and application. It is test intent, not implementation.

9. **Stale compiled validation surface.** **[FACT | High]** Current source lists six tests, including `live_transfer_test`, while the compiled `ctx_tests.beam` atom table contains the other five test functions and not `live_transfer_test`. Existing BEAMs therefore cannot evidence execution of that source test.

10. **Global identity collisions.** **[FACT | High]** Event IDs and live-event keys are global rather than client/session-namespaced. Two clients using the same ordinary turn ID can cause the second event to be suppressed as a duplicate. `src/context_manager.erl:57-76,346-347`.

11. **Unbounded growth/restart exposure.** **[INFERENCE | High]** Malformed but journaled events can repeatedly crash replay because validation occurs after durable insertion and there is no poison quarantine. Coupled with OTP and systemd restart policies, this can produce restart loops, exposing anti-specification item 13. `src/context_manager.erl:57-75,125-151,311-331`; `context-runtime.service:9-10`.

12. **Presence mistaken for health exposure.** **[FACT | High]** A live VM process, PID, DETS files, snapshot, and listener existed. **[JUDGMENT | High]** None establishes the required application-level causal loop; using them alone would violate anti-specification item 8.

13. **Evidence contamination path.** **[FACT | High]** The service and transient Erlang commands share the project working directory and no unique protected crash-dump destination is configured. The current `erl_crash.dump` records a separate VM boot failure in `binary_to_term`, not proof of service-loop behavior. A later VM failure can replace the same filename. `context-runtime.service:7-8`; `erl_crash.dump:1-4`.

## 4. Acceptance scenarios under existing non-mutating evidence

| Scenario | Establishable result |
|---|---|
| A1 — live causal participation | **NOT ESTABLISHED — [JUDGMENT | High]** Static code lacks model-input injection, response/observation capture, graph-version handoff, and causal correlation. The DETS strings show a packaged `live_turn` and three interpretation nodes, but no pre-response model use. |
| A2 — hidden stakeholder oracle | **NOT ESTABLISHED — [JUDGMENT | High]** The live snapshot contains a symbol asserting that an external observer owns the hidden criterion; a stored assertion is not a frozen response/observation/revision trajectory. |
| A3 — irony and missing modality | **NOT ESTABLISHED — [JUDGMENT | High]** Source tests supply an `irony` signal synthetically. Missing modalities and observed-versus-simulated provenance are not modeled. |
| A4 — correction and anti-specification | **PARTIALLY ESTABLISHED — [JUDGMENT | High]** Code and the demo snapshot preserve created/invalidated/reactivated node revisions. No negative-boundary object exists, the relation is not revised, and projection does not enforce non-governance. |
| A5 — dormant branch reactivation | **PARTIALLY ESTABLISHED — [JUDGMENT | Medium-High]** The demo snapshot statically shows cold residency, bridge rehydration, and retained revisions. Client closure/restart plus pertinent contextual reactivation is not jointly evidenced. |
| A6 — cross-client continuity | **NOT ESTABLISHED — [JUDGMENT | High]** No two-client trace, stable client contract, client identity, or provider adapter exists. |
| A7 — failure and regeneration | **PARTIALLY ESTABLISHED — [JUDGMENT | High]** Supervisor structure and source tests support local worker regeneration and event dedupe. Poison quarantine and non-idempotent effect protection are absent. |
| A8 — authority denial | **NOT ESTABLISHED / CAPABILITY ABSENT — [JUDGMENT | High]** No external gate or denial record exists. |
| A9 — authorized active operation | **NOT ESTABLISHED / CAPABILITY ABSENT — [JUDGMENT | High]** No grant model, action executor, expiry, revocation, or effect record exists. |
| A10 — non-mutating inspection | **CONTRADICTED BY DESIGN — [JUDGMENT | High]** The official inspection path may mutate cache/access/eviction state. **[FACT | High]** This appraisal’s own static file hashes remained equal, but that does not validate the application API. |
| A11 — independent review | **NOT ESTABLISHED — [JUDGMENT | High]** The code has no independence record or protected evidence path. This report’s fact/judgment separation is appraisal method, not an application capability. |
| A12 — resource containment | **PARTIALLY ESTABLISHED — [JUDGMENT | High]** Hot-residency eviction exists, but the declared limit can be exceeded and all other principal growth/restart dimensions are unbounded. |

## 5. What Erlang/OTP can and cannot provide

**[FACT | High]** Erlang/OTP is technically well suited to:

- isolate ingestion, interpretation, projection, policy, evidence, and action components as supervised processes;
- serialize graph transitions through `gen_server` or partition them with explicit ownership;
- use links, monitors, supervision strategies, restart intensity, and application releases for fault containment;
- implement event-driven state machines, logical ordering, immutable Erlang terms, idempotency keys, and replay;
- support bounded mailboxes/process heaps when explicitly configured and monitored;
- expose ports or supervised external workers for bounded tool execution;
- provide telemetry hooks and local/distributed messaging.

**[FACT | High]** Erlang/OTP does not by itself provide:

- correct ontology, interpretation, irony detection, intentional meaning, or relevance;
- user ownership, provider-neutral client integration, or a model-input handshake;
- per-action authorization, independent acceptance, or evidentiary truth;
- exactly-once external effects merely through supervision;
- poison-event quarantine, immutable history, or read-only query semantics automatically;
- cryptographic integrity, trusted time, omission detection, privacy policy, or V&V independence;
- distributed consensus merely because Erlang distribution is used.

**[CRITERION-RELATIVE JUDGMENT | High]** Required application-level mechanisms include:

- immutable namespaced IDs and an explicit event/graph/status schema;
- capture adapters that distinguish raw modality, derivations, unavailable signals, and information loss;
- interpretation workers preserving alternatives and recording actor/model provenance;
- a versioned, bounded, read-only projection API with selection reasons and omitted-risk disclosure;
- a pre-response client handshake and correlated response/observation/correction protocol;
- an external policy decision/enforcement point with authenticated principals and scoped, expiring, revocable grants;
- a supervised action executor using idempotency, an outbox/effect ledger, reconciliation, and poison quarantine;
- protected evidence with code/config/spec digests, ordering, integrity, retention, and external export;
- stable authenticated IPC/HTTP or equivalent client gateways rather than unrestricted distribution RPC.

## 6. Observability, V&V, authority, security, recovery, and evidence integrity

### Observability

**[FACT | High]** `status/0` exposes useful internal structure: sequence, workers, hot/cold IDs, catalog, edges, bridges, recurrence, policies, and recent observations. `src/context_manager.erl:537-557`.

**[CRITERION-RELATIVE JUDGMENT | High]** This is introspection, not specification-grade observability. There is no named-claim registry, model-turn correlation, event-loss accounting, sampling policy, observer identity, time interval, probe budget, freshness, or unknown-field declaration.

**[FACT | High]** Observations share mutable operational state and are silently truncated to 30 entries. `src/context_manager.erl:533-535`.

### V&V

**[FACT | High]** The main source suite covers internal seed/scope divergence, worker restart/dedup, cold rehydration/history, recurrence policy, packaged live transfer, and snapshot/journal replay. `src/ctx_tests.erl:11-20,30-163`.

**[FACT | High]** The packaged-live test checks two provisional interpretations and later invalidation, but not a model input or response. `src/ctx_tests.erl:110-139`.

**[FACT | High]** The compiled test BEAM is stale relative to source and omits that test. No test execution evidence was produced or relied upon in this appraisal.

**[CRITERION-RELATIVE JUDGMENT | High]** The tests verify a different, smaller object than the acceptance oracle defined by A1–A12.

### Authority and security

**[FACT | High]** The API trusts caller-supplied worker/scope values, and projections are retrievable by bare event ID without principal or scope checks.

**[FACT | High]** At inspection time, the Erlang distribution listener was bound to `0.0.0.0:45525`; EPMD was bound to `0.0.0.0/[::]:4369`. The default cookie file had mode `0400`, but no TLS, per-principal policy, or operation-specific authorization appears in the service definition.

**[INFERENCE | High]** A principal possessing the node cookie receives node-level RPC capability, potentially including arbitrary exported OTP/OS functions, rather than the constrained grants required by the specification. Firewall and external network reachability are **[UNKNOWN | High]**.

**[FACT | High]** State files use mode `0644` beneath a group-traversable home path; confidentiality therefore depends on host account/group controls rather than an application protection model.

**[FACT | High]** The systemd unit contains no service sandboxing, capability restriction, address-family restriction, resource limit, or separate action principal. `context-runtime.service:5-10`.

### Failure and recovery

**[FACT | High]** Journal insertion and `dets:sync` occur before semantic application; snapshots are periodically replaced through a temporary file; replay skips event IDs already present in `applied`. `src/context_manager.erl:57-76,114-151,508-531`.

**[CRITERION-RELATIVE JUDGMENT | Medium-High]** This gives a reasonable small-POC recovery basis for deterministic internal transitions.

**[INFERENCE | High]** A malformed live candidate lacking required fields is durably journaled and then crashes semantic application. Replay invokes the same failing operation, with no quarantine or skip policy, so restart can repeatedly fail.

**[FACT | High]** Snapshot corruption is silently replaced by initial state, with recovery delegated to the journal and no corruption observation. `src/context_manager.erl:114-123`.

**[FACT | High]** Snapshot writes do not explicitly fsync the file or containing directory, and no backup/checkpoint validation or schema migration exists.

### Evidence integrity and version authority

**[FACT | High]** The live snapshot statically decodes to sequence 1 with one protected symbol, `observer_owned_test`, and no captured live-event structure. The later journal bytes contain a `live-transfer-1` event and three provisional interpretation-node records.

**[CRITERION-RELATIVE JUDGMENT | High]** Those terms establish that data was written, not that it participated in a pre-response model loop or that its semantic assertions are true.

**[FACT | High]** Files have no embedded code/config/spec digest or hash chain, and the storage is writable by the same user/process authority that produces it.

**[FACT | High]** The observed service process predates the current manager BEAM. The current test BEAM predates changed source and omits one source test. Consequently, source, disk BEAM, live process, snapshot schema, and claimed test object are not tied together by a release identifier.

## 7. Prioritized gaps

### Minimal closure of the live POC

1. **P0 — [JUDGMENT | High]** Implement and demonstrate one genuine governed model turn with an atomic/correlated chain from captured raw event through pre-response projection, actual model input, response, user observation, and revision.

2. **P0 — [JUDGMENT | High]** Replace global IDs with authenticated user/client/session-scoped immutable identifiers; reject conflicting reuse without altering old lineage.

3. **P0 — [JUDGMENT | High]** Make projection observationally read-only, versioned, bounded, and explicit about selection reasons, omitted alternatives, provenance, and graph/spec version.

4. **P0 — [JUDGMENT | High]** Validate before committing executable semantic work, retain invalid raw input separately when required, and quarantine poison events during replay.

5. **P0 — [JUDGMENT | High]** Record raw modality, timing, derivation, unavailable signals, observed/simulated status, and information loss.

6. **P0 — [JUDGMENT | High]** Add response, user observation, correction, rejection/negative-boundary, and governance transitions; ensure rejected candidates and their relations cannot govern projection.

7. **P0 — [JUDGMENT | High]** Introduce a minimal external authority gate even if all consequential actions remain denied by default.

8. **P0 — [JUDGMENT | High]** Produce one coherent release manifest tying source, BEAMs, configuration, specification, state schema, and acceptance evidence together; remove or clearly isolate orphan/stale tests.

9. **P1 — [JUDGMENT | High]** Demonstrate restart/reactivation, cross-client continuity, hidden-oracle revision, and read-only inspection using protected before/after evidence.

### Production hardening

1. **[JUDGMENT | High]** Replace exposed raw Erlang distribution with a least-privilege authenticated gateway, or bind/harden distribution with TLS, network policy, separate credentials, and constrained RPC.

2. **[JUDGMENT | High]** Add durable append-only evidence, integrity chaining/signatures, protected timestamps, external export/witnessing, retention, and omission detection.

3. **[JUDGMENT | High]** Add an action outbox/effect ledger, idempotency contracts, reconciliation, revocation checks, and separate execution principals.

4. **[JUDGMENT | High]** Define storage/schema migration, compaction, backup/restore, corruption handling, release upgrades, and disaster-recovery objectives.

5. **[JUDGMENT | High]** Bound input size, projections, journals, dedupe state, mailboxes, process memory, CPU, restart intensity, and external work; expose predictable degradation.

6. **[JUDGMENT | High]** Add privacy classification, encryption where required, deletion/retention policy, multi-user isolation, and audit access control.

7. **[JUDGMENT | High]** Establish independent V&V roles, protected evidence selection, stakeholder acceptance records, and residual-conflict disclosure.

## 8. Specification ambiguities or unresolved conflicts

1. **[UNKNOWN | High]** The exact operational boundary between a minimally raw voice event and a transcript-plus-missing-modality record is unresolved; raw-audio retention is explicitly open.

2. **[UNKNOWN | High]** “Selected active subgraph” may legitimately contain multiple unresolved interpretations, but the specification does not define whether selection chooses an interpretation, a set, or only a locality boundary.

3. **[UNKNOWN | High]** The supported-client set and the rule determining which model turns are “intended to be governed” are unspecified.

4. **[UNKNOWN | High]** The transition semantics among disputed, rejected, invalidated, dormant, and superseded states—and which actor may perform each transition—are not fully fixed.

5. **[UNKNOWN | High]** Warm versus cold is required semantically, while physical storage tiers remain implementation-defined; the observable distinction and reactivation SLA are not defined.

6. **[UNKNOWN | High]** “Consequential,” “safe pre-authorized,” “appropriate permission,” and required reversibility are not operationally classified.

7. **[UNKNOWN | High]** User ownership is not reduced to concrete rules for legal ownership, OS identity, encryption keys, export, deletion, portability, or delegated relying parties.

8. **[UNKNOWN | High]** Critical claims, evidence-retention periods, integrity strength, trusted-time source, external witness, and independence thresholds remain open.

9. **[UNKNOWN | High]** Numerical resource budgets and degradation thresholds are open, although A12 cannot be tested without an instance-specific declaration.

10. **[INFERENCE | Medium]** Indefinite preservation of rejected/history-bearing material may eventually conflict with privacy or user-directed deletion; the specification supplies no erasure/redaction reconciliation.

11. **[UNKNOWN | High]** The precise interface between an external authority gate and supervised Erlang action workers is unspecified.

12. **[UNKNOWN | High]** Multi-actor disagreement, competing user/relying-party corrections, and authority revocation during an in-flight action are not resolved.

## 9. Evidence index

### Normative specification

- `work/consolidated-specification.md:10-22` — purpose, ownership, closed loop.
- `work/consolidated-specification.md:24-72` — ontology, relations, status/history.
- `work/consolidated-specification.md:74-104` — epistemic/modeling rules.
- `work/consolidated-specification.md:106-134` — live loop, tiers, service, supervision, resources.
- `work/consolidated-specification.md:136-160` — authority.
- `work/consolidated-specification.md:162-192` — observability, evidence, independence.
- `work/consolidated-specification.md:194-213` — anti-specification.
- `work/consolidated-specification.md:214-262` — acceptance scenarios.
- `work/consolidated-specification.md:273-288` — open decisions.

### Implementation

- `src/context_manager.erl:4-35` — public API.
- `src/context_manager.erl:37-97` — storage initialization and calls.
- `src/context_manager.erl:99-151` — state, snapshot load, replay.
- `src/context_manager.erl:153-292` — semantic event handlers.
- `src/context_manager.erl:308-380` — provenance, live-turn ingestion, projection.
- `src/context_manager.erl:391-433` — residency/access mutation on reads.
- `src/context_manager.erl:435-506` — resource eviction/rehydration.
- `src/context_manager.erl:508-557` — persistence, observations, public status.
- `src/ctx_sup.erl:9-27` — supervision topology.
- `src/ctx_worker.erl:18-33` — worker recovery and forwarding.
- `src/context_runtime_app.erl:6-9` — application configuration.
- `context-runtime.service:5-13` — live service command/restart.
- `bin/context-runtime-inspect:9-39` — inspection behavior and RPC.
- `Makefile:10-19` — build/test/demo commands.
- `README.md:18-51,53-78` — stated design, claims, and limitations.
- `src/ctx_tests.erl:11-20,30-163` — current source tests.
- `live_vm/src/ctxv_tests.erl:11-29,32-205` — orphan test specification.
- `src/ctx_demo.erl:4-80` — synthetic demonstration and self-labels.
- `erl_crash.dump:1-4` — current boot-failure dump header.

### Binary/state evidence

- `ebin/context_manager.beam` — exports current live-ingestion/projection API; debug info; SHA-256 `44dc6228…ae2b36`.
- `ebin/ctx_tests.beam` — lacks `live_transfer_test`; SHA-256 `50dcc72b…2b18`.
- `_live_state/snapshot.term` — decoded sequence-1 snapshot; SHA-256 `c0e695ba…f1b0f`.
- `_live_state/journal.dets` — static strings include later live-turn/interpretion records; SHA-256 `317f80e6…86eb12`.
- `_demo_state/snapshot.term` — decoded synthetic revision/cold-storage state; SHA-256 `969d1f0d…d72e5d`.
- `_demo_state/journal.dets` — synthetic journal; SHA-256 `699eea0c…5a49`.
- `work/consolidated-specification.md` — SHA-256 `f72dfd03…39d7b`.

**[FACT | High]** These state/crash hashes were identical before and after the appraisal.
