---
name: impl-workflow
description: >
  Create or refine a development workflow document. Defines branching strategy,
  pull request process, code review standards, CI/CD pipeline integration,
  coding conventions, and hotfix procedures. Establishes the team's day-to-day
  development practices.
  ONLY activated by commands: `/impl-workflow` (create) or `/impl-workflow-refine` (refine).
  NEVER auto-trigger based on keywords.
argument-hint: "[path to tech-stack-final.md or test-strategy-final.md]"
version: "1.0"
category: sdlc
phase: impl
prev_phase: impl-codegen
next_phase: deploy-cicd
---

# Development Workflow Skill

## Purpose

Create or refine a development workflow document (`dev-workflow-draft.md`) that defines how code gets from a developer's machine to production. Covers branching strategy, pull request process, code review standards, CI/CD pipeline integration, coding conventions, hotfix procedures, release process, and environment promotion.

This skill establishes the team's day-to-day development practices — the repeatable processes that ensure code quality, collaboration, and reliable delivery.

---

## Two Modes

### Mode 1: Create (`/impl-workflow`)

Generate a development workflow from tech stack and test strategy artifacts.

| Input | Required | Source |
|-------|----------|--------|
| Tech Stack (final) | Yes | `design/final/tech-stack-final.md` or user-specified path |
| Test Strategy (final) | Yes | `test/final/test-strategy-final.md` or user-specified path |
| Architecture (final) | No | `design/final/architecture-final.md` -- service boundaries for branching scope |
| DoR/DoD (final) | No | `impl/final/dor-dod-final.md` -- DoD criteria for PR checklist |
| Charter (final) | No | `init/final/charter-final.md` -- team size for review requirements |
| Codegen Plan (final) | No | `impl/final/codegen-plan-final.md` -- project structure for CI config |

### Mode 2: Refine (`/impl-workflow-refine`)

Improve existing workflow document based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing workflow draft | Yes | `draft/dev-workflow-draft.md` or `draft/dev-workflow-v{N}.md` |
| Review report / feedback | Yes | User provides directly or as `input/review-report.md` |
| Additional details | No | New information the user wants to add |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `dev-workflow-draft.md` | `draft/` |
| Refine | `dev-workflow-v{N}.md` | `draft/` (N = next version number) |

When user is satisfied -> they copy from `draft/` to `impl/final/dev-workflow-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User runs `/impl-workflow-refine` AND existing draft exists in `draft/` -> **Mode 2 (Refine)**
- User runs `/impl-workflow` -> **Mode 1 (Create)**
- User runs `/impl-workflow` but draft already exists -> Ask: "A workflow draft already exists. Create new (overwrite) or refine existing?"

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md` -- document formatting standards
2. `skills/shared/rules/quality-rules.md` -- confidence marking, readiness assessment
3. `skills/shared/rules/output-rules.md` -- versioning, input resolution, diff summary
4. `impl/shared/rules/impl-rules.md` -- implementation phase rules
5. `impl/shared/templates/workflow/workflow-template.md` -- workflow section format
6. `impl/workflow/knowledge/dev-workflow-guide.md` -- workflow techniques and patterns
7. `impl/workflow/rules/output-rules.md` -- workflow-specific output rules
8. `impl/workflow/templates/output-template.md` -- expected output structure

### Step 3: Resolve Input

**Mode 1 (Create):**

