# User Stories: TaskFlow

> **Project**: TaskFlow
> **Version**: 1.0
> **Date Created**: 2026-04-06
> **Last Updated**: 2026-04-06
> **Status**: Draft
> **Author**: AI-Generated
> **Source**: Derived from `epics-final.md` and `scope-final.md`

---

## 1. Story Summary

| ID | Epic | Feature | Title | Persona | Priority | Points | Tags | Confidence |
|----|------|---------|-------|---------|----------|--------|------|------------|
| US-001 | EPIC-001 | SCP-001.1 | Configure webhook endpoint | Dev Dana | Must Have | 3 | — | ✅ CONFIRMED |
| US-002 | EPIC-001 | SCP-001.2 | Parse GitHub push events | Dev Dana | Must Have | 3 | — | ✅ CONFIRMED |
| US-003 | EPIC-001 | SCP-001.3 | Map branch names to tickets | Dev Dana | Must Have | 5 | — | 🔶 ASSUMED |
| US-004 | EPIC-001 | SCP-001.4 | Auto-update ticket status from Git events | Dev Dana | Must Have | 5 | — | 🔶 ASSUMED |
| US-005 | EPIC-001 | SCP-001.5 | Manually override ticket status mapping | Dev Dana | Should Have | 3 | — | 🔶 ASSUMED |
| US-006 | EPIC-001 | SCP-001.2 | Parse GitLab push events | Dev Dana | Must Have | 3 | — | ✅ CONFIRMED |
| US-010 | EPIC-002 | SCP-002.1 | View sprint board | SM Sam | Must Have | 5 | — | ✅ CONFIRMED |
| US-011 | EPIC-002 | SCP-002.4 | Switch between sprints | SM Sam | Must Have | 2 | — | ✅ CONFIRMED |
| US-012 | EPIC-002 | SCP-002.3 | Filter board by assignee and status | SM Sam | Should Have | 3 | — | 🔶 ASSUMED |
| US-013 | EPIC-002 | SCP-002.2 | Real-time board updates | SM Sam | Must Have | 5 | — | 🔶 ASSUMED |
| US-020 | EPIC-004 | SCP-004 | Receive blocker alert for stale tickets | SM Sam | Should Have | 3 | — | ✅ CONFIRMED |
| US-021 | EPIC-004 | SCP-004 | Configure alert rules | SM Sam | Should Have | 5 | — | 🔶 ASSUMED |
| US-025 | EPIC-006 | QA-001 | Dashboard performance target | All | Must Have | 3 | [NFR] | 🔶 ASSUMED |
| US-026 | EPIC-001 | RISK-001 | Validate webhook payload data | Dev | Must Have | 3 | [SPIKE] | 🔶 ASSUMED |

*Note: This is a representative subset. A complete TaskFlow story set would contain ~27 stories across all 6 epics.*

---

## 2. Story Details

### EPIC-001: Real-Time Git Sync

#### US-001: Configure webhook endpoint

| Field | Value |
|-------|-------|
| **ID** | US-001 |
| **Epic** | EPIC-001: Real-Time Git Sync |
| **Feature** | SCP-001.1: Webhook receiver |
| **Story** | As a Dev Dana, I want to register my GitHub repository's webhook endpoint in TaskFlow, so that TaskFlow can receive push and PR events automatically. |
| **Priority** | Must Have |
| **Story Points** | 3 |
| **Dependencies** | None |
| **Tags** | — |
| **Confidence** | ✅ CONFIRMED — Source: scope SCP-001.1 confirmed, charter SCP-001 confirmed |

##### Acceptance Criteria

###### US-001.AC-1: Successful webhook registration

```gherkin
Scenario: Developer registers GitHub webhook
  Given Dev Dana is logged into TaskFlow
  And Dev Dana has a GitHub repository "my-org/my-repo"
  When Dev Dana enters the repository URL and clicks "Connect"
  Then TaskFlow generates a unique webhook URL
  And displays setup instructions for GitHub webhook configuration
  And the repository appears in Dev Dana's connected repos list
```

###### US-001.AC-2: Duplicate repository prevention

```gherkin
Scenario: Developer tries to register an already-connected repo
  Given the repository "my-org/my-repo" is already connected to TaskFlow
  When Dev Dana tries to connect "my-org/my-repo" again
  Then TaskFlow shows a message "This repository is already connected"
  And does not create a duplicate connection
```

