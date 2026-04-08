---
name: init-scope
description: >
  Create or refine a detailed project scope document from an approved charter.
  Expands charter's high-level scope into feature inventory, personas,
  system context, quality attributes, and scope change control.
  ONLY activated by command: `/init-scope`. Use `--create`, `--refine`, or `--score` to set mode.
  NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine|--score"
version: "1.0"
category: sdlc
phase: init
prev_phase: init-charter
next_phase: init-risk
---

# Project Scope Skill

## Purpose

Create or refine a detailed project scope document (`scope-draft.md`) that expands the charter's high-level scope into a comprehensive feature inventory, user personas, system integrations, and quality attributes.

The scope document bridges the gap between "what we want to achieve" (charter) and "what we need to build" (requirements).

---

## Three Modes

### Mode 1: Create (`--create`)

Generate a new scope document from an approved charter.

| Input | Required | Source |
|-------|----------|--------|
| Charter (final or draft) | Yes | `sdlc/init/final/charter-final.md` or user-specified path |
| Additional context | No | User provides domain knowledge, constraints |

### Mode 2: Refine (`--refine`)

Improve an existing scope document based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing scope draft | Yes | `sdlc/init/draft/scope-draft.md` or `sdlc/init/draft/scope-v{N}.md` |
| Review report / feedback | Yes | User provides directly or as `sdlc/init/input/review-report.md` |
| Additional details | No | New information the user wants to add |

### Mode 3: Score (`--score`)

Evaluate artifact quality with a detailed scoreboard.

| Input | Required | Source |
|-------|----------|--------|
| Artifact to score | Yes | `sdlc/init/draft/scope-draft.md` or latest `scope-v{N}.md` or `sdlc/init/final/scope-final.md`, or user-specified path |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `scope-draft.md` | `sdlc/init/draft/` |
| Refine | `scope-v{N}.md` | `sdlc/init/draft/` (N = next version number) |
| Score | `scope-scoreboard.md` | `sdlc/init/draft/` |

When user is satisfied -> they copy from `sdlc/init/draft/` to `sdlc/init/final/scope-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User passes `--score` argument -> **Mode 3 (Score)**
- User passes `--refine` argument -> **Mode 2 (Refine)**
- User passes `--create` argument -> **Mode 1 (Create)**
- No argument specified AND existing draft exists in `sdlc/init/draft/` -> Ask: "A draft already exists. Use `--create` to start fresh or `--refine` to improve it."
- No argument specified AND no draft exists -> **Mode 1 (Create)**

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md` -- document formatting standards
2. `skills/shared/rules/quality-rules.md` -- confidence marking, readiness assessment
3. `skills/shared/rules/output-rules.md` -- versioning, input resolution, diff summary
4. `init/shared/rules/init-rules.md` -- initiation phase rules
5. `init/shared/templates/scope/scope-template.md` -- scope document structure
6. `init/shared/templates/scope/persona-template.md` -- persona card format
7. `init/scope/knowledge/scope-definition-guide.md` -- scope definition techniques
8. `init/scope/rules/output-rules.md` -- scope-specific output rules
9. `init/scope/templates/output-template.md` -- expected output structure
10. `skills/shared/knowledge/scoring-guide.md` -- scoring methodology (Mode 3 only)
11. `skills/shared/rules/scoring-rules.md` -- scoring output rules (Mode 3 only)
12. `skills/shared/templates/scoreboard-output-template.md` -- scoreboard format (Mode 3 only)

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
For charter input (required):
1. Exists in sdlc/init/final/charter-final.md?  -> YES -> read it -> DONE
2. User specified a different path?              -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/init/input/charter-final.md?   -> YES -> read it -> DONE
4. Not found? -> Ask: "No charter found. Please provide a path or run /init-charter first."

If charter is a draft (not final):
- Warn: "Using a draft charter. Some items may be ASSUMED or UNCLEAR — scope will inherit that uncertainty."
- Proceed anyway
```

**Mode 2 (Refine):**

```
For scope draft:
1. Exists in sdlc/init/draft/ (latest version)? -> YES -> read it -> DONE
2. User specified a different path?              -> YES -> read it, copy to sdlc/init/input/ -> DONE
3. Exists in sdlc/init/input/?                   -> YES -> read it -> DONE
4. Not found? -> FAIL: "No existing scope found. Run /init-scope first."

