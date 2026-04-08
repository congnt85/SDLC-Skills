---
name: design-api-security
description: >
  Create or refine API security and contract specifications — authentication,
  authorization, pagination, rate limiting, and WebSocket events. Supplements
  the core API endpoints document produced by /design-api.
  ONLY activated by command: `/design-api-security`. Use `--create`, `--refine`, or `--score` to set mode.
  NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine|--score"
version: "1.0"
category: sdlc
phase: design
prev_phase: design-api
next_phase: design-adr
---

# API Security & Contracts Skill

## Purpose

Create or refine API security and contract specifications (`api-security-draft.md`) —
authentication flows, role-based authorization, pagination strategy, rate limiting tiers,
and WebSocket API. Reads the core API endpoints document as input.

---

## Three Modes

### Mode 1: Create (`--create`)

Generate API security and contract specs from the core API design and architecture.

| Input | Required | Source |
|-------|----------|--------|
| api-draft.md | Yes | `sdlc/design/draft/` — core API endpoints |
| architecture-final.md | No | `sdlc/design/final/` — component boundaries |
| tech-stack-final.md | No | `sdlc/design/final/` — auth provider, framework |
| scope-final.md | No | `sdlc/init/final/` — quality attributes for rate limiting |

### Mode 2: Refine (`--refine`)

Improve existing API security document based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing draft | Yes | `sdlc/design/draft/api-security-draft.md` or latest `api-security-v{N}.md` |
| Review feedback | Yes | User message or `sdlc/design/input/review-report.md` |

### Mode 3: Score (`--score`)

Evaluate artifact quality with a detailed scoreboard.

| Input | Required | Source |
|-------|----------|--------|
| Artifact to score | Yes | `sdlc/design/draft/api-security-draft.md` or latest version, or user-specified path |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `api-security-draft.md` | `sdlc/design/draft/` |
| Refine | `api-security-v{N}.md` | `sdlc/design/draft/` |
| Score | `api-security-scoreboard.md` | `sdlc/design/draft/` |

When satisfied → copy to `sdlc/design/final/api-security-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User passes `--score` → **Mode 3 (Score)**
- User passes `--refine` → **Mode 2 (Refine)**
- User passes `--create` → **Mode 1 (Create)**
- No argument AND existing draft exists → Ask: "A draft already exists. Use `--create` to start fresh or `--refine` to improve it."
- No argument AND no draft exists → **Mode 1 (Create)**

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md` — document formatting standards
2. `skills/shared/rules/quality-rules.md` — confidence marking, readiness assessment
3. `skills/shared/rules/output-rules.md` — versioning, input resolution, diff summary
4. `design/shared/rules/design-rules.md` — design phase rules
5. `design/api/knowledge/api-design-guide.md` — REST API design techniques (shared with /design-api)
6. `design/api-security/rules/output-rules.md` — security-specific output rules
7. `design/api-security/templates/output-template.md` — expected output structure
For Mode 3 (Score): Read resources listed in `skills/shared/knowledge/score-workflow.md`

### Step 3: Resolve Input

Resolve inputs per `skills/shared/knowledge/input-resolution-workflow.md`.

**Create mode inputs:**

| Input | Required | Default Path | Fallback |
|-------|----------|-------------|----------|
| api-draft.md | Yes | `sdlc/design/draft/` | "No API design found. Run /design-api first." |
| architecture-final.md | No | `sdlc/design/final/` | Proceed without |
| tech-stack-final.md | No | `sdlc/design/final/` | Proceed without |
| scope-final.md | No | `sdlc/init/final/` | Proceed without |

**Refine mode inputs:**

| Input | Required | Source |
|-------|----------|--------|
| Existing draft | Yes | `sdlc/design/draft/api-security-draft.md` or latest `api-security-v{N}.md` |
| Review feedback | Yes | User message or `sdlc/design/input/review-report.md` |

### Step 4: Generate (Mode-specific)

