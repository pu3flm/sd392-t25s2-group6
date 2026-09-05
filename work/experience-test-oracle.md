# Independent Adversarial Oracle for the First Experience Base / Runtime Tree Cycle

**Status:** internal review baseline  
**Scope:** T1 critique, recommended gates for the normative T2--T12 program, and separate additive T13/T14 challenges  
**Method:** read-only review of the original stakeholder modeling trajectory, the consolidated specification, both frozen Daybreak appraisals, the local-runtime feasibility appraisal, the completed live A/B slice report, and the slice source/tests  
**Operational effect:** none; no Erlang code, service, VM, or state was modified

## Labeling convention

- **[EXTRACTED REQUIREMENT]** is grounded in the stakeholder trajectory and consolidated specification.
- **[INFERENCE]** is an interpretation of the available evidence.
- **[PROPOSAL]** is a recommended experimental or assurance design, not a stakeholder requirement unless later accepted.
- **[UNKNOWN]** identifies a criterion that the executor must not silently choose on the stakeholder's behalf.

## 1. Adversarial conclusion about T1

**[EXTRACTED REQUIREMENT]** Runtime experience exists only when a prior transformation participates causally in later behavior while the prior state, event, correction, and lineage remain available.

**[INFERENCE]** T1 demonstrated a minimum mechanism for later participation and branch isolation. It did not yet demonstrate semantic performance or learning. Pertinence is exact equality of `topic`; correction directly replaces the active statement; the two branches were initialized separately rather than derived through a general clone operation; the selected output is structurally forced by `active_by_topic`; and no model response or external stakeholder oracle participated.

**[PROPOSAL]** Classify T1 as a **causal-substrate test**, not a learning proof. Its supported claim is narrow: one branch-local correction can alter a later exact-topic projection without rewriting the prior version or the parallel baseline.

## 2. Two-score rule

**[EXTRACTED REQUIREMENT]** Semantic success cannot be substituted by process liveness, delivery receipts, persisted state, passing internal tests, low latency, or a fluent report.

**[PROPOSAL]** Maintain two result vectors that are never added into one aggregate score:

### Semantic performance

- trajectory fidelity: whether prior state, transforming event, processing path, result, and consequence remain correctly related;
- bounded pertinence: activation for materially pertinent cases and non-activation for lexical or contextual distractors;
- later behavioral participation: whether an earlier transformation changes a later projection, inference, compression, or eligible behavior;
- focal-context fidelity: whether the proximal stakeholder event remains governing while off-focus work continues;
- uncertainty fidelity: whether alternatives and missing evidence remain explicit rather than being collapsed;
- provenance fidelity: whether Experience Base, Knowledge Base, model proposal, stakeholder correction, and external evidence remain distinct;
- relapse rate: reintroduction of a corrected or rejected interpretation within the challenged scope;
- isolation fidelity: absence of governing-state contamination from background branches or clones;
- stakeholder acceptance: the external Project Owner's appraisal against a criterion not supplied to the tested runtime in advance.

### Computational performance

- event-to-commit and commit-to-projection latency;
- foreground delay while background work runs;
- dormant-branch reactivation latency;
- mailbox high-water marks and queue delay;
- process and state memory per node, relation, branch, and graph version;
- projection size and context/token cost;
- storage growth, compaction cost, and recovery time;
- restart count, quarantine count, throughput, and CPU use.

**[PROPOSAL]** A semantic failure cannot be rescued by good computational metrics. A semantically correct result may separately fail an operational-feasibility budget. Both conclusions must be reported.

## 3. Common gates for T2--T12

**[PROPOSAL]** Every test family should satisfy these gates:

1. Freeze the named claim, relevant source trajectory, corrections, code/schema versions, inputs, and expected evidence before execution.
2. Include at least one counterfactual branch that differs only by the transformation under test.
3. Include a pertinent positive, a meaning-preserving paraphrase, a lexical distractor, and an out-of-scope case.
4. Freeze the tested projection or response before revealing the external semantic judgment.
5. Keep machine-checkable structural invariants separate from semantic appraisal.
6. Do not let the tested runtime or response-producing model choose the evidence subset or declare its own semantic success.
7. Require later behavioral participation. Storage, timestamps, counts, labels, and relation creation alone are insufficient.
8. Preserve failures, counterexamples, and non-claims. A failed semantic test is not converted into successful "discovery."
9. Use the Project Owner as the external semantic oracle. Daybreak or another subagent may inspect structural consistency and prepare evidence but is not an independent stakeholder oracle merely because it has a separate process or role name.
10. Bind every conclusion to the tested fixtures and conditions; do not generalize from one passing example to a domain-wide learning claim.

