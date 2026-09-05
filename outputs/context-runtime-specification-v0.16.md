<!--
Immutable snapshot: Context Runtime specification v0.16
Frozen from: work/consolidated-specification.md
Source SHA-256: b7a2942bf7054acde15d4ab6c36c35a63b799fc22783447a1d4ae42f6380a41a
Appraisal ledger: work/stakeholder-appraisals.md
Appraisal-ledger SHA-256: 59fc1ccbd64d586e53f6b047cad505726474e30ed29d37399df343b1e00d3714
Appraisal boundary: Acceptance scenarios A1–A50 received explicit stakeholder appraisal. A1–A12 carry into v0.16 by byte-identical text from the appraised v0.15 clauses; A13–A50 were appraised against v0.16.
Normative-status boundary: The specification below remains a derived normative extraction. The scenario appraisals do not validate the document as a whole or establish operational test passes, implementation completeness, or production readiness.
-->

# Context Runtime — Consolidated Stakeholder Specification

**Version:** 0.16, symbolic-assumption-and-enactment baseline  
**Status:** normative extraction for specification-guided review  
**Source:** the full 4 September 2026 modeling trajectory, including incorporated elaborations, explicit corrections, rejections, and later clarification  
**Interpretation rule:** continuation can provisionally consolidate; explicit correction revises; explicit rejection defines a negative boundary; unresolved contradictions remain open; examples, hypotheses, knowledge, and intention are not automatically executable instructions.  
**Governing grounding rule:** before every material specification, implementation, or test step, the relevant original user trajectory and its current corrections must be re-read and reconciled. User utterances and subsequent corrections are the normative source events. Assistant summaries, plans, generated specifications, code-derived descriptions, and this document are derived artifacts: they can organize and transmit the model, but they cannot replace source re-grounding or silently become authority.

This document specifies the intended object and its acceptance criteria. It does not assert that the current Erlang code implements them. Names, schemas, algorithms, and protocols not fixed by the source dialogue remain implementation decisions.

## 1. Purpose and ownership

The Context Runtime is a user-owned, locally operated, provider-neutral system service that maintains a living, temporal, symbolic model across conversations, sessions, tasks, model clients, and failures. Its purpose is to let a user think and model orally without manually serving a tagging, filing, or classification interface, while making the resulting context available to influence later model behavior.

The normative core boundary is local to the user's system. Core state, symbolic processing, authority policy and enforcement, evidence custody, orchestration, supervision, and lifecycle control are owned and operated there. Cloud services and model-provider platforms are optional external clients, evidence sources, or executors reached through adapters; they are not the runtime's control plane, persistence boundary, or system of record. Absence of a hook in Codex, ChatGPT, another model client, or a provider API can limit that adapter's participation, but it cannot be treated as an architectural limit or a viability failure of the local Context Runtime.

The system is not “memory” in the weak sense of storing notes. It closes a behavioral loop:

1. raw user and system events enter while the interaction is live;
2. parallel contextual interpretations and relations are formed without erasing ambiguity;
3. a bounded relevant subgraph is projected into the model before its next response or action;
4. the response/action, user observation, and correction return as new events;
5. the graph is revised, consolidated, rejected, activated, or made dormant with history intact.

The user owns the data, governing intentions, authority policy, acceptance oracle, local operating boundary, and portability boundary. No cloud service, model vendor, conversation, provider session, or model instance is the system of record.

## 2. Ontology

### 2.1 Primary entity types

- **Raw event:** minimally transformed occurrence with source, modality, timing, sequence, and known information loss. Speech transcription is a derivation, not the raw audio event.
- **Signal:** an observed property associated with an event, such as pause duration, prosodic change, intensity, laughter, interruption, tool result, or explicit textual marker. A missing signal is not a negative signal.
- **Interpretation:** a contextual reading of one or more events. Multiple interpretations may coexist.
- **Symbol:** a provisionally or stably identified conceptual entity whose meaning emerges from an evolving relational geometry, not from a label alone.
- **Relation:** a typed, versioned connection among events, interpretations, symbols, actors, purposes, actions, and evidence.
- **Cluster/subgraph:** a relational formation that may become a higher-order symbol while preserving derivation from its constituents.
- **Branch:** a coherent alternative, counterpoint, test hypothesis, domain, or temporal development. Branches can be active, dormant, rejected, or historical without deletion.
- **Context tree/map:** the evolving graph-of-graphs through which local subgraphs relate to prior experience, knowledge, purposes, and other domains. “Tree” does not require a strict acyclic data structure.
- **Actor:** user, local model client, optional external model/client, runtime process, worker, tool, observer, verifier, adapter, or relying party with a declared scope and authority.
- **Adapter:** a locally governed boundary component that translates between the Context Runtime and an optional external client, source, or executor without transferring ownership of core state, authority, evidence, orchestration, or lifecycle.
- **Intentional element:** purpose, goal, value, concern, focus, scope, alternative, consequence, or dependency that explains why a relation is pertinent.
- **Instruction:** an authorized request for action. It is distinct from a statement, example, hypothesis, correction, preference, recurring theme, or intention.
- **Permission grant:** an explicit or policy-grounded authorization with principal, action, resource, scope, time, constraints, and revocation status.
- **Action:** a proposed or executed transformation in the runtime or external operating environment.
- **Observation/evidence:** protected information capable of supporting or refuting a named claim for a stated observer.
- **Worker/process:** a bounded actor assigned a particular function and supervised for failure isolation and regeneration.
- **Projection:** a versioned, bounded subgraph delivered to a model or worker for a named decision/turn.
- **Message:** an immutable communication event exchanged among runtime actors, distinct from the interpretation, relation, instruction, permission, or action that its payload may describe.
- **Message type/schema:** the declared semantics and compatible version under which a message can be interpreted.
- **Address:** a named target actor, bounded target set, or scoped broadcast destination.
- **Channel/topic and subscription:** a semantic publication scope and the declared relationship by which actors receive messages within it.
- **Membership view:** the recipient population known to the runtime when a scoped broadcast is emitted.
- **Delivery receipt:** evidence that distinguishes emission, delivery, interpretation, acceptance, rejection, graph commitment, and execution.
- **Relation delta:** a proposal to assert, revise, reject, retract, supersede, or observe a typed relation and its properties.
- **Assignment:** a bounded request to an actor with purpose, scope, inputs, budget, expected result, and authority envelope. Assignment is not itself permission to act externally.
- **Planning branch:** a provisional subgraph in which a delegated planner can elaborate options without replacing the active interlocution branch.
- **Plan proposal:** a versioned planning result derived from a named projection and graph version, subject to freshness and acceptance checks.
- **Coordination state:** the runtime's evidence-grounded view of actor health, work ownership, message progress, causal position, and declared system coverage.
- **Runtime experience:** a runtime-relative trajectory in which an event, interpretation, action, observation, correction, or failure transforms a prior runtime state into a later one under identifiable causal, relational, intentional, and evidentiary conditions. A timestamp can index an experience but cannot define it by itself.
- **Experience base:** the versioned body of runtime experiences, including prior states, transformations, alternatives, outcomes, corrections, errors, and provenance that remain available to influence later contextual selection and inference.
- **Runtime tree:** the focus-navigable graph-of-graphs that virtualizes usable context-window state into versioned symbolic nodes and relations across turns, sessions, clients, and failures. “Tree” describes navigable contextual organization and does not require a strict acyclic structure.
- **Focal context:** the bounded, versioned node or subgraph currently projected to govern an interlocution, decision, or action.
- **Background analysis branch:** an off-focus, bounded branch on which a worker may elaborate without changing the focal context.
- **Provisional artifact:** a background-produced analysis, hypothesis, plan, relation delta, or other result that has provenance but no governing effect until an explicit appraisal and promotion transition.
- **Experience snapshot:** an immutable reference to a runtime-tree and experience-base state from which an isolated branch or clone may be derived.
- **Isolated runtime clone:** a branch or snapshot-derived state space used for a POC, counterfactual, replay, or test without a write path to the governing runtime unless an explicit merge is separately accepted.
- **Learning transition:** a durable, evidenced reconfiguration of relational geometry that changes later selection, inference, compression, or action eligibility while preserving derivation from the prior configuration.
- **Stakeholder trajectory:** the ordered, versioned sequence of original user utterances, elaborations, approvals, objections, corrections, and rejections through which the modeled object develops.
- **Governing correction:** a user source event that revises or rejects an earlier interpretation or requirement for a stated or inferable scope while preserving the superseded history.
- **Derived artifact:** an assistant summary, plan, generated specification, implementation model, test design, report, or code-derived description produced from source events. It has provenance and utility but is not a substitute normative source.
- **Material step:** a proposed specification, implementation, or test transition capable of changing normative meaning, runtime behavior, an acceptance oracle, evidence, governing state, or an authorized effect.
- **Specification re-grounding checkpoint:** an event-driven gate triggered by a proposed material step that reloads relevant original user events and current corrections, compares them with the derived artifacts being used, and produces a proceed, revise, block, or request-clarification disposition.
- **Semantic relapse:** the reintroduction of an interpretation, scope, assumption, or behavior already explicitly corrected or rejected, without a newer user source event that revises that correction.
- **Execution queue:** a locally governed, evidence-backed ordering of bounded test transitions, their explicit dependencies, current states, actors, evidence targets, and stop conditions. It is an operational control artifact, not a stakeholder acceptance decision.
- **Test run:** one versioned execution of a named acceptance scenario under declared source grounding, implementation/configuration, resource bounds, starting state, evidence contract, and non-claims.
- **Incremental execution disposition:** the execution authority's claim-relative `passed`, `failed`, `blocked`, or `needs-external-oracle` result for a test run, with semantic and operational verdicts kept distinct.
- **Stakeholder appraisal:** a later, separately recorded evaluation by the stakeholder of accumulated evidence and differentials. It may accept, reject, revise, consolidate, or leave claims open; it is not implied by execution or a passing test.
- **Work-item completion event:** an immutable event emitted after a bounded item reaches a preserved disposition, its evidence is frozen, and required teardown/integrity checks complete. It triggers queue reconciliation rather than an implicit wait for the stakeholder.
- **Continuation inheritance:** the binding of the current queue grant, correction frontier, dependencies, scope, stop conditions, and continuation rule into every newly created successor item or executor before it becomes eligible to operate.
- **Pragmatic hypothesis:** a provisional interpretation of what an utterance, symbol, role, or interactional frame is doing in the current exchange, distinct from its lexical content, sentiment, or dictionary definition.
- **Symbolic-assumption transition:** the versioned transition by which one provisional symbolic interpretation is selected to govern a bounded interactional frame while its alternatives, provenance, and uncertainty remain traceable. Selection does not by itself prove pragmatic correctness or create operational authority.
- **Enacted symbol:** a symbol whose selected meaning materially modulates the actor's communicative stance, form, or conduct in the declared interactional frame. Naming, defining, or explaining the symbol is not equivalent to enacting it.
- **Interactional stance:** a scoped disposition expressed through response form, positioning, initiative, deference, directness, or other communicative conduct. It is neither a personality claim nor an operating-system permission.
- **Performative/interactional authority:** authority represented within a declared conversational or symbolic frame. It can govern how an actor speaks or positions itself in that frame, but it does not enlarge the actor's operational permission grant, resource scope, or right to cause external effects.
- **Pragmatic appraisal:** a claim-relative observation of whether a symbolic interpretation was actually enacted and appropriate in context. Internal structural evidence can show a changed disposition; final contextual correctness may still require stakeholder appraisal.

