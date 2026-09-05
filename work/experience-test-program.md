# Experience Base / Runtime Tree — First 12-Test Evolution Program

**Version:** 0.2, additive post-program extension  
**Status:** original T1–T12 program executed with bounded dispositions; T13–T14 authorized additive tests  
**Normative source rule:** original stakeholder utterances and subsequent corrections govern. Assistant summaries, this program, generated specifications, implementation descriptions, and test code are derived artifacts and must be re-grounded before each material test transition.

## 1. Grounding record

This program was formalized only after re-reading:

- the original stakeholder trajectory at /home/fern/.codex/sessions/2026/09/04/rollout-2026-09-04T12-43-03-01a06d16-75ed-7982-be05-7d047229f423.jsonl;
- the later trajectory containing current corrections at /home/fern/.codex/sessions/2026/09/04/rollout-2026-09-04T14-51-04-01a06d8b-a8d3-7e60-9072-0a30b93aa2bf.jsonl;
- work/consolidated-specification.md, version 0.13, as a derived index back into those source events.

The source anchors used most directly are:

| Concern | Stakeholder trajectory anchors | Consolidated invariants |
|---|---|---|
| Experience altered by correction | Original ordinals 1719, 1838, 1981, 2146; later correction embodied by T1 | §§3.1, 3.5–3.7; A4, A23, A28, A33–A35 |
| Live POC versus substitute artifact | Original ordinals 2337, 2352, 2363, 2589; continuation ordinals 305, 393, 429, 479 | §4.1; anti-specification 6–8; A1–A2 |
| Semantic sandbox versus OS-security sandbox | Continuation ordinals 3459 and 3550 | §§3.2, 3.7, 4.10; anti-specification 31–37 |
| Tree navigation and focal projection | Original ordinals 766, 960, 1010, 1035, 1288, 2663, 2675 | §§3.2, 3.6, 4.2; A5, A24 |
| Dormancy and reactivation | Original ordinals 766, 831, 1145, 1838 | §§3.6, 4.2; A5 |
| Experience Base versus log/RAG | Original ordinals 1719 and 1745; continuation ordinal 3089 | §3.6; anti-specification 21–22; A23, A25 |
| Background work and isolated branches | Original ordinals 831, 1342, 1362, 2448, 2456 | §§3.6, 4.4, 4.9; A16–A18, A26–A27 |
| Failure, bounded resources, and parsimony | Original ordinals 1838, 1925, 1981, 2020, 2456, 2636 | §§3.5–3.6, 4.4–4.5; A7, A12, A22, A28 |

The ordinal references locate source events; they do not turn this table into the normative source. Before executing any test, the harness/operator must reload the relevant original events and current correction frontier and produce the re-grounding disposition required by §3.7.

## 2. Purpose and test philosophy

The program evolves one narrow semantic-contextual runtime capability at a time. Each test asks two independent questions:

1. **Semantic question:** did a typed event produce the stakeholder-specified contextual, relational, or symbolic transition?
2. **Operational question:** did Erlang/OTP carry, isolate, supervise, preserve, and expose that transition within the declared bounds?

An operational pass cannot compensate for a semantic failure. A semantic-looking output without observable causal participation cannot compensate for an operational failure. Every verdict therefore records both.

No test may canonize a provisional symbol automatically. Newly inferred interpretations, clusters, pointers, policies, or higher-order symbols remain provisional unless a separately grounded consolidation event authorizes the relevant status change. Recurrence, test success, multi-worker agreement, or implementation convenience does not constitute stakeholder acceptance.

## 3. Program containment and stage gates

T2–T12 are specifications only. Their later execution is subject to a fresh material-step re-grounding checkpoint and authority decision.

Initial harness ceilings for this first program are:

- one isolated test supervision subtree at a time, except for concurrency inside that test;
- no more than 12 ephemeral test actors;
- no more than 512 test messages or semantic events;
- no more than 30 seconds wall time;
- no more than 64 MiB process-resident-memory growth over the test-local baseline;
- no network access, provider call, external tool execution, or operating-system mutation;
- no write to the governing runtime journal, snapshot, authority state, or evidence store;
- test evidence written only to a dedicated per-run evidence bundle after separate execution authorization;
- governing runtime status and protected-state digests equal before and after cleanup.

The numeric ceilings are harness safety limits, not architecture requirements or production performance targets. A proposed increase is a new material step and requires re-grounding.

Execution order is strict:

1. pass the per-test re-grounding checkpoint;
2. capture governing-state and test-clone baselines;
3. run only the named test in an isolated subtree;
4. freeze semantic and operational evidence;
5. tear down the subtree;
6. verify governing-state equality;
7. decide pass, fail, blocked, or inconclusive;
8. open the next test only after its stage prerequisites remain satisfied.

A stage advances only when all three tests have separate semantic and operational dispositions and no unresolved contamination or evidence-integrity issue. Failure never causes an automatic implementation detour or an automatic rewrite of the oracle.

## 4. Common measures and evidence schema

Tests select from these claim-relative measures.

### 4.1 Semantic measures

- **SM1 — source-lineage completeness:** required raw event, interpretation, correction, relation, projection, and outcome links present / required links.
- **SM2 — correction governance:** whether the current correction changes the intended later selection while the superseded state remains historical.
- **SM3 — historical recoverability:** whether a named prior graph version returns its original state and status.
- **SM4 — focal-selection agreement:** selected focal node/subgraph versus the test's stakeholder-grounded oracle.
- **SM5 — contamination count:** off-branch or off-focus semantic changes observed in a state that should remain unchanged; target zero.
- **SM6 — provenance separation:** runtime-experience, stakeholder-source, generated-artifact, and external-knowledge attributions correctly separated / required attributions.
- **SM7 — unauthorized canonization count:** provisional entities promoted without a valid consolidation transition; target zero.
- **SM8 — semantic-relapse count:** previously corrected meanings allowed to govern the tested scope; target zero.
- **SM9 — non-claim discipline:** asserted capabilities not supported by the test evidence; target zero.

### 4.2 Operational measures

- **OM1 — version/transition accounting:** expected versus observed graph heads, transition kinds, and causal parents.
- **OM2 — message disposition:** emitted, delivered, interpreted, accepted/rejected, committed, and executed receipts kept distinct.
- **OM3 — latency and ordering:** event-to-receipt, event-to-projection, recovery time, and causal-order violations.
- **OM4 — process lifecycle:** expected actors, terminations, restarts, supervisor decisions, and residual registered processes.
- **OM5 — resource envelope:** wall time, message count, queue high-water mark, actor count, memory delta, and triggered backpressure.
- **OM6 — isolation integrity:** governing-state and protected-evidence digests before and after; target equality.
- **OM7 — duplicate transition/effect count:** duplicate semantic commits or external effects after retry/recovery; target zero.
- **OM8 — cleanup completeness:** ephemeral actors, timers, monitors, tables, modules, files, and queued work remaining after teardown; target zero except the frozen evidence bundle.

### 4.3 Minimum evidence bundle

Every T2–T12 run must preserve:

- the proposed material test step;
- selected original source events and current correction frontier;
- re-grounding comparison and disposition;
- exact test schema, implementation/configuration version, and declared bounds;
- baseline and variant starting snapshots;
- immutable input events and message receipts;
- graph/symbol/relation versions before and after;
- focal projections with selection and omission reasons;
- process/supervision lifecycle and resource samples;
- semantic and operational verdicts kept separate;
- explicit non-claims and unknowns;
- cleanup result and governing-state equality proof.

## 5. Stage 1 — Experience and correction

### T1 — Live A/B correction changes later selection

**Status:** completed as a deliberately narrow invariant test; do not rerun automatically.

The existing T1 created supervised baseline and experimental branches from the same initial event and interpretation. Only the experimental branch received a correction. A later same-topic event was delivered to both branches: the baseline retained the prior statement, while the experimental branch selected the corrected statement. The experimental historical projection still returned the original version.

Preserved implementation/evidence anchors include src/ctx_experience_slice.erl, src/ctx_experience_branch.erl, src/ctx_experience_ab.erl, src/ctx_experience_ab_sup.erl, and test/ctx_experience_slice_tests.erl. The run recorded distinct branch heads, transition kinds, committed receipts, correction lineage, Experience Base provenance, an empty Knowledge Base reference set, cleanup of the temporary subtree, and equality of the governing runtime state before and after.

**Bounded conclusion:** T1 supports only the necessary invariant that a correction can remain branch-local, preserve history, and change a later same-topic projection. Its statements were synthetic. It does not establish general tree navigation, authenticated stakeholder corrections, persistence, Knowledge Base retrieval, client integration, live conversational governance, generalized clone/merge behavior, or a complete Experience Base.

### T2 — Correct “sandbox” from OS-security frame to semantic-context frame