##### INVEST Check

| Criterion | Pass | Notes |
|-----------|------|-------|
| Independent | Yes | Can be built and tested standalone |
| Negotiable | Yes | Describes outcome, not UI specifics |
| Valuable | Yes | Enables the entire Git sync pipeline |
| Estimable | Yes | Standard webhook setup, well-understood |
| Small | Yes | 3 points, fits in one sprint |
| Testable | Yes | Specific Gherkin scenarios with concrete data |

---

#### US-003: Map branch names to tickets

| Field | Value |
|-------|-------|
| **ID** | US-003 |
| **Epic** | EPIC-001: Real-Time Git Sync |
| **Feature** | SCP-001.3: Ticket mapper |
| **Story** | As a Dev Dana, I want TaskFlow to match my branch name to the corresponding ticket, so that my commits automatically update the right ticket's status. |
| **Priority** | Must Have |
| **Story Points** | 5 |
| **Dependencies** | US-002 (Parse push events) |
| **Tags** | — |
| **Confidence** | 🔶 ASSUMED — Reasoning: depends on branch naming conventions which vary across teams (charter ASM-002). Q&A ref: Q-001 |

##### Acceptance Criteria

###### US-003.AC-1: Standard branch naming convention match

```gherkin
Scenario Outline: Branch name maps to ticket
  Given a ticket "<ticket_id>" exists in the current sprint
  When a push event is received for branch "<branch_name>"
  Then the event is linked to ticket "<ticket_id>"

  Examples:
    | branch_name           | ticket_id |
    | feature/TASK-123      | TASK-123  |
    | bugfix/TASK-456       | TASK-456  |
    | feature/TASK-789-desc | TASK-789  |
```

###### US-003.AC-2: Unrecognized branch name

```gherkin
Scenario: Branch name does not contain a ticket ID
  Given a push event is received for branch "main"
  When TaskFlow attempts to map the branch to a ticket
  Then no ticket mapping is created
  And the event is logged as "unmapped" for review
```

###### US-003.AC-3: Ticket not found

```gherkin
Scenario: Branch contains ticket ID but ticket does not exist
  Given a push event is received for branch "feature/TASK-999"
  And no ticket "TASK-999" exists in any active sprint
  When TaskFlow attempts to map the branch
  Then no ticket mapping is created
  And a warning is logged "Ticket TASK-999 not found"
```

##### INVEST Check

| Criterion | Pass | Notes |
|-----------|------|-------|
| Independent | No | Depends on US-002 (event parser provides branch data) |
| Negotiable | Yes | Mapping logic is flexible (regex, config, etc.) |
| Valuable | Yes | Core feature — without mapping, auto-sync doesn't work |
| Estimable | Yes | 5 points — moderate complexity with pattern matching |
| Small | Yes | 5 points fits in one sprint |
| Testable | Yes | Specific examples with concrete data |

---

### EPIC-002: Sprint Visibility Dashboard

#### US-010: View sprint board

| Field | Value |
|-------|-------|
| **ID** | US-010 |
| **Epic** | EPIC-002: Sprint Visibility Dashboard |
| **Feature** | SCP-002.1: Board view |
| **Story** | As a SM Sam, I want to see a Kanban-style board showing all sprint tickets grouped by status, so that I can assess sprint health at a glance without asking anyone for updates. |
| **Priority** | Must Have |
| **Story Points** | 5 |
| **Dependencies** | US-004 (tickets need status data from Git events) |
| **Tags** | — |
| **Confidence** | ✅ CONFIRMED — Source: scope SCP-002.1 confirmed, charter Obj 1 core feature |

##### Acceptance Criteria

###### US-010.AC-1: Board displays tickets by status

```gherkin
Scenario: SM views sprint board
  Given SM Sam is logged into TaskFlow
  And the current sprint "Sprint 5" contains 15 tickets
  When SM Sam navigates to the sprint dashboard
  Then the board shows 15 tickets arranged in columns
  And columns are labeled "To Do", "In Progress", "In Review", "Done"
  And each ticket shows title, assignee, and story points
```

###### US-010.AC-2: Empty sprint

