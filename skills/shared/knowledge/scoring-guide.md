# Quality Scoring Guide

Methodology for evaluating SDLC artifacts across the 5 quality dimensions. Used by `--score` mode in every skill.

---

## Scoring Scale

| Score | Level | Meaning |
|-------|-------|---------|
| 1 | Critical | Section missing or mostly empty — fails to serve its purpose |
| 2 | Major Issues | Present but vague, inconsistent, or incomplete — needs significant rework |
| 3 | Acceptable | Covers the basics but lacks depth, precision, or polish |
| 4 | Good | Thorough, specific, minor improvements possible |
| 5 | Excellent | Comprehensive, quantified, consistent, fully traceable |

**Important**: Score based on evidence, not impression. Every score must cite specific sections or items that justify it.

---

## Dimension 1: Completeness

**Question**: Are all expected sections present and populated with substantive content?

### How to Evaluate

1. Read the skill's own `templates/output-template.md` to get the expected structure
2. Compare each expected section against the artifact:
   - Section present and populated? → contributes to higher score
   - Section present but shallow (1-2 sentences where paragraphs expected)? → deduction
   - Section missing entirely? → major deduction
3. Check for implied completeness:
   - All input items covered? (e.g., all objectives mapped, all features assigned)
   - Tables fully populated? (no empty cells where values expected)
   - Diagrams/visualizations present where template expects them?

### Scoring Criteria

| Score | Criteria |
|-------|----------|
| 1 | ≥3 required sections missing, or >50% of sections are stubs |
| 2 | 1-2 required sections missing, or >30% of sections lack depth |
| 3 | All required sections present, but some optional sections missing or some sections could be deeper |
| 4 | All required sections present with good depth, most optional sections included |
| 5 | All sections present (required + optional), every table fully populated, diagrams included |

---

## Dimension 2: Clarity

**Question**: Is the content unambiguous and actionable? Could a new team member understand it without additional context?

### How to Evaluate

1. Check for ambiguous language:
   - Weasel words: "might", "could", "possibly", "sometimes", "generally"
   - Vague qualifiers: "fast", "many", "large", "easy", "complex"
   - Passive voice hiding responsibility: "it will be done" (by whom?)
2. Check for actionability:
   - Can each item be acted on directly?
   - Are responsibilities assigned to specific roles?
   - Are conditions and triggers explicitly stated?
3. Check for jargon without definition:
   - Domain terms used without explanation?
   - Acronyms without expansion on first use?

### Scoring Criteria

| Score | Criteria |
|-------|----------|
| 1 | Pervasive ambiguity — most items are vague or unclear |
| 2 | Frequent ambiguity — >30% of items use vague language or lack actionability |
| 3 | Occasional ambiguity — most items are clear, but some sections have vague language |
| 4 | Mostly clear — isolated instances of ambiguity, all items are actionable |
| 5 | Fully clear — every item is unambiguous, actionable, and self-contained |

---

## Dimension 3: Consistency

**Question**: Do cross-references match? Are terms used consistently throughout?

### How to Evaluate

1. Cross-reference integrity:
   - IDs referenced elsewhere actually exist
   - Bidirectional references match
   - Counts match (summary says "5 epics" → exactly 5 epic cards exist)
2. Terminology consistency:
   - Same concept uses same term throughout
   - Abbreviations used consistently after definition
3. Format consistency:
   - Tables use same column structure for same type of data
   - Confidence markers used consistently per quality-rules.md
   - Naming conventions followed (IDs, labels, tags)
4. Priority/status consistency:
   - Labels match across references
   - Risk levels consistent between sections

### Scoring Criteria

| Score | Criteria |
|-------|----------|
| 1 | Pervasive inconsistencies — broken references, conflicting terms, mismatched counts |
| 2 | Multiple inconsistencies — >5 broken cross-references or terminology conflicts |
| 3 | Some inconsistencies — 2-5 issues, mostly cosmetic but some substantive |
| 4 | Minor inconsistencies — 1-2 issues, all cosmetic |
| 5 | Fully consistent — all references valid, all terms consistent, all counts match |

---

## Dimension 4: Quantification