**Mode 1 — Create:**

Work through the document **section by section**:

1. **Authentication & Authorization** — Document auth flow (from tech-stack), token format, token lifecycle. Build role-based permissions matrix mapping roles to endpoint access (CRUD per resource from api-draft.md).
   - Ask: "Are these roles and permissions accurate?"

2. **Pagination & Filtering** — Choose pagination approach (offset vs cursor). Define standard query parameters for listing endpoints (page, limit, sort, order, filter). Show example request and response with meta.

3. **Rate Limiting** — Define rate limit tiers (anonymous, authenticated, elevated). Specify per-endpoint overrides where needed. Document rate limit response headers.

4. **WebSocket API** — If real-time features exist in architecture/stories: define WebSocket connection, authentication, channels, events, and message format.
   - Skip this section if no real-time features are identified

For each section:
- Apply confidence markers (✅ CONFIRMED / 🔶 ASSUMED / ❓ UNCLEAR)
- Create Q&A entries for ASSUMED and UNCLEAR items
- Present section to user before moving to next

**Mode 2 — Refine:**

1. Read existing draft (baseline)
2. Read review report / user feedback
3. Run Quality Scorecard analysis (auth coverage, pagination completeness, rate limit coverage)
4. Present scorecard to user
5. Apply improvements:
   - Address user feedback point by point
   - Resolve Q&A entries from previous version
   - Upgrade confidence levels where possible
   - Add missing auth rules, rate limits, or pagination configs
6. Tag changes: `[UPDATED]`, `[NEW]`
7. Preserve CONFIRMED items unless user explicitly contradicts them
8. Write to `sdlc/design/draft/api-security-v{N}.md`

**Mode 3 -- Score:**

Follow the standard score workflow in `skills/shared/knowledge/score-workflow.md` using this skill's rules and templates as context.

### Step 5: Validate Output

Check against rules:
- Authentication mechanism documented (SEC-01)
- Role permission matrix covers all endpoints from api-draft.md (SEC-02)
- Token lifecycle documented (SEC-03)
- Pagination parameters documented for all list endpoints (SEC-04)
- Rate limit tiers include anonymous, authenticated, elevated (SEC-05)
- Rate limit response headers documented (SEC-06)
- WebSocket auth mechanism documented if WebSocket section exists (SEC-07)
- Confidence markers on every item (CR-01)
- All items trace to requirements or api-draft endpoints (DES-02)
- Standard notations used (DES-04)

### Step 6: Readiness Assessment

Generate assessment per `skills/shared/templates/readiness-assessment.md`:
- Count items by confidence level
- Calculate readiness verdict
- In refine mode: compare with previous version

### Step 7: Output

- **Create mode**: Write to `sdlc/design/draft/api-security-draft.md`
- **Refine mode**: Write to `sdlc/design/draft/api-security-v{N}.md`, include Change Log and Diff Summary

**Mode 3 (Score):** Output per score workflow — `sdlc/design/draft/api-security-scoreboard.md`

Tell the user:
> **API security & contracts {created/refined}!**
> - Output: `sdlc/design/draft/api-security-{version}.md`
> - Readiness: {verdict}
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/design-api-security --refine`
> - When satisfied, copy to `sdlc/design/final/api-security-final.md`
> - Then run `/design-adr` to capture key API decisions as ADRs

---

## Scope Rules

### This skill DOES:
- Document authentication and authorization flows
- Build role-based permission matrices
- Define pagination and filtering strategies
- Set rate limiting tiers and per-endpoint limits
- Design WebSocket events for real-time features
- Apply confidence marking to every specification

### This skill does NOT:
- Design REST endpoints or payloads (belongs to `/design-api`)
- Define error handling or error codes (belongs to `/design-api`)
- Implement API endpoints or write server code (belongs to `impl` phase)
- Design database schema (belongs to `/design-db`)
- Select technologies (belongs to `/design-stack`)