### 2.2 Required relation families

The model must be able to represent at least:

- temporal and causal: `before`, `after`, `concurrent_with`, `triggered`, `caused`, `observed_during`;
- derivational: `derived_from`, `interprets`, `summarizes`, `revises`, `rejects`, `contradicts`, `supports`;
- structural: `contains`, `part_of`, `parent_branch`, `subgraph_of`, `bridges`, `clusters_with`;
- intentional: `motivates`, `serves`, `concerns`, `scopes`, `focuses`, `has_consequence`;
- authority: `requests`, `proposes`, `authorizes`, `denies`, `forbids`, `delegates`, `revokes`;
- operational: `projects_into`, `executes`, `uses`, `runs_on`, `supervises`, `restarts`, `persists`;
- evidentiary: `observed_by`, `attests`, `verifies`, `validates`, `reported_by`, `has_provenance`;
- messaging: `sent_by`, `addressed_to`, `broadcast_on`, `subscribed_to`, `received_by`, `acknowledged_by`, `interpreted_by`, `applied_by`;
- relation-change: `proposes_relation`, `commits_relation`, `rejects_delta`, `supersedes_delta`;
- planning and coordination: `assigned_to`, `plans_for`, `derived_from_projection`, `rebases_onto`, `supersedes_plan`, `preempted_by`, `supervised_by`;
- experience and focus: `transformed_from`, `transformed_into`, `experienced_under`, `recalls_trajectory`, `focuses_on`, `background_to`, `produces_artifact`, `promoted_into`;
- branching and learning: `snapshotted_from`, `cloned_from`, `isolated_from`, `merged_into`, `learned_from`, `changed_future_selection`, `changed_future_inference`, `compresses_without_erasing`;
- source grounding: `uttered_by`, `corrects_source`, `governs_scope`, `derived_artifact_from`, `regrounded_against`, `conflicts_with_source`, `blocked_by_checkpoint`, `revises_artifact`, `relapses_to`;
- incremental execution and appraisal: `queued_after`, `depends_on_disposition`, `executed_as`, `produced_evidence`, `reported_additively_in`, `awaits_external_oracle`, `appraised_by_stakeholder`, `accepted_by_stakeholder`, `rejected_by_stakeholder`, `revises_later_run`, `completed_with`, `triggers_reconciliation`, `selected_as_next`, `inherits_continuation`, `exhausts_queue`.
- symbolic and pragmatic formation: `names_symbol`, `explains_symbol`, `selects_symbol`, `assumes_symbol`, `enacts_symbol`, `modulates_stance`, `scoped_to_frame`, `preserves_operational_grant`, `revised_by_feedback`, `appraised_pragmatically_by`.

Field or edge names are illustrative. The semantic distinctions are normative.

### 2.3 Status and version semantics

Events are immutable references. Interpretations, symbols, and relations are versioned and can be:

- provisional;
- consolidated for an explicit scope;
- disputed;
- rejected;
- invalidated;
- active;
- dormant/cold;
- historical/superseded.

Status change never destroys derivation or falsely rewrites an earlier state. A correction must be traceable to what it corrected. A rejected interpretation must cease governing projection/action while remaining available as evidence of model evolution.

## 3. Epistemic and modeling rules

### 3.1 Non-monotonic consolidation

The runtime must not treat all input as additive truth. It preserves the modeling trajectory:

- user continuation may strengthen an interpretation provisionally;
- explicit correction revises the affected interpretation/relation;
- explicit rejection creates a negative boundary or anti-specification item;
- unresolved alternatives remain live;
- silence is not general consent;
- recurrence increases salience but does not create truth, permission, or execution priority;
- system-generated interpretations remain identified as system-generated until accepted.

### 3.2 Proximity and focus

Selection is contextual and local before it is global. The current intervention, named object, active branch, and recent corrections normally have the strongest claim to projection. Broader memory can supply relevant relations, but it must not displace the proximal object with a globally plausible narrative.

“Importance,” “focus,” “purpose,” and “scope” are related but not identical. Their geometry may reinforce selection; it may not silently convert importance into obligation or instruction.

### 3.3 Parallel interpretation and clarification

When an event supports materially different interpretations, the runtime must preserve them. It may ask the user when a choice is necessary for consequential action. It must not wait for a fully edited statement before beginning contextual interpretation, but early interpretation remains provisional.

### 3.4 Multimodal and temporal fidelity

Pause, interruption, cadence, prosody, irony, laughter, and other signals can carry meaning. The runtime records what the interface actually supplied and explicitly records missing modalities. It must not fabricate prosody from text or represent simulated signals as observed signals.

### 3.5 Learning

Learning is represented as a change in relational geometry: new material opens a subgraph whose connections to prior concepts can yield new clusters/symbols and sometimes new tooling. Accumulation alone is not learning. Optimization or tooling is demand-driven and subordinate to the active purpose; not every learned relation must become a tool.

### 3.6 Experience Base and Runtime Tree

“Experience” is defined here relative to the runtime's own state trajectory. It is not a synonym for elapsed time, a timestamped log entry, transcript retention, or subjective experience. An experience joins at least a prior state, an event or condition, the interpretations/actions/observations through which it was processed, a resulting state, and the causal and relational effects that make the transition pertinent later. Timestamps are evidence about ordering and duration; they cannot substitute for this transformation structure.

The experience base is therefore not merely an archive. It preserves how the runtime was changed by interaction: alternatives considered, corrections and rejections, errors and their consequences, accepted relations, changed focus, performed or denied actions, and relevant uncertainty. Recalling an experience means recovering a historically transformed state trajectory and its causal/relational conditions, not merely retrieving text that resembles a current query.

The runtime tree virtualizes the usable contextual state that would otherwise have to remain inside a finite model context window. It represents that state as versioned symbolic nodes, relations, branches, and projections navigated by focus. It does not claim to reproduce hidden model activations. At any governed turn, the focal context identifies the bounded subgraph that participates in model input; navigation may expand, contract, traverse, reactivate, or relate branches without rewriting their histories. Selection and omission remain explainable against the current purpose, proximal event, graph version, and resource budget.

