# SDLC Overview

Software Development Lifecycle pipeline using Agile/Scrum methodology.
This document describes how the 7 phases connect and what flows between them.

---

## Pipeline Flow

```
init/ → req/ → design/ → test/ + impl/ → deploy/ → ops/
                            ↑                         │
                            └─────────────────────────┘
                              (cycle back for next release)
```

## Phases and Their Skills

### Phase 1: Initiation (`init/`)

Establishes the project foundation. Takes a vague idea and produces structured artifacts.

| Skill | Command | Modes | Input | Output |
|-------|---------|-------|-------|--------|
| charter | `/init-charter` | `--create`, `--refine` | Vague idea, constraints | `charter-final.md` |
| scope | `/init-scope` | `--create`, `--refine` | Charter | `scope-final.md` |
| risk | `/init-risk` | `--create`, `--refine` | Charter, scope | `risk-register-final.md` |

### Phase 2: Requirements (`req/`)

Translates project vision into actionable, prioritized work items.

| Skill | Command | Modes | Input | Output |
|-------|---------|-------|-------|--------|
| epic | `/req-epic` | `--create`, `--refine` | Charter, scope | `epics-final.md` |
| userstory | `/req-userstory` | `--create`, `--refine` | Epics, scope | `backlog-final.md` |
| backlog | `/req-backlog` | `--create`, `--refine` | User stories | `backlog-final.md` |
| traceability | `/req-trace` | `--create`, `--refine` | All req artifacts | `traceability-final.md` |

### Phase 3: Design (`design/`)

Makes key architectural and technical decisions.

| Skill | Command | Modes | Input | Output |
|-------|---------|-------|-------|--------|
| tech-stack | `/design-stack` | `--create`, `--refine` | Charter, backlog | `tech-stack-final.md` |
| architecture | `/design-arch` | `--create`, `--refine` | Tech stack, epics | `architecture-final.md` |
| database | `/design-db` | `--create`, `--refine` | Architecture, backlog | `database-final.md` |
| api | `/design-api` | `--create`, `--refine` | Architecture, backlog | `api-final.md` |
| adr | `/design-adr` | `--create`, `--refine` | All design artifacts | `adr/adr-NNN-final.md` |

### Phase 4: Testing (`test/`)

Defines how the system will be verified.

| Skill | Command | Modes | Input | Output |
|-------|---------|-------|-------|--------|
| strategy | `/test-strategy` | `--create`, `--refine` | Design, backlog | `test-strategy-final.md` |
| plan | `/test-plan` | `--create`, `--refine` | Strategy, sprint plan | `test-plans/` |
| cases | `/test-cases` | `--create`, `--refine` | User stories, API design | `test-cases/` |

### Phase 5: Implementation (`impl/`)

Executes development work in sprints.

| Skill | Command | Modes | Input | Output |
|-------|---------|-------|-------|--------|
| sprint | `/impl-sprint` | `--create`, `--refine` | Backlog, velocity | `sprint-plans/` |
| codegen | `/impl-codegen` | `--create`, `--refine` | Design, test cases | Code files |
| workflow | `/impl-workflow` | `--create`, `--refine` | Team structure | `git-workflow-final.md` |

### Phase 6: Deployment (`deploy/`)

Delivers working software to environments.

| Skill | Command | Modes | Input | Output |
|-------|---------|-------|-------|--------|
| cicd | `/deploy-cicd` | `--create`, `--refine` | Tech stack, test strategy | `cicd-final.yml` |
| release | `/deploy-release` | `--create`, `--refine` | Sprint plan | `release-plan-final.md` |
| env | `/deploy-env` | `--create`, `--refine` | Architecture | `env-config-final.md` |

### Phase 7: Operations (`ops/`)

Maintains and monitors the running system.

| Skill | Command | Modes | Input | Output |
|-------|---------|-------|-------|--------|
| monitoring | `/ops-monitor` | `--create`, `--refine` | Architecture, SLAs | `monitoring-final.md` |
| incident | `/ops-incident` | `--create`, `--refine` | Monitoring, team | `incident-response-final.md` |
| sla | `/ops-sla` | `--create`, `--refine` | Charter, architecture | `sla-slo-final.md` |
| runbook | `/ops-runbook` | `--create`, `--refine` | All ops artifacts | `runbooks/` |
| change | `/ops-change` | `--create`, `--refine` | All ops artifacts | `change-mgmt-final.md` |

---

## Phase-to-Phase Handoff

Each phase's `final/` folder is the single source of truth for the next phase.

```
init/final/    → req/ reads from here
req/final/     → design/ reads from here
design/final/  → test/ + impl/ read from here
impl/final/    → deploy/ reads from here
deploy/final/  → ops/ reads from here
```

Skills within a phase can also read from other skills' `final/` output within the same phase.

---

## Iterative Refinement Pattern

Every skill supports create + refine modes:

1. **Create mode**: Generate initial draft from input
2. **User reviews**: Identifies issues, writes review-report.md
3. **Refine mode**: Reads draft + review report, produces improved version
4. **Repeat** steps 2-3 until Readiness Assessment shows ✅ Ready
5. **Promote**: User copies from `draft/` to `phase/final/`
