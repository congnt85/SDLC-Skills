---
name: deploy-release
description: >
  Create or refine a release management plan covering versioning strategy,
  release types, changelog automation, approval workflow, rollback procedures,
  and release calendar. Maps releases to backlog milestones (MVP, R2, R3).
  ONLY activated by commands: `/deploy-release` (create) or `/deploy-release-refine` (refine).
  NEVER auto-trigger based on keywords.
argument-hint: "[path to cicd-pipeline-final.md] (md/pdf/docx/xlsx/pptx)"
version: "1.0"
category: sdlc
phase: deploy
prev_phase: deploy-cicd
next_phase: deploy-env
---

# Release Management Skill

## Purpose

Create or refine a release management plan (`release-plan-draft.md`) that defines versioning strategy, release types and processes, changelog management, approval workflows, rollback procedures, a release calendar aligned to backlog milestones, and DORA metrics targets.

The release plan ensures every deployment is planned, traceable, reversible, and communicated. It bridges CI/CD pipeline mechanics with business-level release coordination.

---

## Two Modes

### Mode 1: Create (`/deploy-release`)

Generate a release management plan from CI/CD pipeline definition and backlog.

| Input | Required | Source |
|-------|----------|--------|
| CI/CD pipeline (final) | Yes | `sdlc/deploy/final/cicd-pipeline-final.md` or user-specified path |
| Backlog (final) | Yes | `sdlc/req/final/backlog-final.md` or user-specified path |
| Dev workflow (final) | No | `sdlc/impl/final/dev-workflow-final.md` — branching and merge strategy |
| Charter (final) | No | `sdlc/init/final/charter-final.md` — timeline, milestone dates |
| DoR/DoD (final) | No | `sdlc/req/final/dor-dod-final.md` — DoD for release quality gates |
| Scope (final) | No | `sdlc/init/final/scope-final.md` — quality attributes for release criteria |

### Mode 2: Refine (`/deploy-release-refine`)

Improve existing release plan based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing release plan draft | Yes | `sdlc/deploy/draft/release-plan-draft.md` or `sdlc/deploy/draft/release-plan-v{N}.md` |
| Review report / feedback | Yes | User provides directly or as `sdlc/deploy/input/review-report.md` |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `release-plan-draft.md` | `sdlc/deploy/draft/` |
| Refine | `release-plan-v{N}.md` | `sdlc/deploy/draft/` (N = next version number) |

When user is satisfied -> they copy from `sdlc/deploy/draft/` to `sdlc/deploy/final/release-plan-final.md`.

---

## Workflow

### Step 1: Determine Mode

Standard mode detection (create vs refine).

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md`
2. `skills/shared/rules/quality-rules.md`
3. `skills/shared/rules/output-rules.md`
4. `skills/shared/knowledge/agile-scrum-guide.md`
5. `deploy/shared/rules/deploy-rules.md`
6. `deploy/release/knowledge/release-management-guide.md`
7. `deploy/release/rules/output-rules.md`
8. `deploy/release/templates/output-template.md`

### Step 3: Resolve Input

**File Type Conversion** (applies to all file inputs):

Before reading any input file, check its extension:
- `.md` → Read directly, no conversion needed
- `.pdf` → Run `/read-pdf <path> sdlc/deploy/input/` → read the converted .md
- `.docx` / `.doc` → Run `/read-word <path> sdlc/deploy/input/` → read the converted .md
- `.xlsx` / `.xls` → Run `/read-excel <path> sdlc/deploy/input/` → read the converted .md
- `.pptx` / `.ppt` → Run `/read-ppt <path> sdlc/deploy/input/` → read the converted .md

Converted files are saved to `sdlc/deploy/input/`. If a converted .md already exists and is newer than the source, skip conversion.

**Mode 1 (Create):**

```
For cicd-pipeline input (required):
1. User specified path?                              -> YES -> read it, copy to sdlc/deploy/input/ -> DONE
2. Exists in sdlc/deploy/input/cicd-pipeline-final.md? -> YES -> read it -> DONE
3. Exists in sdlc/deploy/final/cicd-pipeline-final.md? -> YES -> read it, copy to sdlc/deploy/input/ -> DONE
4. Not found? -> Ask: "No CI/CD pipeline found. Run /deploy-cicd first."

For backlog input (required):
1. User specified path?                              -> YES -> read it, copy to sdlc/deploy/input/ -> DONE
2. Exists in sdlc/deploy/input/backlog-final.md?     -> YES -> read it -> DONE
3. Exists in sdlc/req/final/backlog-final.md?        -> YES -> read it, copy to sdlc/deploy/input/ -> DONE
4. Not found? -> Ask: "No backlog found. Run /req-backlog first."

