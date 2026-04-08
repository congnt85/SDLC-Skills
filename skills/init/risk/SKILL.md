---
name: init-risk
description: >
  Create or refine a project risk register from charter and/or scope documents.
  Identifies, assesses, and plans responses for project risks using probability-impact
  scoring, risk categorization, heat maps, and monitoring plans.
  ONLY activated by commands: `/init-risk` (create) or `/init-risk-refine` (refine).
  NEVER auto-trigger based on keywords.
argument-hint: "[path to charter or scope file (md/pdf/docx/xlsx/pptx)]"
version: "1.0"
category: sdlc
phase: init
prev_phase: init-scope
next_phase: req-epic
---

# Risk Register Skill

## Purpose

Create or refine a project risk register (`risk-register-draft.md`) that identifies, assesses, and plans responses for risks that could impact the project's success.

The risk register is a living document — it captures what could go wrong, how bad it would be, and what we'll do about it. It draws from the charter (constraints, assumptions, dependencies) and scope (features, integrations, quality attributes).

---

## Two Modes

### Mode 1: Create (`/init-risk`)

Generate a new risk register from charter and/or scope documents.

| Input | Required | Source |
|-------|----------|--------|
| Charter (final or draft) | Yes | `sdlc/init/final/charter-final.md` or user-specified path |
| Scope (final or draft) | No | `sdlc/init/final/scope-final.md` or user-specified path |
| Additional context | No | User provides known risks, concerns |

### Mode 2: Refine (`/init-risk-refine`)

Improve an existing risk register based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing risk register draft | Yes | `sdlc/init/draft/risk-register-draft.md` or `sdlc/init/draft/risk-register-v{N}.md` |
| Review report / feedback | Yes | User provides directly or as `sdlc/init/input/review-report.md` |
| Additional details | No | New risks, score adjustments, mitigation updates |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `risk-register-draft.md` | `sdlc/init/draft/` |
| Refine | `risk-register-v{N}.md` | `sdlc/init/draft/` (N = next version number) |

When user is satisfied -> they copy from `sdlc/init/draft/` to `sdlc/init/final/risk-register-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User runs `/init-risk-refine` AND existing draft exists in `sdlc/init/draft/` -> **Mode 2 (Refine)**
- User runs `/init-risk` -> **Mode 1 (Create)**
- User runs `/init-risk` but draft already exists -> Ask: "A risk register draft already exists. Create new (overwrite) or refine existing?"

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md` -- document formatting standards
2. `skills/shared/rules/quality-rules.md` -- confidence marking, readiness assessment
3. `skills/shared/rules/output-rules.md` -- versioning, input resolution, diff summary
4. `init/shared/rules/init-rules.md` -- initiation phase rules
5. `init/shared/templates/risk/risk-register-template.md` -- risk register structure
6. `init/shared/templates/risk/risk-matrix-template.md` -- common risks and categories
7. `init/risk/knowledge/risk-identification-guide.md` -- risk identification techniques
8. `init/risk/rules/output-rules.md` -- risk-specific output rules
9. `init/risk/templates/output-template.md` -- expected output structure

### Step 3: Resolve Input

**File Type Conversion** (applies to all file inputs):

Before reading any input file, check its extension:
- `.md` → Read directly, no conversion needed
- `.pdf` → Run `/read-pdf <path> sdlc/init/input/` → read the converted .md
- `.docx` / `.doc` → Run `/read-word <path> sdlc/init/input/` → read the converted .md
- `.xlsx` / `.xls` → Run `/read-excel <path> sdlc/init/input/` → read the converted .md
- `.pptx` / `.ppt` → Run `/read-ppt <path> sdlc/init/input/` → read the converted .md

Converted files are saved to `sdlc/init/input/`. If a converted .md already exists and is newer than the source, skip conversion.

**Mode 1 (Create):**

```
For charter input (required):
1. User specified path?                        -> YES -> read it, copy to sdlc/init/input/ -> DONE
2. Exists in sdlc/init/input/charter-final.md? -> YES -> read it -> DONE
3. Exists in sdlc/init/final/charter-final.md? -> YES -> read it, copy to sdlc/init/input/ -> DONE
4. Not found? -> Ask: "No charter found. Please provide a charter path or run /init-charter first."

For scope input (optional but recommended):
1. User specified path?                        -> YES -> read it, copy to sdlc/init/input/ -> DONE
2. Exists in sdlc/init/input/scope-final.md?   -> YES -> read it -> DONE
3. Exists in sdlc/init/final/scope-final.md?   -> YES -> read it, copy to sdlc/init/input/ -> DONE
4. Not found? -> Warn: "No scope document found. Risk register will be based on charter only. Run /init-scope for a more comprehensive risk analysis."
   Proceed without scope.
```

**Mode 2 (Refine):**

```
For risk register draft:
1. User specified path?                        -> YES -> read it, copy to sdlc/init/input/ -> DONE
2. Exists in sdlc/init/input/?                 -> YES -> read it -> DONE
3. Exists in sdlc/init/draft/ (latest version)? -> YES -> read it, copy to sdlc/init/input/ -> DONE
4. Not found? -> FAIL: "No existing risk register found. Run /init-risk first."

For review report:
1. User provided feedback directly in message? -> Save to sdlc/init/input/review-report.md
2. User specified path?                        -> read it, copy to sdlc/init/input/
3. Exists in sdlc/init/input/review-report.md? -> read it
4. Not found? -> Ask: "What feedback do you have on the current risk register?"
```

