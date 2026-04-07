# INVEST Criteria Guide

Detailed checklist for validating user stories against INVEST criteria.

---

## The INVEST Acronym

| Letter | Criterion | Question | What "Pass" Looks Like |
|--------|-----------|----------|----------------------|
| **I** | Independent | Can this story be developed and delivered without requiring another story to finish first? | Story delivers value on its own. Dependencies are noted but don't block development. |
| **N** | Negotiable | Does the story describe the desired outcome rather than a specific solution? | Story says "user can filter tickets" not "add a dropdown with checkboxes." |
| **V** | Valuable | Does this story deliver measurable value to at least one persona? | Story connects to a persona's goal or pain point from scope. |
| **E** | Estimable | Can the team estimate the effort with reasonable confidence? | Story is clear enough that two developers would give similar estimates. |
| **S** | Small | Can this story be completed within a single sprint? | Story is <=8 story points. |
| **T** | Testable | Can you write a test that proves this story works? | Story has specific, verifiable acceptance criteria in Given/When/Then. |

---

## Detailed Criteria with Examples

### Independent

**Pass:**
```
US-010: As a SM Sam, I want to see a Kanban board of sprint tickets,
        so that I can assess sprint health at a glance.
→ Delivers value alone — user can view tickets even without real-time updates.
```

**Fail:**
```
US-010: As a SM Sam, I want to see real-time ticket updates on the board.
→ Requires US-001 (webhook receiver) to be complete first.
   This isn't independent — it can't deliver value without the data source.
```

**How to fix:** Split into "view board with manual data" (independent) and "board receives real-time updates" (depends on webhook). Or note the dependency explicitly and accept it.

**When dependency is acceptable:** Some dependencies are unavoidable (e.g., "display data" depends on "ingest data"). Note them explicitly in the Dependencies field. The key question is: can the story be developed in parallel, even if it can't be demo'd until the dependency is done?

---

### Negotiable

**Pass:**
```
US-003: As a Dev Dana, I want my ticket to update when I push code,
        so that I don't have to manually change the status.
→ HOW the mapping works is negotiable (branch name, commit message, PR title).
```

**Fail:**
```
US-003: As a Dev Dana, I want the system to parse the branch name using
        regex pattern "feature/([A-Z]+-\d+)" to extract the ticket ID.
→ This prescribes the solution. The regex is an implementation detail.
```

**How to fix:** Describe the outcome ("ticket updates automatically") and leave the mechanism to the development team.

---

### Valuable

**Pass:**
```
US-020: As a SM Sam, I want to receive an alert when a ticket is stuck
        for 3+ days, so that I can intervene before it becomes a blocker.
→ Clear value: prevents blockers, saves SM time.
```

**Fail:**
```
US-099: As a developer, I want to refactor the database connection pool.
→ No user-visible value. This is a technical task, not a user story.
```

**How to fix:** Reframe in terms of value: "As a user, I want the dashboard to respond quickly under load, so that I don't waste time waiting." The refactoring is HOW, not WHAT.

---

### Estimable

**Pass:**
```
US-001: As a Dev Dana, I want to register my GitHub repo's webhook endpoint,
        so that TaskFlow receives push and PR events.
→ Clear scope: one endpoint, one platform, well-understood webhook API.
```

**Fail:**
```
US-050: As a user, I want the system to be fast.
→ What does "fast" mean? How do you measure it? Impossible to estimate.
```

**How to fix:** Make it specific and measurable: "Dashboard loads in < 2 seconds at P95 with 500 concurrent users." Or split into a spike first: "Investigate performance bottlenecks and propose optimization targets."

---

### Small

**Pass:**
```
US-002: As a Dev Dana, I want TaskFlow to extract branch name and commit
        author from GitHub push events. (3 points)
→ Focused scope: one event type, specific data fields.
```

**Fail:**
```
US-100: As a SM Sam, I want a complete sprint analytics dashboard with
        velocity, burndown, and predictions. (21 points)
→ This is an epic, not a story. Way too large for one sprint.
```

**How to fix:** Split using story splitting patterns:
- US-100a: Velocity chart (5 points)
- US-100b: Burndown chart (5 points)
- US-100c: Prediction engine (8 points)

---

### Testable

**Pass:**
```
US-003: Map branch names to tickets
  AC: Given a branch named "feature/TASK-123",
      When a push event is received,
      Then ticket TASK-123 status updates to "In Progress"
→ Specific, verifiable, automatable.
```

**Fail:**
```
US-003: Map branches to tickets
  AC: The system should correctly identify tickets from branches.
→ What does "correctly" mean? Which branches? Which tickets?
```

**How to fix:** Write specific Given/When/Then scenarios with concrete data values.

---

## Common INVEST Violations

| Violation | Symptom | Fix |
|-----------|---------|-----|
| Coupled stories | "This story only works after story X" | Split by independent value; note deps |
| Prescriptive solution | Story mentions tables, APIs, frameworks | Rewrite to describe outcome |
| No persona benefit | "Refactor X", "Upgrade Y" | Frame as user value or mark as technical task |
| Vague scope | "Improve the dashboard" | Specify what improvement, for whom |
| Too large | >8 story points | Apply splitting patterns |
| Untestable AC | "Should work well" | Write Given/When/Then with specific data |
