---
name: test-integration
description: >
  Create or refine integration and NFR test cases — cross-component interactions,
  performance, security, availability tests, and coverage matrix.
  ONLY activated by command: `/test-integration`. Use `--create`, `--refine`, or `--score` to set mode.
  NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine|--score"
version: "1.0"
category: sdlc
phase: test
prev_phase: test-cases
next_phase: impl-sprint
---

# Test Integration Skill

## Purpose

Create **test-integration-draft.md** with integration and NFR test cases covering cross-component interactions, performance, security, availability, and data integrity. Includes a coverage matrix showing which acceptance criteria, endpoints, and risks are covered across both test-cases-draft and this document.

---

## Three Modes

| Mode | Command | Input | Output |
|------|---------|-------|--------|
| **Create** | `/test-integration --create` | Test cases draft + design artifacts | New test-integration-draft.md |
| **Refine** | `/test-integration --refine` | Existing draft + user feedback | Updated test-integration-draft.md |
| **Score** | `/test-integration --score` | Existing artifact | test-integration-scoreboard.md |

---

## Inputs

### Create Mode

| Input | Required | Source |
|-------|----------|--------|
| test-cases-draft.md | **REQUIRED** | sdlc/test/draft/ — functional/API test cases to build upon |
| architecture-final.md | **REQUIRED** | sdlc/design/final/ — component boundaries for integration tests |
| scope-final.md | Optional | sdlc/init/final/ — QA-xxx for NFR test cases |
| database-final.md | Optional | sdlc/design/final/ — data constraints for integration/integrity tests |
| risk-register-final.md | Optional | sdlc/init/final/ — risk-based test cases |
| api-final.md | Optional | sdlc/design/final/ — endpoints for coverage matrix |

### Refine Mode

| Input | Required | Source |
|-------|----------|--------|
| test-integration-draft.md | **REQUIRED** | sdlc/test/draft/ — existing draft to improve |
| User feedback | **REQUIRED** | Conversation — specific improvement requests |

### Score Mode

| Input | Required | Source |
|-------|----------|--------|
| Artifact to score | Yes | `sdlc/test/draft/test-integration-draft.md` or latest `test-integration-v{N}.md` or `sdlc/test/final/test-integration-final.md`, or user-specified path |

---

## Output

- **File**: `sdlc/test/draft/test-integration-draft.md`
- **Format**: Follows `test/integration/templates/output-template.md`
- **Score**: `sdlc/test/draft/test-integration-scoreboard.md`

---

## Workflow

### Step 1 — Detect Mode

- User passes `--score` argument -> **Mode 3 (Score)**
- User passes `--refine` argument -> **Mode 2 (Refine)**
- User passes `--create` argument -> **Mode 1 (Create)**
- No argument specified AND existing draft exists in `sdlc/test/draft/` -> Ask: "A draft already exists. Use `--create` to start fresh or `--refine` to improve it."
- No argument specified AND no draft exists -> **Mode 1 (Create)**

### Step 2 — Read Knowledge and Rules

Read these files in order. STOP if any required file is missing:

1. `skills/shared/rules/doc-standards.md`
2. `skills/shared/rules/quality-rules.md`
3. `skills/shared/rules/output-rules.md`
4. `test/shared/rules/test-rules.md`
5. `test/shared/templates/cases/case-template.md`
6. `test/integration/rules/output-rules.md`
7. `test/integration/templates/output-template.md`
For Mode 3 (Score): Read resources listed in `skills/shared/knowledge/score-workflow.md`

### Step 3 — Resolve Inputs

Resolve inputs per `skills/shared/knowledge/input-resolution-workflow.md`.

**Create mode inputs:**

| Input | Required | Default Path | Fallback |
|-------|----------|-------------|----------|
| Test cases draft | Yes | `sdlc/test/draft/test-cases-draft.md` | STOP: "No test cases found. Please run /test-cases first." |
| Architecture | Yes | `sdlc/design/final/architecture-final.md` | STOP: "No architecture found. Please run /design-arch first." |
| Scope | No | `sdlc/init/final/scope-final.md` | Proceed without (limits NFR coverage) |
| Database | No | `sdlc/design/final/database-final.md` | Proceed without |
| Risk register | No | `sdlc/init/final/risk-register-final.md` | Proceed without |
| API spec | No | `sdlc/design/final/api-final.md` | Proceed without |

**Refine mode inputs:**

| Input | Required | Source |
|-------|----------|--------|
| Existing draft | Yes | `sdlc/test/draft/test-integration-draft.md` or latest `test-integration-v{N}.md` |
| Review feedback | Yes | User message or `sdlc/test/input/review-report.md` |

### Step 4 — Generate (Create Mode)

Work through each step systematically:

#### 4.1 Integration Test Suite Organization

