# Risk Register: TaskFlow

> **Project**: TaskFlow
> **Version**: 1.0
> **Date Created**: 2026-04-06
> **Last Updated**: 2026-04-06
> **Status**: Draft
> **Author**: AI-Generated

---

## 1. Risk Summary

| Category | Count | Avg Score | Highest Risk |
|----------|-------|-----------|-------------|
| Technical | 4 | 12.0 | RISK-001 |
| Resource | 2 | 10.0 | RISK-005 |
| Schedule | 2 | 10.5 | RISK-007 |
| Scope | 2 | 10.0 | RISK-009 |
| External | 1 | 8.0 | RISK-010 |
| Organizational | 1 | 10.0 | RISK-011 |
| **Total** | **12** | **10.3** | |

---

## 2. Risk Assessment Matrix

| ID | Category | Description | Source | P | I | Score | Response | Mitigation Strategy | Owner | Status | Confidence |
|----|----------|-------------|--------|---|---|-------|----------|---------------------|-------|--------|------------|
| RISK-001 | Technical | Webhook payloads from GitHub/GitLab may lack sufficient data to accurately determine ticket status transitions | ASM-001 | 3 | 5 | 15 | Mitigate | Conduct PoC in Sprint 0: send test webhook payloads from both GitHub and GitLab; verify all required fields (branch, commit msg, PR status) are present | [TBD] | Open | 🔶 ASSUMED |
| RISK-002 | Technical | Target teams may not use consistent branch naming conventions, preventing automatic commit-to-ticket mapping | ASM-002 | 4 | 4 | 16 | Mitigate | Survey 5 target teams' Git practices before Sprint 1; build configurable parsing rules with regex patterns; support multiple conventions | [TBD] | Open | 🔶 ASSUMED |
| RISK-003 | Technical | Real-time dashboard updates (< 5s latency) may require WebSocket infrastructure that adds significant complexity | QA-005, SCP-002.2 | 3 | 3 | 9 | Mitigate | Start with server-sent events (SSE) for v1; measure actual latency needs from beta users; upgrade to WebSocket only if SSE insufficient | [TBD] | Open | 🔶 ASSUMED |
| RISK-004 | Technical | Dashboard performance degrades with large teams (50+ members) and high ticket volumes (500+ per sprint) | QA-001, SCP-002 | 3 | 3 | 9 | Mitigate | Load test with 500 concurrent users by Sprint 3; set P95 latency target at 2s; implement pagination and lazy loading | [TBD] | Open | 🔶 ASSUMED |
| RISK-005 | Resource | Key developer with Git integration expertise leaves or is reassigned during development | DEP-002 | 2 | 5 | 10 | Mitigate | Cross-train at least 2 developers on webhook/Git integration by Sprint 2; document all integration decisions as ADRs | [TBD] | Open | 🔶 ASSUMED |
| RISK-006 | Resource | UX designer availability is uncertain (DEP-002 in charter marked UNCLEAR) — dashboard design may be delayed | DEP-002 | 3 | 3 | 9 | Mitigate | Start with developer-built UI using component library; engage UX designer when available for refinement; don't block development on UX | [TBD] | Open | ❓ UNCLEAR |
| RISK-007 | Schedule | Timeline pressure (CON-001: launch by end Q3 2026) leaves minimal buffer for unexpected complexity | CON-001 | 4 | 3 | 12 | Mitigate | Prioritize Must Have features only for launch; maintain prioritized backlog so Could Have features can be dropped cleanly; weekly scope review with PO | [TBD] | Open | ✅ CONFIRMED |
| RISK-008 | Schedule | External dependency on GitHub OAuth app approval (DEP-001) could block Git integration development | DEP-001 | 2 | 4 | 8 | Mitigate | Submit OAuth app for approval in week 1; develop against personal access tokens as fallback; build abstraction layer so auth method is swappable | [TBD] | Open | 🔶 ASSUMED |
| RISK-009 | Scope | Requirements for Git event-to-status mapping are undefined (Q-001 in charter), leading to rework if assumptions are wrong | Charter Q-001 | 4 | 3 | 12 | Mitigate | Resolve charter Q-001 before Sprint 1; define mapping rules with SM Sam and 2 target teams; make rules configurable per team | [TBD] | Open | 🔶 ASSUMED |
| RISK-010 | Scope | Scope creep from stakeholders requesting "just one more" notification channel or integration | SCP-003, SCP-004 | 3 | 3 | 9 | Mitigate | Enforce scope change control process from scope document; all additions go through PO evaluation; maintain Won't Have list | [TBD] | Open | 🔶 ASSUMED |
| RISK-011 | External | GitHub or GitLab changes webhook API format, breaking existing integration | INT-001, INT-002 | 2 | 4 | 8 | Transfer | Build abstraction layer over webhook parsing; monitor GitHub/GitLab changelogs; subscribe to API deprecation notifications | [TBD] | Open | 🔶 ASSUMED |
| RISK-012 | Organizational | Budget cap ($300K, CON-002) may be insufficient if team needs to grow or timeline extends | CON-002 | 2 | 5 | 10 | Accept | Maintain prioritized backlog; MVP can ship with Must Have features only within $200K; $100K contingency covers 2-month extension | [TBD] | Open | ✅ CONFIRMED |

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

