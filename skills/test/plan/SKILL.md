---
name: test-plan
description: >
  Create or refine a detailed test plan. Defines test phases, schedule, resource
  allocation, entry/exit criteria, environment setup, and risk mitigation for
  testing activities. Maps test effort to sprints and releases.
  ONLY activated by commands: `/test-plan` (create) or `/test-plan-refine` (refine).
  NEVER auto-trigger based on keywords.
argument-hint: "[path to test-strategy-final.md or backlog-final.md] (md/pdf/docx/xlsx/pptx)"
version: "1.0"
category: sdlc
phase: test
prev_phase: test-strategy
next_phase: test-cases
---

# Test Plan Skill

## Purpose

Create or refine a test plan document (`test-plan-draft.md`) that defines WHEN, WHO, and WHERE testing happens -- the detailed execution plan with test phases, schedule, resource allocation, entry/exit criteria, environment setup, deliverables, risk mitigations, and defect management process.

The test plan bridges "how we test" (test strategy) and "what we test" (test cases). It operationalizes the strategy into a concrete, actionable plan mapped to sprints and releases.

---

## Two Modes

### Mode 1: Create (`/test-plan`)

Generate a test plan from test strategy and requirements/design artifacts.

| Input | Required | Source |
|-------|----------|--------|
| Test strategy (final) | Yes | `sdlc/test/final/test-strategy-final.md` or user-specified path |
| Backlog (final) | Yes | `sdlc/req/final/backlog-final.md` or user-specified path |
| User stories (final) | No | `sdlc/req/final/userstories-final.md` -- story count for effort estimation |
| DoR/DoD (final) | No | `sdlc/req/final/dor-dod-final.md` -- DoD criteria for exit criteria alignment |
| Architecture (final) | No | `sdlc/design/final/architecture-final.md` -- component boundaries for integration test phases |
| Scope (final) | No | `sdlc/init/final/scope-final.md` -- quality attributes for NFR test scheduling |
| Risk register (final) | No | `sdlc/init/final/risk-register-final.md` -- risk-based scheduling |

### Mode 2: Refine (`/test-plan-refine`)

Improve existing test plan based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing plan draft | Yes | `sdlc/test/draft/test-plan-draft.md` or `sdlc/test/draft/test-plan-v{N}.md` |
| Review report / feedback | Yes | User provides directly or as `sdlc/test/input/review-report.md` |
| Additional details | No | New information the user wants to add |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `test-plan-draft.md` | `sdlc/test/draft/` |
| Refine | `test-plan-v{N}.md` | `sdlc/test/draft/` (N = next version number) |

When user is satisfied -> they copy from `sdlc/test/draft/` to `sdlc/test/final/test-plan-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User runs `/test-plan-refine` AND existing draft exists in `sdlc/test/draft/` -> **Mode 2 (Refine)**
- User runs `/test-plan` -> **Mode 1 (Create)**
- User runs `/test-plan` but draft already exists in `sdlc/test/draft/` -> Ask: "A test plan draft already exists. Create new (overwrite) or refine existing?"

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md` -- document formatting standards
2. `skills/shared/rules/quality-rules.md` -- confidence marking, readiness assessment
3. `skills/shared/rules/output-rules.md` -- versioning, input resolution, diff summary
4. `test/shared/rules/test-rules.md` -- test phase rules
5. `test/shared/templates/plan/plan-template.md` -- plan card format
6. `test/plan/knowledge/test-planning-guide.md` -- test planning techniques
7. `test/plan/rules/output-rules.md` -- plan-specific output rules
8. `test/plan/templates/output-template.md` -- expected output structure

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
For test strategy input (required):
1. User specified path?                                    -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. Exists in sdlc/test/input/test-strategy-final.md?      -> YES -> read it -> DONE
3. Exists in sdlc/test/final/test-strategy-final.md?      -> YES -> read it, copy to sdlc/test/input/ -> DONE
4. Not found? -> Ask: "No test strategy found. Please provide a path or run /test-strategy first."

