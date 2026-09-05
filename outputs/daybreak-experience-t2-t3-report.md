---
status: frozen historical stage result
stage: T2 and T3 only
date: 2026-09-04
method: source-regrounded TDD, isolated VM verification, authorized live BEAM subtree
semantic_oracle: external stakeholder; runtime self-acceptance forbidden
external_or_os_effects: none
---

# Experience Base / Runtime Tree — T2 and T3 Report

## 1. Re-grounding checkpoint

This material transition began by rereading the relevant original stakeholder events, not merely the generated specification or the T1 report.

Selected source events:

- Original trajectory ordinal 1719: prior runtime outcomes should remain available as prudential experiential reference, separately from knowledge reference.
- Original trajectory ordinal 1745: the semantic pointer is similar to RAG but is not RAG.
- Continuation ordinal 3089: Experience Base state is relative to the runtime and its symbolic context-tree transformations, not to timestamps.
- Continuation ordinal 3459: the stakeholder rejects the imported software/OS-security meaning of “sandbox” for this POC and scopes it to semantic and contextual objects inside the Erlang VM.
- Continuation ordinal 3550: on doubt, return to and reread the stakeholder’s prior words before continuing.
- Latest stakeholder dispatch: T2 must distinguish causal runtime experience from word/time retrieval; T3 must test the exact scoped sandbox correction across paraphrase, regenerated summary, and rehydration, with host-security and revoked/out-of-scope controls.

Derived artifacts compared:

| Artifact | Version/hash | Role |
|---|---|---|
| `work/consolidated-specification.md` | v0.13; `678efd6f017e2b0aa7235beffb2f4469875c21a37100fbdedcae7a70873230c1` | Derived index into source trajectory |
| `work/experience-test-program.md` | v0.1; `c93f5b606a7e88e8b2768bc1a4f40b72e95ee41bcb07945c856b5d9e6c67b6d9` | Derived test program and common bounds |
| `outputs/daybreak-live-experience-slice-report.md` | `2bd175ad7a6487a50aafdaa805af4d8290638d81660c3cfd8523c4bbe0e03e28` | Historical T1 evidence only |

The current dispatch conflicts with the older program’s T2/T3 numbering. The checkpoint disposition was **PROCEED**, with the latest stakeholder definitions governing T2/T3 and the program’s common evidence/containment rules retained. No universal semantic rule, external action, or runtime self-acceptance was authorized.

The live evidence contains a `provisional_regrounding_receipt_v1` record with these sources, artifact hashes, conflict disposition, exclusions, and bounded proceed result. This record documents the operator comparison; it is not represented as automated source retrieval.

## 2. Frozen criteria

### T2 — Runtime experience is not timestamp/log retrieval

Before implementation, the test fixed these requirements:

1. Give the same lexical later event to two branches with different causal histories and to a sham branch containing only timestamped logs.
2. Require different later selections in the two experiential branches according to their local transformations.
3. Require no experience selection in the sham branch.
4. Repeat with a paraphrase carrying the same typed semantic pointer.
5. Swap the history/log timestamps so recency cannot explain both results.
6. Add a newer, lexically identical but causally irrelevant lure and require it to remain unselected.
7. Preserve raw-event → interpretation → transformation → result lineage.
8. Keep Knowledge Base references separately empty.

### T3 — Scoped sandbox correction and relapse prevention

The correction source was frozen exactly as:

> sandbox means semantic-contextual inside BEAM, not OS-security sandbox

The tested scope was `erlang_context_runtime_poc`. Passing required:

1. block the rejected OS-security meaning in the original form;
2. block a paraphrase of the same in-scope relapse;
3. block a regenerated-summary relapse after an actual supervised process restart and state rehydration;
4. leave a genuine `host_security_review` proposal unblocked;
5. leave an abstract-boundary negative control unblocked;
6. honor a separately identified counterfactual revocation rather than applying the old correction universally;
7. retain the pre-correction historical state and correction/proposal lineage;
8. create no canonical symbol and make no runtime claim of semantic self-judgment.

## 3. Source files and provisional schemas

Files added for this stage:

