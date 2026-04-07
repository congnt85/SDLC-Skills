---
name: design-api
description: >
  Create or refine an API design document. Defines REST API endpoints, request/response
  schemas, authentication, error handling, and pagination. Every endpoint traces to
  user stories and acceptance criteria.
  ONLY activated by commands: `/design-api` (create) or `/design-api-refine` (refine).
  NEVER auto-trigger based on keywords.
argument-hint: "[path to architecture-final.md or userstories-final.md]"
version: "1.0"
category: sdlc
phase: design
prev_phase: design-arch
next_phase: design-adr
---

# API Design Skill

## Purpose

Create or refine an API design document (`api-draft.md`) with full REST API specification —
endpoints, request/response payloads, authentication, error handling, pagination, and rate limiting.
Every endpoint traces to user stories and architecture components.

---

## Two Modes

### Mode 1: Create (`/design-api`)

Generate a new API design document from architecture, user stories, and tech stack artifacts.

| Input | Required | Source |
|-------|----------|--------|
| architecture-final.md | ✅ | `design/final/` or user-specified path |
| userstories-final.md | ✅ | `req/final/` or user-specified path |
| tech-stack-final.md | ✅ | `design/final/` or user-specified path |
| database-final.md | No | `design/final/` — entity names for consistency (DES-06) |
| scope-final.md | No | `init/final/` — quality attributes for rate limiting, performance |
| backlog-final.md | No | `req/final/` — MVP boundary for v1 API scope |

### Mode 2: Refine (`/design-api-refine`)

Improve an existing API design document based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing API draft | ✅ | `draft/api-draft.md` or `draft/api-v{N}.md` |
| Review report / feedback | ✅ | User provides directly or as `input/review-report.md` |
| Additional context | No | New information the user wants to incorporate |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `api-draft.md` | `draft/` |
| Refine | `api-v{N}.md` | `draft/` (N = next version number) |

When user is satisfied → they copy from `draft/` to `design/final/api-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User runs `/design-api-refine` AND existing draft exists in `draft/` → **Mode 2 (Refine)**
- User runs `/design-api` → **Mode 1 (Create)**
- User runs `/design-api` but draft already exists → Ask: "A draft already exists. Create new (overwrite) or refine existing?"

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md` — document formatting standards
2. `skills/shared/rules/quality-rules.md` — confidence marking, readiness assessment
3. `skills/shared/rules/output-rules.md` — versioning, input resolution, diff summary
4. `design/shared/rules/design-rules.md` — design phase rules
5. `design/shared/templates/api/endpoint-template.md` — standard endpoint format
6. `design/api/knowledge/api-design-guide.md` — REST API design techniques
7. `design/api/rules/output-rules.md` — API-specific output rules
8. `design/api/templates/output-template.md` — expected output structure

### Step 3: Resolve Input

**Mode 1 (Create):**

```
For architecture-final.md (REQUIRED):
1. User specified path? → Read it, copy to input/
2. Exists in input/architecture-final.md? → Read it
3. Exists in design/final/architecture-final.md? → Read it, copy to input/
4. Not found? → FAIL: "No architecture document found. Run /design-arch first."

For userstories-final.md (REQUIRED):
1. User specified path? → Read it, copy to input/
2. Exists in input/userstories-final.md? → Read it
3. Exists in req/final/userstories-final.md? → Read it, copy to input/
4. Not found? → FAIL: "No user stories document found. Run /req-userstory first."

For tech-stack-final.md (REQUIRED):
1. User specified path? → Read it, copy to input/
2. Exists in input/tech-stack-final.md? → Read it
3. Exists in design/final/tech-stack-final.md? → Read it, copy to input/
4. Not found? → FAIL: "No tech stack document found. Run /design-stack first."

For optional inputs (database, scope, backlog):
1. Check input/ folder first
2. Check respective final/ folders (design/final/, init/final/, req/final/)
3. If found → copy to input/ for traceability
4. If not found → proceed without, note missing context in Q&A
```

**Mode 2 (Refine):**

```
For API draft:
1. User specified path? → Read it, copy to input/
2. Exists in input/? → Read it
3. Exists in draft/ (latest version)? → Read it, copy to input/
4. Not found? → FAIL: "No existing API document found. Run /design-api first."

For review report:
1. User provided feedback directly in message? → Save to input/review-report.md
2. User specified path? → Read it, copy to input/
3. Exists in input/review-report.md? → Read it
4. Not found? → Ask: "What feedback do you have on the current API design?"
```

### Step 4: Generate (Mode-specific)

**Mode 1 — Create:**

Work through the API document **section by section**:

1. **API Overview** — Determine base URL, versioning strategy (URL path /api/v1/), authentication approach (from tech-stack), common headers, and response envelope format. Confirm with user.

2. **Resource Inventory** — Extract all REST resources from architecture entities and user stories. Map database entities to plural resource names (DES-06). Decide nested vs flat URLs based on ownership relationships. Tag each resource as MVP or [FUTURE] based on backlog priority.
   - Ask: "Are there any resources I've missed or any that should be combined/split?"

