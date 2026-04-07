# Test Cases Sample Output — TaskFlow

This is a complete sample output for the TaskFlow project. It demonstrates the expected format, level of detail, and coverage patterns. Not all 60 test cases are shown — representative examples are provided for each test type.

---

# Test Cases — TaskFlow

**Version**: draft
**Date**: 2026-04-06
**Test Strategy Reference**: test-strategy-final.md
**Test Plan Reference**: test-plan-final.md
**Status**: Draft

---

## 1. Test Suite Overview

| Suite ID | Suite Name | Source | Type | Test Cases | Priority |
|----------|-----------|--------|------|-----------|----------|
| TS-001 | Git Webhook Integration | US-001 | Functional | TC-001 — TC-005 | Critical |
| TS-002 | Branch-to-Task Mapping | US-003 | Functional | TC-006 — TC-009 | High |
| TS-003 | Sprint Board Display | US-010 | Functional | TC-010 — TC-014 | High |
| TS-004 | Blocker Alert Notifications | US-020 | Functional | TC-015 — TC-018 | High |
| TS-010 | Projects API | /api/v1/projects | API | TC-020 — TC-025 | High |
| TS-011 | Sprints API | /api/v1/sprints | API | TC-026 — TC-030 | High |
| TS-012 | Tasks API | /api/v1/tasks | API | TC-031 — TC-036 | High |
| TS-013 | Webhooks API | /api/v1/webhooks | API | TC-037 — TC-040 | Critical |
| TS-030 | Git-to-Database Pipeline | Git → DB | Integration | TC-041 — TC-044 | Critical |
| TS-031 | WebSocket Event Delivery | Service → WS | Integration | TC-045 — TC-047 | High |
| TS-020 | Performance — Response Time | QA-001 | NFR/Performance | TC-048 — TC-050 | Critical |
| TS-021 | Security — OWASP Top 10 | QA-004 | NFR/Security | TC-051 — TC-054 | Critical |
| TS-022 | Availability — Failover | QA-002 | NFR/Availability | TC-055 — TC-056 | Critical |

**Summary**:
- Total test suites: 13
- Total test cases: 60 (4 not shown in detail — follow same patterns)
- By type: Functional (28), API (21), Integration (7), NFR (10)
- By priority: Critical (12), High (25), Medium (18), Low (5)
- Automation: Automated (55), Manual (5)

---

## 2. Functional Test Cases

### TS-001: Git Webhook Integration (US-001)

#### TC-001: GitHub push webhook creates commit record ✅

| Field | Value |
|-------|-------|
| **ID** | TC-001 |
| **Type** | Functional |
| **Priority** | Critical |
| **Source** | US-001.AC-1 |
| **Automation** | Automated |

**Preconditions**:
1. Project "TaskFlow" exists with ID `proj-001` and GitHub integration enabled
2. Webhook secret `whsec_k8sT3stS3cr3t2026` is configured for the project
3. WebSocket client is subscribed to project channel `project:proj-001`
4. Repository `acme/taskflow` is linked to the project

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | POST to `/webhooks/github` with push event payload (see test data) and `X-Hub-Signature-256` header computed as HMAC-SHA256 of payload using secret `whsec_k8sT3stS3cr3t2026` | Response status is `200 OK` with body `{"status": "processed", "commits_count": 2}` |
| 2 | Query database: `SELECT * FROM commits WHERE repo = 'acme/taskflow' AND sha IN ('a1b2c3d', 'e4f5g6h')` | Two commit records exist with correct author (`alice.johnson`), message, timestamp, and branch (`feature/TF-42-login`) |
| 3 | Check WebSocket messages received on `project:proj-001` channel | Two `commit.created` events received with matching commit SHAs and metadata |

**Test Data**:
| Field | Value | Notes |
|-------|-------|-------|
| Webhook URL | `/webhooks/github` | POST endpoint |
| Event type | `push` | `X-GitHub-Event: push` header |
| Repository | `acme/taskflow` | `payload.repository.full_name` |
| Branch | `refs/heads/feature/TF-42-login` | `payload.ref` |
| Commit 1 SHA | `a1b2c3d4e5f6g7h8i9j0` | First commit in push |
| Commit 1 message | `Add JWT validation middleware` | `payload.commits[0].message` |
| Commit 1 author | `alice.johnson` | `payload.commits[0].author.username` |
| Commit 2 SHA | `e4f5g6h7i8j9k0l1m2n3` | Second commit in push |
| Commit 2 message | `Add login form component` | `payload.commits[1].message` |
| Commit 2 author | `alice.johnson` | `payload.commits[1].author.username` |
| HMAC secret | `whsec_k8sT3stS3cr3t2026` | Configured for project |

**Postconditions**:
1. Two new rows exist in `commits` table
2. WebSocket event log contains the emitted events

**Tags**: functional, happy-path, smoke

---

#### TC-002: GitHub webhook with invalid HMAC signature is rejected ✅

