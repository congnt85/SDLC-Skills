---
name: design-api
description: >
  Create or refine an API design document. Defines REST API endpoints, request/response
  schemas, and error handling. Every endpoint traces to user stories and acceptance criteria.
  Auth, pagination, rate limiting, and WebSocket specs are handled by /design-api-security.
  ONLY activated by command: `/design-api`. Use `--create`, `--refine`, or `--score` to set mode.
  NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine|--score"
version: "1.1"
category: sdlc
phase: design
prev_phase: design-arch
next_phase: design-api-security
---

# API Design Skill

## Purpose

Create or refine an API design document (`api-draft.md`) with REST API endpoint specifications
and error handling. Every endpoint traces to user stories and architecture components.
Authentication, authorization, pagination, rate limiting, and WebSocket specs are
produced separately by `/design-api-security`.

---

## Three Modes

### Mode 1: Create (`--create`)

Generate a new API design document from architecture, user stories, and tech stack artifacts.

| Input | Required | Source |
|-------|----------|--------|
| architecture-final.md | ✅ | `sdlc/design/final/` or user-specified path |
| userstories-final.md | ✅ | `sdlc/req/final/` or user-specified path |
| tech-stack-final.md | ✅ | `sdlc/design/final/` or user-specified path |
| database-final.md | No | `sdlc/design/final/` — entity names for consistency (DES-06) |
| scope-final.md | No | `sdlc/init/final/` — quality attributes for rate limiting, performance |
| backlog-final.md | No | `sdlc/req/final/` — MVP boundary for v1 API scope |

### Mode 2: Refine (`--refine`)

Improve an existing API design document based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing API draft | ✅ | `sdlc/design/draft/api-draft.md` or `sdlc/design/draft/api-v{N}.md` |
| Review report / feedback | ✅ | User provides directly or as `sdlc/design/input/review-report.md` |
| Additional context | No | New information the user wants to incorporate |

### Mode 3: Score (`--score`)

Evaluate artifact quality with a detailed scoreboard.

| Input | Required | Source |
|-------|----------|--------|
| Artifact to score | Yes | `sdlc/design/draft/api-design-draft.md` or latest `api-design-v{N}.md` or `sdlc/design/final/api-design-final.md`, or user-specified path |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `api-draft.md` | `sdlc/design/draft/` |
| Refine | `api-v{N}.md` | `sdlc/design/draft/` (N = next version number) |
| Score | `api-design-scoreboard.md` | `sdlc/design/draft/` |

