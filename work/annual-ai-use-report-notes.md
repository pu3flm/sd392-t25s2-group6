# Annual AI-Use Engineering Report — Working Notes

## Scope

- A first-person engineering account of approximately twelve months of practical work with AI tools.
- Its object is the engineer's trials, questions, uses, adaptations, observed capabilities, feasibility limits, failure modes, useful boundaries, and changes in working practice.
- It is not a corpus-validation study, a universal AI theory, or a success report about one settled system.

## Inputs and inventory method

- Build a lightweight chronology from available ChatGPT, Codex, OpenCode, and other relevant records.
- For initial recovery, use dates plus two or three words describing each relevant user question or attempted task.
- Prefer user prompts/questions as the semantic signal; assistant responses are not the primary inventory unit.
- Estimates and representative samples are sufficient at this stage. Do not require complete extraction or construct a Knowledge Base.
- Exclude interactions unrelated to engineering projects, AI-tool behavior, workflow, orchestration, evaluation, or the engineer's attempts to understand and improve those uses.

## Interaction-level pattern inference

- The lightweight user-prompt chronology is only the recovery index. The deeper analytical unit is the complete interaction among the engineer's intention, the prompt and preceding context, platform mediation, tool access and state, the assistant's response, the engineer's correction, and what happened next.
- Do not allocate every failure to either “the user” or “the model.” Candidate failure patterns may emerge from their coupling: loss of context after tool use, generic priors overriding local intent, premature closure, hidden search coverage, unsupported synthesis, stalled delegation, missing progress signals, or correction that does not alter the next action.
- The AI system can contribute inferentially by detecting recurrences and contrasts across more interactions than the engineer can precisely retain at once. That inferential advantage is one of the objects being tested; it must not be converted into epistemic privilege.
- Every reported pattern must retain the boundary between observation and inference: identify the examined material, selection method, recurrence signal, counterexamples, unresolved alternatives, access gaps, and confidence. A pattern remains a candidate even when it is frequent.
- Treat the engineer's live corrections as part of the interaction evidence and as substantive authorial analysis. They often identify the conceptual failure that the original response cannot diagnose from its own priors.
- Avoid the false ownership question “whose failure is it?” when the useful finding concerns a recurrent property of the mediated workflow. Attribute a cause to one component only when the trace actually supports that attribution.
- The requested analysis is an **observational data-analysis operation**, not a decision procedure. It may calculate or estimate incidence, recurrence, co-occurrence, contrast, sequence, correction uptake, and relative evidentiary weight; it may then surface plausible candidate inferences.
- Once analysis has been delegated, inferential work is intrinsic to its execution and does not require a new user request for every inference. “Candidate” names the inference's epistemic status, not a permission gate or a reason to stop before drawing it.
- The assistant should proactively generate useful inferences within the defined analytical scope, showing their grounds, relative weight, uncertainty, and alternatives. It must not confuse that initiative with authority to decide the author's interpretation or final position.
- Its output is authorized for inclusion in the final report with its provenance and uncertainty. Inclusion does not promote an inference to truth, authorize deletion of conflicting material, or bind the engineer's interpretation.
- Keep the layers explicit: `preserved interaction -> extracted observation -> measured/estimated relation -> plausible inference -> author's later interpretation`. Do not collapse the last two stages into a system decision.
- Add the engineer's first-person technical testimony as its own input class. He directly observed the system's behavior during use and is a witness to the interaction, not merely the person supplying a hypothesis after the fact. Keep `witness account`, `interaction trace`, and `cross-interaction inference` distinct and available for comparison.

## Separation from *Before the Project*

- *Before the Project* is one focused narrative within the broader annual account.
- The current live friction around subagents, visibility, contextual staging, continuous queues, and user-as-watchdog is relevant to the annual report's treatment of AI-mediated workforce orchestration.
- That material does not automatically belong in *Before the Project*. It enters that manuscript only if it directly illuminates the epistemic formation of a project before specification.

## Visualization pipeline for the evolution of tackling style

This pipeline preserves two different properties of the OpenCode history: a directional increase in operational formalization and recurring cycles of exploration, repair, and reuse. The current figure is qualitative and ordinal; it must not be presented as a completed measurement of all 937 sessions.

1. **Sources:** use the user-question chronology and the sampled interaction analysis as the initial inputs.
2. **Transformation:** group related touchpoints into four ordinal stages: task constraints, bounded roles, verified workflows, and context infrastructure.
3. **Encoding:** place time on the horizontal axis and operational formalization on an ordinal vertical axis; do not invent a numerical score.
4. **Shape:** use a solid rising curve for the directional shift and dashed loops for recurring exploration, repair, and reuse.
5. **Rendering:** generate the plot as a responsive SVG whose dimensions follow the available display width.
6. **Verification:** inspect both desktop and compact layouts before presenting the figure.

The interpretive choice behind the figure is to avoid forcing the history into either a strictly linear progression or undifferentiated recurrence. The visual presents a candidate shape—a directional, ratcheting spiral—whose support must be tested against the full-session analysis, including counterexamples and alternative explanations.
