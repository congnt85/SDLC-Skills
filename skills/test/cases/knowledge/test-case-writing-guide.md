# Test Case Writing Guide

This guide provides techniques for writing specific, executable test cases that trace to requirements and use concrete test data.

---

## 1. From Gherkin to Test Cases

Every acceptance criterion in user stories follows Gherkin format (Given/When/Then). Map each element directly to test case structure:

| Gherkin Element | Test Case Element |
|----------------|-------------------|
| **Given** | Preconditions + test data setup |
| **When** | Test steps (actions the tester performs) |
| **Then** | Expected results (verifiable assertions) |
| **And** (after Given) | Additional preconditions |
| **And** (after Then) | Additional assertions |
| **Scenario Outline + Examples** | Parameterized test cases (one TC per row, or one TC with data table) |

### Example Mapping

**AC (Gherkin)**:
> Given a valid GitHub webhook payload with push event,
> When the webhook endpoint receives the payload with valid HMAC signature,
> Then a commit record is created in the database
> And a WebSocket event is emitted to project subscribers.

**Test Case**:
- **Preconditions**: Project "TaskFlow" exists with GitHub integration enabled. Webhook secret `whsec_abc123` is configured. WebSocket subscriber is connected to project channel.
- **Step 1**: POST push event JSON payload to `/webhooks/github` with `X-Hub-Signature-256` header computed using HMAC-SHA256 with secret `whsec_abc123`.
- **Step 2**: Verify response status is `200 OK`.
- **Step 3**: Query `commits` table for `repo=taskflow AND sha=abc123def` — verify record exists with correct author, message, and timestamp.
- **Step 4**: Verify WebSocket message received on project channel with type `commit.created` and matching commit SHA.

### Scenario Outline Handling

When an AC uses Scenario Outline with an Examples table, create either:
- **One test case per example row** — when each row tests a meaningfully different scenario
- **One test case with a data table** — when rows are simple input variations of the same scenario

Prefer one-per-row when failure diagnosis matters (e.g., different error codes). Prefer data table when rows are interchangeable (e.g., different valid inputs).

---

## 2. Test Case Granularity

### One Test Case = One Scenario

Each test case should verify exactly one thing. This enables:
- Clear failure diagnosis (you know exactly what broke)
- Independent execution (no test ordering dependencies)
- Accurate coverage tracking (each TC maps to one source)

### Rules

- **Do NOT** combine happy path and error path in one TC
- **Do NOT** test multiple ACs in one TC (if TC fails, which AC is broken?)
- **Exception**: Data-driven tests where the same steps verify multiple inputs — use a test data table within a single TC

### Naming Convention

TC title should be a **readable sentence** describing the scenario:

| Good | Bad |
|------|-----|
| "Sprint board loads within 2 seconds for 50 concurrent users" | "TC-045 performance test" |
| "GitHub webhook with invalid HMAC signature returns 401" | "TC-002 negative webhook" |
| "Creating a project with duplicate name returns 409 Conflict" | "TC-056 duplicate project" |
| "Expired JWT token is rejected with 401 Unauthorized" | "TC-100 auth test" |

Format: `{Subject} {action} {expected outcome}` or `{Action} {condition} {result}`.

---

## 3. Negative Test Case Patterns

For every happy-path test case, consider these negative patterns:

### Input Validation

| Pattern | Example |
|---------|---------|
| Empty/null value | `name: ""` or `name: null` |
| Exceeds max length | `name: "a".repeat(256)` when max is 255 |
| Wrong data type | `priority: "high"` when expecting integer |
| Special characters | `name: "<script>alert(1)</script>"` |
| SQL injection | `search: "'; DROP TABLE tasks; --"` |
| XSS payload | `description: "<img onerror=alert(1) src=x>"` |

### Authorization

| Pattern | Example |
|---------|---------|
| No auth token | Omit `Authorization` header entirely |
| Expired token | JWT with `exp` in the past |
| Wrong role | Member token accessing admin-only endpoint |
| Other user's resource | User A accessing User B's project |
| Tampered token | Modified JWT payload with invalid signature |

### State

| Pattern | Example |
|---------|---------|
| Resource not found | GET `/projects/nonexistent-uuid` |
| Already exists (conflict) | POST duplicate project name |
| Deleted resource | Access soft-deleted sprint |
| Concurrent modification | Two users update same task simultaneously |
| Invalid state transition | Move task from "Done" back to "To Do" when not allowed |

### Boundary

| Pattern | Example |
|---------|---------|
| Minimum value | `priority: 0` or `priority: 1` |
| Maximum value | `priority: 2147483647` |
| Off-by-one | Page 0 vs page 1 (zero-indexed vs one-indexed) |
| Empty collection | Sprint with zero tasks |
| Max collection size | Project with 10,000 tasks (pagination boundary) |

### Infrastructure (for NFR tests)

| Pattern | Example |
|---------|---------|
| Timeout | Database query takes >30s |
| Connection refused | Redis cache unavailable |
| Disk full | Log volume exhausted |
| Out of memory | Processing 1M webhook events |

---

## 4. API Test Case Patterns

For each endpoint type, apply these standard test patterns:

### GET List Endpoints

| Scenario | Expected |
|----------|----------|
| Empty results | 200 with empty array `[]` |
| Single result | 200 with one-element array |
| Pagination — first page | 200 with `page=1`, `hasMore=true` |
| Pagination — last page | 200 with `hasMore=false` |
| Filtering | 200 with only matching results |
| Sorting | 200 with results in specified order |
| Unauthorized | 401 with error body |

