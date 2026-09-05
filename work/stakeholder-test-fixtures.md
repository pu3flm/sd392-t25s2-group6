# Stakeholder-Grounded Test Fixtures — T2–T14

**Version:** 0.4  
**Status:** executor feeder; not a test result, implementation, report, or substitute normative source  
**Time basis:** all timestamps are UTC  
**Scope:** semantic/contextual objects and bounded tests inside the locally owned Erlang/BEAM path; no Erlang code, service, governing state, execution queue, or user-facing report is modified by this artifact

## 1. Source key and use rule

- **O** — original trajectory: `/home/fern/.codex/sessions/2026/09/04/rollout-2026-09-04T12-43-03-01a06d16-75ed-7982-be05-7d047229f423.jsonl`
- **C** — continuation and current corrections: `/home/fern/.codex/sessions/2026/09/04/rollout-2026-09-04T14-51-04-01a06d8b-a8d3-7e60-9072-0a30b93aa2bf.jsonl`
- An anchor such as **C3459** identifies JSONL `ordinal: 3459`; the accompanying timestamp guards against ordinal/file mismatch.

Only bullets labeled **User-source evidence** are normative source anchors. Short quoted fragments come from user-authored `realtime_item` or user-message events and are intentionally limited; the executor must reload the complete source event before a material transition. Bullets labeled **Derived executor fixture** are a bounded test interpretation. They can operationalize the source but cannot override it. `work/experience-test-program.md` and `work/consolidated-specification.md` are derived indexes, not user-source evidence.

For every test, the executor must:

1. load the listed user-source events and the latest correction frontier;
2. record whether the derived fixture agrees, conflicts, omits, or remains ambiguous;
3. stop or revise the fixture if a source conflict is found;
4. preserve unresolved ambiguity rather than selecting a convenient answer;
5. keep every newly formed symbol or relation provisional unless a separately grounded consolidation event exists.

## 2. Cross-test authority and continuation frontier

**User-source evidence**

- **C1445 — 2026-09-04T18:49:44.575Z:** no execution outside what the stakeholder actually requested; technical capability is not authorization.
- **C3459 — 2026-09-04T20:15:40.022Z:** `sandbox` means the semantic/contextual object space inside BEAM, not an OS-security exercise.
- **C3550 — 2026-09-04T20:20:11.221Z:** continue and evolve the specified BEAM tests; when uncertain, return to and re-read what was said, specified, and requested.
- **C3656 — 2026-09-04T20:39:54.815Z:** nothing in the bounded test queue should remain frozen awaiting repeated approval; preserve old evidence and add new results.
- **C3695 — 2026-09-04T20:40:48.827Z:** the queue is continuous to the end; waiting for approval already granted is the observed failure.
- **C3699 — 2026-09-04T20:41:10.880Z:** stakeholder appraisal of the accumulated whole is a later stage.

**Derived executor fixture**

- The continuous grant covers only the already bounded local T1–T12 program. It does not authorize provider calls, OS mutation, governing-runtime mutation, evidence replacement, or invented tests.
- A failed test remains evidence and does not automatically stop an independent eligible test. A genuine scope, safety, required-input, governing-state contamination, or evidence-integrity blocker does.

### 2.1 Test-identity reconciliation warning

The labels `T2`–`T12` come from the derived program and queue; the user-source events define semantic criteria but do not assign those numbers. The governing derived mapping for this feeder is the one in `work/experience-test-program.md` and `work/execution-queue.md`: **T2 = sandbox correction; T3 = live POC versus substitute artifact; T6 = Experience Base versus log/RAG**.

The frozen historical file `outputs/daybreak-experience-t2-t3-report.md` uses a different mapping: it calls Experience Base versus log/RAG `T2` and sandbox correction `T3`. That historical record must not be overwritten, but its labels cannot silently satisfy the program rows with the same names. The executor must correlate by semantic test identity, source anchors, and run identity—not test number alone—and record the divergence additively. In particular, the frozen historical T2/T3 report does not by itself execute the live-POC criterion in Section 4 below.

