# Traceability Techniques Guide

Techniques for building requirements traceability matrices and defining quality gates.

---

## Technique 1: Forward Traceability

Trace from business goals down to implementation.

### Process

```
Charter Objective
  └→ Epic(s) that deliver this objective
       └→ Scope features assigned to each epic
            └→ User stories implementing each feature
                 └→ Acceptance criteria verifying each story
```

### Forward Trace Table

| Objective | Epic(s) | Features | Stories | Total Points | Must Have Points |
|-----------|---------|----------|---------|-------------|-----------------|
| Obj 1 | EPIC-001, EPIC-002 | SCP-001, SCP-002 | US-001..US-013 | 45 | 38 |

### What Forward Traceability Reveals

- **Objectives without epics**: Business goal has no planned work
- **Epics without stories**: Theme exists but no implementable work items
- **Objectives with only Could Have stories**: Low-priority implementation of a business goal

---

## Technique 2: Backward Traceability

Trace from implementation back to business goals.

### Process

```
User Story
  └→ Source feature (SCP-xxx)
       └→ Parent epic (EPIC-xxx)
            └→ Charter objective
                 └→ Success metric (KR)
```

### Backward Trace Table

| Story | Feature | Epic | Objective | Risk | Priority |
|-------|---------|------|-----------|------|----------|
| US-001 | SCP-001.1 | EPIC-001 | Obj 1 | — | Must Have |
| US-026 | — | EPIC-001 | Obj 1 | RISK-001 | Must Have |

### What Backward Traceability Reveals

- **Orphan stories**: Stories that don't trace to any objective (may be unnecessary)
- **Stories without features**: Added during requirements but not in scope (scope creep)
- **Risk-driven stories**: Spike stories tracing to risks rather than features

---

## Technique 3: Coverage Analysis

### Feature Coverage

For each scope feature, check:
- Does it have at least one story?
- What priority are those stories? (Must Have feature with only Could Have stories = weak coverage)
- What's the total point allocation?

### Coverage Matrix

| Feature | Stories | Points | Coverage Status |
|---------|---------|--------|-----------------|
| SCP-001 | 6 | 24 | ✅ Full |
| SCP-005.3 | 0 | 0 | ❌ Gap |

### Coverage Levels

| Level | Meaning |
|-------|---------|
| ✅ Full | Feature has Must Have stories |
| ⚠️ Partial | Feature has stories but all Should/Could Have |
| ❌ Gap | Feature has zero stories |
| 🔄 Deferred | Feature intentionally deferred (documented in Won't Have) |

---

## Technique 4: Gap Analysis

Systematically check for missing links in the traceability chain.

### Gap Checklist

| Check | Question | If Gap Found |
|-------|----------|-------------|
| Objective → Epic | Does every charter objective have at least one epic? | Create Q&A: "Objective X has no epic. Is it still a goal?" |
| Objective → Must Have | Does every objective have at least one Must Have story? | Flag: "Objective X has no Must Have stories — won't be delivered in MVP" |
| Feature → Story | Does every in-scope feature have at least one story? | Flag: "Feature SCP-xxx has no stories — either create stories or move to Out of Scope" |
| Epic → Story | Does every epic have at least one story? | Flag: "EPIC-xxx has no stories — should it be removed?" |
| Story → AC | Does every story have at least 2 acceptance criteria? | Flag: "US-xxx has insufficient acceptance criteria" |
| Persona → Story | Does every Primary persona have Must Have stories? | Flag: "Primary persona {name} has no Must Have stories" |
| Risk → Story | Does every HIGH risk have a spike or mitigation story? | Flag: "RISK-xxx (HIGH) has no corresponding spike story" |

### Gap Impact Assessment

| Gap Type | Impact |
|----------|--------|
| Objective without stories | HIGH — business goal won't be delivered |
| Must Have feature without stories | HIGH — core feature missing |
| Should Have feature without stories | MEDIUM — enhancement missing |
| Could Have feature without stories | LOW — nice-to-have, can defer |
| Persona without stories | MEDIUM — user type not served |

---

## Technique 5: Definition of Ready (DoR)

### Standard DoR Criteria

Every story must meet these criteria before entering a sprint:

| ID | Criterion | Description |
|----|-----------|-------------|
| DOR-01 | Story written | Follows "As a / I want / So that" format |
| DOR-02 | AC defined | At least 2 Gherkin acceptance criteria |
| DOR-03 | Estimated | Story points assigned (Fibonacci scale) |
| DOR-04 | Small enough | Story is <=8 points |
| DOR-05 | Dependencies identified | All dependencies listed and unblocked |
| DOR-06 | Persona identified | Target persona(s) specified |
| DOR-07 | No open questions | All Q&A for this story resolved |

### Project-Specific DoR Additions

Consider adding criteria based on:
- **Charter constraints**: "Complies with CON-003 (GitHub + GitLab support)" if applicable
- **Quality attributes**: "Performance impact assessed" for stories affecting QA-001
- **Team agreements**: "Design mockup approved" if UX review is required

---

## Technique 6: Definition of Done (DoD)

### Standard DoD Criteria

Every story must meet these criteria before being marked "Done":

| ID | Criterion | Description |
|----|-----------|-------------|
| DOD-01 | Code complete | Feature code written and merged to main branch |
| DOD-02 | Tests pass | Unit and integration tests written and passing |
| DOD-03 | AC verified | All acceptance criteria demonstrated and accepted |
| DOD-04 | Code reviewed | Pull request approved by at least 1 reviewer |
| DOD-05 | Deployed to staging | Feature accessible in staging environment |
| DOD-06 | Documentation updated | API docs, README, or user guides updated if affected |

### Project-Specific DoD Additions

Consider adding criteria based on:
- **Quality attributes**: "Performance tested" (QA-001), "Security scanned" (QA-004)
- **Compliance**: "Accessibility checked" (QA-005)
- **Operations**: "Monitoring/alerting configured" if applicable
- **Team maturity**: Start with fewer criteria, add as team matures

### DoR vs DoD

| Aspect | DoR | DoD |
|--------|-----|-----|
| When checked | Before sprint planning | Before marking "Done" |
| Who enforces | Product Owner + Scrum Master | Development Team |
| Focus | Is the story clear enough to start? | Is the story complete enough to ship? |
| Failure mode | Story goes back to backlog for refinement | Story stays in sprint, not counted as done |
