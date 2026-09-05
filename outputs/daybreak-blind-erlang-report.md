# Frozen Blind Assessment of the Erlang Application

**Reviewer:** Daybreak, Ultra reasoning mode  
**Assessment type:** blind, read-only architectural and forensic review  
**Cutoff:** 4 September 2026, 16:34:13 BRT  
**Withheld from reviewer:** stakeholder specification, desired behavior, success criteria, prior narrative, and all `work/` and `outputs/` material

## Review integrity

**FACT — high confidence.** The reviewer did not compile or execute the application, run tests or project scripts, open DETS through Erlang, call the live node, or change service state. Existing state-file hashes were unchanged during the review. Statements below therefore distinguish static implementation evidence from behavior that would require execution.

## Executive finding

**INFERENCE — high confidence.** The implementation appears intended as a falsifiable semantic-context persistence proof of concept: it journals events, materializes symbols and relations, retains provisional interpretations, preserves limited correction history, demonstrates supervised worker restart in source, and experiments with group-based hot/cold residency.

**FACT — high confidence.** Its demonstrable implementation is narrower: a single-node, single-writer Erlang event journal and materialized semantic store, plus a small application-level cache and three thin supervised clients. It contains no model adapter, voice adapter, planner, autonomous learning loop, operating-system tool executor, or mechanism that selects an interpretation and feeds it into a model response.

**UNKNOWN — high confidence.** Without the withheld stakeholder specification, the reviewer cannot establish whether this is the intended application or whether it meets its actual success criterion.

## 1. Demonstrable architecture and runtime model

- **FACT — high confidence.** The project is an OTP application. Its callback reads `storage_dir` and `hot_budget`, then starts one locally registered supervisor. The supplied service configures `_live_state` with a hot budget of 64; source defaults are `_context_state` and 4. Evidence: `src/context_runtime_app.erl:6-9`; `context-runtime.service:7-8`.

- **FACT — high confidence.** `ctx_sup` starts four permanent children using `one_for_one` supervision with restart intensity 5 in 10 seconds: `context_manager`, then workers `ctx_worker_alpha`, `ctx_worker_beta`, and `ctx_worker_gamma`, with scopes `research`, `operations`, and `reflection`. Evidence: `src/ctx_sup.erl:9-25`.

- **FACT — high confidence.** The conceptual graph is data within the manager, not a graph of Erlang processes. Manager state contains worker summaries, hot nodes, catalog metadata, edges, bridges, recurrence counts, policies, live events, applied event IDs, and observations. Evidence: `src/context_manager.erl:99-112`.

- **FACT — high confidence.** All semantic mutations pass through one locally registered `gen_server`. Calls are serialized in that process, making it both the single writer and a runtime bottleneck. Evidence: `src/context_manager.erl:15-35,52-87`.

- **FACT — high confidence.** Workers are synchronous clients. Their only local state is name, scope, and a cached manager-provided summary containing count, last event ID, scope, and seed. They contain no semantic graph, queue, planner, model, executor, or OS-tool adapter. Evidence: `src/ctx_worker.erl:8-37`; `src/context_manager.erl:52-56,382-389`.

- **FACT — high confidence.** Persistence uses a compressed Erlang-term snapshot plus a DETS set containing journal and node records. Startup opens DETS, loads a decodable snapshot, and replays journal sequences newer than `snapshot_seq`. Evidence: `src/context_manager.erl:37-50,114-151,508-531`.

- **FACT — high confidence.** “Hot/cold” is application-level data residency: full hot nodes remain in the manager map; cold node bodies remain in DETS while catalog metadata marks them cold. It is not BEAM hibernation or virtual-machine paging. Evidence: `src/context_manager.erl:391-433,435-506`.

- **FACT — high confidence.** Time is a single global logical sequence incremented for each first-seen event ID. No wall-clock timestamp or distributed causal metadata is recorded. Evidence: `src/context_manager.erl:65-67,308-309,537-557`.

- **FACT — high confidence.** At the review cutoff, the user service was active and had not been restarted by systemd. Its process held `_live_state/journal.dets` open.

- **UNKNOWN — high confidence.** The code version loaded in the running BEAM process cannot be established without contacting or inspecting that VM. The current manager BEAM file was newer than the service start, so hot loading may or may not have occurred.

- **FACT — high confidence.** `live_vm/` contains only `src/ctxv_tests.erl`; the referenced `ctxv_sup`, `ctxv_store`, and `ctxv_layer` implementations and BEAMs are absent and are not part of the root Makefile.

## 2. Demonstrable behaviors and transitions