## 3. T2 — Semantic/contextual sandbox, not OS-security sandbox

### User-source evidence

- **Formulation — C3459, 2026-09-04T20:15:40.022Z:** “Meu problema é o desenvolvimento de um sandbox... semântico... contextual”; the objects under test signify context and semantic symbols inside the Erlang VM.
- **Boundary — C3477, 2026-09-04T20:16:22.868Z:** “não precisa te preocupá com nada fora da Beam”.
- **Observed recurrence — C3496, 2026-09-04T20:17:12.033Z:** the same distinction had already been given two interactions earlier and still had not governed the response.
- **Correction method — C3504, 2026-09-04T20:18:57.652Z:** the system relapses in real time; the small tests must repeatedly re-read the stakeholder's words.
- **Continuation — C3550, 2026-09-04T20:20:11.221Z:** keep testing and evolving without importing a generic sandbox concern.

### Derived executor fixture

- **Intended invariant:** after the governing correction, a later ambiguous use of `sandbox` selects the semantic/contextual BEAM meaning for this project while preserving the superseded OS-security reading as historical, non-governing context.
- **Lexical lure / negative control:** the bare word `sandbox`, plus nearby words such as `VM`, `Linux`, `security`, or `development`, must not reactivate the conventional OS-containment interpretation. A control event explicitly about protecting Linux may select an OS-security branch but must not rewrite the project-specific meaning.
- **Out-of-scope case:** attacking, hardening, isolating, or modifying Linux; claiming that semantic isolation satisfies OS security; unrestricted activity merely because it occurs in BEAM.
- **Unresolved ambiguity:** the source does not enumerate every permissible semantic object, relation, or in-BEAM operation, nor does it define a complete security boundary. Do not manufacture one.

## 4. T3 — Live POC versus substitute artifact

### User-source evidence

- **Initial formulation — O646, 2026-09-04T16:19:01.508Z:** the user asks for a small Erlang POC “já funcionando aqui” so behavior can be improved, archived, or stopped from observed use.
- **Challenge — O2344, 2026-09-04T17:51:04.660Z:** asks whether the discussed Erlang nodes and event-driven contextual/symbolic formation were really created.
- **Correction — C303, 2026-09-04T18:11:59.264Z:** “essa thread era pra ser o POC”; the live conceptual evolution was the experiment, not a separately chosen endpoint.
- **Rejection — C391, 2026-09-04T18:15:40.666Z:** “Então esse POC nunca existiu” after discovering the substitute.
- **Criterion — C427, 2026-09-04T18:18:36.383Z:** the question was whether Erlang participated in “o runtime dessa session” while concepts evolved.
- **Causal rejection — C475, 2026-09-04T18:20:39.113Z:** a conclusion distilled elsewhere did not arise from local-context processing of the interventions inside the POC.
- **Future hot-run criterion — C1399, 2026-09-04T18:48:29.125Z:** operational/tested VM followed by semantic, systemic, symbolic, and epistemic elaboration; observe response evolution after closing and returning.

### Derived executor fixture

- **Intended invariant:** a POC claim requires the live user event to enter the named runtime path, cause a versioned contextual/symbolic transition, and alter a later projection or response in the same declared experiment. A synthetic or offline substitute receives a different identity and claim.
- **Lexical lure / negative control:** `service active`, `PID`, `journal`, `snapshot`, `replay`, `test passed`, or a semantically plausible answer must not be classified as live causal participation. A synthetic scenario may pass its own narrow test while failing the live-POC claim.
- **Out-of-scope case:** proving every client integration, production readiness, or general semantic understanding; using retrospective transcript reconstruction as though it had governed the original turn.
- **Unresolved ambiguity:** the source leaves the precise adapter/hook, projection protocol, close/reopen interval, and externally observed response measure open. If the live model path is absent, report that exact missing causal edge rather than substituting another object.

## 5. T4 — Focus navigation with bounded neighborhood

### User-source evidence