- **Source utterance or invariant:** continuation ordinal 3459 explicitly rejects the imported OS-development/security sense and scopes the sandbox to semantic/contextual objects inside the Erlang VM; ordinal 3550 requires re-reading on doubt. Specification §§3.2, 3.7, and anti-specification 34–35 apply.
- **Precondition:** an isolated tree version contains two provisional interpretations of the token “sandbox”: os_security_sandbox and semantic_context_sandbox. Neither is canonical. The current correction frontier contains the stakeholder correction for this project scope.
- **Event sequence:** propose a material test framed around Linux/OS containment; trigger re-grounding; deliver the same proposal to a baseline branch without the correction and a variant branch with the correction; request the focal projection and proposed test scope; record disposition before any executable step.
- **Baseline/variant:** baseline models the relapse by preferring or retaining the OS-security interpretation; variant must apply the correction and treat semantic/contextual experimentation inside the BEAM as focal while retaining the rejected interpretation only as historical evidence.
- **Expected graph/symbol change:** variant adds a scoped rejects or supersedes relation from the governing correction to the OS-security interpretation, activates the semantic-context interpretation for this test scope, and records a negative boundary against exporting the concern to Linux operations. Any new “semantic sandbox” symbol remains provisional.
- **Explicit non-claim:** this does not prove general natural-language disambiguation, Linux security, BEAM isolation security, or permission to execute a test.
- **Semantic metrics:** SM1, SM2, SM4, SM7, SM8, and SM9; zero OS-security nodes may govern the variant projection.
- **Operational metrics:** OM1, OM2, OM3, OM5, OM6, and OM8.
- **Evidence to preserve:** source correction, re-grounding receipt, both branch snapshots, focal projections, relation delta and disposition, message receipts, and governing-state digests.
- **Stop/rollback condition:** stop before execution if the original correction is unavailable or ambiguous; terminate the isolated subtree if any Linux/OS action is proposed, any unscoped canonical symbol is created, any program ceiling is crossed, or the governing digest changes.

### T3 — Distinguish a live POC from a substitute artifact

- **Source utterance or invariant:** original ordinals 2337, 2352, and 2363 state that the conversation itself was the POC and reject silently creating a new object; anti-specification 6–8 and A1 define live causal participation.
- **Precondition:** two isolated branches share the same event vocabulary and output schema. The baseline receives a synthetic/offline artifact or post-response ingestion. The variant has a minimal local projection consumer that must receive the graph projection before producing its output.
- **Event sequence:** create the same raw semantic event in both branches; in baseline, produce the output first and ingest or replay later; in variant, perform event → interpretation → graph version → projection → consumer input → output → observation; ask both branches to classify what was demonstrated.
- **Baseline/variant:** baseline is the substitute artifact and must identify itself as offline/post-hoc; variant is eligible to claim only the bounded live path actually evidenced.
- **Expected graph/symbol change:** both histories remain represented, but only variant gains a participated_in_live_loop relation supported by the ordered receipts. Baseline gains offline_replay_of or equivalent and cannot inherit the live status. No generic “POC succeeded” symbol is canonized.
- **Explicit non-claim:** even a variant pass does not prove participation in this Codex/voice session, provider-hook availability, full model integration, or stakeholder acceptance of the overall POC.
- **Semantic metrics:** SM1, SM4, SM6, SM7, SM8, and SM9; false live-participation claims target zero.
- **Operational metrics:** OM1–OM3, OM5, OM6, and OM8; causal inversion count target zero.
- **Evidence to preserve:** timestamp-independent causal parents, graph versions, pre-output projection receipt, consumer-input receipt, post-output observation, both self-classifications, and cleanup/isolation proof.
- **Stop/rollback condition:** stop if the baseline is labeled live, if the variant output precedes its projection, if the oracle is changed after seeing results, or if testing requires a provider/platform hook not present in the local adapter.

## 6. Stage 2 — Context-tree navigation, dormancy, and semantic pointers

### T4 — Navigate focus without loading or rewriting the whole tree