- **FACT — high confidence.** Symbol operations include create, review, invalidate, and reactivate. They update status/version/history and record caller-supplied worker, scope, event ID, and logical sequence. Evidence: `src/context_manager.erl:158-176,204-231,294-309`.

- **FACT — high confidence.** Edges may be created and their relation revised, but endpoints are not validated. Reusing an edge ID overwrites the previous edge at version 1 rather than preserving a collision or history. Evidence: `src/context_manager.erl:177-203`.

- **FACT — high confidence.** A bridge maps a token to node IDs. Activation loads those IDs, protects their groups temporarily during budget enforcement, and silently omits missing nodes. Bridge definitions have no version, provenance, or history. Evidence: `src/context_manager.erl:232-250,426-433`.

- **FACT — high confidence.** Three `demand` events of one type create a latent, reversible, non-executable policy flag. `promote_policy` changes flags to active/executable but explicitly returns `executed => false`; `demote_policy` restores latent/non-executable status. No executor consumes these flags. Evidence: `src/context_manager.erl:251-290`.

- **FACT — high confidence.** `live_turn` preserves the raw map, creates one provisional interpretation node per candidate, creates provisional `interpretation_of` edges, and selects none. Projection always returns `selection => none`. Evidence: `src/context_manager.erl:311-380`.

- **FACT — high confidence.** Event-ID deduplication is global across every worker and scope. A repeated ID returns the old result without comparing the new payload, advancing sequence, or incrementing the worker count. Evidence: `src/context_manager.erl:57-76`.

- **FACT — high confidence.** A first-seen event is journaled and synced before semantic processing. Semantic rejections—such as an existing symbol or unknown node, edge, bridge, policy, or event—are still journaled, marked applied, counted as accepted worker events, and wrapped in `{accepted, Result}`. Evidence: `src/context_manager.erl:57-76,160-163,191-193,239-240,278-292`.

- **FACT — high confidence.** The preserved demo store passively decodes to a snapshot at sequence 12 and a journal through sequence 14. It records five creations, invalidation/reactivation, bridge definition/activation, three demands, promotion, and demotion. This proves that the artifacts exist, not that current source passes current tests.

- **FACT — high confidence.** The preserved live store contains a snapshot at sequence 1 and journal records through sequence 2. It includes one protected symbol and one raw `realtime_voice` turn with three provisional interpretations: `active-runtime`, `replaceable-model-client`, and `supervised-operation`. The last is a stored claim that workers may invoke OS tools; it is provisional, unselected data, not an implemented capability.

- **FACT — high confidence.** Both stores have snapshot lag relative to their journals. Replay can recover this if the journal is intact, which makes the journal indispensable.

## 3. Interfaces and active control

- **FACT — high confidence.** Public manager calls are `apply_event/4`, `ingest_live/5`, `projection/1`, `worker_state/2`, `status/0`, `symbol/1`, and `force_snapshot/0`. Evidence: `src/context_manager.erl:4-35`.

- **FACT — high confidence.** Public worker calls submit an event, return cached status, or deliberately simulate a crash. Evidence: `src/ctx_worker.erl:4-16,24-33`.

- **FACT — high confidence.** A caller can mutate symbols, edges, bridges, recurrence/policy flags, and live-turn records, force a snapshot, or deliberately crash a worker.

- **FACT — high confidence.** Worker and scope provenance is not bound to the calling PID or registered worker. Any caller can call `context_manager:apply_event/4` and claim an arbitrary worker or scope identity.

- **FACT — high confidence.** Source and BEAM imports contain no shell, port, subprocess, HTTP, socket-client, model, voice, or generic tool-execution path. Workers call only the manager and `exit/1`; the manager performs DETS and file operations. The implemented semantic events cannot invoke OS tools.

- **FACT — high confidence.** `bin/context-runtime-inspect` is an external shell client. It uses system tools and then starts a second distributed Erlang node for manager status/projection calls. Those shell operations are not worker capabilities. Evidence: `bin/context-runtime-inspect:4-39`.

- **FACT — high confidence.** The service enables Erlang distribution with `-sname`. A peer possessing the Erlang cookie is not limited to the context API; standard distributed Erlang RPC can invoke arbitrary exported functions under the service user's authority. Evidence: `context-runtime.service:8`; `bin/context-runtime-inspect:24-33`.

- **FACT — high confidence.** The demo deletes `_demo_state` before starting its isolated runtime, and `make clean` removes `ebin` plus `_demo_state`. These are manual project operations, not autonomous live behavior. Evidence: `src/ctx_demo.erl:4-8`; `Makefile:21-22`.

