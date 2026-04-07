# Requirements Phase Rules

Rules specific to all skills in the requirements phase.

---

## Content Rules

### REQ-01: No Implementation Details
User stories describe user-visible behavior only. MUST NOT specify:
- Database tables, columns, or schemas
- API endpoints, HTTP methods, or payload formats
- Programming languages, frameworks, or libraries
- Internal architecture, services, or data structures
- Infrastructure or deployment details

These belong to the `design/` phase. If technical constraints exist (e.g., "must integrate with REST API"), document them as constraints in the story, not as implementation decisions.

### REQ-02: INVEST Criteria Enforcement
Every user story MUST satisfy INVEST criteria:
- **I**ndependent: Can be developed without requiring another story to complete first (or dependency is explicitly noted)
- **N**egotiable: Describes the desired outcome, not the specific solution
- **V**aluable: Delivers measurable value to at least one persona
- **E**stimable: Small and clear enough for the team to estimate confidently
- **S**mall: Completable within one sprint (<=8 story points)
- **T**estable: Has verifiable acceptance criteria in Given/When/Then format

If a story fails INVEST, mark it as 🔶 ASSUMED with a Q&A entry suggesting how to fix it.

### REQ-03: Gherkin Acceptance Criteria
Acceptance criteria MUST use Given/When/Then (Gherkin) format:

```gherkin
Scenario: {descriptive name}
  Given {precondition — system state before action}
  When {action — what the user does}
  Then {expected result — observable outcome}
```

Multiple scenarios per story are encouraged (happy path + edge cases).

### REQ-04: Fibonacci Story Points
Estimation uses modified Fibonacci scale: 1, 2, 3, 5, 8, 13

| Points | Meaning | Action |
|--------|---------|--------|
| 1-3 | Small, well-understood | Ready for sprint |
| 5 | Medium, some complexity | Acceptable for sprint |
| 8 | Large, significant effort | Flag for possible split |
| 13 | Very large, high uncertainty | MUST be split before sprint planning |
| >13 | Epic-sized | Not a story — belongs in epics |

Stories >8 points MUST be flagged with `[SPLIT RECOMMENDED]`.
Stories of 13 points MUST include a splitting suggestion.

### REQ-05: Epic-Objective Traceability
Every epic MUST trace to at least one charter objective or success metric.
Orphan epics (not connected to business value) MUST be flagged with Q&A:
"This epic doesn't connect to a stated objective. Is it essential, or should it be removed?"

### REQ-06: Story-Feature Traceability
Every user story MUST trace to at least one scope feature (SCP-xxx).
Stories that don't trace to a scope feature MUST be flagged as `[NEW -- added during requirements]` with justification.

### REQ-07: Persona-Story Mapping
Every Must Have story MUST identify which persona(s) benefit.
Every Primary persona MUST have at least one Must Have story.
If a persona has zero stories, create Q&A: "Persona {name} has no stories. Should they be removed from scope?"

### REQ-08: MoSCoW Consistency
MoSCoW priorities in backlog MUST be consistent with scope feature priorities:
- Must Have feature -> stories are Must Have or Should Have
- Should Have feature -> stories are Should Have or Could Have
- A Must Have feature MUST NOT have all Could Have stories

If priorities diverge from scope, justify in Q&A.

### REQ-09: Acceptance Criteria Minimum
Every user story MUST have at least 2 acceptance criteria:
- At least 1 happy path scenario (normal successful flow)
- At least 1 edge case or error scenario (what happens when things go wrong)

### REQ-10: Cross-Reference Consistency
- Epic IDs (EPIC-xxx) MUST be consistent across epics, stories, backlog, and traceability
- Story IDs (US-xxx) MUST be consistent across stories, backlog, and traceability
- Feature IDs (SCP-xxx) from scope MUST be preserved exactly as-is
- Persona names MUST match scope document exactly