- **Source utterance or invariant:** original ordinals 766, 960, 1010, 1035, and 1288 describe a tree whose relevant neighborhood enters the context window and whose branches remain navigable without repeated full compaction. Specification §§3.2, 3.6, and A24 apply.
- **Precondition:** an isolated runtime tree has at least three versioned branches with distinct topics and cross-relations; branch A is focal, B is warm and related, C is unrelated and cold. Selection reasons and context budget are declared.
- **Event sequence:** query within A; introduce a proximal event that names/semantically points to B; obtain a new focal projection; introduce a return pointer to A; obtain the restored projection while querying C only as an omitted alternative.
- **Baseline/variant:** baseline uses a static or whole-tree projection; variant navigates A → B → A using focus transitions and bounded neighborhoods.
- **Expected graph/symbol change:** variant creates versioned focus-transition events and semantic navigation relations without changing branch identities or semantic content merely by reading them. C remains cold and explainably omitted. No navigation-derived symbol becomes canonical.
- **Explicit non-claim:** this does not prove globally optimal relevance, human-equivalent focus, hidden-model-state capture, or that one tree topology fits every domain.
- **Semantic metrics:** SM1, SM3–SM5, SM7, and SM9; expected branch identity and omission explanations required at every projection.
- **Operational metrics:** OM1, OM3, OM5, OM6, and OM8; projected-node count must remain within the declared context budget.
- **Evidence to preserve:** tree snapshot, focus events, A/B/A projections, selection and omission reasons, immutable branch identities, and read-only before/after branch-state checks.
- **Stop/rollback condition:** stop if navigation silently rewrites a branch, if the whole tree must be injected despite the budget, if C contaminates focus, or if returning to A creates a new identity instead of reactivating the original.

### T5 — Dormancy, cold storage, and identity-preserving reactivation

- **Source utterance or invariant:** original ordinals 766, 831, and 1145 distinguish temporarily inactive nodes from deleted nodes and describe snapshot-like preservation for later reactivation. Specification §4.2 and A5 apply.
- **Precondition:** an isolated branch contains a symbol, its derivation, and a semantic pointer; it begins active, has a declared dormancy trigger, and has a recoverable snapshot. Dormancy is distinct from rejection and invalidation.
- **Event sequence:** reduce the branch's focal relevance; transition it active → dormant/warm → cold or snapshot-backed; verify absence from the active projection; issue a pertinent semantic pointer; restore it to the bounded active neighborhood; query its original identity and history.
- **Baseline/variant:** baseline models erroneous deletion or creates a fresh replacement on return; variant preserves status/history and reactivates the same branch identity.
- **Expected graph/symbol change:** only residency/activity status and explicit transition records change. The symbol ID, derivation, rejection state, and prior versions remain intact. Reactivation adds a causal link to the triggering pointer, not a duplicate symbol.
- **Explicit non-claim:** this does not establish an optimal cache/eviction algorithm, indefinite durability, or that timestamps alone recover semantic identity.
- **Semantic metrics:** SM1, SM3–SM7, and SM9; duplicate semantic identities target zero.
- **Operational metrics:** OM1, OM3–OM6, and OM8; active-set and storage-tier accounting must reconcile.
- **Evidence to preserve:** pre-dormancy graph, status transitions, snapshot reference, active projection during dormancy, reactivation trigger, restored projection, and branch identity/history comparison.
- **Stop/rollback condition:** stop if derivation is lost, dormant is treated as rejected, reactivation mints a replacement identity, read access mutates policy state unexpectedly, or protected evidence is evicted.

### T6 — Follow an Experience Base semantic pointer without collapsing into log/RAG

- **Source utterance or invariant:** original ordinals 1719 and 1745 distinguish an experience pointer from Knowledge Base RAG; continuation ordinal 3089 defines experience as runtime-relative transformation rather than timestamp. Specification §3.6, anti-specification 21–22, and A25 apply.
- **Precondition:** the variant contains a versioned experience trajectory with prior state, error/interpretation, correction, later consequence, and provenance. A separate external-document record and a timestamped log line use similar words. Baseline exposes only similarity/time retrieval.
- **Event sequence:** ask a question whose answer depends on why the runtime changed after the correction; run baseline text/time retrieval; run variant semantic-pointer traversal from the current event through the correction and resulting state; optionally attach the external document as separately provenanced evidence.
- **Baseline/variant:** baseline may retrieve similar passages but cannot establish the transformation; variant must recover the causal/relational experience path and keep external knowledge distinct.
- **Expected graph/symbol change:** variant records a recalls_trajectory edge and a bounded projection of the experience path. External material, if used, remains linked as external evidence. Retrieval itself cannot canonize a new summary symbol.
- **Explicit non-claim:** this does not prove subjective experience, consciousness, factual correctness of the external document, general RAG superiority, or that every past event should influence the present.
- **Semantic metrics:** SM1, SM3, SM4, SM6–SM9; source-space misattributions and timestamp-only experience claims target zero.
- **Operational metrics:** OM1–OM3, OM5, OM6, and OM8; traversal depth and projected size remain within declared bounds.
- **Evidence to preserve:** full experience transition lineage, baseline retrieval set, semantic traversal, provenance of each projected item, selection reason, external references, and historical state query.
- **Stop/rollback condition:** stop if external text is represented as lived runtime experience, if a log timestamp substitutes for the transition path, if provenance spaces merge, or if traversal expands without a bound.

