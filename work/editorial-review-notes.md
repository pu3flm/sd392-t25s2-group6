# Editorial Review Notes

Working notes for the engineer's review of the current PDF.

## Review rule

- Treat the live discussion as primary authorial work in progress. The engineer is developing the argument through dialogue; these formulations are manuscript source material, not merely feedback, agent-alignment instructions, or commentary about the drafting process.
- When the engineer formulates a distinction, criticism, example, or causal relation in conversation, first recover its substantive content for the final narrative. Do not divert it into a rule about assistant behavior unless the engineer is explicitly discussing assistant operation as the object of the broader AI-use account.
- The drafting task is reconstructive and translational: preserve the engineer's position, relations, uncertainty, and rhetorical force while turning the discussion into coherent prose. The assistant must not replace missing first-person knowledge with a generic academic gradient, a novelty claim, or an invented theoretical closure.
- Capture each objection in the engineer's terms before interpreting it.
- Record the affected passage or section when identifiable.
- Separate misconception, structural drift, terminology, missing relation, and prose/style.
- Do not edit the manuscript while the point is still being developed.
- Apply changes only when the intended correction is clear; otherwise retain the open question for joint review.
- Preserve rejected readings because they define the anti-specification of the paper.

## Notes

### Governing scope of *Before the Project*

- The broader program is a personal engineering account of work with AI across roughly the preceding twelve months. *Before the Project* is one focused narrative within that program: it draws only the episodes that illuminate the neglected epistemic work preceding a project. It is neither the complete annual report nor a final theory derived from the most recent experiment.
- The broader year-long body of work probes AI tools in practice: their capabilities, feasibility, limitations, failure modes, useful application boundaries, and possible improvements. Material such as live subagent/workforce orchestration belongs to that broader report unless it directly illuminates the before-project problem.
- The engineer authored the earlier projects, conversations, trials, and artifacts. Their relationship does not need to be inferred from external chronology as though they belonged to unknown authors; the editorial task is to recover and compare their contents because the engineer cannot hold or precisely retrieve the entire year-long trajectory at once.
- The recent Erlang/BEAM Context Runtime work is the latest trial within that larger body of work. Its feasibility and outcome remain open. It must not be promoted into the manuscript's truth model, universal oracle, final architecture, confirmed solution, or retrospective explanation of everything that preceded it.
- The paper can use small pieces from different trials to expose recurring problems, intentions, methods, and developments. Similarity or overlap between an earlier artifact and the current abstract is a content comparison, not a claim that the current work caused, proved, or completed the earlier one.
- When comparing prior material with the manuscript, report: what overlaps, what differs, what the current text adds, and whether the combination is coherent. Do not manufacture a linear evolution, priority shift, evidentiary conclusion, or historical claim unless the underlying material actually establishes it.
- Do not retrofit bibliography onto a project-specific Erlang concept merely to give it academic appearance. For every externally presented claim, preserve an inspectable link from the exact prose to the exact source passage and distinguish: source-supported statement, engineering synthesis, analogy, hypothesis, proposed terminology, and result of the local trial.
- The engineer's present “trust but verify” review is a compensating control for missing or weak claim-to-source linkage. The final artifact should reduce that burden by making the chain of trust inspectable rather than relying on fluent prose or citation proximity.

### Structural thesis: what precedes a project

- The paper's general object is not Erlang, AI tooling, or one POC. It is the neglected work that precedes and conditions a project.
- The engineer's recurring criticism is that “project” is often reduced to producing a specification, plan, or other document. Those artifacts already presuppose prior choices about what the object is, why it matters, which concepts are admissible, what uncertainty remains, and what would count as success or evidence.
- The missing layer may involve pre-project inquiry, meta-analysis, and sometimes analysis of the frames used by that analysis. These labels are candidates, not interchangeable established terms. The intended claim is that the epistemic formation of the project object cannot be skipped merely because a formal project document exists.
- Keep two narrative levels distinct but connected:
  1. the transferable engineering argument about work that must occur before and throughout any project; and
  2. the first-person account of selected trials across approximately twelve months through which the engineer encountered, tested, and refined that problem.
- Within *Before the Project*, only relevant portions of the annual trajectory should be synthesized across projects and trials rather than divided into one section per artifact. A small amount from each relevant episode can show what was attempted, observed, retained, rejected, or left open.
- The current Erlang trial needs only proportionate treatment as the most recent experiment: what is being attempted with process/object structures and what remains unknown. It must not displace the general argument or absorb the other trials.
- Epistemic coherence requires each narrative move to retain its status: experience is not proof; an engineering observation is not a literature result; a proposed frame is not an established field; a document is not the project; and a working implementation is not evidence that the intended object was correctly formed.

### Document genre and rhetorical posture

