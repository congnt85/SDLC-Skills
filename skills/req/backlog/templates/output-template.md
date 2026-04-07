# Backlog Output Template

This is the expected structure for `backlog-draft.md` output. Follow this exactly.

---

```markdown
# Product Backlog: {Project Name}

> **Project**: {Project Name}
> **Version**: {1.0}
> **Date Created**: {YYYY-MM-DD}
> **Last Updated**: {YYYY-MM-DD}
> **Status**: Draft
> **Author**: AI-Generated
> **Source**: Derived from `userstories-final.md` and `epics-final.md`

{If refine mode, include Change Log here}

---

## 1. Backlog Summary

| Metric | Value |
|--------|-------|
| Total stories | {N} |
| Must Have | {N} stories, {X} points |
| Should Have | {N} stories, {X} points |
| Could Have | {N} stories, {X} points |
| Won't Have (deferred) | {N} stories |
| Total Estimated Points | {X} |
| Estimated Velocity | {Y} points/sprint |
| Estimated Sprints (MVP) | {Z} |
| Estimated Sprints (All) | {W} |

---

## 2. MoSCoW Distribution

| Priority | Stories | Points | % of Total | Target |
|----------|---------|--------|------------|--------|
| Must Have | {N} | {X} | {pct}% | ~60% |
| Should Have | {N} | {X} | {pct}% | ~20% |
| Could Have | {N} | {X} | {pct}% | ~20% |
| Won't Have | {N} | — | — | — |

{Flag if distribution is significantly off-target}

---

## 3. Prioritized Backlog

| Rank | ID | Epic | Title | Priority | Points | Dependencies | Release | Confidence |
|------|----|------|-------|----------|--------|-------------|---------|------------|
| 1 | US-{NNN} | EPIC-{NNN} | {title} | Must Have | {pts} | — | MVP | {marker} |
| ... | | | | | | | | |
| --- | --- MVP BOUNDARY --- | | | | | | | |
| {N} | US-{NNN} | EPIC-{NNN} | {title} | Should Have | {pts} | — | R2 | {marker} |
| ... | | | | | | | | |

---

## 4. Dependency Graph

```mermaid
graph TD
    ...
```

**Critical path**: {longest dependency chain}

---

## 5. Release Grouping

### Release 1: MVP

| Epic | Stories | Points | Target Sprints |
|------|---------|--------|---------------|
| EPIC-{NNN} | US-xxx..US-yyy | {X} | Sprint {A}-{B} |

**Total**: {N} stories, {X} points, {Y} sprints

### Release 2: {Name}

| Epic | Stories | Points | Target Sprints |
...

---

## 6. Velocity Assumptions

| Assumption | Value | Confidence |
|------------|-------|------------|
| Sprint length | {2 weeks} | {marker} |
| Team size | {N developers} | {marker} |
| Estimated velocity | {X points/sprint} | {marker} |
| Velocity basis | {estimation method} | {marker} |

### Capacity Check

| Metric | Value |
|--------|-------|
| Must Have points | {X} |
| Available sprints (from timeline) | {N} |
| Required velocity | {X/N} points/sprint |
| Estimated velocity | {Y} points/sprint |
| Status | {OK / At Risk / Over Capacity} |

{If over capacity, include mitigation recommendation}

---

## Q&A Log

### Pending
...

### Answered -- refine mode only
...

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

---

## Approval

| Role | Name | Date | Status |
|------|------|------|--------|
| Product Owner | | | Pending |
| Scrum Master | | | Pending |
```
