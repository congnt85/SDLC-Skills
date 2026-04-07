---
name: design-arch
description: >
  Create or refine a system architecture document using C4 model diagrams.
  Defines system context, containers, components, and key workflows using
  Mermaid notation. Maps quality attributes to architectural decisions.
  ONLY activated by commands: `/design-arch` (create) or `/design-arch-refine` (refine).
  NEVER auto-trigger based on keywords.
argument-hint: "[path to tech-stack-final.md or scope-final.md]"
version: "1.0"
category: sdlc
phase: design
prev_phase: design-stack
next_phase: design-db
---

# System Architecture Skill

## Purpose

Create or refine a system architecture document (`architecture-draft.md`) using C4 model diagrams.
Defines system context, containers, components, and key workflows. Maps quality attributes
from scope to concrete architectural patterns and decisions.

---

## Two Modes

### Mode 1: Create (`/design-arch`)

Generate a new architecture document from tech stack and scope artifacts.

| Input | Required | Source |
|-------|----------|--------|
| tech-stack-final.md | ✅ | `design/final/` or user-specified path |
| scope-final.md | ✅ | `init/final/` or user-specified path |
| charter-final.md | No | `init/final/` — constraints, team structure |
| epics-final.md | No | `req/final/` — epic structure for architecture phasing |
| userstories-final.md | No | `req/final/` — stories drive component design |
| backlog-final.md | No | `req/final/` — MVP boundary for v1 architecture scope |
| risk-register-final.md | No | `init/final/` — technical/integration risks |

### Mode 2: Refine (`/design-arch-refine`)

Improve an existing architecture document based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing architecture draft | ✅ | `draft/architecture-draft.md` or `draft/architecture-v{N}.md` |
| Review report / feedback | ✅ | User provides directly or as `input/review-report.md` |
| Additional context | No | New information the user wants to incorporate |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `architecture-draft.md` | `draft/` |
| Refine | `architecture-v{N}.md` | `draft/` (N = next version number) |

When user is satisfied → they copy from `draft/` to `design/final/architecture-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User runs `/design-arch-refine` AND existing draft exists in `draft/` → **Mode 2 (Refine)**
- User runs `/design-arch` → **Mode 1 (Create)**
- User runs `/design-arch` but draft already exists → Ask: "A draft already exists. Create new (overwrite) or refine existing?"

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md` — document formatting standards
2. `skills/shared/rules/quality-rules.md` — confidence marking, readiness assessment
3. `skills/shared/rules/output-rules.md` — versioning, input resolution, diff summary
4. `design/shared/rules/design-rules.md` — design phase rules
5. `design/shared/templates/architecture/c4-diagram-template.md` — C4 diagram syntax reference
6. `design/architecture/knowledge/c4-modeling-guide.md` — C4 modeling techniques
7. `design/architecture/rules/output-rules.md` — architecture-specific output rules
8. `design/architecture/templates/output-template.md` — expected output structure

### Step 3: Resolve Input

**Mode 1 (Create):**

```
For tech-stack-final.md (REQUIRED):
1. User specified path? → Read it, copy to input/
2. Exists in input/tech-stack-final.md? → Read it
3. Exists in design/final/tech-stack-final.md? → Read it, copy to input/
4. Not found? → FAIL: "No tech stack document found. Run /design-stack first."

For scope-final.md (REQUIRED):
1. User specified path? → Read it, copy to input/
2. Exists in input/scope-final.md? → Read it
3. Exists in init/final/scope-final.md? → Read it, copy to input/
4. Not found? → FAIL: "No scope document found. Run /init-scope first."

For optional inputs (charter, epics, userstories, backlog, risk-register):
1. Check input/ folder first
2. Check respective final/ folders (init/final/, req/final/)
3. If found → copy to input/ for traceability
4. If not found → proceed without, note missing context in Q&A
```

**Mode 2 (Refine):**

```
For architecture draft:
1. User specified path? → Read it, copy to input/
2. Exists in input/? → Read it
3. Exists in draft/ (latest version)? → Read it, copy to input/
4. Not found? → FAIL: "No existing architecture document found. Run /design-arch first."

For review report:
1. User provided feedback directly in message? → Save to input/review-report.md
2. User specified path? → Read it, copy to input/
3. Exists in input/review-report.md? → Read it
4. Not found? → Ask: "What feedback do you have on the current architecture?"
```

### Step 4: Generate (Mode-specific)

**Mode 1 — Create:**

Work through the architecture document **section by section**:

1. **Architecture Overview** — Determine architecture style (monolith, modular monolith, microservices, serverless, hybrid). Justify based on team size (CON-xxx), timeline, scalability targets (QA-xxx), and complexity. Present to user for confirmation.