3. **Endpoint Specifications** — For each resource, define endpoints using `endpoint-template.md` format:
   - Method, path, description, auth requirement, source stories (US-xxx)
   - Rate limit tier
   - Request: headers, path params, query params (for lists), body (for create/update)
   - Response: success with example JSON, error responses with status codes
   - Confidence markers on each endpoint
   - Present each resource's endpoints to user before continuing

4. **Authentication & Authorization** — Document auth flow (from tech-stack), token format, token lifecycle. Build role-based permissions matrix mapping roles to endpoint access (CRUD per resource).
   - Ask: "Are these roles and permissions accurate?"

5. **Error Handling** — Define standard error response format using envelope pattern. Build error code catalog with HTTP status mapping. Document field-level validation error format.

6. **Pagination & Filtering** — Choose pagination approach (offset vs cursor). Define standard query parameters for listing endpoints (page, limit, sort, order, filter). Show example request and response with meta.

7. **Rate Limiting** — Define rate limit tiers (anonymous, authenticated, elevated). Specify per-endpoint overrides where needed. Document rate limit response headers.

8. **WebSocket API** — If real-time features exist in architecture/stories: define WebSocket connection, authentication, channels, events, and message format.
   - Skip this section if no real-time features are identified

For each section:
- Apply confidence markers (✅ CONFIRMED / 🔶 ASSUMED / ❓ UNCLEAR)
- Create Q&A entries for ASSUMED and UNCLEAR items
- Present section to user before moving to next

**Mode 2 — Refine:**

1. Read existing API draft (baseline)
2. Read review report / user feedback
3. Run Quality Scorecard analysis (completeness, endpoint coverage, auth coverage, error handling, traceability)
4. Present scorecard to user: "Here's what I found in the current API design..."
5. Apply improvements:
   - Address user feedback point by point
   - Resolve Q&A entries from previous version
   - Upgrade confidence levels where possible (🔶→✅, ❓→🔶)
   - Add missing endpoints, error codes, or auth rules
   - Proactively suggest improvements for weak areas
6. Tag all changes: `[UPDATED]` for modified items, `[NEW]` for additions
7. Preserve CONFIRMED items unless user explicitly contradicts them
8. Write improved version to `draft/api-v{N}.md`

### Step 5: Validate Output

Check against rules:
- Every endpoint has method, path, description, auth, and source stories (API-01)
- Resource names are plural nouns in kebab-case (API-02)
- URL versioning /api/v1/ used (API-03)
- Every endpoint has success response with example JSON (API-04)
- Every endpoint lists applicable error responses (API-05)
- List endpoints support pagination (API-06)
- Consistent response envelope { data, meta, errors } (API-07)
- Rate limits specified for public and high-traffic endpoints (API-08)
- Authentication mechanism documented (API-09)
- Resource names match database entity names (API-10, DES-06)
- Correct section order (API-11)
- Confidence markers on every endpoint (API-12)
- Quality scorecard first in refine mode (API-13)
- MVP endpoints identified, non-MVP tagged [FUTURE] (API-14)
- Request bodies show required vs optional fields (API-15)
- Request content type specified (API-16)
- All endpoints trace to requirements (DES-02)
- Entity names consistent across artifacts (DES-06)
- Standard notations used (DES-04)
- Mermaid diagrams included where helpful (DES-08)

### Step 6: Readiness Assessment

Generate assessment per `skills/shared/templates/readiness-assessment.md`:
- Count items by confidence level
- Calculate readiness verdict
- In refine mode: compare with previous version

### Step 7: Output

- **Create mode**: Write to `draft/api-draft.md`
- **Refine mode**: Write to `draft/api-v{N}.md`, include Change Log and Diff Summary

Tell the user:
> **API design {created/refined}!**
> - Output: `draft/api-{version}.md`
> - Readiness: {verdict}
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/design-api-refine`
> - When satisfied, copy to `design/final/api-final.md`
> - Then run `/design-adr` to capture key API decisions as ADRs

---

## Scope Rules

### This skill DOES:
- Design REST API contracts, endpoints, and payloads
- Define request/response schemas with example JSON
- Document authentication and authorization flows
- Specify error handling with standard error codes
- Define pagination, filtering, and sorting approaches
- Set rate limiting tiers and per-endpoint limits
- Design WebSocket events for real-time features
- Trace every endpoint to user stories (US-xxx)
- Apply confidence marking to every endpoint specification

### This skill does NOT:
- Implement API endpoints or write server code (belongs to `impl` phase)
- Design database schema or ERDs (belongs to `design-db` skill)
- Define system architecture or service boundaries (belongs to `design-arch` skill)
- Select API frameworks or technologies (belongs to `design-stack` skill)
- Write Architecture Decision Records (belongs to `design-adr` skill)
- Define deployment or infrastructure (belongs to `deploy` phase)
- Design monitoring or alerting for APIs (belongs to `ops` phase)
