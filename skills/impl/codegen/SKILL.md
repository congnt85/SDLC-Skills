---
name: impl-codegen
description: >
  Create or refine a code generation plan. Defines project directory structure,
  module specifications, configuration files, ORM models, API route scaffolding,
  and test infrastructure. Plans what code to generate, not the code itself.
  ONLY activated by command: `/impl-codegen`. Use `--create` or `--refine` to set mode.
  NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine [path to architecture-final.md or tech-stack-final.md] (md/pdf/docx/xlsx/pptx)"
version: "1.0"
category: sdlc
phase: impl
prev_phase: impl-sprint
next_phase: impl-workflow
---

# Code Generation Plan Skill

## Purpose

Create or refine a code generation plan (`codegen-plan-draft.md`) that defines the complete project scaffolding blueprint — directory layout, module specifications, ORM model definitions, API route stubs, configuration files, and test infrastructure.

This skill bridges "what to build" (design artifacts) and "how to build it" (actual implementation). It plans what code files to generate, their structure, and their relationships — without writing the actual source code.

---

## Two Modes

### Mode 1: Create (`--create`)

Generate a code generation plan from design artifacts.

| Input | Required | Source |
|-------|----------|--------|
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

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `codegen-plan-draft.md` | `sdlc/impl/draft/` |
| Refine | `codegen-plan-v{N}.md` | `sdlc/impl/draft/` (N = next version number) |

When user is satisfied -> they copy from `sdlc/impl/draft/` to `sdlc/impl/final/codegen-plan-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User passes `--refine` argument → **Mode 2 (Refine)**
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
6. `impl/codegen/knowledge/scaffolding-guide.md` -- scaffolding techniques
7. `impl/codegen/rules/output-rules.md` -- codegen-specific output rules
8. `impl/codegen/templates/output-template.md` -- expected output structure

### Step 3: Resolve Input

**File Type Conversion** (applies to all file inputs):

Before reading any input file, check its extension:
- `.md` → Read directly, no conversion needed
- `.pdf` → Run `/read-pdf <path> sdlc/impl/input/` → read the converted .md
- `.docx` / `.doc` → Run `/read-word <path> sdlc/impl/input/` → read the converted .md
- `.xlsx` / `.xls` → Run `/read-excel <path> sdlc/impl/input/` → read the converted .md
- `.pptx` / `.ppt` → Run `/read-ppt <path> sdlc/impl/input/` → read the converted .md

Converted files are saved to `sdlc/impl/input/`. If a converted .md already exists and is newer than the source, skip conversion.

**Mode 1 (Create):**

```
For tech-stack input (required):
1. User specified path?                                    -> YES -> read it, copy to sdlc/impl/input/ -> DONE
2. Exists in sdlc/impl/input/tech-stack-final.md?          -> YES -> read it -> DONE
3. Exists in sdlc/design/final/tech-stack-final.md?        -> YES -> read it, copy to sdlc/impl/input/ -> DONE
4. Not found? -> Ask: "No tech stack found. Please provide a path or run /design-stack first."

For architecture input (required):
1. User specified path?                                    -> YES -> read it, copy to sdlc/impl/input/ -> DONE
2. Exists in sdlc/impl/input/architecture-final.md?        -> YES -> read it -> DONE
3. Exists in sdlc/design/final/architecture-final.md?      -> YES -> read it, copy to sdlc/impl/input/ -> DONE
4. Not found? -> Ask: "No architecture found. Please provide a path or run /design-arch first."

For database input (required):
1. User specified path?                                    -> YES -> read it, copy to sdlc/impl/input/ -> DONE
2. Exists in sdlc/impl/input/database-final.md?            -> YES -> read it -> DONE
3. Exists in sdlc/design/final/database-final.md?          -> YES -> read it, copy to sdlc/impl/input/ -> DONE
4. Not found? -> Ask: "No database design found. Please provide a path or run /design-db first."

For API input (required):
1. User specified path?                                    -> YES -> read it, copy to sdlc/impl/input/ -> DONE
2. Exists in sdlc/impl/input/api-final.md?                 -> YES -> read it -> DONE
3. Exists in sdlc/design/final/api-final.md?               -> YES -> read it, copy to sdlc/impl/input/ -> DONE
4. Not found? -> Ask: "No API design found. Please provide a path or run /design-api first."

For test strategy (optional):
1. User specified path?                                    -> YES -> read it, copy to sdlc/impl/input/ -> DONE
2. Exists in sdlc/impl/input/test-strategy-final.md?       -> YES -> read it -> DONE
3. Exists in sdlc/test/final/test-strategy-final.md?       -> YES -> read it, copy to sdlc/impl/input/ -> DONE
4. Not found? -> Proceed without test strategy.

