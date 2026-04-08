---
name: req-trace
description: >
  Create or refine a requirements traceability matrix and Definition of Ready/Done
  from all requirements and initiation artifacts. Verifies complete coverage from
  charter objectives through epics, features, stories, and acceptance criteria.
  ONLY activated by command: `/req-trace`. Use `--create` or `--refine` to set mode.
  NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine"
version: "1.0"
category: sdlc
phase: req
prev_phase: req-backlog
next_phase: design-stack
---

# Requirements Traceability Skill

## Purpose

Create or refine a requirements traceability matrix (`sdlc/req/draft/traceability-draft.md`) and Definition of Ready/Done (`sdlc/req/draft/dor-dod-draft.md`). The traceability matrix verifies that every charter objective is covered by epics, every scope feature has stories, and no requirements fall through the cracks.

This is the last skill in the requirements phase. It produces the quality gate artifacts needed before design begins.

---

## Two Modes

### Mode 1: Create (`--create`)

Generate traceability matrix and DoR/DoD from all artifacts.

| Input | Required | Source |
|-------|----------|--------|
| Epics (final) | Yes | `sdlc/req/final/epics-final.md` |
| User stories (final) | Yes | `sdlc/req/final/userstories-final.md` |
| Backlog (final) | Yes | `sdlc/req/final/backlog-final.md` |
| Charter (final) | Yes | `sdlc/init/final/charter-final.md` |
| Scope (final) | Yes | `sdlc/init/final/scope-final.md` |
| Risk register (final) | No | `sdlc/init/final/risk-register-final.md` |

### Mode 2: Refine (`--refine`)

Improve existing traceability and DoR/DoD based on feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing traceability draft | Yes | `sdlc/req/draft/traceability-draft.md` or versioned |
| Existing DoR/DoD draft | Yes | `sdlc/req/draft/dor-dod-draft.md` or versioned |
| Review report / feedback | Yes | User provides directly or as `sdlc/req/input/review-report.md` |

---

## Output

| Mode | Output Files | Location |
|------|-------------|----------|
| Create | `traceability-draft.md` + `dor-dod-draft.md` | `sdlc/req/draft/` |
| Refine | `traceability-v{N}.md` + `dor-dod-v{N}.md` | `sdlc/req/draft/` |

When user is satisfied -> they copy both files to `sdlc/req/final/`:
- `sdlc/req/final/traceability-final.md`
- `sdlc/req/final/dor-dod-final.md`

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
4. `skills/shared/knowledge/agile-scrum-guide.md` -- DoR/DoD reference
5. `req/shared/rules/req-rules.md`
6. `req/traceability/knowledge/traceability-techniques.md`
7. `req/traceability/rules/output-rules.md`
8. `req/traceability/templates/output-template.md`

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

This skill has the most inputs (5-6 files). Resolve each independently:

```
For epics input (required):
1. Exists in sdlc/req/final/epics-final.md?    -> YES -> read it -> DONE
2. User specified a different path?              -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/req/input/epics-final.md?      -> YES -> read it -> DONE
4. Not found? -> Ask: "No epics found. Run /req-epic first or provide a path."

For userstories input (required):
1. Exists in sdlc/req/final/userstories-final.md? -> YES -> read it -> DONE
2. User specified a different path?              -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/req/input/userstories-final.md?  -> YES -> read it -> DONE
4. Not found? -> Ask: "No user stories found. Run /req-userstory first or provide a path."

For backlog input (required):
1. Exists in sdlc/req/final/backlog-final.md?  -> YES -> read it -> DONE
2. User specified a different path?              -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/req/input/backlog-final.md?    -> YES -> read it -> DONE
4. Not found? -> Ask: "No backlog found. Run /req-backlog first or provide a path."

For charter input (required):
1. Exists in sdlc/init/final/charter-final.md?  -> YES -> read it -> DONE
2. User specified a different path?              -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/req/input/charter-final.md?    -> YES -> read it -> DONE
4. Not found? -> FAIL: "No charter found. Run /init-charter first or provide a path."

For scope input (required):
1. Exists in sdlc/init/final/scope-final.md?    -> YES -> read it -> DONE
2. User specified a different path?              -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/req/input/scope-final.md?      -> YES -> read it -> DONE
4. Not found? -> FAIL: "No scope found. Run /init-scope first or provide a path."

For risk register (optional):
1. Exists in sdlc/init/final/risk-register-final.md? -> YES -> read it -> DONE
2. User specified a different path?              -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/req/input/risk-register-final.md?  -> YES -> read it -> DONE
4. Not found? -> Proceed without risk-to-story tracing.
```