```
For tech-stack input (required):
1. User specified path?                             -> YES -> read it, copy to input/ -> DONE
2. Exists in input/tech-stack-final.md?             -> YES -> read it -> DONE
3. Exists in design/final/tech-stack-final.md?      -> YES -> read it, copy to input/ -> DONE
4. Not found? -> Ask: "No tech stack found. Please provide a path or run /design-stack first."

For test-strategy input (required):
1. User specified path?                             -> YES -> read it, copy to input/ -> DONE
2. Exists in input/test-strategy-final.md?          -> YES -> read it -> DONE
3. Exists in test/final/test-strategy-final.md?     -> YES -> read it, copy to input/ -> DONE
4. Not found? -> Ask: "No test strategy found. Please provide a path or run /test-strategy first."

For architecture input (optional):
1. User specified path?                             -> YES -> read it, copy to input/ -> DONE
2. Exists in input/architecture-final.md?           -> YES -> read it -> DONE
3. Exists in design/final/architecture-final.md?    -> YES -> read it, copy to input/ -> DONE
4. Not found? -> Proceed without architecture.

For DoR/DoD input (optional):
1. User specified path?                             -> YES -> read it, copy to input/ -> DONE
2. Exists in input/dor-dod-final.md?                -> YES -> read it -> DONE
3. Exists in impl/final/dor-dod-final.md?           -> YES -> read it, copy to input/ -> DONE
4. Not found? -> Proceed without DoR/DoD.

For charter input (optional):
1. User specified path?                             -> YES -> read it, copy to input/ -> DONE
2. Exists in input/charter-final.md?                -> YES -> read it -> DONE
3. Exists in init/final/charter-final.md?           -> YES -> read it, copy to input/ -> DONE
4. Not found? -> Proceed without charter.

For codegen plan input (optional):
1. User specified path?                             -> YES -> read it, copy to input/ -> DONE
2. Exists in input/codegen-plan-final.md?           -> YES -> read it -> DONE
3. Exists in impl/final/codegen-plan-final.md?      -> YES -> read it, copy to input/ -> DONE
4. Not found? -> Proceed without codegen plan.
```

**Mode 2 (Refine):**

```
For workflow draft:
1. User specified path?                             -> YES -> read it, copy to input/ -> DONE
2. Exists in input/?                                -> YES -> read it -> DONE
3. Exists in draft/ (latest version)?               -> YES -> read it, copy to input/ -> DONE
4. Not found? -> FAIL: "No existing workflow draft found. Run /impl-workflow first."

For review report:
1. User provided feedback directly in message?      -> Save to input/review-report.md
2. User specified path?                             -> read it, copy to input/
3. Exists in input/review-report.md?                -> read it
4. Not found? -> Ask: "What feedback do you have on the current workflow document?"
```

### Step 4: Generate (Mode-specific)

**Mode 1 -- Create:**

Work through the workflow document **section by section, incrementally**:

1. **Branching Strategy** -- Branch model selection with justification
   - Evaluate GitHub Flow, Git Flow, and Trunk-Based against team context
   - Select model based on team size, release cadence, and CI maturity
   - Define branch types with naming conventions (include ticket ID)
   - Define branch lifecycle (creation, merge, deletion)
   - Set protection rules for permanent branches
   - Present proposed strategy to user before continuing

2. **PR Process** -- Pull request workflow and standards
   - Define PR template (description, tickets, changes, testing, checklist)
   - Set size guidelines (ideal, flag, split thresholds)
   - Include DoD items from dor-dod-final.md in PR checklist
   - Define review assignment strategy (round-robin, expertise-based)
   - Select merge strategy (squash/merge/rebase) with justification
   - Define auto-merge conditions and stale PR policies

3. **Code Review Standards** -- What reviewers check and how
   - Define review checklist by category (correctness, design, security, tests)
   - Set turnaround SLA by PR type (feature, hotfix, chore)
   - Set minimum reviewer count based on team size
   - Define review etiquette (nitpick prefix, suggest alternatives, praise)
   - Distinguish blocking vs non-blocking review comments

4. **CI/CD Pipeline** -- Pipeline from commit to production
   - Map test strategy stages to CI pipeline stages
   - Define pre-commit hooks (local, lint-staged)
   - Define PR pipeline (lint, type check, unit, integration, build)
   - Define post-merge pipeline (deploy staging, E2E, performance)
   - Define release pipeline (deploy production, smoke tests, monitoring)
   - Mark each stage as blocking or advisory
   - Estimate duration per stage
   - Create Mermaid pipeline diagram
   - Define cache strategies for faster CI

5. **Coding Standards** -- Language-specific conventions
   - Define naming conventions (files, classes, functions, variables)
   - Define formatting rules (tool, config)
   - Define linting rules (tool, config)
   - Define import ordering rules
   - Define commit message format (Conventional Commits)
   - Define enforcement mechanisms (pre-commit hooks, CI checks)

6. **Hotfix Process** -- Emergency fix workflow
   - Define hotfix branch creation from main
   - Define minimal fix scope rules
   - Define expedited review process (fewer reviewers, faster SLA)
   - Define merge targets (main AND develop/release branches)
   - Define immediate deployment path
   - Define post-incident review requirement
   - Create Mermaid hotfix flowchart