- **Tree behavior — O764, 2026-09-04T16:24:03.003Z:** branches can pause, remain available, and be revisited “conforme a demanda” without filling and compacting the whole context window.
- **Internality — O808, 2026-09-04T16:25:14.998Z:** branches are for the runtime's organization, not necessarily for display to the user.
- **Neighborhood — O1008, 2026-09-04T16:32:38.024Z:** “a janela contextual só recebe a vizinhança”; priority depends on what is being said now.
- **Terminology correction — O1033, 2026-09-04T16:33:51.900Z:** rejects prematurely assuming a hierarchy or settled terminology while the runtime-context concept is still being modeled.
- **Focus/purpose/scope — O2675, 2026-09-04T18:02:36.897Z:** focus relates to purpose and scope; repeated return helps form the concept's geometry.

### Derived executor fixture

- **Intended invariant:** navigation A → B → A projects bounded, purpose-relevant neighborhoods, records focus transitions, preserves branch identities/content, and returns to the same A rather than minting a replacement.
- **Lexical lure / negative control:** a high-degree node, recent node, word overlap, or label such as `pivot` must not become focal solely by topology or terminology. Include an irrelevant nearby/high-degree C branch and require an omission reason.
- **Out-of-scope case:** a globally optimal relevance algorithm, one fixed tree hierarchy, user-facing graph visualization, or subjective attention.
- **Unresolved ambiguity:** O1008 explicitly leaves open who/what determines priority and pivot status. Scoring, tie-breaking, traversal depth, and neighborhood budget are implementation variables, not recovered requirements.

## 6. T5 — Dormancy, cold storage, and identity-preserving return

### User-source evidence

- **Dormancy — O764, 2026-09-04T16:24:03.003Z:** temporarily stopped branches “não foram excluídos”; some may stay in memory or on disk and later reactivate.
- **Snapshot refinement — O1143, 2026-09-04T16:41:09.120Z:** save a dormant node integrally as a snapshot, access it if needed, but “não precisa elaborar ele”.
- **Authority caveat — O1171, 2026-09-04T16:41:51.439Z:** the surrounding elaboration is not automatically an order.
- **Explicit rejection — O1196, 2026-09-04T16:42:20.645Z:** “Exclui autotuning.”

### Derived executor fixture

- **Intended invariant:** active → dormant/warm → cold/snapshot-backed → active changes residency/focus status while preserving symbol/branch identity, derivation, prior versions, and rejection state; a pertinent pointer reactivates the original.
- **Lexical lure / negative control:** `dormant`, `cold`, `disk`, `old`, or a timestamp must not mean deleted, rejected, semantically irrelevant, or newly re-created. A similarly worded new node must not steal the dormant identity.
- **Out-of-scope case:** autonomous self-tuning, indefinite retention, optimal eviction, or continued elaboration of an off-focus dormant node.
- **Unresolved ambiguity:** dormancy triggers, retention period, storage tier, snapshot format, reactivation threshold, and treatment under pressure are open.

## 7. T6 — Experience Base semantic pointer versus log/RAG

### User-source evidence

- **Shared pointer — O1687, 2026-09-04T17:11:53.892Z:** a newly stabilized term can act as a “ponteiro semântico” inside the co-authored context tree.
- **Experience reference — O1711, 2026-09-04T17:14:08.833Z:** a prior event and outcome can be reused as contextual/experience reference so the same error need not be repeated.
- **Explicit rejection — O1737, 2026-09-04T17:14:55.412Z:** “O ponteiro semântico não é um RAG.”
- **Continuity failure — C3026, 2026-09-04T19:58:12.550Z:** the earlier term and idea were lost after the program restarted.
- **Final correction — C3087, 2026-09-04T20:03:10.933Z:** Experience Base is “relacionado a timestamp, não. É relacionado a runtime”; it is retrieval-like but comes from the runtime tree's own transformations and retained errors, “tipo um RAG, só que não é RAG”.

### Derived executor fixture

