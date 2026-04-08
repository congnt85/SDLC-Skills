---
name: req-epic
description: >
  Create or refine epics (theme-level requirement groupings) from charter
  objectives and scope features. Maps business objectives to deliverable
  work themes with feature assignments, personas, and success criteria.
  ONLY activated by commands: `/req-epic` (create) or `/req-epic-refine` (refine).
  NEVER auto-trigger based on keywords.
argument-hint: "[path to charter or scope file (md/pdf/docx/xlsx/pptx)]"
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

## Two Modes

### Mode 1: Create (`/req-epic`)

Generate epics from charter objectives and scope features.

| Input | Required | Source |
|-------|----------|--------|
| Charter (final) | Yes | `sdlc/init/final/charter-final.md` or user-specified path |
| Scope (final) | Yes | `sdlc/init/final/scope-final.md` or user-specified path |
| Risk register (final) | No | `sdlc/init/final/risk-register-final.md` — high risks may warrant spike epics |

### Mode 2: Refine (`/req-epic-refine`)

Improve existing epics based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing epic draft | Yes | `sdlc/req/draft/epics-draft.md` or `sdlc/req/draft/epics-v{N}.md` |
| Review report / feedback | Yes | User provides directly or as `sdlc/req/input/review-report.md` |
| Additional details | No | New information the user wants to add |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `epics-draft.md` | `sdlc/req/draft/` |
| Refine | `epics-v{N}.md` | `sdlc/req/draft/` (N = next version number) |

When user is satisfied -> they copy from `sdlc/req/draft/` to `sdlc/req/final/epics-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User runs `/req-epic-refine` AND existing draft exists in `sdlc/req/draft/` -> **Mode 2 (Refine)**
- User runs `/req-epic` -> **Mode 1 (Create)**
- User runs `/req-epic` but draft already exists -> Ask: "An epic draft already exists. Create new (overwrite) or refine existing?"

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
For charter input (required):
1. User specified path?                        -> YES -> read it, copy to sdlc/req/input/ -> DONE
2. Exists in sdlc/req/input/charter-final.md?  -> YES -> read it -> DONE
3. Exists in sdlc/init/final/charter-final.md?  -> YES -> read it, copy to sdlc/req/input/ -> DONE
4. Not found? -> Ask: "No charter found. Please provide a path or run /init-charter first."

For scope input (required):
1. User specified path?                        -> YES -> read it, copy to sdlc/req/input/ -> DONE
2. Exists in sdlc/req/input/scope-final.md?    -> YES -> read it -> DONE
3. Exists in sdlc/init/final/scope-final.md?    -> YES -> read it, copy to sdlc/req/input/ -> DONE
4. Not found? -> Ask: "No scope found. Please provide a path or run /init-scope first."

For risk register (optional):
1. User specified path?                        -> YES -> read it, copy to sdlc/req/input/ -> DONE
2. Exists in sdlc/req/input/risk-register-final.md? -> YES -> read it -> DONE
3. Exists in sdlc/init/final/risk-register-final.md? -> YES -> read it, copy to sdlc/req/input/ -> DONE
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

### Step 6: Readiness Assessment

Generate assessment per `skills/shared/templates/readiness-assessment.md`:
- Count items by confidence level (each epic is 1 item)
- Calculate readiness verdict
- In refine mode: compare with previous version

### Step 7: Output

- **Create mode**: Write to `sdlc/req/draft/epics-draft.md`
- **Refine mode**: Write to `sdlc/req/draft/epics-v{N}.md`, include Change Log and Diff Summary

Tell the user:
> **Epics {created/refined}!**
> - Output: `sdlc/req/draft/epics-{version}.md`
> - Readiness: {verdict}
> - Epics: {total} (Must Have: {N}, Should Have: {N}, Could Have: {N})
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/req-epic-refine`
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
