# Acceptance Criteria Template

Standard format for writing acceptance criteria using Gherkin syntax.

---

## Basic Format

```gherkin
Scenario: {Descriptive name — what is being tested}
  Given {precondition — the system state before the action}
  When {action — what the user does}
  Then {expected result — the observable outcome}
```

### Additional Keywords

```gherkin
Scenario: {name}
  Given {precondition 1}
  And {precondition 2}
  When {action}
  And {additional action}
  Then {result 1}
  And {result 2}
  But {negative result — something that should NOT happen}
```

---

## Scenario Naming

Good scenario names describe the situation being tested:

| Bad (vague) | Good (specific) |
|-------------|-----------------|
| "Test login" | "User logs in with valid credentials" |
| "Error case" | "User enters incorrect password three times" |
| "Happy path" | "Developer pushes code and ticket auto-updates to In Review" |

---

## Data-Driven Scenarios

Use `Scenario Outline` with `Examples` table for testing multiple data variations:

```gherkin
Scenario Outline: Git event updates ticket status
  Given a ticket "TASK-123" exists with status "<initial_status>"
  When a "<git_event>" event is received for branch "feature/TASK-123"
  Then the ticket status changes to "<new_status>"

  Examples:
    | git_event      | initial_status | new_status |
    | branch_created | To Do          | In Progress |
    | pull_request   | In Progress    | In Review   |
    | pr_merged      | In Review      | Done        |
```

---

## Background Steps

Use `Background` for preconditions shared across all scenarios in a story:

```gherkin
Background:
  Given the user is logged in as "SM Sam"
  And the current sprint "Sprint 5" is active

Scenario: View sprint board
  When the user navigates to the sprint dashboard
  Then the board shows all tickets for "Sprint 5"

Scenario: Filter by assignee
  When the user filters the board by assignee "Dev Dana"
  Then only tickets assigned to "Dev Dana" are shown
```

---

## Minimum Requirements

Every story MUST have:
1. At least **1 happy path** scenario — the normal, successful flow
2. At least **1 edge case or error** scenario — what happens when something goes wrong

### Common Edge Cases to Consider

| Category | Examples |
|----------|---------|
| Empty state | No data exists yet, first-time use |
| Boundary values | Max length, zero items, exactly at limit |
| Permission errors | Unauthorized access, expired session |
| Invalid input | Wrong format, missing required fields |
| Concurrent access | Two users editing same item |
| Network/external failure | API timeout, webhook delivery failure |
| State conflicts | Item already deleted, status already changed |

---

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| "The system should work correctly" | Not testable | Specify what "correctly" means |
| Testing implementation | "Database stores JSON" | Test observable behavior: "User sees saved data" |
| Too many scenarios | 20+ AC on one story | Story is too large — split it |
| No error scenarios | Only happy path | Add at least 1 failure/edge case |
| Vague Then clause | "Then it works" | Specify exactly what the user sees/gets |