| Field | Value |
|-------|-------|
| **ID** | TC-002 |
| **Type** | Functional |
| **Priority** | Critical |
| **Source** | US-001.AC-1 |
| **Automation** | Automated |

**Preconditions**:
1. Project "TaskFlow" exists with ID `proj-001` and GitHub integration enabled
2. Webhook secret `whsec_k8sT3stS3cr3t2026` is configured for the project

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | POST to `/webhooks/github` with valid push event payload but `X-Hub-Signature-256` header computed using wrong secret `wrong_secret_value` | Response status is `401 Unauthorized` with body `{"error": "INVALID_SIGNATURE", "message": "Webhook signature verification failed"}` |
| 2 | Query database: `SELECT COUNT(*) FROM commits WHERE repo = 'acme/taskflow' AND created_at > NOW() - INTERVAL '10 seconds'` | Count is `0` — no commit records created |
| 3 | Check WebSocket channel `project:proj-001` | No `commit.created` events emitted |

**Test Data**:
| Field | Value | Notes |
|-------|-------|-------|
| Webhook URL | `/webhooks/github` | POST endpoint |
| Valid payload | Same as TC-001 | Reuse push event payload |
| Wrong HMAC secret | `wrong_secret_value` | Does not match configured secret |

**Tags**: functional, negative, security

---

#### TC-003: GitHub webhook with malformed JSON payload returns 400 🔶

| Field | Value |
|-------|-------|
| **ID** | TC-003 |
| **Type** | Functional |
| **Priority** | High |
| **Source** | US-001.AC-1 |
| **Automation** | Automated |

**Assumption**: AC does not explicitly define behavior for malformed payloads. Assumed the system returns 400 Bad Request.

**Preconditions**:
1. Project "TaskFlow" exists with GitHub integration enabled

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | POST to `/webhooks/github` with body `{invalid json content` and valid `X-Hub-Signature-256` header for that exact body | Response status is `400 Bad Request` with body `{"error": "INVALID_PAYLOAD", "message": "Unable to parse webhook payload"}` |
| 2 | Query database for recent commits | No new commit records created |

**Test Data**:
| Field | Value | Notes |
|-------|-------|-------|
| Payload body | `{invalid json content` | Intentionally malformed JSON |

**Tags**: functional, negative, edge-case

---

#### TC-004: Duplicate webhook delivery is handled idempotently ✅

| Field | Value |
|-------|-------|
| **ID** | TC-004 |
| **Type** | Functional |
| **Priority** | High |
| **Source** | US-001.AC-1 |
| **Automation** | Automated |

**Preconditions**:
1. Project "TaskFlow" exists with GitHub integration enabled
2. Commit `a1b2c3d4e5f6g7h8i9j0` already exists in the `commits` table (from a previous delivery)

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | POST to `/webhooks/github` with same push event payload as TC-001 (containing commit `a1b2c3d`) with valid HMAC signature | Response status is `200 OK` with body `{"status": "processed", "commits_count": 0}` (no new commits) |
| 2 | Query `SELECT COUNT(*) FROM commits WHERE sha = 'a1b2c3d4e5f6g7h8i9j0'` | Count is `1` — no duplicate record created |

**Test Data**:
| Field | Value | Notes |
|-------|-------|-------|
| Payload | Same as TC-001 | Exact duplicate delivery |
| Delivery ID | `X-GitHub-Delivery: d1e2f3g4-h5i6-j7k8-l9m0-n1o2p3q4r5s6` | GitHub deduplication header |

**Tags**: functional, edge-case, critical-path

---

#### TC-005: Webhook from unlinked repository is ignored ✅

| Field | Value |
|-------|-------|
| **ID** | TC-005 |
| **Type** | Functional |
| **Priority** | High |
| **Source** | US-001.AC-1 |
| **Automation** | Automated |

**Preconditions**:
1. No project is linked to repository `acme/unknown-repo`

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | POST to `/webhooks/github` with push event from `acme/unknown-repo` with valid HMAC signature | Response status is `200 OK` with body `{"status": "ignored", "reason": "unlinked_repository"}` |
| 2 | Query database for commits from `acme/unknown-repo` | No records found |

**Test Data**:
| Field | Value | Notes |
|-------|-------|-------|
| Repository | `acme/unknown-repo` | Not linked to any project |

**Tags**: functional, negative, edge-case

---

### TS-003: Sprint Board Display (US-010)

#### TC-010: Sprint board loads with tasks grouped by status ✅

| Field | Value |
|-------|-------|
| **ID** | TC-010 |
| **Type** | Functional |
| **Priority** | High |
| **Source** | US-010.AC-1 |
| **Automation** | Automated |

