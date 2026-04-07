# Output Rules -- design/database

Database-specific output constraints. These supplement the project-wide rules in `skills/shared/rules/` and phase rules in `design/shared/rules/`.

---

## Schema Rules

### DBS-01: UUID Primary Keys
Every table MUST have a UUID primary key (column named `id`).
Exception: internal join tables may use auto-increment if justified in a Q&A entry.

### DBS-02: Timestamp Columns
Every table MUST have `created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()` and `updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()` columns.

### DBS-03: ON DELETE Behavior
Every foreign key MUST specify ON DELETE behavior: `CASCADE`, `SET NULL`, or `RESTRICT`.
Include a brief justification for the chosen behavior.

### DBS-04: Story Traceability
Every table MUST reference which user stories (US-xxx) it supports.
If a table exists for technical reasons only (e.g., audit_logs), reference the quality attribute or requirement that drives it.

### DBS-05: Column Completeness
Every column MUST specify:
- Type (PostgreSQL type or equivalent)
- Constraints (PK, FK, UNIQUE, NOT NULL, CHECK)
- Description (what the column represents)

Default values SHOULD be specified where applicable.

### DBS-06: Index Coverage
Indexes MUST be specified for:
- All FK columns
- Columns used in WHERE clauses
- Columns used in JOIN conditions
- Columns used in ORDER BY clauses

### DBS-07: Index Justification
Every index entry MUST include a justification stating which queries or use cases benefit from the index.

### DBS-08: Explicit Enum Values
ENUM types MUST list all values explicitly in the Enum Definitions section.
Each enum MUST specify which table.column uses it.

---

## Security Rules

### DBS-09: PII Flagging
Columns containing Personally Identifiable Information MUST be flagged with the `[PII]` tag in their description.
Examples: email, phone number, full name, address, date of birth.

### DBS-10: Encryption Flagging
Columns requiring encryption at rest MUST be flagged with the `[ENCRYPTED]` tag in their description.
Examples: auth tokens, API secrets, webhook secrets, SSN, payment data.

---

## Format Rules

### DBS-11: ERD Diagram Required
The output MUST include an ERD diagram using Mermaid `erDiagram` syntax (DES-08).
The ERD MUST show all entities, relationships, and key attributes.

### DBS-12: Entity Name Consistency
Entity/table names MUST match the data entities identified in architecture-final.md (DES-06).
If a table name differs from the architecture entity name, explain the mapping in a Q&A entry.

### DBS-13: Section Order
Database output MUST follow this section order:
1. ERD Overview
2. Table Specifications
3. Enum Definitions
4. Migration Strategy
5. Data Security
6. Performance Considerations
7. Q&A Log
8. Readiness Assessment
9. Approval

Do not add, remove, or reorder sections.

### DBS-14: Confidence Markers
Every table MUST have a confidence marker (✅ CONFIRMED / 🔶 ASSUMED / ❓ UNCLEAR).
Confidence is inherited from source stories when available, or assessed based on available information.

### DBS-15: MVP Identification
MVP tables MUST be identified with `**MVP**: Yes`.
Non-MVP tables MUST be tagged with `[FUTURE]` in their heading and `**MVP**: No`.

---

## Refine Mode Rules

### DBS-16: Quality Scorecard First
In refine mode, BEFORE applying changes, generate a Quality Scorecard covering:
- Completeness: Are all architecture entities represented as tables?
- Index coverage: Do all FK and query columns have indexes?
- FK coverage: Do all relationships specify ON DELETE behavior?
- Traceability: Does every table trace to user stories?
- Security: Are PII and encrypted columns flagged?

Present this scorecard to the user before asking what to improve.

### DBS-17: TBD Reduction Target
Each refine round should aim to reduce [TBD] count by at least 30%.
If no TBDs were resolved, flag this in the Diff Summary.

### DBS-18: Confidence Item Counting
The Readiness Assessment MUST count items from these sections:
- Each table is 1 item
- Each relationship (FK) is 1 item
- Each enum definition is 1 item

Indexes and migration ordering are structural -- not counted.
