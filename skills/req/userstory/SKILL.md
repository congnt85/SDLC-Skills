---
name: req-userstory
description: >
  Create or refine user stories with INVEST criteria and Gherkin acceptance
  criteria from epics and scope features. Decomposes each epic into
  implementable stories for each persona, including NFR and spike stories.
  ONLY activated by commands: `/req-userstory` (create) or `/req-userstory-refine` (refine).
  NEVER auto-trigger based on keywords.
argument-hint: "[path to epics file (md/pdf/docx/xlsx/pptx)]"
version: "1.0"
category: sdlc
phase: req
prev_phase: req-epic
next_phase: req-backlog
---

# User Story Skill

## Purpose

Create or refine a user stories document (`sdlc/req/draft/userstories-draft.md`) that decomposes epics into implementable stories with acceptance criteria. Each story follows the "As a / I want / So that" format, satisfies INVEST criteria, and includes Gherkin acceptance criteria.

---

## Two Modes

### Mode 1: Create (`/req-userstory`)

Generate user stories from epics and scope features.

| Input | Required | Source |
|-------|----------|--------|
| Epics (final) | Yes | `sdlc/req/final/epics-final.md` or user-specified path |
| Scope (final) | Yes | `sdlc/init/final/scope-final.md` or user-specified path |
| Risk register (final) | No | `sdlc/init/final/risk-register-final.md` — high risks become spike stories |

### Mode 2: Refine (`/req-userstory-refine`)

Improve existing stories based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing stories draft | Yes | `sdlc/req/draft/userstories-draft.md` or `sdlc/req/draft/userstories-v{N}.md` |
| Review report / feedback | Yes | User provides directly or as `sdlc/req/input/review-report.md` |
| Additional details | No | New stories, AC refinements |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `userstories-draft.md` | `sdlc/req/draft/` |
| Refine | `userstories-v{N}.md` | `sdlc/req/draft/` (N = next version number) |

When user is satisfied -> they copy from `sdlc/req/draft/` to `sdlc/req/final/userstories-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User runs `/req-userstory-refine` AND existing draft exists in `sdlc/req/draft/` -> **Mode 2 (Refine)**
- User runs `/req-userstory` -> **Mode 1 (Create)**
- User runs `/req-userstory` but draft already exists -> Ask: "A stories draft already exists. Create new (overwrite) or refine existing?"

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md` -- document formatting standards
2. `skills/shared/rules/quality-rules.md` -- confidence marking, readiness assessment
3. `skills/shared/rules/output-rules.md` -- versioning, input resolution, diff summary
4. `skills/shared/knowledge/agile-scrum-guide.md` -- user story format, INVEST, Gherkin
5. `req/shared/rules/req-rules.md` -- requirements phase rules
6. `req/shared/templates/userstory/userstory-template.md` -- story card format
7. `req/shared/templates/userstory/acceptance-criteria-template.md` -- Gherkin format
8. `req/userstory/knowledge/invest-criteria.md` -- INVEST checklist
9. `req/userstory/knowledge/story-splitting-patterns.md` -- splitting techniques
10. `req/userstory/knowledge/gherkin-guide.md` -- Gherkin writing guide
11. `req/userstory/rules/output-rules.md` -- story-specific output rules
12. `req/userstory/templates/output-template.md` -- expected output structure

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
For epics input (required):
1. User specified path?                        -> YES -> read it, copy to sdlc/req/input/ -> DONE
2. Exists in sdlc/req/input/epics-final.md?    -> YES -> read it -> DONE
3. Exists in sdlc/req/final/epics-final.md?    -> YES -> read it, copy to sdlc/req/input/ -> DONE
4. Not found? -> Ask: "No epics found. Please provide a path or run /req-epic first."

For scope input (required):
1. User specified path?                        -> YES -> read it, copy to sdlc/req/input/ -> DONE
2. Exists in sdlc/req/input/scope-final.md?    -> YES -> read it -> DONE
3. Exists in sdlc/init/final/scope-final.md?    -> YES -> read it, copy to sdlc/req/input/ -> DONE
4. Not found? -> Ask: "No scope found. Please provide a path or run /init-scope first."

