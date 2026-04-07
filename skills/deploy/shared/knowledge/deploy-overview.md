# Deploy Phase Overview

The deploy phase transforms implementation artifacts into production-ready deployment configurations. It defines CI/CD pipelines, release management processes, and environment infrastructure. This phase bridges "working code" (impl) and "running system" (ops).

---

## Skills in This Phase

```
/deploy-cicd      → Define CI/CD pipeline configuration (build, test, deploy stages)
     ↓
/deploy-release   → Define release management (versioning, changelog, rollback)
     ↓
/deploy-env       → Define environment specifications (infrastructure, config, scaling)
```

Each skill supports two modes: create and refine.

---

## Artifact Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    INPUTS                                    │
│                                                              │
│  From impl/final/:                 From design/final/:       │
│  - codegen-plan-final.md           - tech-stack-final.md     │
│  - dev-workflow-final.md           - architecture-final.md   │
│  - sprint-plan-final.md            - database-final.md       │
│                                                              │
│  From test/final/:                 From init/final/:          │
│  - test-strategy-final.md          - charter-final.md        │
│  - test-plan-final.md              - scope-final.md          │
│                                                              │
│  From req/final/:                                            │
│  - dor-dod-final.md                                          │
│  - backlog-final.md                                          │
└────────────┬──────────────────────────┬──────────────────────┘
             │                          │
             ▼                          ▼
      ┌──────────────────────────────────────────┐
      │         /deploy-cicd                     │
      │  CI/CD pipeline configuration            │
      │  Output: cicd-pipeline-draft.md          │
      └──────────────────┬───────────────────────┘
                         │ promote to deploy/final/
                         ▼
      ┌──────────────────────────────────────────┐
      │         /deploy-release                  │
      │  Release management process              │
      │  Output: release-plan-draft.md           │
      └──────────────────┬───────────────────────┘
                         │ promote to deploy/final/
                         ▼
      ┌──────────────────────────────────────────┐
      │         /deploy-env                      │
      │  Environment specifications              │
      │  Output: env-spec-draft.md               │
      └──────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                   OUTPUTS (deploy/final/)                     │
│                                                              │
│  cicd-pipeline-final.md    release-plan-final.md             │
│  env-spec-final.md                                           │
└─────────────────────────────────────────────────────────────┘
```

---

## What This Phase Reads

| Source | What Deploy Extracts |
|--------|---------------------|
| **dev-workflow-final.md** | Branching strategy, CI stages, merge process, hotfix flow |
| **codegen-plan-final.md** | Project structure, build commands, config files |
| **tech-stack-final.md** | Technologies → Docker images, build tools, cloud services |
| **architecture-final.md** | Containers → deployment topology, service dependencies |
| **database-final.md** | Migration strategy, backup requirements |
| **test-strategy-final.md** | Test stages for pipeline, test tool configs |
| **test-plan-final.md** | Environment requirements for test stages |
| **dor-dod-final.md** | DoD criteria for deployment gates |
| **charter-final.md** | Budget constraints, timeline for release schedule |
| **scope-final.md** | Quality attributes → SLA targets, performance requirements |
| **backlog-final.md** | Release grouping, MVP boundary |

---

## What Downstream Needs

| Deploy Artifact | Ops Phase Uses |
|----------------|----------------|
| **cicd-pipeline-final.md** | Pipeline monitoring, deployment frequency metrics |
| **release-plan-final.md** | Change management, release calendar |
| **env-spec-final.md** | Infrastructure monitoring, capacity planning, incident response |

---

## Key Principles

1. **Infrastructure as Code** — all environment configs are version-controlled and reproducible.
2. **Immutable deployments** — deploy new versions, don't modify running instances.
3. **Zero-downtime deployments** — use blue-green, canary, or rolling strategies.
4. **Environment parity** — staging mirrors production as closely as possible.
5. **Automated everything** — build, test, deploy, rollback are all automated.
6. **Security in the pipeline** — secret management, image scanning, dependency auditing.
7. **Observability built-in** — health checks, readiness probes, structured logging from day one.