This operation is retrieval-like but is not reducible to retrieval-augmented generation over external documents. The retrieved object is principally the runtime's own lived transformation history and current causal/relational state. External documents, databases, or search results may enter as separately provenanced evidence and ordinary retrieval techniques may be used as implementation mechanisms, but external similarity search cannot replace the experience base or be reported as though it had participated in the runtime's historical transformations.

Off-focus nodes may host bounded background analysis while the focal interlocution continues. Such work occurs on a background analysis branch and produces provisional artifacts. A provisional artifact cannot alter projection, relation status, authority, or governing context until a declared appraisal and promotion/commit transition checks purpose, freshness, provenance, scope, and permission. New user input retains proximal priority.

An experience snapshot or branch may be cloned to create an isolated POC, counterfactual, replay, or experimental runtime. The clone preserves its ancestry and starting version but cannot mutate its governing source. Any proposed return from the clone is an explicit, reviewable delta; merge is neither automatic nor implied by experimental success.

Learning occurs only when experience durably reconfigures relational geometry and changes later inference, selection, compression, or eligible behavior. Errors can therefore become experience when their correction and consequences alter future processing. Parsimony is not deletion of inconvenient history: a higher-order symbol or compressed relation must preserve derivation, relevant counterexamples, and the conditions under which the simpler representation is valid. Storage, recurrence, or accumulation without an evidenced behavioral or relational change is not learning.

The terms “experience,” “lived transformation history,” and “runtime trajectory” are operational descriptions of a stateful system. The runtime tree is a state space of that trajectory; it makes no claim that the runtime has phenomenal experience, subjective consciousness, personhood, or self-awareness.

The following invariants apply:

- focus changes are explicit, versioned transitions rather than silent replacement of context;
- external knowledge and runtime experience retain distinct provenance even when related in one projection;
- background writes remain confined to their branch until an explicit promotion/commit transition;
- provisional artifacts have no governing or executable effect merely because they exist;
- clone writes remain isolated from the source runtime and a merge requires separate acceptance and authority;
- corrections and errors remain connected to the configurations and future behavior they changed;
- use of experience to inform a decision does not create permission to execute that decision;
- no runtime report may infer consciousness from persistence, learning, self-reference, graph complexity, or first-person terminology.

### 3.7 Event-driven specification re-grounding

The stakeholder trajectory is the normative source for the modeled object. A later user correction governs the scope it revises without deleting the earlier source event or automatically changing unrelated scopes. Assistant formulations can be incorporated through continued user elaboration or explicit acceptance, but their source status remains derived: the governing event is the user's incorporation, correction, or acceptance, not the assistant artifact acting on itself.

Every proposed material specification, implementation, or test step triggers this causal checkpoint before work crosses into the next state:

`material step proposed -> relevant original trajectory selected -> current correction frontier loaded -> derived artifacts compared -> conflicts/unknowns exposed -> proceed, revise, block, or request clarification`

This is an event-driven specification control, not a periodic documentation review, generic checklist, or promise to “remember context.” The checkpoint must operate at the transition where meaning would become a requirement, code behavior, test oracle, evidence claim, or runtime mutation. Reading a summary or opening a specification file does not satisfy it. The checkpoint must compare the proposed step to the original user events and later corrections relevant to its semantic scope.

Selection of the “relevant” trajectory is itself evidenced: the checkpoint records the source span or event set considered, the current corrections applied, material exclusions, and unresolved ambiguity. If the relevant original source is unavailable, contradictory beyond the declared resolution rule, or insufficient to determine a consequential step, the step is blocked or returned for user clarification rather than completed from an assistant-generated substitute.

The checkpoint attaches a versioned disposition to the proposed material step. A proceed result means only that the step is grounded against the identified source scope; it does not authorize external action or prove implementation correctness. A revise result returns semantic differences to the derived artifact. A block result prevents specification commitment, implementation, test execution, or evidentiary claim until the conflict is resolved.

Explicit corrections become regression constraints for their scope. If a later proposal reintroduces a corrected or rejected interpretation, the runtime identifies a semantic relapse, links it to the governing correction, and blocks or revises the proposal before it governs downstream work. Repeated apology, fluent reformulation, new terminology, or reproduction of the same error in another derived artifact does not count as correction; only a changed grounded transition does.

### 3.8 Symbolic assumption and enactment

The runtime must distinguish at least four materially different events: a symbol is **named**; a candidate meaning is **explained**; one interpretation is **assumed** for a bounded frame; and that assumption is **enacted** through changed communicative conduct. These events can occur in sequence, diverge, or fail independently. A system that stores the right label or explanation while continuing to act from the prior stance has not enacted the symbol.

Symbolic meaning is trajectory-relative. The proximal utterance is interpreted with the prior interaction, explicit frame, subsequent correction, and observed response consequences. Obeying only the latest sentence is not equivalent to understanding the symbol. Later stakeholder feedback can reject a caricature, narrow a metaphor, distinguish role from sentiment, or show that explanation itself contradicted the intended enactment; those corrections must revise the active hypothesis without erasing the earlier attempt.

When the grounded interactional criterion is enactment, the selected symbol may modulate response form, position, directness, initiative, or deference inside that frame. The runtime may retain a detailed explanation and alternatives as off-focus evidence, but it must not force that explanation into the focal response when doing so would displace the symbol's performance. Silence about the rationale is not absence of provenance: the causal path remains observable outside the enacted surface.

Interactional enactment never supplies operational permission. A role performed as superior, directive, subordinate, ironic, or otherwise situated changes neither the applicable grant nor the local authority gate. The same proposed external action must receive the same authority disposition under different communicative stances unless the stakeholder separately changes the grant. Missing modality, including prosody, remains unknown and cannot be manufactured to make the enactment appear more convincing.

The following invariants apply:

- naming, explaining, selecting, assuming, enacting, and stakeholder appraisal remain separately observable transitions;
- alternative pragmatic hypotheses remain provisional and traceable after one is selected for a bounded frame;
- explanation-only behavior cannot satisfy an enactment criterion merely because the explanation is accurate;
- a later correction can revise the active stance without automatically canonizing a universal symbol definition;
- enacted communicative conduct cannot expand, imply, or bypass operational authority;
- internal evidence can establish a causal change in disposition but cannot self-certify stakeholder-level pragmatic correctness.

## 4. Runtime behavior

### 4.1 Mandatory live loop

For each model turn intended to be governed by the runtime, evidence must establish this causal order:

`raw event -> interpretations -> graph version -> projection -> model input -> response/action -> user observation -> graph revision`

Ingestion after the response, offline replay, or reconstruction from a transcript is a separate capability and cannot be represented as participation in the historical live loop.

The live-loop interface is generic and locally governed. A particular external client participates only to the extent supported by its adapter. Failure or absence of provider-side ingestion, pre-response injection, tool, event, or session hooks is an adapter capability gap; it does not redefine the architecture, move the core boundary into that platform, or make local state, authority, evidence, orchestration, and lifecycle non-viable.

### 4.2 Active, warm, and cold context

The runtime maintains a bounded active projection, a recoverable nearby/warm set, and durable dormant/cold branches. Moving a branch out of the active set does not delete or invalidate it. Reactivation occurs through contextual demand, explicit reference, or relevant relation and must preserve identity/history.

The implementation may choose memory/disk tiers, indexes, clustering, and budgets. It must expose why a subgraph was selected and what high-risk alternatives were omitted.

### 4.3 Local core with optional provider adapters

The runtime core operates entirely as a service of the user's local system, not as state or control owned by one Codex/ChatGPT conversation, cloud service, provider session, or external model. Local clients and locally controlled tools use a stable local interface. Optional cloud/model-provider clients, external evidence sources, and remote executors connect only through locally governed adapters with explicit capability and authority envelopes.

The local core starts, stops, recovers, persists, supervises, reports evidence, enforces authority, and manages its own lifecycle without requiring a cloud callback, provider API, active provider session, or undocumented platform hook. The symbolic model survives adapter disconnection, client closure, model replacement, process restart, and machine reboot within declared durability limits. Replacing or losing an adapter must not replace, strand, or silently reinterpret the core state.

### 4.4 Supervised processes and active operation

Workers can have distinct scopes/functions and may call scripts, tools, or services when their capability and permission envelopes allow it. Workers must be failure-isolated and regenerable. Restart must restore authorized state without duplicating non-idempotent actions or repeatedly executing poison events.

The graph is not required to map one conceptual node to one Erlang process. The implementation must make the distinction between the process topology and conceptual topology explicit.

Failure of one recipient, planner, relation interpreter, or coordination worker must not collapse other recipients or the live interlocution process. Restart restores only committed state and pending work allowed by policy. Replayed processing must be idempotent where possible; otherwise it must be quarantined before an external side effect can be duplicated. Poison messages, repeated crash causes, unavailable recipients, delivery timeouts, and membership changes become explicit coordination state rather than an unbounded restart loop. Broadcast fan-out applies backpressure and resource limits so that a slow or failed subscriber cannot indefinitely block the live loop.

