---
name: req-backlog
description: >
  Create or refine a prioritized product backlog from user stories and epics.
  Applies MoSCoW prioritization, dependency ordering, release grouping,
  and velocity-based capacity validation. Marks the MVP boundary.
  ONLY activated by command: `/req-backlog`. Use `--create`, `--refine`, or `--score` to set mode.
  NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine|--score"
version: "1.0"
category: sdlc
phase: req
prev_phase: req-userstory
next_phase: req-trace
---

# Product Backlog Skill

## Purpose

Create or refine a prioritized product backlog (`sdlc/req/draft/backlog-draft.md`) that orders all user stories by priority, validates capacity against velocity, groups stories into releases, and marks the MVP boundary.

The backlog is the single, ordered list of everything the team will build. It transforms individual stories into a delivery plan.

---

## Three Modes

### Mode 1: Create (`--create`)

Generate a prioritized backlog from user stories and epics.

| Input | Required | Source |
|-------|----------|--------|
| User stories (final) | Yes | `sdlc/req/final/userstories-final.md` or user-specified path |
| Epics (final) | Yes | `sdlc/req/final/epics-final.md` or user-specified path |
| Scope (final) | No | `sdlc/init/final/scope-final.md` — for MoSCoW alignment validation |
| Charter (final) | No | `sdlc/init/final/charter-final.md` — for budget/timeline constraints |

### Mode 2: Refine (`--refine`)

Improve existing backlog based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing backlog draft | Yes | `sdlc/req/draft/backlog-draft.md` or `sdlc/req/draft/backlog-v{N}.md` |
| Review report / feedback | Yes | User provides directly or as `sdlc/req/input/review-report.md` |

### Mode 3: Score (`--score`)

Evaluate artifact quality with a detailed scoreboard.

| Input | Required | Source |
|-------|----------|--------|
| Artifact to score | Yes | `sdlc/req/draft/backlog-draft.md` or latest `backlog-v{N}.md` or `sdlc/req/final/backlog-final.md`, or user-specified path |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `backlog-draft.md` | `sdlc/req/draft/` |
| Refine | `backlog-v{N}.md` | `sdlc/req/draft/` (N = next version number) |
| Score | `backlog-scoreboard.md` | `sdlc/req/draft/` |

When user is satisfied -> they copy from `sdlc/req/draft/` to `sdlc/req/final/backlog-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User passes `--score` argument → **Mode 3 (Score)**
- User passes `--refine` argument → **Mode 2 (Refine)**
- User passes `--create` argument → **Mode 1 (Create)**
- No argument specified AND existing draft exists in `sdlc/req/draft/` → Ask: "A draft already exists. Use `--create` to start fresh or `--refine` to improve it."
- No argument specified AND no draft exists → **Mode 1 (Create)**

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md`
2. `skills/shared/rules/quality-rules.md`
3. `skills/shared/rules/output-rules.md`
4. `skills/shared/knowledge/agile-scrum-guide.md` -- MoSCoW, estimation
5. `req/shared/rules/req-rules.md`
6. `req/shared/templates/backlog/backlog-template.md`
7. `req/backlog/knowledge/backlog-prioritization-guide.md`
8. `req/backlog/rules/output-rules.md`
9. `req/backlog/templates/output-template.md`
For Mode 3 (Score): Read resources listed in `skills/shared/knowledge/score-workflow.md`

### Step 3: Resolve Input

Resolve inputs per `skills/shared/knowledge/input-resolution-workflow.md`.

**Create mode inputs:**

| Input | Required | Default Path | Fallback |
|-------|----------|-------------|----------|
| User stories (final) | Yes | `sdlc/req/final/userstories-final.md` | "No user stories found. Run /req-userstory first or provide a path." |
| Epics (final) | Yes | `sdlc/req/final/epics-final.md` | "No epics found. Run /req-epic first or provide a path." |
| Scope (final) | No | `sdlc/init/final/scope-final.md` | Proceed without scope validation |
| Charter (final) | No | `sdlc/init/final/charter-final.md` | Proceed without charter constraints |

**Refine mode inputs:**

| Input | Required | Source |
|-------|----------|--------|
| Existing draft | Yes | `sdlc/req/draft/backlog-draft.md` or latest `backlog-v{N}.md` |
| Review feedback | Yes | User message or `sdlc/req/input/review-report.md` |

### Step 4: Generate (Mode-specific)

**Mode 1 -- Create:**

1. **Backlog Assembly** -- Collect all stories
   - Import all stories from userstories-final.md
   - Carry forward story points, epic assignments, dependencies, tags
   - Verify no stories are missing

2. **MoSCoW Validation** -- Check priority consistency
   - Compare story priorities against scope feature priorities
   - Flag inconsistencies (REQ-08)
   - Calculate MoSCoW distribution (target: ~60/20/20)
   - Flag if Must Have exceeds 70% of total points

3. **Priority Ordering** -- Rank all stories
   - Must Have stories ranked first (within dependency constraints)
   - Within same priority: order by dependency chain, then by value
   - Respect dependencies: dependency always ranked before dependent
   - Mark MVP boundary after last Must Have story

4. **Dependency Graph** -- Visualize story dependencies
   - Generate Mermaid diagram of story dependencies
   - Identify critical path
   - Flag circular dependencies as errors

5. **Release Grouping** -- Organize into releases
   - Release 1 (MVP): All Must Have stories
   - Release 2+: Should Have, then Could Have
   - Calculate total points per release
   - Estimate sprint count per release

6. **Velocity Assumptions** -- Validate capacity
   - Document assumed velocity (from charter team size)
   - Calculate sprints needed for Must Have stories
   - Compare against charter timeline constraint
   - Flag capacity risks if Must Have exceeds available sprints

**Mode 2 -- Refine:**

Standard refine workflow: scorecard -> feedback -> improvements -> versioned output.

**Mode 3 -- Score:**

Follow the standard score workflow in `skills/shared/knowledge/score-workflow.md` using this skill's rules and templates as context.

### Step 5-7: Validate, Readiness, Output

Standard validation and output workflow.

**Mode 3 (Score):** Output per score workflow — `sdlc/req/draft/backlog-scoreboard.md`

Tell the user:
> **Backlog {created/refined}!**
> - Output: `sdlc/req/draft/backlog-{version}.md`
> - Readiness: {verdict}
> - Stories: {total} ({must} Must, {should} Should, {could} Could)
> - Total points: {N} ({mvp_pts} for MVP)
> - Estimated sprints: {N} for MVP, {M} total
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/req-backlog --refine`
> - When satisfied, copy to `sdlc/req/final/backlog-final.md`
> - Then run `/req-trace` to build the traceability matrix and DoR/DoD

---

## Scope Rules

### This skill DOES:
- Prioritize and order all user stories
- Apply MoSCoW prioritization and validate distribution
- Respect story dependencies in ordering
- Group stories into releases
- Mark MVP boundary
- Validate capacity against velocity assumptions
- Generate dependency graph

### This skill does NOT:
- Create or modify user stories (belongs to `req/userstory` skill)
- Create or modify epics (belongs to `req/epic` skill)
- Build traceability matrix (belongs to `req/traceability` skill)
- Plan individual sprints (belongs to `impl/sprint` skill)
- Make technology decisions (belongs to `design/` phase)
- Assign stories to specific team members
