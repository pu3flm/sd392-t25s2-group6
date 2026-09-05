# Narrative Revision Options

## Governing objective

Make the paper easier to enter and learn from without reducing its engineering or academic rigor. Specialized terms should appear when the reader already needs them. The internal context documents guide the argument but are not cited as external authority.

## Option A — The wrong object built correctly (selected)

Open with the familiar engineering paradox that code can compile and tests can pass while the project still solves the wrong problem. From that point, introduce the pre-project layer as the missing relation among purpose, meaning, requirements, action, and evidence.

Why select it:

- preserves the paper's distinctive thesis;
- gives a broad engineering audience an immediate reason to care;
- allows Knowledge Base, controlled AI, and formation to enter naturally;
- keeps Erlang and the design episode as an implementation and stress test rather than the paper's identity.

Risk: the opening can sound accusatory if the substituted artifact is personalized. Mitigation: describe the mechanism neutrally and acknowledge that a substitute may remain technically useful.

## Option B — The laboratory as a knowledge system

Open with knowledge dispersed among papers, code, experiments, people, messages, and tacit decisions. Define the Knowledge Base as scientific infrastructure, then introduce AI as a maintenance and workflow tool.

Strength: warmest and most interdisciplinary entrance; gives education and institutional use immediate weight.

Risk: makes the paper appear primarily about knowledge management and would require broader restructuring and additional educational literature.

## Option C — From trust to instrumentation

Open with the control-engineering principle that an unfamiliar component is bounded, observed, and tested against an external criterion rather than trusted by declaration. Introduce AI as a probabilistic component inside a larger engineered workflow.

Strength: immediately legible to control, systems, and software engineers.

Risk: readers may mistake the paper for an AI-control or agent-safety architecture paper and treat epistemology and ontology as secondary.

## Selected synthesis

Use Option A as the narrative spine. Borrow the scientific-infrastructure and formation language from Option B and the probabilistic-component framing from Option C.

The opening sequence is:

1. Correct implementation of a substituted object.
2. Requirements are not primitive; they inherit meaning and purpose.
3. Knowledge Base as scientific infrastructure.
4. AI as a tool inside the workflow, not its destination or authority.
5. Formation through visible reasoning, provenance, testing, and revision.
6. Pre-project epistemic engineering as the name for the required recursive practice.

## Implemented accessible revision

The selected synthesis is now implemented in the working manuscript.

- The title is shortened to *Before the Project*, with a descriptive subtitle.
- Each major technical section now begins with an ordinary engineering question or failure mode before introducing formal terminology.
- The Knowledge Base, Context Runtime, Experience Base, and Runtime Tree are explicitly distinguished.
- “Formation” is defined as the development of engineering judgment through study and practice.
- AI is presented as a bounded instrument within the workflow; model output does not define task completion.
- The main narrative retains the engineering lessons from the design episode while chronology, protocol identifiers, and prototype boundaries sit in appendices.
- The design-trace appendix is organized by conceptual transition rather than timestamp.
- The paper closes on the three governing anchors: Knowledge Base as scientific infrastructure, AI as instrument rather than destination, and formation through inspectable practice.

This version is recommended because it reduces entry cost without weakening the paper’s ontology, assurance model, or claim boundaries. Options B and C remain viable future adaptations for institutional and control-engineering audiences, respectively; they are not competing truth claims, only different narrative entrances.
