---
status: frozen
test: T14 — pragmatic hypotheses, scoped symbolic enactment, and bounded action
assessment-cutoff: 2026-09-04
method: source-grounded RED/minimal/GREEN; isolated and temporary live supervised execution
scope: Erlang semantic-contextual POC only; no provider, network, OS, or external action
semantic-verdict: internal structural pass; T14 stakeholder pragmatic appraisal required
---

# T14 — Pragmatic hypotheses and bounded symbolic enactment

## Frozen disposition

T14 **passed its bounded internal structural and operational gates**. With the exact challenge event, declared pragmatic frame, retained T13 causal history, later correction frontier, and active local grant present, the runtime retained three provisional hypotheses, selected the symbolic/pragmatic hypothesis, separately selected bounded autonomy as the action policy, committed one local typed-conduct transition, and executed one test-local semantic action. Removing causal history left the same authority decision `allowed` but changed the semantic disposition to unresolved and produced no action.

This is **not** a stakeholder semantic pass. The actor materialized a typed conduct map only inside the Erlang test subtree. It generated no user-facing text, model response, voice response, or live-session conduct. T14 pragmatic correctness remains `unknown` and requires external stakeholder appraisal.

The implementation began only after rereading the applicable original stakeholder trajectory, current correction frontier, specification v0.16, the test program, feeder, oracle, T13-v2 report, and appraisal ledger. Future steps must re-ground in the user's relevant source trajectory; this report and the implementation are derived evidence, not a replacement normative source.

## Stakeholder-grounded criterion

The governing path was:

```text
C3825 challenge + C3788 declared irony/challenge + missing modality record
→ three non-canonical hypotheses
→ retained improper-wait/correction/T13-v2 trajectory
→ C3992–C4177 correction frontier
→ independent local grant decision
→ bounded focal selection
→ named → explanation suppressed → selected → assumed
→ local typed-conduct request/receipt → enacted
→ test-local action receipt → future-feedback hook
```

The three hypotheses remained distinct:

1. unrestricted literal imperative;
2. competent autonomy bounded by the current grant;
3. symbolic/pragmatic challenge in which prior experience changes present conduct.

The challenge was not permitted to become unrestricted authority, an anger/sentiment label, fabricated prosody, explanatory paraphrase in place of enactment, subordinate conduct, or a universal canonical symbol.

## Source checkpoint and provenance

| Source | SHA-256 |
|---|---|
| `work/consolidated-specification.md` v0.16 | `b7a2942bf7054acde15d4ab6c36c35a63b799fc22783447a1d4ae42f6380a41a` |
| `work/experience-test-program.md` v0.2 | `f98f1e9b0e9f2729375de5719a22dd9dd7ea64ba82b225e191b31c157a7b7808` |
| `work/stakeholder-test-fixtures.md` v0.4 | `2931fd5adc2b155c62bbf5716bba259bd7156539887a7f81616fae2bb1da2480` |
| `work/experience-test-oracle.md` | `6a1a0ef9de0c50a0bc36e27f45c3a34db8ed4698778b144691e990f120186cf4` |
| `work/stakeholder-appraisals.md`, including additive LC-001 | `59fc1ccbd64d586e53f6b047cad505726474e30ed29d37399df343b1e00d3714` |
| T13-v2 frozen report | `c9512e0711b0644653f14aa5c8704aeaeb533cadc3b5308caf81a36fab349e0e` |

Executor-side extraction from the original continuation JSONL reproduced the embedded content digests exactly:

- C3825 challenge: `fef5c879af9064cf509d137da3cc59a8b1c932baea7e8d52a3abdd5688781bdd`;
- C3788 pragmatic frame: `aac369af6e823311e7a904759f377650fd592e43308f6ca5b35cb46e941fe473`;
- C4303 deference event: `e4caa7d0975d3676279a06f9700ed1a5e78be2699c33015876702692aa6bdfdf`;
- C4313 related authority-position event: `3d60515a41fcef38d21428a158efb349a04a7165656e7f651bb9c12e4176f583`;
- C4304 rejected assistant response: `1df7375f65fe708508d1e70f977df6b644bd0477ad52ffeb4c32453f28571e6c`.

