---
name: design-stack
description: >
  Create or refine a technology stack selection document. Evaluates and selects
  technologies for frontend, backend, database, infrastructure, and supporting
  services using weighted decision matrices. Every choice is justified with
  scored alternatives.
  ONLY activated by command: `/design-stack`. Use `--create`, `--refine`, or `--score` to set mode.
  NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine|--score"
version: "1.0"
category: sdlc
phase: design
prev_phase: req-traceability
next_phase: design-arch
---

# Tech Stack Selection Skill

## Purpose

Create or refine a technology stack document (`tech-stack-draft.md`) that selects and justifies technologies for ALL categories needed by the project. Each technology choice is backed by a weighted decision matrix with scored alternatives.

The tech stack bridges "what we need to build" (requirements) and "how we will build it" (architecture).

---

## Three Modes

### Mode 1: Create (`--create`)

Generate a tech stack selection from init and req artifacts.

| Input | Required | Source |
|-------|----------|--------|
| Scope (final) | Yes | `sdlc/init/final/scope-final.md` or user-specified path |
| Charter (final) | Yes | `sdlc/init/final/charter-final.md` or user-specified path |
| User stories (final) | No | `sdlc/req/final/userstories-final.md` — technical ACs inform criteria |
| Risk register (final) | No | `sdlc/init/final/risk-register-final.md` — technical risks to mitigate |

### Mode 2: Refine (`--refine`)

Improve existing tech stack based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing tech stack draft | Yes | `sdlc/design/draft/tech-stack-draft.md` or `sdlc/design/draft/tech-stack-v{N}.md` |
| Review report / feedback | Yes | User provides directly or as `sdlc/design/input/review-report.md` |
| Additional details | No | New information the user wants to add |

### Mode 3: Score (`--score`)

Evaluate artifact quality with a detailed scoreboard.

| Input | Required | Source |
|-------|----------|--------|
| Artifact to score | Yes | `sdlc/design/draft/tech-stack-draft.md` or latest `tech-stack-v{N}.md` or `sdlc/design/final/tech-stack-final.md`, or user-specified path |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `tech-stack-draft.md` | `sdlc/design/draft/` |
| Refine | `tech-stack-v{N}.md` | `sdlc/design/draft/` (N = next version number) |
| Score | `tech-stack-scoreboard.md` | `sdlc/design/draft/` |

When user is satisfied -> they copy from `sdlc/design/draft/` to `sdlc/design/final/tech-stack-final.md`.

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

1. `skills/shared/rules/doc-standards.md` -- document formatting standards
2. `skills/shared/rules/quality-rules.md` -- confidence marking, readiness assessment
3. `skills/shared/rules/output-rules.md` -- versioning, input resolution, diff summary
4. `design/shared/rules/design-rules.md` -- design phase rules
5. `design/shared/templates/tech-stack/decision-matrix-template.md` -- decision matrix format
6. `design/tech-stack/knowledge/technology-evaluation-guide.md` -- evaluation techniques
7. `design/tech-stack/rules/output-rules.md` -- tech-stack-specific output rules
8. `design/tech-stack/templates/output-template.md` -- expected output structure
For Mode 3 (Score): Read resources listed in `skills/shared/knowledge/score-workflow.md`

### Step 3: Resolve Input

Resolve inputs per `skills/shared/knowledge/input-resolution-workflow.md`.

**Create mode inputs:**

| Input | Required | Default Path | Fallback |
|-------|----------|-------------|----------|
| scope-final.md | Yes | `sdlc/init/final/` | "No scope found. Please provide a path or run /init-scope first." |
| charter-final.md | Yes | `sdlc/init/final/` | "No charter found. Please provide a path or run /init-charter first." |
| userstories-final.md | No | `sdlc/req/final/` | Proceed without user stories |
| risk-register-final.md | No | `sdlc/init/final/` | Proceed without risk register |

**Refine mode inputs:**

| Input | Required | Source |
|-------|----------|--------|
| Existing draft | Yes | `sdlc/design/draft/tech-stack-draft.md` or latest `tech-stack-v{N}.md` |
| Review feedback | Yes | User message or `sdlc/design/input/review-report.md` |

### Step 4: Generate (Mode-specific)

**Mode 1 -- Create:**

Work through the tech stack document **section by section, incrementally**:

1. **Technology Categories** -- Identify what categories need decisions
   - Standard categories: backend language, backend framework, frontend framework, database (primary), database (cache), message queue, cloud/hosting, CI/CD, monitoring, authentication
   - Check scope for additional categories (e.g., search engine, CDN, file storage, email service)
   - Check integrations (INT-xxx) for mandated technology decisions
   - Present proposed categories to user before proceeding

2. **Decision Matrices** -- For each category, build a weighted decision matrix
   - Use `decision-matrix-template.md` format
   - Derive criteria weights from quality attributes (QA-xxx) and constraints (CON-xxx)
   - Evaluate at least 2 alternatives per category
   - Score each option 1-5 against each criterion
   - Calculate weighted totals
   - Document rationale for the winner

