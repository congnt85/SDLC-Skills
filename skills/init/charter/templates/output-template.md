# Charter Output Template

This is the expected structure for `charter-draft.md` output. Follow this exactly.

---

```markdown
# Project Charter: {Project Name}

> **Project**: {Project Name}
> **Version**: {1.0}
> **Date Created**: {YYYY-MM-DD}
> **Last Updated**: {YYYY-MM-DD}
> **Status**: Draft
> **Author**: AI-Generated

{If refine mode, include Change Log here}

---

## 1. Vision Statement

### Elevator Pitch
{1-2 sentences}

### Product Vision
{Moore template: FOR/WHO/THE/THAT/UNLIKE/OUR SOLUTION}

### Anti-Vision: What This Project is NOT
- {exclusion 1}
- {exclusion 2}

---

## 2. Problem Statement

### Current State
{Description} — ✅/🔶/❓

### Future State
{Description} — ✅/🔶/❓

### Gap Analysis
| Dimension | Current State | Desired Future State | Gap | Confidence |
|-----------|--------------|---------------------|-----|------------|

### Impact of Inaction
{What happens if we don't do this} — ✅/🔶/❓

---

## 3. Business Justification

### Expected Benefits
| Benefit | Type | Estimated Value | Timeline | Confidence |
|---------|------|----------------|----------|------------|

### Success Metrics (OKR Format)

**Objective 1**: {objective}
| Key Result | Baseline | Target | Measurement | Deadline | Confidence |
|------------|----------|--------|-------------|----------|------------|

---

## 4. High-Level Scope

### In Scope
| ID | Feature | Description | Priority | Confidence |
|----|---------|-------------|----------|------------|

### Out of Scope
| ID | Feature | Reason | Confidence |
|----|---------|--------|------------|

---

## 5. Key Milestones
| ID | Milestone | Target Date | Success Criteria | Confidence |
|----|-----------|------------|-----------------|------------|

---

## 6. Budget Estimate

**Method**: {Three-Point / Analogous / Parametric}

| Category | Optimistic | Most Likely | Pessimistic | Expected | Confidence |
|----------|-----------|-------------|-------------|----------|------------|
| **Total** | | | | **$** | |

---

## 7. Team Structure
| Role | Name | Allocation | Responsibilities |
|------|------|-----------|-----------------|

---

## 8. Assumptions
| ID | Assumption | Impact if Wrong | Validation Plan | Confidence |
|----|-----------|----------------|----------------|------------|

## 9. Constraints
| ID | Constraint | Type | Negotiable? | Impact | Confidence |
|----|-----------|------|-------------|--------|------------|

## 10. Dependencies
| ID | Dependency | Type | Owner | Expected Date | Risk if Delayed | Confidence |
|----|-----------|------|-------|--------------|----------------|------------|

---

## Q&A Log

### Pending (⏳)
{Sorted by Impact: HIGH first}

#### Q-001 (related: {item IDs})
- **Impact**: HIGH / MEDIUM / LOW
- **Question**: {specific question}
- **Context**: {why this matters}
- **Answer**:
- **Status**: ⏳ Pending

### Answered (✅) — refine mode only
{Previously answered Q&A entries}

---

## Readiness Assessment

| Metric | Value |
|--------|-------|
| Total items | {N} |
| ✅ CONFIRMED | {X} ({pct}%) |
| 🔶 ASSUMED | {Y} ({pct}%) |
| ❓ UNCLEAR | {Z} ({pct}%) |
| Q&A Pending | {P} (HIGH: {H}, MEDIUM: {M}, LOW: {L}) |

**Verdict**: {✅ Ready / ⚠️ Partially Ready / ❌ Not Ready}
**Reasoning**: {1-2 sentences}

{If refine mode:}
**Comparison**: CONFIRMED {prev}% → {current}% ({+/-}%), {N} Q&A resolved

---

{If refine mode, include Diff Summary here}

---

## Approval

| Role | Name | Date | Status |
|------|------|------|--------|
| Project Sponsor | | | ☐ Pending |
| Product Owner | | | ☐ Pending |
```
