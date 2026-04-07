# Output Rules — init/charter

Charter-specific output constraints. These supplement the project-wide rules in `skills/shared/rules/`.

---

## Charter Content Rules

### CHR-01: Vision Statement Required
Every charter MUST include a vision statement using at least the Moore template format.
Elevator pitch and anti-vision are recommended but optional for first draft.

### CHR-02: SMART Metrics Enforcement
Success metrics MUST be evaluated against SMART criteria:
- If metric is vague (e.g., "improve user experience"), mark as 🔶 ASSUMED
- Create Q&A asking for specific, measurable target
- Suggest a quantified version: "Did you mean something like 'reduce task completion time from 5 min to 2 min'?"

### CHR-03: Budget Must Use Estimation Method
Budget section MUST reference which estimation method was used:
- Three-point (PERT) — preferred for initial estimates
- Analogous — acceptable if comparable project exists
- Parametric — acceptable if unit costs are known
- "Guess" is not acceptable — at minimum use three-point ranges

If budget is completely unknown, write `[TBD — estimation deferred]` and create:
- A Q&A entry asking for budget range
- A risk entry: "Budget undefined — may lead to scope/timeline misalignment"

### CHR-04: Assumptions Need Validation Plans
Every assumption MUST have:
- "Impact if Wrong" column filled (not empty)
- "Validation Plan" column filled (how and when to check)

If validation plan is unknown, mark as 🔶 ASSUMED with Q&A.

### CHR-05: Constraints Must Be Classified
Every constraint MUST specify:
- Type: Budget / Timeline / Technical / Resource / Regulatory
- Negotiable: Yes / No
- Impact: what happens if this constraint tightens

### CHR-06: No Orphan Scope Items
Every in-scope item MUST connect to at least one:
- Business objective (from Section 3)
- Or success metric (from Section 3)

If an in-scope item doesn't trace to any objective, flag it with Q&A:
"This feature doesn't connect to a stated objective. Is it essential, or should it be Could Have / Won't Have?"

---

## Format Rules

### CHR-07: Section Order
Charter output MUST follow the section order in `init/shared/templates/charter/charter-template.md`.
Do not add, remove, or reorder sections.

### CHR-08: ID Prefixes
| Section | Prefix |
|---------|--------|
| In-scope features | SCP- |
| Out-of-scope items | OUT- |
| Milestones | MS- |
| Assumptions | ASM- |
| Constraints | CON- |
| Dependencies | DEP- |
| Q&A entries | Q- |

### CHR-09: Confidence Coverage
The Readiness Assessment MUST count items from these sections:
- Vision statement (1 item)
- Success metrics (each KR is 1 item)
- In-scope features (each feature is 1 item)
- Budget categories (each line is 1 item)
- Assumptions (each assumption is 1 item)
- Constraints (each constraint is 1 item)
- Dependencies (each dependency is 1 item)

Milestones and team structure are informational — not counted in readiness.

---

## Refine Mode Rules

### CHR-10: Quality Scorecard First
In refine mode, BEFORE applying changes, generate a Quality Scorecard
(per `skills/shared/templates/quality-scorecard.md`) covering:
- Completeness: Are all charter sections populated?
- Clarity: Are descriptions specific and unambiguous?
- Quantification: Are metrics SMART? Are quality attrs measurable?
- Consistency: Do cross-references match?
- Traceability: Does every scope item trace to an objective?

Present this scorecard to the user before asking what to improve.

### CHR-11: TBD Reduction Target
Each refine round should aim to reduce [TBD] count by at least 30%.
If no TBDs were resolved, flag this in the Diff Summary.