**Preconditions**:
1. User "alice.johnson" is authenticated with valid JWT
2. Project "TaskFlow" exists with active sprint "Sprint 3" (ID: `sprint-003`)
3. Sprint 3 contains 5 tasks:
   - TF-41: "Design login page" — status: `DONE`
   - TF-42: "Implement JWT auth" — status: `IN_PROGRESS`
   - TF-43: "Write auth unit tests" — status: `TODO`
   - TF-44: "Code review auth module" — status: `TODO`
   - TF-45: "Deploy auth service" — status: `BLOCKED`

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | GET `/api/v1/sprints/sprint-003/board` with `Authorization: Bearer {alice_jwt}` | Response status is `200 OK` |
| 2 | Parse response body — verify `columns` array | Four columns present: `TODO`, `IN_PROGRESS`, `BLOCKED`, `DONE` |
| 3 | Verify `TODO` column tasks | Contains TF-43 and TF-44 (2 tasks) |
| 4 | Verify `IN_PROGRESS` column tasks | Contains TF-42 (1 task) |
| 5 | Verify `BLOCKED` column tasks | Contains TF-45 (1 task) |
| 6 | Verify `DONE` column tasks | Contains TF-41 (1 task) |
| 7 | Verify each task object contains required fields | Each task has: `id`, `title`, `assignee`, `priority`, `story_points`, `status` |

**Test Data**:
| Field | Value | Notes |
|-------|-------|-------|
| Sprint ID | `sprint-003` | Active sprint |
| Total tasks | 5 | Distributed across all 4 status columns |
| User JWT | Alice's valid token | Has project access |

**Tags**: functional, happy-path, smoke

---

#### TC-011: Sprint board with no tasks shows empty columns ✅

| Field | Value |
|-------|-------|
| **ID** | TC-011 |
| **Type** | Functional |
| **Priority** | Medium |
| **Source** | US-010.AC-1 |
| **Automation** | Automated |

**Preconditions**:
1. User "alice.johnson" is authenticated
2. Sprint "Sprint 4" (ID: `sprint-004`) exists with zero tasks (planning phase)

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | GET `/api/v1/sprints/sprint-004/board` with valid auth | Response status is `200 OK` |
| 2 | Parse response body | Four columns present, each with empty `tasks: []` array |
| 3 | Verify summary | `total_tasks: 0`, `completion_percentage: 0` |

**Tags**: functional, edge-case, boundary

---

## 3. API Test Cases

### TS-010: Projects API (/api/v1/projects)

#### TC-020: Create project via API — happy path ✅

| Field | Value |
|-------|-------|
| **ID** | TC-020 |
| **Type** | API |
| **Priority** | High |
| **Source** | POST /api/v1/projects |
| **Automation** | Automated |

**Preconditions**:
1. User "alice.johnson" is authenticated with admin role
2. No project with name "ProjectAlpha" exists

**Request**:
```
POST /api/v1/projects
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...alice_admin_token
Content-Type: application/json

{
  "name": "ProjectAlpha",
  "description": "Next-generation project management tool with AI features",
  "repository_url": "https://github.com/acme/project-alpha",
  "methodology": "scrum",
  "sprint_duration_days": 14
}
```

**Expected Response**:
```
HTTP 201 Created
Content-Type: application/json
Location: /api/v1/projects/proj-new-uuid

{
  "id": "proj-new-uuid",
  "name": "ProjectAlpha",
  "description": "Next-generation project management tool with AI features",
  "repository_url": "https://github.com/acme/project-alpha",
  "methodology": "scrum",
  "sprint_duration_days": 14,
  "status": "active",
  "created_by": "user-alice-001",
  "created_at": "2026-04-06T10:30:00Z",
  "updated_at": "2026-04-06T10:30:00Z"
}
```

**Assertions**:
- Status code is 201
- Response body `id` is a valid UUID
- Response body `name` equals `"ProjectAlpha"`
- Response body `status` equals `"active"`
- Response body `created_by` equals Alice's user ID
- Response header `Location` matches `/api/v1/projects/{id}`
- Database `projects` table has new row with matching values
- `created_at` and `updated_at` are within 5 seconds of now

**Tags**: api, happy-path, smoke

---

#### TC-021: Create project without auth token returns 401 ✅

| Field | Value |
|-------|-------|
| **ID** | TC-021 |
| **Type** | API |
| **Priority** | Critical |
| **Source** | POST /api/v1/projects |
| **Automation** | Automated |

**Preconditions**:
1. No authentication token provided

**Request**:
```
POST /api/v1/projects
Content-Type: application/json

{
  "name": "ProjectAlpha",
  "description": "Should not be created"
}
```

**Expected Response**:
```
HTTP 401 Unauthorized
Content-Type: application/json

{
  "error": "UNAUTHORIZED",
  "message": "Authentication token is required"
}
```

**Assertions**:
- Status code is 401
- Response body contains `error` field with value `"UNAUTHORIZED"`
- No project record created in database

**Tags**: api, negative, security

---

#### TC-022: Create project with missing required fields returns 400 ✅

| Field | Value |
|-------|-------|
| **ID** | TC-022 |
| **Type** | API |
| **Priority** | High |
| **Source** | POST /api/v1/projects |
| **Automation** | Automated |

**Preconditions**:
1. User "alice.johnson" is authenticated with admin role

**Request**:
```
POST /api/v1/projects
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...alice_admin_token
Content-Type: application/json

{
  "description": "Missing required name field"
}
```

