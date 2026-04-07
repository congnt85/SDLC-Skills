# Output Rules -- req/epic

Epic-specific output constraints. These supplement the project-wide rules in `skills/shared/rules/` and phase rules in `req/shared/rules/`.

---

## Epic Content Rules

### EPC-01: Epic-Objective Traceability
Every epic MUST trace to at least one charter objective or success metric.
If an epic doesn't connect to a stated objective, flag it with Q&A:
"This epic doesn't trace to a charter objective. Is it essential?"

Exception: Cross-cutting epics (`[CROSS-CUTTING]`) may link to "supports all objectives."

### EPC-02: Complete Feature Assignment
Every scope feature (SCP-xxx) MUST appear in exactly one epic.
- No feature left unassigned
- No feature assigned to multiple epics
- If a feature spans multiple epics, assign it to the primary epic and note the relationship

### EPC-03: Sequential Epic IDs
Epic IDs MUST be sequential: EPIC-001, EPIC-002, EPIC-003...
No gaps in numbering. If an epic is removed during refine, renumber.

### EPC-04: Epic Scope Features Listed
Each epic card MUST list all assigned scope features by SCP-xxx ID.

### EPC-05: Cross-Cutting Epics Tagged
Epics that serve multiple objectives or provide foundational capabilities MUST be tagged with `[CROSS-CUTTING]` in the title.

### EPC-06: Minimum Epic Count
The epic document MUST contain at least 3 epics.
If fewer than 3 epics are identified, the project may be too small for epic-level decomposition -- suggest using scope features directly as work items.

### EPC-07: No Implementation Details
Epic descriptions MUST describe WHAT and WHY, never HOW.

| Bad (reject) | Good (accept) |
|--------------|---------------|
| "Build a REST API with Express.js" | "Enable Git platforms to send event data to TaskFlow" |
| "Use WebSockets for real-time updates" | "Dashboard reflects ticket changes within seconds" |
| "Store events in PostgreSQL" | "Persist Git event history for sprint analytics" |

### EPC-08: Epic Sizing Guideline
Each epic SHOULD have an estimated story count in the 3-8 range.
- Epics with estimated >12 stories MUST include a note suggesting how to split
- Epics with estimated <3 stories SHOULD include a note about potential merge

---

## Format Rules

### EPC-09: Section Order
Epic output MUST follow the section order in `req/epic/templates/output-template.md`.
Do not add, remove, or reorder sections.

### EPC-10: ID Prefixes

| Section | Prefix |
|---------|--------|
| Epics | EPIC- |
| Q&A entries | Q- |

### EPC-11: Confidence Coverage
The Readiness Assessment MUST count items from these sections:
- Each epic is 1 item
- Each feature assignment is 1 item (in Feature-to-Epic Map)

Epic Overview table and Dependency Map are structural -- not counted.

---

## Refine Mode Rules

### EPC-12: Quality Scorecard First
In refine mode, BEFORE applying changes, generate a Quality Scorecard covering:
- Completeness: Do all charter objectives have epics? Are all features assigned?
- Clarity: Are epic descriptions specific enough for story creation?
- Consistency: Do feature IDs match scope? Do objective refs match charter?
- Traceability: Does every epic trace to an objective?
- Sizing: Are epics in the 3-8 story range?

Present this scorecard to the user before asking what to improve.

### EPC-13: TBD Reduction Target
Each refine round should aim to reduce [TBD] count by at least 30%.
If no TBDs were resolved, flag this in the Diff Summary.
