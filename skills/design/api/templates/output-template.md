# API Output Template

Standard structure for API design documents produced by the `design-api` skill.

---

```markdown
# API Design — {Project Name}

**Version**: draft | v{N}
**Date**: {date}
**Base URL**: {protocol}://{host}/api/v1
**Auth**: {mechanism}
**Status**: Draft | Under Review | Approved

---

## 1. API Overview

**Base URL**: `https://{host}/api/v1`
**Content Type**: application/json
**Authentication**: {Bearer JWT via Auth0 | API Key | etc.}
**API Versioning**: URL path (/api/v1/)

### Common Headers

| Header | Required | Description |
|--------|----------|-------------|
| Authorization | Yes (most endpoints) | Bearer {access_token} |
| Content-Type | Yes (POST/PUT/PATCH) | application/json |
| Accept | No | application/json (default) |
| X-Request-ID | No | Client-generated UUID for request tracing |

### Response Envelope

All responses follow this format:

```json
{
  "data": { ... } | [ ... ],
  "meta": { "total": 100, "page": 1, "limit": 20, "has_next": true },
  "errors": null | [{ "code": "...", "message": "...", "field": "..." }]
}
```

- Success responses: `data` populated, `errors` is `null`
- Error responses: `data` is `null`, `errors` populated
- Collections: `data` is array, `meta` contains pagination info
- Single resources: `data` is object, `meta` is `null`

---

## 2. Resource Inventory

| Resource | Path | Operations | Source Stories | MVP |
|----------|------|-----------|---------------|-----|
| {name} | /api/v1/{name} | GET, POST, PUT, DELETE | US-xxx, US-xxx | Yes |
| {name} | /api/v1/{parent}/:parentId/{name} | GET, POST, PATCH | US-xxx | Yes |
| {name} | /api/v1/{name} | GET | US-xxx | No |

---

## 3. Endpoint Specifications

### 3.1 {Resource Name}

#### GET /api/v1/{resources}  ✅ CONFIRMED

| Field | Value |
|-------|-------|
| **Description** | List all {resources} with pagination and filtering |
| **Auth** | Required |
| **Stories** | US-xxx, US-xxx |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | N/A (no request body) |

**Query Parameters**:

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| page | integer | No | 1 | Page number |
| limit | integer | No | 20 | Items per page (max 100) |
| sort | string | No | created_at | Sort field |
| order | string | No | desc | Sort direction: asc, desc |
| {filter} | string | No | - | Filter by {field} |

**Success Response (200)**:

```json
{
  "data": [
    {
      "id": "uuid",
      "field1": "value",
      "created_at": "2026-04-06T12:00:00Z",
      "updated_at": "2026-04-06T12:00:00Z"
    }
  ],
  "meta": {
    "total": 42,
    "page": 1,
    "limit": 20,
    "has_next": true,
    "has_prev": false
  },
  "errors": null
}
```

**Error Responses**:

| Status | Code | When |
|--------|------|------|
| 401 | UNAUTHORIZED | Missing or invalid auth token |
| 403 | FORBIDDEN | User lacks permission to list {resources} |

---

#### GET /api/v1/{resources}/:id  ✅ CONFIRMED

| Field | Value |
|-------|-------|
| **Description** | Get a single {resource} by ID |
| **Auth** | Required |
| **Stories** | US-xxx |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | N/A |

**Path Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| id | UUID | {Resource} identifier |

**Success Response (200)**:

```json
{
  "data": {
    "id": "uuid",
    "field1": "value",
    "created_at": "2026-04-06T12:00:00Z",
    "updated_at": "2026-04-06T12:00:00Z"
  },
  "meta": null,
  "errors": null
}
```

**Error Responses**:

| Status | Code | When |
|--------|------|------|
| 401 | UNAUTHORIZED | Missing or invalid auth token |
| 403 | FORBIDDEN | User lacks permission |
| 404 | NOT_FOUND | {Resource} with given ID does not exist |

---

#### POST /api/v1/{resources}  🔶 ASSUMED

| Field | Value |
|-------|-------|
| **Description** | Create a new {resource} |
| **Auth** | Required |
| **Stories** | US-xxx |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | application/json |

**Request Body**:

| Field | Type | Required | Constraints | Description |
|-------|------|----------|-------------|-------------|
| name | string | Yes | 1-200 chars | {Resource} name |
| description | string | No | max 2000 chars | {Resource} description |
| {field} | {type} | {Yes/No} | {constraints} | {description} |

```json
{
  "name": "Example Name",
  "description": "Optional description"
}
```

**Success Response (201)**:

```json
{
  "data": {
    "id": "generated-uuid",
    "name": "Example Name",
    "description": "Optional description",
    "created_at": "2026-04-06T12:00:00Z",
    "updated_at": "2026-04-06T12:00:00Z"
  },
  "meta": null,
  "errors": null
}
```

**Error Responses**:

| Status | Code | When |
|--------|------|------|
| 400 | VALIDATION_ERROR | Missing required fields or invalid types |
| 401 | UNAUTHORIZED | Missing or invalid auth token |
| 403 | FORBIDDEN | User lacks permission to create {resources} |
| 409 | CONFLICT | {Resource} with same unique field already exists |

---

#### PATCH /api/v1/{resources}/:id  🔶 ASSUMED

| Field | Value |
|-------|-------|
| **Description** | Partially update a {resource} |
| **Auth** | Required |
| **Stories** | US-xxx |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | application/json |

**Path Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| id | UUID | {Resource} identifier |

**Request Body** (all fields optional — send only changed fields):

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| name | string | 1-200 chars | Updated name |
| {field} | {type} | {constraints} | {description} |