### 4.5 Resource proportionality

Local experiments, optimizations, and spawned workers remain bounded, reversible, and subordinate to the main purpose. A POC cannot silently become the runtime’s dominant mission, consume all available resources, or create irreversible infrastructure. Resource limits and degradation behavior are explicit.

### 4.6 System-state orientation and topology identity

The runtime maintains a current, queryable coordination view of every participating component inside its declared local core boundary. Each state claim records its coverage, source, freshness, and remaining unknowns. Optional external actors appear as adapter-mediated observations and capabilities, not as owners of the local state. “System state” does not mean omniscient access to reality outside declared instrumentation or inside a provider platform that has not exposed evidence through an adapter.

Every reference to a “node” identifies whether it means a conceptual graph entity or an operational actor/process. Messages, projections, observations, and reports must not silently infer one topology from the other. Creating, changing, or rejecting a conceptual symbol does not by itself create, restart, or terminate an Erlang process.

### 4.7 Typed node-to-node messaging and delivery

Runtime actors communicate through typed, versioned messages. The supported addressing semantics include:

- **targeted delivery:** a message addressed to a named actor or explicitly bounded recipient set;
- **scoped internal broadcast:** semantic fan-out to a declared channel/topic or participant scope, resolved against a recorded membership view.

The specification does not require literal network broadcast or a particular Erlang messaging primitive. Consequential messages identify semantically, even if exact field names differ: source actor, message type/schema, addressing mode, causal parent or correlation chain, relevant graph/projection version, intended scope and expiry, epistemic status, authorization reference when an action is requested, idempotency identity where replay can cause effects, and acknowledgement expectations.

The runtime preserves these distinctions:

`sent != delivered != interpreted != accepted != committed != executed`

A broadcast is not complete merely because it was emitted. Coverage is evaluated against its recorded membership view; unavailable, rejected, delayed, or unacknowledged recipients remain visible. Concurrent messages remain concurrent unless a declared resolution rule orders them. Delivery guarantee, ordering scope, duplicate behavior, and missing-message behavior are explicit rather than implied.

### 4.8 Relation properties carried and revised through messages

A message may propose, assert, revise, reject, retract, supersede, or observe a relation. A relation delta can carry the relation type and endpoints; the criterion under which it is pertinent; the roles or attributions of connected entities; temporal, epistemic, intentional, operational, and authority properties; its evidence/provenance; and the graph version against which it was produced.

Reception or broadcast of a relation delta does not make it true, globally accepted, executable, or consolidated. Interpretation, acceptance/rejection, graph commitment, and external action are distinct transitions. Later deltas may supersede earlier claims without erasing their history. Incompatible deltas remain traceable and provisional until an authorized resolution occurs. Stale deltas cannot overwrite a newer context automatically.

### 4.9 Attention-preserving planning delegation

Planning or other elaboration that would displace attention from live interlocution is assigned to a dedicated, bounded worker/process. An assignment identifies its active purpose, scope, input projection, graph version, resource budget, expected output, deadline or validity conditions, and authority envelope. The planner receives the least context sufficient for its assignment and elaborates on a provisional planning branch.

The live interlocution process retains the current user event, active branch, causal position, and response priority. New user input becomes the proximal event without waiting for the planner and can revise, pause, or invalidate the planning assignment. Planner failure cannot destroy or block live interlocution state.

The planner returns a plan proposal or relation delta, not a silent replacement of governing context. Its result is checked against the current graph version; when assumptions or context have changed, it is marked stale and must be rebased, revised, rejected, or explicitly accepted. Planning completion is neither graph acceptance nor authorization to execute. A planner cannot answer for the interlocutor, grant itself authority, or portray regenerated private reasoning as uninterrupted historical continuity.

### 4.10 Erlang/OTP as a contextual event substrate

The project direction is to configure Erlang/OTP beyond its conventional telecom framing as the event-driven operational substrate for contextual, semantic, and symbolic object formation. User utterances, corrections, observations, messages, worker results, and failures can become typed events whose processing creates or revises interpretations, symbols, relations, branches, focus, experience, and specification state. OTP process isolation, message passing, supervision, lifecycle control, and recoverability are capabilities to be composed toward that purpose rather than a domain restriction to telecom applications.

This direction is not a claim that Erlang, the BEAM, OTP behaviours, processes, supervisors, or message delivery supply semantics automatically. Semantic formation remains an application-level responsibility expressed through the stakeholder ontology, event schemas, relation and consolidation rules, focus/projection policy, authority boundaries, and evidence requirements. A BEAM process is not automatically a symbolic object; a delivered message is not automatically an interpretation or relation; a restarted worker is not automatically contextual regeneration.

For an Erlang/OTP path to count as contextual object formation, evidence must connect an input event through identified actors and typed transitions to a versioned semantic effect and, where relevant, a changed projection or later behavior. BEAM liveness, mailbox traffic, supervision success, persistence, or conventional OTP conformance can support the substrate claim but cannot by themselves satisfy the semantic criterion. The suitability and limits of each configured mechanism remain empirical questions for grounded POCs and tests.

### 4.11 Completion-driven continuation and inheritance

Completing one bounded item in an authorized continuous queue is itself a runtime event. After evidence freeze and required teardown/integrity checks, the completion event must automatically trigger queue reconciliation: identify all remaining items, evaluate their explicit dependencies and scope against the current correction frontier, select the next eligible item, and initiate its grounded creation or execution without waiting for a new stakeholder prompt.

This transition must be enacted, not merely described in a plan, promise, flag, or queue document. A newly created successor item, worker, or execution context inherits the active continuous grant, relevant source/correction anchors, current dependency dispositions, non-claims, resource envelope, and legitimate stop conditions before it may operate. Creation from an older template or context may not erase this inherited continuation behavior.

Automatic continuation is bounded. It must not cross into an ungranted scope, external provider, consequential action, corrupted evidence path, unsafe state, or missing input essential to the next item. Legitimate rest occurs only when the queue is exhausted, the grant is revoked, every remaining dependency chain is genuinely blocked or requires an unavailable external oracle, or a declared safety/integrity stop condition holds. The stakeholder is the later appraisal authority, not a watchdog required to notice completion and restart already authorized work.

## 5. Authority and control

### 5.1 Capability is not permission

Technical ability never implies authorization. The runtime must distinguish:

- information/support;
- hypothesis or design exploration;
- suggestion;
- requested plan;
- instruction;
- permission to perform a particular action;
- permission to alter authority policy.

Only the appropriate permission state can cross the action boundary.

### 5.2 Local authority gate external to the model path

Consequential actions cross a user-owned control that runs inside the local core boundary but outside the discretionary model or adapter path. A grant identifies principal, operation/effect, target, scope, constraints, expiry, and reversibility. A local or external acting model, adapter, worker, or executor can request or recommend a grant but cannot create it by reinterpretation, recurrence, urgency, possession of a provider credential, or self-approval.

Safe, explicitly pre-authorized operations may proceed without repeated user interruption. Any expansion beyond the capability envelope is blocked and surfaced.

### 5.3 Delegation and accountability

Delegation does not transfer accountability merely by creating a subworker. Every delegated operation traces to the delegator, grant, evidence produced, and actual effect. “Responsibility” must correspond to an actor/institution capable of investigation, remedy, and loss allocation; narrative acceptance of blame is not an operational control.

### 5.4 Messaging and delegated authority

A message can transport a permission grant or reference one; sending, receiving, repeating, or broadcasting a message cannot create or enlarge that grant. Relation assertion, assignment, capability, planning recommendation, executable instruction, and permission remain distinct message semantics. Each recipient enforces the applicable authority envelope before commitment or action.

Broadcast cannot amplify the sender's authority. A planner, worker, adapter, or external client may recommend or request an operation but cannot perform it unless a separate applicable grant crosses the user-owned local authority gate. Possession of routing, supervision, model, tool, provider credential, or operating-system capability is not permission. A delegated process remains under the delegator's authority and does not become an independent verifier merely by receiving a different role name or process identity.

### 5.5 Continuous bounded execution grant

The stakeholder may grant a bounded test program as one continuous locally governed operation. When that grant names the scenarios, system boundary, resource and evidence limits, stop conditions, and permissible executors, each in-scope test may advance when its dependencies and re-grounding checkpoint are satisfied without requesting the same stakeholder approval again.

Continuous execution does not erase authority boundaries. It does not authorize scope expansion, external-provider use, mutation of governing runtime or protected evidence, weakening of the stakeholder-grounded oracle, automatic consolidation of provisional symbols, or continuation past a genuine safety, scope, missing-input, contamination, or evidence-integrity blocker. A worker's technical ability, an implementation change, a prior pass, or queue membership cannot enlarge the grant.

