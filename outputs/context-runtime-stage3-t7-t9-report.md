---
status: frozen historical stage result
stage: T7-T9
date: 2026-09-04
method: per-test source re-grounding, RED/minimal/GREEN, isolated and live supervised execution
semantic_oracle: stakeholder external to runtime
---

# Runtime Tree Stage 3 — T7 to T9

## Scope and source grounding

Each material test transition was opened only after rereading the applicable stakeholder events rather than treating the generated program as normative.

- **T7 — focal interlocution while planning continues:** original ordinals 831, 1010, 1342, 2663, and 2675. The fixture therefore treated the newest user event as proximal and governing while a bounded adjacent planner remained off-focus.
- **T8 — bounded artifact appraisal:** original ordinals 831, 1342, and 1362. Background output was treated as an idea/proposal, not an instruction, accepted fact, or automatically focal relation.
- **T9 — isolated clone:** original ordinals 721, 2448, and 2456 plus continuation ordinal 3089. Clone ancestry and divergence had to remain separate from the governing source; return was a reviewable delta, never an automatic merge.

Specification v0.15, test-program v0.1, and the oracle/fixture documents were used as derived indexes. All schemas, typed meanings, promotion decisions, and relation fixtures are provisional. The T8 `promote` event is a test-internal appraisal transition, not stakeholder appraisal or canonical acceptance.

## Source files

| File | SHA-256 |
|---|---|
| `src/ctx_runtime_tree_stage3_interlocutor.erl` | `958cc0157ca889b8e25e9b197ec14bb84ca4044c80ffb66e7417b4363ee85fac` |
| `src/ctx_runtime_tree_stage3_planner.erl` | `9f70d7fabc060f057593aa2f23216f3ac71700f264fb92081b0394a3ecad893c` |
| `src/ctx_runtime_tree_stage3_clone.erl` | `ea8a3e94d69a83999df1728fb9a57c3daef51f2caa986400cf202f80807d223f` |
| `src/ctx_runtime_tree_stage3_runner.erl` | `8490b39a4c6db5cb7e0f7dbc8176989956272154bdd6fb87b0cabb9de565eedb` |
| `src/ctx_runtime_tree_stage3_sup.erl` | `048aeaddc4397f134801ee5471d9584d9e74aa846316c34beeaafb49f82a7cf6` |
| `test/ctx_runtime_tree_stage3_tests.erl` | `7ab6e8d655da63a4b2ea36617655a520829057c444ac5487d64c93b15ad27faa` |

Compilation used `compile:file(File, [binary, report_errors, report_warnings])` and `code:load_binary/3`. Isolated checks used a fresh non-distributed BEAM; live checks hot-loaded only these five source modules into the POC node. No `.beam` or test-state file was created in the project.

## RED and GREEN evidence

| Test | RED observed before implementation | GREEN evidence |
|---|---|---|
| T7 | `undef` at `ctx_runtime_tree_stage3_sup:start_link/0` | `T7_GREEN ok`; full isolated set later reported `t7=pass` |
| T8 | `EXPECTED_T8_RED`, `undef` at `ctx_runtime_tree_stage3_runner:run_t8/0` | `T8_GREEN ok`; full isolated set later reported `t8=pass` |
| T9 | `EXPECTED_T9_RED`, `undef` at `ctx_runtime_tree_stage3_runner:run_t9/0` | First green attempt failed because `delete_child` returned `{error,not_found}` after OTP had already removed a terminated temporary child. This failure is preserved. Cleanup handling was minimally revised to accept that lifecycle; the next run reported `T9_GREEN ok`, and the full isolated set reported `t9=pass`. |

The full isolated command loaded the six source/test modules from binary compilation and invoked `run_t7/0`, `run_t8/0`, and `run_t9/0`; it returned:

```text
STAGE3_ISOLATED_GREEN t7=pass t8=pass t9=pass
```

## Live topology

The temporary experimental subtree ran concurrently with the pre-existing POC supervisor:

```text
ctx_sup (pre-existing governing POC)
└── ctx_runtime_tree_stage3_sup        <10012.384.0>
    ├── interlocutor                   <10012.385.0>
    ├── planner                        <10012.386.0>
    └── runner                         <10012.387.0>
        └── T9 temporary clone         supervised only during T9
```

The same three persistent Stage 3 child PIDs were present before and after T7–T9. The T9 clone was terminated and already removed under its `temporary` restart policy before the final topology query.

## T7 result — proximal event wins while planner remains pending

Observed structural sequence:

```text
planner assigned at graph v0
-> planner remains pending
-> user event commits focal graph v1
-> focal projection exposes that user event
-> planner returns v0 proposal
-> proposal stored provisional with no governing effect
```

