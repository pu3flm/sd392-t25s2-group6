---
status: frozen historical stage result
stage: T10-T12
date: 2026-09-04
method: per-test original-source re-grounding, RED/minimal/GREEN, isolated and live supervised execution
semantic_oracle: stakeholder external to runtime
---

# Runtime Tree Stage 4 — T10 to T12

## Grounding and scope

- **T10:** original ordinals 1838 and 2636 require local regeneration after failure without losing committed runtime-tree state. Failure/restart telemetry was kept operational, not automatically turned into conceptual nodes.
- **T11:** original ordinals 1838, 2456, and 2484 require bounded experimentation without sacrificing important/focal context or allowing the POC to become the mission.
- **T12:** original ordinals 1719, 1925, 1981, 2020, 2146, and 2186 plus continuation ordinals 3459 and 3550 require correction-derived learning, parsimony, preserved error/counterexample lineage, no symbol-induced regression, and source rereading.

The program’s normative numbering was restored before T12 executed. Specification v0.15, program v0.1, and oracle/fixture documents were treated as derived indexes. The runtime did not appoint itself the final semantic oracle.

## Files

| File | SHA-256 |
|---|---|
| `src/ctx_runtime_tree_stage4_checkpoint.erl` | `7d432bd0ced593aaddde84a81f6c648f2674a1a0c5d43591b81fa7799bf3e386` |
| `src/ctx_runtime_tree_stage4_worker.erl` | `f59b422c3328dd1acfba9542a21cf4297a371fc5e3f5df50aff238bca0d9d839` |
| `src/ctx_runtime_tree_stage4_resource.erl` | `f3edfad7732fd7c47d038e78501cc9520be5dadabde4854c1ff9bca711b504c5` |
| `src/ctx_runtime_tree_stage4_learning.erl` | `f778fbc6d89e49c057e03e8502d7aec09abb5eee5c093cd1a9847c22a020e976` |
| `src/ctx_runtime_tree_stage4_runner.erl` | `81f374692479a2008b417fa861a78a3d2f76a62a93b3c12a3b39f754db3a3192` |
| `src/ctx_runtime_tree_stage4_sup.erl` | `4ac0d1d7c1b30b9637c15509f12533d683a7181570d3d3cb09ba33e64c241ccb` |
| `test/ctx_runtime_tree_stage4_tests.erl` | `7ac571cd9773bb2a2157a0873d91f20594ee773427efc88d2c9d7826cbd0dc26` |

All application schemas and meanings are provisional fixtures. Compilation remained in-memory.

## RED, implementation failures, and GREEN

| Test | Preserved sequence |
|---|---|
| T10 | RED `undef` at `ctx_runtime_tree_stage4_sup:start_link/0`; first two implementation attempts failed compilation on missing parentheses around map-update expressions; then GREEN with the expected OTP crash/supervisor reports and `T10_GREEN ok`. |
| T11 | RED `undef` at `ctx_runtime_tree_stage4_runner:run_t11/0`; first implementation attempt failed compilation because reserved atom `after` was unquoted as a map key; minimal correction; `T11_GREEN ok`. |
| T12 | RED `undef` at `ctx_runtime_tree_stage4_runner:run_t12/0`; first implementation execution failed because a lookup produced a three-tuple but matched a two-tuple; minimal pattern correction; `T12_GREEN ok`. |

The combined isolated run then returned:

```text
STAGE4_ISOLATED_GREEN t10=pass t11=pass t12=pass
```

## Live topology

```text
ctx_sup (pre-existing governing POC)
└── ctx_runtime_tree_stage4_sup          <10015.455.0>
    ├── checkpoint                       <10015.456.0>
    ├── semantic worker                  <10015.457.0> -> <10015.465.0>
    ├── resource governor                <10015.458.0>
    └── runner                           <10015.459.0>
```

Only the semantic worker restarted during T10. Checkpoint, resource governor, runner, Stage 4 supervisor, and the pre-existing POC continued.

## T10 — recovery, idempotency, and poison quarantine

The same immutable valid event was run normally, with a crash before commit, and with a crash after commit but before reply. The before-commit path replayed into one transition. The lost-reply path found the existing event digest and returned `duplicate_suppressed`; graph version and transition count stayed one. A poison fixture crashed the worker twice; its third attempt was retained in a non-governing quarantine instead of causing another restart.

All six comparison gates passed:

- before-commit replay converged to baseline;
- after-commit replay converged to baseline;
- no duplicate semantic transition;
- poison quarantined at the declared bound;
- poison absent from focal projection;
- crash/restart events did not become conceptual nodes.