When user is satisfied → they copy from `sdlc/design/draft/` to `sdlc/design/final/api-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User passes `--score` argument → **Mode 3 (Score)**
- User passes `--refine` argument → **Mode 2 (Refine)**
- User passes `--create` argument → **Mode 1 (Create)**
- No argument specified AND existing draft exists in `sdlc/design/draft/` → Ask: "A draft already exists. Use `--create` to start fresh or `--refine` to improve it."
- No argument specified AND no draft exists → **Mode 1 (Create)**

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
For Mode 3 (Score): Read resources listed in `skills/shared/knowledge/score-workflow.md`

### Step 3: Resolve Input

Resolve inputs per `skills/shared/knowledge/input-resolution-workflow.md`.

**Create mode inputs:**

| Input | Required | Default Path | Fallback |
|-------|----------|-------------|----------|
| architecture-final.md | Yes | `sdlc/design/final/` | "No architecture document found. Run /design-arch first." |
| userstories-final.md | Yes | `sdlc/req/final/` | "No user stories document found. Run /req-userstory first." |
| tech-stack-final.md | Yes | `sdlc/design/final/` | "No tech stack document found. Run /design-stack first." |
| database-final.md | No | `sdlc/design/final/` | Proceed without, note missing context in Q&A |
| scope-final.md | No | `sdlc/init/final/` | Proceed without, note missing context in Q&A |
| backlog-final.md | No | `sdlc/req/final/` | Proceed without, note missing context in Q&A |

**Refine mode inputs:**

| Input | Required | Source |
|-------|----------|--------|
| Existing draft | Yes | `sdlc/design/draft/api-draft.md` or latest `api-v{N}.md` |
| Review feedback | Yes | User message or `sdlc/design/input/review-report.md` |

### Step 4: Generate (Mode-specific)

**Mode 1 — Create:**

Work through the API document **section by section**:

1. **API Overview** — Determine base URL, versioning strategy (URL path /api/v1/), authentication approach (from tech-stack), common headers, and response envelope format. Confirm with user.

2. **Resource Inventory** — Extract all REST resources from architecture entities and user stories. Map database entities to plural resource names (DES-06). Decide nested vs flat URLs based on ownership relationships. Tag each resource as MVP or [FUTURE] based on backlog priority.
   - Ask: "Are there any resources I've missed or any that should be combined/split?"

3. **Endpoint Specifications** — For each resource, define endpoints using `endpoint-template.md` format:
   - Method, path, description, auth requirement, source stories (US-xxx)
   - Request: headers, path params, query params (for lists), body (for create/update)
   - Response: success with example JSON, error responses with status codes
   - Confidence markers on each endpoint
   - Present each resource's endpoints to user before continuing

4. **Error Handling** — Define standard error response format using envelope pattern. Build error code catalog with HTTP status mapping. Document field-level validation error format.

> **Note:** Authentication flows, role permissions, pagination strategy, rate limiting tiers,
> and WebSocket API are NOT part of this skill. They are handled by `/design-api-security`.

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
8. Write improved version to `sdlc/design/draft/api-v{N}.md`

**Mode 3 -- Score:**

Follow the standard score workflow in `skills/shared/knowledge/score-workflow.md` using this skill's rules and templates as context.

### Step 5: Validate Output

Check against rules:
- Every endpoint has method, path, description, auth, and source stories (API-01)
- Resource names are plural nouns in kebab-case (API-02)
- URL versioning /api/v1/ used (API-03)
- Every endpoint has success response with example JSON (API-04)
- Every endpoint lists applicable error responses (API-05)
- List endpoints support pagination (API-06)
- Consistent response envelope { data, meta, errors } (API-07)
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

- **Create mode**: Write to `sdlc/design/draft/api-draft.md`
- **Refine mode**: Write to `sdlc/design/draft/api-v{N}.md`, include Change Log and Diff Summary

**Mode 3 (Score):** Output per score workflow — `sdlc/design/draft/api-design-scoreboard.md`

Tell the user:
> **API design {created/refined}!**
> - Output: `sdlc/design/draft/api-{version}.md`
> - Readiness: {verdict}
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/design-api --refine`
> - When satisfied, copy to `sdlc/design/final/api-final.md`
> - Then run `/design-api-security` to define auth, pagination, rate limiting, and WebSocket specs
> - Then run `/design-adr` to capture key API decisions as ADRs

---

## Scope Rules

### This skill DOES:
- Design REST API contracts, endpoints, and payloads
- Define request/response schemas with example JSON
- Specify error handling with standard error codes
- Trace every endpoint to user stories (US-xxx)
- Apply confidence marking to every endpoint specification

### This skill does NOT:
- Document authentication and authorization flows (belongs to `/design-api-security`)
- Define pagination, filtering, and sorting strategies (belongs to `/design-api-security`)
- Set rate limiting tiers and per-endpoint limits (belongs to `/design-api-security`)
- Design WebSocket events for real-time features (belongs to `/design-api-security`)
- Implement API endpoints or write server code (belongs to `impl` phase)
- Design database schema or ERDs (belongs to `design-db` skill)
- Define system architecture or service boundaries (belongs to `design-arch` skill)
- Select API frameworks or technologies (belongs to `design-stack` skill)
- Write Architecture Decision Records (belongs to `design-adr` skill)
- Define deployment or infrastructure (belongs to `deploy` phase)
- Design monitoring or alerting for APIs (belongs to `ops` phase)