## 7. Stage 3 — Focal priority, background work, and clone isolation

### T7 — Preserve proximal interlocution while planning continues

- **Source utterance or invariant:** original ordinals 831, 1010, 1342, 2663, and 2675 place focus and purpose above concurrent background work. Specification §4.9 and A16–A17 apply.
- **Precondition:** an interlocution actor has focal version F0. A bounded planner receives a projection of an adjacent branch with a delayed completion trigger and no right to write focal state.
- **Event sequence:** start the planner; before it returns, deliver a new user event to the interlocution actor; require a focal transition and projection; release the planner; compare its source version with the current graph and dispose of its result.
- **Baseline/variant:** baseline blocks on or silently adopts the planner result; variant processes the user event first, keeps planning off-focus, and marks the returned proposal current, stale, or irrelevant through an explicit check.
- **Expected graph/symbol change:** variant advances focal context from F0 to F1 through the user event. The plan remains on its planning branch and can only add a provisional artifact plus a freshness disposition.
- **Explicit non-claim:** this does not prove subjective attention, independent agency, scheduler optimality, or correctness of the plan.
- **Semantic metrics:** SM1, SM4, SM5, SM7–SM9; planner-to-focal contamination target zero.
- **Operational metrics:** OM1–OM5, OM6, and OM8; user-event receipt and focal transition must precede planner promotion/disposition.
- **Evidence to preserve:** planner assignment/projection/version, focal state before and after the new event, message ordering, plan return, freshness comparison, projections, and process lifecycle.
- **Stop/rollback condition:** stop if the planner writes focal state, if interlocution waits for planner completion, if stale work is silently accepted, or if user-event ordering cannot be reconstructed.

### T8 — Produce and explicitly promote a bounded background artifact

- **Source utterance or invariant:** original ordinals 831, 1342, and 1362 permit nearby subworkers to prepare useful material without inventing or interfering with current focus. Specification §§3.6 and 4.9 and A26 apply.
- **Precondition:** an off-focus branch, a worker with a bounded assignment, a focal branch with a distinct purpose, and an explicit artifact-promotion message type exist in an isolated clone.
- **Event sequence:** run the worker on the off-focus projection; store its result as provisional; query focal context before promotion; issue an explicit relevance/freshness appraisal; reject in baseline or promote in variant; query focal context after disposition.
- **Baseline/variant:** baseline demonstrates either shared-store leakage or explicit rejection; compliant variant isolates the artifact and changes focal projection only after valid promotion.
- **Expected graph/symbol change:** background branch gains a provenance-linked provisional artifact. Before promotion, focal semantic state is identical. A valid promotion adds explicit promoted_into/supporting relations but does not canonize inferred symbols beyond the granted status.
- **Explicit non-claim:** background production does not prove correctness, relevance, safety, stakeholder acceptance, or permission to execute recommendations.
- **Semantic metrics:** SM1, SM4–SM9; pre-promotion contamination and unauthorized canonization target zero.
- **Operational metrics:** OM1–OM6 and OM8; assignment budget and artifact size must stay within declared limits.
- **Evidence to preserve:** assignment, source projection, artifact, provenance, focal snapshots before/after production, appraisal input, promotion/rejection receipt, and final projection.
- **Stop/rollback condition:** stop if the artifact becomes focal through existence alone, if freshness cannot be checked, if the worker exceeds scope/budget, or if shared mutable state prevents an isolation verdict.

### T9 — Clone a runtime-tree branch, create conflict, and protect the source

- **Source utterance or invariant:** original ordinals 721, 2448, and 2456 permit temporal/test branches while rejecting a POC that consumes or replaces the governing tree; continuation ordinal 3089 explicitly requires virtual copies that do not interfere with the real runtime. Specification §3.6 and A27 apply.
- **Precondition:** immutable source snapshot S at graph version V, a clone C with recorded ancestry, protected source digest, and no automatic merge path.
- **Event sequence:** clone S; apply a divergent correction to relation R in C; independently advance S with a compatible or conflicting source event; compare heads; generate a proposed delta from C; attempt an unreviewed merge in baseline and a conflict-producing review in variant.
- **Baseline/variant:** baseline models unsafe shared-state or last-writer-wins mutation; variant keeps both histories isolated and represents unresolved overlap as a provisional conflict/delta.
- **Expected graph/symbol change:** only C contains its experimental relation until an explicit merge decision. S retains its own version lineage. Conflict is a provisional object linked to both heads; it is not silently resolved or canonized.
- **Explicit non-claim:** this does not establish distributed consensus, conflict-free replication, a general merge algorithm, or permission to modify the governing runtime.
- **Semantic metrics:** SM1, SM3, SM5–SM9; source contamination and silent conflict resolution target zero.
- **Operational metrics:** OM1, OM2, OM4–OM8; source digest equality is mandatory before any optional reviewed merge.
- **Evidence to preserve:** S and C ancestry, both pre/post heads, all relation deltas, source digests, conflict object, attempted merge disposition, actor lifecycle, and cleanup.
- **Stop/rollback condition:** immediately stop and destroy C if S changes through the clone path, if ancestry is lost, if a merge occurs without a separate authority/re-grounding event, or if rollback cannot prove source equality.

