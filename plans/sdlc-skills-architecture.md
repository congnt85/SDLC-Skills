# Plan: SDLC Skills — Complete Folder Structure & Architecture

## Context

Splitting the monolithic `sdlc-initiation` into small, focused skills with isolated context. Each skill supports two modes (create + refine) in one SKILL.md. The same pattern applies to ALL 7 SDLC phases.

## Design Principles

1. **One skill = one SKILL.md with two modes** (create + refine) — no duplication
2. **Input resolution priority**: user-specified path > own `input/` > previous skill's `final/`
3. **Always copy to own `input/`** — regardless of where resolved from, for traceability
4. **`draft/` vs `final/`** — skill writes to `draft/`, user promotes to phase-level `final/` when satisfied
5. **Phase-level `final/`** — single source of truth, next phase reads from here
6. **Shared resources organized by type** — `knowledge/`, `rules/`, `templates/` at each level
7. **3-layer resource scoping**: project-wide → phase-wide → skill-specific

## Complete Folder Structure

```
skills/
│
├── shared/                                         ← PROJECT-WIDE shared resources
│   ├── knowledge/
│   │   ├── sdlc-overview.md                        ← SDLC phases, pipeline flow
│   │   ├── agile-scrum-guide.md                    ← methodology reference
│   │   └── estimation-methods.md                   ← three-point, parametric, analogous
│   ├── rules/
│   │   ├── doc-standards.md                        ← heading sizes, fonts, table formats
│   │   ├── quality-rules.md                        ← confidence marking, readiness assessment
│   │   └── output-rules.md                         ← versioning, diff summary, naming
│   └── templates/
│       ├── readiness-assessment.md                 ← standard readiness scoring
│       └── quality-scorecard.md                    ← standard quality metrics
│
│
├── init/                                           ← INITIATION PHASE
│   ├── final/                                      ← phase output — next phase reads here
│   │   ├── charter-final.md
│   │   ├── scope-final.md
│   │   └── risk-register-final.md
│   ├── shared/
│   │   ├── knowledge/
│   │   │   └── init-overview.md                    ← initiation phase context, artifact flow
│   │   ├── rules/
│   │   │   └── init-rules.md                       ← init-phase specific rules
│   │   └── templates/
│   │       ├── charter/
│   │       │   ├── charter-template.md
│   │       │   └── vision-template.md
│   │       ├── scope/
│   │       │   ├── scope-template.md
│   │       │   └── persona-template.md
│   │       └── risk/
│   │           ├── risk-register-template.md
│   │           └── risk-matrix-template.md
│   ├── charter/                                    ← /init-charter + /init-charter-refine
│   │   ├── input/
│   │   ├── draft/
│   │   ├── SKILL.md
│   │   ├── knowledge/
│   │   │   └── vision-workshop.md
│   │   ├── rules/
│   │   │   └── output-rules.md
│   │   └── templates/
│   │       ├── output-template.md
│   │       └── sample-output.md
│   ├── scope/                                      ← /init-scope + /init-scope-refine
│   │   ├── input/
│   │   ├── draft/
│   │   ├── SKILL.md
│   │   ├── knowledge/
│   │   │   └── scope-definition-guide.md
│   │   ├── rules/
│   │   │   └── output-rules.md
│   │   └── templates/
│   │       ├── output-template.md
│   │       └── sample-output.md
│   └── risk/                                       ← /init-risk + /init-risk-refine
│       ├── input/
│       ├── draft/
│       ├── SKILL.md
│       ├── knowledge/
│       │   └── risk-identification-guide.md
│       ├── rules/
│       │   └── output-rules.md
│       └── templates/
│           ├── output-template.md
│           └── sample-output.md
│
│
├── req/                                            ← REQUIREMENTS PHASE
│   ├── final/
│   │   ├── epics-final.md
│   │   ├── backlog-final.md
│   │   ├── traceability-final.md
│   │   └── dor-dod-final.md
│   ├── shared/
│   │   ├── knowledge/
│   │   │   └── req-overview.md
│   │   ├── rules/
│   │   │   └── req-rules.md
│   │   └── templates/
│   │       ├── epic/
│   │       │   └── epic-template.md
│   │       ├── userstory/
│   │       │   ├── userstory-template.md
│   │       │   └── acceptance-criteria-template.md
│   │       └── backlog/
│   │           └── backlog-template.md
│   ├── epic/                                       ← /req-epic + /req-epic-refine
│   │   ├── input/
│   │   ├── draft/
│   │   ├── SKILL.md
│   │   ├── knowledge/
│   │   ├── rules/
│   │   └── templates/
│   ├── userstory/                                  ← /req-userstory + /req-userstory-refine
│   │   ├── input/
│   │   ├── draft/
│   │   ├── SKILL.md
│   │   ├── knowledge/
│   │   │   ├── invest-criteria.md
│   │   │   ├── story-splitting-patterns.md
│   │   │   └── userstory-format.md
│   │   ├── rules/
│   │   └── templates/
│   ├── backlog/                                    ← /req-backlog + /req-backlog-refine
│   │   ├── input/
│   │   ├── draft/
│   │   ├── SKILL.md
│   │   ├── knowledge/
│   │   │   └── moscow-prioritization.md
│   │   ├── rules/
│   │   └── templates/
│   └── traceability/                               ← /req-trace + /req-trace-refine
│       ├── input/
│       ├── draft/
│       ├── SKILL.md
│       ├── knowledge/
│       ├── rules/
│       └── templates/
│
│
├── design/                                         ← DESIGN PHASE
│   ├── final/
│   │   ├── tech-stack-final.md
│   │   ├── architecture-final.md
│   │   ├── database-final.md
│   │   ├── api-final.md
│   │   └── adr/
│   │       ├── adr-001-final.md
│   │       └── ...
│   ├── shared/
│   │   ├── knowledge/
│   │   │   └── design-overview.md
│   │   ├── rules/
│   │   │   └── design-rules.md
│   │   └── templates/
│   │       ├── tech-stack/
│   │       │   └── decision-matrix-template.md
│   │       ├── architecture/
│   │       │   └── c4-diagram-template.md
│   │       ├── database/
│   │       │   └── erd-template.md
│   │       └── api/
│   │           └── endpoint-template.md
│   ├── tech-stack/                                 ← /design-stack + /design-stack-refine
│   │   ├── input/
│   │   ├── draft/
│   │   ├── SKILL.md
│   │   ├── knowledge/
│   │   ├── rules/
│   │   └── templates/
│   ├── architecture/                               ← /design-arch + /design-arch-refine
│   │   ├── input/
│   │   ├── draft/
│   │   ├── SKILL.md
│   │   ├── knowledge/
│   │   │   └── architecture-patterns.md
│   │   ├── rules/
│   │   └── templates/
│   ├── database/                                   ← /design-db + /design-db-refine
│   │   ├── input/
│   │   ├── draft/
│   │   ├── SKILL.md
│   │   ├── knowledge/
│   │   │   └── database-design-guide.md
│   │   ├── rules/
│   │   └── templates/
│   ├── api/                                        ← /design-api + /design-api-refine
│   │   ├── input/
│   │   ├── draft/
│   │   ├── SKILL.md
│   │   ├── knowledge/
│   │   │   └── api-design-standards.md
│   │   ├── rules/
│   │   └── templates/
│   └── adr/                                        ← /design-adr + /design-adr-refine
│       ├── input/
│       ├── draft/
│       ├── SKILL.md
│       ├── knowledge/
│       ├── rules/
│       └── templates/
│
│
├── test/                                           ← TESTING PHASE
│   ├── final/
│   │   ├── test-strategy-final.md
│   │   ├── test-plans/
│   │   └── test-cases/
│   ├── shared/
│   │   ├── knowledge/
│   │   │   └── test-overview.md
│   │   ├── rules/
│   │   │   └── test-rules.md
│   │   └── templates/
│   │       ├── strategy/
│   │       ├── plan/
│   │       └── cases/
│   ├── strategy/                                   ← /test-strategy + /test-strategy-refine
│   │   ├── input/
│   │   ├── draft/
│   │   ├── SKILL.md
│   │   ├── knowledge/
│   │   │   └── testing-pyramid.md
│   │   ├── rules/
│   │   └── templates/
│   ├── plan/                                       ← /test-plan + /test-plan-refine
│   │   ├── input/
│   │   ├── draft/
│   │   ├── SKILL.md
│   │   ├── knowledge/
│   │   ├── rules/
│   │   └── templates/
│   └── cases/                                      ← /test-cases + /test-cases-refine
│       ├── input/
│       ├── draft/
│       ├── SKILL.md
│       ├── knowledge/
│       │   └── test-case-patterns.md
│       ├── rules/
│       └── templates/
│
│
├── impl/                                           ← IMPLEMENTATION PHASE
│   ├── final/
│   │   ├── sprint-plans/
│   │   ├── git-workflow-final.md
│   │   └── coding-standards-final.md
│   ├── shared/
│   │   ├── knowledge/
│   │   │   └── impl-overview.md
│   │   ├── rules/
│   │   │   └── impl-rules.md
│   │   └── templates/
│   │       ├── sprint/
│   │       └── pr/
│   ├── sprint/                                     ← /impl-sprint + /impl-sprint-refine
│   │   ├── input/
│   │   ├── draft/
│   │   ├── SKILL.md
│   │   ├── knowledge/
│   │   │   └── sprint-planning-guide.md
│   │   ├── rules/
│   │   └── templates/
│   ├── codegen/                                    ← /impl-codegen + /impl-codegen-refine
│   │   ├── input/
│   │   ├── draft/
│   │   ├── SKILL.md
│   │   ├── knowledge/
│   │   │   ├── coding-standards.md
│   │   │   └── code-patterns.md
│   │   ├── rules/
│   │   └── templates/
│   └── workflow/                                   ← /impl-workflow + /impl-workflow-refine
│       ├── input/
│       ├── draft/
│       ├── SKILL.md
│       ├── knowledge/
│       │   └── pr-workflow.md
│       ├── rules/
│       └── templates/
│
│
├── deploy/                                         ← DEPLOYMENT PHASE
│   ├── final/
│   │   ├── cicd-final.yml
│   │   ├── release-plan-final.md
│   │   ├── env-config-final.md
│   │   └── rollback-plan-final.md
│   ├── shared/
│   │   ├── knowledge/
│   │   │   └── deploy-overview.md
│   │   ├── rules/
│   │   │   └── deploy-rules.md
│   │   └── templates/
│   │       ├── cicd/
│   │       ├── release/
│   │       └── env/
│   ├── cicd/                                       ← /deploy-cicd + /deploy-cicd-refine
│   │   ├── input/
│   │   ├── draft/
│   │   ├── SKILL.md
│   │   ├── knowledge/
│   │   │   └── cicd-pipeline-patterns.md
│   │   ├── rules/
│   │   └── templates/
│   ├── release/                                    ← /deploy-release + /deploy-release-refine
│   │   ├── input/
│   │   ├── draft/
│   │   ├── SKILL.md
│   │   ├── knowledge/
│   │   ├── rules/
│   │   └── templates/
│   └── env/                                        ← /deploy-env + /deploy-env-refine
│       ├── input/
│       ├── draft/
│       ├── SKILL.md
│       ├── knowledge/
│       │   └── environment-configs.md
│       ├── rules/
│       └── templates/
│
│
└── ops/                                            ← OPERATIONS PHASE
    ├── final/
    │   ├── monitoring-final.md
    │   ├── incident-response-final.md
    │   ├── sla-slo-final.md
    │   ├── runbooks/
    │   └── change-mgmt-final.md
    ├── shared/
    │   ├── knowledge/
    │   │   └── ops-overview.md
    │   ├── rules/
    │   │   └── ops-rules.md
    │   └── templates/
    │       ├── monitoring/
    │       ├── incident/
    │       ├── runbook/
    │       └── change/
    ├── monitoring/                                 ← /ops-monitor + /ops-monitor-refine
    │   ├── input/
    │   ├── draft/
    │   ├── SKILL.md
    │   ├── knowledge/
    │   │   └── monitoring-setup.md
    │   ├── rules/
    │   └── templates/
    ├── incident/                                   ← /ops-incident + /ops-incident-refine
    │   ├── input/
    │   ├── draft/
    │   ├── SKILL.md
    │   ├── knowledge/
    │   │   └── incident-response-playbook.md
    │   ├── rules/
    │   └── templates/
    ├── sla/                                        ← /ops-sla + /ops-sla-refine
    │   ├── input/
    │   ├── draft/
    │   ├── SKILL.md
    │   ├── knowledge/
    │   ├── rules/
    │   └── templates/
    ├── runbook/                                    ← /ops-runbook + /ops-runbook-refine
    │   ├── input/
    │   ├── draft/
    │   ├── SKILL.md
    │   ├── knowledge/
    │   ├── rules/
    │   └── templates/
    └── change/                                     ← /ops-change + /ops-change-refine
        ├── input/
        ├── draft/
        ├── SKILL.md
        ├── knowledge/
        │   └── change-management-process.md
        ├── rules/
        └── templates/
```

