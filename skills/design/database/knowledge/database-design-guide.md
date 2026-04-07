# Database Design Guide

Techniques for extracting entities from user stories, designing normalized schemas, choosing key strategies, and planning migrations.

---

## Technique 1: Entity Extraction from Stories

Scan user stories for nouns (entities) and verbs (relationships). Map acceptance criteria fields to columns.

### Process

1. List all user stories and their acceptance criteria
2. Underline every noun → candidate entity
3. Underline every verb → candidate relationship
4. Deduplicate: merge synonyms (e.g., "member" and "participant")
5. For each AC field, identify which entity it belongs to and what column it implies
6. Validate: every table must trace to at least one user story

### Example

```
US-003: "As a Scrum Master, I want to see sprint progress so I can
         identify blockers early."
  AC: Sprint board shows task status breakdown
  AC: Progress bar shows % complete by story points

Nouns → Sprint, Task, StoryPoint (attribute of Task)
Verbs → "shows" → Sprint has many Tasks, Task has status

Entities:
  Sprint  (id, name, goal, start_date, end_date, status)  → US-003
  Task    (id, title, status, story_points, sprint_id)     → US-003
```

### Decision: Entity or Attribute?

| Make it an entity when... | Make it an attribute when... |
|--------------------------|----------------------------|
| It has its own lifecycle (created/updated/deleted independently) | It only exists as part of another entity |
| Multiple other entities reference it | Only one entity uses it |
| It has more than 2-3 fields | It is a single value (name, count, flag) |
| You need to query/filter/sort by it independently | You never query it alone |

---

## Technique 2: Normalization Strategy

Default to Third Normal Form (3NF). Denormalize only with explicit justification.

### When to Normalize (3NF)

- Write-heavy tables: users, projects, tasks
- Data that must be consistent: financial records, permissions
- Entities referenced by multiple other tables
- Data subject to frequent updates

### When to Denormalize

- Read-heavy dashboards where JOIN cost is prohibitive
- Reporting tables that aggregate data from multiple sources
- Cached/materialized views for analytics
- Audit logs where you want a snapshot of state at a point in time

### Decision Criteria

| Factor | Normalize | Denormalize |
|--------|-----------|-------------|
| Write frequency | High | Low |
| Read frequency | Low-Medium | Very High |
| Data consistency | Critical | Eventual OK |
| Query complexity | Simple JOINs | Complex multi-JOIN |
| Update patterns | Frequent | Rare/append-only |

### Example

```
NORMALIZE: user.email stored once in users table, referenced by FK
DENORMALIZE: commit.author_name stored alongside commit
  (author may change display name, but commit record is historical)
```

---

## Technique 3: Primary Key Strategy

### UUID (Recommended Default)

**Pros:**
- Globally unique across tables, databases, and services
- Safe for distributed systems and future microservice splits
- No sequential exposure (prevents enumeration attacks)
- Merge-friendly: no collisions when combining datasets

**Cons:**
- Larger storage (16 bytes vs 4-8 bytes for integer)
- Slower index operations (random insertion pattern)
- Less human-readable in debugging

**Recommendation:** Use UUID for all user-facing entities. Use `gen_random_uuid()` (PostgreSQL) or equivalent for generation.

### Auto-Increment (Exception Cases)

Acceptable for:
- Internal join/association tables with no external exposure
- Time-series data where insertion order matters
- Legacy system integration where integer IDs are required

### Never

- Never use composite natural keys as primary keys (use them as UNIQUE constraints instead)
- Never expose auto-increment IDs in public APIs (use UUID or slug)

---

## Technique 4: Relationship Patterns

### One-to-One

```
users ||--|| user_profiles : "has"
```

Use when: separating frequently-accessed core fields from rarely-accessed extended data. The "child" table has a FK that is also a UNIQUE constraint.

### One-to-Many

```
projects ||--o{ sprints : "contains"
```

Most common pattern. The "many" side holds the FK. Always specify ON DELETE behavior.

### Many-to-Many

```
users ||--o{ project_members : "joins"
projects ||--o{ project_members : "joins"
```

Always use an explicit join table (never implicit). The join table often has its own attributes (role, joined_at). Give it a meaningful name (project_members, not users_projects).

### Self-Referencing

```
tasks |o--o{ tasks : "parent"
```

Use for hierarchical data: task → subtask, category → subcategory, comment → reply. The FK references the same table. Always allow NULL for root items.

### Polymorphic Associations (Avoid if Possible)

```
-- AVOID this pattern when possible:
comments (id, commentable_type, commentable_id, body)

-- PREFER separate FKs:
comments (id, task_id NULL, project_id NULL, body)
  CHECK (task_id IS NOT NULL OR project_id IS NOT NULL)
```

If you must use polymorphic associations, use a discriminator column and document clearly.

---

## Technique 5: Index Strategy

### Mandatory Indexes

1. **All FK columns** — required for JOIN performance and CASCADE operations
2. **Columns in WHERE clauses** — filter predicates need indexes
3. **Columns in ORDER BY** — sort operations benefit from indexes
4. **Columns in JOIN conditions** — JOIN performance

