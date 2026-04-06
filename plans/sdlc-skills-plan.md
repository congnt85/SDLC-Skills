# Plan: Build 7 SDLC Skills for Claude Code

## Context

Build a complete suite of 7 Claude Code skills covering every phase of the Software Development Lifecycle (SDLC), following Agile/Scrum methodology. Each skill **guides** the user step-by-step through a phase AND **generates** artifacts (docs, code, configs). Skills are installed locally to `~/.claude/skills/`. Production-ready depth from day one.

---

## Project Structure

```
/mnt/d/personal/SDLC-Skills/
├── install.sh                         # Copies skills to ~/.claude/skills/
├── skills/
│   ├── sdlc-initiation/
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── charter-template.md
│   │       ├── stakeholder-matrix.md
│   │       └── feasibility-framework.md
│   ├── sdlc-requirements/
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── user-story-patterns.md
│   │       ├── acceptance-criteria-guide.md
│   │       └── backlog-templates.md
│   ├── sdlc-design/
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── architecture-patterns.md
│   │       ├── api-design-standards.md
│   │       ├── database-design-guide.md
│   │       └── tech-stack-decision-matrix.md
│   ├── sdlc-implementation/
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── coding-standards.md
│   │       ├── sprint-planning-guide.md
│   │       └── pr-workflow.md
│   ├── sdlc-testing/
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── test-strategy-templates.md
│   │       ├── test-case-patterns.md
│   │       └── automation-frameworks.md
│   ├── sdlc-deployment/
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── cicd-pipeline-templates.md
│   │       ├── environment-configs.md
│   │       └── rollback-procedures.md
│   └── sdlc-operations/
│       ├── SKILL.md
│       └── references/
│           ├── monitoring-setup.md
│           ├── incident-response-playbook.md
│           └── change-management-process.md
```

---

## Skill Specifications (Summary)

Every SKILL.md follows a consistent structure:
1. **YAML frontmatter** — name, description (with trigger conditions), metadata (version, category, phase, prev/next phase)
2. **Step 0: Load Context** — check for artifacts from prior phases, fallback to asking the user
3. **Guided Workflow** — numbered steps, sometimes with branching paths (modes A/B/C)
4. **Templates & Checklists** — embedded in the skill body
5. **Cross-References** — what it reads from, what it feeds into
6. **Handoff** — summary of artifacts created, pointer to next phase skill

### 1. `sdlc-initiation` — Project Kickoff
- **Triggers**: new project, project charter, stakeholder analysis, feasibility study, project kickoff
- **Workflow**: Gather context → Vision Statement → Project Charter → Stakeholder Analysis → Feasibility Study → Risk Register → Scope Document → Handoff
- **Artifacts**: `docs/project-charter.md`, `docs/stakeholder-analysis.md`, `docs/feasibility-study.md`, `docs/risk-register.md`, `docs/project-scope.md`
- **Key content**: SMART goals, RACI matrix, Power/Interest grid, 5-dimension feasibility scoring, risk probability/impact matrix

### 2. `sdlc-requirements` — Backlog & User Stories
- **Triggers**: user stories, acceptance criteria, backlog creation, requirements gathering, MoSCoW prioritization
- **Workflow**: Read charter/scope → Define Epics → User Story Mapping → Acceptance Criteria (Given/When/Then) → Prioritize (MoSCoW) → Traceability Matrix → DoR/DoD
- **Artifacts**: `docs/epics.md`, `docs/product-backlog.md`, `docs/requirements-traceability.md`, `docs/dor-dod.md`
- **Key content**: INVEST criteria, story splitting patterns, Gherkin format, story point estimation (Fibonacci)

### 3. `sdlc-design` — Architecture & Technical Design
- **Triggers**: system architecture, database design, API design, ADR, tech stack selection, C4 model
- **Workflow**: Read backlog/epics → Tech Stack Selection → High-Level Architecture (C4 diagrams in Mermaid) → Component Design → Database Design (ERD + DDL) → API Design (OpenAPI) → ADRs → Project Scaffold
- **Artifacts**: `docs/tech-stack-decision.md`, `docs/architecture-overview.md`, `docs/database-design.md`, `docs/api-design.md`, `docs/adr/0001-*.md`
- **Key content**: Monolith vs microservices decision tree, Mermaid C4 templates, normalization checklist, REST conventions, ADR format

### 4. `sdlc-implementation` — Sprint Execution & Code
- **Triggers**: sprint planning, coding standards, code generation, PR workflow, branching strategy
- **Modes**: (A) Sprint Planning, (B) Code Generation from design, (C) PR/Workflow Setup
- **Artifacts**: `docs/sprints/sprint-N-plan.md`, `docs/git-workflow.md`, `.github/pull_request_template.md`, `.editorconfig`, linter configs, code stubs
- **Key content**: Capacity calculation, velocity tracking, Conventional Commits, code review checklist, code generation from API/DB design

