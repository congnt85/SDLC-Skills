# Test Plan Template

Standard format for detailed test planning.

---

## Test Plan Structure

```markdown
### Test Phase: {Phase Name}

| Field | Value |
|-------|-------|
| **Scope** | {what is tested in this phase} |
| **Entry Criteria** | {conditions to start this phase} |
| **Exit Criteria** | {conditions to complete this phase} |
| **Duration** | {estimated time} |
| **Resources** | {who/what is needed} |
| **Risks** | {what could go wrong} |

**Activities**:
1. {activity 1}
2. {activity 2}

**Deliverables**:
- {deliverable 1}
- {deliverable 2}
```

---

## Test Schedule Table

```markdown
| Phase | Start | End | Duration | Dependencies | Owner |
|-------|-------|-----|----------|-------------|-------|
| Unit testing | {date} | {date} | {duration} | Code complete | Dev team |
| Integration testing | {date} | {date} | {duration} | Unit tests pass | Dev team |
| API testing | {date} | {date} | {duration} | API deployed to staging | QA team |
| E2E testing | {date} | {date} | {duration} | All integrations ready | QA team |
| Performance testing | {date} | {date} | {duration} | Staging environment | QA + DevOps |
| Security testing | {date} | {date} | {duration} | Feature complete | Security team |
| UAT | {date} | {date} | {duration} | All tests pass | Stakeholders |
```

---

## Entry/Exit Criteria Table

```markdown
### Entry Criteria

| ID | Criterion | Verification | Status |
|----|-----------|-------------|--------|
| ENTRY-01 | {criterion} | {how to verify} | Met / Not Met |

### Exit Criteria

| ID | Criterion | Metric | Target | Status |
|----|-----------|--------|--------|--------|
| EXIT-01 | {criterion} | {metric} | {target} | Met / Not Met |
```

---

## Rules

- Entry and exit criteria MUST be measurable
- Exit criteria MUST align with DoD from dor-dod-final.md
- Test schedule MUST align with sprint/release timeline from backlog
- Resource allocation MUST be realistic given team constraints
- Risk mitigation for testing risks MUST be defined