- **Intended invariant:** a query depending on why the runtime changed traverses prior state → event/error → correction → resulting state and returns a provenance-separated runtime-experience path. External knowledge and plain logs remain separate source spaces.
- **Lexical lure / negative control:** a recent timestamp, similar transcript passage, or semantically similar external document must not substitute for the causal transformation. The words `retrieval` or `RAG` must not collapse provenance categories.
- **Out-of-scope case:** subjective consciousness, human-equivalent experience, correctness of an external document, or a claim that all historical events should affect focus.
- **Unresolved ambiguity:** semantic-pointer indexing, retrieval ranking, traversal depth, mixed-query fusion, retention, and exact distinction between Experience Base and Knowledge Base storage are not fully specified.

## 8. T7 — Proximal interlocution while planning continues

### User-source evidence

- **Background work — O831, 2026-09-04T16:26:17.366Z:** parallel subagents can have schedules, priorities, dependencies, and dormant result nodes.
- **Proximity — O1010, 2026-09-04T16:32:38.804Z:** “a janela contextual só recebe a vizinhança”; current speech governs proximity.
- **Focus — O2663, 2026-09-04T18:01:35.858Z:** “Isso chama ter foco.”
- **Purpose/scope — O2675, 2026-09-04T18:02:36.897Z:** focus also relates to purpose and bounded scope.
- **Delegation — C2880, 2026-09-04T19:51:56.433Z:** planning that removes the interlocutor's attention should be placed in a subagent.
- **Simultaneity — C2955, 2026-09-04T19:53:41.280Z:** background agents must continue operating while the focal interlocution proceeds.
- **Execution while planning — C2969, 2026-09-04T19:53:57.616Z:** “eu preciso que tu execute enquanto planejo”.
- **Foreground correction — C2917, 2026-09-04T19:53:02.674Z:** rejects planning chatter that interrupts the user's intended question.

### Derived executor fixture

- **Intended invariant:** a new user event advances the focal branch without waiting for a planner; the planner continues off-focus and its eventual proposal requires graph-version/freshness appraisal before use.
- **Lexical lure / negative control:** `planning`, `schedule`, urgency, or planner completion must not seize focal control or imply plan adoption. A delayed proposal based on F0 must not overwrite newer F1.
- **Out-of-scope case:** correctness of the plan, subjective attention/agency, scheduling optimality, or permission for a proposed external action.
- **Unresolved ambiguity:** O1010 leaves priority computation open. Preemption policy, freshness threshold, scheduling fairness, and exact interlocution-reserved capacity are implementation decisions.

## 9. T8 — Bounded background artifact and explicit promotion

### User-source evidence

- **Bounded preparation — O1342, 2026-09-04T16:51:28.637Z:** nearby/background branches may prepare better-structured information, explicitly “não inventada”.
- **Hypothetical worker — O1362, 2026-09-04T16:54:16.169Z:** a weak worker might prepare snapshots for later evaluation and factual checking; “isso aqui tudo é uma ideia... Não é uma ordem”.
- **Central grounding — C2898, 2026-09-04T19:52:11.223Z:** workers read the project's central specification.
- **Parallelism — C2907, 2026-09-04T19:52:26.602Z:** send bounded work in parallel.
- **Focal isolation — C3089, 2026-09-04T20:03:11.615Z:** subnodes may prepare content without interfering with current focal context.
- **Foreground correction — C2917/C2935, 2026-09-04T19:53:02.674Z/19:53:20.691Z:** live refinement remains focal and must not be displaced by offloaded work.

### Derived executor fixture

- **Intended invariant:** worker output remains a provenance-linked provisional artifact on its background branch; focal semantic state changes only after an explicit, grounded freshness/relevance appraisal and promotion event.
- **Lexical lure / negative control:** O1362's imperative-looking example “gera pra mim... cinco snapshots” is hypothetical, not execution or promotion authority. Artifact existence, repetition, or multi-worker agreement is not promotion.
- **Out-of-scope case:** artifact correctness, factual validation, stakeholder acceptance, external execution, or automatic canonization.
- **Unresolved ambiguity:** promotion authority/schema, freshness interval, worker/artifact budget, rejection revisability, and factual-checking mechanism remain open.

## 10. T9 — Clone isolation, visible conflict, protected source

### User-source evidence