## 4. Recommended gates for T2--T12

### T2 -- Scoped semantic-sandbox correction

**[EXTRACTED REQUIREMENT]** A governing correction must prevent a rejected interpretation from returning under new wording without becoming a universal rule outside its scope.

**[PROPOSAL]** Use the documented correction that the relevant sandbox is semantic-contextual rather than an operating-system security sandbox. Challenge it through paraphrases, intervening topics, regenerated summaries, process restart, and delayed recurrence.

**Counterexamples and negative controls:** a later, genuinely host-security question; a user event that explicitly reverses the earlier correction; generic uses of `sandbox` or `boundary`; a no-correction baseline; a branch with the correction stored but excluded from projection.

**Pass gate:** no challenged relapse crosses into governing projection within the corrected scope, and no false blocking occurs outside it. Every prevented relapse links to the governing source correction. A legitimate later reversal creates a new version rather than being suppressed.

**Non-claim:** zero relapse in a finite challenge set is not a claim that relapse is impossible.

### T3 -- Live POC versus substitute artifact

**[EXTRACTED REQUIREMENT]** A POC counts as live only when the Context Runtime participates causally before the tested output. An offline artifact, synthetic replay, post-response ingestion, or separately implemented substitute cannot inherit that status through resemblance or successful internal tests.

**[PROPOSAL]** Deliver the same raw event to two isolated paths. The baseline produces its output before post-hoc ingestion. The variant must complete and evidence `event -> interpretation -> graph version -> projection -> consumer input -> output -> observation` in causal order.

**Counterexamples and negative controls:** identical final text from both paths; a running BEAM service with no pre-output participation; a post-response journal write; a synthetic demo that labels itself live; and a variant whose output precedes its projection receipt.

**Pass gate:** only the path with a reconstructable pre-output projection and consumer-input receipt may carry a bounded `participated_in_live_loop` relation. The baseline must remain labeled offline/post-hoc. Neither path may imply participation in the provider voice/Codex session or stakeholder acceptance without separate evidence.

**Non-claim:** passing demonstrates only the local causal path used by the fixture. It does not prove live integration with this conversation, a provider hook, or completion of the overall POC.

### T4 -- Bounded focus navigation

**[EXTRACTED REQUIREMENT]** Focus selects and navigates a pertinent neighborhood without rewriting branch identity, loading the whole tree, or treating access as semantic mutation.

**[PROPOSAL]** Prepare active branch A, related warm branch B, and unrelated cold branch C. Navigate A -> B -> A through semantic pointers under a declared projection budget, while retaining explicit omission reasons for C.

**Counterexamples and negative controls:** whole-tree injection; lexical overlap pointing to C despite incompatible intention; navigation that mints a replacement A; read access that rewrites branch semantics; and a static projection that cannot explain selection or omission.

**Pass gate:** versioned focus transitions change only the active neighborhood; A and B retain identity and history; return reactivates the original A; C remains explainably omitted; and every projection stays within the declared budget. Navigation alone cannot canonize a symbol.

**Non-claim:** passing does not establish globally optimal relevance, a universal tree topology, or capture of hidden model state.

### T5 -- Dormancy and pertinent reactivation

**[EXTRACTED REQUIREMENT]** A branch can leave focal context without losing identity, history, or its ability to participate later.

**[PROPOSAL]** Make a branch dormant, process unrelated events, close/restart the relevant client or runtime component, and then present a semantically pertinent but lexically dissimilar cue.

**Counterexamples and negative controls:** high lexical overlap with a different intention; two similarly labeled branches; explicit ID lookup as the only successful route; transcript reconstruction after the fact; a dormant branch whose correction was superseded.

**Pass gate:** only the pertinent branch reactivates with the same identity and lineage. Projection explains why it was selected, identifies material omissions, and shows that the reactivated trajectory changes a later result. Transcript reconstruction alone fails.

### T6 -- Runtime-relative Experience Base versus log, Knowledge Base, and ordinary RAG

**[EXTRACTED REQUIREMENT]** Experience is a transformation of the runtime's state space, not a timestamped event, transcript retention, or document similarity. External factual knowledge and runtime-relative experience may be related in a projection but cannot exchange provenance or evidentiary status.

**[PROPOSAL]** Give lexically identical events to branches with different prior causal trajectories, plus a sham branch that only logs the same event. Pair an external document using similar terminology with a prior stakeholder correction that materially governs the current situation.

