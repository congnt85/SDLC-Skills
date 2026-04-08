---
name: impl-scaffold
description: >
  Create or refine a project scaffolding plan. Defines directory structure,
  configuration files, and shared utility modules from design artifacts.
  Plans the foundational project layout before module-level code generation.
  ONLY activated by command: `/impl-scaffold`. Use `--create`, `--refine`, or `--score` to set mode.
  NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine|--score"
version: "1.0"
category: sdlc
phase: impl
prev_phase: impl-sprint
next_phase: impl-codegen
---

# Scaffold Plan Skill

## Purpose

Create or refine a project scaffolding plan (`scaffold-plan-draft.md`) that defines the complete project foundation — directory layout, configuration files, and shared utility modules.

This skill bridges "what to build" (design artifacts) and "how to structure it" (project skeleton). It plans the directory tree, all configuration files, and common modules that every feature module will depend on — without writing the actual source code or defining individual feature modules.

---

## Three Modes

### Mode 1: Create (`--create`)

Generate a scaffolding plan from design artifacts.

| Input | Required | Source |
|-------|----------|--------|
| Tech Stack (final) | Yes | `sdlc/design/final/tech-stack-final.md` or user-specified path |
| Architecture (final) | Yes | `sdlc/design/final/architecture-final.md` or user-specified path |
| Database (final) | No | `sdlc/design/final/database-final.md` — informs ORM config |
| API (final) | No | `sdlc/design/final/api-final.md` — informs middleware/guards |
| Test Strategy (final) | No | `sdlc/test/final/test-strategy-final.md` — test tools and structure |

### Mode 2: Refine (`--refine`)

Improve existing scaffold plan based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing scaffold plan draft | Yes | `sdlc/impl/draft/scaffold-plan-draft.md` or `sdlc/impl/draft/scaffold-plan-v{N}.md` |
| Review report / feedback | Yes | User provides directly or as `sdlc/impl/input/review-report.md` |
| Additional details | No | New information the user wants to add |

### Mode 3: Score (`--score`)

Evaluate artifact quality with a detailed scoreboard.

| Input | Required | Source |
|-------|----------|--------|
| Artifact to score | Yes | `sdlc/impl/draft/scaffold-plan-draft.md` or latest `scaffold-plan-v{N}.md` or `sdlc/impl/final/scaffold-plan-final.md`, or user-specified path |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `scaffold-plan-draft.md` | `sdlc/impl/draft/` |
| Refine | `scaffold-plan-v{N}.md` | `sdlc/impl/draft/` (N = next version number) |
| Score | `scaffold-plan-scoreboard.md` | `sdlc/impl/draft/` |

When user is satisfied -> they copy from `sdlc/impl/draft/` to `sdlc/impl/final/scaffold-plan-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User passes `--refine` argument -> **Mode 2 (Refine)**
- User passes `--score` argument -> **Mode 3 (Score)**
- User passes `--create` argument -> **Mode 1 (Create)**
- No argument specified AND existing draft exists in `sdlc/impl/draft/` -> Ask: "A draft already exists. Use `--create` to start fresh or `--refine` to improve it."
- No argument specified AND no draft exists -> **Mode 1 (Create)**

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md` -- document formatting standards
2. `skills/shared/rules/quality-rules.md` -- confidence marking, readiness assessment
3. `skills/shared/rules/output-rules.md` -- versioning, input resolution, diff summary
4. `impl/shared/rules/impl-rules.md` -- implementation phase rules
5. `impl/codegen/knowledge/scaffolding-guide.md` -- scaffolding techniques (sections 1, 4, 6)
6. `impl/scaffold/rules/output-rules.md` -- scaffold-specific output rules
7. `impl/scaffold/templates/output-template.md` -- expected output structure
For Mode 3 (Score): Read resources listed in `skills/shared/knowledge/score-workflow.md`

### Step 3: Resolve Input

Resolve inputs per `skills/shared/knowledge/input-resolution-workflow.md`.

**Create mode inputs:**

| Input | Required | Default Path | Fallback |
|-------|----------|-------------|----------|
| Tech Stack | Yes | `sdlc/design/final/tech-stack-final.md` | "No tech stack found. Please provide a path or run /design-stack first." |
| Architecture | Yes | `sdlc/design/final/architecture-final.md` | "No architecture found. Please provide a path or run /design-arch first." |
| Database | No | `sdlc/design/final/database-final.md` | Proceed without |
| API | No | `sdlc/design/final/api-final.md` | Proceed without |
| Test Strategy | No | `sdlc/test/final/test-strategy-final.md` | Proceed without |

**Refine mode inputs:**

| Input | Required | Source |
|-------|----------|--------|
| Existing draft | Yes | `sdlc/impl/draft/scaffold-plan-draft.md` or latest `scaffold-plan-v{N}.md` |
| Review feedback | Yes | User message or `sdlc/impl/input/review-report.md` |

