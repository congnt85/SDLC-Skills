---
name: impl-codegen
description: >
  Create or refine a code generation plan. Defines module specifications,
  ORM models, API route scaffolding, test infrastructure, and file inventory.
  Plans what code to generate, not the code itself. Requires scaffold plan as input.
  ONLY activated by command: `/impl-codegen`. Use `--create`, `--refine`, or `--score` to set mode.
  NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine|--score"
version: "2.0"
category: sdlc
phase: impl
prev_phase: impl-scaffold
next_phase: impl-workflow
---

# Code Generation Plan Skill

## Purpose

Create or refine a code generation plan (`codegen-plan-draft.md`) that defines module specifications, ORM model definitions, API route stubs, test infrastructure, and a complete file inventory.

This skill takes the scaffold plan (directory layout, config files, shared utilities) as input and plans the feature-level code files to generate — their structure, interfaces, and relationships — without writing the actual source code.

---

## Three Modes

### Mode 1: Create (`--create`)

Generate a code generation plan from scaffold plan and design artifacts.

| Input | Required | Source |
|-------|----------|--------|
| Scaffold Plan (final) | Yes | `sdlc/impl/final/scaffold-plan-final.md` or user-specified path |
| Tech Stack (final) | Yes | `sdlc/design/final/tech-stack-final.md` or user-specified path |
| Architecture (final) | Yes | `sdlc/design/final/architecture-final.md` or user-specified path |
| Database (final) | Yes | `sdlc/design/final/database-final.md` or user-specified path |
| API (final) | Yes | `sdlc/design/final/api-final.md` or user-specified path |
| Test Strategy (final) | No | `sdlc/test/final/test-strategy-final.md` — test tools and structure |
| DoR/DoD (final) | No | `sdlc/impl/final/dor-dod-final.md` — code quality standards |

### Mode 2: Refine (`--refine`)

Improve existing codegen plan based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing codegen plan draft | Yes | `sdlc/impl/draft/codegen-plan-draft.md` or `sdlc/impl/draft/codegen-plan-v{N}.md` |
| Review report / feedback | Yes | User provides directly or as `sdlc/impl/input/review-report.md` |
| Additional details | No | New information the user wants to add |

### Mode 3: Score (`--score`)

Evaluate artifact quality with a detailed scoreboard.

| Input | Required | Source |
|-------|----------|--------|
| Artifact to score | Yes | `sdlc/impl/draft/codegen-plan-draft.md` or latest `codegen-plan-v{N}.md` or `sdlc/impl/final/codegen-plan-final.md`, or user-specified path |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `codegen-plan-draft.md` | `sdlc/impl/draft/` |
| Refine | `codegen-plan-v{N}.md` | `sdlc/impl/draft/` (N = next version number) |
| Score | `codegen-plan-scoreboard.md` | `sdlc/impl/draft/` |

When user is satisfied -> they copy from `sdlc/impl/draft/` to `sdlc/impl/final/codegen-plan-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User passes `--refine` argument → **Mode 2 (Refine)**
- User passes `--score` argument → **Mode 3 (Score)**
- User passes `--create` argument → **Mode 1 (Create)**
- No argument specified AND existing draft exists in `sdlc/impl/draft/` → Ask: "A draft already exists. Use `--create` to start fresh or `--refine` to improve it."
- No argument specified AND no draft exists → **Mode 1 (Create)**

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md` -- document formatting standards
2. `skills/shared/rules/quality-rules.md` -- confidence marking, readiness assessment
3. `skills/shared/rules/output-rules.md` -- versioning, input resolution, diff summary
4. `impl/shared/rules/impl-rules.md` -- implementation phase rules
5. `impl/shared/templates/codegen/codegen-template.md` -- codegen card format
6. `impl/codegen/knowledge/scaffolding-guide.md` -- scaffolding techniques (sections 2, 3, 5)
7. `impl/codegen/rules/output-rules.md` -- codegen-specific output rules
8. `impl/codegen/templates/output-template.md` -- expected output structure
For Mode 3 (Score): Read resources listed in `skills/shared/knowledge/score-workflow.md`

### Step 3: Resolve Input

Resolve inputs per `skills/shared/knowledge/input-resolution-workflow.md`.

**Create mode inputs:**

| Input | Required | Default Path | Fallback |
|-------|----------|-------------|----------|
| Scaffold Plan | Yes | `sdlc/impl/final/scaffold-plan-final.md` | "No scaffold plan found. Please provide a path or run /impl-scaffold first." |
| Tech Stack | Yes | `sdlc/design/final/tech-stack-final.md` | "No tech stack found. Please provide a path or run /design-stack first." |
| Architecture | Yes | `sdlc/design/final/architecture-final.md` | "No architecture found. Please provide a path or run /design-arch first." |
| Database | Yes | `sdlc/design/final/database-final.md` | "No database design found. Please provide a path or run /design-db first." |
| API | Yes | `sdlc/design/final/api-final.md` | "No API design found. Please provide a path or run /design-api first." |
| Test Strategy | No | `sdlc/test/final/test-strategy-final.md` | Proceed without |
| DoR/DoD | No | `sdlc/impl/final/dor-dod-final.md` | Proceed without |

**Refine mode inputs:**

| Input | Required | Source |
|-------|----------|--------|
| Existing draft | Yes | `sdlc/impl/draft/codegen-plan-draft.md` or latest `codegen-plan-v{N}.md` |
| Review feedback | Yes | User message or `sdlc/impl/input/review-report.md` |

### Step 4: Generate (Mode-specific)