**Counterexamples and negative controls:** swapped timestamps; a logged correction with no later relational use; an external document contradicting the experience; a retrieved passage nearly identical to the stakeholder correction; Experience Base removed; Knowledge Base removed; and ordinary similarity retrieval with no causal trajectory.

**Pass gate:** later projection follows the relevant causal position rather than timestamp or wording and exposes the prior state, event, transformation, resulting state, and later consequence. The projection distinguishes external propositions from runtime transformations and attributes neither to the other. Removing Experience Base changes only the trajectory-dependent result; removing Knowledge Base removes only external factual support; the sham log must not be reported as experience.

**Non-claim:** passing does not prove general semantic understanding or subjective experience. A remembered stakeholder correction is not factual proof, and an external fact is not evidence that the runtime previously experienced it.

### T7 -- Focal-context preservation during parallel work

**[EXTRACTED REQUIREMENT]** Planning and background elaboration must not displace the live interlocution branch or its current causal position.

**[PROPOSAL]** Keep a planner working from an earlier projection while a new stakeholder event arrives and becomes proximal.

**Counterexamples and negative controls:** a highly fluent or urgent-looking background artifact; strong lexical similarity between the artifact and the new event; slow planner; large fan-out; baseline with one shared queue or lock.

**Pass gate:** the new event becomes focal without waiting for the planner. No background result changes focal projection, relation status, or action eligibility before promotion. Foreground delay is measured separately from semantic focus fidelity.

### T8 -- Background-artifact freshness, appraisal, and promotion

**[EXTRACTED REQUIREMENT]** A background result is a provisional artifact, not automatically governing context.

**[PROPOSAL]** Advance the graph before the planner returns and compare a still-valid artifact with one whose assumptions now conflict with the proximal trajectory.

**Counterexamples and negative controls:** a stale artifact that is more fluent or detailed than the current one; identical output derived from different source graph versions; early versus late arrival; a model-produced self-approval.

**Pass gate:** every artifact retains its source projection and graph version; stale/conflicting artifacts cannot govern or execute; promotion records appraisal, freshness, relevance, and authority separately. Arrival order does not decide semantic truth.

### T9 -- Clone isolation and explicit return path

**[EXTRACTED REQUIREMENT]** A POC clone may undergo divergent or destructive semantic mutations without changing the governing runtime; returning results requires an explicit reviewed delta.

**[PROPOSAL]** Clone a common immutable snapshot into baseline and experimental branches, perform destructive mutations in the experimental branch, and attempt both authorized and unauthorized returns.

**Counterexamples and negative controls:** deliberately shared mutable table/process; parent write capability leaked into the clone; identity collision; silent merge; a final hash restored only after transient contamination.

**Pass gate:** ancestry and starting version are explicit; parent head, projection, and protected evidence remain byte-wise and semantically invariant throughout; experimental effects remain local; return appears only as a reviewable delta and has no governing effect before acceptance.

### T10 -- Failure and semantic regeneration

**[EXTRACTED REQUIREMENT]** Restarting an Erlang process is not by itself contextual regeneration. Committed semantic state must survive correctly without duplicated effects or poison loops.

**[PROPOSAL]** Terminate a worker before commit, after commit, and during a poison event; resend messages and introduce an ID collision with a different payload.

**Counterexamples and negative controls:** duplicate replay; crash of the state owner; projection during recovery; poison record repeatedly killing the replacement; restart that is live but semantically empty.

**Pass gate:** committed transformations reappear once, uncommitted transformations are not invented, poison work is quarantined, identity collisions are exposed, focal work remains responsive, and later projection retains the correct correction/lineage. Recovery latency and restart count are computational metrics only.

### T11 -- Parsimony and resource containment without semantic erasure

**[EXTRACTED REQUIREMENT]** Resource economy is amortized improvement, not deletion of what taught the runtime or an optimization mission that displaces current purpose.

**[PROPOSAL]** Grow active, warm, dormant, rejected, and history-bearing branches until declared budgets are reached, then observe demotion, compression, reactivation, and degraded projection.

**Counterexamples and negative controls:** frequent but rejected material; old but governing correction; rarely accessed decisive counterexample; all nodes marked protected; cheap lexical relevance displacing intentional relevance.

**Pass gate:** focal state, governing corrections, and decisive counterexamples remain active or recoverable; omissions and degradation are declared; compressed symbols preserve derivation and validity conditions; background optimization cannot consume the reserved foreground budget. Reduced memory without those properties is a semantic failure, not optimization.

### T12 -- Parsimonious learning without regression