## Phase-to-Phase Pipeline Flow

```
init/final/                          → req reads from here
  ├── charter-final.md
  ├── scope-final.md
  └── risk-register-final.md
                │
                ▼
req/final/                           → design reads from here
  ├── epics-final.md
  ├── backlog-final.md
  ├── traceability-final.md
  └── dor-dod-final.md
                │
                ▼
design/final/                        → impl + test read from here
  ├── tech-stack-final.md
  ├── architecture-final.md
  ├── database-final.md
  ├── api-final.md
  └── adr/
                │
          ┌─────┴─────┐
          ▼           ▼
test/final/      impl/final/        → deploy reads from here
                      │
                      ▼
              deploy/final/          → ops reads from here
                      │
                      ▼
                ops/final/           → cycles back to init for next release
```

## Input Resolution Logic (Standard for ALL Skills)

```
For each required input file:
  1. User specified path?     → YES → read it, copy to own input/ → DONE
  2. Exists in own input/?    → YES → read it → DONE
  3. Exists in previous skill's final/ (within phase)
     or previous phase's final/ (cross-phase)?
                              → YES → read it, copy to own input/ → DONE
  4. FAIL — ask user to provide

Once all required inputs resolved → STOP, don't check lower priorities
```

## Skill Mode Pattern (Standard for ALL Skills)

