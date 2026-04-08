---
name: skill-evolution
description: >
  Analyze quality scorecard results and draft-vs-final diffs to identify
  skill definition gaps, then apply approved improvements to skill files
  (SKILL.md, knowledge, rules, templates). Two modes: --analyze produces
  an evolution analysis report, --apply executes approved changes.
  ONLY activated by command: `/skill-evolution`.
  NEVER auto-trigger based on keywords.
argument-hint: "--analyze|--apply <phase>/<skill>"
version: "1.0"
category: sdlc-utility
---

# Skill Evolution

## Purpose

Close the feedback loop between skill output quality and skill definitions. After a user refines a skill's output and corrects the draft into a final version, this skill analyzes what the target skill got wrong (guided by the quality scorecard) and proposes targeted improvements to the skill's definition files.

Two modes: `--analyze` produces a report with proposed changes; `--apply` executes user-approved changes from the report.

---

## Two Modes

### Mode 1: Analyze (`--analyze`)

Analyze scorecard + draft + final to produce an evolution analysis report.

| Input | Required | Source |
|-------|----------|--------|
| Target skill identifier | Yes | User argument: `<phase>/<skill>` (e.g., `req/epic`) |
| Quality Scorecard | Yes | Extracted from refine output in `sdlc/<phase>/draft/`, or user-specified path |
| Draft version | Yes | `sdlc/<phase>/draft/<topic>-draft.md` or latest `<topic>-v{N}.md`, or user-specified path |
| Final version | Yes | `sdlc/<phase>/final/<topic>-final.md`, or user-specified path |

### Mode 2: Apply (`--apply`)

Apply approved changes from an analysis report to the target skill's files.

| Input | Required | Source |
|-------|----------|--------|
| Target skill identifier | Yes | User argument: `<phase>/<skill>` (e.g., `req/epic`) |
| Analysis report | Yes | Most recent `skills/<phase>/<skill>/evolution/*/analysis.md`, or user-specified path |

---

## Output

| Mode | Output Files | Location |
|------|-------------|----------|
| Analyze | `analysis.md` + `scorecard.md` | `skills/<phase>/<skill>/evolution/<timestamp>/` |
| Apply | `patch-note.md` + modified skill files | `skills/<phase>/<skill>/evolution/<timestamp>/` + skill files |

Timestamp format: `yyyy-mm-dd-hh-mm-ss`

---

## Workflow

### Step 1: Determine Mode

- User passes `--analyze <phase>/<skill>` → **Mode 1 (Analyze)**
- User passes `--apply <phase>/<skill>` → **Mode 2 (Apply)**
- No mode argument → Ask: "Use `--analyze` to create an evolution analysis or `--apply` to execute approved changes."
- No skill identifier → Ask: "Which skill to evolve? Specify as `<phase>/<skill>` (e.g., `req/epic`)."

Validate the target skill exists: check that `skills/<phase>/<skill>/SKILL.md` exists. If not → FAIL: "Skill `<phase>/<skill>` not found."

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md` — document formatting standards
2. `skills/shared/rules/quality-rules.md` — confidence marking, readiness assessment
3. `skills/shared/templates/quality-scorecard.md` — scorecard format understanding
4. `skill-evolution/knowledge/skill-anatomy-guide.md` — what each skill file controls
5. `skill-evolution/knowledge/evolution-analysis-guide.md` — analysis methodology
6. `skill-evolution/rules/output-rules.md` — evolution-specific output rules (EVO-01 through EVO-14)
7. `skill-evolution/templates/analysis-template.md` — analysis report structure (Mode 1)
8. `skill-evolution/templates/patch-note-template.md` — patch note structure (Mode 2)

### Step 3: Resolve Input

**Mode 1 (Analyze):**

```
For Quality Scorecard (required):
1. User specified a path?                                     → Read it → DONE
2. Find latest versioned file in sdlc/<phase>/draft/          → Extract "## Quality Scorecard" section → DONE
3. Not found? → Ask: "Provide the path to the quality scorecard or the refine output containing it."

For Draft version (required):
1. User specified a path?                                     → Read it → DONE
2. Exists as sdlc/<phase>/draft/<topic>-v{N}.md (latest N)?   → Read it → DONE
3. Exists as sdlc/<phase>/draft/<topic>-draft.md?             → Read it → DONE
4. Not found? → Ask: "Provide the path to the draft version."