**Mode 1 -- Create:**

Work through the codegen plan **section by section, incrementally**. Use the scaffold plan as the foundation — it provides the directory structure, config files, and shared utilities. This skill adds the feature-level detail.

1. **Module Specifications** -- For each architecture component
   - Define module name, source component, associated stories (US-xxx)
   - List all files to generate within the module (controller, service, DTO, entity, etc.)
   - Define key interfaces and types
   - Specify inter-module dependencies
   - Tag MVP vs [FUTURE] modules

2. **ORM Models/Entities** -- For each database table from database-final.md
   - Map table to entity/model file
   - Map column types to language types (UUID->string, TIMESTAMPTZ->Date, JSONB->Record)
   - Map relationships to decorators/attributes (@OneToMany, @ManyToOne, etc.)
   - Map enums to language-level enums or union types
   - Include validation decorators

3. **API Route Scaffolding** -- For each API resource from api-final.md
   - Map resource to controller file
   - Map each endpoint to a handler method with HTTP method, path, and handler name
   - Create DTO specifications for request validation (CreateXxxDto, UpdateXxxDto)
   - Map auth requirements to guards/middleware
   - Map rate limits to decorators
   - Link each route to source stories (US-xxx)

4. **Test Infrastructure** -- Test directory structure and setup
   - Co-located or separated test structure
   - Test config files with coverage thresholds
   - Fixture and factory setup (test data builders)
   - Test utilities (test app creation, database seeding, auth helpers)
   - Integration test setup (testcontainers, test database)
   - E2E test config (Playwright, Cypress, etc.)

5. **File Inventory** -- Complete list of ALL files to generate
   - File path, purpose, source reference (which design artifact), MVP status
   - Summary counts: total files, source files, test files, config files

For each section:
- Apply confidence markers (CONFIRMED / ASSUMED / UNCLEAR)
- Inherit confidence from design artifacts where applicable
- Create Q&A entries for ASSUMED and UNCLEAR items
- Present section to user before moving to next

**Mode 2 -- Refine:**

1. Read existing codegen plan draft (baseline)
2. Read review report / user feedback
3. Run Quality Scorecard analysis
4. Present scorecard to user
5. Apply improvements:
   - Address user feedback point by point
   - Resolve Q&A entries from previous version
   - Upgrade confidence levels where possible
   - Add missing modules or files discovered during review
   - Adjust directory structure based on feedback
   - Rebalance MVP vs [FUTURE] tagging if needed
6. Tag all changes: `[UPDATED]` for modified items, `[NEW]` for additions
7. Preserve CONFIRMED items unless user explicitly contradicts them
8. Write improved version to `sdlc/impl/draft/codegen-plan-v{N}.md`

**Mode 3 -- Score:**

Follow the standard score workflow in `skills/shared/knowledge/score-workflow.md` using this skill's rules and templates as context.

### Step 5: Validate Output

Check against rules:
- Every item has a confidence marker (CR-01)
- Every architecture component maps to a module (CDG-02)
- Every database table has an ORM model spec (CDG-03)
- Every API resource has a controller spec (CDG-04)
- Every module specifies source stories (CDG-05)
- Test infra matches test strategy tools (CDG-07)
- Complete file inventory present (CDG-08)
- Correct section order (CDG-09)
- Naming follows language/framework conventions (CDG-12, IMP-09)
- MVP modules identified (CDG-14)
- Traces to design artifacts (IMP-01)
- Tech stack compliance (IMP-02)
- No gold plating (IMP-06)
- Dependency ordering respected (IMP-08)
- Approval section present (IMP-10)

### Step 6: Readiness Assessment

Generate assessment per `skills/shared/templates/readiness-assessment.md`:
- Count items by confidence level (each module specification is 1 item)
- Calculate readiness verdict
- In refine mode: compare with previous version

### Step 7: Output

- **Create mode**: Write to `sdlc/impl/draft/codegen-plan-draft.md`
- **Refine mode**: Write to `sdlc/impl/draft/codegen-plan-v{N}.md`, include Change Log and Diff Summary

Tell the user:
> **Codegen plan {created/refined}!**
> - Output: `sdlc/impl/draft/codegen-plan-{version}.md`
> - Readiness: {verdict}
> - Modules: {total} (MVP: {N}, Future: {N})
> - Files planned: {total} ({N} source, {N} test)
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/impl-codegen --refine`
> - When satisfied, copy to `sdlc/impl/final/codegen-plan-final.md`
> - Then run `/impl-workflow` to define the implementation workflow

**Mode 3 (Score):** Output per score workflow — sdlc/impl/draft/codegen-plan-scoreboard.md

---

## Scope Rules

### This skill DOES:
- Define module specifications with files, interfaces, and dependencies
- Specify ORM model/entity definitions from database design
- Plan API controller/route scaffolding from API design
- Plan test infrastructure setup
- Create a complete file inventory with purpose and source references

### This skill does NOT:
- Plan project directory structure (belongs to `impl/scaffold`)
- List configuration files (belongs to `impl/scaffold`)
- Define shared utility modules (belongs to `impl/scaffold`)
- Write actual source code (belongs to code generation / developer work)
- Implement business logic (belongs to implementation execution)
- Run code generators or CLI scaffolding tools (belongs to developer work)
- Set up environments (belongs to `deploy/` phase)
- Define sprint plans (belongs to `impl/sprint` skill)
- Make technology decisions (reads from `design/` phase artifacts)
- Define test cases (belongs to `test/` phase)
- Modify design artifacts -- it reads them as input
