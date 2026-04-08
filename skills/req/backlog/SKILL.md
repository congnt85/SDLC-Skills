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
10. `skills/shared/knowledge/scoring-guide.md` -- scoring methodology (Mode 3 only)
11. `skills/shared/rules/scoring-rules.md` -- scoring output rules (Mode 3 only)
12. `skills/shared/templates/scoreboard-output-template.md` -- scoreboard format (Mode 3 only)

### Step 3: Resolve Input

**File Type Conversion** (applies to all file inputs):

Before reading any input file, check its extension:
- `.md` → Read directly, no conversion needed
- `.pdf` → Run `/read-pdf <path> sdlc/req/input/` → read the converted .md
- `.docx` / `.doc` → Run `/read-word <path> sdlc/req/input/` → read the converted .md
- `.xlsx` / `.xls` → Run `/read-excel <path> sdlc/req/input/` → read the converted .md
- `.pptx` / `.ppt` → Run `/read-ppt <path> sdlc/req/input/` → read the converted .md

Converted files are saved to `sdlc/req/input/`. If a converted .md already exists and is newer than the source, skip conversion.

Note: Files auto-resolved from `sdlc/` pipeline are always .md and skip conversion.

**Mode 1 (Create):**

```
For userstories input (required):
1. Exists in sdlc/req/final/userstories-final.md? -> YES -> read it -> DONE
2. User specified a different path?              -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/req/input/userstories-final.md?  -> YES -> read it -> DONE
4. Not found? -> Ask: "No user stories found. Run /req-userstory first or provide a path."

For epics input (required):
1. Exists in sdlc/req/final/epics-final.md?    -> YES -> read it -> DONE
2. User specified a different path?              -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/req/input/epics-final.md?      -> YES -> read it -> DONE
4. Not found? -> Ask: "No epics found. Run /req-epic first or provide a path."

For scope input (optional):
1. Exists in sdlc/init/final/scope-final.md?    -> YES -> read it -> DONE
2. User specified a different path?              -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/req/input/scope-final.md?      -> YES -> read it -> DONE
4. Not found? -> Proceed without scope validation.

For charter input (optional):
1. Exists in sdlc/init/final/charter-final.md?  -> YES -> read it -> DONE
2. User specified a different path?              -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/req/input/charter-final.md?    -> YES -> read it -> DONE
4. Not found? -> Proceed without charter constraints.
```

**Mode 2 (Refine):** Standard refine input resolution.

**Mode 3 (Score):**

```
For artifact to score (required):
1. User specified a path?                                     → Read it → DONE
2. Exists in sdlc/req/final/backlog-final.md?                 → Read it → DONE
3. Exists as sdlc/req/draft/backlog-v{N}.md (latest N)?       → Read it → DONE
4. Exists as sdlc/req/draft/backlog-draft.md?                 → Read it → DONE
5. Not found? → Ask: "Provide the path to the artifact to score."
```

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

1. **Read Context** — Read this skill's own `templates/output-template.md` and `rules/output-rules.md` to understand expected structure and quality constraints.

2. **Score Each Dimension** — Evaluate the artifact against all 5 quality dimensions (Completeness, Clarity, Consistency, Quantification, Traceability):
   - For each dimension, cite at least 2 specific evidence items from the artifact
   - Score using criteria from `skills/shared/knowledge/scoring-guide.md`
   - Record issues found during scoring

3. **Check Skill Rules Compliance** — For each rule in this skill's `rules/output-rules.md`:
   - ✅ PASS — artifact fully complies
   - ❌ FAIL — artifact clearly violates
   - ⚠️ PARTIAL — artifact partially complies

4. **Compile Issues** — Gather all issues from dimension scoring and rules compliance:
   - Assign severity: HIGH / MED / LOW
   - Link each to its dimension and artifact section

5. **Generate Recommendations** — 3-7 actionable recommendations:
   - HIGH severity issues first, then lowest-scoring dimensions
   - Each specifies: what to change, where, expected result

6. **Calculate Summary** — Average score, lowest/highest dimensions, overall verdict (🟢 Strong ≥4.0 / 🟡 Adequate 3.0-3.9 / 🔴 Needs Work <3.0)

### Step 5-7: Validate, Readiness, Output

Standard validation and output workflow.

**Mode 3 (Score) — additional checks:**
- All 5 dimensions scored with evidence (SCR-01, SCR-02)
- Integer scores 1-5 (SCR-03)
- Issues linked to dimensions and sections (SCR-04, SCR-05)
- Recommendations are actionable, 3-7 count (SCR-06, SCR-07)
- Scoring used this skill's own rules/templates as context (SCR-08)
- Rules compliance section present (SCR-10)

**Mode 3 (Score):**

- Write to `sdlc/req/draft/backlog-scoreboard.md`

Tell the user:
> **Scoreboard complete!**
> - Output: `sdlc/req/draft/backlog-scoreboard.md`
> - Average: {avg}/5 — {verdict}
> - Lowest: {dimension} ({score}/5)
> - Issues: {N} (HIGH: {H}, MED: {M}, LOW: {L})
>
> **Next steps:**
> - Run `/req-backlog --refine` to address issues
> - Or run `/skill-evolution --analyze req/backlog` to improve the skill definition itself

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