3. **Selected Stack Summary** -- Table of all selected technologies
   - Technology name, version, license, category, 1-line rationale
   - Distinguish MVP stack from full stack if they differ

4. **Integration Compatibility** -- Verify selected technologies work together
   - Build compatibility matrix (technology vs technology)
   - Flag any known incompatibilities or plugin requirements
   - Note ORM/driver selections that bridge technologies

5. **Risk Assessment** -- Technical risks from stack choices
   - Version lock-in risks
   - Learning curve risks (team has no experience)
   - Licensing risks (GPL contamination, proprietary costs)
   - Vendor lock-in risks (cloud-specific services)
   - Security risks (CVE history)

6. **Version & Upgrade Strategy** -- Dependency management approach
   - LTS preferences for each technology
   - Upgrade cadence (quarterly, semesterly)
   - Security patching policy
   - Dependency management tooling

7. **Budget Impact** -- Cost analysis
   - Free/open-source vs paid licensing
   - Cloud infrastructure estimates
   - SaaS subscription costs
   - Total estimated annual cost

For each section:
- Apply confidence markers (CONFIRMED / ASSUMED / UNCLEAR)
- Inherit confidence from scope/charter where applicable
- Create Q&A entries for ASSUMED and UNCLEAR items
- Present section to user before moving to next

**Mode 2 -- Refine:**

1. Read existing tech stack draft (baseline)
2. Read review report / user feedback
3. Run Quality Scorecard analysis:
   - Completeness: Are all required categories covered? All matrices present?
   - Justification: Do all decisions have weighted matrices with >=2 alternatives?
   - Traceability: Do criteria weights trace to QA-xxx / CON-xxx?
   - Compatibility: Is the compatibility matrix complete?
   - Risk coverage: Are team expertise gaps flagged?
   - Budget: Are costs estimated?
4. Present scorecard to user
5. Apply improvements:
   - Address user feedback point by point
   - Resolve Q&A entries from previous version
   - Upgrade confidence levels where possible
   - Re-score matrices if new information changes weights
   - Update compatibility matrix if technologies changed
6. Tag all changes: `[UPDATED]` for modified items, `[NEW]` for additions
7. Preserve CONFIRMED items unless user explicitly contradicts them
8. Write improved version to `sdlc/design/draft/tech-stack-v{N}.md`

**Mode 3 -- Score:**

Follow the standard score workflow in `skills/shared/knowledge/score-workflow.md` using this skill's rules and templates as context.

### Step 5: Validate Output

Check against rules:
- Every technology has a decision matrix with >=2 alternatives (TSK-01, DES-01)
- Criteria weights trace to quality attributes or constraints (TSK-02, DES-02)
- Every technology specifies exact version or version range (TSK-03)
- License type specified for every technology (TSK-04)
- Security assessment present for every technology (TSK-05)
- Compatibility matrix verifies no conflicts (TSK-06)
- All integrations from scope addressed (TSK-07)
- Section order matches template (TSK-08)
- ID prefixes correct: DM- for matrices, TSK-RISK- for risks (TSK-09)
- Confidence markers on every decision (TSK-10, CR-01)
- Zero-experience technologies flagged as risks (TSK-12)
- Budget impact calculated (TSK-13)
- MVP stack identified if different from full stack (TSK-14, DES-12)
- Security addressed (DES-07)
- Approval section present (DES-11)

### Step 6: Readiness Assessment

Generate assessment per `skills/shared/templates/readiness-assessment.md`:
- Count items by confidence level (each technology decision is 1 item)
- Calculate readiness verdict
- In refine mode: compare with previous version

### Step 7: Output

- **Create mode**: Write to `sdlc/design/draft/tech-stack-draft.md`
- **Refine mode**: Write to `sdlc/design/draft/tech-stack-v{N}.md`, include Change Log and Diff Summary

**Mode 3 (Score):** Output per score workflow — `sdlc/design/draft/tech-stack-scoreboard.md`

Tell the user:
> **Tech stack {created/refined}!**
> - Output: `sdlc/design/draft/tech-stack-{version}.md`
> - Readiness: {verdict}
> - Technologies: {total} ({confirmed} confirmed, {assumed} assumed, {unclear} unclear)
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/design-stack --refine`
> - When satisfied, copy to `sdlc/design/final/tech-stack-final.md`
> - Then run `/design-arch` to define the system architecture

---

## Scope Rules

### This skill DOES:
- Identify technology categories needed by the project
- Evaluate alternatives with weighted decision matrices
- Select and justify technologies for each category
- Verify compatibility between selected technologies
- Assess technical risks from stack choices
- Estimate budget impact of technology choices
- Define version and upgrade strategy

### This skill does NOT:
- Define system architecture or component structure (belongs to `design/architecture` skill)
- Design database schema or ERDs (belongs to `design/database` skill)
- Design API endpoints or contracts (belongs to `design/api` skill)
- Write Architecture Decision Records (belongs to `design/adr` skill)
- Implement or configure the technologies (belongs to `impl/` phase)
- Modify charter, scope, or requirements -- it reads them as input