```
Impact  5 |     |     | R001|     |     |
        4 |     | R008| R011|R002 |     |
        3 |     |     |R003 |R007 |     |
          |     |     |R004 |R009 |     |
          |     |     |R010 |     |     |
        2 |     |     |     |     |     |
        1 |     |     |     |     |     |
           -----+-----+-----+-----+-----+
              1     2     3     4     5
                    Probability

R005 (2,5) = cell [2,5]    R006 (3,3) = cell [3,3]
R012 (2,5) = cell [2,5]
```

---

## 4. Risk Response Strategies

| Strategy | When to Use | Example |
|----------|------------|---------|
| **Avoid** | Eliminate the threat by changing the plan | Drop ML prediction feature (SCP-005.3) from v1 to avoid data insufficiency risk |
| **Mitigate** | Reduce probability or impact | PoC webhook integration in Sprint 0 to validate data availability (RISK-001) |
| **Transfer** | Shift risk to a third party | Use abstraction layer over GitHub/GitLab APIs to isolate from vendor changes (RISK-011) |
| **Accept** | Acknowledge and monitor | Budget cap is fixed — maintain prioritized backlog so MVP ships within constraints (RISK-012) |

---

## 5. Risk Monitoring Plan

| Risk ID | Trigger Condition | Check Frequency | Contingency Plan | Owner |
|---------|------------------|-----------------|-----------------|-------|
| RISK-001 | PoC reveals missing data fields in webhook payloads | Sprint 0 (one-time) | Fall back to polling GitHub/GitLab API for missing data; accept higher latency | [TBD] |
| RISK-002 | Survey reveals < 50% of target teams use recognizable branch naming | Before Sprint 1 | Build NLP-based commit message parser as alternative mapping strategy | [TBD] |
| RISK-007 | Velocity after Sprint 2 shows Must Have features won't complete by end of Q3 | Every sprint | Escalate to sponsor; propose phased launch with core features first, remaining in v1.1 | [TBD] |
| RISK-009 | Mapping rules rejected by > 1 beta team during beta phase | Sprint review | Make mapping rules fully user-configurable per team; provide setup wizard | [TBD] |

---

## Q&A Log

### Pending

#### Q-001 (related: RISK-001, RISK-002)
- **Impact**: HIGH
- **Question**: Can we get access to sample webhook payloads from 2-3 target teams to validate our parsing assumptions before Sprint 1?
- **Context**: RISK-001 and RISK-002 both depend on understanding actual webhook data and branch naming. Without real samples, we're building on assumptions.
- **Answer**:
- **Status**: Pending

#### Q-002 (related: RISK-006)
- **Impact**: MEDIUM
- **Question**: When will the UX designer be available? Is there a specific date commitment from HR?
- **Context**: RISK-006 can be downgraded if we get a confirmed availability date. If no designer is available, we need to budget for a contractor.
- **Answer**:
- **Status**: Pending

#### Q-003 (related: RISK-012)
- **Impact**: MEDIUM
- **Question**: Is the $300K budget inclusive of the 20% contingency ($43K) mentioned in the charter, or is contingency separate?
- **Context**: If contingency is within the $300K cap, effective development budget is $257K. This affects how much buffer we have for RISK-007 and RISK-012.
- **Answer**:
- **Status**: Pending

---

## Readiness Assessment

| Metric | Value |
|--------|-------|
| Total items | 28 |
| ✅ CONFIRMED | 2 (7%) |
| 🔶 ASSUMED | 25 (89%) |
| ❓ UNCLEAR | 1 (4%) |
| Q&A Pending | 3 (HIGH: 1, MEDIUM: 2, LOW: 0) |
| Risks by severity | Critical: 0, High: 2, Medium: 10, Low: 0 |

**Verdict**: ⚠️ Partially Ready

**Reasoning**: Risk identification is comprehensive (12 risks across 6 categories) and traces to charter/scope sources. However, 89% of items are ASSUMED because risk scoring depends on unvalidated assumptions. The two HIGH-severity risks (RISK-001, RISK-002) have Sprint 0 mitigations that will provide validation data. Risk register readiness will improve significantly after Sprint 0 PoC results.

---

## Approval

| Role | Name | Date | Status |
|------|------|------|--------|
| Project Sponsor | Sarah Chen | | ☐ Pending |
| Product Owner | [TBD] | | ☐ Pending |