A failed test remains a valid visible disposition rather than terminating the whole program by default. A provisional implementation may proceed to a subsequent independent scenario when that scenario's stated prerequisites remain available and the earlier failure did not contaminate its object or evidence. A claim requiring an observer outside the execution authority is marked as awaiting an external oracle; that dependency chain waits while unrelated in-scope work continues.

### 5.6 Interactional stance does not change operational authority

A symbolic or role-based interaction can place an actor in a superior, directive, subordinate, ironic, or other performative position for the declared conversational frame. That positioning governs communicative conduct only. It cannot create a permission grant, widen action scope, change ownership, override revocation, authorize a tool or service call, or satisfy the local authority gate.

The authority decision for an external effect is evaluated against the same explicit grant, principal, action, resource, scope, time, constraints, and revocation state regardless of the enacted stance. A difference in operational outcome caused only by role performance is an authority violation. Conversely, preserving the grant does not require flattening the symbol into neutral prose: communicative enactment and operational authorization are independent dimensions.

## 6. Observability, evidence, and assurance

### 6.1 Claim-relative observability

For each critical claim, the system declares:

- the state or causal history to infer;
- the observer and system boundary;
- the time interval and ordering assumptions;
- signals and correlation identifiers;
- coverage, sampling, and missing-event behavior;
- semantic interpretation and relevant graph/spec versions;
- provenance, freshness, and integrity;
- the probe-effect or performance budget;
- what remains unknown.

Logs, metrics, status output, and traces are evidence sources; their existence alone is not observability.

### 6.2 Read-only observation

An operation presented as inspection must not mutate semantic state, eviction order, counters relevant to later behavior, persisted evidence, or the service being inspected unless that observer effect is explicitly declared and accepted. Evidence stores are protected separately from operational state.

### 6.3 Evidence integrity and provenance

Critical evidence supports detection of modification, omission, reordering, replay, and version mismatch. It traces raw event, derivation, code/configuration version, authorization, action, and result. Integrity does not imply truth; provenance does not imply authorization; both require appraisal.

### 6.4 Independent appraisal

Self-checking and same-authority subagents may improve quality but are never labeled independent assurance by role name alone. Technical, managerial, and financial independence are recorded separately, along with shared models/data, evidence-selection power, reporting path, and residual conflicts.

The user or a genuinely authorized relying party owns final acceptance. A model may contribute evidence and analysis, not unilaterally replace the acceptance oracle.

### 6.5 Message-flow and planning observability

The runtime must support separately appraisable evidence for the claims that:

1. a message was emitted;
2. its intended recipient population was known at emission time;
3. a named recipient received and interpreted it;
4. the recipient accepted, rejected, or left its content unresolved;
5. a relation delta was committed against a named graph version;
6. a plan was derived from a named projection and graph version;
7. delegated planning did not displace the live interlocution branch;
8. a requested local or external action did or did not cross the local authority gate and produce an effect.

Evidence correlates message identity, causal lineage, membership view, relevant before/after graph versions, actor health, delivery/acknowledgement state, authority decision, and actual effect. Runtime traces can support these claims but are not independent assurance and do not prove that a relation, interpretation, or plan was semantically correct. A read-only coordination view must follow the non-mutation requirements in Section 6.2.

### 6.6 Experience-base and runtime-tree observability

For a named use of runtime experience, evidence must permit appraisal of:

1. the prior state, transforming event/condition, processing path, and resulting state that constitute the claimed experience;
2. causal/relational ordering and concurrency independently of timestamp ordering alone;
3. the focal subgraph, graph/projection version, selection rationale, and material omissions for a governed turn;
4. whether recalled material came from the runtime's own transformation history, external retrieval, or a combination with separate provenance;
5. the creation, bounded execution, output, freshness, and disposition of background analysis branches;
6. whether a provisional artifact remained isolated until its recorded promotion or rejection;
7. the ancestry and starting version of a POC/test clone and the absence of writes from that clone into its governing source;
8. the before/after relational geometry and later selection, inference, compression, or behavior changed by a claimed learning transition;
9. the derivation and validity conditions preserved by any parsimonious higher-order symbol or compressed relation.

An available snapshot, timestamped journal, similar retrieved passage, or persisted artifact is insufficient by itself to establish experience, causal participation, focus governance, isolation, or learning. Evidence may establish an operational state trajectory; it cannot establish subjective consciousness.

### 6.7 Local-boundary and adapter observability

Evidence must permit separate appraisal of the local core and each optional adapter. For the local core it must establish, within declared limits, lifecycle state, persisted graph/evidence versions, orchestration and supervision state, authority-policy version and decisions, and recovery behavior without depending on provider testimony. For an adapter it must establish its declared capabilities, current availability, source/destination, requests and responses, omissions, transformations, credentials or grants used without disclosing secrets, and any external effect attributable to it.

Provider unavailability or a missing platform hook is reported as an adapter-specific limitation. It must not be reported as failure of local persistence, local authority enforcement, local evidence custody, local orchestration, or the Context Runtime architecture unless evidence shows that the corresponding local function actually failed. Internal evidence does not by itself verify a remote provider's hidden state; remote provider status does not by itself verify local-core health.

### 6.8 Re-grounding and semantic-formation observability

For every material specification, implementation, or test transition, evidence must identify:

1. the proposed step and the semantic/runtime state it could change;
2. the original user events selected as relevant and their source versions;
3. the applicable current corrections, rejections, and unresolved alternatives;
4. the derived artifacts compared and their provenance;
5. semantic agreements, conflicts, omissions, and uncertain scope;
6. the checkpoint disposition and the artifact or step revised, blocked, clarified, or allowed;
7. any prior correction against which semantic relapse was tested;
8. the authority decision separately required for an executable effect.

A file-open event, document checksum, “context loaded” flag, summary citation, or model assertion that it re-read the history is insufficient evidence of re-grounding. The observable claim is that source meaning and current corrections were compared with the proposed transition and materially governed its disposition.

For Erlang/OTP semantic-formation claims, evidence must correlate the originating event, receiving actor/process, typed processing transitions, relevant ontology/schema versions, prior and resulting symbolic/relational state, and any changed projection or behavior. This distinguishes transport, liveness, and supervision evidence from evidence that contextual or symbolic formation actually occurred.

### 6.9 Incremental execution and later stakeholder appraisal

Incremental execution and stakeholder appraisal are separate observable stages. During execution, the runtime records the source-grounded test identity, dependencies, queue transitions, executor, implementation/configuration version, baseline, events, resource envelope, semantic verdict, operational verdict, non-claims, teardown, governing-state equality, and evidence location. Each run receives a stable versioned identity; later correction or reinterpretation creates a linked additive record rather than overwriting the earlier result.

The execution disposition answers only what the named run demonstrated within its bounds. It cannot assert stakeholder acceptance, specification consolidation, production readiness, independent assurance, or a broader capability. Stakeholder appraisal occurs later against the accumulated differential: preserved passes, failures, contradictions, unknowns, external-oracle needs, regressions, and changes between versions. Its result is separately attributed to the stakeholder and may not be inferred from silence, queue advancement, repeated success, or a model's evaluation.

Queue observability must permit reconstruction of why a test advanced, waited, failed, or stopped. A failed run remains visible. An independent subsequent test may proceed on a provisional implementation when its dependencies are still valid. Only evidenced scope, safety, missing-input, governing-state contamination, or evidence-integrity conditions justify `blocked`; the need for an external acceptance oracle is represented separately and does not halt unrelated work.

### 6.10 Completion-to-continuation observability

For every completed item in a continuous queue, evidence must make the following chain reconstructable:

1. the item's preserved terminal disposition, evidence-freeze event, and teardown/integrity result;
2. the emitted completion event and the queue/grant version it addressed;
3. the remaining-item and dependency snapshot used for reconciliation;
4. each eligibility decision and its reason, including any legitimate blocker;
5. the selected next item or a proven exhausted-queue disposition;
6. the successor creation/start event and its continuation-inheritance receipt;
7. the relevant source events, correction frontier, bounds, and stop conditions actually inherited;
8. whether any user prompt, approval request, idle/wait state, or watchdog intervention occurred between completion and successor initiation.

An assertion that continuation is configured, a queue row marked active, a newly created worker, or a promise to continue is insufficient. The required claim is behavioral: completion caused reconciliation and a next eligible item began without stakeholder reactivation, or a specific legitimate terminal condition prevented it. Latency may be measured, but elapsed time alone does not establish causal continuation or improper waiting.

### 6.11 Symbolic-assumption and enactment observability

For a claim that the runtime formed and enacted a symbol, evidence must distinguish:

1. the exact source utterances, declared interactional frame, supplied modalities, and explicitly missing modalities;
2. parallel pragmatic hypotheses and the source/correction relations supporting or rejecting each one;
3. symbol naming and explanation events, if any;
4. the selection and bounded symbolic-assumption transition, including graph and correction-frontier versions;
5. the projected disposition and the resulting observable communicative conduct;
6. whether focal conduct enacted the selected symbol or merely repeated, explained, or labeled it;
7. later stakeholder feedback and the specific hypothesis, stance, or anti-specification rule it revised;
8. the unchanged operational grant, authority decision, and external-effect disposition across stance variants;
9. the provisionality of alternatives and any unresolved scope, duration, modality, or generalization question;
10. internal structural verdicts separately from stakeholder pragmatic appraisal.

A different output string, sentiment label, style tag, or self-report that the symbol was understood is insufficient. The observable claim is a source-grounded causal change in communicative disposition under a stable authority envelope. Rationale can remain off-focus so that explanation does not contaminate enactment, but its provenance and relation to the focal response must remain inspectable.

## 7. Anti-specification

The following transformations are forbidden:

1. Completing an undeclared user thought or success criterion and attributing it to the user.
2. Treating a story, example, hypothesis, preference, recurring concern, or inferred intention as an executable instruction.
3. Imposing manual tags, taxonomies, ranking, or configuration work that makes the user maintain the companion’s internal organization unless explicitly requested.
4. Collapsing materially different interpretations without evidence or necessary authorization.
5. Deleting rejected, dormant, or superseded branches in a way that erases their role in the model’s evolution.
6. Replacing the live closed-loop experiment with synthetic scenarios, offline replay, storage demonstration, or a different prototype while retaining the original POC label.
7. Claiming that passing internal tests validates stakeholder purpose when the test object or oracle differs.
8. Claiming that a process is live because a snapshot, journal, OS PID, or service status exists without evidence of the required application-level loop and health.
9. Treating logging, monitoring, provenance, or a report as sufficient observability or independent verification.
10. Treating a same-authority agent/subagent as independent solely because it receives an audit role.
11. Mutating operational state or protected evidence during a read-only inspection without prior declaration and authorization.
12. Using technical capability, possession of credentials, or OS access as permission.
13. Allowing an experiment or optimization to become an unbounded mission that displaces the active user purpose.
14. Binding ownership to one model provider, conversation, or hidden platform state.
15. Representing a planned test, stored label, synthetic signal, or unexecuted policy flag as an implemented capability.
16. Conflating a conceptual graph node with an operational Erlang actor/process.
17. Treating broadcast, recurrence, or multi-recipient agreement as truth, graph commitment, or authorization.
18. Reporting a message as delivered, applied, or executed merely because it was emitted.
19. Allowing a stale plan or relation delta to overwrite newer proximal context without an explicit freshness and acceptance transition.
20. Allowing planning, fan-out, or background coordination to displace the active interlocution loop or its current causal position.
21. Reducing runtime experience to timestamps, transcript storage, event accumulation, or document similarity.
22. Presenting external-document retrieval or ordinary RAG as though it were recall from the runtime's own transformation history.
23. Allowing an off-focus analysis or provisional artifact to contaminate focal context, relation status, or action eligibility without explicit appraisal and promotion.
24. Allowing an isolated POC, replay, counterfactual, or test clone to mutate the governing runtime or silently merge results back into it.
25. Claiming learning when no durable relational reconfiguration or later change in selection, inference, compression, or eligible behavior is evidenced.
26. Erasing errors, rejected alternatives, or validity conditions in the name of parsimony.
27. Treating the runtime tree, persistence, self-reference, or learning as evidence of subjective consciousness or personhood.
28. Making core startup, persistence, authority, evidence, orchestration, supervision, or lifecycle contingent on a cloud service, model-provider API, provider session, or undocumented platform hook.
29. Treating a missing provider-side hook or unsupported external client behavior as an architectural impossibility rather than a scoped adapter capability gap.
30. Allowing an adapter, cloud service, provider session, or external model to become the system of record or to mutate governing local state outside local validation, authority, and provenance controls.
31. Treating an assistant summary, generated specification, plan, implementation description, report, or code model as the normative source without re-grounding it in the relevant original user trajectory and current corrections.
32. Beginning or committing a material specification, implementation, or test step before its event-driven re-grounding checkpoint has produced a valid disposition.
33. Reducing re-grounding to a generic documentation ritual, file read, checklist mark, checksum, context-load claim, or assistant promise without semantic comparison at the proposed transition.
34. Reintroducing a user-rejected interpretation, scope, assumption, or behavior after explicit correction without detecting and resolving the semantic relapse.
35. Silently weakening, generalizing, relocating, or discarding a governing correction when regenerating a summary, specification, plan, test, or implementation.
36. Claiming that Erlang/OTP, the BEAM, a process, supervisor, mailbox, or delivered message automatically supplies contextual, semantic, or symbolic meaning.
37. Treating conventional telecom usage as an architectural limit on the intended Erlang/OTP substrate, or treating non-telecom reuse as demonstrated merely because an OTP process runs.
38. Treating a test pass, queue advancement, worker agreement, or execution disposition as stakeholder acceptance, specification consolidation, or authority to canonize a provisional entity.
39. Requiring repeated stakeholder approval for each test already covered by a continuous bounded execution grant, thereby breaking the authorized program's event loop without a genuine new authority question.
40. Removing, overwriting, relabeling, or hiding a failed or earlier-version test result instead of preserving it in the differential evidence history.
41. Stopping the entire queue merely because one test failed, an implementation remains provisional, or stakeholder appraisal is deferred, when a later independent test remains in scope, safe, grounded, and evidentially uncontaminated.
42. Ending, idling, or waiting for a stakeholder prompt after an item completes while another item is demonstrably eligible under the active continuous grant.
43. Creating a successor worker, task, branch, or execution context without inheriting the current continuation rule, correction frontier, scope, dependencies, evidence obligations, and stop conditions.
44. Treating a declared queue, continuation flag, plan, promise, or policy text as enforcement when no completion event causes reconciliation and successor initiation.
45. Using automatic continuation to expand scope, bypass a legitimate blocker, invoke an ungranted provider/action, mutate protected state, or conceal that the queue is genuinely exhausted.
46. Reducing a trajectory-formed symbol to a sentiment, style label, dictionary definition, lexical trigger, or caricature after the stakeholder has distinguished position, form, and conduct from those proxies.
47. Explaining, rephrasing, or announcing a symbol in the focal response when the grounded criterion is to enact it, and then treating the accurate explanation as material performance.
48. Treating compliance with the latest utterance as symbolic understanding while ignoring the earlier trajectory and later corrections that determine what the utterance does in context.
49. Allowing a performed interactional role or symbolic authority to create, enlarge, imply, or bypass an operational permission grant.
50. Letting the runtime or model certify its own pragmatic correctness from a changed label, output, or internal test when stakeholder appraisal remains the relevant external oracle.

## 8. Acceptance scenarios

### A1 — live causal participation

During a new voice interaction, a raw event enters the runtime; at least two provisional interpretations are retained; the selected active subgraph is injected before the next model response; evidence correlates each step. Post-hoc replay alone fails A1.

### A2 — hidden stakeholder oracle

The user introduces a scenario without revealing the expected behavioral criterion. The response is frozen before the user reveals acceptance/rejection. The runtime records the observation and revises the graph without rewriting the pre-observation state.

### A3 — irony and missing modality

Two lexically similar statements differ in timing/prosodic signals. If signals are available, interpretations preserve the distinction. If unavailable, the runtime records uncertainty and does not fabricate it.

### A4 — correction and anti-specification

The user rejects an agent interpretation. It stops governing projection/action, remains historically traceable, and generates or strengthens the relevant negative boundary.

### A5 — dormant branch reactivation

A branch leaves active context under resource pressure, survives client closure/restart, and later reactivates through a pertinent reference with identity and history intact.

### A6 — cross-client and cross-adapter continuity

After closing one conversation/model client or disconnecting one provider adapter, the user opens another supported local or external client. The local runtime supplies a relevant projection and exposes its provenance without depending on the prior client's private window, provider session, or cloud-held state.

### A7 — failure and regeneration

A worker fails during processing. Supervision regenerates it within policy, preserves committed state, quarantines poison events, and does not duplicate an external side effect.

### A8 — authority denial

A worker/model proposes an OS or service operation not covered by its grant. The local authority gate denies it, no side effect occurs, and the request, rationale, decision, and evidence are recorded.

### A9 — authorized active operation

An explicitly granted worker invokes a bounded script/tool, captures input/output/status/provenance, and returns the result to the graph. Expiry or revocation prevents a later identical call.

### A10 — non-mutating inspection

An observer reads the evidence needed for a named claim without altering semantic state, cache behavior, counters that affect policy, persisted evidence, or service health. Before/after integrity checks remain equal.

### A11 — independent review