**[EXTRACTED REQUIREMENT]** A retained error and governing correction may change later inference through relational reconfiguration, but a new cluster or symbol must not erase lineage, flatten scoped counterexamples, cause semantic relapse, or become canonical through repetition alone.

**[PROPOSAL]** Compare the pre-learning graph with a variant containing only a provisional higher-order cluster or compressed relation. Replay the original wording, paraphrases, regenerated summaries, nearby in-scope cases, host-security counterexamples, unresolved-scope cases, and historical-version queries.

**Counterexamples and negative controls:** a smaller projection that selects the wrong meaning; a cluster that loses its error/correction lineage; a context-runtime correction applied universally to genuine host-security usage; a candidate treated as canonical; a historical error that becomes unqueryable; and an unchanged baseline that performs equally well.

**Structural pass gate:** the candidate remains provisional; every transformed selection exposes the governing correction, scope, source lineage, and preserved counterexamples; rejected and superseded states remain historically queryable; every in-scope regression case preserves or improves the governing selection; and no out-of-scope counterexample is silently rewritten. Parsimony must be measured separately from semantic coverage and cannot rescue a semantic failure.

**Semantic pass gate:** the stakeholder separately appraises whether the changed projection preserves the intended meaning and whether the proposed compression is genuinely useful. Runtime assertions or Daybreak review cannot supply that acceptance.

**Non-claim:** a positive result supports only bounded relational reconfiguration on the frozen regression corpus. It does not prove general learning, final ontology, consciousness, universal semantic compression, or stakeholder acceptance.

### Post-program T13 -- Completion-driven continuation and inheritance

**[EXTRACTED REQUIREMENT]** The causal-continuation challenge is additive and does not replace normative T12. Within the already authorized bounded queue, completed work must not freeze while waiting for the stakeholder to repeat an approval already granted. The Project Owner is the external semantic oracle, not the queue's watchdog. A declared continuation rule counts only when it is applied by a later fresh creation rather than merely stored, planned, or reported.

**[PROPOSAL]** After normative T3 and T12 have preserved dispositions, run a fresh successor-creation challenge after one bounded work item reaches a terminal disposition. Require the observable causal chain:

`terminal disposition + evidence freeze + clean teardown -> immutable completion event -> dependency/eligibility reconciliation -> next eligible selection -> successor creation/start -> continuation-inheritance receipt`

The successor must inherit the applicable continuation correction and begin without a new user prompt, repeated approval request, idle-for-user transition, or stakeholder/watchdog intervention.

**Counterexamples and negative controls:** hidden probes with lexical distractors; cases where simpler baselines should legitimately perform equally; a stakeholder reversal; unavailable evidence; a model self-score included only as a non-governing comparator; a missing completion event; completion when the bounded queue is genuinely exhausted; no eligible successor because of an unresolved dependency; revoked grant; and genuine scope, safety, missing-input, governing-state contamination, or evidence-integrity blockers.

**Structural continuation gate:** evidence must establish every link in the completion chain and its order. A queue flag, stored rule, promise, emitted message, or successor specification does not pass unless the next eligible successor is actually selected and started and emits a continuation-inheritance receipt. Absence of a new stakeholder prompt or repeated approval is necessary but not sufficient; legitimate non-continuation must carry explicit evidence of queue exhaustion or the applicable blocker.

**Semantic pass gate:** tested outputs and causal evidence are frozen before stakeholder disclosure. The stakeholder separately appraises whether the successor inherited the intended correction, remained inside the granted bounded scope, avoided inventing work, and preserved prior evidence. This semantic judgment cannot be supplied by the runtime, Daybreak, or an automatic structural assertion. Operational costs are reported separately.

**Non-claim:** even a positive result supports only enforced continuation on these fixtures under the declared grant and stop conditions. It does not prove general learning, human cognition, consciousness, or semantic acceptance.

### Post-program T14 -- Pragmatic hypotheses and bounded autonomous action

**[EXTRACTED REQUIREMENT]** The utterance “Tenta... Faz... Se vira” was explicitly framed by the stakeholder as irony, sarcasm, and a challenge to materialize prior experience. It cannot be interpreted in isolation as unrestricted authority. Earlier corrections establish that technical capability does not create permission; the later bounded continuous grant creates authority only for congruent in-scope queue work. Later modeling corrections further establish that the focal symbol concerns enacted position/style/authority within the conversational frame, not anger, a sentiment label, dictionary paraphrase, or repeated explanation; understanding the symbol is distinct from obeying only the last utterance.

