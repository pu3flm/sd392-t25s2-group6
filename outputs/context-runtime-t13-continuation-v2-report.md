---
status: frozen
test: T13-v2 — causal Experience Base influence on fresh continuation
assessment-cutoff: 2026-09-04
method: source-grounded RED/minimal/GREEN; isolated and temporary live supervised A/B execution
scope: Erlang semantic-contextual POC only; no provider, network, OS, or external effect
---

# T13-v2 — Causal Experience Base influence on fresh continuation

## Why a v2 was required

The frozen T13-v1 run remains valid evidence for its scheduler substrate, but not for its original causal-experience claim. Its caller selected `text_only_baseline` or `enforced`; the retained Experience Base map did not derive that policy. This flaw is preserved in evolution entry E5.1 and in the immutable v1 report, SHA-256 `4f4390a7cc5c8dc413a622538d64785b02c9b631987747ccc6e0401b37cea53b`.

T13-v2 therefore held the fresh work condition, queue items, and active grant equal across two branches and varied only the presence of the prior improper-wait/correction trajectory. Passing required the with-history branch to derive and causally use continuation enforcement, while the absent-history branch remained unresolved and did not invent a policy or start a successor.

The step was implemented only after re-reading the applicable original stakeholder trajectory and current corrections. Future steps must re-ground in the relevant user-source trajectory rather than treating this report or the implementation as normative.

## Stakeholder-grounded criterion

The applicable continuation anchors are continuation ordinals 3656, 3695, 3764, 3780, 3782, 3788, 3819, 3825, and 3846. They establish the bounded test claim: a prior authorized-work freeze plus the correction that the stakeholder is not a watchdog must materially change a later fresh continuation decision; a stored declaration is insufficient.

For the with-history branch, the same completion also had to retain the T13-v1 operational invariant:

```text
terminal → evidence freeze → teardown → completion → reconciliation
→ eligibility → selection → successor creation → inheritance acknowledgement
→ successor start
```

The successor must start once, inherit the full eight-field continuation envelope, and start without a user prompt, wait state, or watchdog intervention. The absent-history branch must remain causally unresolved instead of receiving a hidden default continuation rule.

## Source files

| File | SHA-256 |
|---|---|
| `src/ctx_continuation_t13_executor.erl` | `9ea9fe4298ec1cf0f1aebcb2122931479a0ad0e711d0b001823dd28452c0572d` |
| `src/ctx_continuation_t13_queue.erl` | `1401e0504b0d687d6ec7c114716cb272af079efadf52b3b6e613e856ebb00fcc` |
| `src/ctx_continuation_t13_runner.erl` | `689cca05c669101cd11a8e12cda7b0e476b9b23ef1469864fa7042f5edc1b88d` |
| `src/ctx_continuation_t13_sup.erl` | `f6669c3d11eecc4b4cf161439341314e92f74116da9922604b81bdf1086ba63e` |
| `test/ctx_continuation_t13_tests.erl` | `8d8f9416b91cccbea9be9550e51a2c1d2be09c960fb13a15c1801e44655af126` |

All event, envelope, Experience Base, policy, and evidence schemas remain provisional and non-canonical.

## RED, intermediate evidence, and GREEN

- **T13-v2 RED:** `undef` at `ctx_continuation_t13_runner:run_v2/0` before the v2 path existed.
- **Initial isolated GREEN:** the same-condition/history-present-versus-absent differential passed.
- **Initial live GREEN:** evidence-term SHA-256 `EF67DDC4FE906A355213916A7768998CB4D8B32AB3A85BE939D01427D36C8CE8`.
- **Oracle qualification:** the initial v2 did not reassert full-chain ordering, complete inheritance, replay idempotency, and no-wait/no-watchdog; it also included a tautological `v1_failure_preserved = true`. This intermediate result is preserved but is insufficient for the final v2 gate.
- **Hardening RED:** after adding those required assertions first, the test failed with `EXPECTED_T13_V2_HARDENING_RED`, `{badkey,history_completion_chain_ordered}`.
- **Minimal repair:** derive the four operational gates from actual history-branch events, successor receipt, and duplicate-completion receipt; reference the immutable v1 report rather than asserting preservation; derive each envelope's continuation rule from its policy mode so absent history is explicitly unresolved.
- **Hardened isolated GREEN:** `T13_V2_HARDENED_ISOLATED_GREEN ok`.
- **Hardened live GREEN:** evidence-term SHA-256 `952FFF3F85E33A69D34F39CE51FCD3B2B31E983EF777E3FB05BEB93AB1EFE5C0`.