### 5. `sdlc-testing` — Test Strategy & QA
- **Triggers**: test strategy, test plan, test cases, QA, test automation, BDD, TDD, UAT
- **Modes**: (A) Test Strategy, (B) Test Plan for sprint/feature, (C) Generate Test Cases, (D) Automation Setup
- **Artifacts**: `docs/test-strategy.md`, `docs/test-plans/`, `docs/test-cases/`, `.github/ISSUE_TEMPLATE/bug_report.md`, test config files
- **Key content**: Testing pyramid (70/20/10), test case generation from acceptance criteria, framework configs (Jest/Pytest/Playwright/k6), coverage thresholds, defect lifecycle

### 6. `sdlc-deployment` — CI/CD & Release
- **Triggers**: CI/CD, deployment, release management, Docker, Kubernetes, rollback, infrastructure as code
- **Modes**: (A) CI/CD Pipeline, (B) Release Planning, (C) Environment Config, (D) Containerization
- **Artifacts**: `.github/workflows/ci.yml`, `.github/workflows/deploy.yml`, `docs/release-plan.md`, `docs/environment-config.md`, `docs/rollback-plan.md`, `Dockerfile`, `docker-compose.yml`, `.env.example`
- **Key content**: GitHub Actions pipeline templates, deployment strategies (blue-green, canary, rolling), SemVer, Dockerfile best practices, K8s manifests, rollback procedures

### 7. `sdlc-operations` — Monitoring & Maintenance
- **Triggers**: monitoring, incident response, SLA/SLO, runbook, on-call, post-mortem, change management
- **Modes**: (A) Monitoring Setup, (B) Incident Response, (C) SLA/SLO Definition, (D) Change Management, (E) Runbook Creation
- **Artifacts**: `docs/monitoring-setup.md`, `docs/alerting-rules.md`, `docs/sla-slo.md`, `docs/incident-response.md`, `docs/post-mortems/`, `docs/runbooks/`, `docs/change-management.md`
- **Key content**: RED/USE methods, alerting severity levels, SLI/SLO/SLA framework, blameless post-mortem template, 5 Whys, change types (standard/normal/emergency)

---

## Artifact Flow Between Skills

```
initiation ──→ requirements ──→ design ──→ implementation
                                  │              │
                                  ▼              ▼
                              testing ──→ deployment ──→ operations
                                                            │
                                                            ▼
                                                      (cycle back to initiation)
```

Each skill reads artifacts from prior phases but also works standalone — Step 0 falls back to asking the user when prior artifacts don't exist.

---

## Build Order

| # | Skill | Why This Order | Est. Size |
|---|-------|---------------|-----------|
| 1 | `sdlc-initiation` | Entry point, zero dependencies, establishes patterns | ~400-500 lines |
| 2 | `sdlc-requirements` | Validates cross-reference pattern, produces most-consumed artifact (backlog) | ~500-600 lines |
| 3 | `sdlc-design` | Highest fan-out (4 downstream consumers), complex templates | ~700-900 lines |
| 4 | `sdlc-testing` | Bridges requirements to verification, test-first mindset | ~600-800 lines |
| 5 | `sdlc-implementation` | Depends on design + testing being defined | ~600-800 lines |
| 6 | `sdlc-deployment` | Integrates test gates + branching strategy | ~600-800 lines |
| 7 | `sdlc-operations` | Depends on deployed system knowledge, closes the loop | ~500-700 lines |
| + | `install.sh` | Build alongside skill #1, test incrementally | ~30 lines |

**Total**: ~4,000-5,000 lines of SKILL.md + ~2,000-3,000 lines of reference files

---

## Key Design Decisions

1. **Graceful degradation**: Every skill works standalone. Users can invoke `/sdlc-testing` without running prior phases — it asks for context directly.
2. **Consistent artifact paths**: All skills write to `docs/` with predictable filenames so downstream skills can find them.
3. **Mode selection**: Skills 4-7 offer multiple modes (A/B/C/D) so users can pick exactly what they need.
4. **Agile/Scrum throughout**: Sprint ceremonies, user stories, velocity tracking, DoR/DoD, retrospectives baked in.
5. **Reference files**: Heavy templates and examples go in `references/` subdirectories to keep SKILL.md focused on workflow.

---

## Verification Plan

After building each skill:
1. Run `install.sh` to copy to `~/.claude/skills/`
2. Invoke the skill with `/sdlc-{phase}` in a new Claude Code session
3. Verify it asks the right context questions (Step 0)
4. Verify it generates all listed artifacts with correct structure
5. Verify cross-references work (e.g., `/sdlc-requirements` correctly reads `docs/project-charter.md` from initiation)
6. Test standalone mode (invoke without prior phase artifacts)
