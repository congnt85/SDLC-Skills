# SDLC Skills — User Guide

A complete set of Claude Code skills covering the full Software Development Lifecycle using Agile/Scrum methodology. 26 skills + 4 utilities, 56 commands, 7 phases — from project charter to production operations. Accepts any file type (md, pdf, docx, xlsx, pptx).

---

## Table of Contents

- [Installation](#installation)
- [Quick Start](#quick-start)
- [Skill Reference](#skill-reference)
- [How Skills Work](#how-skills-work)
- [Using Skills](#using-skills)
- [The Refine Workflow](#the-refine-workflow)
- [Draft/Final Pipeline](#draftfinal-pipeline)
- [Confidence Marking](#confidence-marking)
- [Working on a Real Project](#working-on-a-real-project)
- [Upgrading Skills](#upgrading-skills)
- [Uninstalling](#uninstalling)
- [Multi-Format Input](#multi-format-input)
- [Troubleshooting](#troubleshooting)

---

## Installation

### Prerequisites

- [Claude Code](https://claude.ai/code) installed and configured
- Git (to clone the repository)
- Bash shell (Linux, macOS, WSL)

### Install Steps

```bash
# 1. Clone the repository
git clone https://github.com/your-org/SDLC-Skills.git
cd SDLC-Skills

# 2. Install skills to Claude Code
bash install.sh
```

This copies all skills to `~/.claude/skills/`, where Claude Code discovers them automatically.

### Development Mode (Symlink)

If you plan to modify or contribute to the skills, use symlink mode. Changes to the source files take effect immediately — no reinstall needed.

```bash
bash install.sh --symlink
```

### Verify Installation

After installation, start Claude Code and type any skill command (e.g., `/init-charter`). If the skill activates, installation was successful.

You can also check installed skills:

```bash
ls ~/.claude/skills/sdlc-*
```

Expected output includes `sdlc-shared`, `sdlc-init-shared`, `sdlc-init-charter`, `sdlc-req-epic`, etc.

---

## Quick Start

The fastest way to start a project from scratch:

```
1. /init-charter        → Define your project charter
2. /init-scope          → Define detailed scope
3. /init-risk           → Identify and assess risks
4. /req-epic            → Create epics from charter objectives
5. /req-userstory       → Write user stories for each epic
6. /req-backlog         → Prioritize into a backlog
7. /req-trace           → Build traceability matrix + DoR/DoD
8. /design-stack        → Select technology stack
9. /design-arch         → Define system architecture (C4)
10. /design-db          → Design database schema
11. /design-api         → Design API contracts
12. /design-adr         → Document key decisions (run as needed)
13. /test-strategy      → Define testing approach
14. /test-plan          → Plan test execution
15. /test-cases         → Write test cases
16. /impl-sprint        → Plan sprint execution
17. /impl-codegen       → Generate project scaffolding plan
18. /impl-workflow      → Define dev workflow (branching, CI, PRs)
19. /deploy-cicd        → Configure CI/CD pipeline
20. /deploy-release     → Define release management
21. /deploy-env         → Specify environments
22. /ops-monitor        → Set up monitoring & alerting
23. /ops-incident       → Define incident response
24. /ops-sla            → Define SLAs/SLOs/SLIs
25. /ops-runbook        → Create operational runbooks
26. /ops-change         → Define change management
```

You don't have to run all 26 — run only the skills you need. But follow the order within a phase, as later skills read from earlier skills' outputs.

---

## Skill Reference

### Phase 1: Initiation (init)

| Command | Purpose | Key Input | Key Output |
|---------|---------|-----------|------------|
| `/init-charter` | Define project vision, goals, scope, milestones | Project idea (text or file) | `charter-draft.md` |
| `/init-scope` | Define features, personas, quality attributes | `charter-final.md` | `scope-draft.md` |
| `/init-risk` | Identify and assess project risks | `charter-final.md` + `scope-final.md` | `risk-register-draft.md` |

### Phase 2: Requirements (req)

| Command | Purpose | Key Input | Key Output |
|---------|---------|-----------|------------|
| `/req-epic` | Group features into epics | `charter-final.md` + `scope-final.md` | `epics-draft.md` |
| `/req-userstory` | Write user stories with Gherkin ACs | `epics-final.md` + `scope-final.md` | `userstories-draft.md` |
| `/req-backlog` | Prioritize stories (MoSCoW, releases) | `userstories-final.md` + `epics-final.md` | `backlog-draft.md` |
| `/req-trace` | Build traceability matrix + DoR/DoD | All req + init artifacts | `traceability-draft.md` + `dor-dod-draft.md` |

### Phase 3: Design (design)

| Command | Purpose | Key Input | Key Output |
|---------|---------|-----------|------------|
| `/design-stack` | Select and justify technology stack | `scope-final.md` + `charter-final.md` | `tech-stack-draft.md` |
| `/design-arch` | Define architecture (C4 diagrams) | `tech-stack-final.md` + `scope-final.md` | `architecture-draft.md` |
| `/design-db` | Design database schema (ERD) | `architecture-final.md` + `userstories-final.md` | `database-draft.md` |
| `/design-api` | Design REST API contracts | `architecture-final.md` + `userstories-final.md` | `api-draft.md` |
| `/design-adr` | Document architecture decisions | Decision topic + design context | `adr-{NNN}-{slug}-draft.md` |

### Phase 4: Testing (test)

| Command | Purpose | Key Input | Key Output |
|---------|---------|-----------|------------|
| `/test-strategy` | Define testing approach and tools | `tech-stack-final.md` + `architecture-final.md` | `test-strategy-draft.md` |
| `/test-plan` | Plan test execution and schedule | `test-strategy-final.md` + `backlog-final.md` | `test-plan-draft.md` |
| `/test-cases` | Write specific test cases | `userstories-final.md` + `api-final.md` | `test-cases-draft.md` |

### Phase 5: Implementation (impl)

| Command | Purpose | Key Input | Key Output |
|---------|---------|-----------|------------|
| `/impl-sprint` | Plan sprint tasks and capacity | `backlog-final.md` + `userstories-final.md` | `sprint-plan-draft.md` |
| `/impl-codegen` | Plan project scaffolding | `tech-stack-final.md` + `architecture-final.md` | `codegen-plan-draft.md` |
| `/impl-workflow` | Define dev workflow (branching, CI, PRs) | `tech-stack-final.md` + `test-strategy-final.md` | `dev-workflow-draft.md` |

### Phase 6: Deployment (deploy)

| Command | Purpose | Key Input | Key Output |
|---------|---------|-----------|------------|
| `/deploy-cicd` | Configure CI/CD pipeline | `dev-workflow-final.md` + `test-strategy-final.md` | `cicd-pipeline-draft.md` |
| `/deploy-release` | Define release management | `cicd-pipeline-final.md` + `backlog-final.md` | `release-plan-draft.md` |
| `/deploy-env` | Specify environments and infrastructure | `architecture-final.md` + `tech-stack-final.md` | `env-spec-draft.md` |

### Phase 7: Operations (ops)

| Command | Purpose | Key Input | Key Output |
|---------|---------|-----------|------------|
| `/ops-monitor` | Define monitoring and alerting | `env-spec-final.md` + `architecture-final.md` | `monitoring-plan-draft.md` |
| `/ops-incident` | Define incident response process | `monitoring-plan-final.md` + `env-spec-final.md` | `incident-response-draft.md` |
| `/ops-sla` | Define SLAs, SLOs, SLIs, error budgets | `scope-final.md` + `monitoring-plan-final.md` | `sla-spec-draft.md` |
| `/ops-runbook` | Create operational runbooks | `monitoring-plan-final.md` + `env-spec-final.md` | `runbooks-draft.md` |
| `/ops-change` | Define change management process | `release-plan-final.md` + `cicd-pipeline-final.md` | `change-mgmt-draft.md` |

---

## How Skills Work

### Anatomy of a Skill

Each skill contains 5 files (in the installation directory):

```
skills/<phase>/<skill>/
├── SKILL.md               # Workflow definition (create + refine modes)
├── knowledge/
│   └── <guide>.md         # Domain techniques and knowledge
├── rules/
│   └── output-rules.md   # Skill-specific output constraints
└── templates/
    ├── output-template.md # Expected output structure
    └── sample-output.md   # Complete example (TaskFlow project)
```

All skill I/O goes to your **project directory** (not the skills installation):

```
your-project/
└── sdlc/
    ├── init/
    │   ├── input/         # Converted non-md files
    │   ├── draft/         # Skill output (charter-draft.md, etc.)
    │   └── final/         # Promoted artifacts (charter-final.md, etc.)
    ├── req/
    │   ├── input/
    │   ├── draft/
    │   └── final/
    ├── design/
    ├── test/
    ├── impl/
    ├── deploy/
    └── ops/
```

### 3-Layer Resource Scoping

Skills inherit knowledge and rules from three layers:

```
skills/shared/              → Project-wide rules (doc standards, quality rules)
  └── <phase>/shared/       → Phase-wide rules (e.g., design rules, test rules)
      └── <phase>/<skill>/  → Skill-specific rules (e.g., API output rules)
```

Skills read from their own layer and ancestors, never from sibling skills.

### 7-Step Workflow

Every skill follows the same workflow:

1. **Determine Mode** — Create or Refine based on command used
2. **Read Knowledge & Rules** — Load all 3 layers of rules and knowledge
3. **Resolve Input** — Find input files (user path > `sdlc/<phase>/input/` > previous `sdlc/<phase>/final/`). Non-md files are auto-converted.
4. **Generate** — Produce the artifact section by section
5. **Validate** — Check output against all applicable rules
6. **Readiness Assessment** — Count confidence markers, calculate verdict
7. **Output** — Write to `sdlc/<phase>/draft/`, report readiness to user

---

## Using Skills

### Starting a Skill

Type the command in Claude Code:

```
/init-charter "A real-time sprint tracking tool that integrates with GitHub"
```

Or without arguments — the skill will ask for input:

```
/init-charter
```

### Providing Input Files

You can point to existing files — any format is accepted:

```
/init-scope path/to/my-charter.md
/init-scope path/to/my-charter.pdf
/init-scope path/to/my-charter.docx
```

Non-markdown files are automatically converted to markdown via utility skills (`/read-pdf`, `/read-word`, `/read-excel`, `/read-ppt`). Converted files are cached in `sdlc/<phase>/input/`.

Or place files in the input directory beforehand:

```
cp my-charter.md sdlc/init/input/charter-final.md
/init-scope
```

### Reading Output

Skills write to `sdlc/<phase>/draft/` in your project directory:

```
sdlc/init/draft/charter-draft.md      # First version
sdlc/init/draft/charter-v2.md          # After refine
sdlc/init/draft/charter-v3.md          # After second refine
```

Each output includes:
- The artifact content with confidence markers
- A Q&A Log of open questions
- A Readiness Assessment (Ready / Partially Ready / Not Ready)
- An Approval section

---

## The Refine Workflow

Every skill supports iterative refinement. The refine command improves an existing draft based on your feedback.

### How to Refine

```
/init-charter-refine
```

Then provide your feedback in one of three ways:

1. **Directly in the message**: "The vision statement is too vague. Budget should be $200K not $150K."
2. **As a file**: Place feedback in `input/review-report.md`
3. **When prompted**: The skill will ask "What feedback do you have?"

### What Refine Does

1. Reads the latest draft from `draft/`
2. Runs a **Quality Scorecard** analysis (completeness, clarity, quantification, etc.)
3. Shows you the scorecard: "Here's what I found..."
4. Applies your feedback point by point
5. Resolves Q&A entries from the previous version
6. Upgrades confidence levels where possible (❓→🔶→✅)
7. Tags all changes: `[UPDATED]` for modified, `[NEW]` for additions
8. Preserves ✅ CONFIRMED items (unless you explicitly contradict them)
9. Writes new version: `draft/{artifact}-v{N}.md`
10. Compares readiness with the previous version

### Refine Cycle

```
/init-charter              → sdlc/init/draft/charter-draft.md     (v1, 30% Ready)
/init-charter-refine       → sdlc/init/draft/charter-v2.md        (v2, 55% Ready)
/init-charter-refine       → sdlc/init/draft/charter-v3.md        (v3, 85% Ready)
  └── Satisfied? Copy to sdlc/init/final/charter-final.md
```

Repeat until the readiness verdict meets your needs, then promote to `final/`.

---

## Draft/Final Pipeline

Skills write to `sdlc/<phase>/draft/`. The next phase reads from `sdlc/<phase>/final/`. **You control the promotion.**

### Promoting a Draft

When satisfied with a draft, copy it to the phase's `final/` directory:

```bash
cp sdlc/init/draft/charter-v3.md sdlc/init/final/charter-final.md
```

This is a manual quality gate — it ensures only reviewed artifacts flow downstream.

### Pipeline Flow

```
sdlc/init/final/  →  req reads  →  sdlc/req/final/  →  design reads  →  sdlc/design/final/
                                                                              ↓
sdlc/ops/final/  ←  deploy reads  ←  sdlc/deploy/final/  ←  impl reads  ←  sdlc/impl/final/
                                                                              ↑
                                                                        sdlc/test/final/
```

Each phase reads from the previous phase's `sdlc/<phase>/final/` directory. If an input isn't found in `final/`, the skill will ask you for a path or tell you which prerequisite skill to run first.

---

## Confidence Marking

Every item in every artifact gets a confidence marker:

| Marker | Meaning | Action |
|--------|---------|--------|
| ✅ CONFIRMED | Verified from source or user confirmation | None — this is solid |
| 🔶 ASSUMED | Reasonable assumption, needs validation | Add to Q&A, validate with stakeholder |
| ❓ UNCLEAR | Unknown, needs research or decision | Must resolve before proceeding |

### Readiness Verdicts

| Verdict | Criteria | Meaning |
|---------|----------|---------|
| **Ready** | ≥90% CONFIRMED | Safe to promote to `final/` |
| **Partially Ready** | 70-90% CONFIRMED | Usable but review ASSUMED items |
| **Not Ready** | <70% CONFIRMED | Too many unknowns, refine further |

---

## Working on a Real Project

### Recommended Workflow

1. **Start with init phase** — Run `/init-charter` with your project idea. Refine until satisfied. Promote to `final/`.

2. **Follow the phase order** — init → req → design → test → impl → deploy → ops. Within each phase, follow the skill order.

3. **Refine iteratively** — Don't try to get everything perfect on the first pass. Use the refine commands to improve.

4. **Promote when ready** — Copy drafts to `final/` when the readiness verdict is acceptable for your needs.

5. **Skip what you don't need** — Not every project needs all 23 skills. A small project might only need: charter → scope → epic → userstory → backlog → tech-stack → architecture.

### Minimum Viable Path

For a small project, the essential skills are:

```
/init-charter     → Project foundation
/init-scope       → Features and quality attributes
/req-epic         → Work themes
/req-userstory    → Implementable stories
/req-backlog      → Prioritized work
/design-stack     → Technology choices
/design-arch      → System architecture
/design-db        → Database schema
/design-api       → API contracts
/impl-sprint      → Sprint planning
/impl-workflow    → Dev process
```

### Working Directory Setup

Skills create `sdlc/` in your current working directory. Just navigate to your project and start:

```bash
cd my-project
/init-charter "A task management app"

# Skills will create sdlc/init/draft/, sdlc/init/input/, etc. as needed
# Promote outputs to sdlc/<phase>/final/ when ready
```

Your project directory will look like:

```
my-project/
├── sdlc/
│   ├── init/
│   │   ├── input/          # Converted files (from pdf/docx/etc.)
│   │   ├── draft/          # charter-draft.md, scope-draft.md, etc.
│   │   └── final/          # charter-final.md (promoted by you)
│   ├── req/
│   ├── design/
│   ├── test/
│   ├── impl/
│   ├── deploy/
│   └── ops/
├── src/                    # Your code
└── ...
```

---

## Upgrading Skills

### When to Upgrade

Upgrade when the SDLC-Skills repository has been updated with:
- Bug fixes in skill workflows
- Improved templates or knowledge
- New skills or phases
- Rule refinements

### Upgrade Steps

```bash
# 1. Navigate to your SDLC-Skills clone
cd /path/to/SDLC-Skills

# 2. Pull latest changes
git pull origin master

# 3. Reinstall skills
bash install.sh
```

If using symlink mode, pulling is sufficient — symlinks already point to the source:

```bash
cd /path/to/SDLC-Skills
git pull origin master
# Done! Changes are live immediately.
```

### Upgrade Safety

- **Your drafts are safe.** Drafts are written to `sdlc/` in your project directory, not inside the skills installation. Reinstalling skills never touches your project artifacts.
- **Your final/ artifacts are safe.** The `sdlc/<phase>/final/` directories are in your project directory and are not affected by skill updates.
- **Reinstalling cleans old skills.** The installer removes and re-creates each skill, so renamed or deleted skills are cleaned up automatically.

### Version Checking

Check which version you have:

```bash
# Check the latest commit
cd /path/to/SDLC-Skills
git log --oneline -1

# Compare with remote
git fetch origin
git log --oneline HEAD..origin/master
```

---

## Uninstalling

### Remove All Skills

```bash
rm -rf ~/.claude/skills/sdlc-*
```

### Remove a Single Skill

```bash
rm -rf ~/.claude/skills/sdlc-init-charter
```

### Remove a Phase

```bash
rm -rf ~/.claude/skills/sdlc-design-*
```

---

## Multi-Format Input

Skills accept input in any of these formats:

| Format | Extension | Converter Skill |
|--------|-----------|----------------|
| Markdown | `.md` | None (read directly) |
| PDF | `.pdf` | `/read-pdf` |
| Word | `.docx`, `.doc` | `/read-word` |
| Excel | `.xlsx`, `.xls` | `/read-excel` |
| PowerPoint | `.pptx`, `.ppt` | `/read-ppt` |

### How It Works

When you provide a non-markdown file as input, the skill automatically:

1. Detects the file extension
2. Runs the appropriate converter skill (e.g., `/read-pdf`)
3. Saves the converted markdown to `sdlc/<phase>/input/`
4. Reads the converted file and proceeds normally

```
/init-charter path/to/project-brief.pdf
# → Converts to sdlc/init/input/project-brief.md
# → Creates sdlc/init/draft/charter-draft.md
```

### Using Converters Directly

You can also run converter skills standalone:

```
/read-pdf path/to/document.pdf sdlc/init/input/
/read-word path/to/document.docx sdlc/req/input/
/read-excel path/to/spreadsheet.xlsx sdlc/req/input/
/read-ppt path/to/presentation.pptx sdlc/design/input/
```

Converted files are cached — if the markdown output already exists and is newer than the source file, conversion is skipped.

---

## Troubleshooting

### Skill Command Not Recognized

- Verify the skill is installed: `ls ~/.claude/skills/sdlc-init-charter/SKILL.md`
- Reinstall: `bash install.sh`
- Restart Claude Code after installation

### "No charter found" / Missing Input

- The skill can't find a required input file
- Either provide a path as argument: `/init-scope path/to/charter.md` (any format: md, pdf, docx, xlsx, pptx)
- Or promote the prerequisite: `cp sdlc/init/draft/charter-v2.md sdlc/init/final/charter-final.md`

### Skill Reads Wrong Version

- Skills read from `sdlc/<phase>/final/` by default
- If you've refined multiple times, make sure the latest version is promoted to `final/`
- Check: `ls sdlc/<phase>/final/`

### Output Not What Expected

- Run the refine command with specific feedback
- Check the sample output in `templates/sample-output.md` for the expected format
- Review the rules in `rules/output-rules.md` for constraints the skill enforces
