# Requirements Traceability Matrix: TaskFlow

> **Project**: TaskFlow
> **Version**: 1.0
> **Date Created**: 2026-04-06
> **Last Updated**: 2026-04-06
> **Status**: Draft
> **Author**: AI-Generated
> **Source**: Cross-references all init and req artifacts

---

## 1. Forward Traceability (Objective -> Delivery)

| Objective | Epic(s) | Features | Stories | Total Points | Must Have Points | Coverage |
|-----------|---------|----------|---------|-------------|-----------------|----------|
| Obj 1: Eliminate manual sprint status updates | EPIC-001, EPIC-002, EPIC-003 | SCP-001, SCP-002, SCP-003 | US-001..US-006, US-010..US-013, US-015..US-016 | 56 | 43 | ✅ Full |
| Obj 2: Improve sprint predictability | EPIC-002, EPIC-004, EPIC-005 | SCP-002, SCP-004, SCP-005 | US-010..US-013, US-020..US-023, US-040..US-043 | 46 | 12 | ⚠️ Partial |
| (Cross-cutting) | EPIC-006 | INT-005, QA-001, QA-002, QA-004 | US-025, US-030..US-033 | 19 | 19 | ✅ Full |

**Note**: Obj 2 has partial coverage because most stories supporting it are Should Have (alerts) or Could Have (analytics). Only the dashboard stories (US-010..US-013) are Must Have. 🔶 ASSUMED — Q&A ref: Q-001

---

## 2. Backward Traceability (Story -> Source)

| Story | Feature | Epic | Objective | Risk | Priority | Confidence |
|-------|---------|------|-----------|------|----------|------------|
| US-001 | SCP-001.1 | EPIC-001 | Obj 1 | — | Must Have | ✅ |
| US-002 | SCP-001.2 | EPIC-001 | Obj 1 | — | Must Have | ✅ |
| US-003 | SCP-001.3 | EPIC-001 | Obj 1 | — | Must Have | 🔶 |
| US-004 | SCP-001.4 | EPIC-001 | Obj 1 | — | Must Have | 🔶 |
| US-005 | SCP-001.5 | EPIC-001 | Obj 1 | — | Should Have | 🔶 |
| US-006 | SCP-001.2 | EPIC-001 | Obj 1 | — | Must Have | ✅ |
| US-010 | SCP-002.1 | EPIC-002 | Obj 1, 2 | — | Must Have | ✅ |
| US-011 | SCP-002.4 | EPIC-002 | Obj 1, 2 | — | Must Have | ✅ |
| US-012 | SCP-002.3 | EPIC-002 | Obj 1, 2 | — | Should Have | 🔶 |
| US-013 | SCP-002.2 | EPIC-002 | Obj 1, 2 | — | Must Have | 🔶 |
| US-015 | SCP-003.1 | EPIC-003 | Obj 1 | — | Should Have | 🔶 |
| US-016 | SCP-003.2 | EPIC-003 | Obj 1 | — | Should Have | 🔶 |
| US-020 | SCP-004 | EPIC-004 | Obj 2 | — | Should Have | ✅ |
| US-021 | SCP-004 | EPIC-004 | Obj 2 | — | Should Have | 🔶 |
| US-022 | SCP-004 | EPIC-004 | Obj 2 | — | Should Have | 🔶 |
| US-023 | SCP-004 | EPIC-004 | Obj 2 | — | Should Have | 🔶 |
| US-025 | QA-001 | EPIC-006 | Cross-cut | — | Must Have | 🔶 |
| US-026 | — | EPIC-001 | Obj 1 | RISK-001 | Must Have | 🔶 |
| US-027 | — | EPIC-001 | Obj 1 | RISK-002 | Must Have | 🔶 |
| US-030 | INT-005 | EPIC-006 | Cross-cut | — | Must Have | 🔶 |
| US-031 | INT-005 | EPIC-006 | Cross-cut | — | Must Have | 🔶 |
| US-032 | QA-004 | EPIC-006 | Cross-cut | — | Must Have | 🔶 |
| US-033 | QA-002 | EPIC-006 | Cross-cut | — | Must Have | 🔶 |
| US-040 | SCP-005.1 | EPIC-005 | Obj 2 | — | Could Have | 🔶 |
| US-041 | SCP-005.2 | EPIC-005 | Obj 2 | — | Could Have | 🔶 |
| US-042 | SCP-005.3 | EPIC-005 | Obj 2 | — | Could Have | ❓ |
| US-043 | SCP-005 | EPIC-005 | Obj 2 | — | Could Have | 🔶 |

---

## 3. Feature Coverage

