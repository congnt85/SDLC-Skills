# Implementation Phase Overview

The implementation phase transforms design artifacts and test cases into working software. It defines sprint execution plans, generates implementation scaffolding, and establishes development workflows. This phase bridges the gap between "what to build" (design) and "running software" (deploy).

---

## Skills in This Phase

```
/impl-sprint      → Plan sprint execution (task breakdown, assignments, capacity)
     ↓
/impl-codegen     → Generate implementation scaffolding (project structure, modules, configs)
     ↓
/impl-workflow    → Define development workflows (branching, PR, code review, CI integration)
```

Each skill supports two modes: create and refine.

---

## Artifact Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    INPUTS                                    │
│                                                              │
│  From design/final/:               From req/final/:          │
│  - tech-stack-final.md             - backlog-final.md        │
│  - architecture-final.md           - userstories-final.md    │
│  - database-final.md               - epics-final.md          │
│  - api-final.md                    - dor-dod-final.md        │
│  - adr/*.md                                                  │
│                                    From test/final/:          │
│  From init/final/:                 - test-strategy-final.md   │
│  - charter-final.md               - test-cases-final.md      │
│  - scope-final.md                                            │
└────────────┬──────────────────────────┬──────────────────────┘
             │                          │
             ▼                          ▼
      ┌──────────────────────────────────────────┐
      │         /impl-sprint                     │
      │  Sprint planning, task breakdown         │
      │  Output: sprint-plan-draft.md            │
      └──────────────────┬───────────────────────┘
                         │ promote to impl/final/
                         ▼
      ┌──────────────────────────────────────────┐
      │         /impl-codegen                    │
      │  Project scaffolding, module structure   │
      │  Output: codegen-plan-draft.md           │
      └──────────────────┬───────────────────────┘
                         │ promote to impl/final/
                         ▼
      ┌──────────────────────────────────────────┐
      │         /impl-workflow                   │
      │  Branching, PR, code review, CI          │
      │  Output: dev-workflow-draft.md           │
      └──────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                   OUTPUTS (impl/final/)                      │
│                                                              │
│  sprint-plan-final.md    codegen-plan-final.md               │
│  dev-workflow-final.md                                       │
└─────────────────────────────────────────────────────────────┘
```

---

## What This Phase Reads

| Source | What Impl Extracts |
|--------|---------------------|
| **backlog-final.md** | Prioritized stories, MVP boundary, release grouping, velocity assumptions |
| **userstories-final.md** | Story details, ACs for task breakdown, story points |
| **dor-dod-final.md** | DoR for sprint readiness check, DoD for task completion criteria |
| **tech-stack-final.md** | Languages, frameworks → project structure, tooling, configs |
| **architecture-final.md** | Components → module structure, service boundaries |
| **database-final.md** | Tables → ORM models, migration scripts |
| **api-final.md** | Endpoints → controller/route scaffolding |
| **test-strategy-final.md** | Test tools → test config, CI test stages |
| **test-cases-final.md** | Test cases → test file scaffolding |
| **charter-final.md** | Team structure, timeline constraints |

---

## What Downstream Needs

| Impl Artifact | Deploy Phase Uses | Ops Phase Uses |
|--------------|-------------------|----------------|
| **sprint-plan-final.md** | Sprint cadence for release planning | Sprint velocity for capacity planning |
| **codegen-plan-final.md** | Project structure for build pipeline | Module structure for monitoring config |
| **dev-workflow-final.md** | Branch strategy for CI/CD pipeline, PR checks | Hotfix workflow for incident response |

---

## Key Principles

1. **Stories drive tasks** — every implementation task traces to a user story and its ACs.
2. **Architecture drives structure** — project structure mirrors architecture components.
3. **Tech stack drives tooling** — all configs, linters, formatters match selected technologies.
4. **Test-first mindset** — test infrastructure is set up before feature code.
5. **Small, reviewable increments** — tasks should be completable in 1-2 days max.
6. **Automate the workflow** — CI checks, linting, formatting, test running are automated from day one.
7. **DoD compliance** — every task completion is validated against Definition of Done.