For dev-workflow, charter, dor-dod, scope (optional):
Standard resolution from respective sdlc/<phase>/final/ directories. Proceed without if not found.
```

**Mode 2 (Refine):** Standard refine input resolution (drafts in `sdlc/deploy/draft/`, input in `sdlc/deploy/input/`).

### Step 4: Generate (Mode-specific)

**Mode 1 -- Create:**

1. **Versioning Strategy** -- Define version scheme
   - Semantic Versioning (MAJOR.MINOR.PATCH) rules
   - Version bump triggers for each component
   - Pre-release identifiers: -alpha.N (internal), -beta.N (stakeholder preview), -rc.N (release candidate)
   - Build metadata format (+build.NNN)
   - Starting version: 0.x.y for pre-production, 1.0.0 for first GA release
   - Map initial version to MVP milestone from backlog

2. **Release Types** -- Define process per type
   - Major release: breaking changes, full process, extended approval
   - Minor release: new features, standard process
   - Patch release: bug fixes, expedited process
   - Hotfix: emergency fixes, minimal process with post-deploy review
   - Document process differences, SLA targets, and approval requirements for each

3. **Release Process** -- Step-by-step workflow
   - Generate Mermaid flowchart of the release process
   - Define steps: code freeze -> release branch -> staging deploy -> QA sign-off -> production deploy -> smoke tests -> announce
   - Assign owners to each step
   - Define SLA for each step (time targets)
   - Reference CI/CD pipeline stages from cicd-pipeline-final.md

4. **Changelog Management** -- Automation and format
   - Auto-generation method from conventional commits
   - Keep a Changelog format (Added, Changed, Deprecated, Removed, Fixed, Security)
   - Map commit prefixes to changelog sections (feat->Added, fix->Fixed, etc.)
   - Traceability: link entries to user stories (US-xxx) from backlog
   - Audience guidance: write for both developers and stakeholders

5. **Release Approval** -- Gate criteria and approvers
   - Define approval criteria: all tests pass, no critical bugs, performance benchmarks met, security scan clean, stakeholder demo completed
   - Approvers matrix by release type (patch: tech lead; minor: tech lead + PM; major: tech lead + PM + stakeholders)
   - Evidence required: test reports, coverage reports, security scan results
   - Reference DoD criteria from dor-dod-final.md if available

6. **Rollback Procedures** -- Per-layer rollback
   - Application rollback: deploy previous artifact/image
   - Database rollback: forward-fix preferred, tested rollback migration as backup
   - Configuration rollback: revert config change, restart services
   - Target time for each rollback type
   - Communication plan during rollback (status page, team notification, stakeholder update)

7. **Release Calendar** -- Timeline and cadence
   - Map releases to backlog milestones (MVP, R2, R3)
   - Planned release dates aligned with charter timeline
   - Release cadence after GA (e.g., bi-weekly, monthly)
   - Code freeze periods before each release
   - Blackout periods (holidays, company events)

8. **Release Metrics** -- DORA metrics
   - Define four DORA metrics: deployment frequency, lead time for changes, change failure rate, MTTR
   - Set initial targets based on team maturity
   - Define measurement method and tooling
   - Improvement targets over time

**Mode 2 -- Refine:**

Standard refine workflow: scorecard -> feedback -> improvements -> versioned output.

### Step 5-7: Validate, Readiness, Output

Standard validation and output workflow.

Tell the user:
> **Release plan {created/refined}!**
> - Output: `sdlc/deploy/draft/release-plan-{version}.md`
> - Readiness: {verdict}
> - Versioning: {scheme summary}
> - Release types: {N} defined
> - Rollback targets: App <{X}min, DB <{Y}min, Config <{Z}min
> - Calendar: {N} planned releases
> - DORA targets: {maturity level}
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/deploy-release-refine`
> - When satisfied, copy to `sdlc/deploy/final/release-plan-final.md`
> - Then run `/deploy-env` to define environment management

---

## Scope Rules

### This skill DOES:
- Define versioning strategy (semver)
- Define release types and their processes
- Create release process workflow with Mermaid flowchart
- Define changelog automation and format
- Define release approval criteria and approvers
- Define rollback procedures per layer (app, DB, config)
- Create release calendar aligned to backlog milestones
- Define DORA metrics with initial targets
- Map releases to backlog releases (MVP, R2, R3)

### This skill does NOT:
- Implement or execute releases (that happens in operations)
- Define or manage environments (belongs to `deploy/env` skill)
- Define CI/CD pipeline stages (belongs to `deploy/cicd` skill)
- Plan individual sprints (belongs to `impl/sprint` skill)
- Write deployment scripts or infrastructure code
- Manage feature flags (operational concern)
