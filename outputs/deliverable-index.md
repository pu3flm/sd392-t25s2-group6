# Context Runtime — deliverable integrity index

**Snapshot:** 4 September 2026  
**Scope:** user-facing files in `outputs/` and the `work/` artifacts needed to interpret them. This audit added only this index; it did not change an existing artifact, source file, state file, or service.  
**Authority rule:** original stakeholder utterances and later corrections remain normative. Specifications, fixtures, implementations, tests, reports, and this index are derived artifacts.

## Current project state

- `work/execution-queue.md` v0.4 is the current scheduler view: the authorized T1–T14 queue is exhausted. T1–T13 have bounded `passed` dispositions with their recorded qualifications; the current T13 basis is v2. T14 passed its internal structural and operational gates but remains `needs-external-oracle` for pragmatic correctness.
- `work/stakeholder-appraisals.md` records stakeholder appraisal of the **specification clauses** A1–A50. SA-001/SA-002 apply to byte-identical A1–A12 carried from v0.15 to v0.16; SA-003–SA-005 appraise A13–A50 against v0.16; LC-001 corrects the quoted A50 title without changing the disposition. These appraisals do **not** accept an implementation, operational run, report, production claim, or future textual change.
- `outputs/context-runtime-fresh-beam-verification.md` records `FULL_SUITE_OK` for the repository's exported assertion functions in a fresh, non-distributed BEAM. This is aggregate operational evidence, not stakeholder semantic acceptance, independent assurance, or production readiness.

`Frozen` below means immutable evidence for its recorded cutoff/run. `Current` means the file is the present navigation or governing derived artifact. `Superseded` means it remains evidence but must not be used as the latest disposition for the stated claim.

## User-facing output inventory

