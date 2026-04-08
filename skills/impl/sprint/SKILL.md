---
name: impl-sprint
description: >
  Create or refine a sprint execution plan. Breaks user stories into implementable
  tasks, plans capacity, assigns work, and defines sprint goals. Validates
  stories against Definition of Ready and tasks against team velocity.
  ONLY activated by command: `/impl-sprint`. Use `--create`, `--refine`, or `--score` to set mode.
  NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine|--score"
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

## Three Modes

### Mode 1: Create (`--create`)

Generate a sprint execution plan from the prioritized backlog and design artifacts.

| Input | Required | Source |
|-------|----------|--------|
| Backlog (final) | Yes | `sdlc/req/final/backlog-final.md` or user-specified path |
| User stories (final) | Yes | `sdlc/req/final/userstories-final.md` or user-specified path |
| DoR/DoD (final) | Yes | `sdlc/req/final/dor-dod-final.md` or user-specified path |
| Architecture (final) | No | `sdlc/design/final/architecture-final.md` — component structure for task decomposition |
| API (final) | No | `sdlc/design/final/api-final.md` — endpoint details for implementation tasks |
| Database (final) | No | `sdlc/design/final/database-final.md` — table details for migration tasks |
| Test cases (final) | No | `sdlc/test/final/test-cases-final.md` — test cases to include as test tasks |
| Charter (final) | No | `sdlc/init/final/charter-final.md` — team structure, timeline constraints |
| Epics (final) | No | `sdlc/req/final/epics-final.md` — epic grouping for sprint themes |

### Mode 2: Refine (`--refine`)

Improve existing sprint plan based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing sprint plan draft | Yes | `sdlc/impl/draft/sprint-plan-draft.md` or `sdlc/impl/draft/sprint-plan-v{N}.md` |
| Review report / feedback | Yes | User provides directly or as `sdlc/impl/input/review-report.md` |

### Mode 3: Score (`--score`)

Evaluate artifact quality with a detailed scoreboard.

| Input | Required | Source |
|-------|----------|--------|
| Artifact to score | Yes | `sdlc/impl/draft/sprint-plan-draft.md` or latest `sprint-plan-v{N}.md` or `sdlc/impl/final/sprint-plan-final.md`, or user-specified path |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `sprint-plan-draft.md` | `sdlc/impl/draft/` |
| Refine | `sprint-plan-v{N}.md` | `sdlc/impl/draft/` (N = next version number) |
| Score | `sprint-plan-scoreboard.md` | `sdlc/impl/draft/` |

When user is satisfied -> they copy from `sdlc/impl/draft/` to `sdlc/impl/final/sprint-plan-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User passes `--refine` argument → **Mode 2 (Refine)**
- User passes `--score` argument → **Mode 3 (Score)**
- User passes `--create` argument → **Mode 1 (Create)**
- No argument specified AND existing draft exists in `sdlc/impl/draft/` → Ask: "A draft already exists. Use `--create` to start fresh or `--refine` to improve it."
- No argument specified AND no draft exists → **Mode 1 (Create)**

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
9. `skills/shared/knowledge/scoring-guide.md` -- scoring methodology (Mode 3 only)
10. `skills/shared/rules/scoring-rules.md` -- scoring output rules (Mode 3 only)
11. `skills/shared/templates/scoreboard-output-template.md` -- scoreboard format (Mode 3 only)

### Step 3: Resolve Input

**File Type Conversion** (applies to all file inputs):

Before reading any input file, check its extension:
- `.md` → Read directly, no conversion needed
- `.pdf` → Run `/read-pdf <path> sdlc/impl/input/` → read the converted .md
- `.docx` / `.doc` → Run `/read-word <path> sdlc/impl/input/` → read the converted .md
- `.xlsx` / `.xls` → Run `/read-excel <path> sdlc/impl/input/` → read the converted .md
- `.pptx` / `.ppt` → Run `/read-ppt <path> sdlc/impl/input/` → read the converted .md

Converted files are saved to `sdlc/impl/input/`. If a converted .md already exists and is newer than the source, skip conversion.

Note: Files auto-resolved from `sdlc/` pipeline are always .md and skip conversion.

**Mode 1 (Create):**

```
For backlog input (required):
1. Exists in sdlc/req/final/backlog-final.md?              -> YES -> read it, copy to sdlc/impl/input/ -> DONE
2. User specified a different path?                         -> YES -> read it, convert if needed, copy to sdlc/impl/input/ -> DONE
3. Exists in sdlc/impl/input/backlog-final.md?              -> YES -> read it -> DONE
4. Not found? -> Ask: "No backlog found. Run /req-backlog first."

For userstories input (required):
1. Exists in sdlc/req/final/userstories-final.md?          -> YES -> read it, copy to sdlc/impl/input/ -> DONE
2. User specified a different path?                         -> YES -> read it, convert if needed, copy to sdlc/impl/input/ -> DONE
3. Exists in sdlc/impl/input/userstories-final.md?          -> YES -> read it -> DONE
4. Not found? -> Ask: "No user stories found. Run /req-userstory first."

For dor-dod input (required):
1. Exists in sdlc/req/final/dor-dod-final.md?              -> YES -> read it, copy to sdlc/impl/input/ -> DONE
2. User specified a different path?                         -> YES -> read it, convert if needed, copy to sdlc/impl/input/ -> DONE
3. Exists in sdlc/impl/input/dor-dod-final.md?              -> YES -> read it -> DONE
4. Not found? -> Ask: "No DoR/DoD found. Run /req-trace first."

