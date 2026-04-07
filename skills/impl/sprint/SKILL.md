---
name: impl-sprint
description: >
  Create or refine a sprint execution plan. Breaks user stories into implementable
  tasks, plans capacity, assigns work, and defines sprint goals. Validates
  stories against Definition of Ready and tasks against team velocity.
  ONLY activated by commands: `/impl-sprint` (create) or `/impl-sprint-refine` (refine).
  NEVER auto-trigger based on keywords.
argument-hint: "[path to backlog-final.md or sprint number to plan]"
version: "1.0"
category: sdlc
phase: impl
prev_phase: test-cases
next_phase: impl-codegen
---

# Sprint Planning Skill

## Purpose

Create or refine a sprint execution plan (`sprint-plan-draft.md`) that breaks user stories into implementable tasks, plans team capacity, assigns work, validates stories against Definition of Ready, and defines clear sprint goals aligned with releases.

The sprint plan turns the prioritized backlog into an actionable execution schedule — sprint by sprint, story by story, task by task.

---

## Two Modes

### Mode 1: Create (`/impl-sprint`)

Generate a sprint execution plan from the prioritized backlog and design artifacts.

| Input | Required | Source |
|-------|----------|--------|
| Backlog (final) | Yes | `req/final/backlog-final.md` or user-specified path |
| User stories (final) | Yes | `req/final/userstories-final.md` or user-specified path |
| DoR/DoD (final) | Yes | `req/final/dor-dod-final.md` or user-specified path |
| Architecture (final) | No | `design/final/architecture-final.md` — component structure for task decomposition |
| API (final) | No | `design/final/api-final.md` — endpoint details for implementation tasks |
| Database (final) | No | `design/final/database-final.md` — table details for migration tasks |
| Test cases (final) | No | `test/final/test-cases-final.md` — test cases to include as test tasks |
| Charter (final) | No | `init/final/charter-final.md` — team structure, timeline constraints |
| Epics (final) | No | `req/final/epics-final.md` — epic grouping for sprint themes |

### Mode 2: Refine (`/impl-sprint-refine`)

Improve existing sprint plan based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing sprint plan draft | Yes | `draft/sprint-plan-draft.md` or `draft/sprint-plan-v{N}.md` |
| Review report / feedback | Yes | User provides directly or as `input/review-report.md` |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `sprint-plan-draft.md` | `draft/` |
| Refine | `sprint-plan-v{N}.md` | `draft/` (N = next version number) |

When user is satisfied -> they copy from `draft/` to `impl/final/sprint-plan-final.md`.

---

## Workflow

### Step 1: Determine Mode

Standard mode detection (create vs refine).

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md`
2. `skills/shared/rules/quality-rules.md`
3. `skills/shared/rules/output-rules.md`
4. `impl/shared/rules/impl-rules.md`
5. `impl/shared/templates/sprint/sprint-template.md`
6. `impl/sprint/knowledge/sprint-planning-guide.md`
7. `impl/sprint/rules/output-rules.md`
8. `impl/sprint/templates/output-template.md`

### Step 3: Resolve Input

**Mode 1 (Create):**

```
For backlog input (required):
1. User specified path?                      -> YES -> read it, copy to input/ -> DONE
2. Exists in input/backlog-final.md?         -> YES -> read it -> DONE
3. Exists in req/final/backlog-final.md?     -> YES -> read it, copy to input/ -> DONE
4. Not found? -> Ask: "No backlog found. Run /req-backlog first."

For userstories input (required):
1-3. Standard resolution from req/final/
4. Not found? -> Ask: "No user stories found. Run /req-userstory first."

For dor-dod input (required):
1-3. Standard resolution from req/final/
4. Not found? -> Ask: "No DoR/DoD found. Run /req-trace first."

For design artifacts (optional):
Standard resolution from design/final/. Proceed without if not found.

For test cases (optional):
Standard resolution from test/final/. Proceed without if not found.