7. **Release Process** -- How releases are cut
   - Define release branching (if applicable to branching model)
   - Define version tagging strategy (semver)
   - Define changelog generation (auto from conventional commits or manual)
   - Define release approval requirements
   - Define release artifact creation

8. **Environment Promotion** -- Code movement through environments
   - Define environments (dev, staging, production)
   - Define deploy method per environment
   - Define promotion triggers (auto vs manual)
   - Define rollback procedures per environment
   - Define health check requirements before promotion

For each section:
- Apply confidence markers (CONFIRMED / ASSUMED / UNCLEAR)
- Inherit confidence from input artifacts where applicable
- Create Q&A entries for ASSUMED and UNCLEAR items
- Present section to user before moving to next

**Mode 2 -- Refine:**

1. Read existing workflow draft (baseline)
2. Read review report / user feedback
3. Run Quality Scorecard analysis
4. Present scorecard to user
5. Apply improvements:
   - Address user feedback point by point
   - Resolve Q&A entries from previous version
   - Upgrade confidence levels where possible
   - Add missing workflow sections discovered during review
   - Adjust pipeline stages based on feedback
   - Refine SLAs and thresholds based on team input
6. Tag all changes: `[UPDATED]` for modified items, `[NEW]` for additions
7. Preserve CONFIRMED items unless user explicitly contradicts them
8. Write improved version to `draft/dev-workflow-v{N}.md`

### Step 5: Validate Output

Check against rules:
- Every decision has a confidence marker (CR-01)
- Branching strategy selected with justification (WFL-01)
- Branch naming includes ticket ID (WFL-02)
- PR checklist includes DoD items (WFL-03)
- Code review specifies reviewer count and SLA (WFL-04)
- CI pipeline includes all test strategy stages (WFL-05)
- CI stages marked blocking vs advisory (WFL-06)
- Commit message format specified (WFL-07)
- Hotfix process defined with expedited review (WFL-08)
- Correct section order (WFL-09)
- Confidence markers on every decision (WFL-10)
- Refine mode shows scorecard first (WFL-11)
- CI pipeline Mermaid diagram present (WFL-12)
- Release versioning uses semver (WFL-13)
- Rollback procedures documented per environment (WFL-14)
- Traces to input artifacts (IMP-01)
- Tech stack compliance (IMP-02)
- No gold plating (IMP-06)
- Approval section present (IMP-10)

### Step 6: Readiness Assessment

Generate assessment per `skills/shared/templates/readiness-assessment.md`:
- Count items by confidence level (each workflow decision is 1 item)
- Calculate readiness verdict
- In refine mode: compare with previous version

### Step 7: Output

- **Create mode**: Write to `draft/dev-workflow-draft.md`
- **Refine mode**: Write to `draft/dev-workflow-v{N}.md`, include Change Log and Diff Summary

Tell the user:
> **Development workflow {created/refined}!**
> - Output: `draft/dev-workflow-{version}.md`
> - Readiness: {verdict}
> - Branching model: {model}
> - Pipeline stages: {count}
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/impl-workflow-refine`
> - When satisfied, copy to `impl/final/dev-workflow-final.md`
> - Then run `/deploy-cicd` to define the CI/CD deployment pipeline

---

## Scope Rules

### This skill DOES:
- Select and justify a branching strategy for the team
- Define PR process, templates, and merge strategy
- Set code review standards, checklists, and SLAs
- Map test strategy stages to CI/CD pipeline stages
- Define coding standards and enforcement mechanisms
- Document hotfix, release, and environment promotion workflows
- Create pipeline diagrams in Mermaid

### This skill does NOT:
- Implement CI/CD pipelines (belongs to `deploy/cicd` skill)
- Write CI/CD configuration files (belongs to `deploy/cicd` skill)
- Write actual source code (belongs to developer work)
- Set up environments (belongs to `deploy/env` skill)
- Define sprint plans (belongs to `impl/sprint` skill)
- Define test cases or test strategy (belongs to `test/` phase)
- Make technology decisions (reads from `design/` phase artifacts)
- Define monitoring or alerting (belongs to `ops/` phase)
- Modify design or test artifacts -- it reads them as input
