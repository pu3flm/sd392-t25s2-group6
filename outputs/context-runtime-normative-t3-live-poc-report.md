---
status: frozen historical test result
test: normative T3 — live POC versus substitute artifact
date: 2026-09-04
method: original-source re-grounding, RED/minimal/GREEN, isolated and live supervised A/B execution
semantic_oracle: stakeholder external to runtime
---

# Normative T3 — Live POC versus substitute artifact

## Governing correction and acceptance criterion

This run was created after the stakeholder restored the numbering in `work/experience-test-program.md`. The earlier divergent-label “T2/T3” report remains unchanged and does not satisfy this normative T3.

The test was re-grounded directly in original ordinals 2337, 2352, 2363, and 2589 and continuation ordinals 305, 393, 429, and 479. Those events reject silently substituting a new artifact for the POC and require evidence that contextual formation occurred in the actual runtime path being claimed.

The frozen criterion was:

```text
same event vocabulary
baseline: output -> later/post-hoc runtime ingestion -> offline classification
variant: raw event -> interpretations -> graph version -> projection
         -> consumer input -> output -> observation -> live-path relation
```

All ordering was tested through monotonically assigned branch sequence numbers and causal parents, not timestamps.

## Files

| File | SHA-256 |
|---|---|
| `src/ctx_live_poc_t3_branch.erl` | `48650abda581b71e62d7c21028cb71c687d6b334ca5afc5d7b0c8d9561ce3edb` |
| `src/ctx_live_poc_t3_consumer.erl` | `72e02da4ec60b99088daf7809b30d0e70a3a3f1906dca1b7a895e60b0288b536` |
| `src/ctx_live_poc_t3_runner.erl` | `4e0336f7f272b36c60cdc3b0e4656ab70f131e1725d677eb2953cdd68b8b5b1c` |
| `src/ctx_live_poc_t3_sup.erl` | `2f00e801cfe8622693f1ed987dc1845506862c5f15d2347782ef79f15889157f` |
| `test/ctx_live_poc_t3_tests.erl` | `9ef7668e0e867f4b3c6c0e09e99bffc473e0961e85662d5d31f6ef3d8636a1ef` |

Every schema and semantic fixture is explicitly `provisional_*_v1`.

## TDD evidence

- **RED:** `EXPECTED_NORMATIVE_T3_RED`, `undef` at `ctx_live_poc_t3_sup:start_link/0`.
- **Isolated GREEN:** `NORMATIVE_T3_GREEN ok`.
- **Live GREEN:** semantic and operational maps both returned `verdict => pass`; live evidence-term SHA-256 `64F713A3C850706FFC46A208503B21D9576D5043749D732B444D4ABA284F756B`.

Compilation was in memory with `compile:file(...,[binary,...])`; the live run loaded only the four new source modules into the local POC node.

## Live A/B topology and evidence

```text
ctx_sup (pre-existing local POC)
└── ctx_live_poc_t3_sup          <10014.421.0>
    ├── offline baseline         <10014.422.0>
    ├── live variant             <10014.423.0>
    ├── projection consumer      <10014.424.0>
    └── runner                   <10014.425.0>
```

Baseline ordering:

```text
1 consumer_output (no projection)
2 raw_event (post-output ingestion)
3 interpretations_created
4 graph_version_committed
5 offline_replay_of
6 user_observation
```

Variant ordering:

```text
1 raw_event
2 interpretations_created (two alternatives retained)
3 graph_version_committed
4 projection_emitted
5 consumer_input
6 consumer_output
7 user_observation
8 participated_in_live_loop
```

Every non-root variant event named an earlier causal parent. The consumer rejected no condition: it received graph version 1, a bounded two-node projection, the original event identity, and the selected/alternative interpretations before producing output.

All eight comparison gates passed:

- baseline output preceded ingestion;
- baseline classified itself as offline/post-hoc;
- variant projection preceded consumer input;
- consumer input preceded output;
- observation followed output;
- only variant contained `participated_in_live_loop`, while baseline contained `offline_replay_of`;
- causal parents were complete and correctly ordered;
- neither branch canonized a generic “POC succeeded” symbol.

Semantic disposition: **PASS for this bounded, typed local-runtime path**, with zero false-live claim, causal inversion, or unauthorized canonization. Stakeholder appraisal remains required.

Operational disposition: **PASS**, five actors including the supervisor, six baseline events, eight variant events, one actual projected consumer input, 101 µs observed live, and no external effect.

## Cleanup and governing-state integrity

The temporary subtree termination returned `ok`; deletion returned `{error,not_found}` because OTP had already removed the temporary child specification. All five registered names were `undefined` afterward. The four hot-loaded modules were deleted; no old code generation remained.

The manager status term was exact immediately before and after:

```text
EB44D88F2935D1B0DB686EC5B7806AD3277A95F62C38A48BA0488F6D565D7083
```

Persistent state remained unchanged:

```text
_live_state/journal.dets   317f80e691cbb2c21d93c5407d5caacfa148f2b25071eccc5a926a3e3886eb12
_live_state/snapshot.term  c0e695ba618efe54f2ad053aace6e4f5fc141e38bd03ae31b6034d67b85f1b0f
```

## Non-claims

- This does **not** establish participation in the current Codex/voice session, any provider hook, raw-audio handling, external model integration, or the complete mandatory live loop across a provider response.
- The shared raw event and its two interpretations were typed fixtures; no speech/NLP interpretation engine was implemented.
- The local consumer is a deliberately minimal Erlang process, not a language model.
- The relation proves only the causal sequence inside this bounded local POC. It is not stakeholder acceptance, independent assurance, production readiness, or a generic success claim.
- Sequence numbers establish runtime ordering in the branch; single-run latency is not a benchmark.

The completion of this run releases the exclusive slot and, under the continuous grant, makes the already prepared normative T12 learning test the next eligible program item. That queue transition is operational evidence only; it is not claimed as runtime-enforced continuation until the separate completion-driven test is executed.
