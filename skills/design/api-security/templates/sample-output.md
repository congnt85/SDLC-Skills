# API Security & Contracts — TaskFlow

**Version**: draft
**Date**: 2026-04-06
**Base URL**: https://api.taskflow.io/api/v1
**Auth**: Bearer JWT (Auth0)
**Status**: Draft

---

## 1. Authentication & Authorization

### Auth Flow

```
┌────────┐     ┌─────────┐     ┌──────────────┐     ┌─────────────┐
│  SPA   │────>│  Auth0  │────>│ Auth0 Server │────>│ TaskFlow API│
│(React) │<────│ SDK     │<────│  (OIDC/JWT)  │     │  validates  │
└────────┘     └─────────┘     └──────────────┘     │  JWT claims │
                                                     └─────────────┘
```

1. User clicks "Sign In" in the React SPA
2. Auth0 SDK redirects to Auth0 Universal Login (Authorization Code + PKCE)
3. User authenticates (email/password, Google SSO, or GitHub SSO)
4. Auth0 issues JWT access token + refresh token
5. SPA stores access token in memory (never localStorage)
6. SPA includes `Authorization: Bearer {token}` on every API request
7. TaskFlow API validates JWT signature, expiry, and claims

### Token Format (JWT)

```json
{
  "sub": "auth0|user-uuid",
  "email": "alice@taskflow.io",
  "name": "Alice Chen",
  "roles": ["member"],
  "org_id": "org-uuid",
  "iat": 1712404800,
  "exp": 1712408400,
  "iss": "https://taskflow.auth0.com/",
  "aud": "https://api.taskflow.io"
}
```

- **Access token TTL**: 60 minutes
- **Refresh token TTL**: 30 days (rotating)
- **Refresh flow**: `POST /auth/refresh` — returns new access + refresh tokens

### Role Permissions