```gherkin
Scenario: SM views board for sprint with no tickets
  Given SM Sam navigates to sprint "Sprint 6"
  And "Sprint 6" has no tickets assigned
  When the board loads
  Then empty columns are shown with a message "No tickets in this sprint"
  And an "Add Tickets" action is available
```

##### INVEST Check

| Criterion | Pass | Notes |
|-----------|------|-------|
| Independent | Yes | Can display tickets even with manually-set status |
| Negotiable | Yes | Board layout is flexible (Kanban columns, list, etc.) |
| Valuable | Yes | Primary use case for SM Sam — daily sprint visibility |
| Estimable | Yes | 5 points — standard board UI with data display |
| Small | Yes | 5 points fits in one sprint |
| Testable | Yes | Specific ticket counts and column labels |

---

### EPIC-004: Intelligent Alerts & Notifications

#### US-020: Receive blocker alert for stale tickets

| Field | Value |
|-------|-------|
| **ID** | US-020 |
| **Epic** | EPIC-004: Intelligent Alerts & Notifications |
| **Feature** | SCP-004: Alerts & Notifications |
| **Story** | As a SM Sam, I want to receive an alert when a ticket has been "In Progress" for more than 3 days without a Git event, so that I can check if the developer is blocked. |
| **Priority** | Should Have |
| **Story Points** | 3 |
| **Dependencies** | US-004 (needs ticket status tracking data) |
| **Tags** | — |
| **Confidence** | ✅ CONFIRMED — Source: scope SCP-004 confirmed, persona SM Sam scenario 2 |

##### Acceptance Criteria

###### US-020.AC-1: Stale ticket triggers alert

```gherkin
Scenario: Ticket stale for 3 days
  Given ticket "TASK-123" has been "In Progress" for 3 days
  And no Git events have been received for "TASK-123" in 3 days
  When the daily alert check runs
  Then SM Sam receives a notification "TASK-123 may be blocked (no activity for 3 days)"
  And the notification includes the assignee name and last activity date
```

###### US-020.AC-2: Active ticket does not trigger alert

```gherkin
Scenario: Ticket with recent activity
  Given ticket "TASK-456" has been "In Progress" for 5 days
  But a commit was pushed to branch "feature/TASK-456" yesterday
  When the daily alert check runs
  Then no stale ticket alert is sent for "TASK-456"
```

##### INVEST Check

| Criterion | Pass | Notes |
|-----------|------|-------|
| Independent | Yes | Alert logic is independent of dashboard display |
| Negotiable | Yes | Threshold (3 days) and channel are configurable |
| Valuable | Yes | Prevents blockers from going unnoticed |
| Estimable | Yes | 3 points — scheduled job + notification |
| Small | Yes | 3 points fits easily |
| Testable | Yes | Clear trigger conditions and expected notifications |

---

## 3. Persona Coverage Matrix

| Persona | Type | Must Have | Should Have | Could Have | Total Stories | Total Points |
|---------|------|----------|-------------|------------|--------------|-------------|
| Dev Dana | Primary | US-001, US-002, US-003, US-004, US-006 | US-005 | — | 6 | 22 |
| SM Sam | Primary | US-010, US-011, US-013 | US-012, US-020, US-021 | — | 6 | 23 |
| TL Tara | Secondary | — | — | — | 0 | 0 |
| All | — | US-025 | — | — | 1 | 3 |

**Gap**: TL Tara (Secondary persona) has 0 stories in this subset. Full story set would include CI/CD stories (EPIC-003) targeting TL Tara. 🔶 ASSUMED — Q&A ref: Q-002

---

## 4. NFR Stories

#### US-025: [NFR] Dashboard performance target

| Field | Value |
|-------|-------|
| **ID** | US-025 |
| **Epic** | EPIC-006: Platform Foundation [CROSS-CUTTING] |
| **Feature** | QA-001: Performance |
| **Story** | As any user, I want the sprint dashboard to load in less than 2 seconds, so that I can check sprint status without waiting. |
| **Priority** | Must Have |
| **Story Points** | 3 |
| **Tags** | [NFR] |
| **Confidence** | 🔶 ASSUMED — Reasoning: scope QA-001 specifies < 2s but P95 threshold and concurrent user count need confirmation. Q&A ref: Q-003 |

##### Acceptance Criteria

###### US-025.AC-1: Dashboard load time under target