**Expected Response**:
```
HTTP 400 Bad Request
Content-Type: application/json

{
  "error": "VALIDATION_ERROR",
  "message": "Validation failed",
  "details": [
    {
      "field": "name",
      "message": "Name is required",
      "code": "REQUIRED"
    }
  ]
}
```

**Assertions**:
- Status code is 400
- Response `details` array identifies the missing field `name`
- No project record created in database

**Tags**: api, negative, edge-case

---

#### TC-023: Create project with duplicate name returns 409 ✅

| Field | Value |
|-------|-------|
| **ID** | TC-023 |
| **Type** | API |
| **Priority** | High |
| **Source** | POST /api/v1/projects |
| **Automation** | Automated |

**Preconditions**:
1. User "alice.johnson" is authenticated with admin role
2. Project "TaskFlow" already exists in the database

**Request**:
```
POST /api/v1/projects
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...alice_admin_token
Content-Type: application/json

{
  "name": "TaskFlow",
  "description": "Attempting to create duplicate project"
}
```

**Expected Response**:
```
HTTP 409 Conflict
Content-Type: application/json

{
  "error": "CONFLICT",
  "message": "A project with name 'TaskFlow' already exists"
}
```

**Assertions**:
- Status code is 409
- Response identifies the conflicting field
- Original project record unchanged in database
- No new project record created

**Tags**: api, negative, edge-case

---

#### TC-024: Get project by ID — not found returns 404 ✅

| Field | Value |
|-------|-------|
| **ID** | TC-024 |
| **Type** | API |
| **Priority** | High |
| **Source** | GET /api/v1/projects/{id} |
| **Automation** | Automated |

**Preconditions**:
1. User "alice.johnson" is authenticated
2. No project with ID `00000000-0000-0000-0000-000000000000` exists

**Request**:
```
GET /api/v1/projects/00000000-0000-0000-0000-000000000000
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...alice_admin_token
```

**Expected Response**:
```
HTTP 404 Not Found
Content-Type: application/json

{
  "error": "NOT_FOUND",
  "message": "Project not found"
}
```

**Assertions**:
- Status code is 404
- Response body contains meaningful error message

**Tags**: api, negative, edge-case

---

#### TC-025: List projects with pagination ✅

| Field | Value |
|-------|-------|
| **ID** | TC-025 |
| **Type** | API |
| **Priority** | Medium |
| **Source** | GET /api/v1/projects |
| **Automation** | Automated |

**Preconditions**:
1. User "alice.johnson" is authenticated
2. Database contains 15 projects accessible to Alice

**Request**:
```
GET /api/v1/projects?page=2&per_page=10
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...alice_admin_token
```

**Expected Response**:
```
HTTP 200 OK
Content-Type: application/json

{
  "data": [ ... 5 project objects ... ],
  "pagination": {
    "page": 2,
    "per_page": 10,
    "total": 15,
    "total_pages": 2,
    "has_more": false
  }
}
```

**Assertions**:
- Status code is 200
- `data` array contains exactly 5 projects (15 total, page 2 of 10)
- `pagination.has_more` is `false`
- `pagination.total` is 15

**Tags**: api, happy-path, edge-case

---

## 4. Integration Test Cases

### TS-030: Git-to-Database Pipeline Integration Tests

#### TC-041: Webhook → commit storage → task matching → status update (end-to-end) ✅

| Field | Value |
|-------|-------|
| **ID** | TC-041 |
| **Type** | Integration |
| **Priority** | Critical |
| **Source** | Git Service → Database → Task Service → WebSocket |
| **Automation** | Automated |

**Preconditions**:
1. Project "TaskFlow" exists with GitHub integration
2. Task TF-42 ("Implement JWT auth") exists with status `IN_PROGRESS`
3. Task TF-42 is associated with branch pattern `feature/TF-42-*`
4. WebSocket client is subscribed to `project:proj-001`

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | POST webhook push event with branch `refs/heads/feature/TF-42-login` containing 1 commit with message `fix: resolve JWT validation bug [TF-42]` | Webhook returns `200 OK` |
| 2 | Wait 2 seconds for async processing | — |
| 3 | Query `commits` table for SHA from push event | Commit record exists with `task_id` pointing to TF-42 |
| 4 | Query `tasks` table for TF-42 | Task `last_commit_sha` updated, `commit_count` incremented by 1 |
| 5 | Check WebSocket messages on `project:proj-001` | Received `commit.created` event AND `task.updated` event |
| 6 | Verify event ordering | `commit.created` event timestamp precedes `task.updated` event timestamp |

**Test Data**:
| Field | Value | Component | Notes |
|-------|-------|-----------|-------|
| Branch | `feature/TF-42-login` | Webhook Service | Matches task TF-42 pattern |
| Commit SHA | `f1a2b3c4d5e6f7g8h9i0` | Database | Stored in commits table |
| Commit message | `fix: resolve JWT validation bug [TF-42]` | Task Service | Contains task ID reference |
| Task ID | `TF-42` | Task Service | Matched by branch + message |

