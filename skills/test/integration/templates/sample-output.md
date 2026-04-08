# Test Integration Sample Output — TaskFlow

This is a complete sample output for the TaskFlow project. It demonstrates the expected format, level of detail, and coverage patterns for integration and NFR test cases.

---

# Integration & NFR Test Cases — TaskFlow

**Version**: draft
**Date**: 2026-04-06
**Test Cases Reference**: test-cases-draft.md
**Architecture Reference**: architecture-final.md
**Status**: Draft

---

## 1. Test Suite Overview

| Suite ID | Suite Name | Source | Type | Test Cases | Priority |
|----------|-----------|--------|------|-----------|----------|
| TS-INT-001 | Git-to-Database Pipeline | Git Service -> Database -> Task Service | Integration | TC-001 — TC-004 | Critical |
| TS-INT-002 | WebSocket Event Delivery | Task Service -> WebSocket Gateway | Integration | TC-005 — TC-007 | High |
| TS-NFR-001 | Performance — Response Time | QA-001 | NFR/Performance | TC-008 — TC-010 | Critical |
| TS-NFR-002 | Security — OWASP Top 10 | QA-004 | NFR/Security | TC-011 — TC-014 | Critical |
| TS-NFR-003 | Availability — Failover | QA-002 | NFR/Availability | TC-015 — TC-016 | Critical |

**Summary**:
- Total test suites: 5
- Total test cases: 16
- By type: Integration (7), Performance (3), Security (4), Availability (2)
- By priority: Critical (10), High (4), Medium (2), Low (0)

---

## 2. Integration Test Cases

### TS-INT-001: Git-to-Database Pipeline Integration Tests

#### TC-001: Webhook -> commit storage -> task matching -> status update (end-to-end) ✅

| Field | Value |
|-------|-------|
| **ID** | TC-001 |
| **Type** | Integration |
| **Priority** | Critical |
| **Source** | Git Service -> Database -> Task Service -> WebSocket |
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

#### TC-002: Webhook with branch not matching any task — commit stored but no task update ✅

| Field | Value |
|-------|-------|
| **ID** | TC-002 |
| **Type** | Integration |
| **Priority** | High |
| **Source** | Git Service -> Database |
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

### TS-INT-002: WebSocket Event Delivery Integration Tests

#### TC-005: WebSocket subscriber receives real-time task update event ✅

| Field | Value |
|-------|-------|
| **ID** | TC-005 |
| **Type** | Integration |
| **Priority** | High |
| **Source** | Task Service -> WebSocket Gateway |
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

## 3. NFR Test Cases

### TS-NFR-001: Performance Tests (QA-001)

#### TC-008: Dashboard load under 50 concurrent users ✅

| Field | Value |
|-------|-------|
| **ID** | TC-008 |
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
| Ramp-up period | 5 minutes (0 -> 50 VUs) |
| Sustained duration | 10 minutes at 50 VUs |
| Ramp-down | 2 minutes (50 -> 0 VUs) |
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

#### TC-009: API response time under sustained load ✅

| Field | Value |
|-------|-------|
| **ID** | TC-009 |
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

#### TC-010: Webhook processing throughput under burst ✅

| Field | Value |
|-------|-------|
| **ID** | TC-010 |
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

### TS-NFR-002: Security Tests (QA-004)

#### TC-011: SQL injection in task search parameter ✅

| Field | Value |
|-------|-------|
| **ID** | TC-011 |
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

#### TC-012: XSS payload in task title is sanitized ✅

| Field | Value |
|-------|-------|
| **ID** | TC-012 |
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

#### TC-013: JWT token with modified role claim is rejected ✅

| Field | Value |
|-------|-------|
| **ID** | TC-013 |
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

#### TC-014: Rate limiting on login endpoint ✅

| Field | Value |
|-------|-------|
| **ID** | TC-014 |
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

### TS-NFR-003: Availability Tests (QA-002)

#### TC-015: Application serves requests when Redis cache is unavailable ✅

| Field | Value |
|-------|-------|
| **ID** | TC-015 |
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

#### TC-016: Application handles database connection pool exhaustion gracefully ✅

| Field | Value |
|-------|-------|
| **ID** | TC-016 |
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

## 4. Coverage Matrix

### AC Coverage (Combined: test-cases + test-integration)

| Story | Priority | AC | Functional TCs (test-cases) | Integration/NFR TCs (this doc) | Coverage |
|-------|----------|-----|----------------------------|-------------------------------|----------|
| US-001 | Must Have | AC-1 | TC-001, TC-002, TC-003, TC-004, TC-005 | TC-001 (end-to-end pipeline) | ✅ Full |
| US-001 | Must Have | AC-2 | TC-006, TC-007 | — | ✅ Full |
| US-003 | Must Have | AC-1 | TC-006, TC-008 | TC-002 (branch mismatch) | ✅ Full |
| US-003 | Must Have | AC-2 | TC-009 | — | 🔶 Happy path only |
| US-010 | Must Have | AC-1 | TC-010, TC-011 | TC-005 (WS event) | ✅ Full |
| US-010 | Must Have | AC-2 | TC-012, TC-013 | — | ✅ Full |
| US-010 | Must Have | AC-3 | TC-014 | — | 🔶 Happy path only |
| US-020 | Should Have | AC-1 | TC-015, TC-016 | — | ✅ Full |
| US-020 | Should Have | AC-2 | TC-017, TC-018 | — | ✅ Full |

