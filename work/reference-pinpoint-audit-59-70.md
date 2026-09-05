# Claim-to-source pinpoint audit: external references 59--70

Audited 5 September 2026 against `outputs/before-the-project.tex`, SHA-256 `9f6613fed7b485c7812d52713b5964f5cc7c4c903db6c79ba8dc01c6539eb230`. The citation-use search found 15 uses of bibliography keys 59--70. No other uses of these keys occur in the manuscript.

Page notation is deliberately explicit:

- **published p.** means the page printed in the version of record or proceedings;
- **PDF p.** means the one-based page number of the linked PDF object;
- **author-ms p.** means the page printed inside a prepublication author manuscript;
- the two HTML sources are unpaginated, so their section and paragraph are the stable pinpoint.

The four requested classifications are used as follows. **Supported** means the cited source directly warrants the manuscript claim. **Supported with narrower wording** means a source-backed formulation is available but the present sentence goes beyond it. **Version/page mismatch** means the claim is present, but the lawful copy is not the cited version of record or does not carry its pagination. **Not verified** would mean that no adequate support was located in the lawful source; no use fell wholly into that category, although part of the Vincenti sentence could not be pin-pointed beyond the publisher description.

## Result matrix

| Ref. | Key | Manuscript line | Classification |
|---:|---|---:|---|
| 59 | `steyvers2025` | 356 | Supported |
| 60 | `swebench` | 344 | Supported |
| 61 | `sweverified` | 344 | Supported |
| 62 | `taubench` | 340 | Supported |
| 63 | `vanlamsweerde2000` | 128 | Version/page mismatch (claim supported in author manuscript) |
| 64 | `vincenti1990` | 104 | Supported with narrower wording |
| 65 | `w3ctrace` | 314 | Supported with narrower wording |
| 66 | `walker2003` | 232 | Version/page mismatch (claim supported in repository copy) |
| 67 | `weyuker1982` | 308 | Supported |
| 68 | `yu1997` | 76 | Supported |
| 68 | `yu1997` | 94 | Supported with narrower wording |
| 68 | `yu1997` | 120 | Supported |
| 69 | `zavejackson1997` | 94 | Version/page mismatch (claim supported in author manuscript) |
| 69 | `zavejackson1997` | 126 | Supported with narrower wording; also subject to the author-manuscript pagination caveat |
| 70 | `zheng2023` | 348 | Supported with narrower wording |

## 59. `steyvers2025` at manuscript line 356

**Claim audited.** Explanation length and expressed uncertainty altered participant confidence, while extra explanation length did not yield a corresponding improvement in distinguishing correct from incorrect answers in the tested question-answering tasks.

