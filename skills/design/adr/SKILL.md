---
name: design-adr
description: >
  Create or refine Architecture Decision Records (ADRs). Documents significant
  technical decisions with context, alternatives considered, rationale, and
  consequences. Can be run multiple times — each invocation creates one ADR.
  ONLY activated by command: `/design-adr`. Use `--create`, `--refine`, or `--score` to set mode.
  NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine|--score"
version: "1.0"
category: sdlc
phase: design
prev_phase: design-arch
next_phase: null
---

# Architecture Decision Record Skill

## Purpose

Create individual ADR documents (`adr-{NNN}-{slug}-draft.md`) that record significant
architectural decisions. Each invocation produces ONE ADR. Multiple ADRs accumulate in `sdlc/design/draft/`
over multiple invocations throughout the design phase.

The ADR skill is different from other design skills:
- It can run at **any point** during the design phase (not strictly sequential)
- It produces **multiple files** over multiple invocations (`adr-001`, `adr-002`, etc.)
- Each invocation creates exactly **one** ADR
- The ADR number is **auto-incremented** based on existing ADRs in `sdlc/design/draft/`

---

## Three Modes

### Mode 1: Create (`--create`)

Create a new ADR for a specific architectural decision.

| Input | Required | Source |
|-------|----------|--------|
| Decision topic | ✅ | User provides as argument or interactively |
| tech-stack-final.md | No | `sdlc/design/final/` — context for technology decisions |
| architecture-final.md | No | `sdlc/design/final/` — context for architecture decisions |
| database-final.md | No | `sdlc/design/final/` — context for data decisions |
| api-final.md | No | `sdlc/design/final/` — context for API decisions |
| charter-final.md | No | `sdlc/init/final/` — constraints, business context |
| scope-final.md | No | `sdlc/init/final/` — quality attributes, integrations |
| risk-register-final.md | No | `sdlc/init/final/` — risks this decision mitigates |
| userstories-final.md | No | `sdlc/req/final/` — stories driving the decision |

### Mode 2: Refine (`--refine`)

Improve or update an existing ADR based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing ADR | ✅ | `sdlc/design/draft/adr-{NNN}-{slug}-draft.md` (by number or slug) |
| Review report / feedback | ✅ | User provides directly or as `sdlc/design/input/review-report.md` |
| Additional context | No | New information the user wants to incorporate |

### Mode 3: Score (`--score`)

Evaluate artifact quality with a detailed scoreboard.

| Input | Required | Source |
|-------|----------|--------|
| Artifact to score | Yes | `sdlc/design/draft/adr-draft.md` or latest `adr-v{N}.md` or `sdlc/design/final/adr-final.md`, or user-specified path |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `adr-{NNN}-{slug}-draft.md` | `sdlc/design/draft/` |
| Refine | `adr-{NNN}-{slug}-draft.md` | `sdlc/design/draft/` (updates in place, adds Change Log) |
| Score | `adr-scoreboard.md` | `sdlc/design/draft/` |

When user is satisfied → copy to `sdlc/design/final/adr/adr-{NNN}-{slug}-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User passes `--score` argument → **Mode 3 (Score)**
- User passes `--refine` argument → **Mode 2 (Refine)**
- User passes `--create` argument → **Mode 1 (Create)**
- No argument specified AND existing draft exists in `sdlc/design/draft/` → Ask: "A draft already exists. Use `--create` to start fresh or `--refine` to improve it."
- No argument specified AND no draft exists → **Mode 1 (Create)**

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md` — document formatting standards
2. `skills/shared/rules/quality-rules.md` — confidence marking, readiness assessment
3. `skills/shared/rules/output-rules.md` — versioning, input resolution, diff summary
4. `design/shared/rules/design-rules.md` — design phase rules
5. `design/adr/knowledge/adr-writing-guide.md` — ADR writing techniques
6. `design/adr/rules/output-rules.md` — ADR-specific output rules
7. `design/adr/templates/output-template.md` — expected output structure
8. `skills/shared/knowledge/scoring-guide.md` — scoring methodology (Mode 3 only)
9. `skills/shared/rules/scoring-rules.md` — scoring output rules (Mode 3 only)
10. `skills/shared/templates/scoreboard-output-template.md` — scoreboard format (Mode 3 only)

