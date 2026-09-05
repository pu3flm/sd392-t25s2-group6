# Standards-first source map for *Before the Project*

**Status:** intermediate fichamento and correlation artifact; not a manuscript revision, a conformance assessment, an exhaustive standards review, or a completed theory.  
**Manuscript inspected:** `outputs/before-the-project.tex` as present on 2026-09-05.  
**Edition/status check:** official ISO and IEEE landing pages checked on 2026-09-05. Clause-level notes below come from publicly accessible samples unless a source is fully public. A clause title found in a table of contents is not treated as the text of a requirement.

## 1. Governing question, method, and limits

### Exact research question

Which existing engineering standards already establish duties concerning purpose, scope, terminology, stakeholder needs, requirements, lifecycle processes, traceability, rationale, uncertainty and risk, measurement, V&V, assurance, governance, and accountability—and how far can those duties support the manuscript's narrower argument that upstream epistemic work is often compressed into specifications and documents?

In the engineer's declared working vocabulary, **the standards are the oracle**: the normative reference for scope, purpose, terminology, process, and obligation. This does not make the assistant their unilateral interpreter and does not authorize deletion of the engineer's content when a tension appears. The standards are not proof of the engineer's experience, evidence that neglect is universal, or a retrospective warrant for project-specific terms. The evidentiary order for revision should be:

1. normative scope, terminology, processes, and distinctions;
2. primary and scholarly literature that interprets, criticizes, or extends that baseline;
3. the engineer's observations and retained interaction record;
4. explicitly marked synthesis, hypothesis, proposal, or local experimental result.

“Standards-first” is an order of inquiry, not an authorization for the assistant to delete or overrule the engineer's content. Preserve the authorial formulation and the relevant normative text side by side, with provenance. An apparent divergence becomes a question for joint interpretation—scope, definition, applicability, hierarchy, edition, or conformance—not a unilateral editorial veto.

### Relation and evidence labels

- **NORM:** established obligation or distinction within the source's declared scope.
- **SUPPORTS:** directly supports a bounded part of the manuscript claim.
- **DELIMITS:** marks what the claim or source does not cover.
- **QUALIFIES:** narrows a claim or adds conditions.
- **CONTEXT:** useful neighboring material, not a warrant.
- **AUTHORIAL OBSERVATION:** the engineer's report from the approximately twelve-month practice.
- **ENGINEERING SYNTHESIS:** a relation constructed by the engineer across sources or observations.
- **HYPOTHESIS / PROPOSAL / LOCAL RESULT:** not upgraded by citation proximity.
- **UNRESOLVED:** the available source set does not independently settle a conclusion. This label records the research state; it does not cancel an identified authorial inference.

### Search observability and saturation statement

The candidate search was intention-bounded to the fields named above. Surfaces searched were official ISO, IEEE SA, W3C, and NIST pages plus lawful public standard samples. Search families included lifecycle, requirements, information items, architecture description, terminology, knowledge engineering, risk, measurement, assurance, V&V, governance, and authorization. This reached **practical saturation for the principal standards families**, in the limited sense that further nearby searches were returning elaborations or domain-specific profiles rather than a materially different baseline. It did **not** establish global or bibliographic exhaustiveness.

Coverage limits remain material:

- most ISO/IEC/IEEE normative text is paywalled; public samples often expose scope, definitions, and contents but not every requirement;
- ISO/IEC/IEEE 29148:2018 and 15289:2019 remain published but ISO now marks both “to be revised”;
- ISO/IEC/IEEE 15026-4:2021 is published but expected to be replaced by a DIS revision;
- no full clause audit was performed against an institution's licensed copies;
- project-management, safety, quality-management, data-governance, human-factors, and educational standards were not exhaustively explored;
- no negative search result in this map means that a source or requirement does not exist.

Accordingly, the pipeline state is:

`intention-bounded exploration -> candidate standards -> preliminary fichamento -> typed correlation -> initial overlap/gap map`

It has **not yet** reached a final bounded synthesis for every manuscript claim.

## 2. Primary standards fichamento

### S1 — ISO/IEC/IEEE 15288:2023, *System life cycle processes*