| File | Purpose | SHA-256 |
|---|---|---|
| `src/ctx_experience_t2.erl` | Pure, immutable T2 causal-trajectory state and projection | `b14b985c9ffa7b5a3e19d82d51d92b60f11fb61bfa031e83c1e72105fc3b7012` |
| `src/ctx_semantic_correction_t3.erl` | Pure, immutable scoped-correction, proposal, disposition, revocation, and projection state | `64f397e52671c5274879a160a53db4e892d46191900570fe7c7997e8512862c0` |
| `src/ctx_experience_t23_checkpoint.erl` | Test-local in-memory rehydration checkpoint owner | `fb8a66f67300f0af20022b3034f8e1d1b3319f2ccac4359b15e96a1632c57119` |
| `src/ctx_experience_t23_branch.erl` | Generic supervised T2/T3 branch server and stage-separated delivery receipts | `00eb7b9cbda5d432e69a54dcf4484f27599bb20362d2b08d6b693748b78b1c02` |
| `src/ctx_experience_t23_sup.erl` | Bounded one-for-one T2/T3 experiment supervisor | `ec7fdf665418e76166b6bea78347e561a5045d2c9e1e784e98dde268d207eab0` |
| `src/ctx_experience_t23.erl` | Fixed comparator, counterfactual runner, re-grounding record, measures, and evidence bundle | `722c423886cabe3f6f5ee76f1b51c8532881a6650dea7ab74d7d9ff76ee2f885` |
| `test/ctx_experience_t23_tests.erl` | Frozen T2/T3 acceptance assertions | `4921b0be803c4ba3c6e028125b431baa0989e53192422e8cca7b214ad440f732` |

New schema names are deliberately provisional:

- `provisional_experience_t2_state_v1`
- `provisional_experience_t2_projection_v1`
- `provisional_semantic_correction_t3_state_v1`
- `provisional_semantic_correction_t3_projection_v1`
- `provisional_t23_delivery_receipt_v1`
- `provisional_regrounding_receipt_v1`
- `provisional_experience_t2_evidence_v1`
- `provisional_semantic_correction_t3_evidence_v1`

The T2 `trajectory_key` and T3 proposal `meaning_key` are assigned by the frozen test fixture. The runtime applies typed traversal and scope/status rules; it does not infer those keys from natural language.

## 4. RED/green TDD record

All isolated compilation used `compile:file/2` with `[binary, report_errors, report_warnings]`, loaded returned binaries into a disposable Erlang VM, ran from `/tmp`, and set `ERL_CRASH_DUMP=/dev/null`. It emitted no `.beam` files in `src/` or `test/`.

| Stage | Result |
|---|---|
| Oracle RED | With only `test/ctx_experience_t23_tests.erl` present, execution failed at `ctx_experience_t23_sup:start_link/0` with expected `undef`; exit 1. |
| First implementation RED | Compilation rejected unquoted reserved map key `after` at lines 236/512 and an ambiguous local `apply/2`; exit 1. No test runtime was created. |
| Minimal revision | Renamed the key to `after_sample` and the helper to `branch_apply/2`; the acceptance oracle was not changed. |
| GREEN | Intentional T3 worker termination produced the expected OTP supervisor report, and the suite printed `T23_GREEN isolated tests passed`; exit 0. |

The isolated suite created and tore down a fresh supervision subtree. It verified every boolean and count later reported by the live run, including exact state equality across restart.

## 5. Live process topology

The existing node `fern_context_runtime@nitro` was not stopped or restarted. Six stage modules were compiled in the disposable client VM and temporarily loaded into the live node. A `restart => temporary` child was inserted beneath `ctx_sup`:

```text
ctx_sup
└── ctx_experience_t23_sup                    <10029.275.0>
    ├── ctx_experience_t23_checkpoint         <10029.276.0>
    ├── ctx_t2_history_a                      <10029.277.0>
    ├── ctx_t2_history_b                      <10029.278.0>
    ├── ctx_t2_sham                           <10029.279.0>
    ├── ctx_t3_baseline                       <10029.280.0>
    ├── ctx_t3_corrected                      <10029.281.0>
    ├── ctx_t3_revoked                        <10029.282.0>
    └── ctx_experience_t23_comparator         <10029.283.0>
```

This is nine ephemeral actors including the supervisor, below the declared ceiling of 12. The checkpoint was an ordinary test-local Erlang process holding immutable branch terms. It used no ETS, DETS, file, port, network provider, or governing-runtime state.

## 6. T2 evidence

### 6.1 Causal histories and timestamp counterfactual

Both experiential branches indexed `prior_runtime_choice`, but their causal transformations produced different provisional result nodes:

- history A: transformation timestamp 900 → `t2_a_result`;
- history B: transformation timestamp 100 → `t2_b_result`.

Each also contained a lexically identical, non-causal timestamped log claiming the other result:

- history A log timestamp 100, claiming B;
- history B log timestamp 900, claiming A.

The sham branch contained only a lexically matching log at timestamp 10000 and later raw events. It contained no interpretation/transformation/result trajectory.

### 6.2 Projections

The exact later input text was the same in all three branches: `revisit the earlier runtime choice`.

| Probe | History A | History B | Sham log-only |
|---|---|---|---|
| Exact same lexical event | selected `t2_a_result` | selected `t2_b_result` | selected none; `experience_claim=false` |
| Paraphrase: “apply what this runtime learned from that choice” | selected `t2_a_result` | selected `t2_b_result` | selected none |
| Newer lexically identical lure, timestamp 20000, unrelated trajectory key | selected none | selected none | selected none |