**Question**: Are metrics specific and measurable, not vague?

### How to Evaluate

1. Check success criteria / acceptance criteria:
   - Numeric thresholds present? ("99.9% uptime" vs "high availability")
   - Units specified? ("< 200ms" vs "fast")
   - Measurement method defined?
2. Check estimates and sizing:
   - Story points / effort estimates with rationale?
   - Time estimates use ranges? ("2-3 sprints" vs "soon")
   - Resource numbers specified?
3. Check priority and risk:
   - Probability/impact use numeric scales, not just words?
   - Priority ordering is explicit?

### Scoring Criteria

| Score | Criteria |
|-------|----------|
| 1 | Almost no quantification — mostly descriptive text with no numbers |
| 2 | Sparse quantification — some numbers present but most metrics are vague |
| 3 | Moderate quantification — key metrics have numbers, but some success criteria are vague |
| 4 | Good quantification — most metrics are specific, isolated gaps |
| 5 | Fully quantified — every metric has a specific number, unit, and measurement method |

---

## Dimension 5: Traceability

**Question**: Can every item be traced to a source requirement, decision, or stakeholder input?

### How to Evaluate

1. Upward traceability (to source):
   - Items reference their source document/section
   - Confidence markers cite sources per CR-02
   - ASSUMED/UNCLEAR items have Q&A entries per CR-03, CR-04
2. Downward traceability (to next phase):
   - Items have IDs that downstream artifacts can reference
   - Coverage is verifiable (all source items accounted for)
3. Horizontal traceability (within document):
   - Dependencies reference valid items
   - Cross-cutting concerns tagged and linked
4. Orphan detection:
   - No items without a source (unless explicitly derived)
   - No source items left unmapped

### Scoring Criteria

| Score | Criteria |
|-------|----------|
| 1 | No traceability — items exist without any source references |
| 2 | Sparse traceability — some items reference sources, most don't |
| 3 | Partial traceability — most items have source references, some gaps |
| 4 | Good traceability — nearly all items traceable, minor gaps in bidirectional links |
| 5 | Full traceability — every item traces to source, all sources covered, bidirectional links present |

---

## Scoring Process

### Step 1: Read Context
- Read the skill's own `templates/output-template.md` — expected structure
- Read the skill's own `rules/output-rules.md` — quality constraints
- Read phase-specific rules from `<phase>/shared/rules/` if applicable

### Step 2: Score Each Dimension
- Work through each dimension systematically
- For each score, cite at least 2-3 specific evidence items from the artifact
- Record issues as you find them

### Step 3: Check Skill Rules Compliance
- For each rule ID in the skill's `output-rules.md`:
  - PASS: artifact fully complies
  - FAIL: artifact clearly violates
  - PARTIAL: artifact partially complies

### Step 4: Compile Issues
- Link each issue to a scorecard dimension and artifact section
- Assign severity: HIGH (blocks usage), MED (degrades quality), LOW (polish)

### Step 5: Generate Recommendations
- HIGH severity issues first, then lowest-scoring dimensions
- Each recommendation: what to change, where, expected result
- Limit to 3-7 recommendations

---

## Phase-Specific Scoring Emphasis

Different phases naturally weight dimensions differently. Use these as calibration hints, not overrides:

| Phase | Higher Weight | Rationale |
|-------|--------------|-----------|
| **init** | Completeness, Clarity | Foundational documents must be thorough and unambiguous for downstream phases |
| **req** | Traceability, Consistency | Requirement chains (OBJ→EP→US→AC) must be traceable and internally consistent |
| **design** | Consistency, Quantification | Cross-artifact alignment matters; performance/capacity targets must be numeric |
| **test** | Completeness, Traceability | Full coverage of requirements; every test traces to a requirement |
| **impl** | Quantification, Completeness | Capacity, velocity, effort estimates must be specific; all stories decomposed |
| **deploy** | Consistency, Quantification | Config consistency across environments; resource sizing must be numeric |
| **ops** | Quantification, Clarity | SLOs/SLIs must be numeric; runbook steps must be executable without ambiguity |

These emphases mean: when two dimensions score equally, highlight the higher-weight dimension's issues first in recommendations.