| Artifact | Purpose and provenance | Version / integrity status |
|---|---|---|
| `outputs/deliverable-index.md` | Navigation and integrity snapshot derived from the current output/work tree. | **Current and regenerable.** It records dispositions but creates none. |
| `outputs/context-runtime-specification-v0.16.md` | User-facing immutable snapshot of the current derived specification, with a provenance/appraisal-boundary header. | **Frozen/current v0.16 snapshot.** Its body is byte-identical to `work/consolidated-specification.md`; the embedded source and appraisal-ledger hashes match. Clause appraisal does not validate the whole document or implementation. |
| `outputs/before-the-project.tex` | Final English article source, synthesized from the literature ledger, documentary case, differential appraisals, specification/appraisal distinctions, and bounded runtime evidence. | **Current final source; not explicitly frozen.** SHA-256 `ac6ba5496fe11967c4d945742737551343802e8fab64814a6a369d9a446a04b8`. |
| `outputs/before-the-project.pdf` | Final compiled article derived from the current LaTeX source. | **Current final deliverable.** SHA-256 `005aebd192733229ecbf4d61b2b87c8ed2e1ac961d66284dcea214365a2dd9c6`; 22 pages and 13,767 extracted words. Two final compilations, zero undefined/duplicate/unused citations, zero overfull/underfull boxes, full visual inspection, and documentary audit `PASS`. |
| `outputs/ontologia-intencao-e-especificacao.md` | Earlier Portuguese conceptual essay on ontology, intention, specification, and anti-specification. | **Retained historical standalone.** Superseded only as the primary final-article deliverable; it is neither the normative source nor an acceptance record. |
| `outputs/daybreak-blind-erlang-report.md` | Blind, static/read-only appraisal produced without the specification or prior narrative. | **Frozen D1.** Freeze hash matches the file. |
| `outputs/daybreak-spec-guided-erlang-report.md` | Separate static/read-only appraisal against the then-current specification; it did not read D1. | **Frozen D2.** Valid for its cutoff; not a current implementation verdict. |
| `outputs/daybreak-local-runtime-feasibility.md` | Independent static feasibility analysis of a local, provider-neutral architecture. | **Frozen historical analysis.** A feasibility judgment, not implementation proof. |
| `outputs/daybreak-live-experience-slice-report.md` | T1 live A/B branch-local experience slice. | **Frozen/current for T1; passed-as-substrate-only.** No general learning or stakeholder-acceptance claim. |
| `outputs/daybreak-experience-t2-t3-report.md` | Early source-regrounded T2/T3 sandbox/experience run under a divergent numbering convention. | **Frozen historical; superseded for normative numbering.** It can support bounded T2 by semantic identity and supplement T6, but it does not satisfy normative T3. |
| `outputs/context-runtime-normative-t3-live-poc-report.md` | Reconciled normative T3 local causal path versus substitute artifact. | **Frozen/current for normative T3; passed-as-substrate-only.** It does not prove integration with this model/session/provider. |
| `outputs/context-runtime-stage2-t4-t6-report.md` | Bounded focus navigation, dormancy/reactivation, and Experience Base versus log/RAG fixtures. | **Frozen/current for T4–T6 bounded passes.** |
| `outputs/context-runtime-stage3-t7-t9-report.md` | Focal/background ordering, provisional promotion, and clone/source isolation fixtures. | **Frozen/current for T7–T9 bounded passes.** T8 promotion is test-internal, not stakeholder appraisal. |
| `outputs/context-runtime-stage4-t10-t12-report.md` | Fault recovery/idempotence, bounded degradation, and provisional learning/regression fixtures. | **Frozen/current for T10–T12 bounded passes.** Same-authority producer evidence only. |
| `outputs/context-runtime-t13-continuation-report.md` | T13-v1 completion/continuation scheduler substrate. | **Frozen and partially superseded.** Scheduler evidence remains; the claimed causal Experience Base influence failed to establish and is not current. |
| `outputs/context-runtime-t13-continuation-v2-report.md` | T13-v2 history-present/history-absent A/B with policy derived only from retained causal history. | **Frozen/current T13 basis; bounded pass.** No unrestricted learning, durability, or stakeholder-acceptance claim. |
| `outputs/context-runtime-t14-pragmatic-report.md` | T14 typed pragmatic hypotheses, separate authority decision, controls, and one test-local conduct transition. | **Frozen/current run; `needs-external-oracle`.** Internal structural/operational pass only; no user-facing/model/live-session response and no complete A50 feedback-revision cycle. |
| `outputs/context-runtime-evolution-report.md` | Cumulative, additive navigation across E1–E6, including numbering repair and the T13-v1 qualification. | **Current cumulative report.** Prior entries remain historical; later entries qualify rather than rewrite them. |
| `outputs/context-runtime-fresh-beam-verification.md` | Fresh compilation/aggregate re-execution after the queue freeze. | **Current operational verification.** The manifest digest matches current source/tests; it does not replace frozen per-run reports or T14's external oracle. |

## Governing and supporting `work/` artifacts

| Artifact(s) | Use now | Status |
|---|---|---|
| `work/consolidated-specification.md` | Derived specification and A1–A50 clause set. | **Current v0.16**, SHA-256 `b7a2942bf7054acde15d4ab6c36c35a63b799fc22783447a1d4ae42f6380a41a`; clause appraisal is recorded separately. |
| `work/stakeholder-appraisals.md` | Additive SA-001–SA-005 appraisal ledger plus LC-001. | **Current**, SHA-256 `59fc1ccbd64d586e53f6b047cad505726474e30ed29d37399df343b1e00d3714`. |
| `work/execution-queue.md` | Current test dispositions, reconciliation history, and exhaustion state. | **Current v0.4.** All named report paths exist. |
| `work/experience-test-program.md`; `work/stakeholder-test-fixtures.md`; `work/experience-test-oracle.md` | Derived program v0.2, feeder v0.4, and internal adversarial baseline. | **Current supporting controls; not normative sources or acceptance records.** |
| `work/audit-freeze.md` | D1 freeze ledger and state hashes. | **Frozen for D1, stale as a project-status index:** its statement that D2 is pending is superseded by the existing frozen D2 report. |
| `work/report-source.md`; `work/claim-ledger.md`; `work/case-evidence.md` | Research provenance and evidence-class separation used by the final article. | **Retained research inputs; not current project-status indexes.** |
| `work/research-plan.md` | Original research plan. | **Status text is stale:** it still says D2/article production are pending. Retain as planning history, not current project state. |
| `work/pdf-build/` and `work/pdf-render/` | Build, extraction, and visual-QA provenance for the article. | **Supporting internal evidence.** Intermediate previews are superseded by the promoted 22-page `outputs/before-the-project.pdf`; retain the build/render material for audit, not as a separate deliverable. |

