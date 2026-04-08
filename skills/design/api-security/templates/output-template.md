# API Security & Contracts Output Template

Standard structure for API security and contract documents produced by the `design-api-security` skill.

---

```markdown
# API Security & Contracts — {Project Name}

**Version**: draft | v{N}
**Date**: {date}
**Base URL**: {protocol}://{host}/api/v1
**Auth**: {mechanism}
**Status**: Draft | Under Review | Approved

---

## 1. Authentication & Authorization

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

## 2. Pagination & Filtering

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

## 3. Rate Limiting

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

## 4. WebSocket API (if applicable)

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

## 5. Q&A Log

| ID | Section | Question | Priority | Answer | Status |
|----|---------|----------|----------|--------|--------|
| Q-001 | {section} | {question} | HIGH/MED/LOW | {answer or pending} | Open/Resolved |

---

## 6. Readiness Assessment

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

## 7. Approval

| Role | Name | Status | Date |
|------|------|--------|------|
| Technical Lead | {name} | Pending | |
| API Architect | {name} | Pending | |
| Security Lead | {name} | Pending | |
```