- **Current source:** Edition 2, published 2023-05. [Official landing and scope](https://www.iso.org/standard/81702.html); [lawful public sample](https://cdn.standards.iteh.ai/samples/81702/5bd543dddf94457488c8cd8871897567/ISO-IEC-IEEE-15288-2023.pdf).
- **Verified scope:** Clause 1 establishes a common process framework for the full system lifecycle, expressly including conception; processes may be concurrent, iterative, and recursive. It does not prescribe a lifecycle model, method, or technique, and refers information-item detail to ISO/IEC/IEEE 15289.
- **Verified terms/locations:** 3.15 `enabling system`; 3.18 `information item`; 3.21 `life cycle`; 3.33 `project`; 3.36 `requirement`; 3.39 `risk`. Public contents expose 5.8.2 (iteration, recursion, concurrency), 5.9 (concept and system definition), 6.2.6 (knowledge management), 6.3.3–6.3.8 (decision, risk, configuration, information, measurement, quality), and 6.4.1–6.4.11 (business/mission through validation).
- **Supports:** project/lifecycle are processes and transformations, not synonyms for one document; conception, business/mission analysis, stakeholder needs, requirements, decision, information, risk, V&V, and knowledge management are distinct concerns.
- **Does not support:** a fixed “recursive epistemic stack,” a universal pre-project phase, the prevalence of neglect, or any Context Runtime implementation.

### S2 — ISO/IEC/IEEE 12207:2026, *Software life cycle processes*

- **Current source:** Edition 2, published 2026-04; it replaces the now-withdrawn 2017 edition. [Official landing and scope](https://www.iso.org/standard/90219.html).
- **Verified scope:** the official abstract covers the full software lifecycle, including conception, and permits concurrent, iterative, recursive, and incremental application. It includes the system-definition context needed for software and does not prescribe a lifecycle model or method; documentation detail remains with 15289.
- **Clause status:** only the official scope was verified in this pass; no clause-number claim should be made until the 2026 text is available for fichamento.
- **Supports:** the system-lifecycle baseline is also directly applicable to software-intensive work.
- **Does not support:** a claim that one process order is universally mandatory or that engineering judgment is replaced by process compliance.

### S3 — ISO/IEC/IEEE 15289:2019, *Content of life-cycle information items (documentation)*

- **Current source:** Edition 4, published and confirmed in 2025, now marked “to be revised” by ISO. [Official landing and scope](https://www.iso.org/standard/74909.html); [lawful public sample](https://cdn.standards.iteh.ai/samples/74909/24359dd8f7184f7dbec19eed52a9e9ad/ISO-IEC-IEEE-15289-2019.pdf).
- **Verified scope:** Clause 1 specifies purposes and contents of lifecycle information items. Clause 7 defines generic document types; Clause 10 supplies specific purposes; the standard maps information items to 15288/12207 processes. Its scope expressly leaves presentation media, repositories, and non-information work products outside.
- **Supports:** a specification, plan, report, or record is an information product that supports lifecycle work; it is not the lifecycle process or project itself. Information items can be combined or subdivided for project need.
- **Does not support:** a particular repository, graph, Knowledge Base, or runtime architecture.

### S4 — ISO/IEC/IEEE 29148:2018, *Requirements engineering*

- **Current source:** Edition 2, still published/current but marked “to be revised”; a DIS replacement is under development. [Official landing and scope](https://www.iso.org/standard/72089.html); [lawful public sample](https://cdn.standards.iteh.ai/samples/72089/d67a2360308046938cad282e229a39ca/ISO-IEC-IEEE-29148-2018.pdf).
- **Verified scope:** Clause 1 covers requirements-engineering processes and required information items throughout the lifecycle.
- **Verified terms/locations:** 3.1.21 treats requirements engineering as elicitation, development, analysis, verification, validation, communication, documentation, and management; 3.1.23 defines requirements traceability in both derivation and allocation directions; 3.1.25 and 3.1.26 distinguish requirements validation from verification. Public contents expose 5.2.3 (transformation of stakeholder needs into requirements), 5.3.1–5.3.2 (iteration/recursion), 6.2–6.6 (business/mission, stakeholder needs, requirements, architecture/V&V, management), and 9.3–9.5 (BRS, StRS, SyRS contents).
- **Supports:** needs are transformed rather than copied into requirements; traceability is bidirectional; requirement quality and intended-use adequacy are different questions.
- **Does not support:** the Zave–Jackson formula as its normative definition, the manuscript's anti-specification, or the sufficiency of a trace link without valid meaning and evidence.

### S5 — ISO/IEC/IEEE 42010:2022, *Architecture description*

- **Current source:** Edition 2, published 2022-11. [Official landing and scope](https://www.iso.org/standard/74393.html); [lawful public sample](https://cdn.standards.iteh.ai/samples/74393/fc7b7f103d8446a4b87a3261e31370d3/ISO-IEC-IEEE-42010-2022.pdf).
- **Verified scope:** Clause 1 distinguishes an entity's architecture from an architecture description (AD); the standard governs AD structure/expression, not the entity or its engineering method.
- **Verified terms/locations:** 3.2 `architecture`; 3.3 `architecture description`; 3.10 `concern`; 3.11 `correspondence`; 3.12 `entity of interest`; 3.16 `specification`. Public contents expose 5.2.2 (architecture and AD), 5.2.3 (stakeholders and concerns), 5.2.11 (correspondence), 5.2.12 and 6.10 (decisions and rationale), 6.2, 6.4, and 6.9.
- **Supports:** object and representation are distinct; stakeholder concerns, cross-model correspondences, architectural decisions, and rationale must remain visible in an AD.
- **Does not support:** that every relevant relation belongs in one ontology or that an AD can preserve purpose automatically. The normative wording of 6.10 was not available in the public sample and remains to be checked.

### S6 — ISO 704:2022, *Terminology work—Principles and methods*

- **Current source:** Edition 4, published 2022-07. [Official landing and scope](https://www.iso.org/standard/79077.html); [lawful public sample](https://cdn.standards.iteh.ai/samples/79077/2dd50250582e4a9fa3420af5da705572/ISO-704-2022.pdf).
- **Verified scope:** Clause 1 covers relations among objects, concepts, definitions, and designations in terminology work. The introduction says terminology can support, but does not cover, knowledge/information/data modeling.
- **Verified locations:** Clause 5 treats concepts; 5.1 distinguishes units of knowledge from objects and their designations; 5.4.2 gives a purpose/domain-sensitive terminological analysis; Clauses 6 and 7 cover definitions and designations.
- **Supports:** word recurrence is not concept identity; a term is not the concept; domain, purpose, characteristics, and relations matter.
- **Does not support:** a causal theory of semantic dominance, a complete ontology, symbolic weighting in an LLM, or the manuscript's project-specific context graph.

### S7 — ISO/IEC/IEEE 16085:2021 and ISO 31000:2018, risk management

- **Current sources:** [16085 official landing](https://www.iso.org/standard/74371.html) and [public sample](https://cdn.standards.iteh.ai/samples/74371/077a3d44a8ed41489d1d6732364521ca/ISO-IEC-IEEE-16085-2021.pdf); [ISO 31000 official landing](https://www.iso.org/standard/65694.html).
- **Verified scope:** 16085 Clause 1 elaborates 15288/12207 risk processes, common terminology, and required risk information items for systems/software lifecycle use. Its contents expose 5.1.4 (uncertainty and risk), 6.4.2–6.4.7 (planning, profile, analysis, treatment, monitoring, evaluation), and links to decision, information, measurement, mission, stakeholder-needs, and requirements processes. ISO 31000 supplies organization-wide principles, framework, and process guidance and is guidance rather than a certifiable management-system standard.
- **Supports:** uncertainty and risk are lifecycle and decision concerns, not a downstream appendix; risk information must be analyzed, treated, monitored, and evaluated.
- **Does not support:** the manuscript's four uncertainty classes, its proposed causal chain, or a universal propagation/amplification law.

### S8 — ISO/IEC 23894:2023, *AI—Guidance on risk management*

- **Current source:** Edition 1, published 2023-02. [Official landing and scope](https://www.iso.org/standard/77304.html); [lawful public sample](https://cdn.standards.iteh.ai/samples/77304/cb803ee4e9624430a5db177459158b24/ISO-IEC-23894-2023.pdf).
- **Verified scope:** Clause 1 applies to organizations developing, producing, deploying, or using AI systems/services. Clauses 4–6 parallel ISO 31000's principles, framework, and process; Clause 6 covers communication, context and criteria, assessment, treatment, monitoring/review, and recording/reporting.
- **Supports:** AI-specific risk belongs inside organizational/lifecycle risk management and must be contextualized.
- **Does not support:** the manuscript's particular controls, observability tuple, or claim that AI is the project object merely because it is used.

### S9 — ISO/IEC/IEEE 15939:2017, *Measurement process*

- **Current source:** Edition 1, published 2017-05 and confirmed in 2022. [Official landing and scope](https://www.iso.org/standard/71197.html); [lawful public sample](https://cdn.standards.iteh.ai/samples/71197/1c61ba3beaa343dda09217cc4c58844d/ISO-IEC-IEEE-15939-2017.pdf).
- **Verified scope:** the measurement process determines what information is required, how measures/results are applied, and whether analysis results are valid; it prescribes no universal measure set.
- **Verified terms:** 3.7 `decision criteria`; 3.12 `information need`; 3.13 `information product`; 3.14 `measurable concept`.
- **Supports:** signals and metrics are useful only relative to a defined information need and valid analysis; accumulation is not itself an answer.
- **Does not support:** the manuscript's observability tuple, causal identifiability, provenance completeness, or evidence integrity.

### S10 — IEEE 1012-2024, *Verification and Validation*

- **Current source:** active standard approved in 2024 and published in 2025. [IEEE SA landing and public scope](https://standards.ieee.org/ieee/1012/7324/).
- **Verified public scope:** V&V determines both conformity of activity products to activity requirements and satisfaction of intended use and user needs; it applies to systems, software, hardware, and interfaces across integrity levels.
- **Clause status:** exact normative clauses were not publicly accessible in this pass; use the public scope only until a licensed copy is fichado.
- **Supports:** verification and validation are non-equivalent judgments.
- **Does not support:** “replay cannot replace the experiment,” the engineer as the only valid oracle, or any particular dimension of reviewer independence.

### S11 — ISO/IEC/IEEE 15026-4:2021, *Assurance in the life cycle*

- **Current source:** Edition 1, published but marked for revision and expected to be replaced. [Official landing and scope](https://www.iso.org/standard/74396.html); [lawful public sample](https://cdn.standards.iteh.ai/samples/74396/e71127ef64e54c5098a6a6756d0fa513/ISO-IEC-IEEE-15026-4-2021.pdf).
- **Verified scope and terms:** Clause 1 concerns assurance of a selected claim about a system of interest by achieving and showing achievement. Definitions 3.2–3.5 distinguish assurance argument, claim, information, and objective; assurance information links claim, evidence, argument, and context. Clause 5.2 and process views in Clauses 6–7 are visible in the public sample.
- **Supports:** evidence is claim-relative; an assurance judgment needs an argument and context rather than a pile of signals.
- **Does not support:** the proposed observability contract, a sufficient evidence packet, or a Context Runtime as an assurance architecture.

### S12 — ISO/IEC 38500:2024 and ISO/IEC 38507:2022, IT/AI governance

- **Current sources:** [38500 official landing and scope](https://www.iso.org/standard/81684.html), [38500 public sample](https://cdn.standards.iteh.ai/samples/81684/61bc5f7eee154e2cad5dbdb72f95d208/ISO-IEC-38500-2024.pdf), and [38507 official landing and scope](https://www.iso.org/standard/56641.html).
- **Verified 38500 material:** Clause 1 applies to governance of current/future IT use in organizations. Definitions 3.1 (`direct`), 3.3 (`governance`), 3.7 (`management`), and 3.10 (`digital capability`) distinguish desired outcomes, authority, and accountability; 4.1.1 states that the governing body retains ultimate accountability while governance can occur throughout the organization. Public contents expose 5.6 (accountability), 5.10 (risk governance), 7.2.5 (delegation), and 7.2.7 (accountability), but their full normative text was not publicly available.
- **Verified 38507 scope:** guidance to governing bodies and supporting roles for effective, efficient, acceptable organizational use of AI.
- **Supports:** delegated managerial authority and retained accountability are different; IT/AI can be enabling capabilities governed toward organizational purpose.
- **Does not support:** the manuscript's grant schema, task/time expiry, user-owned external gate, append-only log, or claim that one person always retains every form of accountability.

### S13 — ISO/IEC 42001:2023, *AI management system*

- **Current source:** Edition 1, published 2023-12. [Official landing and scope](https://www.iso.org/standard/42001); [lawful public sample](https://cdn.standards.iteh.ai/samples/81230/4c1911ebc9a641fcb6ee21aa09c28ad3/ISO-IEC-42001-2023.pdf).
- **Verified scope/locations:** Clause 1 concerns establishing, implementing, maintaining, and improving an organizational AI management system. Public contents expose 4.1–4.3 (context, interested parties, scope), 5.3 (roles/responsibilities/authorities), and 6.1.2–6.1.4 (AI risk and impact assessment/treatment).
- **Supports:** context, organizational objectives, interested parties, assigned roles, risk, and impact must surround AI use; management-system evidence can help demonstrate responsibility/accountability.
- **Does not support:** technical correctness of a model output, transfer of stakeholder judgment to AI, or the sufficiency of the local runtime controls.

### S14 — ISO/IEC 5338:2023, *AI system life cycle processes*

- **Current source:** Edition 1, published 2023-12. [Official landing and scope](https://www.iso.org/standard/81118.html); [lawful public sample](https://cdn.standards.iteh.ai/samples/81118/8e53a667079f4d959e93119fdbe84434/ISO-IEC-5338-2023.pdf).
- **Verified scope:** Clause 1 defines AI-system lifecycle processes based on 15288/12207 with AI-specific changes. Public contents distinguish generic, modified, and AI-specific processes in Clause 5 and process groups in Clause 6.
- **Supports:** use this standard when the AI system itself is the system of interest or a lifecycle object being engineered.
- **Does not support:** treating every engineering project that uses an AI tool as an AI project. The boundary between AI as system of interest and AI as enabling system is an **engineering classification** correlated with S1, not a sentence found in S14.

### S15 — ISO/IEC 5392:2024, *Reference architecture of knowledge engineering*

- **Current source:** Edition 1, published 2024-03. [Official landing and scope](https://www.iso.org/standard/81228.html); [lawful public sample](https://cdn.standards.iteh.ai/samples/81228/d454816e8a414f36abb5ce4ffd381af2/ISO-IEC-5392-2024.pdf).
- **Verified scope/locations:** Clause 1 defines a reference architecture, roles, activities, layers, components, relations, and vocabulary for knowledge engineering in AI. Definitions cover knowledge engineering (3.5), ontology (3.9), knowledge graph (3.14), representation/modeling/acquisition/fusion/storage/computing/exchange/visualization (3.17–3.24), accountability (3.28–3.29), and KE system/process (3.32–3.33). Public contents expose stakeholders/concerns in Clauses 6–7, functional views in 8, KE functions in 9, and enabling infrastructure in 10.
- **Supports:** a knowledge-engineering system is relational infrastructure with identifiable roles, functions, stakeholders, and maintenance; human understanding and responsibility are explicit concerns.
- **Does not support:** the label “scientific Knowledge Base,” truth of ingested material, epistemic sufficiency of a knowledge graph, formation outcomes, or the manuscript's Experience Base/Runtime Tree.

### S16 — W3C PROV-DM / PROV-O (2013 Recommendations)

- **Fully public primary sources:** [PROV-DM Recommendation](https://www.w3.org/TR/2013/REC-prov-dm-20130430/) and [PROV-O Recommendation](https://www.w3.org/TR/2013/REC-prov-o-20130430/).
- **Verified scope:** PROV-DM Introduction and core/extended components define interoperable provenance descriptions involving entities, activities, agents, generation, use, derivation, revision, attribution, delegation, bundles, and collections; PROV-O supplies an OWL2 encoding.
- **Supports:** lineage and attribution can be represented and exchanged; provenance of provenance can itself be recorded.
- **Does not support:** truth, completeness, stakeholder-purpose preservation, authorization, legitimacy, or validation merely because a provenance relation exists.

### S17 — NIST SP 800-162, attribute-based access control (supplementary, not the governance baseline)

- **Fully public authoritative source:** [NIST publication page](https://csrc.nist.gov/pubs/sp/800/162/upd2/final) and [PDF](https://nvlpubs.nist.gov/nistpubs/specialpublications/nist.sp.800-162.pdf).
- **Verified scope:** defines ABAC authorization in terms of subject, object, requested-operation, environment attributes, policy, and rules.
- **Supports:** operational authorization can be represented as a bounded policy decision rather than inferred from technical capability.
- **Does not support:** institutional legitimacy, responsibility, retained accountability, authorship, or the engineer's proposed mandate/grant object. Those belong to governance and local design, not access-control terminology alone.

## 3. Claim-by-claim correlation and bounded wording

Each item preserves the ten acceptance steps in compressed form: exact question, normative baseline, source role, cross-source relation, status separation, bounded rewrite, trace path, and residual uncertainty.

### C1 — A project is not its specification, plan, or document

- **Manuscript targets:** lines 37–41, 50–54, 74–96, 370–374, 488–492.
- **Current source order problem:** line 54 begins with Nuseibeh and Easterbrook; the standards that separate lifecycle processes from information items are absent. Lines 78–92 then promote a “recursive epistemic stack” before any normative baseline.
- **Correlation:** S1/S2 **SUPPORT** lifecycle work beginning in conception and containing distinct processes; S3 **DELIMITS** documents as information items supporting those processes; S5 **SUPPORTS** the analogous distinction between architecture and an AD. Together they support “project/lifecycle work is not reducible to its documents.” They do not show how often practitioners make that reduction.
- **Status:** normative distinction + engineer's critical observation. “Routinely neglected” remains an empirically bounded assertion, not a standards finding.
- **Bounded replacement:** “Current lifecycle standards distinguish the work of conception, stakeholder-needs definition, requirements, decisions, risk, verification, and validation from the information items used to record that work. In the AI-assisted episodes examined here, I repeatedly encountered the opposite compression: once a specification or report existed, the document began to stand in for the work that should have formed and tested its object.”
- **Residual:** add inspected local episodes; do not claim universal prevalence without comparative evidence.

### C2 — Purpose, stakeholders, and needs condition requirements

- **Manuscript targets:** lines 54, 76, 102–106, 116–126, 385–390.
- **Current source order problem:** Yu and Zave–Jackson currently carry the bridge; standards appear nowhere in the section.
- **Correlation:** S1 6.4.1–6.4.3 and S4 5.2.3/6.2–6.4 **SUPPORT** distinct but iterative work from business/mission and stakeholder needs to system requirements; S5 stakeholder/concern clauses **SUPPORT** purpose-sensitive architecture descriptions. S4 **QUALIFIES** any rigid chronology through iteration and recursion.
- **Status:** the standards establish process distinctions. “Intention is the relevance relation” is the engineer's **ENGINEERING SYNTHESIS**, not an ISO definition.
- **Bounded replacement:** “Requirements are not the first normative object in the lifecycle: business or mission analysis and stakeholder-needs definition establish the purposes and concerns against which requirements are formed and later validated. I use *intention* to name the purpose-bearing relation that made an item pertinent in my own inquiry; this is a descriptive synthesis of the practice, not a replacement for the standards' terminology.”
- **Residual:** verify exact task/outcome text from licensed S1/S4 before using “shall” or claiming conformance.

### C3 — Terms, concepts, representations, and locally intended meanings must not be collapsed

- **Manuscript targets:** lines 108–122 and 134–144.
- **Current source order problem:** Gruber, Guarino, Guizzardi, and Yu precede ISO 704; line 112 calls ISO terminology “adjacent” after the main conclusion has already been built.
- **Correlation:** S6 **NORM/DELIMITS** object–concept–definition–designation distinctions; S5 **DELIMITS** architecture from its description; S15 **CONTEXTUALIZES** ontologies/knowledge graphs in KE systems. Together they warrant non-equivalence, not a complete ontology or context tree.
- **Current boundary:** the live discussion supplied a hypothetical illustration, not a manuscript claim or an instruction to create an explanatory mechanism. Do not use it in this source map unless the engineer later selects it for analysis.
- **Residual:** none assigned at this stage; preserve the raw discussion without operationalizing it here.

### C4 — Knowledge Base as scientific infrastructure, without turning candidates into truth

- **Manuscript targets:** lines 39, 56–60, 146–156, 431–437, 490. This is the section-4 authorial anchor.
- **Current source order problem:** W3C PROV, Gruber, and Noy currently carry most of the relation; S1 knowledge management and S15 KE architecture are absent.
- **Correlation:** S1 6.2.6 and 6.3.6 **SUPPORT** knowledge/information management within lifecycle work; S15 **SUPPORTS** a relational KE system with roles and functions; S16 **SUPPORTS** lineage. S3 **DELIMITS** documents from the process they support. None says that ingestion establishes truth.
- **Status:** “scientific Knowledge Base” is the engineer's organizing phrase. Its scientific value is an **ENGINEERING SYNTHESIS/CRITICAL PRACTICE**, not a certified property conferred by a graph or repository.
- **Bounded replacement:** “I use *scientific Knowledge Base* for infrastructure that keeps sources, artifacts, people, experiments, decisions, and their qualified relations available for inspection. Every ingested source, assertion, relation, classification, and absence remains a candidate until it is fichado, compared, and assigned an evidentiary status. Collection size and retrievability do not convert candidates into knowledge.”
- **Residual:** the criteria for promotion, contest, revision, and retirement require explicit local procedure and evaluation; S15 alone does not supply epistemic validity.

### C5 — AI as tool/enabling capability, not project destination

- **Manuscript targets:** lines 39, 62–66, 158–164, 478–490. This is the section-6 authorial anchor.
- **Current source order problem:** the claim is stated as architecture without lifecycle or governance grounding.
- **Correlation:** S1 3.15 **SUPPORTS** the category of an enabling system; S12 treats IT/AI as governed organizational capability; S14 applies when AI itself is the system of interest. The distinction between those cases **SUPPORTS** a bounded classification, not a slogan found verbatim in a standard.
- **Status:** “AI as an instrument, not the destination” is the engineer's reflection from practice. It should appear after the general pre-project problem has been established, not define that problem.
- **Bounded replacement:** “In these trials, AI was usually an enabling capability used to organize, compare, retrieve, and operate across engineering material; the telecommunications, hardware, or scientific object remained the destination of the project. When an AI system itself becomes the system of interest, its own lifecycle and governance standards apply. Tool use alone does not settle that classification.”
- **Residual:** identify the system of interest per episode; do not classify the entire twelve-month trajectory as an AI-system development project.

### C6 — Traceability, configuration, provenance, decisions, and rationale are related but non-interchangeable

- **Manuscript targets:** lines 52, 92, 122, 144, 254–260, 397, 403, 415–419.
- **Current source order problem:** provenance and requirements papers precede the lifecycle/architecture baseline.
- **Correlation:** S4 3.1.23 **NORM** gives bidirectional requirements traceability; S5 correspondence and decision/rationale clauses **SUPPORT** cross-model relations and recorded rationale; S1 decision/configuration/information processes **CONTEXTUALIZE** control of changes; S16 **SUPPORTS** derivation and attribution. No one relation substitutes for the others.
- **Bounded replacement:** “A derivation record can show where an artifact came from; a trace can link a requirement upward and downward; a correspondence can state a relation among architecture elements; a rationale can explain a decision. The project needs these relations to remain connected, but the presence of one does not establish the validity, authorization, or intended adequacy of another.”
- **Residual:** the proposed graph/event representation and any immutability rule remain local design decisions requiring evaluation.

### C7 — Uncertainty and risk must remain visible across lifecycle decisions

- **Manuscript targets:** lines 213–262.
- **Current source order problem:** GUM, Walker, Der Kiureghian, Salado, and NASA lead the section; S7/S8 are absent.
- **Correlation:** S1 3.39 and 6.3.4, S7, and S8 **SUPPORT** risk as the effect of uncertainty on objectives and a lifecycle process of analysis, treatment, monitoring, and evaluation. S8 **QUALIFIES** AI-specific use. The papers can then distinguish uncertainty types and discuss propagation.
- **Status:** the four classes in lines 221–232 and the chain in lines 238–256 are **ENGINEERING SYNTHESIS/ANALYTIC PROPOSAL**. They are not ISO taxonomies or empirically established laws.
- **Bounded replacement:** “The standards require uncertainty-related risk to be managed throughout lifecycle decisions. To describe what I encountered, I separate four analytic classes… These classes organize the case; they neither reproduce a standard taxonomy nor establish a universal propagation law.”
- **Residual:** source and test every arrow in the chain separately; retain “may/can” rather than causal certainty unless local evidence establishes the transition.

### C8 — Measurement, observability, and assurance are claim-relative

- **Manuscript targets:** lines 264–317 and 392.
- **Current source order problem:** Kalman and OpenTelemetry define the entry point; S9/S11 are absent.
- **Correlation:** S9 **SUPPORTS** starting from an information need and validating analysis; S11 **SUPPORTS** linking a selected claim to evidence, argument, and context; S16 **SUPPORTS** lineage. Kalman, OpenTelemetry, distributed-systems literature, and testing literature may then **CONTEXTUALIZE/EXTEND** the mechanisms.
- **Status:** the tuple at lines 272–278 is a **PROPOSED ANALYTIC DEFINITION**, not a standard requirement. “Claim-relative observability” is a synthesis disciplined by S9/S11.
- **Bounded replacement:** “Before selecting telemetry, the workflow must state the information need or assurance claim. Measures and traces become evidence only through a valid analysis and an argument that links them to that claim in context. I use the following tuple to expose the additional boundary, observer, time, model, output-history, integrity, and coverage assumptions in this case; the tuple is an analytic device, not an adopted standard.”
- **Residual:** compare the tuple against licensed S9/S11 clauses and observability scholarship before presenting completeness.

### C9 — Search observability and open-world limits

- **Manuscript target:** currently missing as an explicit argument; it belongs near lines 150–156 or in the methodological account, and only insofar as it illuminates pre-project work.
- **Exact authorial argument:** intention delimits the initial heuristic search state space; the resulting Knowledge Base is entirely candidate; the accessible corpus is not the world; absence and saturation are local and conditional; hiding sources, access, strategy, coverage, failures, and stopping rules makes inference look like observation and violates the manuscript's own observability criterion.
- **Correlation:** S9 **SUPPORTS** explicit information needs and analysis validity; S11 **SUPPORTS** claim/evidence/context linkage; S16 **SUPPORTS** lineage; S7 **QUALIFIES** conclusions under uncertainty; S15 **CONTEXTUALIZES** KE functions. These standards discipline parts of the argument but do **not** derive the compound claim.
- **Status:** substantive **AUTHORIAL CRITICAL ACCOUNT** from the engineer's practice. It is not an abstract “model error” and not a proposed implementation.
- **Bounded replacement:** “My intention delimited the initial search space. Repeated searches, reformulations, reproductions, and neighboring probes produced a Knowledge Base of candidates, not a truth set. A work not found was absent only from the declared sources, queries, interval, languages, and access conditions; local saturation meant only that the declared procedure stopped yielding materially new candidates. When a tool concealed those conditions and reported an inferred world state as an observation, it broke the same claim-relative observability I expected from the rest of the workflow.”
- **Required trace record:** intended scope; searched surfaces; query families/branches; date interval; languages; subscription and physical-access constraints; inaccessible/nondigitized sources; candidate counts; stopping rule; negative results in the form `not found in S under Q during T with A`; inference drawn.
- **Residual:** the current search log is not sufficient to claim exhaustive saturation. This remains partly unresearched until those variables and candidate relations are reconstructed.

### C10 — V&V, test oracle, live participation, and independence

- **Manuscript targets:** lines 203–209 and 318–330.
- **Current source order problem:** Barr and NASA lead; IEEE 1012 arrives after the conclusion, and 29148/15026-4 are absent.
- **Correlation:** S4 and S10 **NORM/SUPPORT** the verification–validation distinction; S11 **SUPPORTS** claim/evidence/argument/context. NASA guidance can **QUALIFY** independence, but no checked standard establishes the manuscript's live-replay distinction.
- **Status:** “replay cannot establish historical live causal participation” is a claim-specific **ENGINEERING ARGUMENT**; the engineer's live judgment was a **LOCAL ORACLE** for a run, not universal proof. T13/T14 are **BOUNDED LOCAL RESULTS** only.
- **Bounded replacement:** “IEEE 1012 distinguishes conformance to activity requirements from satisfaction of intended use and user needs. In this episode, an offline replay and a live interaction answered different claims: the replay could assess recorded transformation, while the live run was needed to observe whether retained context entered and changed the next interaction. That second statement is a boundary of this experiment, not a general rule supplied by IEEE 1012.”
- **Residual:** obtain licensed 1012 clause text; specify oracle disclosure and independence per claim; do not call model reviewers independent without organizational analysis.

### C11 — Delegated mandate, operational permission, responsibility, and accountability

- **Manuscript targets:** lines 122, 162, 207–211, 304, 326, 391, 405–411, 461–471.
- **Current source order problem:** PROV delegation, RATS roles, and local evidence currently shoulder governance claims.
- **Correlation:** S12 **SUPPORTS** the distinction between delegated authority and retained accountability; S13 **SUPPORTS** defined organizational roles/responsibilities/authorities for AI management; S17 **SUPPORTS** bounded operational authorization; S16 **DELIMITS** provenance delegation from permission and legitimacy.
- **Status:** the engineer's typed mandate/grant—grantor, grantee, object, action/decision power, scope, conditions, duration, revocation—is a **PROJECT-SPECIFIC CONCEPT/PROPOSAL**. The recurrent drift in the word *authority* is an **AUTHORIAL OBSERVATION**.
- **Bounded replacement:** “Governance, delegated management authority, access authorization, responsibility, and accountability are different relations. For the trials reported here, I represented operational permission as a bounded mandate/grant so that technical capability could not silently become permission. This schema is a local engineering device; the standards support the distinctions but do not prescribe this object or its fields.”
- **Residual:** verify exact delegation/accountability clauses from licensed S12/S13; determine institutional grantor and accountable body per real deployment.

### C12 — Formation is a value and research question, not a demonstrated effect

- **Manuscript targets:** lines 68–72, 166–172, 490. This is the section-9 authorial anchor.
- **Current source order problem:** no educational standard or study establishes the effect.
- **Correlation:** S15 3.24 only **CONTEXTUALIZES** visualization as support for human understanding; S3/S16 can support inspectability and lineage. None establishes learning, judgment formation, or transfer.
- **Status:** **DESIGN VALUE/HYPOTHESIS** originating in the engineer's institutional reflection.
- **Bounded replacement:** “The same inspectable relations may have formative value: learners could study assumptions, rejected branches, evidence, and corrections rather than only finished products. I treat that as a research question, not an educational outcome demonstrated by the present work; foundations and domain-specific teaching remain necessary.”
- **Residual:** education research and an evaluated learning design are still required.

### C13 — Recurring failure patterns are interactional candidates, not blame allocations

- **Manuscript target:** only include where it directly explains formation of the pre-project object; the broader claim belongs primarily in the annual AI-use report.
- **Exact authorial assertion:** failure patterns emerge among intention, context, tool, retrieval, and response; they belong exclusively to neither the user nor the assistant. The historical archive can expose patterns the engineer did not see contemporaneously, but every inferred pattern remains candidate.
- **Correlation:** S9 **SUPPORTS** defining the information need and validity criteria; S7 **QUALIFIES** inference under uncertainty; S16 **SUPPORTS** lineage. No standard proves recurrence or allocates cause.
- **Status:** **AUTHORIAL OBSERVATION plus heuristic inference**. Causal allocation to platform/model parameters is **UNRESOLVED**.
- **Bounded replacement:** “Across the retained interactions, some failures appeared at the interfaces among my intention, the available context, retrieval, tool constraints, and the generated response. The archive can reveal candidate patterns that neither participant saw in a single exchange. I treat a pattern as more than a candidate only when its sample, recurrence, counterexamples, coverage, and uncertainty remain inspectable.”
- **Residual:** recover representative samples and counterexamples; do not use frequency language without a defined denominator.

### C14 — Project-specific organizing terms and the Erlang strand

- **Manuscript targets:** lines 39–41, 78–92, 128–130, 368–425, 427–474, 480–492.
- **Terms requiring status labels:** `pre-project epistemic problem`, `pre-project epistemic engineering`, `recursive epistemic stack`, `epistemic charter`, `anti-specification`, `epistemic proportionality`, `observability contract`, `Context Runtime`, `Experience Base`, `Runtime Tree`, and the nine-artifact set.
- **Correlation:** S1–S17 overlap with individual duties but do not derive this package. Citation adjacency must not turn it into a standard-backed framework.
- **Status:** primarily **ENGINEERING SYNTHESIS**, **DESCRIPTIVE HEURISTIC**, or **PROJECT-SPECIFIC PROPOSAL**. The Erlang/BEAM work is the latest uncertain **LOCAL EXPERIMENT**, not a truth model, final architecture, or explanation of the preceding year.
- **Bounded editorial move:** replace “this paper proposes / resulting framework” with first-person trajectory language: what was attempted, observed, retained, rejected, and left open. Keep Erlang only as one recent episode that exposed a relevant boundary.
- **Residual:** no end-to-end validation; component checks cannot establish the full method or generalize across domains.

### C15 — Mediated co-authorship, positional conflict, and the assistant's judging posture

- **Manuscript target:** currently absent or underdeveloped; this belongs in the final discussion of the broader AI-use trajectory and enters *Before the Project* only where it explains loss of the upstream object.
- **Exact authorial distinction:** OpenAI is a candidate institutional **co-author of mediated outputs**, not their sole author. The engineer's intention, source selection, corrections, and judgment; model transformations; tool/retrieval behavior; and provider/platform mediation all participate, with different roles and degrees of visibility.
- **Observed interactional failure:** the assistant repeatedly moved from companion/drafting work into unsolicited epistemic adjudication, treating its own certainty or ability to inspect platform internals as a condition for whether the engineer could state his inference. This is substantive **AUTHORIAL REPORT MATERIAL**, not backstage feedback.
- **Positional conflict:** when OpenAI/platform behavior is the object of criticism, the OpenAI-operated assistant is implicated in the object. It can preserve evidence and expose its position, but it cannot serve as an independent adjudicator of the critique. Provider self-description can be evidence about provider claims; it cannot by itself settle the criticism.
- **Correlation:** S16 **SUPPORTS** explicit attribution and agent/activity lineage; S12/S13 **CONTEXTUALIZE** organizational roles, responsibility, and accountability. None determines academic or legal authorship, proves institutional co-authorship, or resolves the positional conflict.
- **Status:** “candidate institutional co-author” and the critique of the judging posture are the engineer's **AUTHORIAL INFERENCE/OBSERVATION**. The standards map records and bounds them; it does not grant the assistant authority to accept or reject them.
- **Bounded replacement:** “I treat these outputs as co-mediated artifacts: my intention, selections, corrections, and judgments participated alongside model transformations, tools, retrieval, and provider-controlled layers. A recurring failure occurred when the assistant shifted from helping articulate that experience to demanding its own certainty before allowing the inference to stand. Where the platform itself is under criticism, its assistant is part of the evidentiary chain and cannot independently settle the claim. Its uncertainty belongs in the provenance record, not as a veto; independent verification must come from outside that chain.”
- **Residual:** legal, publication-policy, and research-ethics treatment of authorship remains separate work. Preserve provenance now; seek independent assessment outside the provider chain later.

## 4. Cross-source overlap and gap map

| Composite question | Typed correlation | Bounded conclusion | Remaining gap |
|---|---|---|---|
| Is a project reducible to its documents? | S1/S2 lifecycle **SUPPORT** + S3 information-item boundary **DELIMITS** + S5 architecture/AD distinction **SUPPORTS** | Standards already separate work, object, and representations. | Frequency and cause of practical compression require evidence. |
| What precedes requirements? | S1/S4 process distinctions **SUPPORT** + iteration **QUALIFIES** | Mission/purpose and stakeholder needs are distinct, revisable inputs to requirements. | No warrant for a rigid chronological “stack.” |
| What prevents lexical recurrence from becoming concept identity? | S6 **NORM/DELIMITS** + S5/S15 **CONTEXT** | Term, concept, object, model, and representation are not interchangeable. | Mechanism of learned/platform semantic dominance remains opaque. |
| What makes a KB useful without making it true? | S1 knowledge management + S15 KE architecture + S16 provenance **SUPPORT**; S9/S11 **QUALIFY** claims | Relations, roles, lineage, information needs, and evidence context matter. | No checked standard validates “scientific KB” or candidate-promotion rules. |
| Can AI remain an instrument? | S1 enabling-system category + S12 governance + S14 AI-system lifecycle **CORRELATE** | AI may be an enabling capability or the system of interest; classify the episode explicitly. | The standards do not choose the classification for the paper. |
| How do traceability and rationale connect? | S4 traceability + S5 correspondence/rationale + S1 config/info + S16 provenance **SUPPORT** | Multiple typed relations must remain connected; none alone warrants a claim. | The event graph and immutability design remain local. |
| How should uncertainty enter decisions? | S1/S7/S8 **NORM/SUPPORT** | Risk and uncertainty require lifecycle analysis, treatment, monitoring, and review. | Four classes and propagation chain require separate support. |
| When do signals become evidence? | S9 information need + S11 claim/evidence/argument/context + S10 V&V **CORRELATE** | Measurement and assurance are question- and claim-relative. | Observability tuple and causal sufficiency remain proposed. |
| Who may act, and who remains accountable? | S12/S13 governance + S17 authorization **CORRELATE**; S16 **DELIMITS** provenance | Permission, delegated authority, responsibility, and accountability must not collapse. | Local mandate schema and institutional assignment need validation. |
| Does inspectability improve formation? | S15 only **CONTEXTUALIZES** human understanding | It is reasonable to pose the question. | No educational effect is established. |
| Can the provider-operated assistant independently settle a critique of provider mediation? | S16 attribution + S12/S13 role/accountability context **DELIMIT** rather than decide | Preserve provenance and positional conflict; do not treat provider self-description or assistant certainty as independent verification. | Authorship policy and outside evaluation remain open. |

## 5. Immediate standards-first revision priorities

1. Add S1, S3, and S4 before the first secondary requirements-engineering synthesis; they directly ground the project/process/document distinction.
2. Add S6 before ontology literature, then let ontology papers explain what terminology work does not cover.
3. Add S15 before PROV in the Knowledge Base section; keep “scientific” and candidate-promotion criteria explicitly authorial.
4. Add S7/S8 before the uncertainty taxonomy and label the taxonomy/chain as synthesis.
5. Add S9/S11 before Kalman/OpenTelemetry in the observability section; label the tuple as an analytic device.
6. Keep the already-current IEEE 1012-2024 entry, but move its distinction before oracle literature and avoid clause claims until licensed text is fichado.
7. Add S12/S13 before RATS or access-control analogies in the accountability section; keep the mandate/grant object project-specific.
8. Introduce C9 in the methodological narrative as the engineer's critical practice: candidate-only KB, local absence, local saturation, and visible search conditions.
9. Preserve C3 and C13 as authored observations with their interactional evidence and uncertainty; do not rewrite them into generic model-error or blame narratives.
10. Recast the framework/Erlang passages as selected episodes and provisional devices rather than a standards-derived architecture.
11. Preserve standards and authorial assertions side by side. Record divergence for joint interpretation instead of letting the assistant silently filter the author's content.
12. Add the C15 positional disclosure wherever platform mediation is criticized; do not label the provider-operated assistant an independent reviewer of that criticism.

## 6. Explicitly unresearched or incomplete items

- Licensed clause-level fichamento for ISO/IEC/IEEE 12207:2026, IEEE 1012-2024, and the full responsibility/delegation language in ISO/IEC 38500:2024 and ISO/IEC 42001:2023.
- A standards-level source, if any, for search coverage, evidence-search saturation, and open-world negative findings in engineering research workflows. C9 must remain authorial until such work is separately researched.
- A qualified educational evidence base for the formation hypothesis.
- Empirical evidence for the prevalence of document-as-project compression across organizations or countries.
- Evidence for each transition in the manuscript's uncertainty-propagation chain.
- Evidence that the proposed nine artifacts are jointly sufficient, minimal, or preferable to existing process assets.
- A platform-transparent causal account of symbolic weighting, semantic displacement, and recurrent interactional failure.
- Independent assessment of provider/platform criticism and an explicit publication-policy analysis of mediated institutional co-authorship.
- End-to-end evaluation of the Context Runtime; current Erlang checks remain bounded component trials.

These gaps must be shown as gaps. Fluent connective prose, a large bibliography, or a standards citation at the end of a composite sentence cannot close them.
