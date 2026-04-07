# Architecture Decision Record Writing Guide

Techniques and patterns for writing effective Architecture Decision Records.

---

## 1. What Warrants an ADR

Not every technical choice needs an ADR. Use the **DES-09 threshold test** — a decision warrants an ADR when it meets ANY of these criteria:

| Criterion | Description |
|-----------|-------------|
| Cross-cutting | Affects more than one component or module |
| Hard to reverse | Changing this decision later requires significant rework |
| Multiple viable options | There are at least 2 reasonable alternatives |
| Trade-off involved | Involves trade-offs that stakeholders should understand |

### Decisions That DO Need ADRs

- **Database selection** — PostgreSQL vs MySQL vs MongoDB (hard to reverse, affects entire data layer)
- **Architecture style** — Monolith vs modular monolith vs microservices (cross-cutting, hard to reverse)
- **Authentication approach** — JWT vs session-based, Auth0 vs Cognito vs custom (security implications, hard to reverse)
- **API versioning strategy** — URL-based vs header-based (affects all API consumers)
- **Caching strategy** — Redis vs Memcached vs application-level (affects performance architecture)
- **Communication pattern** — Synchronous REST vs asynchronous messaging (cross-cutting, architectural)
- **Deployment model** — Containers vs serverless vs VMs (affects entire ops pipeline)
- **State management** — Where session/application state lives (cross-cutting)
- **Real-time approach** — WebSockets vs SSE vs polling (affects frontend and backend architecture)
- **ORM vs raw SQL** — Affects all data access code (hard to reverse at scale)

### Decisions That DO NOT Need ADRs

- **Variable naming conventions** — important but easily changed, no trade-offs
- **File organization within a module** — internal to one component, easily restructured
- **Which linter or formatter to use** — low impact, easily swapped
- **Import ordering** — cosmetic, no architectural impact
- **Git branching strategy** — process decision, not architecture (unless it affects deployment)
- **IDE or editor choice** — personal preference, no system impact
- **Test file naming convention** — easily changed, no trade-offs

### Gray Area (Use Judgment)

- **Logging framework** — usually not, unless it's a structured logging architecture decision
- **CSS methodology** — not usually, unless choosing between CSS-in-JS vs utility-first fundamentally changes frontend architecture
- **Package manager** — not usually, unless the choice constrains the build pipeline

---

## 2. ADR Lifecycle

Every ADR has a status that tracks its progression:

```
Proposed ──→ Accepted ──→ Deprecated ──→ (archived)
    │                          ↑
    └──→ Rejected              │
                          Superseded by ADR-{NNN}
```

| Status | Meaning | When to Use |
|--------|---------|-------------|
| **Proposed** | Initial state, under discussion | New ADRs — decision not yet finalized |
| **Accepted** | Team agreed, implementation proceeds | After stakeholder review and approval |
| **Rejected** | Considered but not adopted | Decision was explored but a different path was chosen. Still valuable to record WHY it was rejected — prevents revisiting the same dead end. |
| **Deprecated** | Was accepted but no longer applies | Requirements changed, technology evolved, or the problem no longer exists. Must explain WHY it no longer applies. |
| **Superseded** | Replaced by a newer ADR | A new decision replaces this one. MUST link to the successor ADR. The old ADR remains as historical record. |

### Status Transition Rules

- Only `Proposed` ADRs can become `Accepted` or `Rejected`
- Only `Accepted` ADRs can become `Deprecated` or `Superseded`
- Status changes should be recorded in the Change Log
- `Rejected` and `Deprecated` ADRs are never deleted — they are historical records

---

## 3. Writing the Context

The context section answers: **"Why are we making this decision NOW?"**

### Structure

1. **Problem statement** — What situation requires a decision?
2. **Business drivers** — What business needs drive this? (reference charter CON-xxx)
3. **Technical constraints** — What limits our options? (reference scope CON-xxx)
4. **Quality requirements** — What quality attributes are at stake? (reference QA-xxx)
5. **Risk factors** — What risks does this decision address? (reference RISK-xxx)

### Good vs Bad Context

**Bad (vague)**:
> We needed a database for our application.

**Good (specific)**:
> We need ACID transactions for financial sprint data with <50ms query latency (QA-001) and JSONB support for flexible webhook payloads from external integrations (INT-003, INT-004). The team of 4 (CON-003) needs a database they can operate without a dedicated DBA. Our 6-month MVP timeline (CON-001) rules out solutions with steep learning curves.

### Traceability Requirements

Every ADR context MUST reference at least one of:
- `QA-xxx` — quality attribute from scope
- `CON-xxx` — constraint from scope or charter
- `US-xxx` — user story from requirements
- `RISK-xxx` — risk from risk register

This creates a traceable chain: Requirement → Decision → Implementation.

---

## 4. Documenting Alternatives

The alternatives section is what makes ADRs valuable. It captures the OPTIONS considered and WHY the chosen option won.

### Rules for Alternatives

1. **Minimum 2 alternatives** — If there's only one option, it's not really a decision
2. **Include the chosen option** — Mark it clearly as CHOSEN
3. **Be fair to rejected options** — They may become relevant later if requirements change
4. **Use consistent evaluation criteria** — Same pros/cons dimensions for each option
5. **Explain the tie-breaker** — When options are close, what factor tipped the scale?

### Alternative Template

For each alternative, document:

```
### Option {letter}: {Name} {CHOSEN/REJECTED}

{1-2 sentence description of this option}

| Pros | Cons |
|------|------|
| {advantage 1} | {disadvantage 1} |
| {advantage 2} | {disadvantage 2} |
```

### Common Mistakes

