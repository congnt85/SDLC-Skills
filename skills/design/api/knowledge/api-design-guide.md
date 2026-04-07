# REST API Design Guide

Techniques and patterns for designing RESTful APIs that are consistent, intuitive, and maintainable.

---

## 1. Resource Identification

### Extracting Resources
Resources come from two sources:
- **Architecture entities** — containers and components from C4 diagrams map to API resources
- **User stories** — nouns in story descriptions reveal resources (e.g., "As a user, I want to create a **task**" → `/tasks`)

Cross-reference both sources. Every resource should trace to at least one user story and one architecture entity.

### Naming Conventions
- **Plural nouns**: `/projects`, `/tasks`, `/sprints` — never verbs
- **Kebab-case** for multi-word resources: `/alert-rules`, `/ci-builds`, `/project-members`
- **Lowercase only**: never `/Projects` or `/TASKS`
- Match database table names: table `tasks` → resource `/tasks` (DES-06 consistency)

### Nested vs Flat URLs

**Nest when**: strong parent-child ownership exists (child cannot exist without parent)
```
GET /api/v1/projects/:projectId/sprints         # sprints belong to a project
GET /api/v1/sprints/:sprintId/tasks              # tasks belong to a sprint
```

**Keep flat when**: resource is independent or accessed across parents
```
GET /api/v1/notifications                        # not scoped to a single parent
GET /api/v1/users                                # top-level resource
```

**Rule of thumb**: nest at most 2 levels deep. Beyond that, use query parameters:
```
# Instead of: /projects/:id/sprints/:id/tasks/:id/comments
# Use: /comments?task_id=xxx
```

---

## 2. Endpoint Design Patterns

### Standard CRUD Mapping

| Operation | Method | Path | Status Code |
|-----------|--------|------|-------------|
| List | GET | /resources | 200 |
| Get by ID | GET | /resources/:id | 200 |
| Create | POST | /resources | 201 |
| Full update | PUT | /resources/:id | 200 |
| Partial update | PATCH | /resources/:id | 200 |
| Delete | DELETE | /resources/:id | 204 |

### PUT vs PATCH
- **PUT**: replaces the entire resource. Client sends ALL fields. Missing fields are set to defaults/null. Use when the client always has the full object.
- **PATCH**: updates only the provided fields. Client sends a subset. Other fields remain unchanged. Preferred for most update operations.

**Recommendation**: Use PATCH for most updates. Reserve PUT for resources where full replacement is the natural operation (e.g., configuration objects).

### Custom Actions
When CRUD doesn't fit (state transitions, operations):
```
POST /api/v1/sprints/:id/actions/start           # start a sprint
POST /api/v1/sprints/:id/actions/complete         # complete a sprint
POST /api/v1/tasks/:id/actions/assign             # assign a task
```

Pattern: `POST /resources/:id/actions/:action`

### Bulk Operations
For operating on multiple resources at once:
```
POST /api/v1/tasks/bulk
{
  "action": "update",
  "ids": ["uuid1", "uuid2"],
  "data": { "status": "done" }
}
```

Use sparingly — only when the use case genuinely requires batch processing.

---

## 3. Request Design

### Parameter Types

| Location | Use For | Examples |
|----------|---------|---------|
| **Path params** | Resource identifiers | `/projects/:projectId` |
| **Query params** | Filtering, pagination, sorting | `?status=active&page=1` |
| **Request body** | Create/update payloads | `{ "name": "Sprint 1" }` |
| **Headers** | Auth, content type, metadata | `Authorization: Bearer xxx` |

### Request Body Conventions
- Use camelCase for JSON field names (consistent with JavaScript conventions)
- Mark required vs optional fields clearly in documentation
- Include type, constraints, and example values
- Validate on the server: required fields, type constraints, value ranges, string lengths

```json
{
  "name": "string (required, 1-200 chars)",
  "description": "string (optional, max 2000 chars)",
  "status": "enum: active|archived (optional, default: active)",
  "priority": "integer (optional, 1-5, default: 3)"
}
```

### Content-Type Handling
- `application/json` — default for all endpoints
- `multipart/form-data` — file uploads
- Reject unsupported content types with 415 Unsupported Media Type

---

## 4. Response Design

### Envelope Pattern
Wrap all responses in a consistent envelope:

```json
{
  "data": { ... } | [ ... ],
  "meta": { "total": 100, "page": 1, "limit": 20, "has_next": true },
  "errors": null | [{ "code": "...", "message": "...", "field": "..." }]
}
```

- **data**: the resource(s). Object for single, array for collections. `null` on errors.
- **meta**: pagination info for collections, `null` for single resources.
- **errors**: array of error objects on failure, `null` on success.

### Single vs Collection Responses
- **Single resource**: `"data": { "id": "...", "name": "..." }`
- **Collection**: `"data": [{ "id": "...", "name": "..." }, ...]` with `"meta"` for pagination