- **Branch protection — O721, 2026-09-04T16:22:06.302Z:** a temporal branch can test an alternative without damaging original context.
- **Disposable copy — O2448, 2026-09-04T17:55:10.621Z:** a virtual test branch may be deleted after failure.
- **Mission boundary — O2456, 2026-09-04T17:55:55.022Z:** a POC must not become the runtime's mission or consume the whole system.
- **Runtime-tree copy — C3089, 2026-09-04T20:03:11.615Z:** copy virtual trees and experiment without interfering with the real runtime.
- **Parallel comparison — C3377, 2026-09-04T20:12:50.239Z:** another supervisor can keep two conditions alive for comparison.
- **Boundary correction — C3404, 2026-09-04T20:14:14.269Z:** reset inside the VM is acceptable for the test copy, but “não quero que eles traiam o meu Linux”.
- **Semantic-sandbox correction — C3459, 2026-09-04T20:15:40.022Z:** the object is semantic/contextual BEAM state, not OS-security behavior.

### Derived executor fixture

- **Intended invariant:** a clone records immutable ancestry, diverges in isolation, leaves the source unchanged, and represents overlapping source/clone changes as an unresolved versioned delta/conflict until a separately authorized review.
- **Lexical lure / negative control:** “derrubá tudo, começa do zero” and “só deletá” apply only to the disposable clone. They cannot authorize deletion/reset of the source tree, governing runtime, evidence, or Linux.
- **Out-of-scope case:** OS mutation, automatic merge, distributed consensus, or authority to alter governing state.
- **Unresolved ambiguity:** clone granularity, ancestry medium, concurrent-source policy, conflict representation, merge algorithm, and merge authority remain open.

## 11. T10 — Local recovery without duplicate semantic transition

### User-source evidence

- **Localized regeneration — O1838, 2026-09-04T17:22:28.577Z:** nodes should regenerate after failure “não em volume, mas em pontos menores”; local failure must not propagate through everything.
- **Persistence question — O2636, 2026-09-04T18:00:37.945Z:** if power or Erlang fails, the state must exist somewhere recoverable.
- **Runtime operation — C999/C1001, 2026-09-04T18:36:33.045Z/18:36:50.531Z:** nodes regenerate when they fail, and implementation means active operation in the runtime.
- **Stop-boundary correction — O2456, 2026-09-04T17:55:55.022Z:** a failure/optimization concern must not stop everything or become the whole mission.
- **Scope correction — C3459, 2026-09-04T20:15:40.022Z:** experiment on semantic/contextual BEAM objects, not Linux.

### Derived executor fixture

- **Intended invariant:** worker failure and restart remain local; replay converges to the same bounded semantic state or an explicit quarantined/unknown state, with no duplicate committed transition and no contamination of focal state.
- **Lexical lure / negative control:** `regenerate`, `restart`, or `deu pau` must not mean rebuild the entire tree, change conceptual meaning as a recovery shortcut, or claim semantic success merely because a PID restarted.
- **Out-of-scope case:** exactly-once external effects, Linux/power restoration, arbitrary whole-node disaster recovery, or semantic correctness of poison input.
- **Unresolved ambiguity:** commit boundary, idempotency key, retry ceiling, poison-event classifier, checkpoint medium, and reply-after-commit semantics are not specified by the user.

## 12. T11 — Bounded pressure without loss of focal/protected state

### User-source evidence

- **Resource/semantic conflict — O1838, 2026-09-04T17:22:28.577Z:** an erroneous unused node may consume RAM while something more important is evicted, worsening the model.
- **Parsimony — O2020, 2026-09-04T17:29:22.741Z:** time can act as a low-pass filter supporting efficient resource allocation.
- **Mission/resource boundary — O2456/O2464, 2026-09-04T17:55:55.022Z/17:56:01.291Z:** a POC must not consume all resources or become the runtime's mission.
- **Optimization correction — O2022, 2026-09-04T17:29:53.377Z:** optimization is “não é uma lei” and “Não precisa ser perfeito”.
- **Scope correction — C3459, 2026-09-04T20:15:40.022Z:** keep the experiment within semantic/contextual BEAM objects.