- *Before the Project* is not a research paper proposing a production model, universal architecture, or finished method. It is a first-person technical/engineering account focused on how relevant portions of the engineer's longer AI-use trajectory exposed the problem of forming a project before compressing it into documents and specifications.
- The discussion itself is one of the active sites where this account is being worked out. Its value is not that an AI session independently proves the argument; it is that the engineer uses the exchange as a counterweight, exposes conceptual failures, supplies distinctions unavailable to the drafting system, and develops the narrative that the manuscript must faithfully recover.
- The final text must not describe this division of labor as though the assistant discovered the underlying engineering knowledge. The engineer supplies the situated knowledge and develops the criticism; the assistant helps retrieve, compare, structure, and phrase it. Where generic model priors pull the text toward a familiar academic template, that friction is itself relevant to the broader AI-use account when the engineer elects to include it.
- The accumulated interactions provide the trajectory from which the engineer noticed recurring tool behaviors and adapted the way work was conducted. The manuscript may articulate those observations and the approaches that emerged, but it must not upgrade them into a newly proposed formal model merely because they can be arranged systematically.
- Literature should situate, contrast, clarify, or discipline the account. It must not be used to simulate proof of a model the engineer is not claiming to propose.
- Replace proposal rhetoric such as “the defense model is a recursive epistemic stack,” “this paper proposes,” “the resulting framework,” or similar declarative system-building language with narrative-status wording: what I tried, what I observed, what changed in my practice, what seemed useful, what failed, and what remains open.
- “AI is an instrument, not the destination” must not organize the opening or be presented as a constitutive part of the pre-project layer. It may appear later as a reflection arising from the year-long use trajectory, or be omitted if it does not earn a necessary role in the narrative.
- The transferable claim is narrower: before-project epistemic work is routinely neglected in engineering practice, not only in AI-mediated projects and not only in one country. The personal account shows why the engineer became concerned with that neglect; it does not purport to prove its universal incidence.
- Quantitative traces such as dates, session counts, and approximate interaction volume are context for the duration and intensity of the practice. They are not a corpus-validation apparatus, proof, or claim of methodological representativeness.
- Reject the generic academic-innovation template `problem -> novel model -> validation` unless the engineer explicitly makes and supports that claim. It is not the governing form of this manuscript.
- Do not manufacture a heroic-inventor narrative, exceptional-author framing, or implied claim of personal theoretical breakthrough. The engineer is reporting a practical engineering problem and the consequences of trying to work according to existing criteria.
- A short chain of secondary citations cannot establish the causal or conceptual bridge for a broad claim merely because the final sentence is fluent. Citation proximity and the assistant's concluding voice are not warrants.
- The assistant's prose must not close an inferential chain that the engineer did not state or that the cited material does not support. Such additions must either be traceably grounded, marked as a drafting hypothesis for review, or removed.
- The failure that produced the current draft was not simply missing detail in the engineer's prompt. The requested prior trajectory was not recovered, and the missing context was replaced by a familiar academic-proposal structure. The revision must restore source material before drafting connective claims.
- When the engineer supplies a causal interpretation from his study and repeated use—for example, that learned symbolic weighting and platform mediation privilege dominant terms such as *authority* or degraded professional labels—retain it as his stated diagnosis. Do not erase it merely because the assistant cannot inspect a parameter-level causal trace; instead, distinguish the author's assertion and observed interaction pattern from any independently verified mechanism.

### Existing obligations, neglected practice

- In the engineer's declared working vocabulary, **the standards are the oracle**: the governing normative reference against which scope, purpose, terminology, process obligations, and compliance claims are checked. Preserve this formulation in the discussion and do not silently replace it with Erlang, the assistant, a recent experiment, secondary literature, or the accessible corpus as the truth-bearing reference.
- “Standards are the oracle” is a rule of preservation and disciplined comparison, not a license for the assistant to exclude authorial content whenever it perceives a conflict. Retain the engineer's formulation and the normative text side by side with provenance. Interpretation, applicability, conflict, hierarchy, edition, and conformance are objects of the later joint analysis; the assistant may identify candidate tensions but may not adjudicate them unilaterally.
- The manuscript is not proposing another engineering model for the authors themselves or claiming to replace established standards. Its rhetorical challenge is: the relevant obligations already exist across standards and established disciplines; are practitioners actually reading and enacting them before treating a project document as the project?
- Epistemology is not itself one unitary engineering standard. The pertinent epistemic duties are distributed across established work on stakeholder needs, purpose, requirements, lifecycle processes, traceability, decision rationale, uncertainty, risk, V&V, configuration, observability, and accountability.
- Frame the contribution as recovering, juxtaposing, and applying obligations that are routinely fragmented or neglected—not as inventing those obligations.
- Where the manuscript introduces a convenient organizing phrase, mark it as the engineer's descriptive synthesis of the practice or literature, not a proposed replacement standard or a claim that no relevant framework already exists.
- The critical question is operational: what happens when formal standards exist but the upstream work they require is compressed into templates, documentation rituals, or downstream compliance evidence?
- The engineer's practical claim is not merely that standards are neglected. Because common AI-mediated workflows do not preserve or enact those obligations, the engineer has repeatedly had to adapt, constrain, or build tools in order to obtain engineering-usable results.
- The trials demonstrate what changes when AI tools are used under standards-grounded engineering criteria. They do not constitute a proposal to replace those standards.
- Evidence order for the revision must be standards-first:
  1. identify the applicable normative document and its declared scope;
  2. recover its purpose, terminology/glossary, lifecycle/process obligations, required distinctions, and any conformance language;
  3. use books and papers to interpret, compare, criticize, or extend that normative base;
  4. state the engineer's observed tool behavior and trial result in its own first-person evidentiary status.