### Data Formatting
- **IDs**: strings (UUID v4), never auto-increment integers exposed externally
- **Timestamps**: ISO 8601 format: `"2026-04-06T12:00:00Z"` — always UTC
- **Booleans**: true/false, never 0/1 or "yes"/"no"
- **Nulls**: explicitly `null` for absent optional fields, never omit the key
- **Enums**: lowercase strings: `"active"`, `"archived"`, `"in_progress"`

### Embed vs Link
- **Embed** frequently needed related data to avoid N+1 requests:
  ```json
  { "data": { "id": "...", "project": { "id": "...", "name": "..." } } }
  ```
- **Link** large or rarely needed relations:
  ```json
  { "data": { "id": "...", "project_id": "uuid", "_links": { "project": "/api/v1/projects/uuid" } } }
  ```

---

## 5. Error Design

### HTTP Status Code Usage

| Status | Meaning | When to Use |
|--------|---------|-------------|
| 400 | Bad Request | Malformed JSON, missing required fields, type errors |
| 401 | Unauthorized | Missing or expired auth token |
| 403 | Forbidden | Valid token but insufficient permissions |
| 404 | Not Found | Resource does not exist |
| 409 | Conflict | Duplicate resource, state conflict |
| 415 | Unsupported Media Type | Wrong Content-Type header |
| 422 | Unprocessable Entity | Semantic validation (valid JSON, invalid values) |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Unexpected server failure |

**400 vs 422**: Use 400 for structural issues (bad JSON, wrong types). Use 422 for business rule violations (valid structure but invalid values). When in doubt, use 400.

### Error Response Body

```json
{
  "data": null,
  "meta": null,
  "errors": [{
    "code": "VALIDATION_ERROR",
    "message": "Human-readable description of the error",
    "field": "email",
    "details": "Must be a valid email address"
  }]
}
```

- **code**: machine-readable error code (UPPER_SNAKE_CASE)
- **message**: human-readable message (suitable for logs/debugging)
- **field**: the request field that caused the error (null for non-field errors)
- **details**: additional context or constraints

### Field-Level Validation Errors
Return ALL validation errors at once, not just the first:

```json
{
  "errors": [
    { "code": "VALIDATION_ERROR", "field": "name", "message": "Name is required" },
    { "code": "VALIDATION_ERROR", "field": "email", "message": "Invalid email format" }
  ]
}
```

---

## 6. Pagination Patterns

### Offset Pagination (Page/Limit)
Simple, well-understood, good for most use cases.

```
GET /api/v1/tasks?page=2&limit=20&sort=created_at&order=desc
```

Response meta:
```json
{
  "meta": {
    "total": 156,
    "page": 2,
    "limit": 20,
    "has_next": true,
    "has_prev": true
  }
}
```

**Pros**: easy to implement, supports "jump to page N".
**Cons**: inconsistent results if data changes between pages (skip-count problem).

### Cursor Pagination (After/Before)
Better for real-time data or large datasets.

```
GET /api/v1/notifications?after=cursor_abc123&limit=20
```

Response meta:
```json
{
  "meta": {
    "limit": 20,
    "has_next": true,
    "next_cursor": "cursor_def456",
    "has_prev": true,
    "prev_cursor": "cursor_xyz789"
  }
}
```

**Pros**: consistent results, handles real-time inserts/deletes.
**Cons**: cannot jump to arbitrary page, harder to implement.

### Recommendation
- **Offset pagination** for most resources (projects, sprints, users) — simpler, sufficient for moderate datasets
- **Cursor pagination** for high-volume or real-time streams (notifications, activity logs, audit trails)

### Standard Query Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| page | integer | 1 | Page number (offset pagination) |
| limit | integer | 20 | Items per page (max 100) |
| sort | string | created_at | Sort field |
| order | string | desc | Sort direction: asc or desc |
| after | string | - | Cursor for forward pagination |
| before | string | - | Cursor for backward pagination |

### Filtering Syntax
Use query parameters for simple filters:
```
GET /api/v1/tasks?status=in_progress&assignee_id=uuid&priority=1,2,3
```

- Single value: `?status=active`
- Multiple values (OR): `?priority=1,2,3`
- Date ranges: `?created_after=2026-01-01&created_before=2026-03-31`
- Search: `?q=search+term` (full-text search across relevant fields)

---

## 7. Authentication Design

### Bearer Token (JWT)
Stateless authentication. Token included in every request:
```
Authorization: Bearer eyJhbGciOiJSUzI1NiIs...
```

**JWT claims to include**:
- `sub`: user ID
- `email`: user email
- `roles`: array of roles (e.g., `["admin", "member"]`)
- `org_id`: organization/tenant ID (for multi-tenant)
- `exp`: expiration timestamp
- `iat`: issued-at timestamp

