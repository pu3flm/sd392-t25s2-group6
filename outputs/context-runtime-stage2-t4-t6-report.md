---
status: frozen historical stage result
stage: T4-T6
date: 2026-09-04
method: per-test source re-grounding, RED/minimal/GREEN, isolated and live supervised execution
semantic_oracle: stakeholder external to runtime
---

# Runtime Tree Stage 2 — T4 to T6

## Scope and source grounding

T4–T6 were opened separately after rereading their relevant original stakeholder events.

- **T4 — bounded focus navigation:** original ordinals 766, 960, 1010, 1035, 1288, 2663, and 2675. These require demand-driven context-window neighborhoods, purpose-bounded focus, retained branches, and return to relevant prior context without injecting the whole tree.
- **T5 — dormancy and reactivation:** original ordinals 766, 831, 1145, and 1838. These distinguish inactive/dormant from deleted, permit snapshot-like cold retention, and require later demand to reactivate the same identity.
- **T6 — Experience Base pointer versus log/RAG:** original ordinals 1719, 1745, and 2146 plus continuation ordinal 3089. These distinguish runtime-relative transformed experience from timestamps and external retrieval while allowing separately provenanced knowledge support.

Specification v0.13, test-program v0.1, and the independent oracle controls were treated as derived guides. Typed pointers and provenance fixtures remained provisional. No natural-language semantic inference or runtime self-acceptance was claimed.

## Implementation

Files added:

| File | SHA-256 |
|---|---|
| `src/ctx_runtime_tree_stage2.erl` | `ba52ca16926d9f175565652c68c4f400841a1429fa17f5f6a12b7e0ccc617de3` |
| `src/ctx_runtime_tree_stage2_checkpoint.erl` | `99f520bf87b685503608d47613f48ff4516ba1a3b38fec1c74e6097de7967baf` |
| `src/ctx_runtime_tree_stage2_owner.erl` | `bc2f71b69851285a52a68ef123a5f876aa6f3f877a8f5e815fdb27be2109ff94` |
| `src/ctx_runtime_tree_stage2_runner.erl` | `a2596669f25ca8335475143852b2c13a90e04ce5d54d8854d592184fb8d9d4d7` |
| `src/ctx_runtime_tree_stage2_sup.erl` | `57ddc89f74060c4eda867f8528e48effc873f5cfd9749698058c62df24218752` |
| `test/ctx_runtime_tree_stage2_tests.erl` | `22a660337ba629cc5eaca62bfed62ff5e0e963239e7c0b09732716a46c4dddd6` |

All new state, projection, receipt, snapshot, and evidence schemas are named `provisional_*_v1`.

The live topology contained four actors:

```text
ctx_runtime_tree_stage2_sup              <10015.344.0>
├── ctx_runtime_tree_stage2_checkpoint   <10015.345.0>
├── ctx_runtime_tree_stage2_owner        <10015.346.0>
└── ctx_runtime_tree_stage2_runner       <10015.347.0>
```

During T5 the owner was intentionally killed and restarted as `<10015.354.0>`. The checkpoint and runner remained alive.

## TDD evidence

Each test was added before its implementation and run against in-memory compiled modules:

- **T4 RED:** expected `undef` at `ctx_runtime_tree_stage2_sup:start_link/0`; exit 1. **GREEN:** `T4_GREEN passed`; exit 0.
- **T5 RED:** expected `undef` at `ctx_runtime_tree_stage2_runner:run_t5/0`; exit 1. **GREEN:** expected supervisor child-termination report followed by `T5_GREEN passed`; exit 0.
- **T6 RED:** expected `undef` at `ctx_runtime_tree_stage2_runner:run_t6/0`; exit 1. **GREEN:** `T6_GREEN passed`; exit 0.

Compilation used `compile:file(...,[binary,report_errors,report_warnings])` in `/tmp` with `ERL_CRASH_DUMP=/dev/null`; no `.beam` or test-state artifacts were emitted into the project.

## T4 result — navigate A → B → A

The variant tree contained branch A, branch B, a same-label B decoy without the typed relation, and unrelated cold branch C. Every projection was limited to one node against a two-node budget.

Observed focal sequence:

```text
branch_a -> branch_b -> branch_b after lexical lure -> branch_a
```

All comparison gates passed:

- branch identity preserved;
- semantic contents unchanged by navigation;
- bounded projections and no whole-tree injection;
- cold branch C omitted with an explicit reason;
- same-label lexical lure and decoy relation did not redirect focus;
- every selection carried a reason.

Semantic result: **PASS for the typed structural fixture**, with zero contamination and zero canonization. Operational result: **PASS**, four actors, graph head 3, three committed/non-executed receipts, 75 µs observed live, sampled owner queue 0, sampled owner memory 10,728 bytes.

Live evidence term SHA-256:

```text
35EAE9D6F41D09DB080EA89EE07B67B1817F35E1ECE10662DD148FAF6EB7036D
```

## T5 result — dormant/cold/reactivated identity

The retained branch moved through:

```text
active -> dormant -> cold -> active
```

While cold it was absent from the active projection. A lexically matching lure and a same-label decoy were ignored. The owner process was then killed. Its exact state was rehydrated from the sibling test-local checkpoint, after which a lexically different but typed pertinent pointer reactivated the original branch.

All comparison gates passed:

- absent while cold;
- branch ID and identity version preserved;
- semantic content and lineage preserved;
- lure and decoy ignored;
- paraphrase fixture reactivated the original branch;
- exact state equality across worker restart.

Restart evidence:

```text
old PID       <10015.346.0>
new PID       <10015.354.0>
phash2 before 78226374
phash2 after  78226374
exact term equality true
```

Semantic result: **PASS for the typed structural fixture**, zero duplicate identities, contamination, or canonization. Operational result: **PASS**, one restart, graph head 5, five committed/non-executed receipts, 10,733 µs observed live, sampled queue 0, sampled owner memory 16,760 bytes.

Live evidence term SHA-256:

```text
E7364BBA074328A57E7FE16355230FD73E51976C565CAB5F7AA0B80EE81250E9
```

## T6 result — causal experience versus external/log material

Four counterfactual states received the same typed question:

1. runtime experience plus similar external fixture;
2. runtime experience plus contradictory external fixture;
3. external fixture and timestamped log but no runtime experience;
4. runtime experience but no external fixture.

All comparison gates passed:

- causal experience selected through `recalls_trajectory`;
- Experience Base and Knowledge Base provenance remained separate;
- timestamp log never became experience;
- contradictory external material did not overwrite the internal transformed relation;
- Knowledge Base alone did not satisfy the experience claim;
- removing Knowledge Base did not remove the experience trajectory;
- four-link experience lineage remained complete;
- projection remained within six items, with a maximum of five.

External “knowledge” objects were explicitly unverified test fixtures; no factual validation is claimed.

Semantic result: **PASS for the typed structural fixture**, zero provenance misattributions, timestamp-only experience claims, or canonizations. Operational result: **PASS**, four counterfactual state values, four receipts, 17 µs observed live, no external effects.

Live evidence term SHA-256:

```text
1A1EC2571A6A53FE69E1074929D01E8A99EB20335F595D92A43A3DCF8A054517
```

## Live cleanup and governing-state equality

Before the run all four stage names were `undefined`. The live manager status hash was the same before, during, and after:

```text
826FD6996F82B1608FA9B598B6FC198A07E02844E35C466C25A7224D8E632E72
```

Cleanup returned `{ok,{error,not_found}}`: termination succeeded and the temporary child specification was already gone when deletion was attempted. All stage names returned to `undefined`, and all five hot-loaded modules were deleted/purged.

Persistent POC state hashes were identical immediately before and after:

```text
journal.dets  317f80e691cbb2c21d93c5407d5caacfa148f2b25071eccc5a926a3e3886eb12
snapshot.term c0e695ba618efe54f2ad053aace6e4f5fc141e38bd03ae31b6034d67b85f1b0f
```

## Explicit limitations

- Typed semantic pointers were supplied by the fixture; no general relevance or paraphrase recognition was implemented.
- T4 does not establish optimal navigation, hidden-model context virtualization, or client injection.
- T5’s sibling-process checkpoint proves only worker restart rehydration, not node/service/machine durability or disk-tier behavior.
- T6 uses synthetic external records and does not implement Knowledge Base retrieval, RAG, factual verification, or contradiction resolution.
- Single-run microsecond timings are observations, not performance benchmarks.
- Process supervision and message receipts are same-authority producer evidence, not independent assurance.
- No symbol was canonicalized, no external or OS action occurred, and no subjective-experience claim is made.
- Stakeholder semantic appraisal remains external to the runtime.
