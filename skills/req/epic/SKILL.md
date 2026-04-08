---
name: req-epic
description: >
  Create or refine epics (theme-level requirement groupings) from charter
  objectives and scope features. Maps business objectives to deliverable
  work themes with feature assignments, personas, and success criteria.
  ONLY activated by command: `/req-epic`. Use `--create`, `--refine`, or `--score` to set mode.
  NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine|--score"
version: "1.0"
category: sdlc
phase: req
prev_phase: init-risk
next_phase: req-userstory
---

# Epic Definition Skill

## Purpose

Create or refine an epic document (`sdlc/req/draft/epics-draft.md`) that maps charter objectives to deliverable work themes. Epics group related scope features into coherent themes that can be planned, tracked, and delivered as units.

Epics bridge "what we want to achieve" (charter objectives) and "what we need to build as stories" (user stories).

---

## Three Modes

### Mode 1: Create (`--create`)

Generate epics from charter objectives and scope features.

| Input | Required | Source |
|-------|----------|--------|
| Charter (final) | Yes | `sdlc/init/final/charter-final.md` or user-specified path |
| Scope (final) | Yes | `sdlc/init/final/scope-final.md` or user-specified path |
| Risk register (final) | No | `sdlc/init/final/risk-register-final.md` — high risks may warrant spike epics |

### Mode 2: Refine (`--refine`)

Improve existing epics based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing epic draft | Yes | `sdlc/req/draft/epics-draft.md` or `sdlc/req/draft/epics-v{N}.md` |
| Review report / feedback | Yes | User provides directly or as `sdlc/req/input/review-report.md` |
| Additional details | No | New information the user wants to add |

### Mode 3: Score (`--score`)

Evaluate artifact quality with a detailed scoreboard.

| Input | Required | Source |
|-------|----------|--------|
| Artifact to score | Yes | `sdlc/req/draft/epics-draft.md` or latest `epics-v{N}.md` or `sdlc/req/final/epics-final.md`, or user-specified path |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `epics-draft.md` | `sdlc/req/draft/` |
| Refine | `epics-v{N}.md` | `sdlc/req/draft/` (N = next version number) |
| Score | `epics-scoreboard.md` | `sdlc/req/draft/` |

When user is satisfied -> they copy from `sdlc/req/draft/` to `sdlc/req/final/epics-final.md`.

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

1. `skills/shared/rules/doc-standards.md` -- document formatting standards
2. `skills/shared/rules/quality-rules.md` -- confidence marking, readiness assessment
3. `skills/shared/rules/output-rules.md` -- versioning, input resolution, diff summary
4. `req/shared/rules/req-rules.md` -- requirements phase rules
5. `req/shared/templates/epic/epic-template.md` -- epic card format
6. `req/epic/knowledge/epic-decomposition-guide.md` -- epic creation techniques
7. `req/epic/rules/output-rules.md` -- epic-specific output rules
8. `req/epic/templates/output-template.md` -- expected output structure
9. `skills/shared/knowledge/scoring-guide.md` -- scoring methodology (Mode 3 only)
10. `skills/shared/rules/scoring-rules.md` -- scoring output rules (Mode 3 only)
11. `skills/shared/templates/scoreboard-output-template.md` -- scoreboard format (Mode 3 only)

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
For charter input (required):
1. Exists in sdlc/init/final/charter-final.md?  -> YES -> read it -> DONE
2. User specified a different path?              -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/req/input/charter-final.md?    -> YES -> read it -> DONE
4. Not found? -> Ask: "No charter found. Run /init-charter first or provide a path."

For scope input (required):
1. Exists in sdlc/init/final/scope-final.md?    -> YES -> read it -> DONE
2. User specified a different path?              -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/req/input/scope-final.md?      -> YES -> read it -> DONE
4. Not found? -> Ask: "No scope found. Run /init-scope first or provide a path."

For risk register (optional):
1. Exists in sdlc/init/final/risk-register-final.md? -> YES -> read it -> DONE
2. User specified a different path?              -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/req/input/risk-register-final.md?  -> YES -> read it -> DONE
4. Not found? -> Proceed without risk register.
```

**Mode 2 (Refine):**

```
For epic draft:
1. User specified path?                        -> YES -> read it, copy to sdlc/req/input/ -> DONE
2. Exists in sdlc/req/input/?                  -> YES -> read it -> DONE
3. Exists in sdlc/req/draft/ (latest version)? -> YES -> read it, copy to sdlc/req/input/ -> DONE
4. Not found? -> FAIL: "No existing epics found. Run /req-epic first."

