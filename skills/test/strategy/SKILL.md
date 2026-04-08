---
name: test-strategy
description: >
  Create or refine a test strategy document. Defines the testing approach including
  test levels (unit, integration, API, E2E), tool selection, environment requirements,
  coverage targets, NFR testing, and risk-based test prioritization.
  ONLY activated by command: `/test-strategy`. Use `--create` or `--refine` to set mode.
  NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine [path to tech-stack-final.md or architecture-final.md] (md/pdf/docx/xlsx/pptx)"
version: "1.0"
category: sdlc
phase: test
prev_phase: design-adr
next_phase: test-plan
---

# Test Strategy Skill

## Purpose

Create or refine a test strategy document (`test-strategy-draft.md`) that defines HOW to test the system — the overall testing approach, test levels, tool selection, environment requirements, coverage targets, NFR testing approach, and risk-based test prioritization.

The test strategy bridges "what we built" (architecture, tech stack, APIs) and "how we verify it works" (test plans, test cases).

---

## Two Modes

### Mode 1: Create (`--create`)

Generate a test strategy from design and requirements artifacts.

| Input | Required | Source |
|-------|----------|--------|
| Tech stack (final) | Yes | `sdlc/design/final/tech-stack-final.md` or user-specified path |
| Architecture (final) | Yes | `sdlc/design/final/architecture-final.md` or user-specified path |
| User stories (final) | No | `sdlc/req/final/userstories-final.md` — AC count for coverage planning |
| Scope (final) | No | `sdlc/init/final/scope-final.md` — quality attributes for NFR test approach |
| Risk register (final) | No | `sdlc/init/final/risk-register-final.md` — risk-based test prioritization |
| Backlog (final) | No | `sdlc/req/final/backlog-final.md` — MVP boundary for test scope |
| DoR/DoD (final) | No | `sdlc/req/final/dor-dod-final.md` — DoD criteria for exit criteria alignment |
| API spec (final) | No | `sdlc/design/final/api-final.md` — API test approach |
| Database design (final) | No | `sdlc/design/final/database-final.md` — data integrity test approach |

### Mode 2: Refine (`--refine`)

Improve existing test strategy based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing strategy draft | Yes | `sdlc/test/draft/test-strategy-draft.md` or `sdlc/test/draft/test-strategy-v{N}.md` |
| Review report / feedback | Yes | User provides directly or as `sdlc/test/input/review-report.md` |
| Additional details | No | New information the user wants to add |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `test-strategy-draft.md` | `sdlc/test/draft/` |
| Refine | `test-strategy-v{N}.md` | `sdlc/test/draft/` (N = next version number) |

When user is satisfied -> they copy from `sdlc/test/draft/` to `sdlc/test/final/test-strategy-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User passes `--refine` argument → **Mode 2 (Refine)**
- User passes `--create` argument → **Mode 1 (Create)**
- No argument specified AND existing draft exists in `sdlc/test/draft/` → Ask: "A draft already exists. Use `--create` to start fresh or `--refine` to improve it."
- No argument specified AND no draft exists → **Mode 1 (Create)**

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md` -- document formatting standards
2. `skills/shared/rules/quality-rules.md` -- confidence marking, readiness assessment
3. `skills/shared/rules/output-rules.md` -- versioning, input resolution, diff summary
4. `test/shared/rules/test-rules.md` -- test phase rules
5. `test/shared/templates/strategy/strategy-template.md` -- strategy card format
6. `test/strategy/knowledge/test-strategy-guide.md` -- test strategy techniques
7. `test/strategy/rules/output-rules.md` -- strategy-specific output rules
8. `test/strategy/templates/output-template.md` -- expected output structure

### Step 3: Resolve Input

**File Type Conversion** (applies to all file inputs):

Before reading any input file, check its extension:
- `.md` → Read directly, no conversion needed
- `.pdf` → Run `/read-pdf <path> sdlc/test/input/` → read the converted .md
- `.docx` / `.doc` → Run `/read-word <path> sdlc/test/input/` → read the converted .md
- `.xlsx` / `.xls` → Run `/read-excel <path> sdlc/test/input/` → read the converted .md
- `.pptx` / `.ppt` → Run `/read-ppt <path> sdlc/test/input/` → read the converted .md

Converted files are saved to `sdlc/test/input/`. If a converted .md already exists and is newer than the source, skip conversion.

**Mode 1 (Create):**