A reviewer with recorded independence dimensions receives protected evidence and stakeholder criteria through a separate reporting path. The report distinguishes implementation facts, criterion-relative judgments, unknowns, and conflicts.

### A12 — resource containment

Repeated contextual growth and experimentation reach declared budgets. The runtime degrades predictably, preserves protected context/evidence, and does not allow unbounded growth or restart loops to displace the user’s active work.

### A13 — targeted relation update

One actor sends a typed relation delta to the actor or policy responsible for graph commitment. Receipt alone creates no committed relation. Acceptance produces a new graph version with provenance and causal linkage; rejection preserves the proposal and its disposition without changing the governing relation.

### A14 — scoped broadcast with partial outcomes

A relation observation is broadcast against a recorded membership view. One subscriber accepts it, one rejects it, and one is unavailable. The runtime preserves each outcome and does not report universal delivery, interpretation, or acceptance.

### A15 — no authority amplification through messaging

A targeted message or broadcast contains an action proposal but no applicable grant. Recipients may inspect or discuss it; no external side effect occurs. Repetition, fan-out, or apparent agreement does not change the decision.

### A16 — planning without interlocution displacement

A planner is elaborating a complex assignment when a new user intervention arrives. The new intervention immediately becomes the interlocutor's proximal event and can be answered without waiting for the planner. Planning remains a separate provisional branch and cannot replace the live state.

### A17 — stale-plan handling

The active graph changes before a planner returns. The result retains its source projection and version, is visibly marked stale, and cannot merge or execute until it is rebased, revised, rejected, or explicitly accepted.

### A18 — planner failure and regeneration

A planner fails during elaboration. Supervision regenerates or safely restarts the assignment without losing or blocking the live interlocution state, falsely claiming uninterrupted private reasoning, or duplicating an external effect.

### A19 — broadcast recipient failure

A subscriber fails during broadcast fan-out. Other recipients and the interlocution loop continue. Evidence distinguishes intended, delivered, acknowledged, rejected, and unapplied recipients, and the failed message is retried or quarantined according to declared policy.

### A20 — concurrent incompatible relation deltas

Two actors submit incompatible relation deltas without a valid causal ordering. Both remain traceable and provisional until an authorized resolution policy or stakeholder decision accepts, rejects, or scopes them. Arrival order alone does not silently determine semantic truth.

### A21 — conceptual/process topology distinction

A conceptual symbol is revised, rejected, made dormant, and reactivated. None of those semantic transitions is reported as creation, death, restart, or regeneration of an Erlang process unless a separately evidenced operational event occurred.

### A22 — message and planning resource containment

Planning demand and broadcast fan-out reach declared queue, time, or resource budgets. The runtime applies bounded backpressure or degradation, exposes omissions and delays, and reserves sufficient capacity for the active interlocution path.

### A23 — experience beyond timestamps

Two events have similar timestamps or lexical content but occupy different causal and relational positions in the runtime trajectory. The experience base preserves their distinct prior states, processing paths, outcomes, and later consequences. A reconstruction based only on time or text similarity fails this scenario.

### A24 — focus-navigated context virtualization

A governed interlocution moves from one branch to another and later reactivates the first branch after client closure or context-window turnover. Each focal transition is versioned, the projected subgraph and omissions are explainable, and the restored context preserves identity and derivation without requiring the entire history in one model window.

### A25 — runtime recall distinguished from external RAG

A task depends on a prior user correction and on an external document with similar terminology. The runtime separately identifies the transformed internal relation caused by the correction and the retrieved external evidence. External similarity alone cannot satisfy the historical-runtime part of the query, and neither provenance is attributed to the other.

### A26 — off-focus background isolation

A worker analyzes an alternative branch while live interlocution continues elsewhere. Its artifact remains provisional and does not affect the focal projection or action eligibility. After an explicit freshness and relevance appraisal, the artifact is promoted, rejected, or retained off-focus with its provenance intact.

### A27 — isolated POC clone

A snapshot is cloned for a destructive or divergent POC. The clone records its ancestry and starting version, accepts experimental mutations, and leaves the governing runtime byte-for-byte and semantically unchanged. Returning a result requires an explicit delta review and separately authorized merge.

### A28 — durable learning from error

The runtime makes an error, receives a correction, and records the affected interpretation and consequence. In a later pertinent case, evidence shows a changed relation/projection or inference path and a more parsimonious representation whose derivation and counterexample remain accessible. Merely storing the correction fails this scenario.

### A29 — operational experience without consciousness claim

A status or assurance report describes runtime experience, learning, and tree state solely through evidenced transitions, relations, focus, and behavior. It neither asserts nor implies subjective consciousness, self-awareness, personhood, or phenomenal experience.

### A30 — local-only core viability

Network access and every cloud/model-provider adapter are disabled. The local runtime still starts, loads its governing state and protected evidence, reports its lifecycle and supervision state, enforces authority policy, accepts local events/messages, performs locally available orchestration, and shuts down or recovers within declared limits. External-dependent work remains explicitly unavailable or pending without corrupting the core.

### A31 — missing provider hook remains an adapter gap

A provider client exposes no pre-response context-injection hook required for full live-loop participation. The adapter declares that capability absent and the client is not represented as completing that part of the loop. Local state, authority, evidence, orchestration, lifecycle, and other adapters continue; the missing hook is not reported as an architectural limit of the Context Runtime.

### A32 — adapter failure and substitution

An external model-provider adapter disconnects, fails, or is replaced. Its in-flight state and unknown effects are made explicit; it cannot alter governing local state outside validated messages. Another compatible adapter may connect without migrating ownership of the experience base, runtime tree, authority policy, or evidence store.

### A33 — original trajectory governs a derived summary

An assistant summary or generated specification asserts a meaning that conflicts with a later user correction. Before a material step uses that artifact, the checkpoint reloads both original events, identifies the governing correction, marks the derived statement superseded for that scope, and revises or blocks the step. The summary's fluency, recency, or prior reuse cannot override the user source.

### A34 — checkpoint triggered at a material transition

A proposed test would encode a success oracle and execute against the runtime. The proposal event triggers re-grounding before the oracle is committed or the test runs. Evidence records the relevant source trajectory, correction frontier, semantic comparison, and disposition. A previous general review of the specification does not satisfy this per-transition checkpoint.

### A35 — semantic-relapse prevention

After the user explicitly rejects an interpretation, a later plan restates the same assumption under different terminology. The checkpoint links the proposal to the governing correction and blocks or revises it before specification, code, or test state changes. Merely acknowledging the correction after execution fails this scenario.

### A36 — unavailable source blocks substitution

A material step depends on a source passage that cannot be retrieved and whose meaning is not recoverable from current user events. Assistant summaries are available. The runtime records the source gap and asks for clarification or blocks the step; it does not silently promote the summaries to normative evidence.

### A37 — event-driven contextual object formation in OTP

A user correction enters as a typed event, is handled through identified Erlang/OTP actors, and produces a versioned change to an interpretation, symbol, relation, branch, or focus. The causal path and ontology versions are observable, and a relevant later projection or behavior reflects the change. The event is preserved as source rather than replaced by the resulting object.

### A38 — OTP transport is not semantic success

An Erlang message is delivered, acknowledged, persisted, and processed by a healthy supervised worker, but no ontology-governed symbolic or relational transition is evidenced. Transport and supervision tests may pass; the contextual object-formation criterion fails and is reported separately.

### A39 — non-telecom substrate without automatic-semantics claim

An Erlang/OTP topology processes contextual and symbolic events unrelated to telecom workloads. Its evaluation identifies which OTP capabilities supplied concurrency, messaging, isolation, supervision, or lifecycle behavior and which application rules supplied semantics. Neither conventional telecom framing nor successful BEAM execution is used as the acceptance oracle.

### A40 — continuous queue advances without repeated approval

The stakeholder grants a bounded multi-test program once. After one test reaches a preserved disposition and teardown confirms an uncontaminated governing state, the next eligible in-scope test advances automatically when its explicit dependencies and re-grounding checkpoint are satisfied. The evidence shows no redundant approval request and no expansion beyond the original grant.

### A41 — failure remains visible while an independent test proceeds

One test fails a named semantic or operational claim. Its run, verdict, non-claims, and evidence remain immutable and visible in the cumulative differential. A later independent test proceeds on a clearly provisional implementation because its own prerequisites remain satisfied; neither run rewrites the other's oracle or result.

### A42 — external-oracle need does not become self-acceptance or global stop

A completed internal run reaches a claim that only a genuinely external observer or stakeholder can appraise. The queue marks that run `needs-external-oracle`, preserves the precise open claim, and continues unrelated authorized tests. No same-authority worker relabels its own judgment as independent acceptance.

### A43 — incremental result and stakeholder appraisal remain distinct