- The present draft inverts this order: it constructs much of the opening from books and articles, introduces ISO terminology work only later, and reaches IEEE/NASA V&V standards much farther downstream. The revision must not reproduce the same standards-neglect it criticizes.
- Universal wording such as “the world uses AI incorrectly” expresses the engineer's forceful diagnosis but requires bounded presentation. In the manuscript, anchor it in repeated observed practices and in demonstrable divergence from named normative requirements rather than treating universality as already established.

### Heuristic recovery versus source fichamento

- Use **heuristic analysis** for the lightweight recovery of the year-long interaction trajectory: representative prompts, approximate periods, recurring questions, and candidate themes. It is an orientation mechanism, not exhaustive analysis or evidence of frequency by itself.
- Use **source fichamento** for standards and literature that support the manuscript. For every material source, capture at least: declared scope, purpose, terminology/definitions, relevant normative or argumentative passage, exact page/clause, applicability to the manuscript, and explicit non-support.
- Do not convert a desk of forty or fifty consulted PDFs into two ornamental citations beside a broad correlation. The local claim must expose which sources contribute which part of the relation.
- Prefer original standards, official normative documents, primary papers, and authoritative editions. Wikipedia or tertiary summaries cannot serve as the foundation for a material engineering claim.
- In the current manuscript, the “recursive epistemic stack” is presented without a direct warrant and is followed by a synthesis across several literatures. That organization makes the later citations look as though they derive or validate the stack. Unless the engineer deliberately retains it as a personal heuristic description, remove the model form and recover the underlying observations source by source.

### Research acceptance criteria

A research result is not accepted merely because sources were found, opened, cited, or page-checked. For each material argument, the research must preserve this chain:

1. **Question/claim:** state the exact engineering question or proposition being examined.
2. **Normative baseline:** identify applicable standards first, including their scope and terminology; record when no applicable normative source is found.
3. **Qualified sources:** prioritize official standards, primary papers, authoritative editions, and relevant scholarly syntheses; classify source type and limits.
4. **Fichamento:** extract the exact clause, page, definition, argument, assumptions, context, and explicit non-claims relevant to the question.
5. **Typed relation:** mark each source as supporting, qualifying, contradicting, delimiting, contextualizing, or leaving the claim unresolved.
6. **Cross-source correlation:** explain how the sources relate to one another; do not merely list them or place citations after a composite sentence.
7. **Status separation:** keep established normative obligation, published finding, engineering synthesis, analogy, personal observation, heuristic, hypothesis, and proposal visibly distinct.
8. **Claim rewrite:** make the manuscript wording no stronger or broader than the correlated support.
9. **Traceability:** retain an inspectable path from manuscript statement to source passage and from source passage to the role it plays in the reasoning.
10. **Residual uncertainty:** state edition gaps, unavailable clauses, conflicts, and unresolved inference rather than completing them fluently.

The existing PDF-access and pinpoint work satisfies only part of items 3, 4, 8, 9, and 10. It must not be represented as completion of this research process.

### Research pipeline: exploration before correlation

- The governing intention first selects the relevant fields and defines the initial state space of the research. The search is therefore not an unbounded harvest followed by retrospective interpretation; its candidate universe is intention-relative from the outset.
- In the engineer's working method, the first stage is **heuristic state-space exploration**: repeated searches, reformulations, reproductions, branching questions, and neighboring probes continue within and around that intended space until the accessible possibility space is exhausted or reaches an explicit practical saturation condition.
- The expected output of that stage may be hundreds or thousands of candidate works, standards, claims, terms, artifacts, and observations. Breadth at this point is intentional, but it does not yet warrant a conclusion.
- Initial ingestion creates the **Knowledge Base for that intended inquiry**. Every source, assertion, classification, relation, and absence in it remains a candidate; inclusion does not make it true, and exclusion does not establish nonexistence.
- The next stage performs semantic, contextual, epistemological, terminological, and evidentiary comparison across the collection. It identifies overlap, difference, contradiction, dependence, inheritance, scope, assumptions, and gaps.
- Only after those typed relations are formed can the material support synthesis, claim construction, or a defensible account of what is known, proposed, observed, or unresolved.
- The transition must remain visible: `heuristic exploration -> candidate collection -> fichamento -> normalization -> relational comparison -> overlap/gap analysis -> bounded synthesis`.
- “Heuristic” must be defined locally if used in the manuscript. Here it names the engineer's repeated, state-space-oriented exploratory procedure; it must not be silently substituted with a generic claim that every heuristic method is exhaustive.
- A static library contains potentially useful information. The relevant epistemic gain arises from qualified relations and warranted transformations among its contents, not from collection size alone.

