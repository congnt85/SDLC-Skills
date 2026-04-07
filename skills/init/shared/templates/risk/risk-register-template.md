# Risk Register: {Project Name}

> **Project**: {Project Name}
> **Version**: 1.0
> **Date Created**: {YYYY-MM-DD}
> **Last Updated**: {YYYY-MM-DD}
> **Status**: Draft
> **Author**: AI-Generated

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

| ID | Category | Description | Probability (1-5) | Impact (1-5) | Score (P×I) | Response | Mitigation Strategy | Owner | Status | Confidence |
|----|----------|-------------|-------------------|-------------|-------------|----------|---------------------|-------|--------|------------|
| RISK-001 | {category} | {description} | {1-5} | {1-5} | {score} | Avoid/Mitigate/Transfer/Accept | {strategy} | {owner} | Open | {✅/🔶/❓} |

### Scoring Guide

**Probability:**
- 1 = Rare (< 10%)
- 2 = Unlikely (10-30%)
- 3 = Possible (30-50%)
- 4 = Likely (50-70%)
- 5 = Almost certain (> 70%)

**Impact:**
- 1 = Negligible — minor inconvenience, no schedule/budget impact
- 2 = Minor — workaround exists, < 1 week delay or < 5% budget
- 3 = Moderate — some rework, 1-2 week delay or 5-10% budget
- 4 = Major — significant rework, 2-4 week delay or 10-20% budget
- 5 = Critical — project failure, > 4 week delay or > 20% budget

**Risk Score:**
- 1-5: Low — Monitor
- 6-12: Medium — Active mitigation required
- 13-19: High — Escalate and mitigate immediately
- 20-25: Critical — May require scope/approach change

---

## 3. Risk Heat Map

```
Impact  5 |  5  | 10  | 15  | 20  | 25  |
        4 |  4  |  8  | 12  | 16  | 20  |
        3 |  3  |  6  |  9  | 12  | 15  |
        2 |  2  |  4  |  6  |  8  | 10  |
        1 |  1  |  2  |  3  |  4  |  5  |
           ─────┬─────┬─────┬─────┬─────┬
              1     2     3     4     5
                    Probability

Risk placement: {list RISK-IDs in their cells}
```

---

## 4. Risk Response Strategies

| Strategy | When to Use | Example |
|----------|------------|---------|
| **Avoid** | Eliminate the threat by changing the plan | Drop risky feature from scope |
| **Mitigate** | Reduce probability or impact | Add spike to reduce technical uncertainty |
| **Transfer** | Shift risk to a third party | Use managed service instead of self-hosting |
| **Accept** | Acknowledge and monitor (active or passive) | Low-impact risks with no cost-effective mitigation |

---

## 5. Risk Monitoring Plan

| Risk ID | Trigger Condition | Check Frequency | Contingency Plan | Owner |
|---------|------------------|-----------------|-----------------|-------|
| RISK-001 | {what signals this risk is materializing} | {weekly/sprint/daily} | {what to do if triggered} | {name} |

---

## Approval

| Role | Name | Date | Status |
|------|------|------|--------|
| Project Sponsor | | | ☐ Pending |
| Product Owner | | | ☐ Pending |