### GET by ID Endpoints

| Scenario | Expected |
|----------|----------|
| Resource exists | 200 with full resource body |
| Resource not found | 404 with error message |
| Unauthorized | 401 |
| Wrong project (cross-tenant) | 403 or 404 |

### POST Create Endpoints

| Scenario | Expected |
|----------|----------|
| Valid payload | 201 with created resource |
| Missing required fields | 400 with field-level errors |
| Invalid field types | 400 with type error |
| Duplicate (conflict) | 409 with conflict message |
| Unauthorized | 401 |

### PUT/PATCH Update Endpoints

| Scenario | Expected |
|----------|----------|
| Valid full update | 200 with updated resource |
| Partial update (PATCH) | 200 with only changed fields |
| Resource not found | 404 |
| Stale data (optimistic locking) | 409 with version conflict |
| Unauthorized | 401 |

### DELETE Endpoints

| Scenario | Expected |
|----------|----------|
| Resource exists | 204 No Content |
| Resource not found | 404 |
| Cascade effects | Related entities handled (soft delete, orphan cleanup) |
| Unauthorized | 401 |

### Webhook Endpoints

| Scenario | Expected |
|----------|----------|
| Valid signature | 200, event processed |
| Invalid signature | 401, event rejected |
| Malformed payload | 400, event rejected |
| Duplicate delivery | 200, idempotent (no duplicate records) |

---

## 5. Test Data Design

### Principles

1. **Use realistic but synthetic data** — not `test123` or `foo`. Use faker-style values:
   - Names: "Alice Johnson", "Bob Martinez" (not "User1")
   - Emails: "alice.johnson@example.com" (not "test@test.com")
   - Project names: "TaskFlow", "ProjectAlpha" (not "TestProject")

2. **Define relationships** — test data forms a connected graph:
   ```
   User → Project → Sprint → Task → Commit
                              ↓
                        Notification → User
   ```

3. **Specify data for both paths** — positive test data AND negative test data:
   - Valid project: `{ name: "TaskFlow", description: "Project management tool" }`
   - Invalid project: `{ name: "", description: null }` (triggers validation)

4. **Consider data volume** for performance tests:
   - Small: 10 records (unit/integration tests)
   - Medium: 1,000 records (functional tests)
   - Large: 100,000+ records (performance/load tests)

5. **Never use production PII** — all data must be synthetic.

### Test World Pattern

Define a complete "test world" setup that creates all related entities needed for a test suite:

```
Test World: "TaskFlow Standard"
├── Users: 3 (admin, manager, member)
├── Projects: 2 (active, archived)
├── Sprints: 3 per active project (planning, active, completed)
├── Tasks: 5 per sprint (one per status column)
├── Commits: 2 per task (linked via branch name)
├── Notifications: 3 unread per user
└── Alert Rules: 1 per project (blocker alert)
```

Each test case references which part of the test world it needs. Tests that modify data should either use transactions (rollback after test) or create their own isolated data.

---

## 6. Coverage Matrix Technique

Build a traceability matrix to ensure complete coverage:

### Matrix Structure

- **Rows**: Requirements (AC-xxx, QA-xxx, RISK-xxx, API endpoints)
- **Columns**: Test case IDs
- **Marks**: ✅ direct coverage, 🔶 indirect coverage, ❌ gap (no coverage)

### Coverage Calculations

| Metric | Formula | Target |
|--------|---------|--------|
| Must Have AC coverage | ACs with ≥1 TC / total Must Have ACs | ≥95% |
| API endpoint coverage | Endpoints with ≥3 TCs (happy+auth+404) / total endpoints | ≥90% |
| Risk coverage | Risks with ≥1 TC / total Critical+High risks | 100% |
| QA attribute coverage | QA-xxx with ≥1 TC / total QA attributes | 100% |

### Identifying Gaps

After building the matrix:
1. Flag any Must Have AC with zero test cases — **must fix**
2. Flag any API endpoint with fewer than 3 test cases — **should fix**
3. Flag any Critical/High risk with zero test cases — **must fix**
4. Flag any QA attribute with zero test cases — **must fix**
5. Present gaps to user for decision (add TCs or accept risk)

---

## 7. Test Case Prioritization

Assign priority to every test case based on what it covers:

### Priority Levels

| Priority | Criteria | Execution |
|----------|----------|-----------|
| **Critical** | Must Have story happy paths, security tests, data integrity, core auth | Every build, CI gate |
| **High** | Core workflow happy paths, error handling for critical paths, API happy paths | Every build |
| **Medium** | Should Have stories, edge cases for core workflows, API negative tests | Every release |
| **Low** | Could Have stories, cosmetic validation, rare edge cases | Periodic / manual |

### Priority Assignment Rules

1. **Security test cases** → always Critical (regardless of story priority)
2. **Data integrity test cases** → always Critical
3. **Must Have story happy paths** → Critical
4. **Must Have story negative paths** → High
5. **Should Have story happy paths** → High
6. **Should Have story negative paths** → Medium
7. **Could Have story tests** → Medium or Low
8. **Performance test cases** → match QA attribute priority (usually Critical or High)
9. **Exploratory / edge cases** → Low

### Smoke Test Subset

Tag critical-path test cases with `smoke` tag. The smoke suite should:
- Cover the core user journey end-to-end
- Run in under 5 minutes
- Be the first suite executed after deployment
- Contain 10-15 test cases maximum