Each SKILL.md contains two modes:

### Mode 1: Create (`/phase-skill`)
| Step | Action |
|------|--------|
| 1 | Determine mode from command |
| 2 | Resolve input (vague idea, or previous phase/skill final output) |
| 3 | Read knowledge/, rules/, templates/ |
| 4 | Generate draft → write to `draft/` |
| 5 | Assess readiness |

### Mode 2: Refine (`/phase-skill-refine`)
| Step | Action |
|------|--------|
| 1 | Determine mode from command |
| 2 | Resolve input (existing draft from `draft/` + `review-report.md` from `input/`) |
| 3 | Read knowledge/, rules/, templates/ |
| 4 | Analyze quality, identify weak areas |
| 5 | Apply user feedback + proactive improvements |
| 6 | Write improved version to `draft/` (versioned) |
| 7 | Re-assess readiness, show diff summary |

### User promotes to final:
When satisfied with draft → user copies from `skill/draft/` to `phase/final/`

## Command Reference (All Skills)

| Phase | Command | Skill Folder |
|-------|---------|-------------|
| **init** | `/init-charter`, `/init-charter-refine` | `init/charter/` |
| | `/init-scope`, `/init-scope-refine` | `init/scope/` |
| | `/init-risk`, `/init-risk-refine` | `init/risk/` |
| **req** | `/req-epic`, `/req-epic-refine` | `req/epic/` |
| | `/req-userstory`, `/req-userstory-refine` | `req/userstory/` |
| | `/req-backlog`, `/req-backlog-refine` | `req/backlog/` |
| | `/req-trace`, `/req-trace-refine` | `req/traceability/` |
| **design** | `/design-stack`, `/design-stack-refine` | `design/tech-stack/` |
| | `/design-arch`, `/design-arch-refine` | `design/architecture/` |
| | `/design-db`, `/design-db-refine` | `design/database/` |
| | `/design-api`, `/design-api-refine` | `design/api/` |
| | `/design-adr`, `/design-adr-refine` | `design/adr/` |
| **test** | `/test-strategy`, `/test-strategy-refine` | `test/strategy/` |
| | `/test-plan`, `/test-plan-refine` | `test/plan/` |
| | `/test-cases`, `/test-cases-refine` | `test/cases/` |
| **impl** | `/impl-sprint`, `/impl-sprint-refine` | `impl/sprint/` |
| | `/impl-codegen`, `/impl-codegen-refine` | `impl/codegen/` |
| | `/impl-workflow`, `/impl-workflow-refine` | `impl/workflow/` |
| **deploy** | `/deploy-cicd`, `/deploy-cicd-refine` | `deploy/cicd/` |
| | `/deploy-release`, `/deploy-release-refine` | `deploy/release/` |
| | `/deploy-env`, `/deploy-env-refine` | `deploy/env/` |
| **ops** | `/ops-monitor`, `/ops-monitor-refine` | `ops/monitoring/` |
| | `/ops-incident`, `/ops-incident-refine` | `ops/incident/` |
| | `/ops-sla`, `/ops-sla-refine` | `ops/sla/` |
| | `/ops-runbook`, `/ops-runbook-refine` | `ops/runbook/` |
| | `/ops-change`, `/ops-change-refine` | `ops/change/` |