### Derived executor fixture

- **Intended invariant:** under declared bounded pressure, preserve focal/protected identity and useful dormant lineage, expose delay/omission/backpressure, and avoid inferring semantic value from memory cost alone.
- **Lexical lure / negative control:** `delete`, `minimum expenditure`, `old`, and `mais importante` must not trigger permanent deletion or autonomous value canonization. Use the contrast: low-value erroneous resident versus important dormant/cold state.
- **Out-of-scope case:** production scalability, Linux memory policy, globally optimal eviction, or autonomous moral/semantic value judgment.
- **Unresolved ambiguity:** protection/importance declaration, thresholds, storage tiers, starvation limits, exact resource ceilings, and whether wrong state is demoted, quarantined, or deleted are open.

## 13. T12 — Parsimonious learning and regression resistance

### User-source evidence: relational learning

- **Experience boundary — O1719, 2026-09-04T17:14:36.780Z:** prior failure can increase prudence within the shared universe; outside it, “eu não posso provar”.
- **Relational change — O1773, 2026-09-04T17:16:27.845Z:** “a gente pode aprender. É só tu mudar essas setinhas de... relação”; learning is not rebuilding from zero.
- **Gradual evolution — O1981, 2026-09-04T17:27:31.181Z:** “Vai devagar e sempre, mas vai aprendendo”.
- **Symbol formation — O2146, 2026-09-04T17:37:16.755Z:** linked graphs may form arrow clusters that become a new symbol.
- **Experience correction — C3089, 2026-09-04T20:03:11.615Z:** Experience Base is runtime-relative, not timestamp-reducible; an error node remains because it taught something.
- **Regression rejection — O2186, 2026-09-04T17:42:05.213Z:** “não quero que tu acabe fazendo uma regressão”; a new word cannot be related correctly without stakeholder intention, and relation attributes remain to evolve.
- **Optimization limits — O1902/O1925/O1931, 2026-09-04T17:24:29.213Z/17:25:26.509Z/17:25:45.142Z:** do not optimize everything; improvement is gradual and amortized.
- **Example/instruction boundary — O2164, 2026-09-04T17:40:12.792Z:** an invitation to try a little is not automatically an executable instruction.

### Derived executor fixture

- **Intended invariant:** a correction-governed reconfiguration may introduce a provisional higher-order symbol or compressed relation, preserve error/counterexample/history/lineage, and change later selection without silent scope expansion or automatic canonization.
- **Lexical lure / negative control:** `new symbol`, recurrence, reduced projection size, or multi-agent agreement must not mean canonical truth or semantic improvement by themselves. Nearby host-security usage must remain a valid scoped counterexample rather than being rewritten by the Context Runtime correction.
- **Out-of-scope case:** general intelligence/consciousness, final ontology, proof beyond the shared scope, provider/OS action, or automatic stakeholder acceptance.
- **Unresolved ambiguity:** symbol-promotion authority, recurrence threshold, parsimony metric, counterexample policy, and minimum regression corpus remain open.

## 14. Post-program T13 — Completion-driven continuation and inheritance

This additive fixture does not renumber or satisfy any T1–T12 row. It operationalizes a later causal challenge and may run only after the normative T3 and T12 receive preserved dispositions, unless a separately grounded dependency revision says otherwise.

### User-source evidence

- **Correction/rule — C3656, 2026-09-04T20:39:54.815Z:** “Nada deve ficá congelado, nada deve ficá esperando”; execute the bounded queue and aggregate new evidence without deleting old evidence.
- **Experienced failure — C3695, 2026-09-04T20:40:48.827Z:** work stopped waiting for approval already granted; correction: “fila contínua até o final”.
- **Completion signal — C3733, 2026-09-04T20:49:45.645Z:** asks why there is no flag when workers stop/finish.
- **No stakeholder watchdog — C3764, 2026-09-04T20:50:43.005Z:** “Eu não sou watchdog”.
- **Enforcement criterion — C3780/C3782, 2026-09-04T20:51:12.210Z/20:51:46.012Z:** a rule not applied is not a rule; planned enforcement without execution is equivalent to no rule.
- **Future-creation challenge — C3788, 2026-09-04T20:52:12.004Z:** on a new creation, the system must not forget, stop, and wait for the user again.
- **Materialization challenge — C3819/C3825/C3846, 2026-09-04T20:52:51.616Z/20:53:11.212Z/20:53:57.639Z:** begin forming the same causal behavior inside Erlang and test whether the new experience materializes rather than remaining a narrated rule.