### Step 3: Resolve Input

**File Type Conversion** (applies to all file inputs):

Before reading any input file, check its extension:
- `.md` → Read directly, no conversion needed
- `.pdf` → Run `/read-pdf <path> sdlc/design/input/` → read the converted .md
- `.docx` / `.doc` → Run `/read-word <path> sdlc/design/input/` → read the converted .md
- `.xlsx` / `.xls` → Run `/read-excel <path> sdlc/design/input/` → read the converted .md
- `.pptx` / `.ppt` → Run `/read-ppt <path> sdlc/design/input/` → read the converted .md

Converted files are saved to `sdlc/design/input/`. If a converted .md already exists and is newer than the source, skip conversion.

Note: Files auto-resolved from `sdlc/` pipeline are always .md and skip conversion.

**Mode 1 (Create):**

```
For decision topic (REQUIRED):
1. User provided topic as argument? → Use it
2. No argument? → Ask: "What architectural decision do you want to document?"

For ADR number:
1. Scan sdlc/design/draft/ for existing adr-{NNN}-*-draft.md files
2. Determine next number (NNN = max existing + 1, or 001 if none)

For context (ALL OPTIONAL — read what exists):
1. Check sdlc/design/final/ for tech-stack-final.md, architecture-final.md,
   database-final.md, api-final.md
2. Check sdlc/init/final/ for charter-final.md, scope-final.md, risk-register-final.md
3. Check sdlc/req/final/ for userstories-final.md, backlog-final.md
4. User specified a different path? → Read it, convert if needed
5. Check sdlc/design/input/ for any previously copied artifacts
6. If found → copy to sdlc/design/input/ for traceability
7. If not found → proceed without, note missing context
```

**Mode 2 (Refine):**

```
For existing ADR (REQUIRED):
1. User specified ADR number or slug? → Find matching file in sdlc/design/draft/
2. User specified path? → Read it
3. Only one ADR in sdlc/design/draft/? → Use it
4. Multiple ADRs in sdlc/design/draft/ and no specifier? → List them, ask user to choose
5. No ADRs found? → FAIL: "No ADR found. Run /design-adr first."

For review report:
1. User provided feedback directly in message? → Save to sdlc/design/input/review-report.md
2. User specified path? → Read it, copy to sdlc/design/input/
3. Exists in sdlc/design/input/review-report.md? → Read it
4. Not found? → Ask: "What feedback do you have on this ADR?"
```

**Mode 3 (Score):**

```
For artifact to score (required):
1. User specified a path?                                     → Read it → DONE
2. Exists in sdlc/design/final/adr-final.md?                  → Read it → DONE
3. Exists as sdlc/design/draft/adr-v{N}.md (latest N)?        → Read it → DONE
4. Exists as sdlc/design/draft/adr-draft.md?                  → Read it → DONE
5. Not found? → Ask: "Provide the path to the artifact to score."
```

### Step 4: Generate (Mode-specific)

**Mode 1 — Create:**

Work through the ADR structure **section by section**:

1. **Title** — Short, imperative form: "Use PostgreSQL as primary database" not "Database selection". Derive from the user's decision topic.

2. **Status** — Set to `Proposed` (default for new ADRs).

3. **Context** — What forces are at play? What problem prompted this decision? Trace to requirements:
   - Business drivers from charter (CON-xxx)
   - Technical constraints from scope/tech-stack
   - Quality requirements (QA-xxx)
   - Risk mitigations (RISK-xxx)
   - User stories driving the need (US-xxx)
   - Present to user for confirmation.

4. **Decision** — What was decided and why. State clearly: "We will use {X} because {rationale}."

5. **Alternatives Considered** — At least 2 alternatives. For each:
   - Brief description
   - Pros (what it does well)
   - Cons (what it does poorly or risks)
   - CHOSEN or REJECTED label
   - Be fair to rejected options — they may become relevant later.

6. **Consequences** — Split into positive, negative, and neutral:
   - Positive: what this decision enables, simplifies, or improves
   - Negative: what this decision constrains, complicates, or risks
   - Be honest about trade-offs — every decision has downsides.

7. **Compliance** — How this decision affects security, performance, cost, and compliance/legal requirements.

8. **Related Decisions** — Links to other ADRs that are related, depended upon, or superseded. Check existing ADRs in sdlc/design/draft/ for relationships.

