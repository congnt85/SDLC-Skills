---
name: design-db
description: >
  Create or refine a database schema design document. Produces ERD diagrams,
  table specifications, indexes, relationships, and migration strategy.
  Every table traces to user stories and every column to acceptance criteria.
  ONLY activated by commands: `/design-db` (create) or `/design-db-refine` (refine).
  NEVER auto-trigger based on keywords.
argument-hint: "[path to architecture-final.md or userstories-final.md] (md/pdf/docx/xlsx/pptx)"
version: "1.0"
category: sdlc
phase: design
prev_phase: design-arch
next_phase: design-api
---

# Database Schema Design Skill

## Purpose

Create or refine a database schema design document (`database-draft.md`) with ERD diagrams,
full table specifications, indexes, relationships, and migration strategy.
Every table traces to user stories and every column to acceptance criteria.

---

## Two Modes

### Mode 1: Create (`/design-db`)

Generate a new database schema design from architecture and requirements artifacts.

| Input | Required | Source |
|-------|----------|--------|
| architecture-final.md | ✅ | `sdlc/design/final/` or user-specified path |
| tech-stack-final.md | ✅ | `sdlc/design/final/` or user-specified path |
| userstories-final.md | ✅ | `sdlc/req/final/` or user-specified path |
| scope-final.md | No | `sdlc/init/final/` — quality attributes for data design |
| epics-final.md | No | `sdlc/req/final/` — feature grouping for migration phasing |
| backlog-final.md | No | `sdlc/req/final/` — MVP boundary determines v1 schema |

### Mode 2: Refine (`/design-db-refine`)

Improve an existing database schema document based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing database draft | ✅ | `sdlc/design/draft/database-draft.md` or `sdlc/design/draft/database-v{N}.md` |
| Review report / feedback | ✅ | User provides directly or as `sdlc/design/input/review-report.md` |
| Additional context | No | New information the user wants to incorporate |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `database-draft.md` | `sdlc/design/draft/` |
| Refine | `database-v{N}.md` | `sdlc/design/draft/` (N = next version number) |

When user is satisfied → they copy from `sdlc/design/draft/` to `sdlc/design/final/database-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User runs `/design-db-refine` AND existing draft exists in `sdlc/design/draft/` → **Mode 2 (Refine)**
- User runs `/design-db` → **Mode 1 (Create)**
- User runs `/design-db` but draft already exists → Ask: "A draft already exists. Create new (overwrite) or refine existing?"

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md` — document formatting standards
2. `skills/shared/rules/quality-rules.md` — confidence marking, readiness assessment
3. `skills/shared/rules/output-rules.md` — versioning, input resolution, diff summary
4. `design/shared/rules/design-rules.md` — design phase rules
5. `design/shared/templates/database/erd-template.md` — ERD diagram syntax reference
6. `design/database/knowledge/database-design-guide.md` — database design techniques
7. `design/database/rules/output-rules.md` — database-specific output rules
8. `design/database/templates/output-template.md` — expected output structure

### Step 3: Resolve Input

**File Type Conversion** (applies to all file inputs):

Before reading any input file, check its extension:
- `.md` → Read directly, no conversion needed
- `.pdf` → Run `/read-pdf <path> sdlc/design/input/` → read the converted .md
- `.docx` / `.doc` → Run `/read-word <path> sdlc/design/input/` → read the converted .md
- `.xlsx` / `.xls` → Run `/read-excel <path> sdlc/design/input/` → read the converted .md
- `.pptx` / `.ppt` → Run `/read-ppt <path> sdlc/design/input/` → read the converted .md

Converted files are saved to `sdlc/design/input/`. If a converted .md already exists and is newer than the source, skip conversion.

**Mode 1 (Create):**

```
For architecture-final.md (REQUIRED):
1. User specified path? → Read it, copy to sdlc/design/input/
2. Exists in sdlc/design/input/architecture-final.md? → Read it
3. Exists in sdlc/design/final/architecture-final.md? → Read it, copy to sdlc/design/input/
4. Not found? → FAIL: "No architecture document found. Run /design-arch first."

For tech-stack-final.md (REQUIRED):
1. User specified path? → Read it, copy to sdlc/design/input/
2. Exists in sdlc/design/input/tech-stack-final.md? → Read it
3. Exists in sdlc/design/final/tech-stack-final.md? → Read it, copy to sdlc/design/input/
4. Not found? → FAIL: "No tech stack document found. Run /design-stack first."

For userstories-final.md (REQUIRED):
1. User specified path? → Read it, copy to sdlc/design/input/
2. Exists in sdlc/design/input/userstories-final.md? → Read it
3. Exists in sdlc/req/final/userstories-final.md? → Read it, copy to sdlc/design/input/
4. Not found? → FAIL: "No user stories document found. Run /req-userstory first."

For optional inputs (scope, epics, backlog):
1. Check sdlc/design/input/ folder first
2. Check respective final/ folders (sdlc/init/final/, sdlc/req/final/)
3. If found → copy to sdlc/design/input/ for traceability
4. If not found → proceed without, note missing context in Q&A
```

**Mode 2 (Refine):**

```
For database draft:
1. User specified path? → Read it, copy to sdlc/design/input/
2. Exists in sdlc/design/input/? → Read it
3. Exists in sdlc/design/draft/ (latest version)? → Read it, copy to sdlc/design/input/
4. Not found? → FAIL: "No existing database document found. Run /design-db first."

For review report:
1. User provided feedback directly in message? → Save to sdlc/design/input/review-report.md
2. User specified path? → Read it, copy to sdlc/design/input/
3. Exists in sdlc/design/input/review-report.md? → Read it
4. Not found? → Ask: "What feedback do you have on the current database design?"
```