**Tags**: integration, happy-path, critical-path

---

#### TC-042: Webhook with branch not matching any task — commit stored but no task update ✅

| Field | Value |
|-------|-------|
| **ID** | TC-042 |
| **Type** | Integration |
| **Priority** | High |
| **Source** | Git Service → Database |
| **Automation** | Automated |

**Preconditions**:
1. Project "TaskFlow" exists with GitHub integration
2. No task is associated with branch `feature/misc-cleanup`

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | POST webhook push event with branch `refs/heads/feature/misc-cleanup` | Webhook returns `200 OK` |
| 2 | Query `commits` table | Commit record exists with `task_id = NULL` |
| 3 | Query `tasks` table for any recently updated tasks | No task records modified |

**Tags**: integration, edge-case

---

### TS-031: WebSocket Event Delivery Integration Tests

#### TC-045: WebSocket subscriber receives real-time task update event ✅

| Field | Value |
|-------|-------|
| **ID** | TC-045 |
| **Type** | Integration |
| **Priority** | High |
| **Source** | Task Service → WebSocket Gateway |
| **Automation** | Automated |

**Preconditions**:
1. User "alice.johnson" is authenticated via WebSocket with valid JWT
2. Alice is subscribed to channel `project:proj-001`
3. Task TF-43 exists in project proj-001

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | Via REST API, PATCH `/api/v1/tasks/TF-43` with `{"status": "IN_PROGRESS"}` using Bob's JWT (different user) | REST API returns `200 OK` |
| 2 | Within 3 seconds, check Alice's WebSocket connection | Message received: `{"type": "task.updated", "data": {"task_id": "TF-43", "field": "status", "old_value": "TODO", "new_value": "IN_PROGRESS", "updated_by": "bob.martinez"}}` |
| 3 | Verify message structure | Contains `type`, `data`, `timestamp`, `project_id` fields |

**Tags**: integration, happy-path, critical-path

---

## 5. NFR Test Cases

### TS-020: Performance Tests (QA-001)

#### TC-048: Dashboard load under 50 concurrent users ✅

| Field | Value |
|-------|-------|
| **ID** | TC-048 |
| **Type** | Performance |
| **Priority** | Critical |
| **Source** | QA-001 |
| **Tool** | k6 |

**Scenario**:
- Simulate 50 concurrent users accessing the sprint board dashboard. Each virtual user authenticates, loads the sprint board, and navigates between sprints — mimicking a typical standup meeting where the whole team views the board.

**Test Configuration**:
| Parameter | Value |
|-----------|-------|
| Virtual users | 50 |
| Ramp-up period | 5 minutes (0 → 50 VUs) |
| Sustained duration | 10 minutes at 50 VUs |
| Ramp-down | 2 minutes (50 → 0 VUs) |
| Target endpoint(s) | `GET /api/v1/sprints/{id}/board`, `GET /api/v1/projects` |
| Think time | 3-5 seconds (randomized) between requests |

**Test Data Volume**:
| Entity | Count | Notes |
|--------|-------|-------|
| Projects | 10 | Pre-seeded |
| Sprints | 30 | 3 per project |
| Tasks | 300 | 10 per sprint, distributed across statuses |
| Users | 50 | Concurrent test users with valid JWTs |

**Acceptance Criteria**:
| Metric | Target | Measurement Method |
|--------|--------|--------------------|
| p95 response time | < 2 seconds | k6 `http_req_duration` p(95) |
| p99 response time | < 5 seconds | k6 `http_req_duration` p(99) |
| Error rate | < 1% | k6 `http_req_failed` rate |
| Throughput | > 100 RPS | k6 `http_reqs` rate |

**Tags**: performance, nfr, load-test

---

#### TC-049: API response time under sustained load ✅

| Field | Value |
|-------|-------|
| **ID** | TC-049 |
| **Type** | Performance |
| **Priority** | Critical |
| **Source** | QA-001 |
| **Tool** | k6 |

**Scenario**:
- Sustained load test simulating normal business hours traffic across all API endpoints for 30 minutes.

**Test Configuration**:
| Parameter | Value |
|-----------|-------|
| Virtual users | 25 |
| Duration | 30 minutes sustained |
| Target endpoint(s) | All CRUD endpoints (weighted by expected traffic) |
| Think time | 1-3 seconds |

**Acceptance Criteria**:
| Metric | Target | Measurement Method |
|--------|--------|--------------------|
| p95 response time | < 500ms (GET), < 1s (POST/PUT) | k6 per-endpoint breakdown |
| Error rate | < 0.5% | k6 `http_req_failed` |
| Memory usage | No increase > 20% from baseline | Prometheus / Grafana |

**Tags**: performance, nfr, load-test, regression

---

#### TC-050: Webhook processing throughput under burst ✅

| Field | Value |
|-------|-------|
| **ID** | TC-050 |
| **Type** | Performance |
| **Priority** | High |
| **Source** | QA-001 |
| **Tool** | k6 |