All six comparison gates passed: the user event was processed while the planner was pending; focus advanced before plan return; the artifact remained provisional and non-canonical; focal state was exactly unchanged by storing it; source version 0 remained attached; and the new user event remained proximal.

- Semantic disposition: **PASS for this typed structural fixture**, zero focal contamination and zero unauthorized canonization; stakeholder appraisal remains required.
- Operational disposition: **PASS**, four live actors, four typed receipts, 5 µs observed focal handling and 83 µs total live fixture time, no external effect.
- Live evidence-term SHA-256: `22C0844E6E87CC915E3C453CA096E942D66992C8C68F6D0EF0F97422050F3245`.

## T8 result — existence is not promotion

A focal user event created graph v1. Two background artifacts then used exactly the same text. The first retained source graph v0 and was marked stale when `promote` was requested. The second retained source graph v1 and entered the focal relation set only after the explicit test-internal promotion event, producing graph v2. Both artifacts retained background provenance and remained non-canonical.

All six gates passed: no focal change from production alone; stale proposal blocked; current proposal explicitly promoted; identical lexical surface confirmed; provenance preserved; and no canonization.

- Semantic disposition: **PASS for the typed freshness/isolation fixture**, one promoted supporting relation, one stale artifact, zero pre-promotion contamination and zero canonization; correctness/relevance and stakeholder acceptance are not claimed.
- Operational disposition: **PASS**, four actors, nine typed receipts, graph head 2, 94 µs observed live, no external effect.
- Live evidence-term SHA-256: `DD446627796B3C8DF56D1DD05C2C7DF2B48F6A55979666E47070192DA85C1D14`.

## T9 result — supervised clone and provisional conflict

The source snapshot began at graph version 7. A temporary supervised clone acknowledged the source snapshot ID, starting version, and SHA-256 digest, then changed relation R only inside its state. The governing source retained exact term/digest equality through that clone path. The source was independently advanced to graph version 8 with a different value. An unreviewed merge was blocked. Review produced a provisional unresolved conflict containing base, source-head, and clone-head values; review returned the source term unchanged. A deliberately unsafe last-writer-wins counterfactual demonstrated the value that would have contaminated the source but was never applied.

All eight gates passed: source isolation, ancestry, confined divergence, merge gate, provisional conflict, review isolation, temporary-child cleanup, and unsafe-counterfactual discrimination.

- Semantic disposition: **PASS for the immutable-source/typed-delta fixture**, one visible unresolved conflict, zero source contamination, silent merge, or canonization; no general merge algorithm or distributed consensus is claimed.
- Operational disposition: **PASS**, clone process terminated and child absent, four actors after cleanup, 15,937 µs observed live, no external effect.
- Live evidence-term SHA-256: `0021D461C0097A245673C02DF6644B36218D247F65B774A20788969F667D40A2`.

## Cleanup and unchanged-state evidence

The live subtree termination returned `ok`; deletion returned `{error,not_found}` because its temporary child specification was already removed. The Stage 3 supervisor, interlocutor, planner, and runner names all returned `undefined`. Every hot-loaded Stage 3 module returned `true` from `code:delete/1`; the following `code:purge/1` returned `false`, consistent with no lingering old-code generation.

The pre-existing manager status term was exactly equal immediately before and after the run:

```text
before SHA-256 68E7467E005070E2F364D2F2FB3DDCB542845B29C9A80ABC1D56BA9A67B3D6A5
after  SHA-256 68E7467E005070E2F364D2F2FB3DDCB542845B29C9A80ABC1D56BA9A67B3D6A5
```

Persistent governing-state hashes also remained the established values:

```text
_live_state/journal.dets   317f80e691cbb2c21d93c5407d5caacfa148f2b25071eccc5a926a3e3886eb12
_live_state/snapshot.term  c0e695ba618efe54f2ad053aace6e4f5fc141e38bd03ae31b6034d67b85f1b0f
```

## Explicit non-claims and remaining limitations

- Typed meanings, pointers, freshness versions, source events, and appraisal outcomes were supplied by deterministic fixtures; there is no natural-language semantic interpreter.
- T7 proves bounded message/process ordering, not subjective attention, planner correctness, scheduler optimality, or live model-client context injection.
- T8 promotion is internal fixture authority. It does not establish stakeholder approval, truth, safety, permission to execute, or a production authority gate.
- T9’s copy boundary is immutable Erlang terms held by separate processes. It does not establish durable snapshotting, database isolation, distributed consensus, CRDT behavior, or a merge algorithm.
- Timings are single-run observations, not benchmarks.
- The runtime generated its own structural evidence; this is not independent assurance or stakeholder acceptance.
- No external provider, OS action, Knowledge Base query, canonical symbol, or subjective-experience claim participated.

Future implementation steps must re-ground in the relevant original user trajectory and current corrections before their oracle or behavior is committed.
