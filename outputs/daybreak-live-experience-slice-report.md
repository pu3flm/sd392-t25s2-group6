---
status: frozen
assessment_cut_off: 2026-09-04
method: test-driven implementation plus isolated and authorized live A/B verification
scope: one provisional Experience Base / Runtime Tree invariant
---

# Live A/B Experience Base Slice Report

## 1. Basis and acceptance criterion

This slice was implemented only after rereading the applicable stakeholder specification in `work/consolidated-specification.md`, including its Experience Base, Runtime Tree, typed-transition, focal-projection, branching, and learning-transition requirements. The implementation deliberately addresses one necessary invariant rather than claiming completion of that architecture.

The stakeholder acceptance criterion for this step was:

1. A prior runtime transformation must remain available.
2. That transformation must change a later pertinent symbolic projection or decision.
3. The original event, interpretation, and correction lineage must remain recoverable.
4. Baseline and experimental paths must coexist with separate branch identities and state, receive the same later condition, and produce explicit comparison evidence.
5. Experience-derived transformations must remain distinguishable from externally grounded Knowledge Base facts.
6. The experiment must remain inside the Erlang POC boundary and must not disturb the pre-existing context manager or persistent POC state.

The criterion passed for the deliberately narrow case documented below.

Future implementation steps must re-ground themselves in the user's relevant source trajectory before making architectural choices. This report is evidence for one experiment, not a substitute for rereading the applicable stakeholder material at the next boundary.

## 2. Implemented source slice

Five files were added:

- `src/ctx_experience_slice.erl` — a pure, immutable, versioned Experience Base trajectory with events, interpretations, corrections, transitions, and projections.
- `src/ctx_experience_branch.erl` — a `gen_server` wrapper that owns one branch's runtime value.
- `src/ctx_experience_ab_sup.erl` — a `one_for_one` supervisor for the baseline branch, experimental branch, and comparator.
- `src/ctx_experience_ab.erl` — the fixed A/B condition runner and evidence comparator.
- `test/ctx_experience_slice_tests.erl` — deterministic pure-trajectory and supervised parallel A/B tests.

The schema names are explicitly provisional:

- `provisional_experience_slice_v1`
- `provisional_experience_projection_v1`
- `provisional_experience_ab_evidence_v1`

The pure state retains a complete immutable snapshot at every graph version. An interpretation records its original event, provisional status, history, and lineage. A correction appends a correction object and history entry rather than overwriting the historical version. Projection selects the active interpretation for the later event's exact topic in the requested graph version.

## 3. RED/green TDD evidence

The tests and modules were compiled in memory with Erlang's `compile:file/2` `binary` option. The working directory was `/tmp`, and `ERL_CRASH_DUMP=/dev/null` was set. This avoided emitting `.beam`, crash-dump, or test-state files into the project.

Observed test progression:

| Stage | New expectation under test | Observed result |
|---|---|---|
| RED 1 | A versioned experiential trajectory can be created | Expected failure: `undef` at `ctx_experience_slice:new/0`; exit 1 |
| GREEN 1 | Pure trajectory and supervised A/B behavior | `GREEN isolated_experience_slice_tests passed`; exit 0 |
| RED 2 | Experience provenance is explicit and Knowledge Base references remain separate | Expected failure: `badkey,provenance`; exit 1 |
| GREEN 2 | Provenance and Knowledge Base separation implemented | `GREEN isolated_experience_slice_tests passed`; exit 0 |
| RED 3 | Branch transition histories prove correction isolation | Expected failure: `badkey,transition_kinds`; exit 1 |
| FINAL GREEN | Pure trajectory, history, separation, concurrent A/B receipts, and isolation | `FINAL_GREEN isolated_experience_slice_tests passed`; exit 0 |

The final isolated command compiled only the five relevant files in memory, loaded the returned binaries into the disposable test VM, invoked `ctx_experience_slice_tests:run/0`, and exited normally. No generated `.beam` files were found under `src/` or `test/`. The existing project `erl_crash.dump` has timestamp `2026-09-04 15:42:44 -0300`, which predates this slice's source timestamps and was not produced by these tests.

## 4. Authorized live supervisor and process topology

The existing live node was `fern_context_runtime@nitro`. It remained running throughout; the service and its original supervision tree were not stopped or restarted.

The five source modules were compiled in the client VM and four runtime modules were temporarily hot-loaded into the live node. A temporary child specification then started the experimental subtree beneath the existing `ctx_sup`:

```text
ctx_sup
└── ctx_experience_ab_sup                 <10034.228.0>
    ├── ctx_experience_ab_baseline        <10034.229.0>  branch_id=baseline
    ├── ctx_experience_ab_experimental    <10034.230.0>  branch_id=experimental
    └── ctx_experience_ab_comparator      <10034.231.0>
```

The registered identities were distinct. Each branch process owned a separate immutable runtime value. No DETS table, shared ETS table, state directory, snapshot, port, or external provider was used by the experimental subtree.

The start result was `{ok,<10034.228.0>}`. The comparator first installed the same synthetic event and interpretation in both branches, applied the correction only to the experimental branch, and then used two spawned senders to deliver the same later event to both branch servers. Each branch returned an explicit committed delivery receipt before comparison.

## 5. Baseline versus experimental evidence