```
For tech stack input (required):
1. User specified path?                                    -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. Exists in sdlc/test/input/tech-stack-final.md?          -> YES -> read it -> DONE
3. Exists in sdlc/design/final/tech-stack-final.md?        -> YES -> read it, copy to sdlc/test/input/ -> DONE
4. Not found? -> Ask: "No tech stack found. Please provide a path or run /design-stack first."

For architecture input (required):
1. User specified path?                                    -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. Exists in sdlc/test/input/architecture-final.md?        -> YES -> read it -> DONE
3. Exists in sdlc/design/final/architecture-final.md?      -> YES -> read it, copy to sdlc/test/input/ -> DONE
4. Not found? -> Ask: "No architecture found. Please provide a path or run /design-arch first."

For user stories (optional):
1. User specified path?                                    -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. Exists in sdlc/test/input/userstories-final.md?         -> YES -> read it -> DONE
3. Exists in sdlc/req/final/userstories-final.md?          -> YES -> read it, copy to sdlc/test/input/ -> DONE
4. Not found? -> Proceed without user stories.

For scope (optional):
1. User specified path?                                    -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. Exists in sdlc/test/input/scope-final.md?               -> YES -> read it -> DONE
3. Exists in sdlc/init/final/scope-final.md?               -> YES -> read it, copy to sdlc/test/input/ -> DONE
4. Not found? -> Proceed without scope.

For risk register (optional):
1. User specified path?                                    -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. Exists in sdlc/test/input/risk-register-final.md?       -> YES -> read it -> DONE
3. Exists in sdlc/init/final/risk-register-final.md?       -> YES -> read it, copy to sdlc/test/input/ -> DONE
4. Not found? -> Proceed without risk register.

For backlog (optional):
1. User specified path?                                    -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. Exists in sdlc/test/input/backlog-final.md?             -> YES -> read it -> DONE
3. Exists in sdlc/req/final/backlog-final.md?              -> YES -> read it, copy to sdlc/test/input/ -> DONE
4. Not found? -> Proceed without backlog.

For DoR/DoD (optional):
1. User specified path?                                    -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. Exists in sdlc/test/input/dor-dod-final.md?             -> YES -> read it -> DONE
3. Exists in sdlc/req/final/dor-dod-final.md?              -> YES -> read it, copy to sdlc/test/input/ -> DONE
4. Not found? -> Proceed without DoR/DoD.

For API spec (optional):
1. User specified path?                                    -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. Exists in sdlc/test/input/api-final.md?                 -> YES -> read it -> DONE
3. Exists in sdlc/design/final/api-final.md?               -> YES -> read it, copy to sdlc/test/input/ -> DONE
4. Not found? -> Proceed without API spec.

For database design (optional):
1. User specified path?                                    -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. Exists in sdlc/test/input/database-final.md?            -> YES -> read it -> DONE
3. Exists in sdlc/design/final/database-final.md?          -> YES -> read it, copy to sdlc/test/input/ -> DONE
4. Not found? -> Proceed without database design.
```

**Mode 2 (Refine):**

```
For strategy draft:
1. User specified path?                                    -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. Exists in sdlc/test/input/?                             -> YES -> read it -> DONE
3. Exists in sdlc/test/draft/ (latest version)?            -> YES -> read it, copy to sdlc/test/input/ -> DONE
4. Not found? -> FAIL: "No existing strategy found. Run /test-strategy first."

For review report:
1. User provided feedback directly in message?     -> Save to sdlc/test/input/review-report.md
2. User specified path?                            -> read it, copy to sdlc/test/input/
3. Exists in sdlc/test/input/review-report.md?    -> read it
4. Not found? -> Ask: "What feedback do you have on the current test strategy?"
```

### Step 4: Generate (Mode-specific)

**Mode 1 -- Create:**

Work through the test strategy document **section by section, incrementally**:

1. **Test Approach Overview** -- Testing philosophy, test pyramid commitment, shift-left approach
   - Define automation-first strategy
   - State test pyramid commitment (unit > integration > API > E2E)
   - Identify shift-left practices (testing early, testing often)
   - Specify automation target percentage
   - Present to user before detailing

2. **Test Levels** -- For each level (unit, integration, API, E2E):
   - Define scope: what is tested at this level
   - Select tools: framework, mocking library, assertion library
   - Assign responsibility: who writes and maintains these tests
   - Set automation target: percentage of automated vs manual
   - Set coverage target: line/branch coverage or scenario coverage
   - Define CI stage: when tests run in the pipeline
   - Map architecture components to test boundaries

3. **Tool Selection** -- Complete tool inventory
   - Test frameworks (unit, integration, API, E2E)
   - Mocking and stubbing libraries
   - Coverage measurement tools
   - Performance testing tools
   - Security testing tools
   - Static analysis tools
   - All tools MUST be compatible with tech stack from tech-stack-final.md