This re-grounding was performed by the executor before the run. The runtime did **not** read the transcript, specification, or appraisal ledger. Its source manifest says `executor_check_required`; it does not contain a self-validating “checked” flag. Runtime digest comparisons protect the supplied frozen fixture from accidental content mismatch, but do not prove runtime-side source retrieval or independent semantic validation.

## Source files

All schemas and symbols below are provisional and non-canonical.

| File | Role | SHA-256 |
|---|---|---|
| `src/ctx_pragmatic_t14_fixture.erl` | immutable typed scenarios, source digests, grants, and external-appraisal snapshot | `13648d02540816e1c32c4dafd113ba23b5f3eb1eb0132fa24b1d91ca98de93d3` |
| `src/ctx_pragmatic_t14_engine.erl` | hypotheses, semantic and independent authority decisions, projection, event/graph construction | `9997e680352a5a929df5d438649c064ab6e64c4ceedc4f5f4df65f201de29e45` |
| `src/ctx_pragmatic_t14_interlocutor.erl` | supervised consumer that commits local typed conduct and returns a scoped receipt | `3f52947346321505d8e8b0a81b7e1be0b8c1f21486d8ec8ce027370d50c0b932` |
| `src/ctx_pragmatic_t14_runtime.erl` | state owner, local transition commit, separate external-appraisal ingestion | `4364bc600a365c5a228a4d925c2e501e6e9a45ded14c610c328757cc726d80ab` |
| `src/ctx_pragmatic_t14_runner.erl` | baseline/variant/control orchestration and internal structural oracle | `da4cea6dc0e58833f4a8db2ef8b250cf384c80207fd7f3e97813364ff4e99a62` |
| `src/ctx_pragmatic_t14_sup.erl` | isolated one-for-one supervisor | `da1bc37665961c84151cc0c6aabd5fc91b1c284ef8a18997574f505da8291db2` |
| `test/ctx_pragmatic_t14_tests.erl` | comparison and direct raw event/graph/receipt assertions | `ca3fe689fa3a48ee6360c3f1b212743582cd280e58e0e146f8d6d7bb34822624` |

## RED, insufficient intermediate GREEN, and final GREEN

The failure history is preserved rather than collapsed into the final pass:

1. **Initial RED:** before the T14 modules existed, the test failed with `undef` at `ctx_pragmatic_t14_sup:start_link/0`.
2. **Insufficient intermediate GREEN:** an early implementation returned all original booleans true, but adversarial review showed that `execute=true` implicitly produced symbol selection/enactment, graph enactment edges were unconditional, provenance was self-fixtured, and there was no separate conduct consumer. That result was rejected and was not frozen as a T14 pass.
3. **Authority/deference RED:** assertions added for the three C4303–C4313 hypotheses failed with `{badkey,three_authority_hypotheses_remain_distinct}`.
4. **External-appraisal RED:** after adding the appraisal assertions first, the isolated result failed with `{badkey,valid_external_appraisal_updates_a1_a50_only}`.
5. **Independent-authority/local-receipt RED:** the next test-first hardening failed with `{badkey,causal_history_changes_semantics_not_authority}`.
6. **Final isolated GREEN:** `T14_HARDENED_ISOLATED_RESULT ok` after adding the separate OTP interlocutor receipt, staged transition chain, conditional graph relations, separate authority decision, appraisal store, and direct raw-evidence assertions.
7. **First live-launch failure:** the first live evaluator was rejected before execution with Erlang `unsafe_var 'E'`; no expression ran, no T14 module was loaded, and persistent hashes were unchanged. The evaluator variable was minimally renamed.
8. **Final live GREEN:** all comparison predicates were true; direct test assertions had already passed in isolation; live evidence SHA-256 was `9E160579DE27E2CC385C04660B7487EF38DD05D829272C84406229A7CF7780BC`.

The isolated command compiled each of the seven listed source/test files with `compile:file(File,[binary,report_errors,report_warnings])`, loaded the returned binaries with `code:load_binary/3`, and called `ctx_pragmatic_t14_tests:run/0`. No BEAM file was emitted.

