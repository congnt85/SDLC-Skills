# Epic Output Template

This is the expected structure for `epics-draft.md` output. Follow this exactly.

---

```markdown
# Epics: {Project Name}

> **Project**: {Project Name}
> **Version**: {1.0}
> **Date Created**: {YYYY-MM-DD}
> **Last Updated**: {YYYY-MM-DD}
> **Status**: Draft
> **Author**: AI-Generated
> **Source**: Derived from `charter-final.md` and `scope-final.md`

{If refine mode, include Change Log here}

---

## 1. Epic Overview

| ID | Title | Objective | Features | Priority | Est. Stories | Est. Points | Confidence |
|----|-------|-----------|----------|----------|-------------|-------------|------------|

---

## 2. Epic Details

### EPIC-{NNN}: {Title}

| Field | Value |
|-------|-------|
| **ID** | EPIC-{NNN} |
| **Title** | {title} |
| **Objective** | {charter objective ref} |
| **Description** | {2-3 sentences} |
| **Scope Features** | {SCP-xxx, SCP-yyy} |
| **Personas** | {persona names and roles} |
| **Success Criteria** | {measurable outcome from OKRs} |
| **Priority** | Must Have / Should Have / Could Have |
| **Estimated Stories** | {N} |
| **Estimated Points** | {range or total} |
| **Dependencies** | {EPIC-xxx or "None"} |
| **Tags** | {optional: [CROSS-CUTTING], [SPIKE]} |
| **Confidence** | {marker + annotation} |

{Repeat for each epic}

---

## 3. Feature-to-Epic Map

| Feature (SCP-xxx) | Description | Epic | Notes |
|-------------------|-------------|------|-------|

---

## 4. Epic Dependency Map

```mermaid
graph LR
    ...
```

---

## Q&A Log

### Pending

#### Q-{NNN} (related: EPIC-{NNN})
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