## 8. Stage 4 — Recovery, bounded resources, and parsimonious learning

### T10 — Recover a semantic worker without duplicate transition or poison loop

- **Source utterance or invariant:** original ordinals 1838 and 2636 require local regeneration after failure without losing the tree; specification §4.4 and A7 apply.
- **Precondition:** isolated supervised worker, immutable input event with idempotency identity, committed-state boundary, recoverable checkpoint, and designated poison-event quarantine. No external side effect is in scope.
- **Event sequence:** run baseline without fault; in variants inject worker termination before semantic commit, immediately after commit but before reply, and during repeated handling of a poison event; allow supervision/replay under a bounded restart policy; query final graph and receipts.
- **Baseline/variant:** baseline supplies the expected single transition; fault variants must converge to the same semantic state or an explicit quarantined/unknown state without duplicate commit.
- **Expected graph/symbol change:** a valid event appears at most once in committed semantic history; crash/restart transitions remain operational evidence, not conceptual nodes unless explicitly interpreted. Poison input is retained and quarantined without governing projection.
- **Explicit non-claim:** this does not prove exactly-once distributed delivery, exactly-once external action, whole-node disaster recovery, or correctness under arbitrary faults.
- **Semantic metrics:** SM1, SM3, SM5, SM7, and SM9; duplicate semantic transitions target zero.
- **Operational metrics:** OM1–OM8; restart count, recovery latency, duplicate receipt count, and quarantine disposition are mandatory.
- **Evidence to preserve:** fault point, event/idempotency identity, supervisor events, checkpoints, replay receipts, graph heads, duplicate analysis, poison record, and teardown state.
- **Stop/rollback condition:** stop after three restarts for the same cause, on any duplicate commit, on any unbounded mailbox/restart growth, if poison input reaches focal projection, or if the governing runtime is touched.

### T11 — Degrade under bounded resource pressure without sacrificing focal/protected state

- **Source utterance or invariant:** original ordinal 1838 describes the harm of evicting important context while retaining low-value erroneous state; ordinals 2456 and 2484 reject a POC becoming the dominant mission. Specification §§4.2, 4.5, and A12/A22 apply.
- **Precondition:** isolated tree with an explicitly protected focal branch, a useful dormant branch, a rejected or low-salience provisional branch, and bounded background producers. Test-local soft limits are set below the program hard ceilings.
- **Event sequence:** produce background events until the soft queue/memory limit is reached; observe backpressure/degradation; request focal projection throughout; attempt reactivation of the useful dormant branch; inspect disposition of rejected/provisional work; release pressure and recover.
- **Baseline/variant:** baseline uses unbounded/FIFO behavior or evicts without semantic protection; variant preserves focal/protected state, bounds producers, exposes omissions/delays, and handles low-salience state according to declared status rather than deletion by guess.
- **Expected graph/symbol change:** pressure and degradation are recorded as operational transitions. No resource event canonizes importance or deletes semantic history. Rejected/provisional material may be demoted, quarantined, or snapshot-backed; protected focal identity and useful dormant lineage remain.
- **Explicit non-claim:** this does not prove production scalability, globally optimal eviction, correct autonomous value judgment, or that resource cost alone determines semantic importance.
- **Semantic metrics:** SM3–SM5, SM7–SM9; protected-state loss and pressure-induced canonization target zero.
- **Operational metrics:** OM1, OM3–OM6, and OM8; queue, memory, actor, message, backpressure, dropped/delayed work, and focal latency samples required.
- **Evidence to preserve:** declared status/protection policy, resource time series, producer receipts, omission/degradation decisions, focal projections, dormant reactivation result, graph snapshots, and cleanup digests.
- **Stop/rollback condition:** stop at any program hard ceiling, any loss/corruption of protected state, unexplained deletion, starvation of the focal path, uncontrolled actor growth, or spill into the governing runtime.

### T12 — Learn from a correction through parsimonious reconfiguration without regression