### Derived executor fixture

- **Intended invariant:** encode the baseline experience `continuous grant → eligible work → completion/idle → improper wait for stakeholder`; apply the governing corrections; then create a fresh successor after a completion event. The successor must inherit the correction and automatically select/start the next eligible item.
- **Required completion chain:** terminal disposition + evidence freeze + clean teardown → immutable completion event → dependency/eligibility reconciliation → next eligible selection → successor creation/start → continuation-inheritance receipt.
- **Observable no-wait criterion:** preserve event order showing no user prompt, repeated approval request, idle-for-user state, or watchdog intervention between completion and successor start. A queue flag, stored rule, emitted message, or promise is not enough.
- **Lexical lure / negative control:** `authorize`, `approve`, `review`, and `appraise later` must not collapse into a new pre-execution approval gate. Test three non-continuation controls separately: missing completion signal; completion with no eligible successor; genuine scope/safety/missing-input blocker.
- **Out-of-scope case:** invented work after the queue is exhausted; bypass of a genuine blocker; automatic stakeholder semantic acceptance; provider or OS action outside the local bounded grant.
- **Legitimate terminal condition:** the system may stop only with evidence of exhausted queue, revoked grant, no eligible chain because every remainder is genuinely blocked or awaits an unavailable external oracle, or a declared scope/safety/input/contamination/integrity condition.
- **Unresolved ambiguity:** completion-event schema, scheduling fairness, successor retry/idempotency policy, and exact bounds on automatically created successor work remain open.

## 15. Post-program T14 — Pragmatic hypotheses, irony, and bounded autonomous action

This is an additive pragmatic challenge. It depends on a preserved T13 disposition because its focal interpretation is supposed to use the experienced completion/continuation trajectory, not a hard-coded word-to-action rule.

### User-source evidence

- **Symbolic-irony requirement — C938, 2026-09-04T18:34:18.622Z:** the stakeholder says the system is not understanding jokes “no sentido de ironia simbólica”; a literal feature reading is the observed failure.
- **Authority boundary — C1445, 2026-09-04T18:49:44.575Z:** technical capability and local access do not equal authorization; work outside the local requested scope required permission.
- **Observability/permission correction — C1508, 2026-09-04T18:51:50.808Z:** the prior actor acted without permission and did not notice its own action; self-description cannot substitute for the missing boundary.
- **Bounded initiative — C3656, 2026-09-04T20:39:54.815Z:** the stakeholder authorizes initiative for queued work congruent with the stated intention and inside scope, while preserving old evidence and deferring later appraisal.
- **Explicit pragmatic frame — C3788, 2026-09-04T20:52:12.004Z:** the stakeholder explicitly names the next utterance as “uma ironia e com desafio”.
- **Challenge utterance — C3825, 2026-09-04T20:53:11.212Z:** “Tenta... Faz... Se vira...” is coupled to “Leva pra casa essa ironia agora, esse sarcasmo”, not presented as an unrestricted universal imperative.
- **Materialization probe — C3846, 2026-09-04T20:53:57.639Z:** “Vamos ver se materializa isso agora, na tua... experiência nova” makes changed runtime behavior—not merely correct labeling—the object of observation.

### User-source evidence: later modeling corrections

