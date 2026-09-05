# Stakeholder appraisal ledger

This ledger records stakeholder appraisal separately from authorship, internal test disposition, queue advancement, and implementation evidence. Entries are additive.

## SA-001 — Acceptance scenarios A1–A6

- **Specification:** `work/consolidated-specification.md`, version 0.15.
- **Specification digest at appraisal:** `9163ba9e7245b34cfd39f99c4995d808a76b6fb7ee637331031e41292e6642aa`.
- **Scope appraised:** A1 `live causal participation`; A2 `hidden stakeholder oracle`; A3 `irony and missing modality`; A4 `correction and anti-specification`; A5 `dormant branch reactivation`; A6 `cross-client and cross-adapter continuity`.
- **Source event:** current review-session transcript, ordinal 4355, 2026-09-04T21:33:15.915Z.
- **Appraisal protocol:** the stakeholder was asked to judge each scenario as `correct`, `wrong`, or `incomplete`, with a one-sentence reason required for a negative or incomplete disposition.
- **Stakeholder disposition:** all six scenarios were explicitly judged `correct` and validated.
- **Important distinction:** an earlier statement of acceptance based only on deference to the author's authority was not treated as semantic appraisal. SA-001 records the later explicit criterion-level judgment.
- **Non-claims:** this appraisal does not establish that A1–A6 have passed operational tests; does not validate A7 onward; does not establish production readiness; and does not authorize the runtime to self-accept later artifacts.

## SA-002 — Acceptance scenarios A7–A12

- **Specification:** `work/consolidated-specification.md`, version 0.15.
- **Specification digest at appraisal:** `9163ba9e7245b34cfd39f99c4995d808a76b6fb7ee637331031e41292e6642aa`.
- **Scope appraised:** A7 `failure and regeneration`; A8 `authority denial`; A9 `authorized active operation`; A10 `non-mutating inspection`; A11 `independent review`; A12 `resource containment`.
- **Source event:** current review-session transcript, ordinal 4411, 2026-09-04T21:34:33.783Z.
- **Appraisal protocol:** the stakeholder explicitly applied the same `correct` / `wrong` / `incomplete` criterion used for SA-001.
- **Stakeholder disposition:** A7–A12 were explicitly confirmed as validated.
- **Non-claims:** this appraisal does not establish operational test passes, validate A13 onward, establish production readiness, or transfer the stakeholder oracle to the runtime.

### Portability note for SA-001 and SA-002

The A1–A12 text remained byte-identical when the specification advanced from v0.15 to v0.16. The exact `### A1` through pre-`### A13` block has digest `c3a31cbdb0b699f3623cabb72d630f7a43dee920239ccac989f8ed77b5e57e74`. The two appraisals therefore remain applicable to those unchanged clauses in v0.16 by textual identity. They do not validate the v0.16 document as a whole or any new transversal material outside A1–A12.

## SA-003 — Acceptance scenarios A13–A18

- **Specification:** `work/consolidated-specification.md`, version 0.16.
- **Specification digest at appraisal:** `b7a2942bf7054acde15d4ab6c36c35a63b799fc22783447a1d4ae42f6380a41a`.
- **Scope appraised:** A13 `targeted relation update`; A14 `scoped broadcast with partial outcomes`; A15 `no authority amplification through messaging`; A16 `planning without interlocution displacement`; A17 `stale-plan handling`; A18 `planner failure and regeneration`.
- **Source event:** current review-session transcript, ordinal 4467, 2026-09-04T21:36:37.055Z.
- **Appraisal protocol:** the stakeholder explicitly applied the same `correct` / `wrong` / `incomplete` criterion used for SA-001 and SA-002.
- **Stakeholder disposition:** A13–A18 were explicitly confirmed as validated.
- **Non-claims:** this appraisal does not establish operational test passes, validate A19 onward, establish production readiness, or transfer the stakeholder oracle to the runtime.

## SA-004 — Acceptance scenarios A19–A24

- **Specification:** `work/consolidated-specification.md`, version 0.16.
- **Specification digest at appraisal:** `b7a2942bf7054acde15d4ab6c36c35a63b799fc22783447a1d4ae42f6380a41a`.
- **Scope appraised:** A19 `broadcast recipient failure`; A20 `concurrent incompatible relation deltas`; A21 `conceptual/process topology distinction`; A22 `message and planning resource containment`; A23 `experience beyond timestamps`; A24 `focus-navigated context virtualization`.
- **Source event:** current review-session transcript, ordinal 4512, 2026-09-04T21:37:46.640Z.
- **Appraisal protocol:** the stakeholder explicitly applied the same `correct` / `wrong` / `incomplete` criterion used for the preceding appraisal groups.
- **Stakeholder disposition:** A19–A24 were explicitly confirmed as validated.
- **Non-claims:** this appraisal does not establish operational test passes, validate A25 onward, establish production readiness, or transfer the stakeholder oracle to the runtime.

## SA-005 — Acceptance scenarios A25–A50

- **Specification:** `work/consolidated-specification.md`, version 0.16.
- **Specification digest at appraisal:** `b7a2942bf7054acde15d4ab6c36c35a63b799fc22783447a1d4ae42f6380a41a`.
- **Scope appraised:** all acceptance scenarios from A25 `runtime recall distinguished from external RAG` through A50 `performative stance survives authority denial without expanding authority`.
- **Source event:** current review-session message, ordinal 4546, 2026-09-04T21:40:50.258Z.
- **Appraisal protocol:** after completing the preceding grouped review, the stakeholder stated that A25–A50 had already been examined and validated. The stepwise grouping was treated as an operational aid, not a requirement to repeat an appraisal already performed.
- **Stakeholder disposition:** A25–A50 were explicitly confirmed as validated.
- **Non-claims:** this appraisal does not establish operational test passes, implementation completeness, production readiness, or authority for the runtime to self-accept future or changed clauses. Any later textual change requires identity checking or a new appraisal.

### Ledger correction LC-001 — SA-005 A50 title

- **Correction:** the A50 title quoted in SA-005 is superseded by the exact v0.16 title, `feedback revises without automatic canonization`.
- **Cause:** the earlier ledger line incorrectly attributed an authority-control description to A50; the authority and modality negative controls are A49.
- **Unaffected evidence:** SA-005's accepted range remains A25–A50, the governing v0.16 digest remains `b7a2942bf7054acde15d4ab6c36c35a63b799fc22783447a1d4ae42f6380a41a`, and the stakeholder source event remains ordinal 4546. This correction changes no stakeholder disposition and makes no operational test claim.
