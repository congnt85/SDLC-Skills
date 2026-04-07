# Gherkin Acceptance Criteria Guide

How to write clear, testable acceptance criteria using Gherkin syntax.

---

## Basic Syntax

```gherkin
Scenario: {Descriptive name of what is being tested}
  Given {precondition — the state of the system before the action}
  When {action — what the user or system does}
  Then {expected result — the observable outcome}
```

### Keywords

| Keyword | Purpose | Example |
|---------|---------|---------|
| `Given` | Set up preconditions | `Given the user is logged in as "SM Sam"` |
| `When` | Describe the action | `When the user clicks "View Sprint"` |
| `Then` | Assert the outcome | `Then the sprint board displays all tickets` |
| `And` | Add to any section | `And the tickets are grouped by status` |
| `But` | Negative assertion | `But completed tickets are grayed out` |

---

## Scenario Naming

Scenario names should describe the situation, not the test.

| Bad | Good |
|-----|------|
| "Test 1" | "Developer pushes code and ticket auto-updates" |
| "Happy path" | "SM views sprint board with active sprint" |
| "Error case" | "User enters invalid webhook URL" |
| "Check login" | "User logs in with valid GitHub OAuth credentials" |

---

## Writing Good Preconditions (Given)

Preconditions establish the state before the action:

```gherkin
# Good — specific, observable state
Given a ticket "TASK-123" exists with status "To Do"
And the ticket is assigned to "Dev Dana"
And the current sprint "Sprint 5" contains "TASK-123"

# Bad — vague, unverifiable
Given the system is set up
Given everything is ready
```

### Tips:
- Include specific data values (ticket IDs, user names, status values)
- Only include preconditions that affect the outcome
- Use `And` for multiple preconditions

---

## Writing Good Actions (When)

Actions describe what triggers the behavior:

```gherkin
# Good — specific user or system action
When a GitHub push event is received for branch "feature/TASK-123"
When the user clicks the "Filter" button and selects assignee "Dev Dana"

# Bad — passive, unclear who acts
When the ticket is updated
When filtering happens
```

### Tips:
- One primary action per `When` (use `And` sparingly)
- Specify the actor (user, system, external service)
- Include specific input data

---

## Writing Good Expected Results (Then)

Results describe what should be observable:

```gherkin
# Good — specific, verifiable outcome
Then ticket "TASK-123" status changes to "In Progress"
And a notification is sent to "SM Sam" with message "TASK-123 started"
But the ticket assignee does not change

# Bad — vague, subjective
Then it works correctly
Then the user is satisfied
Then the system performs well
```

### Tips:
- Results must be verifiable by a test (human or automated)
- Include specific expected values
- Use `But` for things that should NOT happen (negative assertions)

---

## Data-Driven Scenarios (Scenario Outline)

Use `Scenario Outline` with `Examples` to test multiple data variations without duplicating scenarios:

```gherkin
Scenario Outline: Git event updates ticket status
  Given a ticket "<ticket_id>" exists with status "<initial_status>"
  When a "<git_event>" event is received for branch "feature/<ticket_id>"
  Then the ticket status changes to "<new_status>"
  And the status change timestamp is recorded

  Examples:
    | ticket_id | git_event       | initial_status | new_status  |
    | TASK-123  | branch_created  | To Do          | In Progress |
    | TASK-123  | pull_request    | In Progress    | In Review   |
    | TASK-123  | pr_merged       | In Review      | Done        |
    | TASK-456  | branch_created  | To Do          | In Progress |
```

### When to Use Scenario Outline:
- Same workflow, different data inputs
- Testing multiple valid/invalid values
- Boundary value testing

---

## Shared Preconditions (Background)

Use `Background` for preconditions shared across all scenarios in a story:

```gherkin
Background:
  Given the user is logged in as "SM Sam"
  And the current sprint "Sprint 5" is active
  And the sprint contains 15 tickets

Scenario: View sprint board
  When the user navigates to the sprint dashboard
  Then the board shows 15 tickets grouped by status

Scenario: Filter by assignee
  When the user selects assignee filter "Dev Dana"
  Then only tickets assigned to "Dev Dana" are shown
  And the ticket count updates to show filtered count
```

### Rules:
- Background runs before each scenario
- Keep it short (2-3 lines max)
- Only include preconditions used by ALL scenarios in the story

---

## Minimum Requirements Per Story

Every story MUST have at least 2 scenarios:

1. **Happy path** — the normal, successful flow
2. **Edge case or error** — what happens when something goes wrong

### Common Edge Cases to Cover

| Category | Scenario Ideas |
|----------|---------------|
| Empty state | No tickets in sprint, first-time user |
| Boundary | Max tickets per sprint, longest branch name |
| Permission | Unauthorized user tries to access |
| Invalid input | Malformed webhook payload, missing fields |
| Concurrent | Two events for same ticket simultaneously |
| Failure | External API timeout, webhook delivery failure |
| State conflict | Ticket already deleted, sprint already closed |

---

## Anti-Patterns

| Anti-Pattern | Example | Fix |
|-------------|---------|-----|
| Testing implementation | "Then the database has a new row" | Test observable behavior: "Then the ticket appears on the board" |
| Too many steps | 15 Given/When/Then lines | Split into separate scenarios |
| Vague results | "Then it works" | Specify exactly what the user sees |
| Missing error cases | Only happy path | Add at least one failure scenario |
| UI-specific | "Then a green toast appears" | Describe outcome: "Then a success confirmation is shown" |
| Duplicate data | Same scenario copied 5 times | Use Scenario Outline with Examples |
