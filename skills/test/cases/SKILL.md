---
name: test-cases
description: >
  Create or refine functional and API test cases organized into test suites.
  Generates specific, executable test scenarios with steps, test data, expected
  results, and traceability to acceptance criteria and API endpoints.
  ONLY activated by command: `/test-cases`. Use `--create`, `--refine`, or `--score` to set mode.
  NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine|--score"
version: "1.0"
category: sdlc
phase: test
prev_phase: test-plan
next_phase: test-integration
---

# Test Cases Skill

## Purpose

Create **test-cases-draft.md** with specific, executable functional and API test cases organized into suites, fully traced to requirements. Each test case includes concrete steps, test data, expected results, and traceability to acceptance criteria or API endpoints.

---

## Three Modes

| Mode | Command | Input | Output |
|------|---------|-------|--------|
| **Create** | `/test-cases --create` | Requirements + design artifacts | New test-cases-draft.md |
| **Refine** | `/test-cases --refine` | Existing draft + user feedback | Updated test-cases-draft.md |
| **Score** | `/test-cases --score` | Existing artifact | test-cases-scoreboard.md |

---

## Inputs

### Create Mode

| Input | Required | Source |
|-------|----------|--------|
| userstories-final.md | **REQUIRED** | sdlc/req/final/ — acceptance criteria drive test cases |
| api-final.md | **REQUIRED** | sdlc/design/final/ — API endpoints drive API test cases |
| test-strategy-final.md | Optional | sdlc/test/final/ — tools, approach, coverage targets |
| test-plan-final.md | Optional | sdlc/test/final/ — scope, priorities |
| database-final.md | Optional | sdlc/design/final/ — data constraints for test data |
| backlog-final.md | Optional | sdlc/req/final/ — MVP boundary for test prioritization |

### Refine Mode

| Input | Required | Source |
|-------|----------|--------|
| test-cases-draft.md | **REQUIRED** | sdlc/test/draft/ — existing draft to improve |
| User feedback | **REQUIRED** | Conversation — specific improvement requests |

### Score Mode

| Input | Required | Source |
|-------|----------|--------|
| Artifact to score | Yes | `sdlc/test/draft/test-cases-draft.md` or latest `test-cases-v{N}.md` or `sdlc/test/final/test-cases-final.md`, or user-specified path |

---

## Output

- **File**: `sdlc/test/draft/test-cases-draft.md`
- **Format**: Follows `test/cases/templates/output-template.md`
- **Score**: `sdlc/test/draft/test-cases-scoreboard.md`

---

## Workflow

### Step 1 — Detect Mode

- User passes `--score` argument → **Mode 3 (Score)**
- User passes `--refine` argument → **Mode 2 (Refine)**
- User passes `--create` argument → **Mode 1 (Create)**
- No argument specified AND existing draft exists in `sdlc/test/draft/` → Ask: "A draft already exists. Use `--create` to start fresh or `--refine` to improve it."
- No argument specified AND no draft exists → **Mode 1 (Create)**

### Step 2 — Read Knowledge and Rules

Read these files in order. STOP if any required file is missing:

1. `skills/shared/rules/doc-standards.md`
2. `skills/shared/rules/quality-rules.md`
3. `skills/shared/rules/output-rules.md`
4. `test/shared/rules/test-rules.md`
5. `test/shared/templates/cases/case-template.md`
6. `test/cases/knowledge/test-case-writing-guide.md`
7. `test/cases/rules/output-rules.md`
8. `test/cases/templates/output-template.md`
For Mode 3 (Score): Read resources listed in `skills/shared/knowledge/score-workflow.md`

### Step 3 — Resolve Inputs

Resolve inputs per `skills/shared/knowledge/input-resolution-workflow.md`.

**Create mode inputs:**

| Input | Required | Default Path | Fallback |
|-------|----------|-------------|----------|
| User stories | Yes | `sdlc/req/final/userstories-final.md` | STOP: "No user stories found. Please provide a path or run /req-userstory first." |
| API spec | Yes | `sdlc/design/final/api-final.md` | STOP: "No API design found. Please provide a path or run /design-api first." |
| Test strategy | No | `sdlc/test/final/test-strategy-final.md` | Proceed without |
| Test plan | No | `sdlc/test/final/test-plan-final.md` | Proceed without |
| Database | No | `sdlc/design/final/database-final.md` | Proceed without |
| Backlog | No | `sdlc/req/final/backlog-final.md` | Proceed without |