## 4. Supervision, failure, and recovery

- **FACT — high confidence.** A worker exit is eligible for permanent local restart without intentionally restarting its siblings or the manager. The new worker reloads its small summary from the manager. Evidence: `src/ctx_sup.erl:9-25`; `src/ctx_worker.erl:18-29`.

- **INFERENCE — high confidence.** Under ordinary OTP semantics, the simulated crash should yield a new worker PID, but the blind review did not execute this path. Preserved evidence does not record PIDs or supervisor restarts.

- **FACT — high confidence.** Manager recovery loads a snapshot and replays later journal inputs, rebuilding applied IDs and worker counters. Journal records and currently hot nodes are DETS-synced. Evidence: `src/context_manager.erl:65-75,125-151,508-519`.

- **INFERENCE — high confidence.** A journal-serializable event that crashes semantic processing can become a poison record: it is synced first, then crashes on processing, and restart replay can crash on the same record until supervisor intensity is exhausted. Evidence: `src/context_manager.erl:65-75,125-151,311-333`; `src/ctx_sup.erl:19`.

- **FACT — high confidence.** Snapshot decode failure silently produces a fresh initial state; no corruption report or schema validation is exposed. Recovery then depends on full journal replay. Evidence: `src/context_manager.erl:114-123`.

- **FACT — high confidence.** Graceful manager termination attempts a snapshot and DETS close. Kill, VM crash, power loss, or snapshot-write exceptions can bypass completion. Evidence: `src/context_manager.erl:92-95,521-529`.

- **INFERENCE — high confidence.** Application-supervisor exhaustion may leave systemd reporting the BEAM OS process alive because the application is started temporarily while a top-level evaluator independently waits forever. `Restart=on-failure` observes process failure, not application health. Evidence: `context-runtime.service:8-10`.

- **FACT — high confidence.** Zero systemd restarts establishes only that systemd did not restart the OS process. No child-restart counter or conclusive manager/worker restart telemetry is exposed.

## 5. Observability, auditability, integrity, security, and operations

### Observability and auditability

- **FACT — high confidence.** `status/0` exposes logical sequence, worker summaries, catalog, edges, bridges, recurrence, policies, live-event IDs, and observations. Raw live events require projection. Evidence: `src/context_manager.erl:537-557`.

- **FACT — high confidence.** `symbol/1` and `projection/1` mutate cache state: they load cold nodes, increment access counts, update last-touch, alter hot/cold residency, and may evict other groups. The supplied inspection client can therefore affect later eviction order and status. Evidence: `src/context_manager.erl:80-85,357-379,402-433`; `bin/context-runtime-inspect:28-34`.

- **FACT — high confidence.** Observations are capped at 30, lack timestamps, and are not journaled. Startup and duplicate observations can disappear unless a later snapshot preserves them. Evidence: `src/context_manager.erl:49-50,61-63,533-535`.

- **FACT — high confidence.** Journal provenance is caller-asserted. It lacks authenticated attribution, payload hash, result, code version, timestamp, and hash chaining.

- **FACT — high confidence.** Replay recomputes results using the code loaded later, so code changes may reinterpret post-snapshot journal inputs.

### Integrity and correctness

- **FACT — high confidence.** Global event-ID deduplication can silently suppress a legitimate event from another worker/scope; a different payload with the same ID is treated as a duplicate rather than a collision.

- **FACT — high confidence.** `live_turn` candidate IDs are not checked against the catalog. A candidate can overwrite an existing symbol, resetting kind, status, version, history, and protection. Edge IDs can likewise overwrite edges. Evidence: `src/context_manager.erl:319-345`.

- **FACT — high confidence.** `protected` influences eviction only. It does not restrict review, invalidation, reactivation, or candidate overwrite and is not an authorization control.

- **FACT — high confidence.** The eviction fallback can discard an accepted new or updated node immediately when all other candidate groups are protected. The catalog can then claim a cold node for which no DETS node record exists, or an updated node can revert to a prior DETS version. Evidence: `src/context_manager.erl:294-305,435-475,490-512`.

- **FACT — high confidence.** If every group is protected, eviction can stop while above budget. “Bounded hot symbols” is not an invariant. Evidence: `src/context_manager.erl:448-460`.

- **FACT — high confidence.** Snapshot terms use safe decoding, but the resulting map is not structurally validated. Saved values can replace runtime keys after merge. Evidence: `src/context_manager.erl:114-123`.

- **FACT — high confidence.** Snapshot replacement uses a temporary file and rename but has no explicit file/directory `fsync`, backup generation, or checksum. Evidence: `src/context_manager.erl:521-529`.