| Feature (SCP-xxx) | Description | Stories | Points | Coverage Status |
|-------------------|-------------|---------|--------|-----------------|
| SCP-001 (Git Integration) | Auto-detect commits, PRs, branches | 6 | 22 | ✅ Full |
| SCP-001.1 (Webhook receiver) | Accept webhook payloads | US-001 | 3 | ✅ Full |
| SCP-001.2 (Event parser) | Extract data from events | US-002, US-006 | 6 | ✅ Full |
| SCP-001.3 (Ticket mapper) | Match events to tickets | US-003 | 5 | ✅ Full |
| SCP-001.4 (Status updater) | Change ticket status | US-004 | 5 | ✅ Full |
| SCP-001.5 (Manual override) | User corrects mapping | US-005 | 3 | ✅ Full |
| SCP-002 (Sprint Dashboard) | Real-time board | 4 | 15 | ✅ Full |
| SCP-002.1 (Board view) | Kanban-style board | US-010 | 5 | ✅ Full |
| SCP-002.2 (Real-time updates) | Live refresh | US-013 | 5 | ✅ Full |
| SCP-002.3 (Filter and search) | Filter tickets | US-012 | 3 | ✅ Full |
| SCP-002.4 (Sprint selector) | Switch sprints | US-011 | 2 | ✅ Full |
| SCP-003 (CI/CD Integration) | Build/deploy sync | 2 | 8 | ✅ Full |
| SCP-003.1 (Build status) | CI build sync | US-015 | 5 | ✅ Full |
| SCP-003.2 (Deploy status) | Deploy stage sync | US-016 | 3 | ✅ Full |
| SCP-004 (Alerts) | Push notifications | 4 | 13 | ✅ Full |
| SCP-005 (Analytics) | Sprint analytics | 4 | 18 | ⚠️ Partial |
| SCP-005.1 (Velocity chart) | Velocity over time | US-040 | 5 | ✅ Full (Could Have) |
| SCP-005.2 (Burndown chart) | Sprint burndown | US-041 | 5 | ✅ Full (Could Have) |
| SCP-005.3 (Prediction engine) | ML-based prediction | US-042 | 5 | ❓ UNCLEAR |

---

## 4. Gap Analysis

### Objectives Without Full Coverage
- **Obj 2 (Improve sprint predictability)**: Has epics and stories, but only EPIC-002 dashboard stories are Must Have. The primary measurement (KR 2.1: 40% -> 75% accuracy) relies on analytics (Could Have) and alerts (Should Have). **Impact: MEDIUM** — MVP delivers visibility but not predictability improvement measurement. 🔶 ASSUMED — Q&A ref: Q-001

### Features Without Stories
- None — all scope features have at least one story. ✅

### Epics Without Stories
- None — all 6 epics have stories. ✅

### Stories Without Acceptance Criteria
- None in the documented subset. Full story set should be verified. 🔶 ASSUMED

### Personas Without Must Have Stories
- **TL Tara (Secondary)**: Has no Must Have stories. CI/CD stories (US-015, US-016) are Should Have. **Impact: LOW** — TL Tara is a Secondary persona; acceptable for MVP. ✅ CONFIRMED

### High Risks Without Spike Stories
- **RISK-001 (Webhook data sufficiency)**: Covered by US-026 [SPIKE]. ✅
- **RISK-002 (Branch naming conventions)**: Covered by US-027 [SPIKE]. ✅
- All other HIGH risks have mitigation strategies in risk register. ✅

---

## 5. Coverage Summary

| Metric | Value |
|--------|-------|
| Objectives with epics | 2/2 (100%) |
| Objectives with Must Have stories | 2/2 (100%) |
| Features with stories | 18/19 (95%) |
| Features with Must Have stories | 12/19 (63%) |
| Epics with stories | 6/6 (100%) |
| Stories with AC | 27/27 (100%) |
| Primary personas with Must Have stories | 2/2 (100%) |
| HIGH risks with spike stories | 2/2 (100%) |

**Overall**: Strong coverage. One feature gap (SCP-005.3 is UNCLEAR). All Must Have features have stories. All Primary personas are served.

---

## Q&A Log

### Pending

#### Q-001 (related: Obj 2, EPIC-005)
- **Impact**: MEDIUM
- **Question**: Is Obj 2 (Improve sprint predictability) adequately served by MVP if analytics is Could Have? Should velocity chart (US-040) be promoted to Should Have?
- **Context**: The charter's KR 2.1 (40% -> 75% commitment accuracy) relies on analytics data. Without at least basic velocity tracking, measuring KR 2.1 improvement may not be possible.
- **Answer**:
- **Status**: Pending

#### Q-002 (related: SCP-005.3, US-042)
- **Impact**: LOW
- **Question**: Should SCP-005.3 (Prediction engine) and US-042 be moved to Won't Have for v1?
- **Context**: This feature is UNCLEAR in scope and requires historical data not available at launch. Keeping it as Could Have sets expectations it might be delivered.
- **Answer**:
- **Status**: Pending

---

## Readiness Assessment

| Metric | Value |
|--------|-------|
| Total items | 40 |
| ✅ CONFIRMED | 18 (45%) |
| 🔶 ASSUMED | 21 (53%) |
| ❓ UNCLEAR | 1 (3%) |
| Gaps found | 1 (SCP-005.3 UNCLEAR) |
| Q&A Pending | 2 (HIGH: 0, MEDIUM: 1, LOW: 1) |

