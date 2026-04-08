---
name: test-plan
description: >
  Create or refine a detailed test plan. Defines test phases, schedule, resource
  allocation, entry/exit criteria, environment setup, and risk mitigation for
  testing activities. Maps test effort to sprints and releases.
  ONLY activated by command: `/test-plan`. Use `--create`, `--refine`, or `--score` to set mode.
  NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine|--score"
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

## Three Modes

### Mode 1: Create (`--create`)

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

### Mode 2: Refine (`--refine`)

Improve existing test plan based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing plan draft | Yes | `sdlc/test/draft/test-plan-draft.md` or `sdlc/test/draft/test-plan-v{N}.md` |
| Review report / feedback | Yes | User provides directly or as `sdlc/test/input/review-report.md` |
| Additional details | No | New information the user wants to add |

### Mode 3: Score (`--score`)

Evaluate artifact quality with a detailed scoreboard.

| Input | Required | Source |
|-------|----------|--------|
| Artifact to score | Yes | `sdlc/test/draft/test-plan-draft.md` or latest `test-plan-v{N}.md` or `sdlc/test/final/test-plan-final.md`, or user-specified path |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `test-plan-draft.md` | `sdlc/test/draft/` |
| Refine | `test-plan-v{N}.md` | `sdlc/test/draft/` (N = next version number) |
| Score | `test-plan-scoreboard.md` | `sdlc/test/draft/` |

When user is satisfied -> they copy from `sdlc/test/draft/` to `sdlc/test/final/test-plan-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User passes `--score` argument → **Mode 3 (Score)**
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
5. `test/shared/templates/plan/plan-template.md` -- plan card format
6. `test/plan/knowledge/test-planning-guide.md` -- test planning techniques
7. `test/plan/rules/output-rules.md` -- plan-specific output rules
8. `test/plan/templates/output-template.md` -- expected output structure
For Mode 3 (Score): Read resources listed in `skills/shared/knowledge/score-workflow.md`

### Step 3: Resolve Input

Resolve inputs per `skills/shared/knowledge/input-resolution-workflow.md`.

**Create mode inputs:**

| Input | Required | Default Path | Fallback |
|-------|----------|-------------|----------|
| Test strategy | Yes | `sdlc/test/final/test-strategy-final.md` | "No test strategy found. Please provide a path or run /test-strategy first." |
| Backlog | Yes | `sdlc/req/final/backlog-final.md` | "No backlog found. Please provide a path or run /req-backlog first." |
| User stories | No | `sdlc/req/final/userstories-final.md` | Proceed without |
| DoR/DoD | No | `sdlc/req/final/dor-dod-final.md` | Proceed without |
| Architecture | No | `sdlc/design/final/architecture-final.md` | Proceed without |
| Scope | No | `sdlc/init/final/scope-final.md` | Proceed without |
| Risk register | No | `sdlc/init/final/risk-register-final.md` | Proceed without |

**Refine mode inputs:**

| Input | Required | Source |
|-------|----------|--------|
| Existing draft | Yes | `sdlc/test/draft/test-plan-draft.md` or latest `test-plan-v{N}.md` |
| Review feedback | Yes | User message or `sdlc/test/input/review-report.md` |

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

**Mode 3 -- Score:**

Follow the standard score workflow in `skills/shared/knowledge/score-workflow.md` using this skill's rules and templates as context.

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

**Mode 3 (Score):** Output per score workflow — sdlc/test/draft/test-plan-scoreboard.md

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
> - Review the output and provide feedback via `/test-plan --refine`
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