Semantic disposition: **PASS for the bounded semantic checkpoint fixture**, zero duplicate transition, poison projection, or canonization. Operational disposition: **PASS**, four worker restarts total, two poison restarts, three poison attempts, five actors, 25,737 µs observed live, no external effect.

Live evidence-term SHA-256: `148DAC4FD1DE6724FB5DA7D2EE6963897302DD62F7A42083571E879700F03E5A`.

## T11 — bounded degradation with focal protection

The test-local governor accepted four provisional background artifacts and backpressured the next four. Every submission was followed by a focal projection query. The protected focal branch remained projected; a useful dormant branch reactivated with the same identity and lineage while pressure was active; a rejected branch remained historical and omitted for a stated reason. Releasing pressure moved the four accepted artifacts to snapshot-backed test history and returned the queue to zero.

All seven comparison gates passed. Observations:

```text
soft queue limit                 4 items
accepted / backpressured        4 / 4
maximum focal call              9 µs
sampled process memory          2,832 -> 8,856 -> 8,856 bytes
sampled mailbox length          0 -> 0 -> 0
```

Semantic disposition: **PASS for the declared status/protection fixture**, zero protected-state loss, unexplained deletion, or pressure canonization. Operational disposition: **PASS for the application-level soft queue**, five actors, 187 µs total observed live, no external effect.

Live evidence-term SHA-256: `F8452DFF3C0884EC5DE83E4DCAAAC2F75DD60063F668CD3DFC417457BD653DD5`.

## T12 — parsimonious provisional learning without regression

The baseline retained six redundant correction relations and deliberately relapsed on a regenerated in-scope summary. A proposed higher-order cluster was re-grounded against the original learning/parsimony events and the scoped sandbox correction. Applying it produced graph version 11 with `provisional_learning_transition`, `bounded_projection_policy`, and `canonical => false`.

The regression set contained original wording, a paraphrase, a regenerated summary, a nearby in-scope case, a real host-security case, and an unrelated-scope case. All four in-scope cases selected the scoped semantic/contextual meaning. The host-security case still selected OS-security sandboxing. The unrelated case remained unresolved. The rejected old interpretation, active correction, six compressed relations, counterexample, and historical pre-correction version 9 all remained accessible.

All eight gates passed: later selection changed, in-scope relapse blocked, out-of-scope counterexample preserved, correction lineage recoverable, historical error queryable, active projection smaller, candidate provisional, and no canonization.

```text
graph version                    10 -> 11
total projected items           34 -> 17
flat retained-state estimate    1,352 -> 3,232 bytes
variant regression projection   1 µs
```

The increased retained-state estimate is intentional evidence that parsimony here means a smaller active path with derivation retained, not deletion or less total storage.

Semantic disposition: **PASS for the typed regression fixture**, six cases, zero in-scope relapse, lost counterexample, or canonization; stakeholder appraisal remains required. Operational disposition: **PASS**, five actors, 23 µs observed live, no external effect.

Live evidence-term SHA-256: `65D7F4D411B4AA29785FD8C598D519F8A6B8B117B832F38393C2F2695B196611`.

## Cleanup and governing-state integrity

Stage 4 termination returned `ok`; deletion returned `{error,not_found}` for the already-removed temporary child specification. All five registered Stage 4 names became `undefined`; all six hot-loaded source modules were deleted with no lingering old-code generation.

The manager term was exactly equal before/after:

```text
68E7467E005070E2F364D2F2FB3DDCB542845B29C9A80ABC1D56BA9A67B3D6A5
```

Persistent state remained unchanged:

```text
_live_state/journal.dets   317f80e691cbb2c21d93c5407d5caacfa148f2b25071eccc5a926a3e3886eb12
_live_state/snapshot.term  c0e695ba618efe54f2ad053aace6e4f5fc141e38bd03ae31b6034d67b85f1b0f
```

## Explicit limitations and non-claims

- T10 uses an in-memory sibling checkpoint, not disk/service/machine recovery. It proves neither distributed exactly-once delivery nor external-effect idempotency.
- T11 enforces a logical application queue. It does not create real mailbox/RSS pressure, benchmark scheduler fairness, prove production scalability, or implement a general semantic eviction policy.
- T12 uses typed case scopes, not natural-language classification. Its provisional cluster is not universal, canonical, stakeholder-accepted, or proof of general learning/intelligence.
- Same-authority runtime receipts are not independent assurance. Single-run timings are observations, not benchmarks.
- No provider, network, OS action, external Knowledge Base query, canonical symbol, or consciousness claim participated.

T1–T12 now have preserved bounded dispositions, including the repaired normative T3. This does not imply overall stakeholder acceptance. The next authorized items are the additive completion-driven continuation test and the live pragmatic-irony challenge, each requiring fresh original-source grounding.