For backlog input (required):
1. User specified path?                                    -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. Exists in sdlc/test/input/backlog-final.md?             -> YES -> read it -> DONE
3. Exists in sdlc/req/final/backlog-final.md?              -> YES -> read it, copy to sdlc/test/input/ -> DONE
4. Not found? -> Ask: "No backlog found. Please provide a path or run /req-backlog first."

For user stories (optional):
1. User specified path?                                    -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. Exists in sdlc/test/input/userstories-final.md?         -> YES -> read it -> DONE
3. Exists in sdlc/req/final/userstories-final.md?          -> YES -> read it, copy to sdlc/test/input/ -> DONE
4. Not found? -> Proceed without user stories.

For DoR/DoD (optional):
1. User specified path?                                    -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. Exists in sdlc/test/input/dor-dod-final.md?             -> YES -> read it -> DONE
3. Exists in sdlc/req/final/dor-dod-final.md?              -> YES -> read it, copy to sdlc/test/input/ -> DONE
4. Not found? -> Proceed without DoR/DoD.

For architecture (optional):
1. User specified path?                                    -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. Exists in sdlc/test/input/architecture-final.md?        -> YES -> read it -> DONE
3. Exists in sdlc/design/final/architecture-final.md?      -> YES -> read it, copy to sdlc/test/input/ -> DONE
4. Not found? -> Proceed without architecture.

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
```

**Mode 2 (Refine):**

```
For plan draft:
1. User specified path?                                    -> YES -> read it, copy to sdlc/test/input/ -> DONE
2. Exists in sdlc/test/input/?                             -> YES -> read it -> DONE
3. Exists in sdlc/test/draft/ (latest version)?            -> YES -> read it, copy to sdlc/test/input/ -> DONE
4. Not found? -> FAIL: "No existing plan found. Run /test-plan first."

