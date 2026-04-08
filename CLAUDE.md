# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repo builds Claude Code skills covering the full Software Development Lifecycle (SDLC) using Agile/Scrum methodology. Skills are organized by SDLC phase, with each skill having its own `SKILL.md`, knowledge base, rules, and templates. Each skill supports two modes: create and refine (iterative improvement). Skills install to `~/.claude/skills/`.

## Build Status

All 7 phases are complete (26 skills + 4 utilities). Each skill accepts `--create` or `--refine` as mode argument. The project migrated from a monolithic structure to a split architecture with isolated, focused skills.

| Phase | Skill | Command | Status |
|-------|-------|---------|--------|
| **init** | charter | `/init-charter` | **Done** |
| **init** | scope | `/init-scope` | **Done** |
| **init** | risk | `/init-risk` | **Done** |
| **req** | epic | `/req-epic` | **Done** |
| **req** | userstory | `/req-userstory` | **Done** |
| **req** | backlog | `/req-backlog` | **Done** |
| **req** | traceability | `/req-trace` | **Done** |
| **design** | tech-stack | `/design-stack` | **Done** |
| **design** | architecture | `/design-arch` | **Done** |
| **design** | database | `/design-db` | **Done** |
| **design** | api | `/design-api` | **Done** |
| **design** | adr | `/design-adr` | **Done** |
| **test** | strategy | `/test-strategy` | **Done** |
| **test** | plan | `/test-plan` | **Done** |
| **test** | cases | `/test-cases` | **Done** |
| **impl** | sprint | `/impl-sprint` | **Done** |
| **impl** | codegen | `/impl-codegen` | **Done** |
| **impl** | workflow | `/impl-workflow` | **Done** |
| **deploy** | cicd | `/deploy-cicd` | **Done** |
| **deploy** | release | `/deploy-release` | **Done** |
| **deploy** | env | `/deploy-env` | **Done** |
| **ops** | monitoring | `/ops-monitor` | **Done** |
| **ops** | incident | `/ops-incident` | **Done** |
| **ops** | sla | `/ops-sla` | **Done** |
| **ops** | runbook | `/ops-runbook` | **Done** |
| **ops** | change | `/ops-change` | **Done** |
| **utils** | read-pdf | `/read-pdf` | **Done** |
| **utils** | read-word | `/read-word` | **Done** |
| **utils** | read-excel | `/read-excel` | **Done** |
| **utils** | read-ppt | `/read-ppt` | **Done** |

## Repository Structure

```
skills/                          # Skill definitions (installed to ~/.claude/skills/)
  shared/                        # Project-wide: rules/, knowledge/, templates/
    utils/                       # Converter utilities: read-pdf, read-word, read-excel, read-ppt
  <phase>/
    shared/                      # Phase-wide: rules/, knowledge/, templates/
    <skill>/
      SKILL.md                   # Skill definition (two modes: create + refine)
      knowledge/                 # Skill-specific knowledge
      rules/                     # Skill-specific output rules
      templates/                 # Output template + sample output
```

### Project Directory (created in user's working directory)

```
sdlc/                            # All skill I/O lives here (in user's project dir)
  <phase>/
    input/                       # Converted non-md files (from /read-pdf, /read-word, etc.)
    draft/                       # Skill output (skills write here)
    final/                       # Promoted artifacts (user copies drafts here)
```

## Architecture Patterns

- **3-layer resource scoping**: `skills/shared/` (project-wide) -> `<phase>/shared/` (phase-wide) -> `<skill>/` (skill-specific). Skills only read their own layer + ancestors, never sibling skills.
- **Two modes per skill**: Mode 1 (Create) generates from input; Mode 2 (Refine) improves existing draft from user feedback. Both modes in one SKILL.md.
- **Project directory I/O**: All skill input/output goes to `sdlc/<phase>/` in the user's project directory (cwd), NOT in the skills installation directory.
- **Multi-format input**: Skills accept any file type (md/pdf/docx/xlsx/pptx). Non-md files are auto-converted via `/read-pdf`, `/read-word`, `/read-excel`, `/read-ppt` utility skills. Converted files are cached in `sdlc/<phase>/input/`.
- **Input resolution priority**: User-specified path > `sdlc/<phase>/input/` > previous phase's `sdlc/<phase>/final/`. Converted files saved to `sdlc/<phase>/input/`.
- **Draft/final separation**: Skills write to `sdlc/<phase>/draft/`. User promotes to `sdlc/<phase>/final/` when satisfied. Next phase reads from `final/`.
- **Confidence marking**: Every item gets ✅ CONFIRMED / 🔶 ASSUMED / ❓ UNCLEAR. Readiness assessment counts these for go/no-go verdict.
- **Pipeline flow**: sdlc/init/final/ -> req reads -> sdlc/req/final/ -> design reads -> sdlc/design/final/ -> test+impl read -> deploy reads -> ops reads.

## Install & Test

```bash
./install.sh              # Copy skills to ~/.claude/skills/
./install.sh --symlink    # Symlink for development
```

## Building New Skills

Follow the init phase pattern. Each skill needs 5 files:
1. `SKILL.md` — workflow definition with create + refine modes
2. `knowledge/<guide>.md` — domain techniques and knowledge
3. `rules/output-rules.md` — skill-specific output constraints
4. `templates/output-template.md` — expected output structure
5. `templates/sample-output.md` — complete example output (TaskFlow project)

Read the plan at `/root/.claude/plans/calm-tinkering-sutton.md` for the full folder structure and build order.
