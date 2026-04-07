# Risk Register Output Template

This is the expected structure for `risk-register-draft.md` output. Follow this exactly.

---

```markdown
# Risk Register: {Project Name}

> **Project**: {Project Name}
> **Version**: {1.0}
> **Date Created**: {YYYY-MM-DD}
> **Last Updated**: {YYYY-MM-DD}
> **Status**: Draft
> **Author**: AI-Generated

{If refine mode, include Change Log here}

---

## 1. Risk Summary

| Category | Count | Avg Score | Highest Risk |
|----------|-------|-----------|-------------|
| Technical | {N} | {avg} | RISK-{NNN} |
| Resource | {N} | {avg} | |
| Schedule | {N} | {avg} | |
| Scope | {N} | {avg} | |
| External | {N} | {avg} | |
| Organizational | {N} | {avg} | |
| **Total** | **{N}** | **{avg}** | |

---

## 2. Risk Assessment Matrix

| ID | Category | Description | Source | P (1-5) | I (1-5) | Score | Response | Mitigation Strategy | Owner | Status | Confidence |
|----|----------|-------------|--------|---------|---------|-------|----------|---------------------|-------|--------|------------|

### Scoring Guide

**Probability:**
- 1 = Rare (< 10%)
- 2 = Unlikely (10-30%)
- 3 = Possible (30-50%)
- 4 = Likely (50-70%)
- 5 = Almost certain (> 70%)

**Impact:**
- 1 = Negligible
- 2 = Minor (< 1 week delay or < 5% budget)
- 3 = Moderate (1-2 week delay or 5-10% budget)
- 4 = Major (2-4 week delay or 10-20% budget)
- 5 = Critical (> 4 week delay or > 20% budget)

**Risk Score Ranges:**
- 1-5: Low -- Monitor
- 6-12: Medium -- Active mitigation required
- 13-19: High -- Escalate and mitigate immediately
- 20-25: Critical -- May require scope/approach change

---

## 3. Risk Heat Map

{ASCII heat map with RISK-IDs placed in cells}

---

## 4. Risk Response Strategies

| Strategy | When to Use | Example |
|----------|------------|---------|
| **Avoid** | Eliminate the threat by changing the plan | {project-specific example} |
| **Mitigate** | Reduce probability or impact | {project-specific example} |
| **Transfer** | Shift risk to a third party | {project-specific example} |
| **Accept** | Acknowledge and monitor | {project-specific example} |

---

## 5. Risk Monitoring Plan

| Risk ID | Trigger Condition | Check Frequency | Contingency Plan | Owner |
|---------|------------------|-----------------|-----------------|-------|

---

## Q&A Log

### Pending

#### Q-{NNN} (related: RISK-{NNN})
- **Impact**: HIGH / MEDIUM / LOW
- **Question**: {specific question}
- **Context**: {why this matters for risk assessment}
- **Answer**:
- **Status**: Pending

### Answered -- refine mode only
{Previously answered Q&A entries}

---

## Readiness Assessment

| Metric | Value |
|--------|-------|
| Total items | {N} |
| CONFIRMED | {X} ({pct}%) |
| ASSUMED | {Y} ({pct}%) |
| UNCLEAR | {Z} ({pct}%) |
| Q&A Pending | {P} (HIGH: {H}, MEDIUM: {M}, LOW: {L}) |
| Risks by severity | Critical: {C}, High: {H}, Medium: {M}, Low: {L} |

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
| Project Sponsor | | | Pending |
| Product Owner | | | Pending |
```
