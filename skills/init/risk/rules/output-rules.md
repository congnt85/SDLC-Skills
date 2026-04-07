# Output Rules -- init/risk

Risk-specific output constraints. These supplement the project-wide rules in `skills/shared/rules/`.

---

## Risk Content Rules

### RSK-01: Complete Risk Scoring
Every risk MUST have:
- Probability score (1-5)
- Impact score (1-5)
- Calculated risk score (P x I)
- Category assignment

No blank scores. If scoring is uncertain, mark as ASSUMED with best estimate.

### RSK-02: Response Strategy Required
Every risk MUST have a response strategy:
- Type: Avoid / Mitigate / Transfer / Accept
- Specific mitigation action (not generic)

Bad: "Mitigate — reduce risk"
Good: "Mitigate — conduct PoC in Sprint 0 to validate webhook payload contents with GitHub and GitLab"

### RSK-03: Monitoring Plan for High/Critical Risks
Every risk with score >= 13 (High or Critical) MUST have:
- A monitoring plan entry
- Trigger condition (specific, observable)
- Check frequency
- Contingency plan

Risks with score < 13 should still be monitored but monitoring plan entries are optional.

### RSK-04: Sequential Risk IDs
Risk IDs MUST be sequential: RISK-001, RISK-002, RISK-003...
No gaps in numbering. If a risk is removed during refine, renumber remaining risks.

### RSK-05: Minimum Risk Count
The risk register MUST contain at least 8 identified risks.
If fewer than 8 risks are identified, use the category sweep technique from
`risk-identification-guide.md` to find gaps.

### RSK-06: Category Coverage
At least 4 of the 6 risk categories MUST be represented:
- Technical
- Resource
- Schedule
- Scope
- External
- Organizational

If a category has zero risks, add a note: "No {category} risks identified — verify this is accurate."

### RSK-07: Specific Mitigation Strategies
Mitigation strategies MUST be specific and actionable:

| Bad (reject) | Good (accept) |
|--------------|---------------|
| "Monitor the situation" | "Review API changelog weekly; set up deprecation alerts" |
| "Reduce risk" | "Cross-train 2 team members on Git integration by Sprint 2" |
| "Have a backup plan" | "If GitHub webhook fails, fall back to polling API every 60s" |
| "Test thoroughly" | "Load test with 500 concurrent users by Sprint 3; fail if P95 > 2s" |

### RSK-08: Risk Source Traceability
Every risk SHOULD trace to its source:
- From charter assumption: "Source: ASM-xxx"
- From charter constraint: "Source: CON-xxx"
- From charter dependency: "Source: DEP-xxx"
- From scope feature: "Source: SCP-xxx"
- From scope integration: "Source: INT-xxx"
- From scope quality attribute: "Source: QA-xxx"
- From user input: "Source: user-identified"
- From common risk checklist: "Source: risk-matrix-template"

---

## Format Rules

### RSK-09: Section Order
Risk register output MUST follow the section order in `init/shared/templates/risk/risk-register-template.md`.
Do not add, remove, or reorder sections.

### RSK-10: ID Prefixes

| Section | Prefix |
|---------|--------|
| Risks | RISK- |
| Q&A entries | Q- |

### RSK-11: Confidence Coverage
The Readiness Assessment MUST count items from these sections:
- Risk assessments (each risk is 1 item)
- Mitigation strategies (each strategy is 1 item)
- Monitoring plan entries (each entry is 1 item)

Risk summary, heat map, and response strategy reference are structural -- not counted.

---

## Refine Mode Rules

### RSK-12: Quality Scorecard First
In refine mode, BEFORE applying changes, generate a Quality Scorecard covering:
- Completeness: Are all risk categories represented? Is the monitoring plan populated?
- Clarity: Are risk descriptions specific enough to act on?
- Quantification: Are probability and impact scores justified? Are mitigations measurable?
- Consistency: Do risk sources match actual charter/scope items?
- Traceability: Does every risk trace to a source document or user input?

Present this scorecard to the user before asking what to improve.

### RSK-13: Score Recalibration
Each refine round should recalibrate risk scores:
- Did any risks increase in probability based on new information?
- Did any mitigations reduce impact sufficiently to re-score?
- Are there new risks from resolved Q&A items?

### RSK-14: TBD Reduction Target
Each refine round should aim to reduce [TBD] count by at least 30%.
If no TBDs were resolved, flag this in the Diff Summary.