For architecture (optional):
1. Exists in sdlc/design/final/architecture-final.md?      -> YES -> read it, copy to sdlc/impl/input/ -> DONE
2. User specified a different path?                         -> YES -> read it, convert if needed, copy to sdlc/impl/input/ -> DONE
3. Exists in sdlc/impl/input/architecture-final.md?         -> YES -> read it -> DONE
4. Not found? -> Proceed without architecture.

For API (optional):
1. Exists in sdlc/design/final/api-final.md?               -> YES -> read it, copy to sdlc/impl/input/ -> DONE
2. User specified a different path?                         -> YES -> read it, convert if needed, copy to sdlc/impl/input/ -> DONE
3. Exists in sdlc/impl/input/api-final.md?                  -> YES -> read it -> DONE
4. Not found? -> Proceed without API design.

For database (optional):
1. Exists in sdlc/design/final/database-final.md?          -> YES -> read it, copy to sdlc/impl/input/ -> DONE
2. User specified a different path?                         -> YES -> read it, convert if needed, copy to sdlc/impl/input/ -> DONE
3. Exists in sdlc/impl/input/database-final.md?             -> YES -> read it -> DONE
4. Not found? -> Proceed without database design.

For test cases (optional):
1. Exists in sdlc/test/final/test-cases-final.md?          -> YES -> read it, copy to sdlc/impl/input/ -> DONE
2. User specified a different path?                         -> YES -> read it, convert if needed, copy to sdlc/impl/input/ -> DONE
3. Exists in sdlc/impl/input/test-cases-final.md?           -> YES -> read it -> DONE
4. Not found? -> Proceed without test cases.

For charter (optional):
1. Exists in sdlc/init/final/charter-final.md?             -> YES -> read it, copy to sdlc/impl/input/ -> DONE
2. User specified a different path?                         -> YES -> read it, convert if needed, copy to sdlc/impl/input/ -> DONE
3. Exists in sdlc/impl/input/charter-final.md?              -> YES -> read it -> DONE
4. Not found? -> Proceed without charter.

For epics (optional):
1. Exists in sdlc/req/final/epics-final.md?                -> YES -> read it, copy to sdlc/impl/input/ -> DONE
2. User specified a different path?                         -> YES -> read it, convert if needed, copy to sdlc/impl/input/ -> DONE
3. Exists in sdlc/impl/input/epics-final.md?                -> YES -> read it -> DONE
4. Not found? -> Proceed without epics.
```

**Mode 2 (Refine):** Standard refine input resolution.

**Mode 3 (Score):**

```
For artifact to score (required):
1. User specified a path?                                     → Read it → DONE
2. Exists in sdlc/impl/final/sprint-plan-final.md?             → Read it → DONE
3. Exists as sdlc/impl/draft/sprint-plan-v{N}.md (latest N)?   → Read it → DONE
4. Exists as sdlc/impl/draft/sprint-plan-draft.md?             → Read it → DONE
5. Not found? → Ask: "Provide the path to the artifact to score."
```

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

### Step 5: Validate

Validate output against:
- Implementation phase rules (IMP-01 through IMP-10)
- Sprint plan output rules (SPR-01 through SPR-14)
- Project-wide output rules

Flag any violations and fix before output.

**Mode 3 (Score) — additional checks:**
- All 5 dimensions scored with evidence (SCR-01, SCR-02)
- Integer scores 1-5 (SCR-03)
- Issues linked to dimensions and sections (SCR-04, SCR-05)
- Recommendations are actionable, 3-7 count (SCR-06, SCR-07)
- Scoring used this skill's own rules/templates as context (SCR-08)
- Rules compliance section present (SCR-10)

### Step 6: Readiness Assessment

Count confidence markers across all sprint plan items:
- Sprint goals, capacity estimates, assignments, task breakdowns
- Calculate CONFIRMED / ASSUMED / UNCLEAR percentages
- Determine verdict: Ready / Partially Ready / Not Ready

### Step 7: Output and Next Steps

Tell the user:
> **Sprint plan {created/refined}!**
> - Output: `sdlc/impl/draft/sprint-plan-{version}.md`
> - Readiness: {verdict}
> - Sprints planned: {N} detailed, {M} high-level
> - Total tasks: {N} across {M} stories
> - Capacity utilization: {avg}% average across sprints
> - DoR issues: {N} stories flagged
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/impl-sprint --refine`
> - When satisfied, copy to `sdlc/impl/final/sprint-plan-final.md`
> - Then run `/impl-codegen` to generate implementation code from the sprint plan

**Mode 3 (Score):**

- Write to `sdlc/impl/draft/sprint-plan-scoreboard.md`

Tell the user:
> **Scoreboard complete!**
> - Output: `sdlc/impl/draft/sprint-plan-scoreboard.md`
> - Average: {avg}/5 — {verdict}
> - Lowest: {dimension} ({score}/5)
> - Issues: {N} (HIGH: {H}, MED: {M}, LOW: {L})
>
> **Next steps:**
> - Run `/impl-sprint --refine` to address issues
> - Or run `/skill-evolution --analyze impl/sprint` to improve the skill definition itself

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
