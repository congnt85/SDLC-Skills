---
name: design-api
description: >
  Create or refine an API design document. Defines REST API endpoints, request/response
  schemas, authentication, error handling, and pagination. Every endpoint traces to
  user stories and acceptance criteria.
  ONLY activated by command: `/design-api`. Use `--create`, `--refine`, or `--score` to set mode.
  NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine|--score"
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
9. `skills/shared/knowledge/scoring-guide.md` — scoring methodology (Mode 3 only)
10. `skills/shared/rules/scoring-rules.md` — scoring output rules (Mode 3 only)
11. `skills/shared/templates/scoreboard-output-template.md` — scoreboard format (Mode 3 only)

### Step 3: Resolve Input

**File Type Conversion** (applies to all file inputs):

Before reading any input file, check its extension:
- `.md` → Read directly, no conversion needed
- `.pdf` → Run `/read-pdf <path> sdlc/design/input/` → read the converted .md
- `.docx` / `.doc` → Run `/read-word <path> sdlc/design/input/` → read the converted .md
- `.xlsx` / `.xls` → Run `/read-excel <path> sdlc/design/input/` → read the converted .md
- `.pptx` / `.ppt` → Run `/read-ppt <path> sdlc/design/input/` → read the converted .md

Converted files are saved to `sdlc/design/input/`. If a converted .md already exists and is newer than the source, skip conversion.

Note: Files auto-resolved from `sdlc/` pipeline are always .md and skip conversion.

**Mode 1 (Create):**

```
For architecture-final.md (REQUIRED):
1. Exists in sdlc/design/final/architecture-final.md? → Read it, copy to sdlc/design/input/
2. User specified a different path? → Read it, convert if needed
3. Exists in sdlc/design/input/architecture-final.md? → Read it
4. Not found? → FAIL: "No architecture document found. Run /design-arch first."

For userstories-final.md (REQUIRED):
1. Exists in sdlc/req/final/userstories-final.md? → Read it, copy to sdlc/design/input/
2. User specified a different path? → Read it, convert if needed
3. Exists in sdlc/design/input/userstories-final.md? → Read it
4. Not found? → FAIL: "No user stories document found. Run /req-userstory first."

For tech-stack-final.md (REQUIRED):
1. Exists in sdlc/design/final/tech-stack-final.md? → Read it, copy to sdlc/design/input/
2. User specified a different path? → Read it, convert if needed
3. Exists in sdlc/design/input/tech-stack-final.md? → Read it
4. Not found? → FAIL: "No tech stack document found. Run /design-stack first."

For optional inputs (database, scope, backlog):
1. Check respective final/ folders first (sdlc/design/final/, sdlc/init/final/, sdlc/req/final/)
2. User specified a different path? → Read it, convert if needed
3. Check sdlc/design/input/ folder
4. If found → copy to sdlc/design/input/ for traceability
5. If not found → proceed without, note missing context in Q&A
```

**Mode 2 (Refine):**

```
For API draft:
1. User specified path? → Read it, copy to sdlc/design/input/
2. Exists in sdlc/design/input/? → Read it
3. Exists in sdlc/design/draft/ (latest version)? → Read it, copy to sdlc/design/input/
4. Not found? → FAIL: "No existing API document found. Run /design-api first."

For review report:
1. User provided feedback directly in message? → Save to sdlc/design/input/review-report.md
2. User specified path? → Read it, copy to sdlc/design/input/
3. Exists in sdlc/design/input/review-report.md? → Read it
4. Not found? → Ask: "What feedback do you have on the current API design?"
```

**Mode 3 (Score):**

```
For artifact to score (required):
1. User specified a path?                                     → Read it → DONE
2. Exists in sdlc/design/final/api-design-final.md?           → Read it → DONE
3. Exists as sdlc/design/draft/api-design-v{N}.md (latest N)? → Read it → DONE
4. Exists as sdlc/design/draft/api-design-draft.md?           → Read it → DONE
5. Not found? → Ask: "Provide the path to the artifact to score."
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
8. Write improved version to `sdlc/design/draft/api-v{N}.md`

**Mode 3 -- Score:**

1. **Read Context** — Read this skill's own `templates/output-template.md` and `rules/output-rules.md` to understand expected structure and quality constraints.

2. **Score Each Dimension** — Evaluate the artifact against all 5 quality dimensions (Completeness, Clarity, Consistency, Quantification, Traceability):
   - For each dimension, cite at least 2 specific evidence items from the artifact
   - Score using criteria from `skills/shared/knowledge/scoring-guide.md`
   - Record issues found during scoring

3. **Check Skill Rules Compliance** — For each rule in this skill's `rules/output-rules.md`:
   - ✅ PASS — artifact fully complies
   - ❌ FAIL — artifact clearly violates
   - ⚠️ PARTIAL — artifact partially complies

4. **Compile Issues** — Gather all issues from dimension scoring and rules compliance:
   - Assign severity: HIGH / MED / LOW
   - Link each to its dimension and artifact section

5. **Generate Recommendations** — 3-7 actionable recommendations:
   - HIGH severity issues first, then lowest-scoring dimensions
   - Each specifies: what to change, where, expected result

6. **Calculate Summary** — Average score, lowest/highest dimensions, overall verdict (🟢 Strong ≥4.0 / 🟡 Adequate 3.0-3.9 / 🔴 Needs Work <3.0)

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

**Mode 3 (Score) — additional checks:**
- All 5 dimensions scored with evidence (SCR-01, SCR-02)
- Integer scores 1-5 (SCR-03)
- Issues linked to dimensions and sections (SCR-04, SCR-05)
- Recommendations are actionable, 3-7 count (SCR-06, SCR-07)
- Scoring used this skill's own rules/templates as context (SCR-08)
- Rules compliance section present (SCR-10)

### Step 6: Readiness Assessment

Generate assessment per `skills/shared/templates/readiness-assessment.md`:
- Count items by confidence level
- Calculate readiness verdict
- In refine mode: compare with previous version

### Step 7: Output

- **Create mode**: Write to `sdlc/design/draft/api-draft.md`
- **Refine mode**: Write to `sdlc/design/draft/api-v{N}.md`, include Change Log and Diff Summary

**Mode 3 (Score):**

- Write to `sdlc/design/draft/api-design-scoreboard.md`

Tell the user:
> **Scoreboard complete!**
> - Output: `sdlc/design/draft/api-design-scoreboard.md`
> - Average: {avg}/5 — {verdict}
> - Lowest: {dimension} ({score}/5)
> - Issues: {N} (HIGH: {H}, MED: {M}, LOW: {L})
>
> **Next steps:**
> - Run `/design-api --refine` to address issues
> - Or run `/skill-evolution --analyze design/api` to improve the skill definition itself

Tell the user:
> **API design {created/refined}!**
> - Output: `sdlc/design/draft/api-{version}.md`
> - Readiness: {verdict}
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/design-api --refine`
> - When satisfied, copy to `sdlc/design/final/api-final.md`
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