**Mode 2 (Refine):** Resolve both draft files (traceability + DoR/DoD) plus review report.

### Step 4: Generate (Mode-specific)

**Mode 1 -- Create:**

**Part A: Traceability Matrix**

1. **Forward Traceability** (Objective -> Delivery)
   - For each charter objective, list the epic(s) that deliver it
   - For each epic, list the stories that implement it
   - Sum story points per objective
   - Calculate coverage: does every objective have at least one Must Have story?

2. **Backward Traceability** (Story -> Source)
   - For each story, trace back: story -> feature (SCP-xxx) -> epic (EPIC-xxx) -> objective
   - Include risk source for spike stories
   - Identify stories that don't trace back to any objective (orphans)

3. **Feature Coverage** (from scope)
   - For each scope feature (SCP-xxx), list assigned stories
   - Calculate coverage percentage
   - Flag features with 0 stories as gaps
   - Note features with only Could Have stories (weak coverage)

4. **Gap Analysis**
   - Objectives without epics
   - Objectives without Must Have stories
   - Features without stories
   - Epics without stories
   - Stories without acceptance criteria
   - Personas without Must Have stories

5. **Coverage Summary**
   - Total objectives covered
   - Total features covered
   - Total epics with stories
   - Total stories with AC
   - Overall coverage percentage

**Part B: Definition of Ready (DoR)**

6. **DoR Criteria** -- Define what makes a story ready for sprint planning
   - Standard criteria (story format, AC, estimates, dependencies)
   - Project-specific criteria (from charter constraints, team agreements)
   - Each criterion gets a DOR-xx ID and confidence marker

**Part C: Definition of Done (DoD)**

7. **DoD Criteria** -- Define what makes a story complete
   - Standard criteria (code complete, tests, review, deploy)
   - Project-specific criteria (from quality attributes, compliance needs)
   - Each criterion gets a DOD-xx ID and confidence marker

For all sections:
- Apply confidence markers
- Create Q&A entries for gaps and UNCLEAR items
- Present each section to user before continuing

**Mode 2 -- Refine:**

Standard refine workflow. Re-run gap analysis to check if gaps from v1 have been addressed.

### Step 5-7: Validate, Readiness, Output

Validate both output files against rules. Generate readiness assessment for the combined traceability + DoR/DoD.

Tell the user:
> **Traceability {created/refined}!**
> - Outputs: `sdlc/req/draft/traceability-{version}.md` + `sdlc/req/draft/dor-dod-{version}.md`
> - Readiness: {verdict}
> - Coverage: {pct}% objectives, {pct}% features
> - Gaps found: {N}
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review both outputs and provide feedback via `/req-trace --refine`
> - When satisfied, copy both to `sdlc/req/final/`:
>   - `sdlc/req/final/traceability-final.md`
>   - `sdlc/req/final/dor-dod-final.md`
> - Requirements phase complete! Run `/design-stack` to start design

---

## Scope Rules

### This skill DOES:
- Build forward and backward traceability matrices
- Perform gap analysis (missing coverage)
- Calculate coverage metrics
- Define DoR and DoD criteria
- Verify cross-reference consistency across all artifacts

### This skill does NOT:
- Create or modify epics, stories, or backlog
- Make technology decisions
- Define test strategies (belongs to `test/` phase)
- Plan sprints (belongs to `impl/` phase)
- Modify any source documents -- it reads and verifies them