## Hash cross-check

### Matches

- Every report hash cited by `outputs/context-runtime-evolution-report.md` matches its current frozen report file, including T1, the early T2/T3 report, Stages 2–4, normative T3, T13-v1, T13-v2, and T14.
- Exact current file hashes cited in the normative T3, Stage 2, Stage 3, Stage 4, T13-v2, and T14 source/test tables match. T14's cited v0.16 specification, program v0.2, feeder v0.4, oracle, appraisal ledger, and T13-v2 report hashes also match.
- The immutable user-facing v0.16 specification snapshot's body exactly matches `work/consolidated-specification.md`; its embedded source and appraisal-ledger hashes are correct.
- D1's frozen report hash and all four `_demo_state` / `_live_state` hashes in `work/audit-freeze.md` match current bytes. The repeated live-state hashes in later reports also match.
- T14's five cited transcript-text digests (C3788, C3825, C4303, C4304, C4313) match the corresponding current JSONL `payload.text` bytes. The A1–A12 portability digest `c3a31c…57e74` also matches the exact current block before A13.
- The fresh-BEAM source-and-test manifest digest was recomputed from the sorted GNU-style SHA-256 manifest of current `src/*.erl` and `test/*.erl`: `e956000fa4ed260c8347ad92b4687591ec57f2eec24ab1c17bee8eb4db7b66d7`, matching the verification report.

### Historical divergences, not silent corruption

- `outputs/daybreak-experience-t2-t3-report.md` binds specification v0.13 (`678efd6f…230c1`) and program v0.1 (`c93f5b60…7b6d9`). Current files are v0.16 (`b7a2942b…0a41a`) and v0.2 (`f98f1e9b…b7808`). The report labels those old versions and remains frozen.
- T13-v1 cites historical hashes for `ctx_continuation_t13_queue.erl` (`6196a8de…6f170`), `ctx_continuation_t13_runner.erl` (`e288f8da…0b13f`), and `ctx_continuation_t13_tests.erl` (`920b57c5…dbcdb`). Current v2-era bytes hash to `1401e050…0fcc`, `689cca05…1b88d`, and `8d8f9416…f126`. The v1 report itself still matches its cited frozen hash `4f4390a7…a53b`; this is expected source evolution, not a rewritten report.
- The frozen specification-guided appraisal cites a truncated then-current specification hash `f72dfd03…39d7b`; the present v0.16 file is `b7a2942b…0a41a`. Its other truncated code/state hashes still match current bytes.

### Not independently re-hashable from this tree

- Live evidence-term and `context_manager:status()` term hashes refer to transient Erlang terms, not files. The reports describe them, but no serialized `work/test-evidence/Txx/run-vNNN/` bundles exist in the current workspace, despite that path being named in the queue's reporting contract. Those term hashes therefore cannot be independently recomputed from retained files.
- The fresh-BEAM report records that an initial unavailable-EUnit attempt rewrote `erl_crash.dump`. That dump was already classified as compromised/non-authoritative; it must not be used as preserved evidence. The successful aggregate run used isolated crash-dump handling.

## Safe interpretation

The strongest supported summary is: the specification's A1–A50 clauses have a recorded stakeholder appraisal; the Erlang fixtures have bounded operational/structural results; current source/tests re-execute successfully in a fresh BEAM; and T14's actual pragmatic fit remains open to an external stakeholder oracle. None of those statements implies overall implementation acceptance, independent assurance, production readiness, or a live provider/session integration.