Identify key component interactions from architecture-final.md:
- **Service -> Database**: CRUD operations with real DB
- **Service -> Cache**: cache hit/miss scenarios
- **Service -> External API**: webhook processing, API calls
- **WebSocket**: connection, event subscription, message delivery
- **Cross-service**: service-to-service communication flows

One suite per component interaction.

#### 4.2 Integration Test Cases

For each key component interaction:
- **Service -> Database**: CRUD operations, transaction isolation, connection pool behavior
- **Service -> Cache**: cache hit, cache miss, cache invalidation, cache unavailability
- **Service -> External API**: webhook delivery, retry logic, timeout handling
- **WebSocket**: connection lifecycle, event subscription, message delivery, reconnection
- End-to-end data flow through multiple components
- Include preconditions, concrete test steps, expected results, and test data

#### 4.3 NFR Test Cases

For each quality attribute (QA-xxx) from scope:
- **Performance**: load scenarios with specific user counts, ramp-up, duration, and response time targets. Specify tool (k6, JMeter, etc.) and measurement method.
- **Security**: OWASP Top 10 checks (injection, auth bypass, XSS, CSRF), JWT manipulation, rate limiting. Specify attack vector and expected defense.
- **Availability**: failover scenarios (cache down, DB pool exhaustion), graceful degradation, recovery behavior.
- **Data integrity**: FK constraint violations, concurrent updates, race conditions, orphan record prevention.

#### 4.4 Coverage Matrix

Build a combined coverage matrix referencing test cases from BOTH test-cases-draft.md and this document:
- **AC Coverage**: which acceptance criteria are covered by which test cases
- **API Endpoint Coverage**: happy path, auth, 404, validation, other
- **Risk Coverage**: which risks have corresponding test cases
- **Coverage Summary**: totals, percentages, and targets

Identify gaps explicitly. Flag any ACs, endpoints, or risks with no test coverage.

### Step 4 — Generate (Refine Mode)

1. Read existing `sdlc/test/draft/test-integration-draft.md`
2. Show **quality scorecard** first:
   - Total test cases by type (integration, performance, security, availability)
   - Coverage matrix summary
   - Confidence distribution (CONFIRMED / ASSUMED / UNCLEAR)
   - Known gaps
3. Apply user feedback — typical refinements:
   - Add missing integration test cases for uncovered component interactions
   - Add NFR test cases for uncovered quality attributes
   - Improve performance test targets with real data
   - Add security test cases for additional OWASP categories
   - Update coverage matrix
4. Update coverage matrix after changes
5. Present changes summary to user

**Mode 3 -- Score:**

Follow the standard score workflow in `skills/shared/knowledge/score-workflow.md` using this skill's rules and templates as context.

### Step 5 — Validate

Check output against:
- INT rules (INT-01 through INT-07) from `test/integration/rules/output-rules.md`
- Test rules from `test/shared/rules/test-rules.md`
- Quality rules from `skills/shared/rules/quality-rules.md`

Fix any violations before proceeding.

### Step 6 — Readiness Assessment

Evaluate:
- % of component interactions from architecture with integration test coverage
- % of QA-xxx with >=1 NFR test case
- Combined coverage (test-cases + test-integration) of Must Have ACs, API endpoints, and risks
- Confidence distribution (CONFIRMED / ASSUMED / UNCLEAR)
- Coverage gaps

**Verdict**:
- **Ready** — all key interactions covered, all QA attributes tested, combined AC coverage >=95%, <=10% UNCLEAR
- **Partially Ready** — most interactions covered, some QA gaps, combined AC coverage >=80%
- **Not Ready** — below thresholds, significant gaps

### Step 7 — Output and Next Step

1. Write `sdlc/test/draft/test-integration-draft.md`
2. Present summary: test case counts by type, coverage stats, gaps, confidence
3. Suggest next step: `/impl-sprint` to begin implementation planning

**Mode 3 (Score):** Output per score workflow — sdlc/test/draft/test-integration-scoreboard.md

---

## Scope Rules

### DOES

- Write integration test cases covering cross-component interactions
- Write NFR test cases for performance, security, availability, and data integrity
- Build combined coverage matrix (test-cases + test-integration)
- Trace every test case to architecture components, quality attributes, or risks
- Specify concrete test configurations (VU counts, durations, targets)
- Assign priority and tags to every test case

### Does NOT

- Write functional test cases for user stories — that is `/test-cases`
- Write API endpoint test cases — that is `/test-cases`
- Define testing approach or methodology — that is `/test-strategy`
- Plan test execution schedule or resources — that is `/test-plan`
- Implement or code automated tests — that is `/impl-codegen`
- Execute tests or report results — that is implementation phase
- Define acceptance criteria — that is `/req-userstory`
- Design API contracts — that is `/design-api`