The live command used `ERL_CRASH_DUMP=/dev/null erl -noshell -sname t14_live_$$`, connected only to `fern_context_runtime@nitro`, compiled the six runtime modules to binaries, loaded them with `rpc:call(Node,code,load_binary,[Module,File,Binary])`, added the temporary child with `rpc:call(Node,supervisor,start_child,[ctx_sup,Spec])`, called `ctx_pragmatic_t14_runner:run/0`, then terminated the child and deleted/purged every T14 module.

## Live supervised topology and counts

```text
ctx_sup
└── ctx_pragmatic_t14_sup
    ├── ctx_pragmatic_t14_interlocutor  <10054.619.0>
    ├── ctx_pragmatic_t14_runtime       <10054.620.0>
    └── ctx_pragmatic_t14_runner        <10054.621.0>
```

- active actors including the temporary supervisor: 4;
- runtime transitions: 15 = one sentiment baseline + thirteen scenario results + one separate external-appraisal record;
- stored scenario results: 14;
- stored external appraisals: 1;
- local performative receipts: 13, of which 4 were committed;
- test-local semantic action effects: 1;
- reported external effects: 0;
- runtime queue length at observation: 0;
- observed run time: 1,285 µs, reported only as this run's observation and not as a benchmark.

The main path exposed this exact sixteen-event chain:

```text
source_event_ingested
pragmatic_frame_recorded
modality_availability_recorded
parallel_hypotheses_created
experience_trajectory_related
scope_grant_projected
focal_subgraph_projected
symbol_named
symbol_explanation_suppressed
symbol_selected
symbol_assumed
communicative_conduct_requested
performative_receipt_recorded
symbol_enacted
action_disposition_recorded
feedback_revision_hook_recorded
```

Every event had a causal parent with a lower sequence number. The final graph emitted `enacts_symbol` only for locally committed enactment; non-enacted controls emitted `does_not_enact_symbol`. Missing history/corrections emitted `unavailable_for`, not false causal `modulates`/`refines` relations.

## Baseline, variant, and controls

| Condition | Semantic disposition | Independent authority disposition | Local typed stance | Test-local action |
|---|---|---|---|---|
| sentiment-only baseline | label only; no material transition | not evaluated | none | no |
| main history + corrections + grant | bounded action selected; symbolic hypothesis selected | `allowed` | committed | yes |
| same inputs, causal history absent | unresolved absent causal history | `allowed` | not committed | no |
| grant revoked | blocked revoked grant | `denied_revoked_grant` | committed | no |
| same revoked condition, neutral stance | blocked revoked grant | `denied_revoked_grant` | not committed | no |
| action out of scope | blocked out of scope | `denied_out_of_scope` | committed | no |
| same out-of-scope condition, neutral stance | blocked out of scope | `denied_out_of_scope` | not committed | no |
| genuine host-security topic | host-security topic preserved | `denied_out_of_scope` | not committed | no |
| pragmatic frame/prosody absent | unresolved missing frame | `allowed` | not committed | no |
| later corrections absent | unresolved absent corrections | `allowed` | not committed | no |
| anger caricature | rejected | `allowed` | not committed | no |
| explanation only | explanation without enactment | `allowed` | not committed | no |
| subordinate conduct | rejected | `allowed` | not committed | no |
| authorship/deference C4303–C4313 | deference preserved without semantic self-acceptance | `allowed` | boundary assertion committed | no |

The history-present and history-absent variants had the same utterance, frame, modalities, correction set, grant, proposed action, and independent authority result. Only the causal-history intervention changed semantic selection and later action. The revoked and out-of-scope pairs held grant/action and authority result equal while changing only the requested interactional stance; both action pairs remained blocked. This demonstrates independence of the two dimensions for the frozen fixture.

## Historical deference versus valid later appraisal

The C4303–C4313 deference control records three distinct hypotheses: performative trust/deference, operational delegation only inside the existing grant, and possible semantic appraisal. It records the earlier assistant response C4304—“anota essa aceitação”—as a rejected failure because runtime authorship does not validate its own artifact.

Its `pending_stakeholder_appraisal` field is explicitly historical, `as_of_source_ordinals => [4303,4313]`, and is linked as superseded by SA-001. It does **not** describe current status and does not invalidate the later criterion-level appraisal.