For charter and epics (optional):
Standard resolution from init/final/ and req/final/. Proceed without if not found.
```

**Mode 2 (Refine):** Standard refine input resolution.

### Step 4: Generate (Mode-specific)

**Mode 1 -- Create:**

1. **Sprint Overview** -- Plan sprint structure
   - Determine number of sprints from backlog releases and velocity
   - Set sprint duration (from charter or default 2 weeks)
   - Calculate team capacity per sprint (members x available days x focus factor)
   - State velocity assumptions with confidence markers
   - Align sprint count with release milestones (MVP, R2, R3)
   - Present overview plan to user before detailed breakdown

2. **DoR Validation** -- Check each story against Definition of Ready
   - Walk through every story planned for detailed sprints
   - Check each DoR criterion from dor-dod-final.md
   - Stories passing all criteria: mark as Ready
   - Stories failing criteria: mark as Not Ready with specific gaps
   - Suggest remediation for each gap (which skill to run, what info needed)
   - Flag stories that should be deferred until DoR is met

3. **Sprint Plans** -- For each sprint:
   - Sprint goal: 1 sentence, aligned with epic theme or release milestone
   - Stories committed: pulled from backlog in priority order
   - Capacity calculation: team members x available days x focus factor (0.6-0.8)
   - Utilization check: committed points <= capacity, flag if >90%
   - Buffer allocation: 10-20% reserved for unplanned work
   - Release alignment: which release does this sprint contribute to

4. **Task Breakdown** -- For each story in each sprint:
   - Break into implementation tasks (2-8 hours each, per IMP-03)
   - Walk through architecture layers: DB -> Service -> API -> Frontend -> Tests -> Infra
   - Include test tasks for every feature task (IMP-05)
   - Specify task dependencies (T-xxx depends on T-yyy)
   - Map each task to applicable DoD criteria (IMP-04)
   - Trace tasks to design artifacts (IMP-01): architecture components, API endpoints, DB tables

5. **Team Assignments** -- Assign tasks based on skills and capacity
   - Match tasks to team member roles (backend, frontend, full-stack)
   - Balance workload across team members
   - Verify no team member is over-allocated
   - Consider task dependencies when assigning (avoid blocking)

6. **Sprint Dependencies** -- Map cross-sprint and external dependencies
   - Generate Mermaid diagram of sprint-to-sprint dependencies
   - Show internal task dependency chains per sprint
   - List external dependencies (third-party APIs, design assets, infrastructure)
   - Identify risk items per sprint

7. **Definition of Done Checklist** -- Per-task completion criteria
   - Derive checklist from dor-dod-final.md
   - Map each DOD item to applicable task types
   - Include verification method for each criterion

**Mode 2 -- Refine:**

Standard refine workflow:
1. Read existing sprint plan draft
2. Generate Quality Scorecard (SPR-11):
   - Sprint goals: Are they clear and achievable?
   - Capacity: Is utilization within bounds?
   - DoR compliance: Are all stories validated?
   - Task granularity: Are tasks 2-8 hours?
   - Dependencies: Are they explicit and acyclic?
   - DoD mapping: Does every task reference DoD criteria?
   - Test coverage: Does every feature task have a test task?
3. Read user feedback / review report
4. Apply improvements
5. Output versioned sprint plan

### Step 5: Validate

Validate output against:
- Implementation phase rules (IMP-01 through IMP-10)
- Sprint plan output rules (SPR-01 through SPR-14)
- Project-wide output rules

Flag any violations and fix before output.

### Step 6: Readiness Assessment

Count confidence markers across all sprint plan items:
- Sprint goals, capacity estimates, assignments, task breakdowns
- Calculate CONFIRMED / ASSUMED / UNCLEAR percentages
- Determine verdict: Ready / Partially Ready / Not Ready

### Step 7: Output and Next Steps

Tell the user:
> **Sprint plan {created/refined}!**
> - Output: `draft/sprint-plan-{version}.md`
> - Readiness: {verdict}
> - Sprints planned: {N} detailed, {M} high-level
> - Total tasks: {N} across {M} stories
> - Capacity utilization: {avg}% average across sprints
> - DoR issues: {N} stories flagged
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/impl-sprint-refine`
> - When satisfied, copy to `impl/final/sprint-plan-final.md`
> - Then run `/impl-codegen` to generate implementation code from the sprint plan

---

## Scope Rules

### This skill DOES:
- Plan sprints with goals, stories, capacity, and utilization
- Break user stories into implementable tasks (2-8 hours each)
- Plan team capacity and assign work to team members
- Validate stories against Definition of Ready
- Map tasks to DoD criteria
- Trace tasks to design artifacts (architecture, API, DB)
- Include test tasks for every feature task
- Visualize sprint and task dependencies
- Plan MVP sprints in detail, post-MVP sprints at high level

### This skill does NOT:
- Generate implementation code (belongs to `impl/codegen` skill)
- Define development workflow or branching strategy (belongs to `impl/workflow` skill)
- Execute sprints or track actual progress
- Create or modify user stories (belongs to `req/userstory` skill)
- Create or modify the backlog (belongs to `req/backlog` skill)
- Define DoR/DoD (belongs to `req/traceability` skill)
- Make architecture or design decisions (belongs to `design/` phase)
