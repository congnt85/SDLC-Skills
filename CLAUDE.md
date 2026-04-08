# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repo builds Claude Code skills covering the full Software Development Lifecycle (SDLC) using Agile/Scrum methodology. Skills are organized by SDLC phase, with each skill having its own `SKILL.md`, knowledge base, rules, and templates. Each skill supports two modes: create and refine (iterative improvement). Skills install to `~/.claude/skills/`.

## Build Status

All 7 phases are complete (23 skills, 46 commands). The project migrated from a monolithic structure (`sdlc-initiation`, `sdlc-requirements`, etc.) to a split architecture with isolated, focused skills. Old monolithic skills in `skills/sdlc-*` are being replaced.

| Phase | Skill | Command | Status |
|-------|-------|---------|--------|
| **init** | charter | `/init-charter`, `/init-charter-refine` | **Done** |
| **init** | scope | `/init-scope`, `/init-scope-refine` | **Done** |
| **init** | risk | `/init-risk`, `/init-risk-refine` | **Done** |
| **req** | epic | `/req-epic`, `/req-epic-refine` | **Done** |
| **req** | userstory | `/req-userstory`, `/req-userstory-refine` | **Done** |
| **req** | backlog | `/req-backlog`, `/req-backlog-refine` | **Done** |
| **req** | traceability | `/req-trace`, `/req-trace-refine` | **Done** |
| **design** | tech-stack | `/design-stack`, `/design-stack-refine` | **Done** |
| **design** | architecture | `/design-arch`, `/design-arch-refine` | **Done** |
| **design** | database | `/design-db`, `/design-db-refine` | **Done** |
| **design** | api | `/design-api`, `/design-api-refine` | **Done** |
| **design** | adr | `/design-adr`, `/design-adr-refine` | **Done** |
| **test** | strategy | `/test-strategy`, `/test-strategy-refine` | **Done** |
| **test** | plan | `/test-plan`, `/test-plan-refine` | **Done** |
| **test** | cases | `/test-cases`, `/test-cases-refine` | **Done** |
| **impl** | sprint | `/impl-sprint`, `/impl-sprint-refine` | **Done** |
| **impl** | codegen | `/impl-codegen`, `/impl-codegen-refine` | **Done** |
| **impl** | workflow | `/impl-workflow`, `/impl-workflow-refine` | **Done** |
| **deploy** | cicd | `/deploy-cicd`, `/deploy-cicd-refine` | **Done** |
| **deploy** | release | `/deploy-release`, `/deploy-release-refine` | **Done** |
| **deploy** | env | `/deploy-env`, `/deploy-env-refine` | **Done** |
| **ops** | monitoring | `/ops-monitor`, `/ops-monitor-refine` | **Done** |
| **ops** | incident | `/ops-incident`, `/ops-incident-refine` | **Done** |
| **ops** | sla | `/ops-sla`, `/ops-sla-refine` | **Done** |
| **ops** | runbook | `/ops-runbook`, `/ops-runbook-refine` | **Done** |
| **ops** | change | `/ops-change`, `/ops-change-refine` | **Done** |

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
