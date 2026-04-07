# SLA Specification Output Template

This is the expected structure for `sla-spec-draft.md` output. Follow this exactly.

---

```markdown
# SLA Specification — {Project Name}

> **Project**: {Project Name}
> **Version**: draft | v{N}
> **Date Created**: {YYYY-MM-DD}
> **Last Updated**: {YYYY-MM-DD}
> **Status**: Draft | Under Review | Approved
> **Author**: AI-Generated
> **Source**: Based on `scope-final.md` and `monitoring-plan-final.md`

{If refine mode, include Change Log here}

---

## 1. SLI/SLO/SLA Hierarchy

{Brief explanation of the three concepts and how they relate for this project.}

### Hierarchy Overview

| Concept | Definition | Audience | Example |
|---------|-----------|----------|---------|
| **SLI** (Service Level Indicator) | Quantitative measurement of service quality | Engineering | Request success rate = 99.7% |
| **SLO** (Service Level Objective) | Internal target for an SLI | Engineering + Product | Success rate >= 99.5% over 30 days |
| **SLA** (Service Level Agreement) | External commitment with consequences | Customers | Success rate >= 99.0%, credits if breached |

### Quality Attribute to SLI Mapping

| QA ID | Quality Attribute | SLI Category | SLI ID |
|-------|-------------------|-------------|--------|
| {QA-xxx} | {attribute name} | {category} | {SLI-xxx} |

---

## 2. SLI Definitions

### SLI-{001}: {SLI Name}

| Attribute | Value | Confidence |
|-----------|-------|------------|
| **Source QA** | {QA-xxx}: {description} | ✅/🔶/❓ |
| **Category** | {Availability / Latency / Correctness / Freshness / Throughput} | ✅/🔶/❓ |
| **Metric Name** | {exact metric name in monitoring} | ✅/🔶/❓ |
| **Formula** | {e.g., successful requests / total requests} | ✅/🔶/❓ |
| **Data Source** | {e.g., ALB access logs, Prometheus, CloudWatch} | ✅/🔶/❓ |
| **Measurement Window** | {e.g., per-minute for alerting, 30-day rolling for SLO} | ✅/🔶/❓ |
| **Includes** | {what counts as success} | ✅/🔶/❓ |
| **Excludes** | {what is excluded from calculation} | ✅/🔶/❓ |

{Repeat for each SLI.}

### SLI Summary Table

| SLI ID | Name | Formula | Source | Window | Confidence |
|--------|------|---------|--------|--------|------------|
| SLI-{001} | {name} | {formula} | {source} | {window} | ✅/🔶/❓ |

---

## 3. SLO Targets

### SLO Summary

| SLO ID | SLI | Target | Window | Error Budget | Source QA | Confidence |
|--------|-----|--------|--------|-------------|-----------|------------|
| SLO-{001} | SLI-{001} | {target %} | {window} | {budget %} | {QA-xxx} | ✅/🔶/❓ |

### SLO-{001}: {SLO Name}

| Attribute | Value | Confidence |
|-----------|-------|------------|
| **SLI** | SLI-{001}: {name} | ✅/🔶/❓ |
| **Target** | {e.g., >= 99.5%} | ✅/🔶/❓ |
| **Measurement Window** | {e.g., 30-day rolling} | ✅/🔶/❓ |
| **Error Budget** | {e.g., 0.5% = 3.6 hours/month} | ✅/🔶/❓ |
| **Derived From** | {QA-xxx}: {requirement text} | ✅/🔶/❓ |
| **Breach Consequence (Internal)** | {e.g., feature freeze, investigation} | ✅/🔶/❓ |

{Repeat for each SLO.}

---

## 4. SLA Commitments

{If no external SLA is needed, state: "This project operates with internal SLOs only. No external SLA commitments are defined at this time. SLA commitments should be introduced when the service has paying customers or contractual obligations."}

{If external SLAs exist:}

### SLA Summary

| SLA ID | SLO ID | SLA Target | SLO Target | Gap | Consequence | Confidence |
|--------|--------|-----------|-----------|-----|-------------|------------|
| SLA-{001} | SLO-{001} | {target} | {target} | {gap %} | {consequence} | ✅/🔶/❓ |

### SLA-{001}: {SLA Name}

| Attribute | Value | Confidence |
|-----------|-------|------------|
| **Corresponding SLO** | SLO-{001} | ✅/🔶/❓ |
| **SLA Target** | {less aggressive than SLO} | ✅/🔶/❓ |
| **Measurement Period** | {e.g., calendar month} | ✅/🔶/❓ |
| **Breach Consequence** | {e.g., service credits, penalty} | ✅/🔶/❓ |
| **Exclusions** | {e.g., planned maintenance, force majeure} | ✅/🔶/❓ |

---

## 5. Error Budgets

### 5.1 Error Budget Summary

| SLO ID | SLO Target | Error Budget | Monthly Budget (concrete) | Tracking Method | Confidence |
|--------|-----------|-------------|--------------------------|-----------------|------------|
| SLO-{001} | {target} | {budget %} | {hours / requests / etc.} | {method} | ✅/🔶/❓ |

### 5.2 Burn Rate Alert Configuration

| Alert Name | SLI | Burn Rate | Window | Severity | Action | Confidence |
|------------|-----|-----------|--------|----------|--------|------------|
| Fast burn — {name} | SLI-{001} | {e.g., 14.4x} | {e.g., 5 min} | P1 (page) | {action} | ✅/🔶/❓ |
| Slow burn — {name} | SLI-{001} | {e.g., 6x} | {e.g., 6 hours} | P2 (ticket) | {action} | ✅/🔶/❓ |
| Budget alert — {name} | SLI-{001} | N/A | {e.g., 30-day} | P3 (notify) | {action} | ✅/🔶/❓ |

### 5.3 Error Budget Policies

| Budget Consumed | State | Policy | Owner | Confidence |
|----------------|-------|--------|-------|------------|
| 0-50% | **Normal** | {policy description} | {owner} | ✅/🔶/❓ |
| 50-80% | **Investigate** | {policy description} | {owner} | ✅/🔶/❓ |
| 80-100% | **Feature Freeze** | {policy description} | {owner} | ✅/🔶/❓ |
| 100%+ | **Incident Response** | {policy description} | {owner} | ✅/🔶/❓ |

---

## 6. SLO Dashboard

### 6.1 Dashboard Layout

| Panel | Metrics Displayed | Audience | Confidence |
|-------|-------------------|----------|------------|
| {panel name} | {metrics} | {who views this} | ✅/🔶/❓ |

### 6.2 Reporting Cadence

| Report | Frequency | Audience | Content | Delivery | Confidence |
|--------|-----------|----------|---------|----------|------------|
| {report name} | {frequency} | {audience} | {what it contains} | {how delivered} | ✅/🔶/❓ |

---

## 7. Review Process

### 7.1 Monthly Operational Review

| Attribute | Value | Confidence |
|-----------|-------|------------|
| **Frequency** | Monthly | ✅/🔶/❓ |
| **Duration** | {e.g., 30 minutes} | ✅/🔶/❓ |
| **Attendees** | {roles} | ✅/🔶/❓ |
| **Agenda** | {numbered list} | ✅/🔶/❓ |
| **Output** | {e.g., action items, SLO status report} | ✅/🔶/❓ |

### 7.2 Quarterly Strategic Review

| Attribute | Value | Confidence |
|-----------|-------|------------|
| **Frequency** | Quarterly | ✅/🔶/❓ |
| **Duration** | {e.g., 60 minutes} | ✅/🔶/❓ |
| **Attendees** | {roles} | ✅/🔶/❓ |
| **Agenda** | {numbered list} | ✅/🔶/❓ |
| **Output** | {e.g., target adjustments, new SLIs} | ✅/🔶/❓ |

### 7.3 Ad-Hoc Review Triggers

| Trigger | Action | Owner | Confidence |
|---------|--------|-------|------------|
| {trigger condition} | {what review to conduct} | {who initiates} | ✅/🔶/❓ |

---

## 8. Q&A Log

| ID | Question | Raised By | Priority | Answer | Status | Confidence |
|----|----------|-----------|----------|--------|--------|------------|
| Q-001 | {question} | {source} | HIGH/MED/LOW | {answer or "Pending"} | Open/Resolved | ✅/🔶/❓ |

---

## 9. Readiness Assessment

### Confidence Summary

| Level | Count | Percentage |
|-------|-------|------------|
| ✅ CONFIRMED | {n} | {%} |
| 🔶 ASSUMED | {n} | {%} |
| ❓ UNCLEAR | {n} | {%} |
| **Total Items** | {n} | 100% |

### Verdict: {READY / PARTIALLY READY / NOT READY}

{Justification for verdict. List critical gaps if not ready.}

### Key Risks

| # | Risk | Impact | Mitigation |
|---|------|--------|------------|
| 1 | {risk description} | {impact} | {mitigation} |

---

## 10. Approval

| Role | Name | Decision | Date | Signature |
|------|------|----------|------|-----------|
| DevOps Lead | {name} | Approved / Rejected / Conditional | {date} | _________ |
| Engineering Manager | {name} | Approved / Rejected / Conditional | {date} | _________ |

**Conditions / Comments:**
{Any conditions for approval or comments from reviewers.}
```