For review report:
1. User provided feedback directly in message?     -> Save to sdlc/test/input/review-report.md
2. User specified path?                            -> read it, copy to sdlc/test/input/
3. Exists in sdlc/test/input/review-report.md?    -> read it
4. Not found? -> Ask: "What feedback do you have on the current test plan?"
```

### Step 4: Generate (Mode-specific)

**Mode 1 -- Create:**

Work through the test plan document **section by section, incrementally**:

1. **Test Scope** -- What is in/out of test scope
   - Map to MVP boundary from backlog-final.md
   - Identify which releases/epics are covered
   - List out-of-scope items with reasons
   - Document assumptions about testability
   - Present to user before continuing

2. **Test Phases** -- Define phases aligned with releases
   - For each phase: scope, activities, duration, dependencies, owner
   - Typical phases: Sprint Testing, Feature Testing, System Testing, NFR Testing, Regression + UAT
   - Map phases to release cadence from backlog
   - Define phase dependencies (which phase gates which)

3. **Test Schedule** -- Timeline with milestones
   - Map test activities to sprints from backlog
   - Include Mermaid gantt chart for visual timeline
   - Identify parallel activities
   - Include buffer time (at least 10% of total test duration)
   - Mark critical path and schedule risks

4. **Resource Allocation** -- Who does what
   - Developer testing vs QA testing responsibilities
   - Skill requirements per phase
   - Allocation percentages per phase
   - Tool licenses needed with procurement status and cost

5. **Entry/Exit Criteria** -- Per test phase
   - Entry criteria: what must be true to start the phase
   - Exit criteria: what must be true to finish the phase
   - Align exit criteria with DoD from dor-dod-final.md
   - Every criterion must be measurable and verifiable

6. **Environment Plan** -- Environment setup timeline
   - Environment list with ownership and readiness dates
   - Infrastructure requirements per environment
   - Data preparation approach per environment
   - Service dependency management

7. **Test Deliverables** -- What artifacts are produced
   - Report types, formats, frequency, audience
   - Sign-off documents and their owners
   - Coverage and defect metrics reports

8. **Test Risks & Mitigations** -- Risks specific to testing
   - Environment delays, data issues, tool failures, resource unavailability
   - Impact and likelihood assessment per risk
   - Specific mitigation plan per risk with owner

9. **Defect Management** -- Bug lifecycle process
   - Severity definitions with concrete examples
   - Priority vs severity distinction
   - Triage process and cadence
   - Fix SLA by severity level
   - Regression testing policy after fixes

For each section:
- Apply confidence markers (CONFIRMED / ASSUMED / UNCLEAR)
- Inherit confidence from strategy/req/design artifacts where applicable
- Create Q&A entries for ASSUMED and UNCLEAR items
- Present section to user before moving to next

**Mode 2 -- Refine:**

1. Read existing plan draft (baseline)
2. Read review report / user feedback
3. Run Quality Scorecard analysis
4. Present scorecard to user
5. Apply improvements:
   - Address user feedback point by point
   - Resolve Q&A entries from previous version
   - Upgrade confidence levels where possible
   - Improve schedule estimates and resource allocation
   - Update entry/exit criteria based on new information
   - Refine risk mitigations
6. Tag all changes: `[UPDATED]` for modified items, `[NEW]` for additions
7. Preserve CONFIRMED items unless user explicitly contradicts them
8. Write improved version to `sdlc/test/draft/test-plan-v{N}.md`

### Step 5: Validate Output

Check against rules:
- Every item has a confidence marker (CR-01)
- Test scope aligns with MVP boundary (PLN-01)
- Test phases map to release/sprint structure (PLN-02)
- Entry criteria are measurable and verifiable (PLN-03)
- Exit criteria align with DoD (PLN-04)
- Resource allocation is realistic (PLN-05)
- Schedule includes phase dependencies (PLN-06)
- Environment plan specifies timeline and ownership (PLN-07)
- Defect severity definitions are explicit with examples (PLN-08)
- Section order matches template (PLN-09)
- Confidence markers on all planning estimates (PLN-10)
- Refine mode shows quality scorecard first (PLN-11)
- Schedule includes buffer time >= 10% (PLN-12)
- Test risks have mitigation plans (PLN-13)
- MVP test plan identified separately (PLN-14)
- Traces to requirements exist (TST-01)
- Test pyramid compliance (TST-02)
- NFR test scenarios for each QA attribute (TST-04)
- DoD alignment (TST-09)
- Approval section present (TST-13)
- Cross-references consistent (REQ-10)

### Step 6: Readiness Assessment

Generate assessment per `skills/shared/templates/readiness-assessment.md`:
- Count items by confidence level (each planning decision is 1 item)
- Calculate readiness verdict
- In refine mode: compare with previous version

### Step 7: Output

- **Create mode**: Write to `sdlc/test/draft/test-plan-draft.md`
- **Refine mode**: Write to `sdlc/test/draft/test-plan-v{N}.md`, include Change Log and Diff Summary

Tell the user:
> **Test Plan {created/refined}!**
> - Output: `sdlc/test/draft/test-plan-{version}.md`
> - Readiness: {verdict}
> - Test phases: {N} defined
> - Entry/exit criteria: {N} entry, {N} exit
> - Risks identified: {N}
> - Schedule buffer: {N} days ({%} of total)
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/test-plan-refine`
> - When satisfied, copy to `sdlc/test/final/test-plan-final.md`
> - Then run `/test-cases` to create detailed test cases for each test level

---

## Scope Rules

### This skill DOES:
- Plan test execution across phases, sprints, and releases
- Define test schedule with milestones and dependencies
- Allocate resources and define responsibilities
- Set measurable entry/exit criteria per test phase
- Plan test environments with provisioning timelines
- Define test deliverables and reporting cadence
- Identify testing risks with mitigation plans
- Define defect management process (severity, triage, SLA)

### This skill does NOT:
- Define testing approach or tool selection (belongs to `test/strategy` skill)
- Write individual test cases or test scenarios (belongs to `test/cases` skill)
- Implement actual test code (belongs to `impl/` phase)
- Set up test environments or infrastructure (belongs to `deploy/` phase)
- Configure CI/CD pipeline (belongs to `deploy/cicd` skill)
- Modify strategy, design, or requirements artifacts -- it reads them as input