For Final version (required):
1. User specified a path?                                     → Read it → DONE
2. Exists in sdlc/<phase>/final/<topic>-final.md?             → Read it → DONE
3. Not found? → Ask: "Provide the path to the final version."
```

Then read the target skill's definition files (all required):
```
4. skills/<phase>/<skill>/SKILL.md
5. All files in skills/<phase>/<skill>/knowledge/
6. All files in skills/<phase>/<skill>/rules/
7. All files in skills/<phase>/<skill>/templates/
```

Also check for previous evolution history:
```
8. List skills/<phase>/<skill>/evolution/*/patch-note.md (if any exist)
   → Read them to understand prior evolutions
```

**Mode 2 (Apply):**

```
For Analysis report (required):
1. User specified a path?                                     → Read it → DONE
2. Find most recent skills/<phase>/<skill>/evolution/*/analysis.md → Read it → DONE
3. Not found? → Ask: "No analysis found. Run --analyze first or provide a path."
```

Then read all target skill files that may be modified:
```
4. skills/<phase>/<skill>/SKILL.md
5. All files in skills/<phase>/<skill>/knowledge/
6. All files in skills/<phase>/<skill>/rules/
7. All files in skills/<phase>/<skill>/templates/
```

### Step 4: Generate (Mode-specific)

**Mode 1 — Analyze:**

Work through the analysis **section by section**:

1. **Scorecard Summary** — Parse the quality scorecard
   - Extract scores for all 5 dimensions
   - Calculate gap from target (4/5) for each dimension
   - Identify dimensions requiring evolution (score < 4)
   - Present summary to user before continuing

2. **Diff Analysis** — Compare draft vs final systematically
   - Phase 1: Structural analysis (section-level additions, removals, reordering)
   - Phase 2: Content analysis (additions, corrections, removals, restructuring within sections)
   - Phase 3: Classify each change (Knowledge Gap / Template Gap / Rule Gap / Workflow Gap / Calibration Gap / Input Miss / Project-Specific)
   - Phase 4: Filter out formatting-only changes and project-specific changes
   - Number each substantive change: C-1, C-2, ...

3. **Root Cause Analysis** — For each non-project-specific change
   - Identify which skill layer caused the problem (use skill-anatomy-guide.md targeting guide)
   - Name the specific file and section responsible
   - Explain the diagnosis: what's missing or wrong in the skill definition
   - Number each root cause: RCA-1, RCA-2, ...

4. **Proposed Changes** — For each root cause
   - Draft the specific proposed change with exact copy-paste-ready content
   - Read the current content from the target file to include in "Current content" block
   - Name the target file path and section
   - Assign priority (HIGH / MEDIUM / LOW) using impact assessment heuristics
   - Link to scorecard dimension and estimate score improvement
   - Number each proposed change: PC-1, PC-2, ...
   - List project-specific observations separately
   - Flag shared/cross-skill issues separately

5. **Assessment** — Summarize metrics
   - Calculate estimated post-evolution scorecard average
   - Include previous evolution history if available
   - State next steps for the user

Output: Write `analysis.md` following the analysis template.
Also write `scorecard.md` (archive of the scorecard input) to the same evolution directory.

**Mode 2 — Apply:**

1. Read the analysis report
2. Parse all proposed changes (PC-1, PC-2, ...)
3. Check approval status of each:
   - ✅ APPROVED → will be applied
   - ❌ REJECTED → will be skipped
   - ⏳ PENDING → Ask user: "PC-{N} is still PENDING. Apply all pending changes? Or mark specific ones as APPROVED/REJECTED first."
4. For each APPROVED change:
   a. Read the target file
   b. Locate the target section
   c. Verify the "Current content" matches the actual file (if not → WARN and skip)
   d. Apply the change (replace current with proposed content, or add new content)
   e. Write the modified file
5. Bump the version in the target skill's `SKILL.md` frontmatter:
   - Any change to `SKILL.md` workflow → major bump (e.g., 1.0 → 2.0)
   - Changes only to knowledge/rules/templates → minor bump (e.g., 1.0 → 1.1)
6. Generate `patch-note.md` following the patch note template
7. Write patch-note to the same evolution timestamp directory as the analysis

### Step 5: Validate Output

**Mode 1 (Analyze) — check against rules:**

- Every proposed change names exact file path and section (EVO-01)
- Every proposed change links to a scorecard dimension with expected improvement (EVO-02)
- Diff analysis covers all substantive changes (EVO-03)
- Every root cause attributed to exactly one skill layer (EVO-04)
- Every proposed change has a priority (EVO-05)
- No project-specific changes in proposed list (EVO-06)
- Proposed changes don't break backward compatibility (EVO-07)
- No changes proposed to shared resources (EVO-12)
- All artifacts in new timestamp directory (EVO-13)
- Single skill scope (EVO-14)

**Mode 2 (Apply) — check against rules:**

- Only applying changes from the analysis report (EVO-08)
- Each change applied independently (EVO-09)
- Version bumped in SKILL.md (EVO-10)
- Patch note includes all required information (EVO-11)
- No shared resources modified (EVO-12)
- Artifacts in correct timestamp directory (EVO-13)

### Step 6: Readiness Assessment

**Mode 1 (Analyze):**

| Metric | Value |
|--------|-------|
| Scorecard dimensions analyzed | {N}/5 |
| Dimensions below target (< 4) | {N} |
| Draft→final changes analyzed | {N} |
| Root causes identified | {N} |
| Proposed changes | {N} (HIGH: {H}, MEDIUM: {M}, LOW: {L}) |
| Estimated post-evolution average | {N}/5 |

**Verdict**: {✅ Analysis Complete / ⚠️ Partial Analysis / ❌ Insufficient Data}

- ✅ Analysis Complete: All low-scoring dimensions have at least one proposed change
- ⚠️ Partial Analysis: Some low-scoring dimensions have no proposed changes (explain why)
- ❌ Insufficient Data: Could not complete diff analysis (e.g., draft and final too different to compare meaningfully)

**Mode 2 (Apply):**

| Metric | Value |
|--------|-------|
| Changes proposed | {N} |
| Changes approved | {N} |
| Changes applied successfully | {N} |
| Changes skipped | {N} |
| Files modified | {list} |
| Version | {old} → {new} |

**Verdict**: {✅ Evolution Applied / ⚠️ Partially Applied / ❌ Apply Failed}

### Step 7: Output

**Mode 1 (Analyze):**

- Create directory: `skills/<phase>/<skill>/evolution/<timestamp>/`
- Write: `skills/<phase>/<skill>/evolution/<timestamp>/analysis.md`
- Write: `skills/<phase>/<skill>/evolution/<timestamp>/scorecard.md`

Tell the user:
> **Evolution analysis complete!**
> - Analysis: `skills/<phase>/<skill>/evolution/<timestamp>/analysis.md`
> - Scorecard archived: `skills/<phase>/<skill>/evolution/<timestamp>/scorecard.md`
> - Proposed changes: {N} (HIGH: {H}, MEDIUM: {M}, LOW: {L})
> - Estimated post-evolution average: {N}/5
>
> **Next steps:**
> 1. Review each proposed change in the analysis report
> 2. Mark each PC as ✅ APPROVED or ❌ REJECTED
> 3. Run `/skill-evolution --apply <phase>/<skill>` to apply approved changes
> 4. Run `./install.sh` to update installed skills

**Mode 2 (Apply):**

- Write: `skills/<phase>/<skill>/evolution/<timestamp>/patch-note.md`
- Modified skill files are already written in Step 4

Tell the user:
> **Skill evolution applied!**
> - Patch note: `skills/<phase>/<skill>/evolution/<timestamp>/patch-note.md`
> - Version: {old} → {new}
> - Changes applied: {N}/{total proposed}
> - Files modified: {list}
>
> **Next steps:**
> 1. Review the modified skill files
> 2. Run `./install.sh` to update installed skills
> 3. Test the evolved skill on a new project to verify improvement

---

## Scope Rules

### This skill DOES:
- Analyze quality scorecard results to identify weak dimensions
- Compare draft vs final versions to find what the skill got wrong
- Trace problems to specific skill definition files and sections
- Propose copy-paste-ready changes with priority and rationale
- Apply user-approved changes to skill files
- Maintain evolution history with timestamps
- Bump skill versions after changes
- Flag shared/cross-skill issues for manual review

### This skill does NOT:
- Modify shared resources (`skills/shared/` or `<phase>/shared/`)
- Evolve multiple skills in a single run
- Auto-apply changes without user approval
- Generate new skill output (that's what the target skill does)
- Create or modify draft/final artifacts in `sdlc/`
- Delete previous evolution history
- Make project-specific changes to generalizable skill definitions