| Endpoint Pattern | admin | manager | member | viewer |
|-----------------|-------|---------|--------|--------|
| GET /projects | ✅ | ✅ | ✅ | ✅ |
| POST /projects | ✅ | ✅ | ❌ | ❌ |
| PUT /projects/:id | ✅ | ✅ | ❌ | ❌ |
| DELETE /projects/:id | ✅ | ❌ | ❌ | ❌ |
| GET /sprints | ✅ | ✅ | ✅ | ✅ |
| POST /sprints | ✅ | ✅ | ❌ | ❌ |
| PATCH /sprints/:id | ✅ | ✅ | ❌ | ❌ |
| GET /tasks | ✅ | ✅ | ✅ | ✅ |
| POST /tasks | ✅ | ✅ | ✅ | ❌ |
| PATCH /tasks/:id | ✅ | ✅ | own | ❌ |
| DELETE /tasks/:id | ✅ | ✅ | ❌ | ❌ |
| GET /alert-rules | ✅ | ✅ | ✅ | ✅ |
| POST /alert-rules | ✅ | ✅ | ❌ | ❌ |
| PUT /alert-rules/:id | ✅ | ✅ | ❌ | ❌ |
| DELETE /alert-rules/:id | ✅ | ✅ | ❌ | ❌ |
| GET /notifications | ✅ | ✅ | ✅ | ✅ |
| PATCH /notifications/:id | ✅ | ✅ | ✅ | ✅ |
| POST /webhooks/* | signature-based (no user role) | | | |

**"own"** = user can only update tasks assigned to them.

---

## 2. Pagination & Filtering

### Pagination Approach

Offset-based pagination for all list endpoints. Chosen for simplicity and compatibility with the TaskFlow UI which uses page-based navigation. Cursor-based pagination is not needed because TaskFlow's datasets are moderate-size (hundreds to low thousands per project).

### Standard Parameters

| Parameter | Type | Default | Max | Description |
|-----------|------|---------|-----|-------------|
| page | integer | 1 | - | Page number (1-indexed) |
| limit | integer | 20 | 100 | Items per page |
| sort | string | created_at | - | Sort field (varies by resource) |
| order | string | desc | - | Sort direction: asc, desc |

### Filtering

Simple query parameter filters per resource:
```
GET /api/v1/sprints/:sprintId/tasks?status=in_progress&assignee_id=uuid&priority=1,2
```

- Single value: `?status=active`
- Multiple values (OR): `?priority=1,2,3`
- Date ranges: `?since=2026-01-01T00:00:00Z&until=2026-03-31T23:59:59Z`
- Text search: `?q=webhook` (searches title/name fields)

### Example

**Request**:
```
GET /api/v1/projects/proj-uuid/sprints?page=2&limit=5&sort=start_date&order=asc&status=completed
```

**Response meta**:
```json
{
  "meta": {
    "total": 12,
    "page": 2,
    "limit": 5,
    "has_next": true,
    "has_prev": true
  }
}
```

---

## 3. Rate Limiting

| Tier | Limit | Applies To |
|------|-------|-----------|
| Anonymous | 20/min | Health check, public docs endpoints |
| Standard | 100/min | All authenticated user endpoints |
| Elevated | 500/min | Webhook ingestion (POST /webhooks/*) |

### Per-Endpoint Overrides

| Endpoint | Limit | Reason |
|----------|-------|--------|
| POST /auth/login | 10/min | Brute force prevention |
| POST /auth/refresh | 30/min | Token refresh frequency |
| GET /notifications | 60/min | Polling frequency cap |

### Rate Limit Headers

Included in every response:

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 73
X-RateLimit-Reset: 1712408400
```

### Exceeded Response

```
HTTP/1.1 429 Too Many Requests
Retry-After: 30
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1712408400
```

```json
{
  "data": null,
  "meta": null,
  "errors": [{
    "code": "RATE_LIMITED",
    "message": "Rate limit exceeded. Try again in 30 seconds.",
    "field": null,
    "details": "Standard tier limit is 100 requests per minute"
  }]
}
```

---

## 4. WebSocket API

**URL**: `wss://api.taskflow.io/ws?token={jwt}`
**Auth**: JWT access token in query parameter (validated on connection upgrade)
**Heartbeat**: ping/pong every 30 seconds

### Channels

| Channel Pattern | Description | Example |
|----------------|-------------|---------|
| project:{projectId} | All updates for a project | project:proj-a1b2c3d4-... |
| sprint:{sprintId} | Updates for a specific sprint board | sprint:sprint-c3d4e5f6-... |

### Subscription

```json
{ "action": "subscribe", "channel": "sprint:sprint-c3d4e5f6-a7b8-9012-cdef-123456789012" }
{ "action": "unsubscribe", "channel": "sprint:sprint-c3d4e5f6-a7b8-9012-cdef-123456789012" }
```

### Events

| Event | Direction | Payload | Description |
|-------|-----------|---------|-------------|
| task.created | Server -> Client | { id, title, status, assignee_id, sprint_id } | New task added to sprint |
| task.updated | Server -> Client | { id, status, assignee_id, priority, updated_fields[] } | Task fields changed |
| task.deleted | Server -> Client | { id, sprint_id } | Task removed from sprint |
| sprint.updated | Server -> Client | { id, status, task_count, completed_count } | Sprint status or counters changed |
| commit.received | Server -> Client | { sha, message, author, linked_task_id } | New commit received via webhook |
| alert.triggered | Server -> Client | { alert_rule_id, name, message, severity } | Alert condition met |

### Message Format

```json
{
  "event": "task.updated",
  "channel": "sprint:sprint-c3d4e5f6-a7b8-9012-cdef-123456789012",
  "data": {
    "id": "task-e5f6a7b8-c9d0-1234-efab-345678901234",
    "status": "in_progress",
    "assignee_id": "user-33445566-7788-99aa-bbcc-ddeeff001122",
    "updated_fields": ["status", "assignee_id"]
  },
  "timestamp": "2026-04-06T12:15:00Z"
}
```

### Reconnection

1. Client detects disconnect (missed heartbeat or WebSocket close event)
2. Exponential backoff: 1s, 2s, 4s, 8s, max 30s
3. On reconnect, client sends `{ "action": "replay", "since": "2026-04-06T12:10:00Z" }`
4. Server replays missed events since that timestamp

---

## 5. Q&A Log

| ID | Section | Question | Priority | Answer | Status |
|----|---------|----------|----------|--------|--------|
| Q-001 | Auth | Should we support API key authentication in addition to JWT for service-to-service calls? | MED | Pending — need input from architecture team. | Open |
| Q-002 | Rate Limiting | Should webhook ingestion have a separate rate limit per source (GitHub vs GitLab) or a shared limit? | LOW | Shared limit is sufficient for MVP. Per-source limits can be added later. | Resolved |
| Q-003 | WebSocket | Should we verify webhook signatures asynchronously to avoid blocking the response? How should we handle payload replay attacks? | HIGH | Pending — need input from security review. | Open |

---

## 6. Readiness Assessment

### Confidence Summary

| Confidence | Count | Percentage |
|------------|-------|-----------|
| ✅ CONFIRMED | 8 | 40% |
| 🔶 ASSUMED | 11 | 55% |
| ❓ UNCLEAR | 1 | 5% |
| **Total** | 20 | 100% |

### Open Q&A Items

| Priority | Count |
|----------|-------|
| HIGH | 1 |
| MEDIUM | 1 |
| LOW | 0 |

### Verdict

**PARTIALLY READY**

The API security & contracts document covers authentication (Auth0 JWT), role-based authorization for all 18 endpoint patterns, pagination strategy, rate limiting tiers, and WebSocket events. Key risks:

- 55% of specifications are assumed — need user/architect confirmation on role permissions and rate limit thresholds
- 1 HIGH-priority Q&A open regarding webhook security (signature verification approach)
- Service-to-service authentication not yet addressed (Q-001)

Recommended: Run `/design-api-security --refine` after security review to upgrade assumed items to confirmed.

---

## 7. Approval

| Role | Name | Status | Date |
|------|------|--------|------|
| Technical Lead | [TBD] | Pending | |
| API Architect | [TBD] | Pending | |
| Security Lead | [TBD] | Pending | |
