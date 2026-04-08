---
name: req-backlog
description: >
  Create or refine a prioritized product backlog from user stories and epics.
  Applies MoSCoW prioritization, dependency ordering, release grouping,
  and velocity-based capacity validation. Marks the MVP boundary.
  ONLY activated by command: `/req-backlog`. Use `--create` or `--refine` to set mode.
  NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine [path to userstories file (md/pdf/docx/xlsx/pptx)]"
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

## Two Modes

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

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `backlog-draft.md` | `sdlc/req/draft/` |
| Refine | `backlog-v{N}.md` | `sdlc/req/draft/` (N = next version number) |

When user is satisfied -> they copy from `sdlc/req/draft/` to `sdlc/req/final/backlog-final.md`.

---

## Workflow

### Step 1: Determine Mode

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

### Step 3: Resolve Input

**File Type Conversion** (applies to all file inputs):

Before reading any input file, check its extension:
- `.md` → Read directly, no conversion needed
- `.pdf` → Run `/read-pdf <path> sdlc/req/input/` → read the converted .md
- `.docx` / `.doc` → Run `/read-word <path> sdlc/req/input/` → read the converted .md
- `.xlsx` / `.xls` → Run `/read-excel <path> sdlc/req/input/` → read the converted .md
- `.pptx` / `.ppt` → Run `/read-ppt <path> sdlc/req/input/` → read the converted .md

Converted files are saved to `sdlc/req/input/`. If a converted .md already exists and is newer than the source, skip conversion.

**Mode 1 (Create):**

```
For userstories input (required):
1. User specified path?                        -> YES -> read it, copy to sdlc/req/input/ -> DONE
2. Exists in sdlc/req/input/userstories-final.md? -> YES -> read it -> DONE
3. Exists in sdlc/req/final/userstories-final.md? -> YES -> read it, copy to sdlc/req/input/ -> DONE
4. Not found? -> Ask: "No user stories found. Run /req-userstory first."

For epics input (required):
1-3. Standard resolution from sdlc/req/final/
4. Not found? -> Ask: "No epics found. Run /req-epic first."

For scope and charter (optional):
Standard resolution from sdlc/init/final/. Proceed without if not found.
```

**Mode 2 (Refine):** Standard refine input resolution.

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

### Step 5-7: Validate, Readiness, Output

Standard validation and output workflow.

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