For review report:
1. User provided feedback directly in message? -> Save to sdlc/req/input/review-report.md
2. User specified path?                        -> read it, copy to sdlc/req/input/
3. Exists in sdlc/req/input/review-report.md?  -> read it
4. Not found? -> Ask: "What feedback do you have on the current epics?"
```

**Mode 3 (Score):**

```
For artifact to score (required):
1. User specified a path?                                     → Read it → DONE
2. Exists in sdlc/req/final/epics-final.md?                   → Read it → DONE
3. Exists as sdlc/req/draft/epics-v{N}.md (latest N)?         → Read it → DONE
4. Exists as sdlc/req/draft/epics-draft.md?                   → Read it → DONE
5. Not found? → Ask: "Provide the path to the artifact to score."
```

### Step 4: Generate (Mode-specific)

**Mode 1 -- Create:**

Work through the epic document **section by section, incrementally**:

1. **Epic Identification** -- Map charter objectives to epics
   - For each charter objective, create at least one epic
   - Group related scope features (SCP-xxx) into the same epic
   - Identify cross-cutting concerns (auth, security, performance, infrastructure) as separate epics tagged `[CROSS-CUTTING]`
   - If risk register is available, check for high risks that need spike epics
   - Present proposed epic structure to user before detailing

2. **Epic Details** -- Fill out epic cards
   - For each epic, complete the full epic card (per template)
   - Assign all scope features to exactly one epic (verify no orphans)
   - Estimate story count and total points per epic
   - Identify inter-epic dependencies

3. **Feature-to-Epic Map** -- Verify complete coverage
   - List every scope feature and its assigned epic
   - Flag any scope features not assigned to an epic
   - Flag any epics with no scope features (unless cross-cutting)

4. **Epic Dependency Map** -- Visualize dependencies
   - Generate Mermaid diagram showing epic dependencies
   - Identify critical path (longest dependency chain)

For each section:
- Apply confidence markers (CONFIRMED / ASSUMED / UNCLEAR)
- Inherit confidence from charter/scope where applicable
- Create Q&A entries for ASSUMED and UNCLEAR items
- Present section to user before moving to next

**Mode 2 -- Refine:**

1. Read existing epic draft (baseline)
2. Read review report / user feedback
3. Run Quality Scorecard analysis
4. Present scorecard to user
5. Apply improvements:
   - Address user feedback point by point
   - Resolve Q&A entries from previous version
   - Upgrade confidence levels where possible
   - Improve epic descriptions for clarity
   - Rebalance feature assignments if needed
6. Tag all changes: `[UPDATED]` for modified items, `[NEW]` for additions
7. Preserve CONFIRMED items unless user explicitly contradicts them
8. Write improved version to `sdlc/req/draft/epics-v{N}.md`

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
- Every epic traces to a charter objective (EPC-01, REQ-05)
- Every scope feature appears in exactly one epic (EPC-02)
- Epic IDs are sequential (EPC-03)
- Cross-cutting epics are tagged (EPC-05)
- At least 3 epics (EPC-06)
- No implementation details (REQ-01)
- Approval section present (INIT-07)
- Cross-references consistent (REQ-10)

**Mode 3 (Score) — additional checks:**
- All 5 dimensions scored with evidence (SCR-01, SCR-02)
- Integer scores 1-5 (SCR-03)
- Issues linked to dimensions and sections (SCR-04, SCR-05)
- Recommendations are actionable, 3-7 count (SCR-06, SCR-07)
- Scoring used this skill's own rules/templates as context (SCR-08)
- Rules compliance section present (SCR-10)

### Step 6: Readiness Assessment

Generate assessment per `skills/shared/templates/readiness-assessment.md`:
- Count items by confidence level (each epic is 1 item)
- Calculate readiness verdict
- In refine mode: compare with previous version

### Step 7: Output

- **Create mode**: Write to `sdlc/req/draft/epics-draft.md`
- **Refine mode**: Write to `sdlc/req/draft/epics-v{N}.md`, include Change Log and Diff Summary

**Mode 3 (Score):**

- Write to `sdlc/req/draft/epics-scoreboard.md`

Tell the user:
> **Scoreboard complete!**
> - Output: `sdlc/req/draft/epics-scoreboard.md`
> - Average: {avg}/5 — {verdict}
> - Lowest: {dimension} ({score}/5)
> - Issues: {N} (HIGH: {H}, MED: {M}, LOW: {L})
>
> **Next steps:**
> - Run `/req-epic --refine` to address issues
> - Or run `/skill-evolution --analyze req/epic` to improve the skill definition itself

Tell the user:
> **Epics {created/refined}!**
> - Output: `sdlc/req/draft/epics-{version}.md`
> - Readiness: {verdict}
> - Epics: {total} (Must Have: {N}, Should Have: {N}, Could Have: {N})
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/req-epic --refine`
> - When satisfied, copy to `sdlc/req/final/epics-final.md`
> - Then run `/req-userstory` to write user stories for each epic

---

## Scope Rules

### This skill DOES:
- Map charter objectives to epic themes
- Assign scope features to epics
- Identify cross-cutting concerns as separate epics
- Create spike epics for high-risk items
- Estimate epic size (story count, point range)
- Visualize epic dependencies

### This skill does NOT:
- Write user stories (belongs to `req/userstory` skill)
- Prioritize the backlog (belongs to `req/backlog` skill)
- Build traceability matrix (belongs to `req/traceability` skill)
- Make technology decisions (belongs to `design/` phase)
- Define sprint plans (belongs to `impl/` phase)
- Modify charter or scope -- it reads them as input