For risk register (optional):
1-3. Standard resolution from sdlc/init/final/
4. Not found? -> Proceed without spike stories.
```

**Mode 2 (Refine):**

Standard refine input resolution (draft + review report).

### Step 4: Generate (Mode-specific)

**Mode 1 -- Create:**

Work through stories **epic by epic, incrementally**:

1. **Story Generation** -- For each epic:
   a. Read the epic's assigned scope features and sub-features
   b. Read the persona-to-feature map from scope
   c. For each feature/sub-feature, create stories from the perspective of relevant personas
   d. Write "As a [persona], I want [action], so that [benefit]" for each
   e. Assign story points (Fibonacci: 1, 2, 3, 5, 8, 13)
   f. Flag stories >8 points with `[SPLIT RECOMMENDED]`
   g. Present epic's stories to user before moving to next epic

2. **Acceptance Criteria** -- For each story:
   a. Write at least 2 Gherkin scenarios (happy path + edge case)
   b. Use Scenario Outline for data-driven variations where applicable
   c. Ensure AC is testable and specific

3. **INVEST Check** -- Validate each story against INVEST criteria
   - Flag violations with Q&A suggesting fixes

4. **NFR Stories** -- From scope quality attributes (QA-xxx):
   - Create stories for performance, security, availability targets
   - Tag with `[NFR]`, assign to cross-cutting epic
   - These stories still need AC (e.g., "Given 500 concurrent users, When loading dashboard, Then response time < 2s at P95")

5. **Spike Stories** -- From risk register (high-impact risks):
   - Create time-boxed investigation stories for uncertain technical risks
   - Tag with `[SPIKE]`, include time-box constraint
   - AC focuses on "produce a documented decision"

6. **Persona Coverage Matrix** -- Verify all personas have stories
   - Every Primary persona must have Must Have stories
   - Flag gaps with Q&A

For each section:
- Apply confidence markers
- Inherit confidence from epics/scope
- Create Q&A entries for ASSUMED and UNCLEAR items

**Mode 2 -- Refine:**

1. Read existing draft (baseline)
2. Read review report / user feedback
3. Run Quality Scorecard analysis
4. Present scorecard to user
5. Apply improvements:
   - Address feedback point by point
   - Resolve Q&A entries
   - Improve vague AC with specific scenarios
   - Split stories that are too large
   - Add missing edge case AC
   - Fix INVEST violations
6. Tag changes: `[UPDATED]`, `[NEW]`
7. Write to `sdlc/req/draft/userstories-v{N}.md`

### Step 5: Validate Output

Check against rules:
- Story format: "As a / I want / So that" (USR-01)
- Min 2 AC per story (USR-02, REQ-09)
- AC in Gherkin format (USR-03, REQ-03)
- Stories >8 points flagged (USR-04)
- Every story references parent epic (USR-06)
- Every story references source feature (USR-07)
- NFR stories tagged (USR-08)
- Spike stories tagged (USR-09)
- INVEST criteria checked (REQ-02)
- No implementation details (REQ-01)
- Persona coverage verified (REQ-07)
- Cross-references consistent (REQ-10)
- Approval section present

### Step 6: Readiness Assessment

Count items by confidence (each story is 1 item). Calculate verdict.

### Step 7: Output

- **Create mode**: Write to `sdlc/req/draft/userstories-draft.md`
- **Refine mode**: Write to `sdlc/req/draft/userstories-v{N}.md`

Tell the user:
> **User stories {created/refined}!**
> - Output: `sdlc/req/draft/userstories-{version}.md`
> - Readiness: {verdict}
> - Stories: {total} (Must Have: {N}, Should Have: {N}, Could Have: {N})
> - NFR stories: {N}, Spike stories: {N}
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/req-userstory-refine`
> - When satisfied, copy to `sdlc/req/final/userstories-final.md`
> - Then run `/req-backlog` to prioritize and order the product backlog

---

## Scope Rules

### This skill DOES:
- Decompose epics into implementable user stories
- Write Gherkin acceptance criteria for each story
- Apply INVEST criteria validation
- Estimate story points on Fibonacci scale
- Create NFR stories from quality attributes
- Create spike stories from high-impact risks
- Verify persona coverage

### This skill does NOT:
- Define or modify epics (belongs to `req/epic` skill)
- Prioritize the backlog or order stories (belongs to `req/backlog` skill)
- Build traceability matrix (belongs to `req/traceability` skill)
- Make technology decisions (belongs to `design/` phase)
- Define sprint plans (belongs to `impl/` phase)
- Write test cases (belongs to `test/` phase)
