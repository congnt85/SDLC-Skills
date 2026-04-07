# Output Rules -- req/traceability

Traceability-specific output constraints. These supplement the project-wide rules in `skills/shared/rules/` and phase rules in `req/shared/rules/`.

---

## Traceability Content Rules

### TRC-01: Objective Coverage
Every charter objective MUST trace to at least one epic.
If an objective has no epic, flag as a HIGH-impact gap.

### TRC-02: Feature Coverage
Every in-scope feature (SCP-xxx) MUST trace to at least one user story.
Features with zero stories are flagged as gaps in the Feature Coverage table.

### TRC-03: Epic Coverage
Every epic MUST have at least one user story.
Epics with zero stories are flagged as gaps.

### TRC-04: Story Traceability
Every story MUST trace backward to:
- A scope feature (SCP-xxx) OR a risk (RISK-xxx) for spike stories
- A parent epic (EPIC-xxx)

Stories that don't trace to any source are flagged as orphans.

### TRC-05: Gap Flagging
All identified gaps MUST be documented in the Gap Analysis section with:
- What's missing
- Impact assessment (HIGH / MEDIUM / LOW)
- Recommended action (create stories, defer feature, or remove from scope)

### TRC-06: Coverage Metrics
The traceability document MUST calculate and display:
- % of objectives with epics
- % of features with stories
- % of epics with stories
- % of stories with acceptance criteria

### TRC-07: DoR Minimum Criteria
Definition of Ready MUST include at least:
- Story follows standard format
- Acceptance criteria defined (>=2 Gherkin scenarios)
- Story points estimated
- Dependencies identified and unblocked

### TRC-08: DoD Minimum Criteria
Definition of Done MUST include at least:
- Code complete and merged
- Tests written and passing
- Acceptance criteria verified
- Code reviewed (PR approved)
- Deployed to staging

### TRC-09: Dual Output
This skill produces TWO output files:
- `traceability-draft.md` — traceability matrix, gap analysis, coverage
- `dor-dod-draft.md` — Definition of Ready + Definition of Done

Both files share the same version number and are promoted together.

### TRC-10: Sequential Traceability IDs
Traceability row IDs use prefix TR-: TR-001, TR-002...
DoR uses DOR-: DOR-01, DOR-02...
DoD uses DOD-: DOD-01, DOD-02...

### TRC-11: Confidence Coverage
Readiness Assessment counts items from BOTH output files:
- Each traceability row with a gap is 1 item
- Each DoR criterion is 1 item
- Each DoD criterion is 1 item
- Full-coverage rows contribute as CONFIRMED items

---

## Format Rules

### TRC-12: Section Order
Both output files MUST follow the section order in `req/traceability/templates/output-template.md`.

---

## Refine Mode Rules

### TRC-13: Quality Scorecard First
In refine mode, generate Quality Scorecard covering:
- Completeness: Are all objectives, features, epics, and stories accounted for?
- Coverage: What % of features have stories? What % of objectives have Must Have stories?
- Consistency: Do IDs match across all source documents?
- DoR/DoD: Are criteria specific and measurable?
- Gaps: Have gaps from the previous version been addressed?

### TRC-14: Gap Reduction Target
Each refine round should aim to reduce gaps by at least 50%.
New gaps may be discovered during refine — these are acceptable if documented.