### Step 4: Generate (Mode-specific)

**Mode 1 — Create:**

Work through the database design document **section by section**:

1. **Entity Identification** — Extract data entities from architecture components and user stories. Scan stories for nouns (entities) and verbs (relationships). Map acceptance criteria fields to columns. List entities with source references (US-xxx, component names).
   - Present entity list to user for confirmation before proceeding
   - Ask: "Are there any entities I've missed or any that should be merged/split?"

2. **ERD Diagram** — Full Mermaid erDiagram with all entities, relationships, and key attributes. Use standard cardinality notation. Present to user before detailing table specs.
   - Ask: "Does this relationship model look correct?"

3. **Table Specifications** — For each table, specify:
   - Columns: name, type, constraints, default, description, source story (US-xxx)
   - Indexes: name, columns, type (B-tree/GIN/etc), justification (which queries benefit)
   - Relationships: FK column, references, ON DELETE behavior, description
   - Apply UUID primary keys (DBS-01), created_at/updated_at (DBS-02)
   - Flag PII columns with [PII] tag (DBS-09), encrypted columns with [ENCRYPTED] tag (DBS-10)
   - Mark MVP vs [FUTURE] tables (DBS-15)

4. **Enum Definitions** — All ENUM types with their values explicitly listed and which table.column uses them (DBS-08).

5. **Data Migration Strategy** — Migration ordering respecting FK dependencies (topological sort). Base tables first, dependent tables next, join tables last. Seed data needs with purpose. Migration tooling from tech-stack.

6. **Data Security** — Columns requiring encryption, PII identification, access control notes. Classification: PII / Sensitive / Public. Protection: Encryption / Hash / Mask.

7. **Performance Considerations** — Indexing strategy summary, partitioning needs, read replica candidates, connection pooling, caching layer interaction with architecture.

For each section:
- Apply confidence markers (✅ CONFIRMED / 🔶 ASSUMED / ❓ UNCLEAR)
- Create Q&A entries for ASSUMED and UNCLEAR items
- Present section to user before moving to next

**Mode 2 — Refine:**

1. Read existing database draft (baseline)
2. Read review report / user feedback
3. Run Quality Scorecard analysis (completeness, table coverage, index coverage, FK coverage, traceability)
4. Present scorecard to user: "Here's what I found in the current database design..."
5. Apply improvements:
   - Address user feedback point by point
   - Resolve Q&A entries from previous version
   - Upgrade confidence levels where possible (🔶→✅, ❓→🔶)
   - Add missing indexes, constraints, or relationships
   - Proactively suggest improvements for weak areas
6. Tag all changes: `[UPDATED]` for modified items, `[NEW]` for additions
7. Preserve CONFIRMED items unless user explicitly contradicts them
8. Write improved version to `sdlc/design/draft/database-v{N}.md`

### Step 5: Validate Output

Check against rules:
- Every table has UUID PK (DBS-01)
- Every table has created_at and updated_at (DBS-02)
- Every FK specifies ON DELETE behavior (DBS-03)
- Every table references source user stories (DBS-04)
- Every column has type, constraints, description (DBS-05)
- FK columns and query columns have indexes (DBS-06)
- Index entries include justification (DBS-07)
- ENUM values listed explicitly (DBS-08)
- PII columns flagged (DBS-09)
- Encrypted columns flagged (DBS-10)
- ERD diagram present in Mermaid (DBS-11, DES-08)
- Entity names match architecture components (DBS-12, DES-06)
- Correct section order (DBS-13)
- Confidence markers on every table (DBS-14)
- MVP tables identified, non-MVP tagged [FUTURE] (DBS-15)
- Traces to requirements (DES-02)
- Consistency across artifacts (DES-06)
- Standard notations used (DES-04)
- Quality attributes addressed (DES-10)

### Step 6: Readiness Assessment

Generate assessment per `skills/shared/templates/readiness-assessment.md`:
- Count items by confidence level (each table = 1 item, each relationship = 1 item)
- Calculate readiness verdict
- In refine mode: compare with previous version

### Step 7: Output

- **Create mode**: Write to `sdlc/design/draft/database-draft.md`
- **Refine mode**: Write to `sdlc/design/draft/database-v{N}.md`, include Change Log and Diff Summary

Tell the user:
> **Database schema {created/refined}!**
> - Output: `sdlc/design/draft/database-{version}.md`
> - Tables: {N} (MVP: {M}, Future: {F})
> - Readiness: {verdict}
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/design-db-refine`
> - When satisfied, copy to `sdlc/design/final/database-final.md`
> - Then run `/design-api` (if not done) or `/design-adr`

---

## Scope Rules

### This skill DOES:
- Design database schema with ERD diagrams in Mermaid notation
- Specify full table definitions (columns, types, constraints, defaults)
- Define indexes with justification for each
- Specify foreign key relationships with ON DELETE behaviors
- Create migration strategy with dependency ordering
- Identify PII and encryption requirements
- Document performance considerations (partitioning, replicas, pooling)
- Trace every table to user stories and every column to acceptance criteria
- Apply confidence marking to every table and relationship

### This skill does NOT:
- Select database technology (belongs to `design-stack` skill)
- Define system architecture or components (belongs to `design-arch` skill)
- Design API endpoints or contracts (belongs to `design-api` skill)
- Write Architecture Decision Records (belongs to `design-adr` skill)
- Implement migration scripts (belongs to `impl` phase)
- Define backup/recovery procedures (belongs to `ops` phase)
- Design monitoring or alerting (belongs to `ops` phase)