### Step 4: Generate (Mode-specific)

**Mode 1 -- Create:**

Work through the risk register **section by section**:

1. **Risk Identification** -- Extract risks from source documents
   - Scan charter for: assumptions (each could fail), constraints (each could tighten), dependencies (each could delay), UNCLEAR items (each is a risk), Q&A pending items
   - Scan scope for: complex features (L/XL), external integrations, ASSUMED quality attributes, persona-feature gaps
   - Cross-reference with common risk checklist from `risk-matrix-template.md`
   - Ask: "Are there any known risks, concerns, or past project issues I should include?"

2. **Risk Assessment** -- Score each risk using probability-impact matrix
   - Assign probability (1-5) and impact (1-5)
   - Calculate risk score (P x I)
   - Categorize: Technical / Resource / Schedule / Scope / External / Organizational
   - Apply consistent scoring using the scoring guide

3. **Risk Summary** -- Aggregate by category
   - Count risks per category
   - Calculate average score per category
   - Identify highest-risk item per category

4. **Risk Heat Map** -- Visual placement of risks on the P x I matrix
   - Place each RISK-ID in the appropriate cell
   - Highlight Critical (20-25) and High (13-19) zones

5. **Risk Response Strategies** -- Plan response for each risk
   - Assign response type: Avoid / Mitigate / Transfer / Accept
   - Write specific mitigation strategy (not generic)
   - Assign owner (use [TBD] if unknown)

6. **Risk Monitoring Plan** -- Define how to watch for risk triggers
   - Define trigger condition (observable signal that risk is materializing)
   - Set check frequency (daily / weekly / sprint)
   - Write contingency plan (what to do if triggered)

For each risk:
- Apply confidence markers (CONFIRMED / ASSUMED / UNCLEAR)
- Risks derived from CONFIRMED charter items -> CONFIRMED
- Risks inferred by analysis -> ASSUMED
- Risks with unclear probability or impact -> UNCLEAR
- Create Q&A entries for UNCLEAR risks

**Mode 2 -- Refine:**

1. Read existing risk register draft (baseline)
2. Read review report / user feedback
3. Run Quality Scorecard analysis (completeness, clarity, quantification, consistency, traceability)
4. Present scorecard to user: "Here's what I found in the current risk register..."
5. Apply improvements:
   - Address user feedback point by point
   - Resolve Q&A entries from previous version
   - Upgrade confidence levels where possible
   - Re-score risks if new information changes probability or impact
   - Add risks missed in initial identification
   - Improve generic mitigations with specific actions
   - Fill in [TBD] owners where possible
6. Tag all changes: `[UPDATED]` for modified items, `[NEW]` for additions
7. Preserve CONFIRMED items unless user explicitly contradicts them
8. Write improved version to `sdlc/init/draft/risk-register-v{N}.md`

### Step 5: Validate Output

Check against rules:
- Every risk has a confidence marker (CR-01)
- CONFIRMED risks cite source (CR-02)
- ASSUMED risks have reasoning + Q&A ref (CR-03)
- Every risk has probability AND impact score (RSK-01)
- Every risk has a response strategy (RSK-02)
- Every High/Critical risk has a monitoring plan entry (RSK-03)
- Risk IDs are sequential (RSK-04)
- At least 8 risks identified (RSK-05)
- All 6 categories considered (RSK-06)
- Mitigation strategies are specific, not generic (RSK-07)
- No technical decisions made (INIT-03)
- Approval section present (INIT-07)
- Cross-references consistent (INIT-08)

### Step 6: Readiness Assessment

Generate assessment per `skills/shared/templates/readiness-assessment.md`:
- Count items by confidence level
- Calculate readiness verdict
- In refine mode: compare with previous version

### Step 7: Output

- **Create mode**: Write to `sdlc/init/draft/risk-register-draft.md`
- **Refine mode**: Write to `sdlc/init/draft/risk-register-v{N}.md`, include Change Log and Diff Summary

Tell the user:
> **Risk register {created/refined}!**
> - Output: `sdlc/init/draft/risk-register-{version}.md`
> - Readiness: {verdict}
> - Risks: {total} ({critical} Critical, {high} High, {medium} Medium, {low} Low)
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/init-risk-refine`
> - When satisfied, copy to `sdlc/init/final/risk-register-final.md`
> - Initiation phase complete! Run `/req-epic` to start requirements

---

## Scope Rules

### This skill DOES:
- Identify project risks from charter, scope, and user input
- Assess risks using probability-impact scoring
- Categorize risks across 6 standard categories
- Plan risk responses (avoid, mitigate, transfer, accept)
- Create risk monitoring plans with trigger conditions
- Generate risk heat maps
- Apply confidence marking to every risk

### This skill does NOT:
- Perform quantitative risk analysis (Monte Carlo, etc.) -- too early
- Create risk response budgets -- belongs to project management
- Execute risk responses -- belongs to implementation phase
- Assess technical feasibility -- deferred skill
- Conduct stakeholder risk tolerance analysis -- deferred skill
- Modify charter or scope -- it reads them as input