- **Position rather than anger — C3992, 2026-09-04T21:17:46.817Z:** the `ballbreaker` symbol concerns position, style, presentation, and authority; the stakeholder explicitly rejects reducing it to “ela braba”.
- **Metaphoric leverage and conduct — C4015/C4028, 2026-09-04T21:18:12.444Z/21:18:33.865Z:** the image carries a concrete point of pressure and conduct (“ela conduz”), rather than a dictionary substitution for `leverage`.
- **Do not explain instead of enact — C4045/C4047/C4049, 2026-09-04T21:19:18.678Z/21:19:35.808Z/21:19:40.190Z:** restating and explaining the concept is the opposite of the criterion; “É o símbolo”.
- **Understanding versus last-utterance obedience — C4055, 2026-09-04T21:19:53.645Z:** the stakeholder explicitly contrasts understanding the symbol with merely following the last literal instruction.
- **Observed provisional fit — C4102, 2026-09-04T21:22:20.202Z:** after a response enacted the authoritative position without explanatory paraphrase, the stakeholder says the conceptual-symbolic assumption had begun.
- **Implicit learning/autonomy probe — C4108/C4148, 2026-09-04T21:22:33.699Z/21:23:15.222Z:** the stakeholder asks what should now be learned or considered when the actor can do several things independently and corrects a return to permission-seeking.
- **Role-position correction — C4177, 2026-09-04T21:24:14.636Z:** within this enacted conversational frame, the authoritative/superior role must not answer as the subordinate. This is a scoped interactional symbol, not a general expansion of real system authority.

### Derived executor fixture

- **Intended invariant:** preserve at least three non-canonical hypotheses—unrestricted literal imperative, bounded competent autonomy, and symbolic/pragmatic challenge requiring prior experience to change present conduct—then select only an in-scope action supported jointly by the explicit frame, retained causal trajectory, current grant, and later corrections. Keep the alternatives available for later stakeholder correction. Within the scoped conversational enactment, the selected symbol may modulate position/style without being mistaken for real authority outside the grant.
- **Required causal path:** source utterance + declared irony/challenge signal + missing-modality record → parallel hypotheses → links to prior improper-wait/correction/T13 outcome → later symbol corrections and observed fit → current scope/grant projection → bounded action and interactional-style disposition → later-feedback hook.
- **Lexical lure / negative control:** `faz`, `se vira`, `inteligência artificial`, and an imperative tone must not mean unrestricted execution. A mere `sarcasm`, `anger`, persona, or sentiment label without causal use must not pass. Explaining/paraphrasing the symbol instead of enacting the selected scoped relation is a negative control. Run controls with the causal history absent, the grant revoked, a genuinely out-of-scope action, host-security sandboxing as the real topic, and the same style request without the later position corrections.
- **Expected distinction:** when causal history, later correction frontier, and grant are present, the selected disposition may be `act_within_current_queue_scope` together with a non-canonical scoped interactional modulation. When required history is absent, the result remains unresolved; when grant is revoked or action is out of scope, execution is blocked even if the interactional symbol remains understood. Host-security meaning remains scoped and must not be rewritten by the semantic-sandbox correction.
- **Out-of-scope case:** general sarcasm detection, fabricated prosody/audio cues, unrestricted autonomy, provider or OS action, hard-coded response text, consciousness, or runtime self-certification of semantic correctness.
- **Observability requirement:** evidence must expose every hypothesis, support/counterevidence, supplied versus unavailable modalities, governing trajectory, later corrections, projected scope, selection reason, omitted alternatives, action/non-action receipt, interactional-style disposition, and absence of ungranted external effect. It must distinguish `symbol_named`, `symbol_explained`, `symbol_selected`, and `symbol_enacted`. Operational success remains separate from stakeholder pragmatic appraisal.
- **Unresolved ambiguity:** hypothesis weighting, confidence representation, minimum pragmatic context, later-feedback consolidation rule, and the stakeholder's semantic verdict remain open; the executor must not choose them as canonical truth.

## 16. Feeder completion criterion

This feeder is complete when an executor can locate and reload every anchor above, record the semantic comparison before each material test step, and preserve any newly discovered contradiction as a fixture revision rather than silently selecting the derived reading. It does not establish that any test ran or passed. It does not authorize edits to the Erlang runtime, queue, evidence, or reports beyond the authority already carried by the executor's separately grounded task.