**Total: 23 skills × 2 modes = 46 commands**

## Build Order (Priority)

### Priority 1 — Build first (init phase)
1. `skills/shared/` — project-wide rules, knowledge, templates
2. `init/shared/` — init-phase shared resources
3. `init/charter/` — foundation skill, everything depends on this
4. `init/scope/` — depends on charter
5. `init/risk/` — depends on charter, optionally scope

### Priority 2 — Build next (req + design phases)
6. `req/shared/` + `req/epic/` + `req/userstory/` + `req/backlog/` + `req/traceability/`
7. `design/shared/` + `design/tech-stack/` + `design/architecture/` + `design/database/` + `design/api/` + `design/adr/`

### Priority 3 — Build later
8. `test/` phase
9. `impl/` phase
10. `deploy/` phase
11. `ops/` phase

### Deferred (low priority)
- `init/stakeholder/` — optional, governance-only
- `init/feasibility/` — optional, go/no-go decision

## Migration from Current Structure

1. Create new folder structure under `skills/`
2. Migrate content from `skills/sdlc-initiation/` → `skills/init/charter/`, distributing references to appropriate shared levels
3. Delete `skills/sdlc-initiation/`, `skills/sdlc-requirements/`, `skills/sdlc-design/` after migration
4. Update `install.sh` to handle nested structure
5. Update `CLAUDE.md`
