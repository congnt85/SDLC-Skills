# Database Schema Design — {Project Name}

**Version**: draft | v{N}
**Date**: {date}
**Database**: {technology from tech-stack}
**ORM**: {if applicable}
**Status**: Draft | Under Review | Approved

---

## 1. ERD Overview

```mermaid
erDiagram
    {ENTITY_A} ||--o{ {ENTITY_B} : "{relationship}"
    {ENTITY_A} ||--|| {ENTITY_C} : "{relationship}"

    {ENTITY_A} {
        uuid id PK
        string name
        timestamp created_at
        timestamp updated_at
    }

    {ENTITY_B} {
        uuid id PK
        uuid entity_a_id FK
        string field1
        enum status
        timestamp created_at
        timestamp updated_at
    }
```

---

## 2. Table Specifications

### 2.1 {table_name}

**Source Stories**: US-xxx, US-xxx
**MVP**: Yes / No
**Confidence**: ✅ CONFIRMED / 🔶 ASSUMED / ❓ UNCLEAR

| Column | Type | Constraints | Default | Description | Source |
|--------|------|-------------|---------|-------------|--------|
| id | UUID | PK, NOT NULL | gen_random_uuid() | Primary key | — |
| {col} | {type} | {constraints} | {default} | {desc} | US-xxx |
| created_at | TIMESTAMPTZ | NOT NULL | NOW() | Record creation time | — |
| updated_at | TIMESTAMPTZ | NOT NULL | NOW() | Last modification time | — |

**Indexes**:

| Name | Columns | Type | Justification |
|------|---------|------|---------------|
| idx_{table}_{col} | {col} | B-tree / GIN / UNIQUE | {which queries benefit} |

**Relationships**:

| Column | References | ON DELETE | Description |
|--------|-----------|-----------|-------------|
| {fk_col} | {table}.id | CASCADE / SET NULL / RESTRICT | {desc} |

### 2.2 {next_table}

{Repeat the same structure for each table}

---

## 3. Enum Definitions

| Enum Name | Values | Used By |
|-----------|--------|---------|
| {enum_name} | val1, val2, val3 | {table.column} |

---

## 4. Migration Strategy

**Migration Tool**: {tool from tech-stack, e.g., Prisma Migrate, Flyway, Alembic}

**Ordering** (topological sort by FK dependencies):

| Order | Table | Dependencies | Notes |
|-------|-------|-------------|-------|
| 1 | {table} | — | Base table, no dependencies |
| 2 | {table} | {table} | Depends on {table} |
| ... | ... | ... | ... |

**Seed Data**:

| Table | Seed Data | Purpose | Environment |
|-------|-----------|---------|-------------|
| {table} | {description} | {why needed} | All / Dev only / Test only |

---

## 5. Data Security

| Table | Column | Classification | Protection | Notes |
|-------|--------|---------------|------------|-------|
| {table} | {col} | PII / Sensitive / Public | Encryption / Hash / Mask | {additional notes} |

---

## 6. Performance Considerations

| Concern | Table(s) | Strategy | Trigger | MVP |
|---------|----------|----------|---------|-----|
| {concern} | {tables} | {strategy} | {when to implement} | Yes / [FUTURE] |

---

## 7. Q&A Log

| ID | Question | Context | Answer | Impact | Status |
|----|----------|---------|--------|--------|--------|
| Q-001 | {question} | {context} | {answer or TBD} | HIGH / MEDIUM / LOW | Open / Resolved |

---

## 8. Readiness Assessment

### Item Counts

| Confidence | Count | Percentage |
|------------|-------|------------|
| ✅ CONFIRMED | {n} | {%} |
| 🔶 ASSUMED | {n} | {%} |
| ❓ UNCLEAR | {n} | {%} |
| **Total** | {n} | 100% |

### Verdict: {READY / PARTIALLY READY / NOT READY}

{Justification for verdict based on confidence distribution}

---

## 9. Approval

| Role | Name | Date | Verdict |
|------|------|------|---------|
| Tech Lead | | | |
| Backend Lead | | | |
| DBA / Data Engineer | | | |