### Composite Indexes

Follow the leftmost prefix rule: an index on `(a, b, c)` supports queries on `(a)`, `(a, b)`, and `(a, b, c)` but NOT `(b)` or `(c)` alone.

```
-- This query benefits from idx_tasks_sprint_status:
SELECT * FROM tasks WHERE sprint_id = ? AND status = ?

-- Index definition:
CREATE INDEX idx_tasks_sprint_status ON tasks(sprint_id, status);
```

### Partial Indexes

Use for filtered queries on a subset of rows:

```
-- Only index active sprints (most queries filter to active):
CREATE INDEX idx_sprints_active ON sprints(project_id)
  WHERE status = 'active';
```

### Index Anti-Patterns

- **Over-indexing**: Every index slows writes. Don't index columns rarely queried.
- **Indexing low-cardinality columns alone**: An index on `boolean` is rarely useful.
- **Missing composite indexes**: Two single-column indexes are NOT the same as one composite index.

### Justification Requirement

Every index entry must include which queries or use cases benefit:

```
| Name | Columns | Type | Justification |
|------|---------|------|---------------|
| idx_tasks_sprint_id | sprint_id | B-tree | Sprint board loads all tasks for a sprint |
| idx_tasks_assignee_status | assignee_id, status | B-tree | "My tasks" page filters by assignee and status |
```

---

## Technique 6: Audit and Soft Delete Patterns

### Timestamps (Required on Every Table)

```sql
created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
```

Use `TIMESTAMPTZ` (with timezone), not `TIMESTAMP`. Set `updated_at` via application code or database trigger on every UPDATE.

### Soft Delete

Add `deleted_at TIMESTAMPTZ NULL` to tables where:
- Data must be recoverable (user accounts, projects)
- Audit trail is required (compliance, billing)
- Cascading hard deletes are dangerous

Do NOT use soft delete for:
- High-volume transient data (logs, notifications)
- Data with no recovery need (session tokens)

When using soft delete, add a partial index:

```sql
CREATE INDEX idx_users_active ON users(email) WHERE deleted_at IS NULL;
```

And ensure all queries include `WHERE deleted_at IS NULL` (or use a database view).

### Audit Log Table

For compliance-critical data, create a separate audit log:

```sql
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  table_name VARCHAR(100) NOT NULL,
  record_id UUID NOT NULL,
  action VARCHAR(10) NOT NULL,  -- INSERT, UPDATE, DELETE
  old_values JSONB,
  new_values JSONB,
  performed_by UUID REFERENCES users(id),
  performed_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

---

## Technique 7: JSONB Usage

### When to Use JSONB

- **Flexible metadata**: user preferences, feature flags, configuration
- **External API responses**: webhook payloads, third-party data
- **Variable schema**: different entity types with different attributes
- **Rapid prototyping**: schema not yet finalized

### When NOT to Use JSONB

- Data you need to JOIN on regularly
- Data with strict consistency requirements
- Data you need to enforce constraints on (use columns instead)
- Primary query filters (use indexed columns instead)

### Indexing JSONB

```sql
-- GIN index for containment queries (@>, ?, ?|, ?&):
CREATE INDEX idx_alert_rules_config ON alert_rules USING GIN(config);

-- Expression index for specific key lookups:
CREATE INDEX idx_alert_rules_threshold ON alert_rules((config->>'threshold'));
```

### Example

```sql
-- Good JSONB use: alert rule configuration varies by type
alert_rules.config JSONB
  -- For blocker alerts: {"threshold": 2, "notify": ["email", "slack"]}
  -- For stale alerts:   {"days_stale": 3, "exclude_statuses": ["done"]}

-- Bad JSONB use: storing task status in JSONB
  -- Use an ENUM column instead — you query/filter/sort by status constantly
```

---

## Technique 8: Migration Ordering

### Topological Sort by FK Dependencies

Order migrations so that referenced tables are created before referencing tables.

### Process

1. List all tables and their FK dependencies
2. Identify base tables (no FKs to other tables): users, projects
3. Build dependency graph
4. Topological sort: base tables first, then dependents, then join tables

### Example

```
1. users           — base table, no dependencies
2. projects        — FK → users (owner_id)
3. project_members — FK → users, FK → projects
4. sprints         — FK → projects
5. tasks           — FK → sprints, FK → projects, FK → users
6. commits         — FK → tasks (nullable), FK → projects
7. ci_builds       — FK → projects, FK → commits
8. alert_rules     — FK → projects, FK → users
9. notifications   — FK → users, FK → alert_rules (nullable)
```

### Seed Data Strategy

Identify tables that need seed data for the application to function:

| Priority | Type | Example |
|----------|------|---------|
| Required | System defaults | Default roles, status values (if not ENUM) |
| Required | Admin accounts | Initial admin user for first login |
| Optional | Demo data | Sample project for onboarding |
| Test only | Test fixtures | Predictable data for automated tests |

Seed data migrations run AFTER schema migrations and are environment-specific (dev seeds differ from production seeds).
