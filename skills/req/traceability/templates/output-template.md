# Traceability Output Template

This skill produces TWO output files. Both templates are defined here.

---

## File 1: `traceability-draft.md`

```markdown
# Requirements Traceability Matrix: {Project Name}

> **Project**: {Project Name}
> **Version**: {1.0}
> **Date Created**: {YYYY-MM-DD}
> **Last Updated**: {YYYY-MM-DD}
> **Status**: Draft
> **Author**: AI-Generated
> **Source**: Cross-references all init and req artifacts

{If refine mode, include Change Log here}

---

## 1. Forward Traceability (Objective -> Delivery)

| Objective | Epic(s) | Features | Stories | Total Points | Must Have Points | Coverage |
|-----------|---------|----------|---------|-------------|-----------------|----------|

---

## 2. Backward Traceability (Story -> Source)

| Story | Feature | Epic | Objective | Risk | Priority | Confidence |
|-------|---------|------|-----------|------|----------|------------|

---

## 3. Feature Coverage

| Feature (SCP-xxx) | Description | Stories | Points | Coverage Status |
|-------------------|-------------|---------|--------|-----------------|

**Coverage Status**: Full / Partial / Gap / Deferred

---

## 4. Gap Analysis

### Objectives Without Full Coverage
{List any objectives missing Must Have stories}

### Features Without Stories
{List features with zero stories}

### Epics Without Stories
{List epics with zero stories}

### Stories Without Acceptance Criteria
{List stories missing AC}

### Personas Without Must Have Stories
{List Primary personas with no Must Have stories}

### High Risks Without Spike Stories
{List HIGH risks with no corresponding spike or mitigation story}

---

## 5. Coverage Summary

| Metric | Value |
|--------|-------|
| Objectives with epics | {X}/{Y} ({pct}%) |
| Objectives with Must Have stories | {X}/{Y} ({pct}%) |
| Features with stories | {X}/{Y} ({pct}%) |
| Epics with stories | {X}/{Y} ({pct}%) |
| Stories with AC | {X}/{Y} ({pct}%) |
| Primary personas with Must Have stories | {X}/{Y} ({pct}%) |
| HIGH risks with spike stories | {X}/{Y} ({pct}%) |

---

## Q&A Log

### Pending
...

---

## Readiness Assessment

| Metric | Value |
|--------|-------|
| Total items | {N} |
| CONFIRMED | {X} ({pct}%) |
| ASSUMED | {Y} ({pct}%) |
| UNCLEAR | {Z} ({pct}%) |
| Gaps found | {G} |
| Q&A Pending | {P} (HIGH: {H}, MEDIUM: {M}, LOW: {L}) |

**Verdict**: {Ready / Partially Ready / Not Ready}
**Reasoning**: {1-2 sentences}

---

## Approval

| Role | Name | Date | Status |
|------|------|------|--------|
| Product Owner | | | Pending |
| Scrum Master | | | Pending |
```

---

## File 2: `dor-dod-draft.md`

```markdown
# Definition of Ready & Definition of Done: {Project Name}

> **Project**: {Project Name}
> **Version**: {1.0}
> **Date Created**: {YYYY-MM-DD}
> **Last Updated**: {YYYY-MM-DD}
> **Status**: Draft
> **Author**: AI-Generated

{If refine mode, include Change Log here}

---

## Definition of Ready (DoR)

A story is ready for sprint planning when ALL criteria are met:

| ID | Criterion | Description | Source | Confidence |
|----|-----------|-------------|--------|------------|
| DOR-01 | {criterion} | {description} | {standard / project-specific} | {marker} |

---

## Definition of Done (DoD)

A story is done when ALL criteria are met:

| ID | Criterion | Description | Source | Confidence |
|----|-----------|-------------|--------|------------|
| DOD-01 | {criterion} | {description} | {standard / project-specific} | {marker} |

---

## DoR/DoD Applicability

| Criterion | Regular Stories | NFR Stories | Spike Stories |
|-----------|----------------|-------------|--------------|
| DOR-01 | Yes | Yes | Modified |
| DOD-01 | Yes | Yes | Modified |

{Note any criteria that apply differently to NFR or Spike stories}

---

## Approval

| Role | Name | Date | Status |
|------|------|------|--------|
| Product Owner | | | Pending |
| Scrum Master | | | Pending |
```