### Security and confidentiality

- **FACT — high confidence.** At cutoff, the BEAM distribution listener and EPMD listened on all interfaces. Effective external reachability was not assessed.

- **FACT — high confidence.** The service unit declares no application-specific TLS, authorization, sandbox, filesystem restriction, resource limits, or readiness check. It runs under the user's account. The Erlang cookie has restrictive local file mode but remains a shared high-value credential.

- **INFERENCE — high confidence.** A network-reachable peer that obtains the cookie can execute arbitrary Erlang RPC under the service user's authority, not merely context-store operations. The project declares no TLS protection for distribution.

- **FACT — high confidence.** Project/state directories and source/state files are readable by other local accounts that can traverse the parent path. Stored voice text and semantic content therefore lack project-specific local confidentiality controls.

- **FACT — high confidence.** BEAMs were compiled with `debug_info`, embedding abstract code and source paths in readable files.

- **FACT — high confidence.** There are no input-size, collection-size, caller, rate, or mailbox limits. Caller-supplied Erlang terms and growing maps can consume memory, disk, CPU, or atoms.

### Operational risks

- **FACT — high confidence.** Hot-node count is the only intended bound, and even it is conditional. Catalog, journal, applied IDs, workers, edges, bridges, recurrence, policies, live events, histories, raw text, and cold data grow without compaction.

- **FACT — high confidence.** `status/0` copies almost the full public state; projection scans all edges and performs repeated membership checks. Cost grows with accumulated data and blocks the single manager while executing.

- **FACT — high confidence.** Revision and candidate construction repeatedly append to lists, creating avoidable nonlinear behavior for large histories or candidate sets.

- **FACT — high confidence.** The service and inspection client hard-code project paths and hostname-derived node naming.

- **FACT — high confidence.** The compiled `ctx_tests.beam` is older than `src/ctx_tests.erl`: its abstract code contains five tests and omits `live_transfer_test`, while source declares six. Existing BEAMs do not prove that current six-test source passes.

- **FACT — high confidence.** `live_vm/src/ctxv_tests.erl` asserts stronger behavior—validation before journaling, collision detection, journal verification, read-only projections, four interpretation layers, and responses—but all supporting `ctxv_*` modules are absent. These tests are design assertions, not implementation evidence.

## 6. Apparent intention or capability — inference only

- **INFERENCE — high confidence.** The system appears intended to retain raw events and parallel provisional interpretations, preserve correction lineage, expose logical provenance, demonstrate worker restart, and experiment with hot/cold semantic residency.

- **INFERENCE — high confidence.** Its implemented capability is closest to a single-node event journal plus materialized semantic maps and a small cache.

- **INFERENCE — high confidence.** An external model, voice service, or other Erlang client could produce and consume ordinary Erlang terms through an adapter, but no such gateway or model lifecycle exists in the inspected implementation.

- **INFERENCE — high confidence.** The “executable policy” field seems intended to represent explicit authorization state, but present code only changes flags and performs no scheduled or external work.

- **INFERENCE — high confidence.** The orphan `ctxv_tests.erl` appears to describe a planned successor with four interpretation layers, verifiable journaling, responses, stronger validation, and read-only projection. The implementations are absent.

- **INFERENCE — high confidence.** The live-state claim that workers can invoke OS tools is stored semantic input, not a capability of the reviewed application.

## 7. Unknowns that the artifact cannot settle

- The stakeholder specification, intended success criteria, or conformity to them.
- Whether current source compiles and current tests pass; neither was executed.
- The manager BEAM version and in-memory state of the running process.
- The health of manager and workers; OS-process health is not application health.
- Whether any worker or manager restart occurred.
- Who submitted preserved events, whether their content is true, or whether they correspond to an external acceptance criterion.
- Effective network reachability and security controls outside the project unit.
- DETS health according to Erlang, intentionally not tested by opening the files.
- Crash consistency under power loss, partial corruption, or hostile state changes.
- Production throughput, latency, mailbox behavior, and storage growth.
- Autonomous reasoning, learning, intent inference, causal guarantees, consensus, or generic tool use; no implementation evidence establishes these.

## Frozen blind conclusion

The code and artifacts communicate a persistence-and-supervision experiment, not a live semantic agent runtime. They expose meaningful technical mechanisms and several serious correctness, observability, security, and operational defects. Most importantly for the later differential review, the artifact alone does not communicate the stakeholder's intended closed loop or acceptance oracle. Whether that absence is an implementation failure, a documentation failure, a deliberate external separation, or all three can be judged only after the withheld specification is supplied.