### Step 4: Generate (Mode-specific)

**Mode 1 -- Create:**

Work through the scaffold plan **section by section, incrementally**:

1. **Project Structure** -- Full directory tree mirroring architecture components
   - Map each architecture component to a source directory under `src/`
   - Add test directories (unit, integration, e2e)
   - Add configuration, scripts, and infrastructure directories
   - Follow framework conventions (NestJS modules, React feature folders, etc.)
   - Present proposed directory tree to user before detailing other sections

2. **Configuration Files** -- All config files needed for the tech stack
   - Language config (tsconfig.json, pyproject.toml, etc.)
   - Linting and formatting (eslint, prettier, etc.)
   - Test config (jest, vitest, pytest, etc.)
   - Docker files (Dockerfile, docker-compose.yml)
   - Environment config (.env.example with all vars documented)
   - Git config (.gitignore, hooks)
   - CI config (.github/workflows/)
   - ORM config (prisma schema, TypeORM config, etc.)

3. **Shared Utilities** -- Common modules every project needs
   - Error handling (custom exceptions, global exception filter)
   - Logging (structured logging setup)
   - Auth middleware/guards
   - Validation pipe/middleware
   - Response formatting (standard envelope)
   - Config validation (environment variable schema)

For each section:
- Apply confidence markers (CONFIRMED / ASSUMED / UNCLEAR)
- Inherit confidence from design artifacts where applicable
- Create Q&A entries for ASSUMED and UNCLEAR items
- Present section to user before moving to next

**Mode 2 -- Refine:**

1. Read existing scaffold plan draft (baseline)
2. Read review report / user feedback
3. Run Quality Scorecard analysis
4. Present scorecard to user
5. Apply improvements:
   - Address user feedback point by point
   - Resolve Q&A entries from previous version
   - Upgrade confidence levels where possible
   - Adjust directory structure based on feedback
   - Add missing config files or shared utilities
6. Tag all changes: `[UPDATED]` for modified items, `[NEW]` for additions
7. Preserve CONFIRMED items unless user explicitly contradicts them
8. Write improved version to `sdlc/impl/draft/scaffold-plan-v{N}.md`

**Mode 3 -- Score:**

Follow the standard score workflow in `skills/shared/knowledge/score-workflow.md` using this skill's rules and templates as context.

### Step 5: Validate Output

Check against rules:
- Every item has a confidence marker (CR-01)
- Directory structure mirrors architecture components (SCF-01)
- Config files match tech-stack versions (SCF-02)
- Environment variables documented (SCF-03)
- Shared utilities cover cross-cutting concerns (SCF-04)
- Correct section order (SCF-05)
- Naming follows language/framework conventions (SCF-06)
- Traces to design artifacts (IMP-01)
- Tech stack compliance (IMP-02)
- No gold plating (IMP-06)
- Approval section present (IMP-10)

### Step 6: Readiness Assessment

Generate assessment per `skills/shared/templates/readiness-assessment.md`:
- Count items by confidence level (each config file and utility module is 1 item)
- Calculate readiness verdict
- In refine mode: compare with previous version

### Step 7: Output

- **Create mode**: Write to `sdlc/impl/draft/scaffold-plan-draft.md`
- **Refine mode**: Write to `sdlc/impl/draft/scaffold-plan-v{N}.md`, include Change Log and Diff Summary

Tell the user:
> **Scaffold plan {created/refined}!**
> - Output: `sdlc/impl/draft/scaffold-plan-{version}.md`
> - Readiness: {verdict}
> - Directories: {total top-level modules}
> - Config files: {N}
> - Shared utilities: {N}
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/impl-scaffold --refine`
> - When satisfied, copy to `sdlc/impl/final/scaffold-plan-final.md`
> - Then run `/impl-codegen` to plan module specs, ORM models, API routes, and test infra

**Mode 3 (Score):** Output per score workflow -- sdlc/impl/draft/scaffold-plan-scoreboard.md

---

## Scope Rules

### This skill DOES:
- Plan project directory structure from architecture components
- List all configuration files with key settings
- Define shared utility modules (error handling, logging, auth, validation, response formatting, config)
- Map architecture components to top-level directories
- Document environment variables

### This skill does NOT:
- Define module specifications with files, interfaces, and dependencies (belongs to `impl/codegen`)
- Specify ORM model/entity definitions (belongs to `impl/codegen`)
- Plan API controller/route scaffolding (belongs to `impl/codegen`)
- Plan test infrastructure setup (belongs to `impl/codegen`)
- Create a file inventory (belongs to `impl/codegen`)
- Write actual source code (belongs to developer work)
- Set up environments (belongs to `deploy/` phase)
- Define sprint plans (belongs to `impl/sprint` skill)
- Make technology decisions (reads from `design/` phase artifacts)