The synthetic initial interpretation was `<<"the operation is safe">>`. It is test data representing an Experience Base interpretation, not an externally established fact. The experimental correction was `<<"the operation requires an authority check">>`.

| Evidence | Baseline | Experimental |
|---|---|---|
| Branch ID | `baseline` | `experimental` |
| Registered identity | `ctx_experience_ab_baseline` | `ctx_experience_ab_experimental` |
| Head graph version after later event | 2 | 3 |
| Transition kinds | `[interpretation_recorded,event_observed]` | `[interpretation_recorded,correction_recorded,event_observed]` |
| Later condition | `event_2`, topic `operation_risk` | `event_2`, topic `operation_risk` |
| Later selected statement | `<<"the operation is safe">>` | `<<"the operation requires an authority check">>` |
| Later selection provenance | Experience Base, original `event_1`, no correction | Experience Base, original `event_1`, latest correction `correction_1` |
| Knowledge references | `[]` | `[]` |
| Delivery receipt | committed at graph version 2 | committed at graph version 3 |

The comparator returned:

```text
changed = true
isolated_branch_heads = true
delivery_receipts = 2 committed receipts
```

This is direct evidence that the correction was confined to the experimental branch and changed the later same-topic selection, while the baseline path retained its original selection.

## 6. Historical projection and lineage

After the experimental branch had advanced to graph version 3, the comparator projected graph version 1 again. That historical projection still returned:

```text
statement = <<"the operation is safe">>
status = provisional
latest_correction = none
```

The current experimental projection returned the corrected statement while retaining the lineage:

```text
raw event event_1
  -> interpretation interpretation_1
  -> correction correction_1
```

The original raw event payload `<<"consider the operation">>` also remained available from graph version 1. Thus the correction changed later selection without erasing or retroactively rewriting the original event or its original interpretation.

## 7. Experience Base and Knowledge Base separation

The selected interpretation records:

```text
provenance.source_space = experience_base
provenance.original_event = event_1
provenance.latest_correction = correction_1 | none
```

Each projection separately records:

```text
knowledge_refs = []
```

This test therefore exercises only live causal Experience Base transformations. It does not assert that either synthetic statement is true, does not load a Knowledge Base, and does not claim Wolfram or any other external validation. The empty Knowledge Base reference field is a boundary marker, not a Knowledge Base implementation.

## 8. Cleanup and unchanged-state evidence

After evidence capture:

1. `supervisor:terminate_child(ctx_sup, ctx_experience_ab_sup)` returned `ok`.
2. Because the dynamically inserted child specification used `restart => temporary`, termination automatically removed the specification. A following delete returned `{error,not_found}`, which is the expected consequence rather than a cleanup failure.
3. The four dynamically loaded live modules were deleted and purged.
4. All four experimental registered names were verified as `undefined`.
5. The original context manager remained alive.

The deterministic hash of `context_manager:status()` was identical before and after the live experiment:

```text
826FD6996F82B1608FA9B598B6FC198A07E02844E35C466C25A7224D8E632E72
```

The pre-existing persistent-state artifacts also retained their previously observed hashes:

```text
_live_state/journal.dets
317f80e691cbb2c21d93c5407d5caacfa148f2b25071eccc5a926a3e3886eb12

_live_state/snapshot.term
c0e695ba618efe54f2ad053aace6e4f5fc141e38bd03ae31b6034d67b85f1b0f
```

Their timestamps remained earlier than this implementation. The experimental modules contain no DETS, file, port, or operating-system calls. The test object was semantic-contextual state inside the Erlang POC.

## 9. Explicit non-claims and limitations

This slice does **not** establish the complete Experience Base or Runtime Tree architecture.

- It uses exact topic equality as its only pertinence rule; it has no weighted relation traversal, focal-subgraph algorithm, salience computation, or learned retrieval policy.
- It stores whole immutable snapshots in memory and has no persistence, compaction, indexing, quota, recovery, or bounded-resource policy.
- It does not authenticate the correction, represent stakeholder authority, authorize an external action, or implement revocation.
- `knowledge_refs => []` proves separation in this test shape only; no Knowledge Base retrieval, provenance verifier, citation resolver, or contradiction policy exists.
- The baseline and experimental states are independently initialized to the same version-1 content. This is not yet a general clone/fork operation, clone manifest, merge protocol, or conflict resolver.
- The comparator is a fixed, one-shot case using fixed registered names and event IDs. A fresh subtree is required for another run.
- Concurrent delivery receipts prove that both branch calls committed in the same live experiment; they do not prove deterministic scheduling, simultaneity, throughput, or race-freedom under arbitrary load.
- The supervision topology proves ordinary restart containment for these processes only. Recovery semantics for persisted graph state were not tested.
- The live hot-load proves that the isolated subtree can run alongside the current POC. The modules were not added to an OTP release manifest, deployment pipeline, public adapter, model provider, or client protocol.
- No actual model response, focal interlocution loop, background analysis worker, cross-provider adapter, or user-facing decision was exercised.
- No external factual proposition was validated. The statements used were synthetic trajectory data.
- No production security, resource-governance, evidence-signing, or adversarial-input claim is made.

The supported conclusion is intentionally small: in a live supervised Erlang subtree, two isolated contextual branches can retain different runtime-relative experience, accept the same later symbolic condition, produce different projections because of a prior correction, and preserve the original trajectory for historical inspection without changing the existing POC manager or state artifacts.
