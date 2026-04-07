# Sprint Plan Template

Standard format for sprint planning and task breakdown.

---

## Sprint Card

```markdown
### Sprint {N}: {Sprint Goal}

| Field | Value |
|-------|-------|
| **Sprint** | {N} |
| **Goal** | {1-sentence sprint goal} |
| **Duration** | {N} weeks |
| **Start Date** | {date} |
| **End Date** | {date} |
| **Capacity** | {N} story points |
| **Committed** | {N} story points |
| **Utilization** | {%} |
| **Release** | {MVP / R2 / R3} |

**Stories**:
| Story | Title | Points | Priority | Owner | Status |
|-------|-------|--------|----------|-------|--------|
| US-xxx | {title} | {pts} | Must/Should/Could | {name} | Not Started |
```

---

## Task Breakdown Format

```markdown
### US-xxx: {Story Title} ({points} pts)

| Task | Description | Estimate | Owner | Depends On | DoD Items |
|------|-------------|----------|-------|-----------|-----------|
| T-{NNN} | {task description} | {hours} | {name} | T-{NNN} | DOD-01, DOD-03 |
```

---

## Capacity Planning Table

```markdown
| Team Member | Role | Available Days | Capacity (pts) | Allocated (pts) | Utilization |
|-------------|------|---------------|----------------|-----------------|-------------|
| {name} | {role} | {days} | {pts} | {pts} | {%} |
```

---

## Rules

- Sprint goal MUST be achievable within the sprint
- Committed points MUST NOT exceed team capacity
- Every story MUST meet Definition of Ready before sprint inclusion
- Tasks MUST be small enough to complete in 1-2 days
- Dependencies between tasks MUST be explicit
- Sprint should include test tasks for every feature task
