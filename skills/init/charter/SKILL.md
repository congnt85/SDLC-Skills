---
name: init-charter
description: >
  Create or refine a project charter from a vague idea or existing context.
  Guides through vision statement, problem analysis, business justification,
  scope boundaries, milestones, budget estimation, and team structure.
  Produces a structured project charter document.
  ONLY activated by command: `/init-charter`. Use `--create`, `--refine`, or `--score` to set mode.
  NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine|--score [project idea or input file]"
version: "1.0"
category: sdlc
phase: init
prev_phase: null
next_phase: init-scope
---

# Project Charter Skill

## Purpose

Create or refine a structured project charter (`charter-draft.md`) from a vague idea.
The charter is the foundation artifact — all other SDLC skills depend on it.

---

## Three Modes

### Mode 1: Create (`--create`)

Generate a new charter from user input.

| Input | Required | Source |
|-------|----------|--------|
| Project idea / description | ✅ | User provides directly or as file in `sdlc/init/input/` |
| Known constraints | No | Budget, timeline, team, tech mandates |
| Existing context | No | Any prior documents the user has |

### Mode 2: Refine (`--refine`)

Improve an existing charter based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing charter draft | ✅ | `sdlc/init/draft/charter-draft.md` or `sdlc/init/draft/charter-v{N}.md` |
| Review report / feedback | ✅ | User provides directly or as `sdlc/init/input/review-report.md` |
| Additional details | No | New information the user wants to add |

### Mode 3: Score (`--score`)

Evaluate artifact quality with a detailed scoreboard.

| Input | Required | Source |
|-------|----------|--------|
| Artifact to score | Yes | `sdlc/init/draft/charter-draft.md` or latest `charter-v{N}.md` or `sdlc/init/final/charter-final.md`, or user-specified path |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `charter-draft.md` | `sdlc/init/draft/` |
| Refine | `charter-v{N}.md` | `sdlc/init/draft/` (N = next version number) |
| Score | `charter-scoreboard.md` | `sdlc/init/draft/` |

When user is satisfied → they copy from `sdlc/init/draft/` to `sdlc/init/final/charter-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User passes `--score` argument → **Mode 3 (Score)**
- User passes `--refine` argument → **Mode 2 (Refine)**
- User passes `--create` argument → **Mode 1 (Create)**
- No argument specified AND existing draft exists in `sdlc/init/draft/` → Ask: "A draft already exists. Use `--create` to start fresh or `--refine` to improve it."
- No argument specified AND no draft exists → **Mode 1 (Create)**

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md` — document formatting standards
2. `skills/shared/rules/quality-rules.md` — confidence marking, readiness assessment
3. `skills/shared/rules/output-rules.md` — versioning, input resolution, diff summary
4. `init/shared/rules/init-rules.md` — initiation phase rules
5. `init/shared/templates/charter/charter-template.md` — charter structure
6. `init/shared/templates/charter/vision-template.md` — vision formats
7. `init/charter/knowledge/vision-workshop.md` — vision creation techniques
8. `init/charter/rules/output-rules.md` — charter-specific output rules
9. `init/charter/templates/output-template.md` — expected output structure

If budget estimation is needed:
10. `skills/shared/knowledge/estimation-methods.md` — estimation techniques

11. `skills/shared/knowledge/scoring-guide.md` -- scoring methodology (Mode 3 only)
12. `skills/shared/rules/scoring-rules.md` -- scoring output rules (Mode 3 only)
13. `skills/shared/templates/scoreboard-output-template.md` -- scoreboard format (Mode 3 only)

### Step 3: Resolve Input

**File Type Conversion** (applies to all file inputs):

Before reading any input file, check its extension:
- `.md` → Read directly, no conversion needed
- `.pdf` → Run `/read-pdf <path> sdlc/init/input/` → read the converted .md
- `.docx` / `.doc` → Run `/read-word <path> sdlc/init/input/` → read the converted .md
- `.xlsx` / `.xls` → Run `/read-excel <path> sdlc/init/input/` → read the converted .md
- `.pptx` / `.ppt` → Run `/read-ppt <path> sdlc/init/input/` → read the converted .md

Converted files are saved to `sdlc/init/input/`. If a converted .md already exists and is newer than the source, skip conversion.

Note: Files auto-resolved from `sdlc/` pipeline are always .md and skip conversion.

**Mode 1 (Create):**

```
1. User provided project idea as argument? → Use it, save to sdlc/init/input/
2. File exists in sdlc/init/input/ (e.g., sdlc/init/input/vague-idea.md)? → Read it
3. Nothing found? → Ask user: "What's your project idea? A sentence or paragraph is fine."
```

**Mode 2 (Refine):**

```
For charter draft:
1. Exists in sdlc/init/draft/ (latest version)? → Read it → DONE
2. User specified a different path?              → Read it, copy to sdlc/init/input/ → DONE
3. Exists in sdlc/init/input/?                   → Read it → DONE
4. Not found? → FAIL: "No existing charter found. Run /init-charter first."

For review report:
1. User provided feedback directly in message? → Save to sdlc/init/input/review-report.md
2. User specified path? → Read it, copy to sdlc/init/input/
3. Exists in sdlc/init/input/review-report.md? → Read it
4. Not found? → Ask: "What feedback do you have on the current charter?"
```

**Mode 3 (Score):**