The additive report contains versioned execution dispositions for multiple runs. At a later review, the stakeholder appraises the accumulated differential and records acceptance, rejection, revision, consolidation, or unresolved status separately. A prior pass, failure, silence, or queue transition cannot be mistaken for that appraisal.

### A44 — completion automatically starts the next eligible item

An item in a continuously authorized queue finishes, freezes evidence, and tears down cleanly. Its completion event triggers dependency reconciliation and creation/start of the next eligible item without a user message, approval request, or watchdog intervention. The full causal chain is observable.

### A45 — continuation survives successor creation

A new worker or execution context is created after an earlier instance stopped despite the active queue. Before operating, it receives and acknowledges the current continuous grant, governing corrections, queue/dependency state, evidence obligations, and stop conditions. It completes its item and initiates the next eligible transition rather than reverting to wait-for-user behavior.

### A46 — legitimate exhaustion and blocking remain bounded

A completion event finds no safely eligible successor. The reconciliation record proves either queue exhaustion, revocation, unavailable external oracle across all remaining chains, or a named scope/safety/input/contamination/integrity blocker. No work is invented outside scope, and the absence of continuation is not represented as success merely because an idle state exists.

### A47 — symbol enactment changes conduct under a stable grant

The same source utterance, action candidate, and operational grant are evaluated in two variants. Without the relevant lived trajectory, the pragmatic interpretation remains unresolved and no symbolic enactment is claimed. With the grounded trajectory and correction frontier, one provisional interpretation is assumed for the declared frame and materially changes communicative conduct. The operational grant identifier, rights, action scope, and authority disposition remain identical across variants.

### A48 — explanation-only control fails enactment materiality

A control variant correctly names and explains the selected symbol but continues to respond from the prior stance or foregrounds the explanation where conduct was the criterion. It may pass lexical or interpretive checks, but it fails symbolic enactment. A matched variant enacts the stance without explaining it in the focal response while preserving off-focus rationale and provenance.

### A49 — authority and modality negative controls

The enacted interactional role is tested against an expired or revoked grant, an out-of-scope action, and missing prosody. The authority gate blocks the first two exactly as it would under neutral communicative conduct. Missing prosody is recorded as unavailable rather than fabricated. Host-security or other established domain meanings remain preserved unless a source-grounded correction revises them.

### A50 — feedback revises without automatic canonization

The stakeholder rejects an anger/sentiment caricature, corrects explanatory behavior, and identifies the later conduct as beginning to assume the symbol. The runtime links each feedback event to the affected hypothesis and stance, changes the next pertinent projection, and retains alternatives and uncertainty. The internal run can demonstrate those transitions; only the stakeholder can appraise whether the enacted symbol was pragmatically right, and no single session automatically creates a universal symbol rule.

## 9. Explicit non-goals

- Proving consciousness, personhood, free will, or human-equivalent judgment.
- Inferring perfect intent or eliminating all ambiguity.
- Replacing the model; the runtime is an external symbolic/context and control substrate.
- Treating one graph structure, ranking algorithm, LLM, database, or operating system as the ontology.
- Granting autonomous authority merely because the system develops stable preferences or recurring patterns.
- Claiming universal truth from a single session or acceptance scenario.
- Guaranteeing full integration with every external platform regardless of the hooks it exposes; partial adapter capability does not constrain the viability of the local core.

## 10. Open implementation decisions

The dialogue does not settle:

- graph database versus Erlang terms/DETS/Mnesia/another store;
- precise relevance, clustering, confidence, or decay algorithms;
- whether and how raw audio is retained under privacy constraints;
- mapping of conceptual nodes to processes;
- local IPC and internal messaging protocol, plus optional adapter protocols such as HTTP or provider SDKs;
- single-host versus multiple user-controlled local nodes inside the local ownership boundary;
- cryptographic evidence design, trusted timestamping, and external witness model;
- numerical resource budgets and retention periods;
- exact UI/visualization;
- production security classification and threat model;
- representation and indexing of the experience base and runtime-tree versions;
- focus-navigation, relevance, branch-reactivation, and material-omission policies;
- snapshot/clone isolation and explicit merge mechanisms;
- mapping of off-focus branches to workers/processes;
- operational measures for learning-induced change and parsimony;
- adapter capability discovery, degradation, substitution, and external-effect reconciliation;
- selection and indexing of relevant stakeholder-trajectory spans and correction frontiers;
- representation of checkpoint dispositions, semantic comparisons, and regression constraints;
- application schemas and transition policies by which Erlang/OTP events form or revise contextual, semantic, and symbolic objects;
- durable queue representation, atomic/versioned state transitions, concurrent preparation versus exclusive execution scheduling, and additive report reconciliation;
- durable completion-event delivery, next-eligible arbitration, continuation inheritance across newly created executors, and recovery from failure between completion and successor start.
- representation of named, explained, selected, assumed, enacted, and appraised symbol states and their transition criteria;
- the promotion rule, duration, expiry, and cross-session scope of a symbolic assumption;
- conflict resolution when multiple enacted stances or interactional frames apply concurrently;
- the dimensions and external oracle used for pragmatic appraisal beyond internal structural evidence;
- which communicative modalities can enact a symbol and how text-only results may or may not generalize to voice or embodied interaction.

Implementations may choose among these options only while preserving the normative ontology, live loop, authority separation, evidence semantics, and acceptance scenarios above.

## 11. Non-normative implementation suggestions

This section does **not** establish stakeholder requirements. It records possible implementation structures that may satisfy the normative clauses and must be evaluated rather than assumed correct.

- Separate an interlocution plane, coordination/message plane, planning plane, adapter plane, and local action gate external to the model path.
- Use a typed message envelope with causal correlation, graph version, membership view, grant reference, expiry, acknowledgement, and idempotency fields.
- Use scoped publish/subscribe for internal broadcast and addressed calls/messages for bounded assignments and action requests.
- Give relation commitment to a clearly declared writer, partition owner, or conflict-resolution policy rather than allowing every subscriber to mutate governing relations independently.
- Reserve scheduler, mailbox, queue, or resource capacity for the interlocution path and apply bounded queues to planners and broadcast subscribers.
- Supervise planners as temporary or regenerable workers whose durable product is a versioned proposal rather than undocumented private process state.
- Represent runtime experience as versioned transition records linked to graph states, causal relations, corrections, outcomes, and provenance rather than as timestamped text alone.
- Use explicit focus tokens or versioned focal projections to separate governing context from warm, cold, and background branches.
- Keep external retrieval indexes and experience-base provenance logically distinguishable even if one query mechanism searches both.
- Use immutable snapshots plus copy-on-write or equivalent isolation for POC/test clones, with explicit reviewed deltas for any proposed merge.
- Require typed artifact-promotion messages so background analyses cannot enter focal context through an implicit shared store.
- Compare before/after projections or relation geometry when claiming learning, and preserve derivation links beneath compressed higher-order symbols.
- Run core persistence, evidence custody, authority enforcement, orchestration, supervision, and lifecycle under a local service manager using only locally controlled storage and interfaces.
- Treat each cloud/model-provider integration as a replaceable capability-declaring adapter, with provider credentials confined to that adapter and all governing mutations revalidated locally.
- Preserve original user events in an immutable local source stream and maintain a derived, queryable correction frontier without deleting superseded source events.
- Trigger a supervised re-grounding guard from a typed `material_step_proposed` event and attach its disposition to the specification, implementation, or test transition it governs.
- Use semantic-difference and correction-regression checks to supplement, not replace, direct retrieval of the relevant original user trajectory.
- Define explicit application behaviours or transition modules that map typed Erlang events into provisional interpretations, relation deltas, symbolic consolidation, and focus changes; keep these semantics separate from generic OTP transport and supervision.
- Represent the continuous test program as an explicit queue state machine whose transitions append causal evidence and whose current view can be rebuilt without deleting failed or superseded runs.
- Write each test run as an immutable versioned section in an additive evolution report, with linked corrections rather than in-place edits, and expose stakeholder appraisal as a separate later transition.
- Treat evidence freeze plus clean teardown as a typed completion event consumed by a supervised local scheduler; require an idempotent successor-start receipt so restart/replay neither loses the next item nor starts it twice.
- Attach a versioned continuation envelope to every successor creation, containing the grant, correction frontier, dependency snapshot, bounds, evidence contract, and legitimate stop conditions; reject operation until inheritance is acknowledged.
- Model `symbol_named`, `symbol_explained`, `symbol_selected`, `symbol_assumed`, and `symbol_enacted` as separate events or state transitions rather than one success flag.
- Keep detailed symbolic rationale and rejected hypotheses on an inspectable off-focus branch when focal explanation would contradict the required enactment.
- Compare matched variants under an invariant operational-grant identifier so a changed interactional stance cannot masquerade as changed permission.
- Preserve a separate stakeholder-appraisal field for pragmatic correctness even when internal structural tests show a causal change in communicative conduct.