**Verdict**: ⚠️ Partially Ready

**Reasoning**: Coverage is strong — 100% of objectives have epics and Must Have stories, 95% of features have stories, all Primary personas are served, and all HIGH risks have spike stories. The main gap is SCP-005.3 (ML prediction) which remains UNCLEAR. Confidence is mostly ASSUMED because many stories trace through assumed feature definitions from scope. No blocking issues for proceeding to design phase.

---

## Approval

| Role | Name | Date | Status |
|------|------|------|--------|
| Product Owner | [TBD] | | ☐ Pending |
| Scrum Master | [TBD] | | ☐ Pending |

---
---

# Definition of Ready & Definition of Done: TaskFlow

> **Project**: TaskFlow
> **Version**: 1.0
> **Date Created**: 2026-04-06
> **Last Updated**: 2026-04-06
> **Status**: Draft
> **Author**: AI-Generated

---

## Definition of Ready (DoR)

A story is ready for sprint planning when ALL applicable criteria are met:

| ID | Criterion | Description | Source | Confidence |
|----|-----------|-------------|--------|------------|
| DOR-01 | Story format | Story follows "As a [persona], I want [action], so that [benefit]" format | Standard (REQ-02) | ✅ CONFIRMED |
| DOR-02 | Acceptance criteria | At least 2 Gherkin acceptance criteria (happy path + edge case) | Standard (REQ-03, REQ-09) | ✅ CONFIRMED |
| DOR-03 | Estimated | Story points assigned using Fibonacci scale (1-13) | Standard (REQ-04) | ✅ CONFIRMED |
| DOR-04 | Small enough | Story is <=8 points; stories >8 have a splitting plan | Standard (REQ-04) | ✅ CONFIRMED |
| DOR-05 | Dependencies resolved | All dependencies identified; blocking dependencies are completed or in progress | Standard | ✅ CONFIRMED |
| DOR-06 | Persona identified | Target persona(s) specified from scope document | Standard (REQ-07) | ✅ CONFIRMED |
| DOR-07 | No open questions | All Q&A entries for this story are resolved or have no HIGH impact | Standard (QA-04) | ✅ CONFIRMED |
| DOR-08 | Feature traced | Story traces to a scope feature (SCP-xxx) or risk (RISK-xxx) | Project-specific (REQ-06) | ✅ CONFIRMED |

---

## Definition of Done (DoD)

A story is done when ALL applicable criteria are met:

| ID | Criterion | Description | Source | Confidence |
|----|-----------|-------------|--------|------------|
| DOD-01 | Code complete | Feature code written and merged to main branch | Standard | ✅ CONFIRMED |
| DOD-02 | Unit tests pass | Unit tests written for new code; all tests passing | Standard | ✅ CONFIRMED |
| DOD-03 | Integration tests pass | Integration tests covering key workflows; all passing | Standard | 🔶 ASSUMED |
| DOD-04 | AC verified | All acceptance criteria demonstrated and accepted by PO | Standard | ✅ CONFIRMED |
| DOD-05 | Code reviewed | Pull request approved by at least 1 reviewer | Standard | ✅ CONFIRMED |
| DOD-06 | Deployed to staging | Feature accessible and functional in staging environment | Standard | 🔶 ASSUMED |
| DOD-07 | Documentation updated | API docs, user guides updated if affected by the story | Standard | 🔶 ASSUMED |
| DOD-08 | Performance verified | For stories affecting QA-001: response time < 2s at P95 verified | Project-specific (QA-001) | 🔶 ASSUMED |
| DOD-09 | Security scanned | For stories involving auth or data: no new vulnerabilities | Project-specific (QA-004) | 🔶 ASSUMED |

---

## DoR/DoD Applicability

| Criterion | Regular Stories | NFR Stories | Spike Stories |
|-----------|----------------|-------------|--------------|
| DOR-01 (Story format) | Yes | Yes | Modified: "As a developer, I want to investigate..." |
| DOR-02 (AC defined) | Yes | Yes (with measurable targets) | Yes (decision-focused AC) |
| DOR-03 (Estimated) | Yes | Yes | Yes (time-boxed instead) |
| DOR-04 (Small enough) | Yes | Yes | Yes (time-box <=3 days) |
| DOD-01 (Code complete) | Yes | Yes | No (spike produces a report, not code) |
| DOD-02 (Unit tests) | Yes | Modified (load/perf tests) | No |
| DOD-04 (AC verified) | Yes | Yes | Yes (decision documented) |
| DOD-08 (Performance) | If applicable | Always | No |

---

## Approval

| Role | Name | Date | Status |
|------|------|------|--------|
| Product Owner | [TBD] | | ☐ Pending |
| Scrum Master | [TBD] | | ☐ Pending |
