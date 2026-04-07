# Output Rules — design/api

API-specific output constraints. These supplement the project-wide rules in `skills/shared/rules/` and the design phase rules in `design/shared/rules/design-rules.md`.

---

## Endpoint Content Rules

### API-01: Endpoint Specification Required Fields
Every endpoint MUST specify:
- HTTP method (GET, POST, PUT, PATCH, DELETE)
- Full path (e.g., `/api/v1/projects/:projectId`)
- Description of what the endpoint does
- Auth requirement (Required / Public)
- Source user stories (US-xxx references)

Endpoints missing any of these fields are incomplete.

### API-02: Resource Naming Convention
Resource names MUST be:
- Plural nouns: `/projects`, `/tasks`, `/sprints`
- Kebab-case for multi-word: `/alert-rules`, `/ci-builds`, `/project-members`
- Lowercase only: never `/Projects` or `/TASKS`
- Never verbs: `/create-task` is wrong; `POST /tasks` is correct

### API-03: URL Versioning Required
All endpoints MUST use URL path versioning: `/api/v1/`.
Header-based or query-parameter versioning is not acceptable.

### API-04: Success Response Examples
Every endpoint MUST include a success response with:
- HTTP status code (200, 201, 204)
- Example JSON body showing realistic data
- Response MUST use the standard envelope format

### API-05: Error Response Coverage
Every endpoint MUST list applicable error responses with:
- HTTP status code
- Error code (machine-readable, UPPER_SNAKE_CASE)
- Description of when this error occurs

At minimum: 401 (if auth required), 404 (for by-ID endpoints), 400/422 (for create/update).

### API-06: Pagination Required for Lists
Every list endpoint (GET that returns a collection) MUST support pagination:
- Query parameters: `page`, `limit` (offset) or `after`, `before` (cursor)
- Response meta MUST include: `total`, `page`, `limit`, `has_next` (or cursor equivalents)
- Default limit: 20. Maximum limit: 100.

### API-07: Consistent Response Envelope
ALL responses MUST use the standard envelope format:
```json
{
  "data": { ... } | [ ... ] | null,
  "meta": { ... } | null,
  "errors": null | [{ "code": "...", "message": "...", "field": "..." }]
}
```

- Success: `data` populated, `errors` null
- Error: `data` null, `errors` populated
- Collections: `data` is array, `meta` has pagination info

### API-08: Rate Limiting Specification
Rate limits MUST be specified for:
- All public (unauthenticated) endpoints
- All high-traffic endpoints (list endpoints, search, webhooks)
- Auth endpoints (login, token refresh) — with lower limits

Each rate limit MUST specify: requests per time window (e.g., "100/min").

### API-09: Authentication Documentation
The API design MUST document:
- Authentication mechanism (Bearer JWT, API Key, OAuth2)
- Token format and claims (for JWT)
- Token lifecycle (access token expiry, refresh flow)
- How to include credentials in requests (header name, format)

---

## Consistency Rules

### API-10: Resource-Entity Name Consistency
Resource names MUST match database entity names per DES-06:
- Database table `tasks` → API resource `/tasks`
- Database table `alert_rules` → API resource `/alert-rules`
- Database table `ci_builds` → API resource `/ci-builds`

If database-final.md is available, cross-reference every resource name. Flag mismatches as errors.

---

## Format Rules

### API-11: Section Order
API output MUST follow this section order:
1. API Overview
2. Resource Inventory
3. Endpoint Specifications
4. Authentication & Authorization
5. Error Handling
6. Pagination & Filtering
7. Rate Limiting
8. WebSocket API (if applicable — omit if no real-time features)
9. Q&A Log
10. Readiness Assessment
11. Approval

Do not add, remove, or reorder sections (except WebSocket which is conditional).

### API-12: Confidence Markers on Endpoints
Every endpoint specification MUST have a confidence marker:
- ✅ CONFIRMED — endpoint confirmed by user or clearly derived from confirmed stories
- 🔶 ASSUMED — endpoint inferred from architecture/stories but not explicitly confirmed
- ❓ UNCLEAR — endpoint may or may not be needed; requires clarification

### API-13: Refine Mode Quality Scorecard
In refine mode, BEFORE applying changes, generate a Quality Scorecard covering:
- Completeness: Are all resources covered with CRUD endpoints?
- Auth coverage: Does every endpoint specify auth requirements?
- Error coverage: Does every endpoint list applicable errors?
- Traceability: Does every endpoint trace to user stories?
- Consistency: Do resource names match database entities?
- Pagination: Do all list endpoints support pagination?

Present this scorecard to the user before asking what to improve.

### API-14: MVP Scope Tagging
- MVP endpoints MUST be clearly identified (default — no tag needed)
- Non-MVP endpoints MUST be tagged with `[FUTURE]`
- The Resource Inventory table MUST have a "MVP" column (Yes/No)
- If backlog-final.md is available, align MVP boundary with backlog priorities

### API-15: Request Body Documentation
Request body examples for POST/PUT/PATCH MUST:
- Show required fields clearly (annotated or in a separate table)
- Show optional fields with default values
- Include type information (string, integer, boolean, enum values)
- Include constraint information (min/max length, value ranges)

### API-16: Content Type Specification
Every endpoint that accepts a request body MUST specify its content type:
- `application/json` — for standard JSON payloads
- `multipart/form-data` — for file uploads
- Other content types as applicable

---

## Refine Mode Rules

### API-13a: TBD Reduction Target
Each refine round should aim to reduce [TBD] and ❓ UNCLEAR counts by at least 30%.
If no TBDs were resolved, flag this in the Diff Summary.

### API-13b: Change Tracking
In refine mode, all changes MUST be tagged:
- `[UPDATED]` — modified from previous version
- `[NEW]` — added in this version
- `[REMOVED]` — deleted from previous version (document in Change Log)