9. **Q&A** — Capture open questions about this decision.

10. **Approval** — Blank approval table for stakeholder sign-off.

For each section:
- Apply confidence markers (✅ CONFIRMED / 🔶 ASSUMED / ❓ UNCLEAR)
- Create Q&A entries for ASSUMED and UNCLEAR items

**Mode 2 — Refine:**

1. Read existing ADR (baseline)
2. Read review report / user feedback
3. Run Quality Scorecard analysis:
   - Title format (imperative?)
   - Context traceability (requirements traced?)
   - Alternatives completeness (>=2 with pros/cons?)
   - Consequences balance (both positive and negative?)
   - Compliance coverage
   - Confidence distribution (% CONFIRMED vs ASSUMED vs UNCLEAR)
4. Present scorecard to user: "Here's what I found in the current ADR..."
5. Apply improvements:
   - Address user feedback point by point
   - Update status if requested (Proposed → Accepted / Rejected / Deprecated / Superseded)
   - Resolve Q&A entries from previous version
   - Upgrade confidence levels where possible (🔶→✅, ❓→🔶)
   - Add new context, alternatives, or consequences
   - Link to superseding ADR if status is Deprecated/Superseded
   - Proactively suggest improvements for weak areas
6. Tag all changes: `[UPDATED]` for modified items, `[NEW]` for additions
7. Preserve CONFIRMED items unless user explicitly contradicts them
8. Add Change Log section at top showing what changed

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
- Title in imperative form (ADR-01)
- Valid status (ADR-02)
- Context traces to at least one requirement (ADR-03)
- At least 2 alternatives with pros and cons (ADR-04)
- Both positive and negative consequences (ADR-05)
- Sequential ADR number, never reused (ADR-06)
- Correct file naming (ADR-07)
- Superseded ADRs link to successor (ADR-08)
- Deprecated ADRs explain why (ADR-09)
- Correct section order (ADR-10)
- Confidence markers on decision and alternatives (ADR-11)
- Refine mode shows scorecard first (ADR-12)
- Traces to requirements (DES-02)
- Quality attributes considered (DES-03)
- Consistency across artifacts (DES-06)
- ADR threshold met — DES-09 criteria (DES-09)

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

- **Create mode**: Write to `sdlc/design/draft/adr-{NNN}-{slug}-draft.md`
- **Refine mode**: Update `sdlc/design/draft/adr-{NNN}-{slug}-draft.md` with Change Log

**Mode 3 (Score):**

- Write to `sdlc/design/draft/adr-scoreboard.md`

Tell the user:
> **Scoreboard complete!**
> - Output: `sdlc/design/draft/adr-scoreboard.md`
> - Average: {avg}/5 — {verdict}
> - Lowest: {dimension} ({score}/5)
> - Issues: {N} (HIGH: {H}, MED: {M}, LOW: {L})
>
> **Next steps:**
> - Run `/design-adr --refine` to address issues
> - Or run `/skill-evolution --analyze design/adr` to improve the skill definition itself

Tell the user:
> **ADR {NNN} created!**
> - Output: `sdlc/design/draft/adr-{NNN}-{slug}-draft.md`
> - Status: Proposed
> - Decision: {short summary}
>
> **Next steps:**
> - Review and provide feedback via `/design-adr --refine`
> - When approved, copy to `sdlc/design/final/adr/adr-{NNN}-{slug}-final.md`
> - Run `/design-adr` again for additional decisions

---

## Scope Rules

### This skill DOES:
- Document architectural decisions with full context and rationale
- Record alternatives considered with pros and cons
- Track decision status through its lifecycle (Proposed → Accepted → Deprecated)
- Link related decisions across ADRs
- Trace decisions to requirements, constraints, and quality attributes
- Apply confidence marking to decisions and alternative assessments
- Auto-number ADRs sequentially based on existing records

### This skill does NOT:
- Make the architectural decisions (that's the other design skills — tech-stack, architecture, database, API)
- Implement decisions (belongs to `impl` phase)
- Replace decision matrices in tech-stack (ADRs complement matrices with narrative context)
- Generate multiple ADRs in a single invocation (one ADR per run)
- Reuse or renumber ADR numbers (numbers are permanent, sequential)