For review report:
1. User provided feedback directly in message? -> Save to sdlc/init/input/review-report.md
2. User specified path?                        -> read it, copy to sdlc/init/input/
3. Exists in sdlc/init/input/review-report.md? -> read it
4. Not found? -> Ask: "What feedback do you have on the current scope?"
```

**Mode 3 (Score):**

```
For artifact to score (required):
1. User specified a path?                                     → Read it → DONE
2. Exists in sdlc/init/final/scope-final.md?                  → Read it → DONE
3. Exists as sdlc/init/draft/scope-v{N}.md (latest N)?        → Read it → DONE
4. Exists as sdlc/init/draft/scope-draft.md?                  → Read it → DONE
5. Not found? → Ask: "Provide the path to the artifact to score."
```

### Step 4: Generate (Mode-specific)

**Mode 1 -- Create:**

Work through the scope document **section by section, incrementally**:

1. **Project Boundaries** -- Expand charter's in-scope/out-of-scope into boundary diagram
   - Carry forward all SCP- and OUT- items from charter
   - Ask: "Are there additional features to include or exclude?"

2. **Feature Inventory** -- Break charter features into sub-features with complexity sizing
   - For each charter feature (SCP-xxx), decompose into sub-features
   - Assign MoSCoW priority (Must/Should/Could/Won't)
   - Estimate complexity (XS/S/M/L/XL)
   - Map inter-feature dependencies
   - Ask: "Do any of these features need further breakdown?"

3. **User Roles / Personas** -- Define 2-5 personas from charter's target audience
   - Extract target users from charter's vision statement
   - Create persona cards with goals, pain points, scenarios
   - Build persona-to-feature map
   - Ask: "Are these the right user types? Any missing?"

4. **System Context** -- Identify external integrations and system boundaries
   - Extract integrations from charter (e.g., Git, CI/CD references)
   - Map data flow direction (IN/OUT/BI)
   - Generate C4 Context diagram in Mermaid
   - Ask: "What external systems does this need to integrate with?"

5. **Quality Attributes** -- Define non-functional requirements with measurable targets
   - Push for quantified targets (INIT-04)
   - Cover: performance, availability, scalability, security, accessibility, maintainability
   - Ask: "What are your quality expectations? (response time, uptime, user load, etc.)"

6. **Scope Change Control** -- Include change request process
   - Standard process from template (usually no customization needed)

For each section:
- Apply confidence markers (CONFIRMED / ASSUMED / UNCLEAR)
- Inherit confidence from charter where applicable
- Create Q&A entries for ASSUMED and UNCLEAR items
- Present section to user before moving to next

**Mode 2 -- Refine:**

1. Read existing scope draft (baseline)
2. Read review report / user feedback
3. Run Quality Scorecard analysis (completeness, clarity, quantification, consistency, traceability)
4. Present scorecard to user: "Here's what I found in the current scope..."
5. Apply improvements:
   - Address user feedback point by point
   - Resolve Q&A entries from previous version
   - Upgrade confidence levels where possible
   - Break down features that are too large (L/XL without sub-features)
   - Quantify vague quality attributes
   - Strengthen persona scenarios
6. Tag all changes: `[UPDATED]` for modified items, `[NEW]` for additions
7. Preserve CONFIRMED items unless user explicitly contradicts them
8. Write improved version to `sdlc/init/draft/scope-v{N}.md`

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
- Features trace to charter objectives (SCP-01)
- Personas have measurable volume (SCP-02)
- Quality attributes are quantified (INIT-04, SCP-04)
- No technical decisions made (INIT-03)
- Feature IDs are consistent with charter (SCP-05)
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

- **Create mode**: Write to `sdlc/init/draft/scope-draft.md`
- **Refine mode**: Write to `sdlc/init/draft/scope-v{N}.md`, include Change Log and Diff Summary

**Mode 3 (Score):**

- Write to `sdlc/init/draft/scope-scoreboard.md`

Tell the user:
> **Scoreboard complete!**
> - Output: `sdlc/init/draft/scope-scoreboard.md`
> - Average: {avg}/5 — {verdict}
> - Lowest: {dimension} ({score}/5)
> - Issues: {N} (HIGH: {H}, MED: {M}, LOW: {L})
>
> **Next steps:**
> - Run `/init-scope --refine` to address issues
> - Or run `/skill-evolution --analyze init/scope` to improve the skill definition itself

Tell the user:
> **Scope {created/refined}!**
> - Output: `sdlc/init/draft/scope-{version}.md`
> - Readiness: {verdict}
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/init-scope --refine`
> - When satisfied, copy to `sdlc/init/final/scope-final.md`
> - Then run `/init-risk` to create the risk register

---

## Scope Rules

### This skill DOES:
- Expand charter scope into detailed feature inventory
- Define user personas with goals, pain points, scenarios
- Identify external system integrations
- Define measurable quality attributes
- Apply MoSCoW prioritization and complexity sizing
- Generate C4 system context diagrams (Mermaid)
- Apply confidence marking to every item

### This skill does NOT:
- Write user stories or acceptance criteria (belongs to `req/` phase)
- Make technology decisions (belongs to `design/` phase)
- Create architecture diagrams beyond system context (belongs to `design/` phase)
- Define sprint plans or estimates (belongs to `impl/` phase)
- Perform risk analysis (belongs to `init/risk` skill)
- Modify the charter -- it reads the charter as input