**Refine mode inputs:**

| Input | Required | Source |
|-------|----------|--------|
| Existing draft | Yes | `sdlc/test/draft/test-cases-draft.md` or latest `test-cases-v{N}.md` |
| Review feedback | Yes | User message or `sdlc/test/input/review-report.md` |

### Step 4 — Generate (Create Mode)

Work through each step systematically:

#### 4.1 Test Suite Organization

Group test cases by source:
- **Functional suites**: one suite per user story (TS-xxx maps to US-xxx)
- **API suites**: one suite per API resource

Present suite structure to user before proceeding.

#### 4.2 Functional Test Cases

For each user story:
- For each acceptance criterion (AC), create at least one **happy-path** test case
- For each AC, create at least one **negative/edge-case** test case
- Map Gherkin Given/When/Then to test steps
- Specify **concrete test data** (not placeholders)
- Include preconditions and postconditions

#### 4.3 API Test Cases

For each API endpoint:
- **Happy path**: valid request → expected response
- **Validation**: invalid/missing fields → 400 error
- **Auth**: missing/invalid token → 401/403
- **Not found**: invalid ID → 404
- **Rate limiting**: exceed limit → 429
- Use real request/response examples from api-final.md

#### 4.4 Test Data Specifications

For each suite:
- Required test data entities
- How to create them (seed, factory, manual)
- Relationships between test data entities

### Step 4 — Generate (Refine Mode)

1. Read existing `sdlc/test/draft/test-cases-draft.md`
2. Show **quality scorecard** first:
   - Total test cases by type (functional, API) and priority
   - AC coverage % (Must Have, Should Have, Could Have)
   - API endpoint coverage %
   - Confidence distribution (CONFIRMED / ASSUMED / UNCLEAR)
   - Known gaps
3. Apply user feedback — typical refinements:
   - Add missing test cases for uncovered ACs
   - Improve test data specificity
   - Add negative/edge cases
   - Improve coverage for specific endpoints
   - Adjust priorities
4. Present changes summary to user

**Mode 3 -- Score:**

Follow the standard score workflow in `skills/shared/knowledge/score-workflow.md` using this skill's rules and templates as context.

### Step 5 — Validate

Check output against:
- TCS rules (TCS-01 through TCS-14) from `test/cases/rules/output-rules.md`
- Test rules from `test/shared/rules/test-rules.md`
- Quality rules from `skills/shared/rules/quality-rules.md`

Fix any violations before proceeding.

### Step 6 — Readiness Assessment

Evaluate:
- % of Must Have ACs with >=1 happy-path AND >=1 negative test case
- % of API endpoints with happy + auth + 404 coverage
- Confidence distribution (CONFIRMED / ASSUMED / UNCLEAR)
- Coverage gaps

**Verdict**:
- **Ready** — >=95% Must Have AC coverage, >=90% API coverage, <=10% UNCLEAR
- **Partially Ready** — >=80% Must Have AC coverage, >=70% API coverage, some gaps identified
- **Not Ready** — below thresholds, significant gaps

### Step 7 — Output and Next Step

1. Write `sdlc/test/draft/test-cases-draft.md`
2. Present summary: test case counts by type/priority, coverage stats, gaps, confidence
3. Suggest next step: `/test-integration` to create integration and NFR test cases

**Mode 3 (Score):** Output per score workflow — sdlc/test/draft/test-cases-scoreboard.md

---

## Scope Rules

### DOES

- Write specific functional and API test cases with concrete steps, test data, and expected results
- Organize test cases into suites by source (user story, API resource)
- Trace every test case to a requirement (US-xxx.AC-N or API endpoint)
- Specify concrete test data (not placeholders)
- Assign priority and tags to every test case

### Does NOT

- Write integration test cases (cross-component interactions) — that is `/test-integration`
- Write NFR test cases (performance, security, availability) — that is `/test-integration`
- Build the combined coverage matrix — that is `/test-integration`
- Define testing approach or methodology — that is `/test-strategy`
- Plan test execution schedule or resources — that is `/test-plan`
- Implement or code automated tests — that is `/impl-codegen`
- Execute tests or report results — that is implementation phase
- Define acceptance criteria — that is `/req-userstory`
- Design API contracts — that is `/design-api`