```
For artifact to score (required):
1. User specified a path?                                     → Read it → DONE
2. Exists in sdlc/init/final/charter-final.md?                → Read it → DONE
3. Exists as sdlc/init/draft/charter-v{N}.md (latest N)?      → Read it → DONE
4. Exists as sdlc/init/draft/charter-draft.md?                → Read it → DONE
5. Not found? → Ask: "Provide the path to the artifact to score."
```

### Step 4: Generate (Mode-specific)

**Mode 1 — Create:**

Work through the charter **section by section, incrementally**:

1. **Vision Statement** — Draft using Moore template + elevator pitch + anti-vision
   - Present to user, ask for feedback
   - Refine if needed before continuing

2. **Problem Statement** — Current state / future state gap analysis
   - Ask: "What problem does this solve? What happens today without it?"

3. **Business Justification** — Benefits table + OKR-based success metrics
   - Push for SMART metrics (reject vague goals)
   - Ask: "How will you measure success? What are the key results?"

4. **High-Level Scope** — In-scope / out-of-scope table
   - Ask: "What features are definitely in? What's explicitly out?"

5. **Key Milestones** — Timeline with dates
   - If dates unknown, use relative timing (Sprint 1, Month 2, etc.)

6. **Budget Estimate** — Use three-point estimation (PERT) from `estimation-methods.md`
   - If budget unknown, mark as [TBD] and flag as risk

7. **Team Structure** — Roles and allocations
   - Ask: "Who's on the team? What roles are filled vs needed?"

8. **Assumptions, Constraints, Dependencies**
   - Every assumption gets an "Impact if Wrong" and "Validation Plan"
   - Constraints get a "Negotiable?" flag

For each section:
- Apply confidence markers (✅ CONFIRMED / 🔶 ASSUMED / ❓ UNCLEAR)
- Create Q&A entries for ASSUMED and UNCLEAR items
- Present section to user before moving to next

**Mode 2 — Refine:**

1. Read existing charter draft (baseline)
2. Read review report / user feedback
3. Run Quality Scorecard analysis (completeness, clarity, quantification, etc.)
4. Present scorecard to user: "Here's what I found in the current draft..."
5. Apply improvements:
   - Address user feedback point by point
   - Resolve Q&A entries from previous version
   - Upgrade confidence levels where possible (🔶→✅, ❓→🔶)
   - Proactively suggest improvements for weak areas
6. Tag all changes: `[UPDATED]` for modified items, `[NEW]` for additions
7. Preserve CONFIRMED items unless user explicitly contradicts them
8. Write improved version to `sdlc/init/draft/charter-v{N}.md`

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

### Step 5: Validate Output

Check against rules:
- Every item has a confidence marker (CR-01)
- CONFIRMED items cite source (CR-02)
- ASSUMED items have reasoning + Q&A ref (CR-03)
- UNCLEAR items have Q&A ref + impact (CR-04)
- Success metrics are SMART (INIT-02)
- Quality attributes are quantified (INIT-04)
- No technical decisions made (INIT-03)
- Approval section present (INIT-07)
- Cross-references consistent (INIT-08)

**Mode 3 (Score) — additional checks:**
- All 5 dimensions scored with evidence (SCR-01, SCR-02)
- Integer scores 1-5 (SCR-03)
- Issues linked to dimensions and sections (SCR-04, SCR-05)
- Recommendations are actionable, 3-7 count (SCR-06, SCR-07)
- Scoring used this skill's own rules/templates as context (SCR-08)
- Rules compliance section present (SCR-10)

### Step 6: Readiness Assessment

Generate assessment per `skills/shared/templates/readiness-assessment.md`:
- Count items by confidence level
- Calculate readiness verdict
- In refine mode: compare with previous version

### Step 7: Output

- **Create mode**: Write to `sdlc/init/draft/charter-draft.md`
- **Refine mode**: Write to `sdlc/init/draft/charter-v{N}.md`, include Change Log and Diff Summary

**Mode 3 (Score):**

- Write to `sdlc/init/draft/charter-scoreboard.md`

Tell the user:
> **Scoreboard complete!**
> - Output: `sdlc/init/draft/charter-scoreboard.md`
> - Average: {avg}/5 — {verdict}
> - Lowest: {dimension} ({score}/5)
> - Issues: {N} (HIGH: {H}, MED: {M}, LOW: {L})
>
> **Next steps:**
> - Run `/init-charter --refine` to address issues
> - Or run `/skill-evolution --analyze init/charter` to improve the skill definition itself

Tell the user:
> **Charter {created/refined}!**
> - Output: `sdlc/init/draft/charter-{version}.md`
> - Readiness: {verdict}
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/init-charter --refine`
> - When satisfied, copy to `sdlc/init/final/charter-final.md`
> - Then run `/init-scope` to define detailed project scope

---

## Scope Rules

### This skill DOES:
- Create/refine project charter documents
- Ask clarifying questions about project vision, scope, budget, team
- Push for SMART metrics and quantified quality attributes
- Identify and flag risks related to charter content
- Apply confidence marking to every item

### This skill does NOT:
- Make technology decisions (belongs to `design/` phase)
- Write user stories (belongs to `req/` phase)
- Define detailed personas (belongs to `init/scope` skill)
- Perform feasibility analysis (deferred skill)
- Perform stakeholder analysis (deferred skill)
- Create the project — it documents the project plan