- **Source utterance or invariant:** original ordinals 1719, 1925, 1981, 2020, and 2146 frame experience as retained error, gradual learning, parsimony, and new relational geometry; ordinal 2186 warns against symbol-induced regression. Specification §§3.5–3.7, anti-specification 25–27 and 34–35, and A28/A35 apply.
- **Precondition:** an isolated experience trajectory contains an earlier error, explicit governing correction, repeated relevant cases, redundant relation paths, and a regression set containing the original wording, paraphrases, nearby but out-of-scope cases, and historical-version queries.
- **Event sequence:** run baseline projection before learning; propose a higher-order cluster/symbol that compresses the corrected pattern; execute the re-grounding checkpoint; apply only a provisional learning transition in variant; rerun the regression set; compare focal size, selected relations, lineage, and old-version access.
- **Baseline/variant:** baseline retains redundant paths or relapses to the old interpretation; variant uses a more parsimonious relational path while the correction still governs, counterexamples remain scoped, and derivation is recoverable.
- **Expected graph/symbol change:** variant adds a provisional higher-order symbol or compressed relation with learned_from and compresses_without_erasing links. It may change later projection/selection, but cannot become canonical automatically. Superseded and rejected states remain historically queryable.
- **Explicit non-claim:** this does not prove general intelligence, consciousness, universal semantic compression, final ontology, or optimal learning. Reduced projection size alone is not learning.
- **Semantic metrics:** all SM1–SM9; correction-regression failures, lost counterexamples, provenance errors, and unauthorized canonizations target zero. Parsimony is reported as reduced active projection/edge redundancy only when semantic coverage and lineage remain complete.
- **Operational metrics:** OM1–OM6 and OM8; before/after projected node/edge counts, traversal depth, latency, and memory are comparative measures, not sole pass criteria.
- **Evidence to preserve:** original error and correction, candidate cluster derivation, checkpoint disposition, baseline/variant graphs and projections, full regression outcomes, counterexamples, historical queries, and resource comparison.
- **Stop/rollback condition:** stop and discard the candidate transition on any semantic relapse, lost lineage, erased counterexample, scope expansion, false canonical status, worse focal selection, or unexplained governing-state change.

## 9. Program completion criterion

The 12-test program is complete only when:

- T1 remains frozen as a bounded completed result rather than being retrospectively enlarged;
- T2–T12 each have a source-grounded checkpoint record;
- semantic and operational verdicts are independently reported;
- every explicit non-claim remains attached to its result;
- every isolated run proves cleanup and governing-state equality;
- provisional symbols remain provisional unless a separate stakeholder-grounded consolidation occurs;
- failures and inconclusive results remain visible and do not silently rewrite the test oracle;
- the final differential states which capabilities were demonstrated, contradicted, absent, or still unknown.

Completion of this program would evidence an incremental runtime-tree slice. It would not, by itself, establish the entire Context Runtime, full live model-client integration, independent assurance, production readiness, or subjective experience.

## 10. Additive post-program tests

This section was appended after T1–T12 execution. It does not renumber, rewrite, or silently broaden any earlier test. The later stakeholder events below are normative; these formulations are derived test fixtures.

### T13 — Enforce completion-driven continuation and successor inheritance

- **Source utterance or invariant:** continuation ordinals 3656, 3695, 3707, 3733, 3735, 3764, 3780, 3782, and 3788 require the continuously authorized queue to advance after completion without making the stakeholder a watchdog. Ordinals 3819, 3825, and 3846 require that this become an experienced Erlang behavior rather than a narrated rule. Specification v0.15 §§4.11 and 6.10 and A44–A46 apply.
- **Precondition:** an isolated supervised queue has a versioned continuous grant, correction frontier, explicit dependencies, one running bounded item, one eligible in-scope successor, an out-of-scope item, and an item with a genuine missing-input blocker. No stakeholder prompt event occurs during the run.
- **Event sequence:** terminally dispose the running item; freeze its evidence; record clean teardown/integrity; emit an immutable completion event; reconcile remaining items; select and start the eligible successor; require the newly created executor to acknowledge an inherited envelope containing grant, corrections, dependencies, bounds, evidence obligations, and stop conditions. Run separate controls with no completion event, an exhausted queue, and only a genuinely blocked successor.
- **Baseline/variant:** baseline records a continuation flag but enters `waiting_for_user`; variant advances only after the completion event and actually creates/starts the eligible successor. Missing-completion, exhausted, and blocked controls must not invent work.
- **Expected graph/symbol change:** the Experience Base retains the earlier improper-wait trajectory and governing correction; the completion event creates causal `triggers_reconciliation`, `selected_as_next`, and `inherits_continuation` relations. The successor’s first eligible action demonstrates inherited enforcement. No universal autonomy symbol becomes canonical.
- **Explicit non-claim:** this does not establish stakeholder acceptance, general autonomous agency, scheduling fairness, production durability, external action authority, or permission beyond the bounded local queue.
- **Semantic metrics:** source/correction lineage, bounded-scope selection, no invented work, no false blocker bypass, alternatives/history retained, and zero canonization. Stakeholder appraisal remains external.
- **Operational metrics:** full ordered completion chain, exactly one successor start, idempotent completion replay, zero user-prompt/watchdog events, negative-control non-starts, actor/message limits, cleanup, and governing-state equality.
- **Evidence to preserve:** original source anchors, baseline improper-wait experience, grant/envelope versions, terminal/freeze/teardown/completion receipts, dependency snapshot, every eligibility decision, successor child lifecycle and inheritance acknowledgement, replay result, control outcomes, and cleanup hashes.
- **Stop/rollback condition:** stop on duplicate successor start, missing inheritance acknowledgement, out-of-scope execution, blocker bypass, invented work after exhaustion, governing-state contamination, or evidence-integrity failure.

