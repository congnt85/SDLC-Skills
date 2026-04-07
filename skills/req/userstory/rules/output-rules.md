# Output Rules -- req/userstory

User story-specific output constraints. These supplement the project-wide rules in `skills/shared/rules/` and phase rules in `req/shared/rules/`.

---

## Story Content Rules

### USR-01: Story Format
Every user story MUST follow the standard format:
"As a {persona}, I want to {action}, so that {benefit}."

- Persona MUST be a named persona from scope (e.g., "Dev Dana", not "a user")
- Action MUST describe user-visible behavior (not technical tasks)
- Benefit MUST explain WHY this matters to the persona

### USR-02: Minimum Acceptance Criteria
Every user story MUST have at least 2 acceptance criteria:
- At least 1 happy path scenario
- At least 1 edge case, error, or boundary scenario

### USR-03: Gherkin Format Required
All acceptance criteria MUST use Given/When/Then (Gherkin) format.
Free-text criteria (bullet lists, prose) are not acceptable.

### USR-04: Story Point Limits
- Stories >8 points MUST be flagged with `[SPLIT RECOMMENDED]` tag
- Stories of 13 points MUST include a suggested splitting approach
- Stories >13 points MUST NOT exist -- they are epic-sized

### USR-05: Story Point Splitting Suggestion
When flagging a story with `[SPLIT RECOMMENDED]`, include a note:
```
**Splitting suggestion**: Split by {pattern} into:
- US-xxx.a: {sub-story 1} (~{N} pts)
- US-xxx.b: {sub-story 2} (~{N} pts)
```

### USR-06: Epic Reference Required
Every story MUST reference its parent epic: `EPIC-{NNN}: {title}`.
Stories without an epic assignment are rejected.

### USR-07: Feature Reference Required
Every story MUST reference its source scope feature: `SCP-{NNN}: {name}`.
Exception: Spike stories may reference a RISK-xxx instead.

### USR-08: NFR Story Tagging
Stories derived from scope quality attributes (QA-xxx) MUST be tagged `[NFR]`.
NFR stories still need Gherkin AC with measurable thresholds.

### USR-09: Spike Story Tagging
Stories derived from risk register risks (RISK-xxx) MUST be tagged `[SPIKE]`.
Spike stories MUST include a time-box (e.g., "Time-box: 2 days").
Spike AC focuses on producing a documented decision (proceed / pivot / abandon).

### USR-10: Sequential Story IDs
Story IDs MUST be sequential: US-001, US-002, US-003...
No gaps. If a story is removed during refine, renumber.

### USR-11: AC ID Format
Acceptance criteria IDs are scoped to their story: US-001.AC-1, US-001.AC-2, etc.

### USR-12: Confidence Coverage
The Readiness Assessment MUST count each story as 1 item.
INVEST check results do not add separate items.

---

## Format Rules

### USR-13: Section Order
User story output MUST follow the section order in `req/userstory/templates/output-template.md`.

### USR-14: ID Prefixes

| Section | Prefix |
|---------|--------|
| User stories | US- |
| Acceptance criteria | US-xxx.AC-N |
| Q&A entries | Q- |

---

## Refine Mode Rules

### USR-15: Quality Scorecard First
In refine mode, BEFORE applying changes, generate a Quality Scorecard covering:
- Completeness: Do all epics have stories? Do all features have stories?
- Clarity: Are story descriptions specific? Are AC testable?
- Quantification: Do all stories have point estimates? Do NFR stories have measurable targets?
- Consistency: Do epic/feature IDs match? Do persona names match scope?
- INVEST compliance: Do all stories pass INVEST check?

### USR-16: TBD Reduction Target
Each refine round should aim to reduce [TBD] count by at least 30%.
