# Entity-Relationship Diagram Template

Standard format for database design using Mermaid ERD notation.

---

## ERD Diagram

```mermaid
erDiagram
    {ENTITY_A} ||--o{ {ENTITY_B} : "{relationship}"
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
    }
```

---

## Relationship Notation

| Symbol | Meaning |
|--------|---------|
| `\|\|--o{` | One to many (required) |
| `\|\|--\|\|` | One to one |
| `o{--o{` | Many to many (via join table) |
| `\|o--o{` | Zero or one to many |

---

## Table Specification

```markdown
### {Table Name}

| Column | Type | Constraints | Description | Source Story |
|--------|------|-------------|-------------|-------------|
| id | UUID | PK | Primary key | — |
| {column} | {type} | {PK/FK/UNIQUE/NOT NULL} | {description} | US-{NNN} |
| created_at | TIMESTAMP | NOT NULL, DEFAULT NOW | Record creation time | — |
| updated_at | TIMESTAMP | NOT NULL | Last modification time | — |

**Indexes**:
- `idx_{table}_{column}` on `{column}` — {reason}

**Relationships**:
- `{column}` → `{other_table}.id` (FK, ON DELETE {CASCADE/SET NULL/RESTRICT})
```

---

## Common Column Types

| Type | Usage |
|------|-------|
| UUID | Primary keys, foreign keys |
| VARCHAR(N) | Short text with known max length |
| TEXT | Long text, no length limit |
| INTEGER | Counts, quantities |
| BIGINT | Large numbers, timestamps as epoch |
| BOOLEAN | True/false flags |
| TIMESTAMP | Date/time with timezone |
| JSONB | Flexible schema data (PostgreSQL) |
| ENUM | Fixed set of values (status, type) |

---

## Rules

- Every table MUST have a primary key (prefer UUID over auto-increment)
- Every table MUST have `created_at` and `updated_at` timestamps
- Foreign keys MUST specify ON DELETE behavior
- Indexes MUST be specified for columns used in WHERE, JOIN, ORDER BY
- Every table MUST reference which user stories it supports
- Sensitive data columns MUST be noted for encryption
- ENUM values MUST be listed explicitly
