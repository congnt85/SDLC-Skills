# Evolution Analysis Guide

Methodology for analyzing skill output quality and proposing targeted improvements to skill definitions.

---

## 1. Scorecard-to-Root-Cause Mapping

Each scorecard dimension has characteristic root causes. Use these heuristics to guide investigation:

### Completeness (Score < 4)

**Symptoms**: Missing sections, incomplete tables, absent diagrams, unexplored areas.

| Root Cause Pattern | Target Layer |
|-------------------|-------------|
| Template lacks the section entirely | `templates/output-template.md` |
| Template has section but skill skipped it | `SKILL.md` Step 4 (generate instructions) |
| Knowledge doesn't cover the topic | `knowledge/*.md` |
| Sample output shows shallow version of section | `templates/sample-output.md` |

### Clarity (Score < 4)

**Symptoms**: Ambiguous wording, vague descriptions, unclear responsibilities, passive voice overuse.

| Root Cause Pattern | Target Layer |
|-------------------|-------------|
| Workflow step instructions are ambiguous | `SKILL.md` Step 4 |
| Knowledge lacks specific examples | `knowledge/*.md` |
| Template placeholders don't describe expected content clearly | `templates/output-template.md` |
| Sample output demonstrates vague writing | `templates/sample-output.md` |
| No rule enforcing specificity | `rules/output-rules.md` |

### Consistency (Score < 4)

**Symptoms**: Cross-reference mismatches, conflicting terminology, ID misalignment, format inconsistencies.

| Root Cause Pattern | Target Layer |
|-------------------|-------------|
| No validation rule for cross-reference checking | `rules/output-rules.md` |
| Template sections use inconsistent naming | `templates/output-template.md` |
| Workflow doesn't include consistency check pass | `SKILL.md` Step 5 |
| Knowledge uses inconsistent terminology | `knowledge/*.md` |

### Quantification (Score < 4)

**Symptoms**: Vague metrics ("fast", "many"), missing numbers, non-measurable success criteria.

| Root Cause Pattern | Target Layer |
|-------------------|-------------|
| No rule requiring specific metrics | `rules/output-rules.md` |
| Knowledge doesn't teach quantification techniques | `knowledge/*.md` |
| Template fields don't prompt for numeric values | `templates/output-template.md` |
| Sample output uses vague language | `templates/sample-output.md` |

### Traceability (Score < 4)

**Symptoms**: Items not linked to source, missing IDs, broken reference chains, orphan items.

| Root Cause Pattern | Target Layer |
|-------------------|-------------|
| No rule requiring source tracing | `rules/output-rules.md` |
| Template lacks traceability columns/fields | `templates/output-template.md` |
| Knowledge doesn't explain traceability approach | `knowledge/*.md` |
| Workflow doesn't include traceability verification | `SKILL.md` Step 5 |

---

## 2. Diff Analysis Technique

Systematic comparison of draft (AI-generated) vs final (user-corrected) to identify what the skill got wrong.

### Phase 1: Structural Analysis

Compare at the section level first:

1. List all top-level sections (H2) in both draft and final
2. Identify: sections added by user, sections removed by user, sections reordered
3. For each surviving section, note if sub-sections (H3+) changed

### Phase 2: Content Analysis

Within each section, compare content:

1. **Additions**: Content present in final but absent from draft
   - New paragraphs, table rows, list items, diagram elements
   - Classify: was this information available in the input? (If yes → skill missed it. If no → skill couldn't have known)

2. **Corrections**: Content present in both but changed
   - Factual corrections (wrong information → right information)
   - Precision improvements (vague → specific)
   - Wording/tone changes (unclear → clear)

3. **Removals**: Content present in draft but absent from final
   - Irrelevant content (skill generated off-topic material)
   - Redundant content (said the same thing twice)
   - Incorrect content (factually wrong, removed entirely)

4. **Restructuring**: Same content, different organization
   - Reordered items within a table or list
   - Merged or split sections
   - Changed hierarchy levels

### Phase 3: Change Classification

For each significant change, classify by:

| Classification | Meaning | Skill Layer Hint |
|---------------|---------|-----------------|
| **Knowledge Gap** | Skill lacked domain expertise | `knowledge/*.md` |
| **Template Gap** | Output structure was wrong/incomplete | `templates/output-template.md` |
| **Rule Gap** | Quality constraint not enforced | `rules/output-rules.md` |
| **Workflow Gap** | Process step missing or unclear | `SKILL.md` |
| **Calibration Gap** | Right structure but wrong depth/quality | `templates/sample-output.md` |
| **Input Miss** | Information was in input but skill didn't use it | `SKILL.md` Step 3 or Step 4 |
| **Project-Specific** | Change only applies to this particular project | NOT a skill issue |

### Phase 4: Significance Filtering

Not every change warrants a skill evolution. Filter out:

- **Formatting-only changes**: Group as "{N} formatting changes" — no skill evolution needed
- **Project-specific content**: Information unique to the user's project that the skill couldn't generalize from
- **Preference changes**: Subjective style choices that vary by user (unless pattern repeats across multiple evolutions)
- **Minor wording tweaks**: Small phrasing changes that don't indicate a systematic problem

Focus on changes that indicate a **repeatable pattern** — something the skill would get wrong again on a different project.

---

## 3. Change Impact Assessment

Not all skill file modifications have equal impact. Prioritize changes based on enforcement power:

### Impact Hierarchy

```
rules/output-rules.md     ████████████  Highest enforcement — validated in Step 5
templates/output-template.md  ████████████  Highest structural impact — defines output shape
SKILL.md (Step 4)          ██████████   Direct generation instructions
knowledge/*.md             ████████     Influences quality but not enforced
templates/sample-output.md ██████       Calibration influence, least direct
```

### Priority Assignment

| Priority | Criteria | Example |
|----------|----------|---------|
| **HIGH** | Would prevent a score of 1-2 on any dimension. Or: user had to add/rewrite an entire section. | Missing template section that user always adds |
| **MEDIUM** | Would improve a score of 3 to 4+. Or: user consistently corrects the same type of content. | Knowledge gap causing shallow treatment of a topic |
| **LOW** | Would improve a score of 4 to 5. Polish-level improvement. | Sample output could demonstrate better quantification |

### Estimating Post-Evolution Score

For each proposed change, estimate the scorecard impact:

- A new rule (HIGH priority) typically improves its dimension by 1-2 points
- A template addition (HIGH priority) typically improves Completeness by 1-2 points
- A knowledge addition (MEDIUM priority) typically improves Clarity/Quantification by 0.5-1 point
- A sample output improvement (LOW priority) typically improves calibration by 0.5 points

These are heuristics — actual impact depends on the specific change.

---

## 4. Evolution Anti-Patterns

### Anti-Pattern 1: Over-Fitting

**Symptom**: Proposed changes are too specific to the project that triggered the analysis.

**Example**: "Add a section for 'Mobile App Push Notification Architecture'" — this is project-specific, not a generalizable skill improvement.

**Guard**: Ask: "Would this change help the skill produce better output for ANY project, or just this one?" If only this one, classify as "project-specific" and do not propose as a skill change.

**Rule**: EVO-06

### Anti-Pattern 2: Scope Creep

**Symptom**: Analysis proposes changes that belong to a different skill or to shared resources.

**Example**: Evolution of `req/epic` proposes adding user story details — this belongs to `req/userstory`.

**Guard**: Check the target skill's "This skill does NOT" section. If the proposed change falls outside scope, flag it as a different skill's issue.

### Anti-Pattern 3: Template Bloat

**Symptom**: Every evolution adds more required sections, making the template increasingly heavy.

**Example**: After 5 evolutions, the template has 30 required sections — no project needs all of them.

**Guard**: When adding a section, consider:
- Is this needed for >50% of projects? → Make it required
- Is this needed for some projects? → Make it optional with "[Optional]" marker
- Is this rarely needed? → Add to knowledge as a technique, not to template

### Anti-Pattern 4: Rule Inflation

**Symptom**: Too many rules reduce compliance and make validation a bottleneck.

**Example**: After 5 evolutions, the skill has 50 rules — many overlap or conflict.

**Guard**: Before adding a new rule:
- Can an existing rule be tightened instead of adding a new one?
- Does this rule conflict with or duplicate an existing rule?
- Is this rule enforceable (can Step 5 actually check it)?

### Anti-Pattern 5: Regression Introduction

**Symptom**: A change that fixes one dimension's score causes another dimension's score to drop.

**Example**: Adding strict quantification rules improves Quantification but hurts Clarity (too many numbers obscure the narrative).

**Guard**: For each proposed change, consider side effects on other dimensions. If a trade-off exists, note it explicitly in the proposal.

---

## 5. Multi-Evolution Tracking

When a skill has been evolved multiple times, use the evolution history to:

1. **Detect recurring issues**: If the same dimension scores low across multiple evolutions, the previous fixes were insufficient — need a deeper intervention
2. **Measure evolution effectiveness**: Compare pre-evolution and post-evolution scorecard averages
3. **Prevent oscillation**: If evolution N added something that evolution N+2 removes, there's an underlying design tension to resolve
4. **Track cumulative drift**: Review all patch notes to ensure the skill hasn't drifted from its original purpose

Access evolution history at: `skills/<phase>/<skill>/evolution/*/patch-note.md`