**Scenario**:
- Simulate a burst of 100 webhook deliveries in 10 seconds (e.g., large merge or force push).

**Test Configuration**:
| Parameter | Value |
|-----------|-------|
| Requests | 100 webhooks in 10 seconds |
| Target endpoint | `POST /webhooks/github` |
| Payload size | ~2KB per webhook |

**Acceptance Criteria**:
| Metric | Target | Measurement Method |
|--------|--------|--------------------|
| All webhooks processed | 100% (no drops) | Count commits in DB vs webhooks sent |
| p95 processing time | < 5 seconds end-to-end | Time from POST to commit visible in DB |
| No duplicate commits | 0 duplicates | `SELECT sha, COUNT(*) FROM commits GROUP BY sha HAVING COUNT(*) > 1` |

**Tags**: performance, nfr, load-test, burst

---

### TS-021: Security Tests (QA-004)

#### TC-051: SQL injection in task search parameter ✅

| Field | Value |
|-------|-------|
| **ID** | TC-051 |
| **Type** | Security |
| **Priority** | Critical |
| **Source** | QA-004 |
| **OWASP** | A03:2021 — Injection |

**Preconditions**:
1. User "alice.johnson" is authenticated
2. Tasks exist in the database

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | GET `/api/v1/tasks?search=' OR 1=1--` with valid auth token | Response status is `400 Bad Request` with `{"error": "VALIDATION_ERROR", "message": "Invalid search query"}` |
| 2 | Verify response body does NOT contain all tasks | Response does not return unfiltered task list |
| 3 | Check application logs for SQL injection attempt | Log entry exists with severity `WARN` and category `security.injection_attempt` |

**Test Data**:
| Field | Value | Notes |
|-------|-------|-------|
| Search parameter | `' OR 1=1--` | Classic SQL injection payload |
| Alternative payloads | `'; DROP TABLE tasks; --`, `' UNION SELECT * FROM users --` | Test multiple vectors |

**Tags**: security, nfr, negative

---

#### TC-052: XSS payload in task title is sanitized ✅

| Field | Value |
|-------|-------|
| **ID** | TC-052 |
| **Type** | Security |
| **Priority** | Critical |
| **Source** | QA-004 |
| **OWASP** | A03:2021 — Injection (XSS) |

**Preconditions**:
1. User "alice.johnson" is authenticated with admin role

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | POST `/api/v1/tasks` with `{"title": "<script>alert('XSS')</script>Task Title", "sprint_id": "sprint-003"}` | Response status is `201 Created` (task created) |
| 2 | GET the created task by ID | Task `title` field is sanitized: `"Task Title"` (script tag stripped) or HTML-encoded: `"&lt;script&gt;alert('XSS')&lt;/script&gt;Task Title"` |
| 3 | Verify no script execution context | Raw HTML response does not contain unescaped `<script>` tags |

**Tags**: security, nfr, negative

---

#### TC-053: JWT token with modified role claim is rejected ✅

| Field | Value |
|-------|-------|
| **ID** | TC-053 |
| **Type** | Security |
| **Priority** | Critical |
| **Source** | QA-004 |
| **OWASP** | A07:2021 — Identification and Authentication Failures |

**Preconditions**:
1. User "charlie.member" has a valid JWT with role `member`

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | Decode Charlie's JWT, change `role` from `member` to `admin` in the payload, re-encode without valid signature | Tampered JWT string created |
| 2 | GET `/api/v1/admin/users` with tampered JWT in Authorization header | Response status is `401 Unauthorized` with `{"error": "INVALID_TOKEN", "message": "Token signature verification failed"}` |
| 3 | Verify no admin data is returned | Response body does not contain user list |

**Test Data**:
| Field | Value | Notes |
|-------|-------|-------|
| Original role | `member` | Charlie's actual role |
| Tampered role | `admin` | Escalation attempt |
| Signing algorithm | `RS256` | Server's expected algorithm |

**Tags**: security, nfr, negative

---

#### TC-054: Rate limiting on login endpoint ✅

| Field | Value |
|-------|-------|
| **ID** | TC-054 |
| **Type** | Security |
| **Priority** | High |
| **Source** | QA-004 |
| **OWASP** | A07:2021 — Identification and Authentication Failures |

**Preconditions**:
1. Rate limit configured: 10 requests per minute per IP for `/auth/login`

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | Send 10 POST requests to `/auth/login` with invalid credentials within 30 seconds | First 10 requests return `401 Unauthorized` (normal auth failure) |
| 2 | Send 11th POST request to `/auth/login` | Response status is `429 Too Many Requests` with `Retry-After` header |
| 3 | Wait for `Retry-After` duration, send another request | Normal `401 Unauthorized` response (rate limit reset) |

**Tags**: security, nfr, negative, edge-case

---

### TS-022: Availability Tests (QA-002)

#### TC-055: Application serves requests when Redis cache is unavailable ✅

| Field | Value |
|-------|-------|
| **ID** | TC-055 |
| **Type** | Availability |
| **Priority** | Critical |
| **Source** | QA-002 |
| **Automation** | Automated (requires infrastructure control) |