### API Endpoint Coverage (Combined)

| Endpoint | Happy | Auth | 404 | Validation | Integration | Coverage |
|----------|-------|------|-----|-----------|-------------|----------|
| POST /api/v1/projects | TC-020 | TC-021 | — | TC-022 | — | ✅ Full |
| GET /api/v1/projects | TC-025 | TC-021 | — | — | — | 🔶 Partial |
| GET /api/v1/projects/:id | — | — | TC-024 | — | — | 🔶 Partial |
| POST /api/v1/sprints | TC-026 | TC-027 | — | TC-028 | — | ✅ Full |
| GET /api/v1/sprints/:id/board | TC-010 | TC-029 | TC-030 | — | TC-005 (WS) | ✅ Full |
| POST /api/v1/tasks | TC-031 | TC-032 | — | TC-033 | — | ✅ Full |
| PATCH /api/v1/tasks/:id | TC-034 | TC-035 | TC-036 | — | TC-005 (WS) | ✅ Full |
| POST /webhooks/github | TC-001 | TC-002 | — | TC-003 | TC-001 (e2e) | ✅ Full |

### Risk Coverage

| Risk ID | Risk Description | Test Cases | Coverage |
|---------|-----------------|-----------|----------|
| RISK-001 | GitHub API rate limiting disrupts webhook processing | TC-010 (perf burst) | ✅ Full |
| RISK-002 | Data loss during database failover | TC-015, TC-016 (availability) | ✅ Full |
| RISK-003 | Unauthorized data access via JWT manipulation | TC-013 (security) | ✅ Full |
| RISK-004 | SQL injection in user-facing search fields | TC-011 (security) | ✅ Full |
| RISK-005 | WebSocket connection storms during standup | TC-008 (performance) | 🔶 Indirect |

### Coverage Summary

| Metric | Total | Covered | Coverage % | Target |
|--------|-------|---------|-----------|--------|
| Must Have ACs | 30 | 30 | 100% | >=95% ✅ |
| Should Have ACs | 12 | 10 | 83% | >=80% ✅ |
| Could Have ACs | 8 | 5 | 63% | — |
| API Endpoints | 12 | 11 | 92% | >=90% ✅ |
| Quality Attributes | 6 | 6 | 100% | 100% ✅ |
| High/Critical Risks | 5 | 5 | 100% | 100% ✅ |
| Component Interactions | 4 | 4 | 100% | >=90% ✅ |

---

## 5. Q&A Log

| # | Question | Context | Answer | Impact |
|---|----------|---------|--------|--------|
| 1 | What data volume should performance tests use? Strategy mentions "production-like" but production scale is unknown. | TC-008, TC-009 | PENDING — assumed 300 tasks / 50 users based on typical SaaS startup. Need product team input for production projections. | If production scale is larger, VU count and data volume in performance tests need adjustment. |
| 2 | Should WebSocket integration tests cover reconnection after network disruption? | TS-INT-002 | PENDING — current tests cover happy-path delivery only. Reconnection behavior depends on client library choice. | If reconnection is required, add TC for disconnect/reconnect with message replay. |

---

## 6. Readiness Assessment

### Confidence Distribution

| Level | Count | % |
|-------|-------|---|
| ✅ CONFIRMED | 10 | 63% |
| 🔶 ASSUMED | 5 | 31% |
| ❓ UNCLEAR | 1 | 6% |

### Coverage Assessment

| Criterion | Status | Notes |
|-----------|--------|-------|
| Key component interactions covered | ✅ Met | 4/4 interactions from architecture have test cases |
| All QA attributes tested | ✅ Met | 3/3 priority QA attributes have NFR test cases (Performance, Security, Availability) |
| Combined AC coverage >=95% (Must Have) | ✅ Met | 100% (30/30 ACs covered across test-cases + test-integration) |
| UNCLEAR items <=10% | ✅ Met | 6% UNCLEAR (1/16 test cases) |

### Verdict: Partially Ready

Integration and NFR coverage targets are met. However, 31% of test cases are ASSUMED — primarily performance targets and availability thresholds that need stakeholder confirmation. The pending Q&A on production data volume could significantly change performance test configurations. Recommend resolving Q&A items before finalizing.

### Recommended Actions

1. **Resolve performance data volume Q&A** — get product team input on expected production scale
2. **Review ASSUMED performance targets** — confirm p95/p99 targets with engineering lead
3. **Add WebSocket reconnection test** — if client reconnection is a requirement
4. **Run `/test-integration --refine`** after Q&A resolution to update confidence markers

---

## 7. Approval

| Role | Name | Decision | Date |
|------|------|----------|------|
| QA Lead | | Pending | |
| Technical Lead | | Pending | |
| Product Owner | | Pending | |
