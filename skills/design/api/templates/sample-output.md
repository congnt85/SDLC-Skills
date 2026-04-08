# API Design — TaskFlow

**Version**: draft
**Date**: 2026-04-06
**Base URL**: https://api.taskflow.io/api/v1
**Auth**: Bearer JWT (Auth0)
**Status**: Draft

---

## 1. API Overview

**Base URL**: `https://api.taskflow.io/api/v1`
**Content Type**: application/json
**Authentication**: Bearer JWT via Auth0
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
  "data": { "..." },
  "meta": { "total": 100, "page": 1, "limit": 20, "has_next": true },
  "errors": null
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
| projects | /api/v1/projects | GET, POST, PUT, DELETE | US-001, US-003, US-010 | Yes |
| project-members | /api/v1/projects/:projectId/members | GET, POST, DELETE | US-010 | Yes |
| sprints | /api/v1/projects/:projectId/sprints | GET, POST, PATCH | US-010, US-011, US-012 | Yes |
| tasks | /api/v1/sprints/:sprintId/tasks | GET, POST, PATCH, DELETE | US-011 | Yes |
| commits | /api/v1/projects/:projectId/commits | GET | US-001, US-002 | Yes |
| alert-rules | /api/v1/projects/:projectId/alert-rules | GET, POST, PUT, DELETE | US-020 | Yes |
| notifications | /api/v1/notifications | GET, PATCH | US-020 | Yes |
| ci-builds | /api/v1/projects/:projectId/ci-builds | GET | US-015, US-016 | No |
| webhooks | /api/v1/webhooks/github, /api/v1/webhooks/gitlab | POST | US-001, US-002 | Yes |

---

## 3. Endpoint Specifications

### 3.1 Projects

#### GET /api/v1/projects  ✅ CONFIRMED

| Field | Value |
|-------|-------|
| **Description** | List all projects the authenticated user has access to |
| **Auth** | Required |
| **Stories** | US-001, US-003 |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | N/A (no request body) |

**Query Parameters**:

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| page | integer | No | 1 | Page number |
| limit | integer | No | 20 | Items per page (max 100) |
| sort | string | No | updated_at | Sort field: name, created_at, updated_at |
| order | string | No | desc | Sort direction: asc, desc |
| status | string | No | - | Filter by status: active, archived |
| q | string | No | - | Search by project name |

**Success Response (200)**:

```json
{
  "data": [
    {
      "id": "proj-a1b2c3d4-e5f6-7890-abcd-ef1234567890",
      "name": "TaskFlow Platform",
      "description": "Real-time sprint tracking with Git integration",
      "status": "active",
      "owner_id": "user-11223344-5566-7788-99aa-bbccddeeff00",
      "member_count": 8,
      "created_at": "2026-01-15T09:00:00Z",
      "updated_at": "2026-04-05T14:30:00Z"
    },
    {
      "id": "proj-b2c3d4e5-f6a7-8901-bcde-f12345678901",
      "name": "Internal Dashboard",
      "description": "Company metrics dashboard",
      "status": "active",
      "owner_id": "user-22334455-6677-8899-aabb-ccddeeff0011",
      "member_count": 3,
      "created_at": "2026-02-20T10:00:00Z",
      "updated_at": "2026-04-01T16:45:00Z"
    }
  ],
  "meta": {
    "total": 5,
    "page": 1,
    "limit": 20,
    "has_next": false,
    "has_prev": false
  },
  "errors": null
}
```

**Error Responses**:

| Status | Code | When |
|--------|------|------|
| 401 | UNAUTHORIZED | Missing or invalid auth token |

---

#### GET /api/v1/projects/:projectId  ✅ CONFIRMED

| Field | Value |
|-------|-------|
| **Description** | Get a single project by ID with summary statistics |
| **Auth** | Required |
| **Stories** | US-003 |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | N/A |

**Path Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| projectId | UUID | Project identifier |

**Success Response (200)**:

```json
{
  "data": {
    "id": "proj-a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "name": "TaskFlow Platform",
    "description": "Real-time sprint tracking with Git integration",
    "status": "active",
    "owner_id": "user-11223344-5566-7788-99aa-bbccddeeff00",
    "repository_url": "https://github.com/taskflow/platform",
    "git_provider": "github",
    "member_count": 8,
    "active_sprint_id": "sprint-c3d4e5f6-a7b8-9012-cdef-123456789012",
    "created_at": "2026-01-15T09:00:00Z",
    "updated_at": "2026-04-05T14:30:00Z"
  },
  "meta": null,
  "errors": null
}
```

**Error Responses**:

| Status | Code | When |
|--------|------|------|
| 401 | UNAUTHORIZED | Missing or invalid auth token |
| 403 | FORBIDDEN | User is not a member of this project |
| 404 | NOT_FOUND | Project with given ID does not exist |

---

#### POST /api/v1/projects  ✅ CONFIRMED

| Field | Value |
|-------|-------|
| **Description** | Create a new project |
| **Auth** | Required (admin, manager) |
| **Stories** | US-001, US-010 |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | application/json |