**Preconditions**:
1. Application is running and healthy
2. Redis cache is available and populated with cached data

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | Stop Redis container / disconnect Redis | Application logs warning: `"Cache unavailable, falling back to database"` |
| 2 | GET `/api/v1/sprints/sprint-003/board` with valid auth | Response status is `200 OK` with correct data (served from database) |
| 3 | Verify response time | Response time may increase but stays under 5 seconds (degraded but functional) |
| 4 | Restart Redis | Application logs info: `"Cache connection restored"` |
| 5 | GET same endpoint again | Response served from cache (faster response time) |

**Tags**: availability, nfr, happy-path

---

#### TC-056: Application handles database connection pool exhaustion gracefully ✅

| Field | Value |
|-------|-------|
| **ID** | TC-056 |
| **Type** | Availability |
| **Priority** | Critical |
| **Source** | QA-002 |
| **Automation** | Automated (requires infrastructure control) |

**Preconditions**:
1. Application running with database connection pool max size of 20
2. Application is under normal load

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | Open 20 long-running database transactions (exhaust connection pool) | Connections consumed |
| 2 | Send API request `GET /api/v1/projects` | Response status is `503 Service Unavailable` with `{"error": "SERVICE_UNAVAILABLE", "message": "Please try again later"}` (NOT a timeout or connection error) |
| 3 | Release 5 long-running transactions | 5 connections returned to pool |
| 4 | Send same API request | Response status is `200 OK` (service recovered) |

**Tags**: availability, nfr, negative, edge-case

---

## 6. Test Data Specifications

### Test Data Set: TaskFlow Test World

**Purpose**: Provides a complete, realistic dataset for functional, API, and integration test suites.

| Entity | Count | Key Fields | Relationships | Creation Method |
|--------|-------|-----------|---------------|----------------|
| Users | 3 | `alice.johnson` (admin), `bob.martinez` (manager), `charlie.member` (member) | Each assigned to projects | Database seed |
| Projects | 2 | `TaskFlow` (active, proj-001), `ArchivedApp` (archived, proj-002) | Owned by alice | Database seed |
| Sprints | 3 | Sprint 2 (completed), Sprint 3 (active), Sprint 4 (planning) — all in TaskFlow | Belong to proj-001 | Database seed |
| Tasks | 10 | TF-41 through TF-50, distributed: 2 TODO, 3 IN_PROGRESS, 1 BLOCKED, 2 IN_REVIEW, 2 DONE | Belong to Sprint 3, assigned to users | Database seed |
| Commits | 5 | `a1b2c3d` through `e5f6g7h`, linked to tasks TF-42, TF-43, TF-45 | Belong to proj-001, linked to tasks by branch | Database seed |
| Alert Rules | 2 | Blocker alert (proj-001), SLA breach alert (proj-001) | Configured by alice | Database seed |
| Notifications | 5 | 3 unread (alice), 1 read (bob), 1 unread (charlie) | Linked to tasks and alerts | Database seed |

**Setup Script**: `test/fixtures/seed-taskflow-world.sql` (or equivalent factory/fixture file)

**Teardown**: Transaction rollback after each test suite. For integration tests, truncate and re-seed between suites.

### Test Data Set: Performance Test World

**Purpose**: Large-volume dataset for performance and load testing.

| Entity | Count | Key Fields | Relationships | Creation Method |
|--------|-------|-----------|---------------|----------------|
| Users | 50 | Generated faker profiles | Distributed across projects | Factory script |
| Projects | 10 | Generated project names | 5 users per project | Factory script |
| Sprints | 30 | 3 per project (plan/active/done) | Belong to projects | Factory script |
| Tasks | 300 | 10 per sprint, all statuses | Assigned to users, linked to sprints | Factory script |
| Commits | 600 | 2 per task | Linked to tasks | Factory script |

---

## 7. Coverage Matrix

### AC Coverage

| Story | Priority | AC | Test Cases | Coverage |
|-------|----------|-----|-----------|----------|
| US-001 | Must Have | AC-1 | TC-001, TC-002, TC-003, TC-004, TC-005 | ✅ Full |
| US-001 | Must Have | AC-2 | TC-006, TC-007 | ✅ Full |
| US-003 | Must Have | AC-1 | TC-006, TC-008 | ✅ Full |
| US-003 | Must Have | AC-2 | TC-009 | 🔶 Happy path only |
| US-010 | Must Have | AC-1 | TC-010, TC-011 | ✅ Full |
| US-010 | Must Have | AC-2 | TC-012, TC-013 | ✅ Full |
| US-010 | Must Have | AC-3 | TC-014 | 🔶 Happy path only |
| US-020 | Should Have | AC-1 | TC-015, TC-016 | ✅ Full |
| US-020 | Should Have | AC-2 | TC-017, TC-018 | ✅ Full |

### API Endpoint Coverage