- **"There was no other option"** — There is always at least "do nothing" or "build custom"
- **Strawman alternatives** — Don't include options you never seriously considered just to pad the list. Each alternative should be genuinely viable.
- **Missing trade-off analysis** — Every option has BOTH pros and cons. If an option has only pros, you haven't looked hard enough.
- **No decision rationale** — After listing alternatives, explain WHY the chosen option won. What was the deciding factor?

---

## 5. Writing Consequences

Every decision creates consequences — things that become easier AND things that become harder. Honest consequence documentation is critical for future teams.

### Three Categories

| Category | What to Include |
|----------|----------------|
| **Positive** | What this decision enables, simplifies, improves, or de-risks |
| **Negative** | What this decision constrains, complicates, risks, or makes harder |
| **Neutral** | What changes but is neither clearly positive nor negative |

### Consequence Checklist

For each decision, consider consequences in these dimensions:

- **Development speed** — Faster or slower to build?
- **Operational complexity** — More or fewer things to monitor/maintain?
- **Team skills** — Does the team have the skills, or need training?
- **Cost** — Higher or lower infrastructure/licensing costs?
- **Scalability** — What happens when load increases 10x?
- **Security** — New attack surfaces or security improvements?
- **Flexibility** — Easier or harder to change direction later?
- **Testing** — Easier or harder to test?

### Common Mistakes

- **No negative consequences** — Every decision has downsides. If you can't find any, you haven't thought hard enough.
- **Too abstract** — "Better performance" is not useful. "Sub-millisecond cache reads reduce dashboard load time from 3s to <1s" is useful.
- **Missing mitigation** — For significant negative consequences, note how they can be mitigated.

---

## 6. Decision Identification from Design Artifacts

Where to find decisions worth recording across design artifacts:

### From Tech Stack (`tech-stack-final.md`)

Every decision matrix winner is an ADR candidate:
- Backend framework selection
- Database selection (primary, cache, search)
- Frontend framework selection
- Cloud provider selection
- Authentication service selection
- Monitoring/observability tool selection

**Tip**: If the decision matrix was close (winning score within 10% of runner-up), the decision definitely needs an ADR to capture the nuanced reasoning.

### From Architecture (`architecture-final.md`)

- Architecture style choice (monolith, modular monolith, microservices, serverless)
- Communication patterns (sync REST, async messaging, event-driven)
- Deployment model (containers, serverless, hybrid)
- Cross-cutting concern strategies (logging, auth, error handling)
- Data flow patterns (CQRS, event sourcing, traditional CRUD)

### From Database (`database-final.md`)

- Schema strategy (fully normalized, strategic denormalization, document-oriented)
- Primary key strategy (UUID vs auto-increment vs ULID)
- JSONB/flexible schema usage (when and why)
- Migration strategy (tool choice, rollback approach)
- Indexing strategy for performance-critical queries

### From API (`api-final.md`)

- API versioning strategy (URL-based, header-based, query parameter)
- Authentication mechanism (JWT, OAuth, API keys)
- Pagination approach (offset, cursor, keyset)
- Real-time communication (WebSocket, SSE, long polling)
- Error response format and codes
- Rate limiting strategy

---

## 7. ADR Numbering

### Rules

- Numbers are **sequential** — ADR-001, ADR-002, ADR-003, ...
- Numbers are **never reused** — If ADR-003 is superseded, the replacement is ADR-007 (next available), NOT ADR-003v2
- Numbers are **auto-incremented** — Scan `draft/` for existing `adr-{NNN}-*-draft.md` files, use max + 1
- Format is **zero-padded to 3 digits** — 001, 002, ... 099, 100

### Slug Format

- **Kebab-case**, 3-5 words
- Imperative verb + subject: `use-redis-for-caching`, `adopt-modular-monolith`, `require-jwt-authentication`
- Must match the decision title (abbreviated)

### Examples

| File Name | Title |
|-----------|-------|
| `adr-001-adopt-modular-monolith-draft.md` | Adopt Modular Monolith Architecture |
| `adr-002-use-postgresql-primary-db-draft.md` | Use PostgreSQL as Primary Database |
| `adr-003-use-redis-for-caching-draft.md` | Use Redis for Caching and Pub/Sub |
| `adr-004-implement-jwt-authentication-draft.md` | Implement JWT Authentication via Auth0 |

---

## 8. Common Anti-patterns

### Anti-pattern: Vague Context

**Bad**: "We needed something fast for our application."
**Good**: "Dashboard must load in <2 seconds (QA-001) with 50 concurrent teams (QA-003). Current prototype shows 3.5s load time without caching. We need a caching layer to meet performance targets."

### Anti-pattern: Missing Alternatives

**Bad**: "There was no other option — we had to use PostgreSQL."
**Good**: "We considered PostgreSQL, MySQL, and MongoDB. PostgreSQL was chosen because..." (there are ALWAYS alternatives)

### Anti-pattern: No Consequences

**Bad**: "This decision will improve our system."
**Good**: Lists specific positive outcomes AND specific negative trade-offs.

### Anti-pattern: Overly Long ADRs

Keep ADRs to **1-2 pages**. They are decision records, not design documents. If you're writing more than 2 pages, you're probably mixing decision documentation with design documentation.

### Anti-pattern: Retroactive Documentation

Documenting decisions after the fact without capturing the original reasoning loses the most valuable part of the ADR — the WHY. If writing retroactively, interview the decision-makers and reconstruct the reasoning as accurately as possible.

### Anti-pattern: Decision Without Trade-offs

If your ADR shows the chosen option as clearly superior in every dimension, either you haven't evaluated alternatives fairly, or the decision was obvious enough not to need an ADR (revisit the DES-09 threshold test).