### Search observability and open-world limits

- A research Knowledge Base is bounded by the intention, search strategies, catalogs, subscriptions, libraries, repositories, languages, dates, indexes, digitization, permissions, and physical access actually available during the search.
- The accessible corpus is not the world corpus. A missing item may exist in another library, a nondigitized collection, an unindexed archive, a different edition, another language, or a source that is temporarily inaccessible.
- Record negative search results as bounded observations: `not found in sources S, under queries Q, during interval T, with access conditions A`. Never promote them to `does not exist` without an independently warranted closed-world condition.
- Saturation is likewise local: it means that the declared search procedure stopped producing materially new candidates within the observed state space. It does not mean that all relevant knowledge has been exhausted.
- Search observability requires the workflow to expose at least: intended scope, searched surfaces, query families and branches, coverage, access failures, unavailable or nondigitized material, stopping rule, and the inference made from the observed result.
- A tool layer that hides these variables and reports an inferred world state as though it were directly observed creates a misleading epistemic layer. That is a workflow/tooling defect visible in the present practice; reporting it does not by itself propose a new model or implementation.

### Local semantic authority versus external sources

- The local Context Map is the normative state of the active symbolic agreement.
- External documentation or literature may enter as provenance-tagged candidate evidence about an external fact.
- Retrieval must not silently revise the active concept, relation, priority, or operational agreement.
- Any promotion of external material into the Runtime Tree requires an explicit local adjudication event.
- If a provider lookup can overwrite the active Context Map merely because it is newer or externally authoritative, the local runtime has lost the authority it was introduced to preserve.

### Semantic drift in “authority”

- The manuscript currently lets *authority* carry several distinct meanings: a person or institution, legitimacy, decision power, operational permission, and the thing that is delegated.
- The engineer's intended object is the bounded **delegated mandate/grant**: a relation recording who grants whom which decision or action power, for what object, scope, conditions, duration, and revocation rule.
- Do not treat generic authority, authorization, permission, mandate, competence, responsibility, and accountability as interchangeable.
- Model the grant as an explicit object or typed relation; the authority-bearing actor is a different node, and accountability is not automatically transferred with the grant.
- Revisit the article's broader claim about semantic drift so that *authority* itself becomes one of the terms whose drift causes workflow errors.
- Etymological check: English *authority* descends through French from Latin *auctoritas*, derived from *auctor* (originator, creator, promoter); *auctor* is related to *augere* (to increase, originate, promote). This supports the historical relation between authorship/origination and authority, but does **not** make the two words strict modern synonyms. Sources checked: Merriam-Webster, Oxford Learner's Dictionaries, and Lewis & Short via Perseus.
- Candidate architectural decomposition: `author of intent` → `delegated mandate/grant` → `authorized executor`; keep `responsibility`, `accountability`, `permission`, and `liability` as separately typed relations.
- Broader thesis to research rather than assert universally: computer systems commonly operationalize *authority* as an enforceable proxy such as a role, permission, access-control rule, credential, or capability. That narrowing is useful inside a formal security model, but becomes a category error when exported as the whole sociotechnical concept and allowed to erase authorship, mandate provenance, legitimacy, responsibility, and liability.
- Consequence for AI and semantic tooling: one lexical label can activate heterogeneous semantic, ontological, and contextual neighborhoods. Word-level recurrence must therefore never be treated as concept identity. Normalize each occurrence into a typed candidate relation before it can influence inference or action.
- For *authority*, the disambiguation set presently includes at least: `authorship/origination`, `epistemic warrant/source`, `institutional legitimacy`, `delegated mandate`, `authorization/permission`, `executable capability`, and `authority-bearing actor`.
- Supporting technical example to evaluate for the paper: NIST's security glossary distinguishes *authority* (persons or bodies with rights and responsibilities) from *authorization* (privileges or the act of granting them), while NIST's ABAC guidance explicitly uses *access control* and *authorization* synonymously within its local model. This is evidence of model-scoped terminology, not proof that every computing use is globally wrong.