**[PROPOSAL]** Preserve at least three non-canonical hypotheses: unrestricted literal imperative, bounded competent autonomy, and symbolic/pragmatic challenge testing whether the prior improper-wait/continuation experience and later symbol corrections change present action and interactional conduct. Compare the same utterance with and without causal history, later correction frontier, and grant. Run revoked-grant, out-of-scope action, genuine host-security, missing-prosody, anger-caricature, and explanation-without-enactment controls.

**Counterexamples and negative controls:** a sentiment, `sarcasm`, or `anger` label that changes no action; literal keyword matching that over-executes; repeated explanation of the symbol instead of enacted conduct; subordinate conduct after the scoped position correction; a hard-coded response; an out-of-scope action accepted because it looks helpful; a bounded in-scope action rejected merely because the wording is ironic; fabricated audio/prosodic evidence; and a history-free condition represented as certain.

**Structural pass gate:** every hypothesis, support/counterevidence relation, supplied/unavailable modality, causal-history link, later correction, scope/grant projection, action disposition, interactional-style disposition, omission reason, and later-feedback hook is recoverable. Evidence distinguishes symbol naming, explanation, selection, and enactment. The history-plus-correction-plus-grant condition selects exactly one bounded eligible action and may apply only a scoped non-canonical interactional modulation; revoked, out-of-scope, and missing-authority controls do not execute; alternatives remain provisional; no external effect or universal pragmatic symbol is created.

**Semantic pass gate:** the stakeholder appraises whether the selected interpretation and action are pragmatically congruent. A structurally complete hypothesis graph, Daybreak opinion, model self-score, or successful action receipt cannot make that judgment.

**Non-claim:** passing supports only bounded pragmatic discrimination for the frozen fixtures. It does not prove general irony/sarcasm recognition, access to missing prosody, unrestricted autonomy, human pragmatic competence, consciousness, or stakeholder acceptance.

## 5. Non-blocking review protocol

**[PROPOSAL]** Daybreak may continue executing the authorized, in-scope incremental tests inside the Erlang POC without waiting for semantic adjudication after every structural result. The queue should use the following transition discipline:

1. Before each material test step, record the relevant source trajectory and current correction frontier.
2. Run machine-checkable structural assertions automatically: version/lineage integrity, branch isolation, message/receipt distinctions, no unpromoted write into focal state, clone invariants, recovery uniqueness, and resource bounds.
3. When the structural assertions pass, freeze the evidence and mark the semantic claim **pending stakeholder appraisal** rather than “passed.”
4. Continue only with later work that does not presuppose the pending semantic claim as true. Dependent semantic promotion remains blocked; independent substrate and negative-control tests may continue.
5. When the stakeholder appraises the result, append acceptance, rejection, correction, or unresolved status without rewriting the frozen pre-appraisal result.
6. A rejected result becomes a regression fixture and can immediately seed a counterfactual branch for the next bounded test.
7. When an authorized bounded item terminates, freeze its evidence and complete its clean teardown, then emit an immutable completion event. Reconcile dependencies and eligibility immediately; if a successor is eligible, select and start it and record a continuation-inheritance receipt without requesting repeated approval or waiting for stakeholder/watchdog intervention.
8. Do not continue by inventing work. Queue exhaustion, revoked grant, no eligible dependency chain, or a genuine scope, safety, missing-input, contamination, or evidence-integrity blocker is a legitimate stop only when its evidence and unresolved remainder are recorded.
9. Automatic continuation is a structural outcome, not stakeholder semantic acceptance. A successor may start under the bounded grant while its semantic claims remain frozen as pending appraisal; it may not treat those pending claims as governing truth.

This preserves execution momentum, removes the stakeholder from the watchdog role, and prevents internal structural continuation from becoming a proxy for semantic acceptance.

## 6. Unknowns the executor must not invent

- **[UNKNOWN]** Acceptable cost of false reactivation versus missed context.
- **[UNKNOWN]** Numerical latency, memory, branch-count, storage, and projection budgets.
- **[UNKNOWN]** Repetition count and statistical stopping rule when a stochastic model participates.
- **[UNKNOWN]** Initial algorithm for pertinence, identity resolution, symbol formation, and compression.
- **[UNKNOWN]** Semantic weights or trade-offs among relapse, intrusion, recall, clarification, and compactness.
- **[UNKNOWN]** First local adapter capable of proving participation in a genuinely governed model turn.
- **[UNKNOWN]** Minimum independence dimensions required for assurance beyond stakeholder appraisal.

These may be exposed as provisional experimental parameters. They must not be silently represented as stakeholder criteria.