| Endpoint | Happy | Auth | 404 | Validation | Other | Coverage |
|----------|-------|------|-----|-----------|-------|----------|
| POST /api/v1/projects | TC-020 | TC-021 | — | TC-022 | TC-023 (409) | ✅ Full |
| GET /api/v1/projects | TC-025 | TC-021 | — | — | — | 🔶 Partial |
| GET /api/v1/projects/:id | — | — | TC-024 | — | — | 🔶 Partial |
| POST /api/v1/sprints | TC-026 | TC-027 | — | TC-028 | — | ✅ Full |
| GET /api/v1/sprints/:id/board | TC-010 | TC-029 | TC-030 | — | — | ✅ Full |
| POST /api/v1/tasks | TC-031 | TC-032 | — | TC-033 | — | ✅ Full |
| PATCH /api/v1/tasks/:id | TC-034 | TC-035 | TC-036 | — | — | ✅ Full |
| POST /webhooks/github | TC-001 | TC-002 | — | TC-003 | TC-004 (dup) | ✅ Full |

### Risk Coverage

| Risk ID | Risk Description | Test Cases | Coverage |
|---------|-----------------|-----------|----------|
| RISK-001 | GitHub API rate limiting disrupts webhook processing | TC-050 | ✅ Full |
| RISK-002 | Data loss during database failover | TC-055, TC-056 | ✅ Full |
| RISK-003 | Unauthorized data access via JWT manipulation | TC-053, TC-021 | ✅ Full |
| RISK-004 | SQL injection in user-facing search fields | TC-051 | ✅ Full |
| RISK-005 | WebSocket connection storms during standup | TC-048 | 🔶 Indirect |

### Coverage Summary

| Metric | Total | Covered | Coverage % | Target |
|--------|-------|---------|-----------|--------|
| Must Have ACs | 30 | 30 | 100% | ≥95% ✅ |
| Should Have ACs | 12 | 10 | 83% | ≥80% ✅ |
| Could Have ACs | 8 | 5 | 63% | — |
| API Endpoints | 12 | 11 | 92% | ≥90% ✅ |
| Quality Attributes | 6 | 6 | 100% | 100% ✅ |
| High/Critical Risks | 5 | 5 | 100% | 100% ✅ |

---

## 8. Q&A Log

| # | Question | Context | Answer | Impact |
|---|----------|---------|--------|--------|
| 1 | What data volume should performance tests use? Strategy mentions "production-like" but production scale is unknown. | TC-048, TC-049 | PENDING — assumed 300 tasks / 50 users based on typical SaaS startup. Need product team input for production projections. | If production scale is larger, VU count and data volume in performance tests need adjustment. |
| 2 | Should E2E browser tests cover multiple browsers, or is Chrome-only sufficient for MVP? | TS-003 (Sprint board) | PENDING — assumed Chrome-only for MVP, cross-browser as post-MVP. | If cross-browser required, add browser matrix to functional test cases and increase manual test count. |
| 3 | How much overlap should exist between API test cases and contract tests mentioned in strategy? | TS-010 through TS-013 | PENDING — current API test cases focus on behavior. Contract tests (if implemented) would verify schema. Minimal overlap expected. | If contract tests are confirmed, some API validation test cases (TC-022, TC-028, TC-033) may be redundant. |

---

## 9. Readiness Assessment

### Confidence Distribution

| Level | Count | % |
|-------|-------|---|
| ✅ CONFIRMED | 27 | 45% |
| 🔶 ASSUMED | 28 | 47% |
| ❓ UNCLEAR | 5 | 8% |

### Coverage Assessment

| Criterion | Status | Notes |
|-----------|--------|-------|
| Must Have AC coverage ≥95% | ✅ Met | 100% (30/30 ACs covered) |
| API endpoint coverage ≥90% | ✅ Met | 92% (11/12 endpoints covered) |
| All QA attributes tested | ✅ Met | 6/6 quality attributes have NFR test cases |
| UNCLEAR items ≤10% | ✅ Met | 8% UNCLEAR (5/60 test cases) |

### Verdict: Partially Ready

Coverage targets are met, but 47% of test cases are marked ASSUMED — meaning nearly half rely on interpretation of ambiguous acceptance criteria. The 3 pending Q&A items (data volume for performance tests, browser matrix, contract test overlap) could change test case scope. Recommend resolving Q&A items and converting ASSUMED to CONFIRMED via stakeholder review before finalizing.

### Recommended Actions

1. **Resolve Q&A items** — get product team input on performance data volume and browser requirements
2. **Review ASSUMED test cases** — schedule 30-minute walkthrough with product owner to confirm or correct assumptions
3. **Add missing GET /projects/:id happy path** — currently only 404 test exists, need happy-path TC
4. **Finalize test data seed script** — create `seed-taskflow-world.sql` before implementation begins
5. **Run `/test-cases-refine`** after Q&A resolution to update confidence markers

---

## 10. Approval

| Role | Name | Decision | Date |
|------|------|----------|------|
| QA Lead | | Pending | |
| Technical Lead | | Pending | |
| Product Owner | | Pending | |
