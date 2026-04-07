# User Story Output Template

This is the expected structure for `userstories-draft.md` output. Follow this exactly.

---

```markdown
# User Stories: {Project Name}

> **Project**: {Project Name}
> **Version**: {1.0}
> **Date Created**: {YYYY-MM-DD}
> **Last Updated**: {YYYY-MM-DD}
> **Status**: Draft
> **Author**: AI-Generated
> **Source**: Derived from `epics-final.md` and `scope-final.md`

{If refine mode, include Change Log here}

---

## 1. Story Summary

| ID | Epic | Feature | Title | Persona | Priority | Points | Tags | Confidence |
|----|------|---------|-------|---------|----------|--------|------|------------|

---

## 2. Story Details

### EPIC-{NNN}: {Epic Title}

#### US-{NNN}: {Story Title}

| Field | Value |
|-------|-------|
| **ID** | US-{NNN} |
| **Epic** | EPIC-{NNN}: {title} |
| **Feature** | SCP-{NNN}: {name} |
| **Story** | As a {persona}, I want to {action}, so that {benefit}. |
| **Priority** | Must Have / Should Have / Could Have |
| **Story Points** | {1/2/3/5/8/13} |
| **Dependencies** | {US-xxx or "None"} |
| **Tags** | {[NFR], [SPIKE], [SPLIT RECOMMENDED], or "—"} |
| **Confidence** | {marker + annotation} |

##### Acceptance Criteria

###### US-{NNN}.AC-1: {scenario name}

```gherkin
Scenario: {name}
  Given {precondition}
  When {action}
  Then {result}
```

###### US-{NNN}.AC-2: {edge case}

```gherkin
Scenario: {name}
  Given {precondition}
  When {action}
  Then {result}
```

##### INVEST Check

| Criterion | Pass | Notes |
|-----------|------|-------|
| Independent | Yes/No | {notes} |
| Negotiable | Yes/No | {notes} |
| Valuable | Yes/No | {notes} |
| Estimable | Yes/No | {notes} |
| Small | Yes/No | {notes} |
| Testable | Yes/No | {notes} |

---

{Repeat for each story, grouped by epic}

---

## 3. Persona Coverage Matrix

| Persona | Type | Must Have | Should Have | Could Have | Total Stories | Total Points |
|---------|------|----------|-------------|------------|--------------|-------------|

---

## 4. NFR Stories

{Stories derived from quality attributes QA-xxx, tagged [NFR]}

---

## 5. Spike Stories

{Stories derived from high-impact risks RISK-xxx, tagged [SPIKE]}

---

## Q&A Log

### Pending

#### Q-{NNN} (related: US-{NNN})
- **Impact**: HIGH / MEDIUM / LOW
- **Question**: {specific question}
- **Context**: {why this matters}
- **Answer**:
- **Status**: Pending

### Answered -- refine mode only

---

## Readiness Assessment

| Metric | Value |
|--------|-------|
| Total items | {N} |
| CONFIRMED | {X} ({pct}%) |
| ASSUMED | {Y} ({pct}%) |
| UNCLEAR | {Z} ({pct}%) |
| Q&A Pending | {P} (HIGH: {H}, MEDIUM: {M}, LOW: {L}) |

**Verdict**: {Ready / Partially Ready / Not Ready}
**Reasoning**: {1-2 sentences}

{If refine mode:}
**Comparison**: CONFIRMED {prev}% -> {current}% ({+/-}%), {N} Q&A resolved

---

{If refine mode, include Diff Summary here}

---

## Approval

| Role | Name | Date | Status |
|------|------|------|--------|
| Product Owner | | | Pending |
| Scrum Master | | | Pending |
```
