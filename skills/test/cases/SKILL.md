---
name: test-cases
description: >
  Create or refine test cases organized into test suites. Generates specific,
  executable test scenarios with steps, test data, expected results, and
  traceability to acceptance criteria. Covers functional, API, integration,
  and NFR test cases.
  ONLY activated by command: `/test-cases`. Use `--create` or `--refine` to set mode.
  NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine"
version: "1.0"
category: sdlc
phase: test
prev_phase: test-plan
next_phase: impl-sprint
---

# Test Cases Skill

## Purpose

Create **test-cases-draft.md** with specific, executable test cases organized into suites, fully traced to requirements. Each test case includes concrete steps, test data, expected results, and traceability to acceptance criteria, API endpoints, quality attributes, or risks.

---

## Two Modes

| Mode | Command | Input | Output |
|------|---------|-------|--------|
| **Create** | `/test-cases --create` | Requirements + design artifacts | New test-cases-draft.md |
| **Refine** | `/test-cases --refine` | Existing draft + user feedback | Updated test-cases-draft.md |

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
| architecture-final.md | Optional | sdlc/design/final/ — component boundaries for integration tests |
| scope-final.md | Optional | sdlc/init/final/ — QA-xxx for NFR test cases |
| backlog-final.md | Optional | sdlc/req/final/ — MVP boundary for test prioritization |
| risk-register-final.md | Optional | sdlc/init/final/ — risk-based test cases |

### Refine Mode

| Input | Required | Source |
|-------|----------|--------|
| test-cases-draft.md | **REQUIRED** | sdlc/test/draft/ — existing draft to improve |
| User feedback | **REQUIRED** | Conversation — specific improvement requests |

---

## Output

- **File**: `sdlc/test/draft/test-cases-draft.md`
- **Format**: Follows `test/cases/templates/output-template.md`

---

## Workflow

### Step 1 — Detect Mode

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

### Step 3 — Resolve Inputs

**File Type Conversion** (applies to all file inputs):

Before reading any input file, check its extension:
- `.md` → Read directly, no conversion needed
- `.pdf` → Run `/read-pdf <path> sdlc/test/input/` → read the converted .md
- `.docx` / `.doc` → Run `/read-word <path> sdlc/test/input/` → read the converted .md
- `.xlsx` / `.xls` → Run `/read-excel <path> sdlc/test/input/` → read the converted .md
- `.pptx` / `.ppt` → Run `/read-ppt <path> sdlc/test/input/` → read the converted .md

Converted files are saved to `sdlc/test/input/`. If a converted .md already exists and is newer than the source, skip conversion.

Note: Files auto-resolved from `sdlc/` pipeline are always .md and skip conversion.

**Mode 1 (Create) — Input resolution priority** (for each input file):

```
For userstories input (required):
1. Exists in sdlc/req/final/userstories-final.md?          -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. User specified a different path?                         -> YES -> read it, convert if needed, copy to sdlc/test/input/ -> DONE
3. Exists in sdlc/test/input/userstories-final.md?          -> YES -> read it -> DONE
4. Not found? -> STOP: "No user stories found. Please provide a path or run /req-userstory first."

For api input (required):
1. Exists in sdlc/design/final/api-final.md?               -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. User specified a different path?                         -> YES -> read it, convert if needed, copy to sdlc/test/input/ -> DONE
3. Exists in sdlc/test/input/api-final.md?                  -> YES -> read it -> DONE
4. Not found? -> STOP: "No API design found. Please provide a path or run /design-api first."

For test-strategy (optional):
1. Exists in sdlc/test/final/test-strategy-final.md?       -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. User specified a different path?                         -> YES -> read it, convert if needed, copy to sdlc/test/input/ -> DONE
3. Exists in sdlc/test/input/test-strategy-final.md?        -> YES -> read it -> DONE
4. Not found? -> Proceed without test strategy.

For test-plan (optional):
1. Exists in sdlc/test/final/test-plan-final.md?           -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. User specified a different path?                         -> YES -> read it, convert if needed, copy to sdlc/test/input/ -> DONE
3. Exists in sdlc/test/input/test-plan-final.md?            -> YES -> read it -> DONE
4. Not found? -> Proceed without test plan.

For database (optional):
1. Exists in sdlc/design/final/database-final.md?          -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. User specified a different path?                         -> YES -> read it, convert if needed, copy to sdlc/test/input/ -> DONE
3. Exists in sdlc/test/input/database-final.md?             -> YES -> read it -> DONE
4. Not found? -> Proceed without database design.

For architecture (optional):
1. Exists in sdlc/design/final/architecture-final.md?      -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. User specified a different path?                         -> YES -> read it, convert if needed, copy to sdlc/test/input/ -> DONE
3. Exists in sdlc/test/input/architecture-final.md?         -> YES -> read it -> DONE
4. Not found? -> Proceed without architecture.

For scope (optional):
1. Exists in sdlc/init/final/scope-final.md?               -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. User specified a different path?                         -> YES -> read it, convert if needed, copy to sdlc/test/input/ -> DONE
3. Exists in sdlc/test/input/scope-final.md?                -> YES -> read it -> DONE
4. Not found? -> Proceed without scope.

For backlog (optional):
1. Exists in sdlc/req/final/backlog-final.md?              -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. User specified a different path?                         -> YES -> read it, convert if needed, copy to sdlc/test/input/ -> DONE
3. Exists in sdlc/test/input/backlog-final.md?              -> YES -> read it -> DONE
4. Not found? -> Proceed without backlog.

For risk register (optional):
1. Exists in sdlc/init/final/risk-register-final.md?       -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. User specified a different path?                         -> YES -> read it, convert if needed, copy to sdlc/test/input/ -> DONE
3. Exists in sdlc/test/input/risk-register-final.md?        -> YES -> read it -> DONE
4. Not found? -> Proceed without risk register.
```