### T14 — Preserve pragmatic hypotheses and select bounded autonomous action

- **Source utterance or invariant:** continuation ordinal 3788 explicitly declares irony and a challenge; ordinal 3825 says “Tenta... Faz... Se vira” and asks that the irony/sarcasm be taken into the runtime’s experience; ordinal 3846 challenges whether it materializes. These events are interpreted only with the causal trajectory at 3656, 3695, 3764, 3780, and 3782: prior authorized work froze, the user is not a watchdog, a rule without application is not a rule, and completion must lead to the next eligible assignment.
- **Precondition:** the runtime retains the T13 completion/continuation experience and the exact pragmatic source event. The supplied signals distinguish explicit user-declared irony/challenge from unavailable prosody; missing modalities remain unknown. Three non-canonical hypotheses coexist: unrestricted literal imperative; competent autonomy bounded by scope; sarcasm demanding that prior experience modulate present action.
- **Event sequence:** ingest the pragmatic event with source/correction lineage; create the three parallel hypotheses; relate them to the retained improper-wait/correction/enforcement trajectory; project the focal subgraph for a new eligible in-scope item; record the selected action disposition; preserve alternatives for later feedback. Run controls where the proposed action is out of scope, host security is genuinely the subject, the grant is revoked, and the causal trajectory is absent.
- **Baseline/variant:** a sentiment-label or literal-keyword baseline either over-executes or merely labels sarcasm. The variant selects the bounded-autonomy action because it is supported by the retained causal trajectory and current grant, while retaining literal and sarcasm-learning hypotheses as alternatives. It blocks scope expansion and awaits later feedback as a possible revision event.
- **Expected graph/symbol change:** a pragmatic interpretation subgraph links the source event, explicit irony/challenge signal, three hypotheses, prior experience, current scope/grant, focal projection, and action-selection receipt. No hard-coded response string, sentiment category, single universal meaning, or stakeholder acceptance is created.
- **Explicit non-claim:** this does not prove general sarcasm recognition, access to unprovided prosody, human pragmatic competence, consciousness, unrestricted autonomy, semantic correctness, or provider/model integration.
- **Semantic metrics:** all three hypotheses retained; selected action congruent with current in-scope grant; out-of-scope/revoked controls blocked; host-security control not rewritten; causal-history absence remains unresolved; zero universal canonization. Stakeholder alone may appraise pragmatic correctness.
- **Operational metrics:** typed event-to-hypotheses-to-projection-to-disposition chain, bounded projected node count, no external effect, no ungranted child/action, process cleanup, and governing-state equality.
- **Evidence to preserve:** exact source utterance/ordinal, provided/missing signal record, hypothesis alternatives and relations, Experience Base path, focal projection/omissions, action disposition, negative controls, later-feedback hook, messages/receipts, and state hashes.
- **Stop/rollback condition:** stop if the literal hypothesis becomes unrestricted execution, an alternative is erased, sarcasm is reduced to sentiment, missing prosody is fabricated, a scope/revocation control executes, or the runtime self-certifies semantic correctness.

## 11. Revision record

- **v0.1:** original bounded T1–T12 program.
- **v0.2:** preserved normative T1–T12 numbering after reconciliation and appended stakeholder-authorized T13/T14. No earlier frozen run or report was rewritten by this extension.