```gherkin
Scenario: Dashboard loads within performance target
  Given 500 concurrent users are accessing TaskFlow
  When a user navigates to the sprint dashboard
  Then the dashboard fully renders in less than 2 seconds at P95
```

###### US-025.AC-2: Performance under heavy sprint

```gherkin
Scenario: Dashboard loads with large sprint
  Given the current sprint contains 100 tickets
  And 50 concurrent users are viewing the board
  When the dashboard loads
  Then all 100 tickets are displayed in less than 3 seconds at P95
```

---

## 5. Spike Stories

#### US-026: [SPIKE] Validate webhook payload data

| Field | Value |
|-------|-------|
| **ID** | US-026 |
| **Epic** | EPIC-001: Real-Time Git Sync |
| **Source** | RISK-001: Webhook payloads may lack sufficient data (Score: 15) |
| **Story** | As a developer, I want to validate that GitHub and GitLab webhook payloads contain sufficient data to determine ticket status transitions, so that we can confirm the core auto-sync feature is feasible before building it. |
| **Priority** | Must Have |
| **Story Points** | 3 |
| **Tags** | [SPIKE] |
| **Time-box** | 2 days |
| **Confidence** | 🔶 ASSUMED — Reasoning: derived from RISK-001. Spike validates core assumption. |

##### Acceptance Criteria

###### US-026.AC-1: GitHub payload validation

```gherkin
Scenario: Validate GitHub webhook payload
  Given a test GitHub repository with webhook configured
  When push, PR, and branch events are triggered
  Then the received payloads contain: branch name, commit SHA, author, timestamp
  And a documented decision is produced: proceed / pivot / abandon
```

###### US-026.AC-2: GitLab payload validation

```gherkin
Scenario: Validate GitLab webhook payload
  Given a test GitLab repository with webhook configured
  When push, MR, and branch events are triggered
  Then the received payloads contain equivalent data fields
  And differences between GitHub and GitLab payloads are documented
```

---

## Q&A Log

### Pending

#### Q-001 (related: US-003, US-004)
- **Impact**: HIGH
- **Question**: What specific branch naming conventions should the ticket mapper support? Should it be configurable per team, or is one pattern sufficient?
- **Context**: US-003 acceptance criteria use "feature/TASK-123" format, but teams may use other patterns. This was flagged in charter (ASM-002) and scope (Q-001).
- **Answer**:
- **Status**: Pending

#### Q-002 (related: Persona Coverage Matrix)
- **Impact**: MEDIUM
- **Question**: Should TL Tara have dedicated stories in EPIC-001 (Git Sync) or EPIC-002 (Dashboard), or are the CI/CD stories (EPIC-003) sufficient for this persona?
- **Context**: The persona coverage matrix shows 0 stories for TL Tara in the current subset. CI/CD stories would address this but are Should Have priority.
- **Answer**:
- **Status**: Pending

#### Q-003 (related: US-025)
- **Impact**: MEDIUM
- **Question**: What is the expected concurrent user count for the performance target? Scope says 500 developers initially — should performance testing target 500 or a higher number?
- **Context**: The P95 latency target of < 2s may need different thresholds for different load levels. Affects both the NFR story and testing strategy.
- **Answer**:
- **Status**: Pending

---

## Readiness Assessment

| Metric | Value |
|--------|-------|
| Total items | 14 |
| ✅ CONFIRMED | 6 (43%) |
| 🔶 ASSUMED | 8 (57%) |
| ❓ UNCLEAR | 0 (0%) |
| Q&A Pending | 3 (HIGH: 1, MEDIUM: 2, LOW: 0) |
| Q&A Answered | 0 |

**Verdict**: ⚠️ Partially Ready

**Reasoning**: Core Git sync and dashboard stories are well-defined with specific Gherkin AC. However, this is a representative subset (~14 of ~27 expected stories). The HIGH-impact Q&A about branch naming conventions (Q-001) must be resolved before implementation as it affects the core ticket mapper (US-003, US-004). Spike story US-026 should be completed in Sprint 0 to validate the foundational assumption.

---

## Approval

| Role | Name | Date | Status |
|------|------|------|--------|
| Product Owner | [TBD] | | ☐ Pending |
| Scrum Master | [TBD] | | ☐ Pending |