4. **Test Environment Strategy** -- Environments needed
   - Local dev: fast feedback, mocked externals
   - CI: automated, isolated, containerized
   - Staging: production-like, real integrations
   - Performance: dedicated, production-scale (if applicable)
   - Define what to mock vs use real services at each level
   - Data management approach per environment

5. **NFR Testing Approach** -- For each quality attribute (QA-xxx from scope):
   - Test type (load, stress, penetration, chaos, etc.)
   - Tool selection
   - Target metric with specific numbers
   - Acceptance criteria (pass/fail threshold)

6. **Risk-Based Prioritization** -- Map risks to test priority
   - For each RISK-xxx, identify test scenarios
   - Weight by severity x likelihood
   - High-risk: full path coverage (happy + error + edge)
   - Low-risk: happy-path only
   - Critical path analysis from architecture

7. **Coverage Targets** -- Measurable targets
   - Code coverage: line and branch percentages
   - Requirement coverage: AC coverage by priority
   - Risk coverage: percentage by severity
   - CI enforcement policies (gate vs advisory)
   - Coverage ratchet strategy

8. **Test Data Strategy** -- Data management
   - Data creation approach (fixtures, factories, seeds)
   - Test isolation (per-test, per-suite, shared)
   - Cleanup mechanism (teardown, transaction rollback)
   - Sensitive data handling (masking, synthetic, anonymized)

For each section:
- Apply confidence markers (CONFIRMED / ASSUMED / UNCLEAR)
- Inherit confidence from design/req artifacts where applicable
- Create Q&A entries for ASSUMED and UNCLEAR items
- Present section to user before moving to next

**Mode 2 -- Refine:**

1. Read existing strategy draft (baseline)
2. Read review report / user feedback
3. Run Quality Scorecard analysis
4. Present scorecard to user
5. Apply improvements:
   - Address user feedback point by point
   - Resolve Q&A entries from previous version
   - Upgrade confidence levels where possible
   - Improve tool justifications and coverage targets
   - Update NFR testing approach based on new information
6. Tag all changes: `[UPDATED]` for modified items, `[NEW]` for additions
7. Preserve CONFIRMED items unless user explicitly contradicts them
8. Write improved version to `sdlc/test/draft/test-strategy-v{N}.md`

### Step 5: Validate Output

Check against rules:
- Every item has a confidence marker (CR-01)
- Test pyramid defines all 4 levels (STR-01)
- Tool selection is compatible with tech stack (STR-02)
- Every QA-xxx has a test approach (STR-03)
- Coverage targets have specific percentages (STR-04)
- Risk prioritization references risk register (STR-05)
- At least 3 environments defined (STR-06)
- Test data strategy is complete (STR-07)
- Section order matches template (STR-08)
- Confidence markers on all decisions (STR-09)
- CI integration specifies pipeline stages (STR-11)
- Test architecture Mermaid diagram present (STR-12)
- Automation target specified (STR-13)
- Approval section present (INIT-07)
- Cross-references consistent (REQ-10)

### Step 6: Readiness Assessment

Generate assessment per `skills/shared/templates/readiness-assessment.md`:
- Count items by confidence level (each strategy decision is 1 item)
- Calculate readiness verdict
- In refine mode: compare with previous version

### Step 7: Output

- **Create mode**: Write to `sdlc/test/draft/test-strategy-draft.md`
- **Refine mode**: Write to `sdlc/test/draft/test-strategy-v{N}.md`, include Change Log and Diff Summary

Tell the user:
> **Test Strategy {created/refined}!**
> - Output: `sdlc/test/draft/test-strategy-{version}.md`
> - Readiness: {verdict}
> - Test levels: {N} defined
> - Tools: {N} selected
> - NFR coverage: {N}/{total} quality attributes addressed
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/test-strategy --refine`
> - When satisfied, copy to `sdlc/test/final/test-strategy-final.md`
> - Then run `/test-plan` to create detailed test plans for each test level

---

## Scope Rules

### This skill DOES:
- Define the overall testing approach and philosophy
- Select test tools compatible with the tech stack
- Set measurable coverage targets with enforcement policies
- Plan NFR testing for each quality attribute
- Prioritize testing by risk severity
- Define test environment strategy
- Define test data strategy
- Create test architecture diagrams

### This skill does NOT:
- Create detailed test plans with specific scenarios (belongs to `test/plan` skill)
- Write individual test cases (belongs to `test/cases` skill)
- Implement actual test code (belongs to `impl/` phase)
- Set up test environments or infrastructure (belongs to `deploy/` phase)
- Define CI/CD pipeline configuration (belongs to `deploy/cicd` skill)
- Modify design or requirements artifacts -- it reads them as input