### API Key Authentication
For service-to-service communication or third-party integrations:
```
X-API-Key: sk_live_abc123def456
```

- Prefix keys: `sk_live_` for production, `sk_test_` for sandbox
- Hash keys before storage — never store plaintext
- Support key rotation (multiple active keys per service)

### OAuth2 Flows

| Flow | Use Case |
|------|----------|
| Authorization Code + PKCE | Single-page applications (SPA) |
| Authorization Code | Server-side web applications |
| Client Credentials | Service-to-service (machine-to-machine) |

### Token Lifecycle
- **Access token**: short-lived (15-60 minutes)
- **Refresh token**: longer-lived (7-30 days), stored securely
- **Refresh flow**: `POST /auth/refresh` with refresh token → new access + refresh tokens
- **Revocation**: `POST /auth/revoke` to invalidate refresh token

### Role-Based Access Control (RBAC)
Define endpoint permissions per role:

| Action | admin | manager | member | viewer |
|--------|-------|---------|--------|--------|
| Create resource | yes | yes | yes | no |
| Read resource | yes | yes | yes | yes |
| Update own resource | yes | yes | yes | no |
| Update any resource | yes | yes | no | no |
| Delete resource | yes | no | no | no |

Document per-endpoint: which roles can access, and whether resource-level ownership matters.

---

## 8. Versioning Strategy

### URL Versioning (Recommended)
```
/api/v1/projects
/api/v2/projects    # breaking changes only
```

- Explicit and visible in every request
- Easy to test (change URL, see different behavior)
- Easy to deprecate (redirect v1 → v2 with warning headers)

### When to Increment Version
Only for **breaking changes**:
- Removing a field from response
- Changing a field type
- Renaming an endpoint
- Changing required fields in request

**Non-breaking changes** (no version bump needed):
- Adding new optional fields to response
- Adding new optional query parameters
- Adding new endpoints
- Adding new error codes

### Deprecation Strategy
1. Add `Sunset: <date>` header to deprecated endpoints
2. Return `Deprecation: true` header
3. Log usage of deprecated endpoints for migration tracking
4. Maintain old version for minimum 6 months after deprecation notice

---

## 9. Rate Limiting Design

### Tier Structure

| Tier | Limit | Applies To |
|------|-------|-----------|
| Anonymous | 20 req/min | Unauthenticated endpoints (public health checks, docs) |
| Standard | 100 req/min | Authenticated users (normal API usage) |
| Elevated | 500 req/min | Webhooks, batch ingestion, internal services |

### Rate Limit Headers
Include in every response:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 73
X-RateLimit-Reset: 1680307200    # Unix timestamp when window resets
```

### Exceeded Response
```
HTTP/1.1 429 Too Many Requests
Retry-After: 30

{
  "data": null,
  "meta": null,
  "errors": [{
    "code": "RATE_LIMITED",
    "message": "Rate limit exceeded. Try again in 30 seconds."
  }]
}
```

### Per-Endpoint Overrides
Some endpoints need custom limits:
- Login/auth: lower limit (10/min) to prevent brute force
- Search: moderate limit (30/min) due to compute cost
- Webhooks: higher limit (500/min) for burst ingestion
- File upload: lower limit (5/min) due to bandwidth

---

## 10. WebSocket Design

### When to Use WebSocket
REST is insufficient when the client needs:
- **Real-time updates** — sprint board changes, task status transitions
- **Live dashboards** — build status, deployment progress
- **Collaborative editing** — multiple users on same resource
- **Push notifications** — alerts, mentions, assignments

### Connection Pattern
```
wss://api.example.com/ws?token={jwt}
```

- Authenticate via JWT in query parameter on connection
- Server validates token before upgrading to WebSocket
- Heartbeat ping/pong every 30 seconds to detect stale connections

### Channel/Room Pattern
Scope subscriptions to avoid broadcasting everything:
```json
{ "action": "subscribe", "channel": "project:uuid-123" }
{ "action": "subscribe", "channel": "sprint:uuid-456" }
{ "action": "unsubscribe", "channel": "project:uuid-123" }
```

### Event Message Format
```json
{
  "event": "task.updated",
  "channel": "sprint:uuid-456",
  "data": {
    "id": "task-uuid",
    "status": "in_progress",
    "updated_by": "user-uuid"
  },
  "timestamp": "2026-04-06T12:00:00Z"
}
```

### Standard Events
- `{resource}.created` — new resource added
- `{resource}.updated` — resource fields changed
- `{resource}.deleted` — resource removed
- `{resource}.status_changed` — explicit status transition

### Reconnection Strategy
1. Client detects disconnect (missed heartbeat or WebSocket close)
2. Exponential backoff: 1s, 2s, 4s, 8s, max 30s
3. On reconnect, client sends last received event timestamp
4. Server replays missed events since that timestamp (event sourcing)