For DoR/DoD (optional):
1. User specified path?                                    -> YES -> read it, copy to sdlc/impl/input/ -> DONE
2. Exists in sdlc/impl/input/dor-dod-final.md?             -> YES -> read it -> DONE
3. Exists in sdlc/impl/final/dor-dod-final.md?             -> YES -> read it, copy to sdlc/impl/input/ -> DONE
4. Not found? -> Proceed without DoR/DoD.
```

**Mode 2 (Refine):**

```
For codegen plan draft:
1. User specified path?                                    -> YES -> read it, copy to sdlc/impl/input/ -> DONE
2. Exists in sdlc/impl/input/?                             -> YES -> read it -> DONE
3. Exists in sdlc/impl/draft/ (latest version)?            -> YES -> read it, copy to sdlc/impl/input/ -> DONE
4. Not found? -> FAIL: "No existing codegen plan found. Run /impl-codegen first."

For review report:
1. User provided feedback directly in message?      -> Save to sdlc/impl/input/review-report.md
2. User specified path?                             -> read it, copy to sdlc/impl/input/
3. Exists in sdlc/impl/input/review-report.md?     -> read it
4. Not found? -> Ask: "What feedback do you have on the current codegen plan?"
```

### Step 4: Generate (Mode-specific)

**Mode 1 -- Create:**

Work through the codegen plan **section by section, incrementally**:

1. **Project Structure** -- Full directory tree mirroring architecture components
   - Map each architecture component to a source directory under `src/`
   - Add test directories (unit, integration, e2e)
   - Add configuration, scripts, and infrastructure directories
   - Follow framework conventions (NestJS modules, React feature folders, etc.)
   - Present proposed directory tree to user before detailing modules

2. **Module Specifications** -- For each architecture component
   - Define module name, source component, associated stories (US-xxx)
   - List all files to generate within the module (controller, service, DTO, entity, etc.)
   - Define key interfaces and types
   - Specify inter-module dependencies
   - Tag MVP vs [FUTURE] modules

3. **ORM Models/Entities** -- For each database table from database-final.md
   - Map table to entity/model file
   - Map column types to language types (UUID->string, TIMESTAMPTZ->Date, JSONB->Record)
   - Map relationships to decorators/attributes (@OneToMany, @ManyToOne, etc.)
   - Map enums to language-level enums or union types
   - Include validation decorators

4. **API Route Scaffolding** -- For each API resource from api-final.md
   - Map resource to controller file
   - Map each endpoint to a handler method with HTTP method, path, and handler name
   - Create DTO specifications for request validation (CreateXxxDto, UpdateXxxDto)
   - Map auth requirements to guards/middleware
   - Map rate limits to decorators
   - Link each route to source stories (US-xxx)

5. **Configuration Files** -- All config files needed for the tech stack
   - Language config (tsconfig.json, pyproject.toml, etc.)
   - Linting and formatting (eslint, prettier, etc.)
   - Test config (jest, vitest, pytest, etc.)
   - Docker files (Dockerfile, docker-compose.yml)
   - Environment config (.env.example with all vars documented)
   - Git config (.gitignore, hooks)
   - CI config (.github/workflows/)
   - ORM config (prisma schema, TypeORM config, etc.)

6. **Test Infrastructure** -- Test directory structure and setup
   - Co-located or separated test structure
   - Test config files with coverage thresholds
   - Fixture and factory setup (test data builders)
   - Test utilities (test app creation, database seeding, auth helpers)
   - Integration test setup (testcontainers, test database)
   - E2E test config (Playwright, Cypress, etc.)

7. **Shared Utilities** -- Common modules every project needs
   - Error handling (custom exceptions, global exception filter)
   - Logging (structured logging setup)
   - Auth middleware/guards
   - Validation pipe/middleware
   - Response formatting (standard envelope)
   - Config validation (environment variable schema)

8. **File Inventory** -- Complete list of ALL files to generate
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

### Step 5: Validate Output

Check against rules:
- Every item has a confidence marker (CR-01)
- Directory structure mirrors architecture components (CDG-01)
- Every architecture component maps to a module (CDG-02)
- Every database table has an ORM model spec (CDG-03)
- Every API resource has a controller spec (CDG-04)
- Every module specifies source stories (CDG-05)
- Config files match tech-stack versions (CDG-06)
- Test infra matches test strategy tools (CDG-07)
- Complete file inventory present (CDG-08)
- Correct section order (CDG-09)
- Naming follows language/framework conventions (CDG-12, IMP-09)
- Environment variables documented (CDG-13)
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
> - Files planned: {total} ({N} source, {N} test, {N} config)
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/impl-codegen --refine`
> - When satisfied, copy to `sdlc/impl/final/codegen-plan-final.md`
> - Then run `/impl-workflow` to define the implementation workflow

---

## Scope Rules

### This skill DOES:
- Plan project directory structure from architecture components
- Define module specifications with files, interfaces, and dependencies
- Specify ORM model/entity definitions from database design
- Plan API controller/route scaffolding from API design
- List all configuration files with key settings
- Plan test infrastructure setup
- Define shared utility modules
- Create a complete file inventory with purpose and source references

### This skill does NOT:
- Write actual source code (belongs to code generation / developer work)
- Implement business logic (belongs to implementation execution)
- Run code generators or CLI scaffolding tools (belongs to developer work)
- Set up environments (belongs to `deploy/` phase)
- Define sprint plans (belongs to `impl/sprint` skill)
- Make technology decisions (reads from `design/` phase artifacts)
- Define test cases (belongs to `test/` phase)
- Modify design artifacts -- it reads them as input