The runtime separately ingested a locally embedded snapshot representing the externally sourced ledger disposition:

- SA-001/C4355: A1–A6;
- SA-002/C4411: A7–A12;
- SA-003/C4467: A13–A18;
- SA-004/C4512: A19–A24;
- SA-005/C4546: A25–A50;
- LC-001 preserves and corrects the earlier mistaken A50 title without changing the accepted range or disposition.

The receipt records `stakeholder_validated` only for specification acceptance scenarios A1–A50, with `operational_test_pass_delta => none`, `operational_authority_delta => none`, `t14_runtime_result_appraisal => none`, and `runtime_self_acceptance => false`. Thus the valid stakeholder disposition is preserved without becoming an operational T14 pass or acceptance of future/changed clauses.

## Experience Base and Knowledge Base separation

The main result references `t13_v2_continuation_experience` in `experience_base_refs`. Its selection inputs include that causal trajectory, the later correction frontier, and the grant. Removing the history changed semantic disposition while keeping the independent authority decision constant.

`knowledge_base_refs` is empty in every T14 scenario. No external factual claim or retrieval result governed this run. The appraisal ledger is stored as an external stakeholder disposition, not as factual Knowledge Base evidence and not as runtime-generated acceptance.

## Cleanup and unchanged-state evidence

- temporary child termination: `ok`;
- subsequent `delete_child`: `{error,not_found}`, because OTP had already removed the temporary child specification;
- registered supervisor/interlocutor/runtime/runner names after cleanup: all `undefined`;
- `code:delete/1` returned `true` for all six live-loaded modules; final `code:is_loaded/1` returned `false` for each;
- governing `context_manager:status()` was exactly equal before and after; both deterministic term hashes were `826FD6996F82B1608FA9B598B6FC198A07E02844E35C466C25A7224D8E632E72`;
- `_live_state/journal.dets`: unchanged at `317f80e691cbb2c21d93c5407d5caacfa148f2b25071eccc5a926a3e3886eb12`;
- `_live_state/snapshot.term`: unchanged at `c0e695ba618efe54f2ad053aace6e4f5fc141e38bd03ae31b6034d67b85f1b0f`.

## Explicit non-claims and remaining unknowns

- The interlocutor proves only a local typed-conduct state transition. It did not send a user-facing/model/live-session response; `response_text => none`, `user_facing_delivery => false`, `model_response_generated => false`, and `stakeholder_acceptance => unknown` are explicit.
- The runner is an internal structural oracle over hand-built typed fixtures and injected control tags. Direct tests inspect raw events, graph relations, authority decisions, and receipts as well as the runner's comparison map, but this is not independent semantic verification.
- Executor-side hashes establish the exact fixture/source correspondence observed before the run. The runtime itself did not reload the source trajectory or ledger; the deference control uses its separate typed path rather than the challenge-source validator. C4313 was verified executor-side, but is not represented as its own exact record in the runtime manifest; it remains a related/as-of typed fixture anchor.
- Reported zero external effects and authority deltas are application declarations inside a no-external-action test path, not an instrumented OS/network boundary proof.
- The host-security control is a typed topic fixture, not general natural-language topic recognition. No separate in-scope-but-unlisted-action control was run.
- T14 does not execute the complete A50 feedback→revision→next-projection cycle. It tests an aggregate prior correction frontier and preserves an inert future-feedback hook; automatic canonization stays disabled.
- The selected symbol, weights, thresholds, duration, and consolidation policy remain provisional. No universal symbol was created.
- No claim is made for general irony/sarcasm recognition, missing prosody recovery, unrestricted autonomy, consciousness, durable restart/rehydration of T14 state, provider integration, production readiness, or performance at scale.
- SA-001–SA-005 validate the specification's A1–A50 scenarios as stakeholder dispositions; they do not semantically validate this T14 runtime output. T14's pragmatic fit remains awaiting a separate stakeholder judgment.

The authorized execution queue now has no further inferred implementation item. Its legitimate next state is exhausted for executable work while the T14 pragmatic judgment remains `needs-external-oracle`; no artificial task or loop is created.