**Pinpoint.** The Results subsection “Explanation style and length affect human confidence” reports the uncertainty-language and length effects, including the long/short/uncertainty-only comparisons, at [published pp. 224--225 / PDF pp. 4--5](https://mstrep.s3.amazonaws.com/publications/WhatLLMsKnowSteyversetal.pdf#page=4). The continuation at [published p. 225 / PDF p. 5](https://mstrep.s3.amazonaws.com/publications/WhatLLMsKnowSteyversetal.pdf#page=5) states that confidence increased without a corresponding increase in discrimination sensitivity. The Discussion restates the length-bias result at [published p. 226 / PDF p. 6](https://mstrep.s3.amazonaws.com/publications/WhatLLMsKnowSteyversetal.pdf#page=6).

**Assessment: Supported.** The manuscript appropriately confines the inference to the tested multiple-choice and short-answer settings and says “did not necessarily,” rather than making a universal claim.

**Page caveat.** The author-hosted file is publisher-formatted. Its first 11 PDF pages correspond to the version-of-record span 221--231; PDF pp. 12--16 are extended-data pages and do not continue that journal pagination.

## 60. `swebench` at manuscript line 344

**Claim audited.** SWE-bench determines success with hidden fail-to-pass and regression checks.

**Pinpoint.** Section 2.1 defines `FAIL_TO_PASS` tests at [proceedings/PDF p. 2](https://proceedings.iclr.cc/paper_files/paper/2024/file/edac78c3e300629acfe6cbe9ca88fb84-Paper-Conference.pdf#page=2). Sections 2.2--2.3 state that all associated tests must pass and describe the additional tests that check preservation of prior functionality at [p. 3](https://proceedings.iclr.cc/paper_files/paper/2024/file/edac78c3e300629acfe6cbe9ca88fb84-Paper-Conference.pdf#page=3). Appendix A.1 expressly labels the test patch as containing “unseen tests” and distinguishes `FAIL_TO_PASS` from `PASS_TO_PASS` at [pp. 15--16](https://proceedings.iclr.cc/paper_files/paper/2024/file/edac78c3e300629acfe6cbe9ca88fb84-Paper-Conference.pdf#page=15); Appendix A.4 gives the exact all-F2P/all-P2P resolution rule at [p. 20](https://proceedings.iclr.cc/paper_files/paper/2024/file/edac78c3e300629acfe6cbe9ca88fb84-Paper-Conference.pdf#page=20).

**Assessment: Supported.** “Regression tests” is a reasonable functional gloss, but the source's exact name is `PASS_TO_PASS`. A maximally source-faithful wording would say “hidden `FAIL_TO_PASS` and `PASS_TO_PASS` tests.”

**Page caveat.** The 51-page ICLR proceedings PDF carries matching printed and PDF page numbers, including its appendices.

## 61. `sweverified` at manuscript line 344

**Claim audited.** Human revalidation removed many infeasible or underspecified instances and materially changed measured performance.

**Pinpoint.** The official OpenAI article's “Adapting SWE-bench as a Preparedness Evaluation” section identifies overly specific or irrelevant tests, underspecified descriptions, and unreliable environments. “SWE-bench Verified” and “Our Approach” describe professional-developer screening and a 500-sample validated subset. “Dataset construction” states the removal rule. The first paragraph under “Annotation Results” reports 38.3% flagged for underspecification, 61.1% for potentially unfair tests, and 68.3% filtered overall. The second paragraph under “Performance on SWE-bench Verified” reports a change from 16% to 33.2% for GPT-4o with the best-performing tested scaffold. These are all on the [official, unpaginated article](https://openai.com/index/introducing-swe-bench-verified/).

**Assessment: Supported.** “Materially changing measured performance” is supported by the reported 16%/33.2% comparison. It should continue to be read as a benchmark-configuration result, not a model-wide performance law: the article's note 4 says the scaffold runs used a single seed and that results can differ from leaderboard results.

**Version caveat.** This is HTML, not a paginated paper. The cited page was published 13 August 2024 and updated 24 February 2025; section names are the appropriate pinpoint.

## 62. `taubench` at manuscript line 340

**Claim audited.** The benchmark places an agent between a simulated user, policy, and APIs; scores final database state plus required output; repeated-run reliability drops substantially; and full reward can coexist with a missing required confirmation.

**Pinpoint.** Figure 1 and the benchmark setup describe the simulated user, domain policy, and database APIs at [proceedings/PDF pp. 2--3](https://proceedings.iclr.cc/paper_files/paper/2025/file/1b126cc38b8638e07bef37e7b2bb72bf-Paper-Conference.pdf#page=2). The “Task instances” and “Reward” paragraphs define the final-database and required-output product at [p. 4](https://proceedings.iclr.cc/paper_files/paper/2025/file/1b126cc38b8638e07bef37e7b2bb72bf-Paper-Conference.pdf#page=4). The first paragraph of [p. 5](https://proceedings.iclr.cc/paper_files/paper/2025/file/1b126cc38b8638e07bef37e7b2bb72bf-Paper-Conference.pdf#page=5) explicitly gives the no-confirmation/full-reward counterexample. The “Pass-hat-k metric” paragraph is also on p. 5; Section 5.1 and Figure 4 report that the best GPT-4o retail configuration falls from above 60% at pass-hat-1 to below 25% at pass-hat-8 at [pp. 7--8](https://proceedings.iclr.cc/paper_files/paper/2025/file/1b126cc38b8638e07bef37e7b2bb72bf-Paper-Conference.pdf#page=7).

**Assessment: Supported.** For typographic precision, the source's repeated-run metric is pass-hat-k; at k=1 it is equal to pass@1, but the reported reliability curve is not the ordinary pass@k curve.

**Page caveat.** The 53-page ICLR proceedings PDF and its printed page numbers align. The 50-page arXiv version is not used for these pinpoints.

## 63. `vanlamsweerde2000` at manuscript line 128

**Claim audited.** Obstacle analysis confronts over-ideal goal models with possible conditions that can obstruct the goals.

**Pinpoint.** The abstract says first-sketch goals and assumptions may be too ideal and introduces techniques that generate obstacles from goal formulations and domain properties at [author PDF p. 1](https://webperso.info.ucl.ac.be/~avl/files/TSE-Obstacles.pdf#page=1). The Introduction defines an obstacle as an undesirable but possible condition under which a goal may not be achieved and presents the method as deidealization at [author-ms/PDF p. 2](https://webperso.info.ucl.ac.be/~avl/files/TSE-Obstacles.pdf#page=2). Section 3.1 formalizes obstruction at [author-ms/PDF pp. 5--6](https://webperso.info.ucl.ac.be/~avl/files/TSE-Obstacles.pdf#page=5), and Section 4 integrates obstacle identification and resolution into goal elaboration at [pp. 7--8](https://webperso.info.ucl.ac.be/~avl/files/TSE-Obstacles.pdf#page=7).

**Assessment: Version/page mismatch (substance supported).** The manuscript's one-sentence characterization is substantively accurate. “Tests” is an interpretive verb; “generates and checks obstacle conditions from goal formulations and domain properties” would reproduce the method more literally.

**Page caveat.** The lawful file is a 29-page revised/expanded author manuscript marked “to appear.” The cited version of record is *IEEE TSE* 26(10), 978--1005, a 28-page journal span. The manuscript page numbers above cannot safely be converted into final IEEE page numbers.

## 64. `vincenti1990` at manuscript line 104

**Claim audited.** Vincenti rejects engineering as mere application of scientific knowledge and shows engineers generating domain-specific knowledge through design, analysis, testing, and iteration.

**Pinpoint.** The [official Johns Hopkins University Press description](https://www.press.jhu.edu/books/title/3022/what-engineers-know-and-how-they-know-it) says that engineering problem-solving knowledge may appear mundane or derivative from science but is sophisticated and internal to engineering, and that the book explains how engineering knowledge is obtained and grows. Its table of contents identifies case chapters on design, design requirements, control-volume analysis, test-derived data, production, and a concluding variation-selection model.

**Assessment: Supported with narrower wording.** The official description directly supports the first sentence and the general claim that design work obtains and grows engineering knowledge. It does not supply a page-level basis for the manuscript's exact four-part list, especially “iteration.” A fully verified formulation would be: “Vincenti presents engineering knowledge as sophisticated and internal to engineering rather than merely derivative from science, and traces how it is obtained and grows through design problems.”

**Edition/page caveat.** No lawful free full-text PDF was located. The bibliography cites the 1990 edition, whereas the current publisher page describes the 1993 paperback; neither the web description nor the contents page can establish a 1990-edition pinpoint.

## 65. `w3ctrace` at manuscript line 314

**Claim audited.** In a jointly cited paragraph, trace reconstruction depends on propagation/instrumentation; sampling leaves missing paths; and instrumentation can alter timing or evidence.

**Pinpoint.** The W3C Recommendation's [§2.1, “Problem Statement”](https://www.w3.org/TR/2021/REC-trace-context-1-20211123/#problem-statement) explains that a distributed trace must remain identifiable across components and that absent/common propagation can break correlation, propagation, or vendor metadata. [§2.2, “Solution”](https://www.w3.org/TR/2021/REC-trace-context-1-20211123/#solution) defines the linking role of a common trace context. [§3.2.2.5.1, “Sampled flag”](https://www.w3.org/TR/2021/REC-trace-context-1-20211123/#sampled-flag) states that recording only a subset yields broken traces, recording everything can be prohibitively expensive, and uncoordinated collection decisions fragment traces.

**Assessment: Supported with narrower wording.** This source supports the propagation, correlation, sampling-cost, and fragmentation parts. It does **not** establish the paragraph's observer-effect claims that instrumentation changes timing or mutates evidence; those require the other jointly cited sources. Do not attribute the entire paragraph to W3C alone.

**Version/page caveat.** The 23 November 2021 Recommendation is authoritative, stable, unpaginated HTML. Section anchors, not page numbers, are the precise citation units.

## 66. `walker2003` at manuscript line 232

**Claim audited.** Walker et al. distinguish uncertainty's nature from its location in context, inputs, model structure, technical implementation, parameters, and outcomes.

**Pinpoint.** Section 3 identifies location, level, and nature as separate dimensions at [repository PDF p. 4](https://repository.tudelft.nl/file/File_f19ef7d6-bb60-40ac-9a62-99a47341bf4f#page=4). Section 4 defines the locations and lists context, model uncertainty (including model-structure and model-technical uncertainty), inputs, parameters, and model outcomes at [PDF pp. 5--7](https://repository.tudelft.nl/file/File_f19ef7d6-bb60-40ac-9a62-99a47341bf4f#page=5). Section 6 separately defines the nature dimension as epistemic uncertainty versus variability uncertainty at [PDF p. 9](https://repository.tudelft.nl/file/File_f19ef7d6-bb60-40ac-9a62-99a47341bf4f#page=9).

**Assessment: Version/page mismatch (claim supported).** The taxonomy in the manuscript is accurate; “outputs” is a harmless shortening of the source term “model outcome uncertainty.”

**Page caveat.** The TU Delft deposit is a 13-page production-stage file whose first page still says “Vol. 00, No. 0, pp. 000--000” and whose internal headers run 1--13. The version of record is *Integrated Assessment* 4(1), 5--17. Because the deposit does not carry final journal pagination, the PDF pinpoints above must not be cited as published pp. 8--13 by simple arithmetic.

## 67. `weyuker1982` at manuscript line 308

**Claim audited.** Observable output can remain untestable when there is no feasible oracle for deciding its correctness.

**Pinpoint.** The abstract and §1 define an oracle as the tester or external mechanism that can decide whether output is correct and define a program as non-testable when no oracle exists or when obtaining the correct output is practically too difficult, at [published p. 465 / PDF p. 1](https://homes.cs.washington.edu/~rjust/courses/CSE503/2021_02_12-reading1.pdf#page=1). Section 2 develops partial-oracle examples and classes of non-testable programs at [published pp. 465--466 / PDF pp. 1--2](https://homes.cs.washington.edu/~rjust/courses/CSE503/2021_02_12-reading1.pdf#page=1).

**Assessment: Supported.** “Relation” is terminology supplied more explicitly by the jointly cited later oracle literature; Weyuker directly supports the absence or practical infeasibility of a correctness-deciding oracle.

**Page caveat.** The institutional scan preserves the version-of-record pagination exactly: PDF pp. 1--6 correspond to published pp. 465--470.

## 68a. `yu1997` at manuscript line 76

**Claim audited.** Early- and late-phase requirements work is not strictly sequential or merely temporal.

**Pinpoint.** The conclusion says exactly that the relationship between early and late requirements engineering is not strictly sequential or even temporal, then explains that each phase generates and draws on knowledge maintained throughout the lifecycle, at [published p. 234 / PDF p. 9](https://www.cs.toronto.edu/pub/eric/RE97.pdf#page=9).

**Assessment: Supported.** No narrowing is needed.

## 68b. `yu1997` at manuscript line 94

**Claim audited.** Stakeholder goals and dependencies have “rationale priority” over detailed prescriptions.

**Pinpoint.** The abstract and Introduction distinguish early-phase inquiry into organizational goals, stakeholder interests, alternatives, implications, and “whys” from later detailed specification at [published p. 226 / PDF p. 1](https://www.cs.toronto.edu/pub/eric/RE97.pdf#page=1). Section 3 says the requirements engineer helps stakeholders find solutions and that decisions remain with stakeholders at [published p. 232 / PDF p. 7](https://www.cs.toronto.edu/pub/eric/RE97.pdf#page=7); it contrasts multi-lateral intentional dependencies with the later unilateral prescriptive model at [published p. 233 / PDF p. 8](https://www.cs.toronto.edu/pub/eric/RE97.pdf#page=8).

**Assessment: Supported with narrower wording.** “Rationale priority” is this manuscript's synthesis, not Yu's stated formal ordering. A source-nearer formulation would be: “Yu treats stakeholder goals, interests, alternatives, and dependencies as the rationale-bearing subject matter of early-phase inquiry before conversion to a detailed prescriptive model.”

## 68c. `yu1997` at manuscript line 120

**Claim audited.** Early intentional modeling covers actors, goals, beliefs/capabilities, dependencies, alternatives, and rationales; stakeholders decide while the requirements engineer supports.

**Pinpoint.** The abstract/Introduction covers stakeholder interests, alternatives, implications, goals, and “whys” at [published p. 226 / PDF p. 1](https://www.cs.toronto.edu/pub/eric/RE97.pdf#page=1). Section 2 defines actors as having goals, beliefs, abilities, and commitments and describes strategic dependencies at [published p. 227 / PDF p. 2](https://www.cs.toronto.edu/pub/eric/RE97.pdf#page=2). Section 3 states that stakeholders are information sources and decision makers and that the requirements engineer primarily supports them at [published p. 232 / PDF p. 7](https://www.cs.toronto.edu/pub/eric/RE97.pdf#page=7); the means--ends discussion reiterates stakeholder choice at [published p. 233 / PDF p. 8](https://www.cs.toronto.edu/pub/eric/RE97.pdf#page=8).

**Assessment: Supported.** “Capabilities” paraphrases Yu's “abilities”; the remainder is directly supported.

**Page caveat for all three Yu uses.** The author-hosted proceedings copy retains final pp. 226--235, with PDF p. 1 = published p. 226 and PDF p. 10 = published p. 235. Some mathematical/*i* glyphs extract poorly, but the cited prose is legible.

## 69a. `zavejackson1997` at manuscript line 94

**Claim audited.** Domain knowledge and specification bear the logical adequacy relation `K,S ⊢ R` to requirements.

**Pinpoint.** Section 5 defines `R` as requirements, `S` as implementable specifications, and `K` as relevant indicative domain knowledge, then states that `S` and `K` must together guarantee `R`, at [PDF p. 21 / author-ms p. 20](https://www.pamelazave.com/4dc.pdf#page=21). The completion criteria repeat the entailment condition later in the manuscript.

**Assessment: Version/page mismatch (substance supported).** The logical relation is explicit, but the lawful author copy is not the final ACM pagination.

## 69b. `zavejackson1997` at manuscript line 126

**Claim audited.** Requirements describe desired relations in the environment; specifications express implementable machine-side behavior at the interface and, together with valid domain assumptions, suffice for the requirements.

**Pinpoint.** Section 3.2 locates requirements in the environment and defines indicative domain knowledge versus optative desired properties at [PDF pp. 8--10 / author-ms pp. 7--9](https://www.pamelazave.com/4dc.pdf#page=8). The action-control discussion distinguishes shared and unshared environmental phenomena and machine-controlled actions at [PDF pp. 12--13 / author-ms pp. 11--12](https://www.pamelazave.com/4dc.pdf#page=12). Section 5 defines a specification as an implementable optative property and gives `S,K ⊢ R` at [PDF p. 21 / author-ms p. 20](https://www.pamelazave.com/4dc.pdf#page=21); §5.1 explains that specifications coordinated with domain knowledge guarantee requirements at [PDF p. 23 / author-ms p. 22](https://www.pamelazave.com/4dc.pdf#page=23).

**Assessment: Supported with narrower wording.** “Machine behaviors expressible at the boundary” is broadly right but slightly blurs the paper's insistence that all descriptions are grounded in environmental phenomena. A source-faithful formulation would be: “a specification is an implementable optative property stated in shared phenomena and constraining machine-controlled behavior; together with valid domain knowledge it guarantees the requirement.”

**Page caveat for both Zave/Jackson uses.** The linked 35-page author manuscript is dated 16 July 1996 and uses its own page sequence; the version of record is *ACM TOSEM* 6(1), 1--30 (1997). The author-ms/PDF pinpoints must not be presented as final ACM pages.

## 70. `zheng2023` at manuscript line 348

**Claim audited.** LLM judges show high human agreement in some comparisons, answer-order inconsistency, verbosity susceptibility, and strong dependence on rubric/reference answers.

**Pinpoint.** The abstract reports greater-than-80% agreement in the evaluated settings at [proceedings/PDF p. 1](https://proceedings.neurips.cc/paper_files/paper/2023/file/91f18a1287b398d378ef22505bf41832-Paper-Datasets_and_Benchmarks.pdf#page=1). Section 3.3 and Tables 2--3 document position inconsistency and the repetitive-list verbosity test at [pp. 4--5](https://proceedings.neurips.cc/paper_files/paper/2023/file/91f18a1287b398d378ef22505bf41832-Paper-Datasets_and_Benchmarks.pdf#page=4). Section 3.4 reports that few-shot prompting changed GPT-4 consistency from 65.0% to 77.5% and that a reference-guided math judge reduced the small test's failure rate from 70% to 15% at [p. 6](https://proceedings.neurips.cc/paper_files/paper/2023/file/91f18a1287b398d378ef22505bf41832-Paper-Datasets_and_Benchmarks.pdf#page=6). Section 4.2 reports 85% non-tie GPT-4/human agreement on MT-bench and describes the tested single-answer judge as having a relatively stable internal rubric at [pp. 7--8](https://proceedings.neurips.cc/paper_files/paper/2023/file/91f18a1287b398d378ef22505bf41832-Paper-Datasets_and_Benchmarks.pdf#page=7).

**Assessment: Supported with narrower wording.** High agreement, order sensitivity, verbosity bias, and a large reference-guidance effect on the small math test are supported. “Strong dependence on rubric” is not: the paper instead calls the tested GPT-4 judge's internal rubric relatively stable. A precise replacement is “sensitivity to judge setup and prompting, with reference-guided grading substantially reducing errors in the tested math comparison.”

**Page caveat.** The official 29-page NeurIPS proceedings PDF has matching printed/PDF pages and includes appendices. The pinpoints above concern the main paper, not the arXiv version.

## Surgical follow-up priorities

1. **Line 348 (`zheng2023`):** remove the unsupported “strong dependence on rubric” phrase; retain prompt/setup sensitivity and the bounded reference-guided math result.
2. **Line 104 (`vincenti1990`):** narrow the exact process list unless a lawful copy of the cited 1990 edition is consulted for page-level support.
3. **Line 314 (`w3ctrace`):** keep W3C attached only to propagation and sampling/fragmentation; do not treat it as support for timing perturbation or evidence mutation.
4. **Line 126 (`zavejackson1997`):** prefer “shared environmental phenomena constraining machine-controlled behavior” over language that sounds as though their specification directly describes machine internals.
5. **Pinpoint hygiene only:** `vanlamsweerde2000`, `walker2003`, and `zavejackson1997` are substantively supported, but any future page citation must either name the manuscript/repository page explicitly or be checked against the version of record.