2. **System Context (C4 Level 1)** — Identify all actors from scope personas and external systems from scope integrations (INT-xxx). Draw C4Context diagram in Mermaid. Show what data flows between actors/externals and the system.
   - Ask: "Are there any external systems or actors I've missed?"

3. **Container Diagram (C4 Level 2)** — Decompose system into deployable units. Map each container to a technology from tech-stack-final.md. Show communication protocols (REST, WebSocket, SQL, AMQP, etc.).
   - Present container list to user before diagramming

4. **Component Diagrams (C4 Level 3)** — For containers with >3 internal modules, show internal structure. Use patterns: Controller-Service-Repository, MVC, CQRS as appropriate.
   - Only diagram containers that warrant decomposition

5. **Sequence Diagrams** — Identify key workflows from user stories that cross >=3 participants. Minimum 2 sequence diagrams for MVP workflows. Show happy path, note error paths.
   - Ask: "Which workflows are most critical to visualize?"

6. **Quality Attribute Mapping** — Map EVERY QA-xxx from scope to specific architectural responses. Show which components implement each quality attribute. Use concrete patterns (caching, circuit breakers, etc.).

7. **Deployment Overview** — High-level deployment topology: environments, scaling approach, key infrastructure. NOT full deployment design (that belongs to deploy phase).

8. **Architecture Principles** — Document key principles driving decisions (API-first, event-driven, modular monolith, cache-first, etc.). Include rationale and implications.

For each section:
- Apply confidence markers (✅ CONFIRMED / 🔶 ASSUMED / ❓ UNCLEAR)
- Create Q&A entries for ASSUMED and UNCLEAR items
- Present section to user before moving to next

**Mode 2 — Refine:**

1. Read existing architecture draft (baseline)
2. Read review report / user feedback
3. Run Quality Scorecard analysis (completeness, diagram coverage, QA mapping, traceability)
4. Present scorecard to user: "Here's what I found in the current architecture..."
5. Apply improvements:
   - Address user feedback point by point
   - Resolve Q&A entries from previous version
   - Upgrade confidence levels where possible (🔶→✅, ❓→🔶)
   - Improve diagrams based on feedback
   - Proactively suggest improvements for weak areas
6. Tag all changes: `[UPDATED]` for modified items, `[NEW]` for additions
7. Preserve CONFIRMED items unless user explicitly contradicts them
8. Write improved version to `draft/architecture-v{N}.md`

### Step 5: Validate Output

Check against rules:
- C4 Level 1 (System Context) diagram present (ARC-01)
- C4 Level 2 (Container) diagram with technology labels (ARC-02)
- C4 Level 3 for containers with >3 modules (ARC-03)
- Sequence diagrams for workflows with >3 participants (ARC-04)
- All diagrams use Mermaid syntax (ARC-05)
- Every container maps to tech-stack-final.md (ARC-06)
- Every external system maps to scope INT-xxx (ARC-07)
- QA mapping addresses ALL QA-xxx from scope (ARC-08)
- MVP vs FUTURE scope distinguished (ARC-09)
- Correct section order (ARC-10)
- Entity names consistent for downstream DB/API design (ARC-11)
- Confidence markers on every decision (ARC-12)
- At least 2 MVP sequence diagrams (ARC-14)
- Traces to requirements (DES-02)
- Quality attributes drive architecture (DES-03)
- Standard notations used (DES-04)
- Consistency across artifacts (DES-06)
- Mermaid diagrams required (DES-08)

### Step 6: Readiness Assessment

Generate assessment per `skills/shared/templates/readiness-assessment.md`:
- Count items by confidence level
- Calculate readiness verdict
- In refine mode: compare with previous version

### Step 7: Output

- **Create mode**: Write to `draft/architecture-draft.md`
- **Refine mode**: Write to `draft/architecture-v{N}.md`, include Change Log and Diff Summary

Tell the user:
> **Architecture {created/refined}!**
> - Output: `draft/architecture-{version}.md`
> - Readiness: {verdict}
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/design-arch-refine`
> - When satisfied, copy to `design/final/architecture-final.md`
> - Then run `/design-db` and `/design-api` (can run in parallel)

---

## Scope Rules

### This skill DOES:
- Define system architecture via C4 model diagrams (Context, Container, Component)
- Create sequence diagrams for key workflows
- Map quality attributes to architectural patterns and components
- Document architecture style decisions with justification
- Provide high-level deployment overview
- Document architecture principles driving decisions
- Apply confidence marking to every architectural decision

### This skill does NOT:
- Select technologies (belongs to `design-stack` skill)
- Design database schema or ERDs (belongs to `design-db` skill)
- Design API endpoints or contracts (belongs to `design-api` skill)
- Write Architecture Decision Records (belongs to `design-adr` skill)
- Define deployment pipelines or CI/CD (belongs to `deploy` phase)
- Define monitoring or alerting (belongs to `ops` phase)
- Make requirements decisions (belongs to `req` phase)
