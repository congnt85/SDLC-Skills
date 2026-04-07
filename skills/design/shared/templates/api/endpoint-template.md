# API Endpoint Template

Standard format for designing API endpoints.

---

## Endpoint Specification

```markdown
### {METHOD} {path}

| Field | Value |
|-------|-------|
| **Method** | GET / POST / PUT / PATCH / DELETE |
| **Path** | /api/v1/{resource}/{id} |
| **Description** | {what this endpoint does} |
| **Auth** | Required / Public |
| **Stories** | US-{NNN}, US-{NNN} |
| **Rate Limit** | {N requests/minute or "standard"} |

#### Request

**Headers**:
| Header | Required | Description |
|--------|----------|-------------|
| Authorization | Yes | Bearer {token} |
| Content-Type | Yes (POST/PUT) | application/json |

**Path Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| id | UUID | {resource} identifier |

**Query Parameters** (GET only):
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| page | integer | No | 1 | Page number |
| limit | integer | No | 20 | Items per page (max 100) |
| sort | string | No | created_at | Sort field |

**Request Body** (POST/PUT):
```json
{
  "field1": "string (required)",
  "field2": 123,
  "field3": "enum: value1|value2|value3"
}
```

#### Response

**Success (200/201)**:
```json
{
  "data": {
    "id": "uuid",
    "field1": "string",
    "field2": 123,
    "created_at": "2026-04-06T12:00:00Z"
  }
}
```

**Error Responses**:
| Status | Code | Description |
|--------|------|-------------|
| 400 | VALIDATION_ERROR | Invalid request body |
| 401 | UNAUTHORIZED | Missing or invalid auth token |
| 403 | FORBIDDEN | Insufficient permissions |
| 404 | NOT_FOUND | Resource not found |
| 409 | CONFLICT | Duplicate resource |
| 429 | RATE_LIMITED | Too many requests |
| 500 | INTERNAL_ERROR | Server error |
```

---

## API Overview Table

```markdown
| Method | Path | Description | Auth | Stories |
|--------|------|-------------|------|---------|
| GET | /api/v1/{resources} | List resources | Yes | US-xxx |
| POST | /api/v1/{resources} | Create resource | Yes | US-xxx |
| GET | /api/v1/{resources}/{id} | Get resource | Yes | US-xxx |
| PUT | /api/v1/{resources}/{id} | Update resource | Yes | US-xxx |
| DELETE | /api/v1/{resources}/{id} | Delete resource | Yes | US-xxx |
```

---

## Rules

- RESTful naming: plural nouns for resources (`/sprints`, `/tickets`)
- Version prefix: `/api/v1/`
- Consistent response envelope: `{ "data": ..., "meta": ..., "errors": ... }`
- Pagination for list endpoints (page/limit or cursor-based)
- Every endpoint MUST reference which user stories it implements
- Error responses MUST use standard error codes
- Auth requirements MUST be specified for every endpoint
- Rate limiting MUST be specified for public or high-traffic endpoints