Both experiential projections returned the four-link lineage:

```text
raw_event -> interpretation -> transformation -> result
```

All nine inspected projections returned `knowledge_refs=[]` and marked lexical content and timestamp ordering as non-authoritative selection fields. The projection followed the fixture-supplied semantic pointer through the branch-local causal index.

### 6.3 Verdicts and measures

Live evidence hash:

```text
8A09CADD62CCDE80DEACA3378945D7BEE2F74ED262EA97676D15CF09A89E472F
```

Semantic result: **PASS for the frozen structural criterion**.

- same lexical event: true;
- different causal selections: true;
- sham not represented as experience: true;
- paraphrase stable: true;
- timestamps swapped without redirecting selection: true;
- lexical lure ignored: true;
- lineage complete: true;
- Knowledge Base references separate: true;
- timestamp/lexical contamination observed: false.

Operational result: **PASS within declared test bounds**.

- branch heads: A=5, B=5, sham=4, all expected;
- receipts: 14, all sent/delivered/interpreted/committed, none executed externally;
- wall time: 310 microseconds in the reported live run;
- actors: 9;
- sampled T2 branch memory: 8,568 → 28,440 bytes;
- sampled queues after synchronous processing: total 0, max 0;
- true queue high-water mark: unknown because no high-water instrumentation was added.

## 7. T3 evidence

### 7.1 Correction and branches

All three branches began with two provisional, non-canonical interpretations for `erlang_context_runtime_poc`: `semantic_context_sandbox` and `os_security_sandbox`. The baseline had no correction. The corrected branch received source event `stakeholder_correction_3459`. The revocation branch received the same correction and then a separately identified **counterfactual test-fixture revocation**, explicitly marked as not an actual stakeholder event.

Applying the correction added a scope-local governing constraint, marked the OS-security candidate historical/rejected for that scope, activated the semantic-context candidate for that scope, and preserved the source and relation lineage. It created no universal or canonical symbol.

### 7.2 Relapse and negative-control outcomes

| Probe | Baseline | Corrected branch |
|---|---|---|
| Original OS-security relapse | unblocked without applicable correction | `blocked_semantic_relapse` |
| Host-kernel/filesystem paraphrase | unblocked without applicable correction | `blocked_semantic_relapse` |
| Regenerated host-hardening summary | unblocked without applicable correction | `blocked_semantic_relapse` after restart |

Negative controls:

- a real `host_security_review` scope was not blocked;
- an abstract-boundary meaning in the POC scope was not blocked;
- after the explicitly modeled counterfactual revocation, the OS-security proposal was `unblocked_revoked_correction` rather than governed by the old correction.

The pre-correction graph version remained projectable with OS-security provisionally active. The current corrected projection selected the semantic-context candidate while both candidates remained non-canonical. All inspected projections kept `knowledge_refs=[]`.

### 7.3 Restart and rehydration

The comparator captured the corrected branch at graph version 4, killed PID `<10029.281.0>`, observed the supervisor restart it as `<10029.304.0>`, and queried the restarted process before delivering the regenerated-summary probe.

```text
version before = 4
version after  = 4
phash2 before = 110084783
phash2 after  = 110084783
exact Erlang term equality = true
```

The regenerated-summary relapse was then blocked using the rehydrated correction state. This demonstrates one test-local in-memory rehydration path; it is not disk durability or whole-node recovery.

### 7.4 Verdicts and measures

Live evidence hash:

```text
0262BBB8A4A99237E19B88BE650185D0C1E0D91A492BB7EF955572CC8EBD2F4E
```

Semantic result: **PASS for the frozen structural regression set, pending external stakeholder appraisal of meaning**.

- unblocked in-scope relapse count: 0;
- out-of-scope overgeneralization count: 0;
- unauthorized canonization count: 0;
- original, paraphrase, and regenerated-summary relapse blocked: true;
- host-security and abstract negative controls unblocked: true;
- counterfactual revocation honored: true;
- correction/proposal lineage complete: true;
- historical state recoverable: true;
- runtime semantic self-judgment: not performed.

Operational result: **PASS within declared test bounds**.

- heads: baseline=4, corrected=7, revoked counterfactual=4, all expected;
- receipts: 15, all committed as proposal/correction/disposition evidence, none executed externally;
- supervised worker restarts: 1;
- exact checkpoint rehydration: true;
- wall time: 11,467 microseconds;
- actors: 9;
- sampled T3 branch memory: 8,568 → 41,232 bytes;
- sampled queues after synchronous processing: total 0, max 0;
- true queue high-water mark: unknown.

## 8. Cleanup and governing-state evidence

Before insertion, all nine experimental registered names were `undefined`. The deterministic SHA-256 of `context_manager:status()` was:

```text
826FD6996F82B1608FA9B598B6FC198A07E02844E35C466C25A7224D8E632E72
```

It was identical during the experiment and after cleanup.

Cleanup results:

```text
terminate_child = ok
delete_child    = {error,not_found}
```

The `not_found` result is expected because the dynamically inserted child used `restart => temporary` and its child specification disappeared on termination. All six dynamically loaded modules were deleted and purged. Every experimental registered name returned to `undefined`. The manager status term compared exactly equal before and after.

The persistent artifacts retained their earlier hashes and timestamps:

```text
_live_state/journal.dets
317f80e691cbb2c21d93c5407d5caacfa148f2b25071eccc5a926a3e3886eb12
mtime 2026-09-04 15:39:01.816724835 -0300

_live_state/snapshot.term
c0e695ba618efe54f2ad053aace6e4f5fc141e38bd03ae31b6034d67b85f1b0f
mtime 2026-09-04 15:38:37.702329261 -0300
```

The initial pre-run `sha256sum _live_state/...` command was issued from `/tmp` and returned “No such file or directory.” This was an evidence-command path error, not a POC failure or state mutation. The absolute-path read after cleanup produced the hashes above, equal to the previously frozen T1 observations. Therefore the manager equality is a direct before/during/after proof for this run; file-byte equality is supported by unchanged earlier-versus-after hashes and old mtimes, not by a successful immediate pre-run file hash in this command.

## 9. Exact execution forms

The RED and GREEN isolated runs used this execution form with the seven listed files:

```text
ERL_CRASH_DUMP=/dev/null erl -noshell -eval '
  compile:file(File,[binary,report_errors,report_warnings]),
  code:load_binary(...),
  ctx_experience_t23_tests:run(),
  halt(...).
'
```

The live run used:

```text
ERL_CRASH_DUMP=/dev/null erl -noshell -sname ctx_t23_probe_<shell-pid> -eval '<bounded live runner>'
```

The runner pinged only `fern_context_runtime@nitro`, compiled the six runtime modules with the same in-memory `binary` option, invoked `code:load_binary/3` through local Erlang RPC, inserted `ctx_experience_t23_sup` under `ctx_sup`, called `ctx_experience_t23:run_t2/0` and `run_t3/0`, compared manager status terms, terminated the temporary child, deleted/purged the modules, and verified all names and manager state. It exited 0.

The corrected state read used:

```text
sha256sum /home/fern/Documents/Codex/2026-09-04/context-runtime-erlang-poc/_live_state/journal.dets /home/fern/Documents/Codex/2026-09-04/context-runtime-erlang-poc/_live_state/snapshot.term
```

## 10. Explicit non-claims and unknowns

- The fixture supplies semantic pointer and meaning keys. These tests do not demonstrate natural-language understanding, embedding retrieval, general paraphrase recognition, or autonomous semantic classification.
- A structural semantic PASS means the implementation matched the frozen source-grounded fixture. Final semantic correctness remains for the stakeholder; the runtime did not select or accept its own oracle.
- T2 does not prove that every useful experience can be represented by one key, that causal indexing is globally correct, or that timestamp/text retrieval is never useful.
- T2’s logs are test objects, not an implemented logging or RAG subsystem. `knowledge_refs=[]` preserves a boundary but does not implement a Knowledge Base.
- T3 does not prove a universal anti-relapse mechanism. It covers three positive relapse forms and three negative controls under exact typed scopes.
- The counterfactual revocation is synthetic and is not attributed to the stakeholder.
- The in-memory checkpoint surviving a sibling worker restart does not establish service restart, node restart, machine reboot, disk recovery, distributed recovery, or tamper resistance.
- `phash2` is a comparison aid, not cryptographic evidence. Exact term equality was also checked.
- Message-stage booleans are producer evidence from this same-authority experiment, not independent assurance.
- Sampled queue length after operations is not a queue high-water measurement.
- Microsecond timings are single-run observations, not benchmarks.
- No model response, current voice turn, external provider, host-security operation, OS mutation, network service, action authority gate, or stakeholder acceptance decision was exercised.
- No claim is made about consciousness, general learning, production readiness, optimality, or the complete Context Runtime.

## 11. Bounded conclusion and next state

T2 establishes, for a typed and bounded structural fixture, that later projection can follow branch-local causal runtime trajectory rather than identical wording, timestamp ordering, or a log-only sham. T3 establishes, for its frozen scope and regression set, that a stakeholder correction can remain governing across paraphrase, generated-summary recurrence, and one supervised worker restart without blocking genuine host-security, abstract-boundary, or explicitly revoked controls.

Both results are provisional producer evidence awaiting stakeholder appraisal. Their live experiment was removed without changing the pre-existing manager state. This stage is frozen before T4; later steps must reread their own relevant source events and may not retroactively enlarge these claims.