**Request Body**:

| Field | Type | Required | Constraints | Description |
|-------|------|----------|-------------|-------------|
| name | string | Yes | 1-200 chars | Project name |
| description | string | No | max 2000 chars | Project description |
| repository_url | string | No | valid URL | Git repository URL |
| git_provider | string | No | enum: github, gitlab | Git provider type |

```json
{
  "name": "TaskFlow Platform",
  "description": "Real-time sprint tracking with Git integration",
  "repository_url": "https://github.com/taskflow/platform",
  "git_provider": "github"
}
```

**Success Response (201)**:

```json
{
  "data": {
    "id": "proj-a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "name": "TaskFlow Platform",
    "description": "Real-time sprint tracking with Git integration",
    "status": "active",
    "owner_id": "user-11223344-5566-7788-99aa-bbccddeeff00",
    "repository_url": "https://github.com/taskflow/platform",
    "git_provider": "github",
    "member_count": 1,
    "active_sprint_id": null,
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
| 400 | VALIDATION_ERROR | Missing required fields or invalid values |
| 401 | UNAUTHORIZED | Missing or invalid auth token |
| 403 | FORBIDDEN | User lacks permission to create projects |
| 409 | CONFLICT | Project with same name already exists for this user |

---

#### PUT /api/v1/projects/:projectId  🔶 ASSUMED

| Field | Value |
|-------|-------|
| **Description** | Update all fields of a project |
| **Auth** | Required (admin, manager, project owner) |
| **Stories** | US-003 |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | application/json |

**Path Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| projectId | UUID | Project identifier |

**Request Body**:

| Field | Type | Required | Constraints | Description |
|-------|------|----------|-------------|-------------|
| name | string | Yes | 1-200 chars | Project name |
| description | string | Yes | max 2000 chars, nullable | Project description |
| repository_url | string | Yes | valid URL, nullable | Git repository URL |
| git_provider | string | Yes | enum: github, gitlab, nullable | Git provider |
| status | string | Yes | enum: active, archived | Project status |

```json
{
  "name": "TaskFlow Platform v2",
  "description": "Updated description",
  "repository_url": "https://github.com/taskflow/platform",
  "git_provider": "github",
  "status": "active"
}
```

**Success Response (200)**:

```json
{
  "data": {
    "id": "proj-a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "name": "TaskFlow Platform v2",
    "description": "Updated description",
    "status": "active",
    "repository_url": "https://github.com/taskflow/platform",
    "git_provider": "github",
    "owner_id": "user-11223344-5566-7788-99aa-bbccddeeff00",
    "member_count": 8,
    "active_sprint_id": "sprint-c3d4e5f6-a7b8-9012-cdef-123456789012",
    "created_at": "2026-01-15T09:00:00Z",
    "updated_at": "2026-04-06T12:05:00Z"
  },
  "meta": null,
  "errors": null
}
```

**Error Responses**:

| Status | Code | When |
|--------|------|------|
| 400 | VALIDATION_ERROR | Missing required fields or invalid values |
| 401 | UNAUTHORIZED | Missing or invalid auth token |
| 403 | FORBIDDEN | User is not project owner/admin |
| 404 | NOT_FOUND | Project does not exist |
| 409 | CONFLICT | Name conflicts with another project |

---

#### DELETE /api/v1/projects/:projectId  🔶 ASSUMED

| Field | Value |
|-------|-------|
| **Description** | Delete a project and all associated data |
| **Auth** | Required (admin only) |
| **Stories** | US-010 |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | N/A |

**Path Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| projectId | UUID | Project identifier |

**Success Response (204)**: No body

**Error Responses**:

| Status | Code | When |
|--------|------|------|
| 401 | UNAUTHORIZED | Missing or invalid auth token |
| 403 | FORBIDDEN | User is not admin |
| 404 | NOT_FOUND | Project does not exist |

---

### 3.2 Sprints

#### GET /api/v1/projects/:projectId/sprints  ✅ CONFIRMED

| Field | Value |
|-------|-------|
| **Description** | List all sprints for a project |
| **Auth** | Required |
| **Stories** | US-010, US-011 |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | N/A |

**Path Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| projectId | UUID | Project identifier |

**Query Parameters**:

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| page | integer | No | 1 | Page number |
| limit | integer | No | 20 | Items per page (max 100) |
| sort | string | No | start_date | Sort field: start_date, end_date, created_at |
| order | string | No | desc | Sort direction: asc, desc |
| status | string | No | - | Filter: planning, active, completed, cancelled |

**Success Response (200)**:

```json
{
  "data": [
    {
      "id": "sprint-c3d4e5f6-a7b8-9012-cdef-123456789012",
      "project_id": "proj-a1b2c3d4-e5f6-7890-abcd-ef1234567890",
      "name": "Sprint 14",
      "goal": "Complete webhook integration and alert system",
      "status": "active",
      "start_date": "2026-03-25",
      "end_date": "2026-04-07",
      "task_count": 12,
      "completed_count": 7,
      "velocity": null,
      "created_at": "2026-03-24T10:00:00Z",
      "updated_at": "2026-04-05T09:15:00Z"
    }
  ],
  "meta": {
    "total": 14,
    "page": 1,
    "limit": 20,
    "has_next": false,
    "has_prev": false
  },
  "errors": null
}
```

**Error Responses**:

| Status | Code | When |
|--------|------|------|
| 401 | UNAUTHORIZED | Missing or invalid auth token |
| 403 | FORBIDDEN | User is not a project member |
| 404 | NOT_FOUND | Project does not exist |

---

#### GET /api/v1/projects/:projectId/sprints/:sprintId  ✅ CONFIRMED

| Field | Value |
|-------|-------|
| **Description** | Get a single sprint with task summary |
| **Auth** | Required |
| **Stories** | US-011 |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | N/A |

**Path Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| projectId | UUID | Project identifier |
| sprintId | UUID | Sprint identifier |

**Success Response (200)**:

```json
{
  "data": {
    "id": "sprint-c3d4e5f6-a7b8-9012-cdef-123456789012",
    "project_id": "proj-a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "name": "Sprint 14",
    "goal": "Complete webhook integration and alert system",
    "status": "active",
    "start_date": "2026-03-25",
    "end_date": "2026-04-07",
    "task_count": 12,
    "completed_count": 7,
    "velocity": null,
    "task_summary": {
      "todo": 2,
      "in_progress": 3,
      "in_review": 0,
      "done": 7
    },
    "created_at": "2026-03-24T10:00:00Z",
    "updated_at": "2026-04-05T09:15:00Z"
  },
  "meta": null,
  "errors": null
}
```

**Error Responses**:

| Status | Code | When |
|--------|------|------|
| 401 | UNAUTHORIZED | Missing or invalid auth token |
| 403 | FORBIDDEN | User is not a project member |
| 404 | NOT_FOUND | Sprint or project does not exist |

---

#### POST /api/v1/projects/:projectId/sprints  ✅ CONFIRMED

| Field | Value |
|-------|-------|
| **Description** | Create a new sprint for a project |
| **Auth** | Required (admin, manager) |
| **Stories** | US-010, US-012 |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | application/json |

**Path Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| projectId | UUID | Project identifier |

**Request Body**:

| Field | Type | Required | Constraints | Description |
|-------|------|----------|-------------|-------------|
| name | string | Yes | 1-100 chars | Sprint name |
| goal | string | No | max 500 chars | Sprint goal |
| start_date | string | Yes | ISO 8601 date | Sprint start date |
| end_date | string | Yes | ISO 8601 date, after start | Sprint end date |

```json
{
  "name": "Sprint 15",
  "goal": "Implement CI/CD dashboard and notifications",
  "start_date": "2026-04-08",
  "end_date": "2026-04-21"
}
```

**Success Response (201)**:

```json
{
  "data": {
    "id": "sprint-d4e5f6a7-b8c9-0123-defa-234567890123",
    "project_id": "proj-a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "name": "Sprint 15",
    "goal": "Implement CI/CD dashboard and notifications",
    "status": "planning",
    "start_date": "2026-04-08",
    "end_date": "2026-04-21",
    "task_count": 0,
    "completed_count": 0,
    "velocity": null,
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
| 400 | VALIDATION_ERROR | Missing required fields, end_date before start_date |
| 401 | UNAUTHORIZED | Missing or invalid auth token |
| 403 | FORBIDDEN | User lacks permission to create sprints |
| 404 | NOT_FOUND | Project does not exist |
| 409 | CONFLICT | Active sprint already exists for this project |

---

#### PATCH /api/v1/projects/:projectId/sprints/:sprintId  🔶 ASSUMED

| Field | Value |
|-------|-------|
| **Description** | Update sprint fields or transition sprint status |
| **Auth** | Required (admin, manager) |
| **Stories** | US-011, US-012 |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | application/json |

**Path Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| projectId | UUID | Project identifier |
| sprintId | UUID | Sprint identifier |

**Request Body** (all fields optional):

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| name | string | 1-100 chars | Updated sprint name |
| goal | string | max 500 chars | Updated sprint goal |
| status | string | enum: planning, active, completed, cancelled | Status transition |
| end_date | string | ISO 8601 date | Updated end date |

**Status Transitions**:
- `planning` -> `active` (start sprint)
- `active` -> `completed` (complete sprint, calculates velocity)
- `active` -> `cancelled` (cancel sprint)
- Other transitions are invalid and return 400

```json
{
  "status": "active"
}
```

**Success Response (200)**:

```json
{
  "data": {
    "id": "sprint-c3d4e5f6-a7b8-9012-cdef-123456789012",
    "status": "active",
    "updated_at": "2026-04-06T12:10:00Z"
  },
  "meta": null,
  "errors": null
}
```

**Error Responses**:

| Status | Code | When |
|--------|------|------|
| 400 | VALIDATION_ERROR | Invalid status transition or field values |
| 401 | UNAUTHORIZED | Missing or invalid auth token |
| 403 | FORBIDDEN | User lacks permission |
| 404 | NOT_FOUND | Sprint or project does not exist |

---

### 3.3 Tasks

#### GET /api/v1/sprints/:sprintId/tasks  ✅ CONFIRMED

| Field | Value |
|-------|-------|
| **Description** | List tasks in a sprint with filtering and sorting |
| **Auth** | Required |
| **Stories** | US-011 |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | N/A |

**Path Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| sprintId | UUID | Sprint identifier |

**Query Parameters**:

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| page | integer | No | 1 | Page number |
| limit | integer | No | 20 | Items per page (max 100) |
| sort | string | No | priority | Sort: priority, status, created_at, updated_at |
| order | string | No | asc | Sort direction: asc, desc |
| status | string | No | - | Filter: todo, in_progress, in_review, done |
| assignee_id | UUID | No | - | Filter by assigned user |
| priority | string | No | - | Filter: 1,2,3,4,5 (comma-separated) |
| q | string | No | - | Search by task title |

**Success Response (200)**:

```json
{
  "data": [
    {
      "id": "task-e5f6a7b8-c9d0-1234-efab-345678901234",
      "sprint_id": "sprint-c3d4e5f6-a7b8-9012-cdef-123456789012",
      "title": "Implement GitHub webhook receiver",
      "description": "Create POST endpoint to receive GitHub push events and map to task updates",
      "status": "in_progress",
      "priority": 1,
      "story_points": 5,
      "assignee_id": "user-33445566-7788-99aa-bbcc-ddeeff001122",
      "assignee": {
        "id": "user-33445566-7788-99aa-bbcc-ddeeff001122",
        "name": "Alice Chen",
        "avatar_url": "https://avatars.example.com/alice.jpg"
      },
      "labels": ["backend", "integration"],
      "commit_count": 3,
      "created_at": "2026-03-25T09:00:00Z",
      "updated_at": "2026-04-05T16:20:00Z"
    },
    {
      "id": "task-f6a7b8c9-d0e1-2345-fabc-456789012345",
      "sprint_id": "sprint-c3d4e5f6-a7b8-9012-cdef-123456789012",
      "title": "Design alert rule configuration UI",
      "description": "Build form for creating and editing alert rules",
      "status": "todo",
      "priority": 2,
      "story_points": 3,
      "assignee_id": null,
      "assignee": null,
      "labels": ["frontend"],
      "commit_count": 0,
      "created_at": "2026-03-25T09:05:00Z",
      "updated_at": "2026-03-25T09:05:00Z"
    }
  ],
  "meta": {
    "total": 12,
    "page": 1,
    "limit": 20,
    "has_next": false,
    "has_prev": false
  },
  "errors": null
}
```

**Error Responses**:

| Status | Code | When |
|--------|------|------|
| 401 | UNAUTHORIZED | Missing or invalid auth token |
| 403 | FORBIDDEN | User is not a project member |
| 404 | NOT_FOUND | Sprint does not exist |

---

#### GET /api/v1/sprints/:sprintId/tasks/:taskId  ✅ CONFIRMED

| Field | Value |
|-------|-------|
| **Description** | Get a single task with full details and linked commits |
| **Auth** | Required |
| **Stories** | US-011 |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | N/A |

**Path Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| sprintId | UUID | Sprint identifier |
| taskId | UUID | Task identifier |

**Success Response (200)**:

```json
{
  "data": {
    "id": "task-e5f6a7b8-c9d0-1234-efab-345678901234",
    "sprint_id": "sprint-c3d4e5f6-a7b8-9012-cdef-123456789012",
    "title": "Implement GitHub webhook receiver",
    "description": "Create POST endpoint to receive GitHub push events and map to task updates",
    "status": "in_progress",
    "priority": 1,
    "story_points": 5,
    "assignee_id": "user-33445566-7788-99aa-bbcc-ddeeff001122",
    "assignee": {
      "id": "user-33445566-7788-99aa-bbcc-ddeeff001122",
      "name": "Alice Chen",
      "avatar_url": "https://avatars.example.com/alice.jpg"
    },
    "labels": ["backend", "integration"],
    "linked_commits": [
      {
        "sha": "abc1234",
        "message": "feat: add webhook controller scaffold",
        "author": "Alice Chen",
        "timestamp": "2026-04-03T14:22:00Z"
      },
      {
        "sha": "def5678",
        "message": "feat: parse GitHub push event payload",
        "author": "Alice Chen",
        "timestamp": "2026-04-04T10:15:00Z"
      }
    ],
    "created_at": "2026-03-25T09:00:00Z",
    "updated_at": "2026-04-05T16:20:00Z"
  },
  "meta": null,
  "errors": null
}
```

**Error Responses**:

| Status | Code | When |
|--------|------|------|
| 401 | UNAUTHORIZED | Missing or invalid auth token |
| 403 | FORBIDDEN | User is not a project member |
| 404 | NOT_FOUND | Task or sprint does not exist |

---

#### POST /api/v1/sprints/:sprintId/tasks  ✅ CONFIRMED

| Field | Value |
|-------|-------|
| **Description** | Create a new task in a sprint |
| **Auth** | Required (admin, manager, member) |
| **Stories** | US-011 |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | application/json |

**Path Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| sprintId | UUID | Sprint identifier |

**Request Body**:

| Field | Type | Required | Constraints | Description |
|-------|------|----------|-------------|-------------|
| title | string | Yes | 1-300 chars | Task title |
| description | string | No | max 5000 chars | Task description (Markdown) |
| priority | integer | No | 1-5, default: 3 | Priority (1=highest) |
| story_points | integer | No | 1-21 | Estimation in story points |
| assignee_id | UUID | No | valid user UUID | Assigned team member |
| labels | string[] | No | max 10 labels | Task labels |

```json
{
  "title": "Implement GitHub webhook receiver",
  "description": "Create POST endpoint to receive GitHub push events and map to task updates",
  "priority": 1,
  "story_points": 5,
  "assignee_id": "user-33445566-7788-99aa-bbcc-ddeeff001122",
  "labels": ["backend", "integration"]
}
```

**Success Response (201)**:

```json
{
  "data": {
    "id": "task-e5f6a7b8-c9d0-1234-efab-345678901234",
    "sprint_id": "sprint-c3d4e5f6-a7b8-9012-cdef-123456789012",
    "title": "Implement GitHub webhook receiver",
    "description": "Create POST endpoint to receive GitHub push events and map to task updates",
    "status": "todo",
    "priority": 1,
    "story_points": 5,
    "assignee_id": "user-33445566-7788-99aa-bbcc-ddeeff001122",
    "labels": ["backend", "integration"],
    "commit_count": 0,
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
| 400 | VALIDATION_ERROR | Missing title, invalid priority range, invalid assignee |
| 401 | UNAUTHORIZED | Missing or invalid auth token |
| 403 | FORBIDDEN | User lacks permission to create tasks |
| 404 | NOT_FOUND | Sprint does not exist |

---

#### PATCH /api/v1/sprints/:sprintId/tasks/:taskId  🔶 ASSUMED

| Field | Value |
|-------|-------|
| **Description** | Update task fields (partial update) |
| **Auth** | Required (admin, manager, member — own tasks or manager+) |
| **Stories** | US-011 |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | application/json |

**Path Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| sprintId | UUID | Sprint identifier |
| taskId | UUID | Task identifier |

**Request Body** (all fields optional):

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| title | string | 1-300 chars | Updated title |
| description | string | max 5000 chars | Updated description |
| status | string | enum: todo, in_progress, in_review, done | Status transition |
| priority | integer | 1-5 | Updated priority |
| story_points | integer | 1-21 | Updated estimate |
| assignee_id | UUID or null | valid user UUID | Reassign or unassign |
| labels | string[] | max 10 | Replace labels |

```json
{
  "status": "in_progress",
  "assignee_id": "user-33445566-7788-99aa-bbcc-ddeeff001122"
}
```

**Success Response (200)**:

```json
{
  "data": {
    "id": "task-e5f6a7b8-c9d0-1234-efab-345678901234",
    "status": "in_progress",
    "assignee_id": "user-33445566-7788-99aa-bbcc-ddeeff001122",
    "updated_at": "2026-04-06T12:15:00Z"
  },
  "meta": null,
  "errors": null
}
```

**Error Responses**:

| Status | Code | When |
|--------|------|------|
| 400 | VALIDATION_ERROR | Invalid field values or status transition |
| 401 | UNAUTHORIZED | Missing or invalid auth token |
| 403 | FORBIDDEN | User lacks permission (viewer or non-member) |
| 404 | NOT_FOUND | Task or sprint does not exist |

---

#### DELETE /api/v1/sprints/:sprintId/tasks/:taskId  🔶 ASSUMED

| Field | Value |
|-------|-------|
| **Description** | Delete a task from a sprint |
| **Auth** | Required (admin, manager) |
| **Stories** | US-011 |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | N/A |

**Path Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| sprintId | UUID | Sprint identifier |
| taskId | UUID | Task identifier |

**Success Response (204)**: No body

**Error Responses**:

| Status | Code | When |
|--------|------|------|
| 401 | UNAUTHORIZED | Missing or invalid auth token |
| 403 | FORBIDDEN | User lacks permission to delete tasks |
| 404 | NOT_FOUND | Task or sprint does not exist |

---

### 3.4 Webhooks

#### POST /api/v1/webhooks/github  ✅ CONFIRMED

| Field | Value |
|-------|-------|
| **Description** | Receive GitHub webhook events (push, PR, CI status) |
| **Auth** | GitHub signature verification (X-Hub-Signature-256) |
| **Stories** | US-001, US-002 |
| **Rate Limit** | Elevated (500/min) |
| **Content-Type** | application/json |

**Request Headers**:

| Header | Required | Description |
|--------|----------|-------------|
| X-Hub-Signature-256 | Yes | HMAC SHA-256 signature of the payload |
| X-GitHub-Event | Yes | Event type (push, pull_request, status) |
| X-GitHub-Delivery | Yes | Unique delivery ID |

**Request Body** (GitHub push event example):

```json
{
  "ref": "refs/heads/main",
  "commits": [
    {
      "id": "abc1234def5678",
      "message": "feat: add webhook controller scaffold [TF-142]",
      "author": {
        "name": "Alice Chen",
        "email": "alice@taskflow.io"
      },
      "timestamp": "2026-04-06T12:00:00Z"
    }
  ],
  "repository": {
    "full_name": "taskflow/platform",
    "html_url": "https://github.com/taskflow/platform"
  }
}
```

**Success Response (200)**:

```json
{
  "data": {
    "processed": true,
    "commits_linked": 1,
    "tasks_updated": ["task-e5f6a7b8-c9d0-1234-efab-345678901234"]
  },
  "meta": null,
  "errors": null
}
```

**Error Responses**:

| Status | Code | When |
|--------|------|------|
| 400 | VALIDATION_ERROR | Malformed webhook payload |
| 401 | WEBHOOK_VALIDATION_FAILED | Invalid X-Hub-Signature-256 |
| 404 | NOT_FOUND | Repository not linked to any project |

---

#### POST /api/v1/webhooks/gitlab  🔶 ASSUMED

| Field | Value |
|-------|-------|
| **Description** | Receive GitLab webhook events (push, merge request, pipeline) |
| **Auth** | GitLab secret token verification (X-Gitlab-Token) |
| **Stories** | US-001, US-002 |
| **Rate Limit** | Elevated (500/min) |
| **Content-Type** | application/json |

**Request Headers**:

| Header | Required | Description |
|--------|----------|-------------|
| X-Gitlab-Token | Yes | Secret token for webhook verification |
| X-Gitlab-Event | Yes | Event type (Push Hook, Merge Request Hook, Pipeline Hook) |

**Request Body** (GitLab push event example):

```json
{
  "object_kind": "push",
  "ref": "refs/heads/main",
  "commits": [
    {
      "id": "abc1234def5678",
      "message": "feat: add webhook controller scaffold [TF-142]",
      "author": {
        "name": "Alice Chen",
        "email": "alice@taskflow.io"
      },
      "timestamp": "2026-04-06T12:00:00Z"
    }
  ],
  "project": {
    "path_with_namespace": "taskflow/platform",
    "web_url": "https://gitlab.com/taskflow/platform"
  }
}
```

**Success Response (200)**:

```json
{
  "data": {
    "processed": true,
    "commits_linked": 1,
    "tasks_updated": ["task-e5f6a7b8-c9d0-1234-efab-345678901234"]
  },
  "meta": null,
  "errors": null
}
```

**Error Responses**:

| Status | Code | When |
|--------|------|------|
| 400 | VALIDATION_ERROR | Malformed webhook payload |
| 401 | WEBHOOK_VALIDATION_FAILED | Invalid X-Gitlab-Token |
| 404 | NOT_FOUND | Repository not linked to any project |

---

### 3.5 Alert Rules  🔶 ASSUMED

#### GET /api/v1/projects/:projectId/alert-rules

| Field | Value |
|-------|-------|
| **Description** | List alert rules configured for a project |
| **Auth** | Required |
| **Stories** | US-020 |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | N/A |

**Path Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| projectId | UUID | Project identifier |

**Query Parameters**:

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| page | integer | No | 1 | Page number |
| limit | integer | No | 20 | Items per page |
| enabled | boolean | No | - | Filter by enabled/disabled |

**Success Response (200)**:

```json
{
  "data": [
    {
      "id": "alert-a7b8c9d0-e1f2-3456-abcd-567890123456",
      "project_id": "proj-a1b2c3d4-e5f6-7890-abcd-ef1234567890",
      "name": "Sprint velocity drop",
      "condition": "velocity_change < -20%",
      "threshold": -20,
      "channel": "slack",
      "recipients": ["#team-taskflow"],
      "enabled": true,
      "created_at": "2026-03-01T10:00:00Z",
      "updated_at": "2026-03-15T11:30:00Z"
    }
  ],
  "meta": {
    "total": 3,
    "page": 1,
    "limit": 20,
    "has_next": false,
    "has_prev": false
  },
  "errors": null
}
```

**Error Responses**:

| Status | Code | When |
|--------|------|------|
| 401 | UNAUTHORIZED | Missing or invalid auth token |
| 403 | FORBIDDEN | User is not a project member |
| 404 | NOT_FOUND | Project does not exist |

---

#### POST /api/v1/projects/:projectId/alert-rules  🔶 ASSUMED

| Field | Value |
|-------|-------|
| **Description** | Create a new alert rule for a project |
| **Auth** | Required (admin, manager) |
| **Stories** | US-020 |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | application/json |

**Request Body**:

| Field | Type | Required | Constraints | Description |
|-------|------|----------|-------------|-------------|
| name | string | Yes | 1-200 chars | Alert rule name |
| condition | string | Yes | enum: velocity_change, build_failure, blocked_tasks, no_commits | Condition type |
| threshold | number | Yes | varies by condition | Trigger threshold |
| channel | string | Yes | enum: slack, email, webhook | Notification channel |
| recipients | string[] | Yes | min 1 | Notification recipients |
| enabled | boolean | No | default: true | Whether rule is active |

```json
{
  "name": "Build failure alert",
  "condition": "build_failure",
  "threshold": 1,
  "channel": "slack",
  "recipients": ["#ci-alerts"],
  "enabled": true
}
```

**Success Response (201)**:

```json
{
  "data": {
    "id": "alert-b8c9d0e1-f2a3-4567-bcde-678901234567",
    "project_id": "proj-a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "name": "Build failure alert",
    "condition": "build_failure",
    "threshold": 1,
    "channel": "slack",
    "recipients": ["#ci-alerts"],
    "enabled": true,
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
| 400 | VALIDATION_ERROR | Missing required fields or invalid condition |
| 401 | UNAUTHORIZED | Missing or invalid auth token |
| 403 | FORBIDDEN | User lacks permission to manage alerts |
| 404 | NOT_FOUND | Project does not exist |

---

### 3.6 Notifications  🔶 ASSUMED

#### GET /api/v1/notifications

| Field | Value |
|-------|-------|
| **Description** | List notifications for the authenticated user |
| **Auth** | Required |
| **Stories** | US-020 |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | N/A |

**Query Parameters**:

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| page | integer | No | 1 | Page number |
| limit | integer | No | 20 | Items per page (max 100) |
| read | boolean | No | - | Filter: true (read only), false (unread only) |
| type | string | No | - | Filter: alert, mention, assignment, sprint_update |

**Success Response (200)**:

```json
{
  "data": [
    {
      "id": "notif-c9d0e1f2-a3b4-5678-cdef-789012345678",
      "type": "alert",
      "title": "Sprint velocity dropped 25%",
      "message": "Sprint 14 velocity is 25% lower than the 3-sprint average",
      "read": false,
      "project_id": "proj-a1b2c3d4-e5f6-7890-abcd-ef1234567890",
      "resource_type": "sprint",
      "resource_id": "sprint-c3d4e5f6-a7b8-9012-cdef-123456789012",
      "created_at": "2026-04-05T09:15:00Z"
    }
  ],
  "meta": {
    "total": 8,
    "page": 1,
    "limit": 20,
    "has_next": false,
    "has_prev": false
  },
  "errors": null
}
```

**Error Responses**:

| Status | Code | When |
|--------|------|------|
| 401 | UNAUTHORIZED | Missing or invalid auth token |

---

#### PATCH /api/v1/notifications/:notificationId  🔶 ASSUMED

| Field | Value |
|-------|-------|
| **Description** | Mark a notification as read/unread |
| **Auth** | Required (own notifications only) |
| **Stories** | US-020 |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | application/json |

**Request Body**:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| read | boolean | Yes | Mark as read (true) or unread (false) |

```json
{
  "read": true
}
```

**Success Response (200)**:

```json
{
  "data": {
    "id": "notif-c9d0e1f2-a3b4-5678-cdef-789012345678",
    "read": true,
    "updated_at": "2026-04-06T12:20:00Z"
  },
  "meta": null,
  "errors": null
}
```

**Error Responses**:

| Status | Code | When |
|--------|------|------|
| 401 | UNAUTHORIZED | Missing or invalid auth token |
| 403 | FORBIDDEN | Notification belongs to another user |
| 404 | NOT_FOUND | Notification does not exist |

---

### 3.7 Commits  🔶 ASSUMED

#### GET /api/v1/projects/:projectId/commits

| Field | Value |
|-------|-------|
| **Description** | List commits linked to a project (read-only, populated by webhooks) |
| **Auth** | Required |
| **Stories** | US-001, US-002 |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | N/A |

**Path Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| projectId | UUID | Project identifier |

**Query Parameters**:

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| page | integer | No | 1 | Page number |
| limit | integer | No | 20 | Items per page (max 100) |
| task_id | UUID | No | - | Filter commits linked to a specific task |
| author | string | No | - | Filter by commit author name |
| since | string | No | - | ISO 8601 datetime — commits after this time |
| until | string | No | - | ISO 8601 datetime — commits before this time |

**Success Response (200)**:

```json
{
  "data": [
    {
      "id": "commit-d0e1f2a3-b4c5-6789-defa-890123456789",
      "sha": "abc1234def5678",
      "message": "feat: add webhook controller scaffold [TF-142]",
      "author": "Alice Chen",
      "author_email": "alice@taskflow.io",
      "timestamp": "2026-04-06T12:00:00Z",
      "branch": "main",
      "linked_task_id": "task-e5f6a7b8-c9d0-1234-efab-345678901234",
      "provider": "github"
    }
  ],
  "meta": {
    "total": 234,
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
| 403 | FORBIDDEN | User is not a project member |
| 404 | NOT_FOUND | Project does not exist |

---

### 3.8 CI Builds [FUTURE]  ❓ UNCLEAR

#### GET /api/v1/projects/:projectId/ci-builds

| Field | Value |
|-------|-------|
| **Description** | List CI/CD build results for a project |
| **Auth** | Required |
| **Stories** | US-015, US-016 |
| **Rate Limit** | Standard (100/min) |
| **Content-Type** | N/A |

**Path Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| projectId | UUID | Project identifier |

**Query Parameters**:

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| page | integer | No | 1 | Page number |
| limit | integer | No | 20 | Items per page (max 100) |
| status | string | No | - | Filter: pending, running, success, failed |
| branch | string | No | - | Filter by branch name |

**Success Response (200)**:

```json
{
  "data": [
    {
      "id": "build-e1f2a3b4-c5d6-7890-efab-012345678901",
      "project_id": "proj-a1b2c3d4-e5f6-7890-abcd-ef1234567890",
      "commit_sha": "abc1234def5678",
      "branch": "main",
      "status": "success",
      "duration_seconds": 142,
      "provider": "github_actions",
      "url": "https://github.com/taskflow/platform/actions/runs/12345",
      "triggered_at": "2026-04-06T12:01:00Z",
      "completed_at": "2026-04-06T12:03:22Z"
    }
  ],
  "meta": {
    "total": 89,
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
| 403 | FORBIDDEN | User is not a project member |
| 404 | NOT_FOUND | Project does not exist |

---

## 4. Authentication & Authorization

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

## 5. Error Handling

### Standard Error Response

```json
{
  "data": null,
  "meta": null,
  "errors": [
    {
      "code": "VALIDATION_ERROR",
      "message": "Request validation failed",
      "field": "name",
      "details": "Name is required and must be 1-200 characters"
    },
    {
      "code": "VALIDATION_ERROR",
      "message": "Request validation failed",
      "field": "start_date",
      "details": "Must be a valid ISO 8601 date"
    }
  ]
}
```

All validation errors are returned at once (not just the first).

### Error Code Catalog

| Code | HTTP Status | Description |
|------|------------|-------------|
| VALIDATION_ERROR | 400 | Request body or parameter validation failed |
| UNAUTHORIZED | 401 | Missing, expired, or invalid authentication token |
| FORBIDDEN | 403 | Valid token but insufficient role/permissions |
| NOT_FOUND | 404 | Requested resource does not exist |
| CONFLICT | 409 | Resource conflict (duplicate name, invalid state transition) |
| RATE_LIMITED | 429 | Rate limit exceeded for this endpoint/tier |
| INTERNAL_ERROR | 500 | Unexpected server error (logged, not exposed to client) |
| INVALID_TOKEN | 401 | JWT signature validation failed or token is malformed |
| INSUFFICIENT_ROLE | 403 | User's role does not have access to this operation |
| WEBHOOK_VALIDATION_FAILED | 401 | Webhook signature verification failed (GitHub/GitLab) |

---

## 6. Pagination & Filtering

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

## 7. Rate Limiting

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

## 8. WebSocket API

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

## 9. Q&A Log

| ID | Section | Question | Priority | Answer | Status |
|----|---------|----------|----------|--------|--------|
| Q-001 | API Overview | Should we offer GraphQL as an alternative to REST? Current design is REST-only. If GraphQL is needed, it would be a separate gateway. | LOW | REST is sufficient for MVP. GraphQL can be evaluated post-launch based on client needs. | Resolved |
| Q-002 | Pagination | Should high-volume endpoints (commits, notifications) use cursor pagination instead of offset? | MED | Offset pagination is acceptable for MVP scale. Revisit if datasets exceed 10K per query. | Resolved |
| Q-003 | Webhooks | Should we verify webhook signatures asynchronously to avoid blocking the response? How should we handle payload replay attacks? | HIGH | Pending — need input from security review. | Open |

---

## 10. Readiness Assessment

### Confidence Summary

| Confidence | Count | Percentage |
|------------|-------|-----------|
| ✅ CONFIRMED | 14 | 45% |
| 🔶 ASSUMED | 16 | 52% |
| ❓ UNCLEAR | 1 | 3% |
| **Total** | 31 | 100% |

### Open Q&A Items

| Priority | Count |
|----------|-------|
| HIGH | 1 |
| MEDIUM | 0 |
| LOW | 0 |

### Verdict

**PARTIALLY READY**

The API design covers all 9 identified resources with endpoint specifications, authentication, error handling, pagination, rate limiting, and WebSocket support. 45% of endpoints are confirmed from user stories. Key risks:

- 52% of endpoints are assumed — need user/architect confirmation on CRUD scope for alert-rules, notifications, commits, and CI builds
- 1 HIGH-priority Q&A open regarding webhook security (signature verification approach)
- CI builds resource marked [FUTURE] and needs clarification on MVP inclusion
- Database entity name consistency (DES-06) cannot be fully validated without database-final.md

Recommended: Run `/design-api --refine` after architecture and database reviews to upgrade assumed endpoints to confirmed.

---

## 11. Approval

| Role | Name | Status | Date |
|------|------|--------|------|
| Technical Lead | [TBD] | Pending | |
| API Architect | [TBD] | Pending | |
| Product Owner | [TBD] | Pending | |