**Actions**:
- Locate each input file using priority order above
- Copy resolved files to `sdlc/test/input/` for traceability
- STOP if REQUIRED inputs (userstories-final.md, api-final.md) are not found — tell user what is missing
- Log which optional inputs were found vs. missing

### Step 4 — Generate (Create Mode)

Work through each step systematically:

#### 4.1 Test Suite Organization

Group test cases by source:
- **Functional suites**: one suite per user story (TS-xxx maps to US-xxx)
- **API suites**: one suite per API resource
- **Integration suites**: one suite per component interaction
- **NFR suites**: one suite per quality attribute

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

#### 4.4 Integration Test Cases

For key component interactions:
- **Service → Database**: CRUD operations with real DB
- **Service → Cache**: cache hit/miss scenarios
- **Service → External API**: webhook processing, API calls
- **WebSocket**: connection, event subscription, message delivery

#### 4.5 NFR Test Cases

For each quality attribute:
- **Performance**: load scenarios with specific user counts and targets
- **Security**: OWASP Top 10 checks, auth bypass attempts, injection tests
- **Availability**: failover scenarios, graceful degradation
- **Data integrity**: FK constraint violations, concurrent updates

#### 4.6 Test Data Specifications

For each suite:
- Required test data entities
- How to create them (seed, factory, manual)
- Relationships between test data entities

#### 4.7 Coverage Matrix

Summary showing which ACs, endpoints, and risks are covered by which test cases. Identify gaps explicitly.

### Step 4 — Generate (Refine Mode)

1. Read existing `sdlc/test/draft/test-cases-draft.md`
2. Show **quality scorecard** first:
   - Total test cases by type and priority
   - AC coverage % (Must Have, Should Have, Could Have)
   - API endpoint coverage %
   - Quality attribute coverage %
   - Confidence distribution (CONFIRMED / ASSUMED / UNCLEAR)
   - Known gaps
3. Apply user feedback — typical refinements:
   - Add missing test cases for uncovered ACs
   - Improve test data specificity
   - Add negative/edge cases
   - Improve coverage for specific endpoints
   - Add integration test cases
   - Adjust priorities
4. Update coverage matrix after changes
5. Present changes summary to user

### Step 5 — Validate

Check output against:
- TCS rules (TCS-01 through TCS-16) from `test/cases/rules/output-rules.md`
- Test rules from `test/shared/rules/test-rules.md`
- Quality rules from `skills/shared/rules/quality-rules.md`

Fix any violations before proceeding.

### Step 6 — Readiness Assessment

Evaluate:
- % of Must Have ACs with ≥1 happy-path AND ≥1 negative test case
- % of API endpoints with happy + auth + 404 coverage
- % of QA-xxx with ≥1 NFR test case
- Confidence distribution (CONFIRMED / ASSUMED / UNCLEAR)
- Coverage gaps

**Verdict**:
- **Ready** — ≥95% Must Have AC coverage, ≥90% API coverage, all QA attributes tested, ≤10% UNCLEAR
- **Partially Ready** — ≥80% Must Have AC coverage, ≥70% API coverage, some gaps identified
- **Not Ready** — below thresholds, significant gaps

### Step 7 — Output and Next Step

1. Write `sdlc/test/draft/test-cases-draft.md`
2. Present summary: test case counts by type/priority, coverage stats, gaps, confidence
3. Suggest next step: `/impl-sprint` to begin implementation planning

---

## Scope Rules

### DOES

- Write specific test cases with concrete steps, test data, and expected results
- Organize test cases into suites by source (story, resource, QA attribute)
- Trace every test case to a requirement (US-xxx.AC-N, QA-xxx, RISK-xxx, API endpoint)
- Specify concrete test data (not placeholders)
- Build coverage matrix and identify gaps
- Assign priority and tags to every test case

### Does NOT

- Define testing approach or methodology — that is `/test-strategy`
- Plan test execution schedule or resources — that is `/test-plan`
- Implement or code automated tests — that is `/impl-codegen`
- Execute tests or report results — that is implementation phase
- Define acceptance criteria — that is `/req-userstory`
- Design API contracts — that is `/design-api`
