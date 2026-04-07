# Story Splitting Patterns

9 techniques for splitting large user stories into smaller, independent stories.

---

## When to Split

| Story Points | Action |
|-------------|--------|
| 1-5 | No split needed |
| 8 | Consider splitting — flag with `[SPLIT RECOMMENDED]` |
| 13 | Must split — too large for one sprint |
| >13 | Epic-sized — should be an epic, not a story |

---

## Pattern 1: Split by Workflow Step

Break a multi-step workflow into individual steps.

**Before (13 points):**
```
As a Dev Dana, I want to connect my GitHub repo and have commits auto-update tickets.
```

**After:**
```
US-A: As a Dev Dana, I want to register my GitHub repo's webhook endpoint. (3 pts)
US-B: As a Dev Dana, I want TaskFlow to parse push events from my repo. (3 pts)
US-C: As a Dev Dana, I want commits to auto-update my ticket status. (5 pts)
```

---

## Pattern 2: Split by Data Variation

If a story handles multiple data types or formats, split by type.

**Before (13 points):**
```
As a Dev Dana, I want TaskFlow to process all Git events (push, PR, branch, tag).
```

**After:**
```
US-A: ...process push events (commits). (3 pts)
US-B: ...process pull request events (open, merge, close). (5 pts)
US-C: ...process branch events (create, delete). (2 pts)
US-D: ...process tag events (release tags). (2 pts)
```

---

## Pattern 3: Split by Interface

If a feature works across multiple interfaces, split by interface.

**Before (8 points):**
```
As a SM Sam, I want to receive alerts via email, Slack, and push notification.
```

**After:**
```
US-A: ...receive alerts via email. (3 pts)
US-B: ...receive alerts via Slack. (3 pts)
US-C: ...receive alerts via push notification. (3 pts)
```

---

## Pattern 4: Split by Operation (CRUD)

Split a feature that involves create, read, update, delete into separate stories.

**Before (8 points):**
```
As a SM Sam, I want to manage alert rules (create, view, edit, delete).
```

**After:**
```
US-A: ...create a new alert rule. (3 pts)
US-B: ...view my existing alert rules. (2 pts)
US-C: ...edit an existing alert rule. (2 pts)
US-D: ...delete an alert rule. (1 pt)
```

---

## Pattern 5: Split by Persona

If different personas interact with the same feature differently, split by persona.

**Before (8 points):**
```
As a user, I want to view the sprint dashboard.
```

**After:**
```
US-A: As a Dev Dana, I want to see my assigned tickets on the sprint board. (3 pts)
US-B: As a SM Sam, I want to see all tickets grouped by status. (3 pts)
US-C: As a TL Tara, I want to see team workload distribution. (3 pts)
```

---

## Pattern 6: Split by Business Rule

If a story contains multiple business rules or conditions, split by rule.

**Before (8 points):**
```
As a Dev Dana, I want my ticket to auto-update based on Git events.
```

**After:**
```
US-A: ...ticket moves to "In Progress" when I create a branch. (2 pts)
US-B: ...ticket moves to "In Review" when I open a PR. (3 pts)
US-C: ...ticket moves to "Done" when my PR is merged. (2 pts)
US-D: ...ticket moves back to "In Progress" if PR is closed without merge. (2 pts)
```

---

## Pattern 7: Split by Happy Path / Sad Path

Separate the normal flow from error handling and edge cases.

**Before (8 points):**
```
As a Dev Dana, I want to register my repo's webhook including validation and error handling.
```

**After:**
```
US-A: ...register my repo's webhook (happy path). (3 pts)
US-B: ...see an error message if webhook registration fails. (2 pts)
US-C: ...retry failed webhook deliveries automatically. (3 pts)
```

---

## Pattern 8: Split by Performance Level

Separate the functional story from the performance optimization.

**Before (8 points):**
```
As a SM Sam, I want the dashboard to load instantly with real-time updates.
```

**After:**
```
US-A: ...view the sprint dashboard (loads with page refresh). (3 pts)
US-B: ...dashboard loads in < 2 seconds. (3 pts) [NFR]
US-C: ...dashboard updates in real-time without refresh. (5 pts)
```

---

## Pattern 9: Split by Spike / Implementation

Separate research from implementation when uncertainty is high.

**Before (13 points):**
```
As a SM Sam, I want ML-based sprint completion predictions.
```

**After:**
```
US-A: [SPIKE] Investigate ML models for sprint prediction. (3 pts, time-boxed 2 days)
US-B: ...see historical velocity trends. (3 pts)
US-C: ...see sprint completion probability based on current velocity. (5 pts)
US-D: ...see confidence intervals on the prediction. (3 pts)
```

---

## Splitting Decision Tree

```
Is the story > 8 points?
  ├─ YES → Must split. Which pattern fits best?
  │   ├─ Multiple steps?         → Pattern 1 (Workflow Step)
  │   ├─ Multiple data types?    → Pattern 2 (Data Variation)
  │   ├─ Multiple interfaces?    → Pattern 3 (Interface)
  │   ├─ CRUD operations?        → Pattern 4 (Operation)
  │   ├─ Multiple personas?      → Pattern 5 (Persona)
  │   ├─ Multiple rules?         → Pattern 6 (Business Rule)
  │   ├─ Complex error handling?  → Pattern 7 (Happy/Sad Path)
  │   ├─ Performance concerns?   → Pattern 8 (Performance Level)
  │   └─ High uncertainty?       → Pattern 9 (Spike/Implementation)
  │
  └─ NO → Don't split (unless dependencies require it)
```

---

## Anti-Patterns: Bad Splits

| Anti-Pattern | Problem | Better Approach |
|-------------|---------|-----------------|
| Split by layer (frontend/backend) | Neither delivers value alone | Split by user-visible behavior |
| Split by technical task | "Write API", "Write UI" | Split by feature or workflow |
| Arbitrary halves | "Part 1" and "Part 2" | Split by meaningful boundary |
| One story per AC | Creates too many tiny stories | Group related AC in one story |