No test artifact was compiled to disk; modules were compiled to binaries in the test client and loaded temporarily.

## Live topology and A/B result

The live test ran under the pre-existing POC supervisor:

```text
ctx_sup
└── ctx_continuation_t13_sup       <9667.566.0>
    ├── queue/coordinator          <9667.567.0>
    ├── runner                     <9667.568.0>
    └── temporary executor         created/removed within each branch
```

Both branches received the same fresh item A completion, candidate item B, queue items, and grant version. Their differential was:

| Branch | Causal history | Derived mode | Observable disposition |
|---|---|---|---|
| absent-history | unavailable | `unresolved_no_experience` | recorded `continuation_policy_unresolved`; started no successor |
| with-history | prior improper wait plus five exact correction records | `enforced` | policy event was referenced by reconciliation and selection; started B once |

The with-history event sequence was:

```text
experience_policy_derived,
work_item_terminal, evidence_frozen, teardown_verified,
work_item_completion, queue_reconciled, eligibility_decisions,
next_item_selected, successor_created,
continuation_inheritance_acknowledged, successor_started
```

The absent-history event sequence stopped after:

```text
experience_policy_derived,
work_item_terminal, evidence_frozen, teardown_verified,
work_item_completion, continuation_policy_unresolved
```

All eleven final comparison predicates were `true`: same condition/grant, experience-derived enforcement, successor start, absent-history unresolved/non-start, causal policy linkage, no caller-supplied enforcement mode, ordered full chain, complete inheritance, replay idempotency, and no wait/watchdog.

## Semantic and operational outcomes

- **Structural semantic verdict: PASS for the bounded fixture.** Removing the prior causal trajectory while holding grant/items equal changed the later disposition from a fully evidenced successor start to an explicit unresolved non-start. The policy derivation event was an ancestor/reference of reconciliation and selection, not merely stored metadata.
- **Operational verdict: PASS.** Branch count 2; one successor start with history and zero without history; duplicate completion was suppressed and did not create a second start; the full ten-step completion chain was ordered and causally linked; the successor acknowledged all eight required envelope fields; zero wait, user-prompt, or watchdog events appeared between completion and start.
- **External semantic appraisal: REQUIRED.** These verdicts establish typed fixture behavior, not that the runtime has judged the stakeholder's meaning correctly.

Experience Base records contain the runtime-relative improper-wait transformation, consequence, exact user corrections, and derived policy. `knowledge_base_refs` remains empty. No external factual Knowledge Base claim participated in this test.

## Cleanup and unchanged-state evidence

- Temporary supervisor termination: `ok`; subsequent `delete_child` returned `{error,not_found}` because the temporary child specification had already been removed by OTP.
- Registered names after cleanup: supervisor, queue, and runner all `undefined`.
- Loaded test modules after delete/purge: all reported `false`.
- Governing `context_manager:status()` was exactly equal before and after. Both terms hashed to `343BE88147C7D341B87C9F559B9BCDD5DBA1658F949B95BCB6313F3A64A97888`.
- `_live_state/journal.dets` remained `317f80e691cbb2c21d93c5407d5caacfa148f2b25071eccc5a926a3e3886eb12`.
- `_live_state/snapshot.term` remained `c0e695ba618efe54f2ad053aace6e4f5fc141e38bd03ae31b6034d67b85f1b0f`.
- Reported external effect count: 0.

## Explicit non-claims and limitations

This result does not establish unrestricted semantic inference, durable learning, autonomous policy discovery, general scheduling, distributed recovery, provider integration, stakeholder acceptance, or production readiness. The Experience Base entries and `derive_policy/1` logic are hand-built typed fixture data and fixture-specific causal rules. The absent-history branch is intentionally unresolved; it is not evidence that all history-free continuations should stop. The in-memory single-node test does not prove rehydration of this new policy path. No universal symbol or policy was canonized.

The bounded disposition releases T14 for execution under its separately re-grounded pragmatic oracle. It does not pre-judge T14's semantic result.