**Success Response (200)**:

```json
{
  "data": { "...updated resource..." },
  "meta": null,
  "errors": null
}
```

**Error Responses**:

| Status | Code | When |
|--------|------|------|
| 400 | VALIDATION_ERROR | Invalid field values |
| 401 | UNAUTHORIZED | Missing or invalid auth token |
| 403 | FORBIDDEN | User lacks permission |
| 404 | NOT_FOUND | {Resource} does not exist |

---

#### DELETE /api/v1/{resources}/:id  🔶 ASSUMED

| Field | Value |
|-------|-------|
| **Description** | Delete a {resource} |
| **Auth** | Required (admin/owner) |
| **Stories** | US-xxx |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | N/A |

**Success Response (204)**: No body

**Error Responses**:

| Status | Code | When |
|--------|------|------|
| 401 | UNAUTHORIZED | Missing or invalid auth token |
| 403 | FORBIDDEN | User lacks permission to delete |
| 404 | NOT_FOUND | {Resource} does not exist |

---

### 3.2 {Next Resource}
{Repeat endpoint specification pattern...}

---

## 4. Authentication & Authorization

### Auth Flow

{Description of authentication flow — e.g., SPA → Auth Provider → JWT → API validates}

### Token Format

{JWT claims, expiry, refresh mechanism}

### Role Permissions

| Endpoint Pattern | admin | manager | member | viewer |
|-----------------|-------|---------|--------|--------|
| GET /resources | ✅ | ✅ | ✅ | ✅ |
| POST /resources | ✅ | ✅ | ✅ | ❌ |
| PATCH /resources/:id | ✅ | ✅ | own | ❌ |
| DELETE /resources/:id | ✅ | ❌ | ❌ | ❌ |

---

## 5. Error Handling

### Standard Error Response

```json
{
  "data": null,
  "meta": null,
  "errors": [{
    "code": "VALIDATION_ERROR",
    "message": "Human-readable message",
    "field": "email",
    "details": "Must be a valid email address"
  }]
}
```

### Error Code Catalog

| Code | HTTP Status | Description |
|------|------------|-------------|
| VALIDATION_ERROR | 400 | Request body validation failed |
| UNAUTHORIZED | 401 | Missing or invalid authentication |
| FORBIDDEN | 403 | Insufficient permissions |
| NOT_FOUND | 404 | Requested resource does not exist |
| CONFLICT | 409 | Resource conflict (duplicate, state) |
| RATE_LIMITED | 429 | Rate limit exceeded |
| INTERNAL_ERROR | 500 | Unexpected server error |
| {CUSTOM_CODE} | {status} | {description} |

---

## 6. Pagination & Filtering

### Pagination Approach

{Offset or cursor — explain choice}

### Standard Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| page | integer | 1 | Page number |
| limit | integer | 20 | Items per page (max 100) |
| sort | string | created_at | Sort field |
| order | string | desc | Sort direction: asc, desc |

### Example Request

```
GET /api/v1/{resources}?page=2&limit=10&sort=name&order=asc
```

### Example Response Meta

```json
{
  "meta": {
    "total": 45,
    "page": 2,
    "limit": 10,
    "has_next": true,
    "has_prev": true
  }
}
```

---

## 7. Rate Limiting

| Tier | Limit | Applies To |
|------|-------|-----------|
| Anonymous | 20/min | Unauthenticated endpoints |
| Standard | 100/min | Authenticated users |
| Elevated | 500/min | Webhook ingestion, batch operations |

### Rate Limit Headers

Included in every response:

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 73
X-RateLimit-Reset: 1680307200
```

### Exceeded Response

HTTP 429 with `Retry-After` header and standard error envelope.

---

## 8. WebSocket API (if applicable)

**URL**: `wss://{host}/ws?token={jwt}`
**Auth**: JWT in connection query parameter

### Channels

| Channel Pattern | Description |
|----------------|-------------|
| {entity}:{id} | Updates for specific {entity} |

### Events

| Event | Direction | Payload | Description |
|-------|-----------|---------|-------------|
| {resource}.created | Server → Client | { id, ...fields } | New {resource} created |
| {resource}.updated | Server → Client | { id, ...changed } | {Resource} updated |
| {resource}.deleted | Server → Client | { id } | {Resource} deleted |

### Message Format

```json
{
  "event": "{resource}.{action}",
  "channel": "{entity}:{id}",
  "data": { ... },
  "timestamp": "2026-04-06T12:00:00Z"
}
```

---

## 9. Q&A Log

| ID | Section | Question | Priority | Answer | Status |
|----|---------|----------|----------|--------|--------|
| Q-001 | {section} | {question} | HIGH/MED/LOW | {answer or pending} | Open/Resolved |

---

## 10. Readiness Assessment

### Confidence Summary

| Confidence | Count | Percentage |
|------------|-------|-----------|
| ✅ CONFIRMED | {N} | {%} |
| 🔶 ASSUMED | {N} | {%} |
| ❓ UNCLEAR | {N} | {%} |
| **Total** | {N} | 100% |

### Open Q&A Items

| Priority | Count |
|----------|-------|
| HIGH | {N} |
| MEDIUM | {N} |
| LOW | {N} |

### Verdict

**{READY / PARTIALLY READY / NOT READY}**

{Rationale for verdict based on confidence levels and open Q&A items}

---

## 11. Approval

| Role | Name | Status | Date |
|------|------|--------|------|
| Technical Lead | {name} | Pending | |
| API Architect | {name} | Pending | |
| Product Owner | {name} | Pending | |
```
