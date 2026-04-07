# C4 Architecture Modeling Guide

Techniques and patterns for creating system architecture using the C4 model.

---

## 1. C4 Model Overview

The C4 model provides four levels of abstraction for describing software architecture:

| Level | Name | Audience | Shows | When to Use |
|-------|------|----------|-------|-------------|
| 1 | System Context | Everyone | System + users + external systems | ALWAYS — required for every project |
| 2 | Container | Technical team | Deployable units + technologies | ALWAYS — shows tech choices and communication |
| 3 | Component | Developers | Internal modules within a container | When container has >3 distinct responsibilities |
| 4 | Code | Developers | Classes, interfaces, functions | RARELY — usually generated from code, not designed |

**Key principle**: Each level zooms into the previous level. Start broad (Level 1), then zoom into areas that need detail.

**Level 4 (Code) is typically NOT needed** in architecture documents. Code-level design emerges during implementation. Only create Level 4 diagrams when the internal structure of a component is complex and non-obvious.

---

## 2. Level 1: System Context

### Purpose

Show the system as a single box surrounded by the people who use it and the other systems it interacts with. This is the "big picture" view.

### Technique

1. **Identify actors** — Pull from scope document personas. Each persona type becomes a Person element.
2. **Identify external systems** — Pull from scope integrations (INT-xxx). Each integration becomes a System_Ext element.
3. **Draw the system** — One single System box representing the entire project.
4. **Define relationships** — Show what flows between actors/externals and the system. Label with WHAT (data/actions), not HOW (protocol).

### Input Mapping

| Source | Maps To |
|--------|---------|
| Scope personas | Person elements |
| Scope integrations (INT-xxx) | System_Ext elements |
| Scope functional boundaries | System description |

### Rules

- Keep it simple — one diagram, one system box
- No internal details of the system
- Every person/external system must trace to a scope artifact
- Label relationships with what is communicated (e.g., "Views sprint progress", "Sends webhook events")
- Do NOT label with protocols at this level

### Common Mistakes

- Including too many actors (consolidate similar roles)
- Showing internal databases as external systems
- Missing external systems that are mentioned in integrations
- Labeling relationships with technical protocols instead of business actions

---

## 3. Level 2: Container Diagram

### Purpose

Decompose the system into deployable/runnable units (containers). Show technology choices and communication protocols.

### Technique

1. **List containers** — Identify every separately deployable unit: web app, API server, database, cache, message queue, background workers, etc.
2. **Assign technologies** — Map each container to a technology from tech-stack-final.md. Every container MUST have a technology label.
3. **Define communication** — Show how containers talk to each other. Include protocols (REST, WebSocket, SQL, AMQP, gRPC).
4. **Show external connections** — Include external systems and users from Level 1.

### Architecture Style Decision

Before drawing the container diagram, decide the architecture style:

| Style | When to Use | Team Size | Complexity |
|-------|------------|-----------|------------|
| **Monolith** | Small team, simple domain, tight timeline | 1-5 devs | Low-medium |
| **Modular Monolith** | Small-medium team, clear domain boundaries, want future extraction | 3-10 devs | Medium |
| **Microservices** | Large team, independent deployability needed, high scale requirements | 10+ devs | High |
| **Serverless** | Event-driven workloads, variable traffic, minimal ops capacity | Any | Medium |
| **Hybrid** | Mix of requirements — e.g., monolith core + serverless for events | Any | Medium-high |

**Decision criteria**:
- Team size and experience (small team → avoid microservices overhead)
- Timeline pressure (tight deadline → monolith or modular monolith)
- Scalability requirements (stated QA targets, not hypothetical)
- Domain complexity (clear bounded contexts → modular or micro)
- Operational maturity (can the team run distributed systems?)

### Common Containers

| Container | Typical Technology | Purpose |
|-----------|--------------------|---------|
| Web Application / SPA | React, Vue, Angular | User interface |
| API Server | Node.js, NestJS, Django, Spring | Business logic, REST/GraphQL API |
| Database | PostgreSQL, MySQL, MongoDB | Persistent data storage |
| Cache | Redis, Memcached | Performance, session storage |
| Message Queue | RabbitMQ, Redis, Kafka | Async processing, event bus |
| Background Workers | Same as API (separate process) | Async jobs, scheduled tasks |
| CDN / Static Hosting | CloudFront, Nginx, S3 | Frontend asset delivery |
| API Gateway | Kong, AWS API Gateway | Routing, rate limiting, auth |

### Rules

- Every container MUST map to a technology from tech-stack-final.md
- Show communication protocols on relationship arrows
- Include data stores (databases, caches) as containers
- Background workers are separate containers even if same codebase
- Group containers inside a System_Boundary

---

## 4. Level 3: Component Diagram

### Purpose

Show the internal structure of a container — its modules, services, controllers, and how they interact.

### When to Create

Only create Level 3 diagrams for containers that have **>3 distinct responsibilities**. Trivial containers (e.g., a cache, a simple static file server) do not need component diagrams.

### Technique

1. **Identify responsibilities** — What does this container do? List its distinct concerns.
2. **Group into components** — Organize responsibilities into modules/services.
3. **Apply patterns** — Use well-known architectural patterns for internal organization.
4. **Show dependencies** — Draw relationships between components and to external containers/systems.

### Common Patterns

| Pattern | When to Use | Structure |
|---------|------------|-----------|
| **Controller-Service-Repository** | CRUD-heavy API with clear layers | Controller → Service → Repository → DB |
| **MVC** | Web applications with server-side rendering | Model → View → Controller |
| **CQRS** | Read-heavy with complex queries | Separate Command and Query paths |
| **Hexagonal / Ports & Adapters** | Need to isolate business logic from infra | Core domain ← Ports → Adapters |
| **Module-per-Feature** | Feature-organized codebase (NestJS, Django apps) | Feature modules with own controllers/services |

### Rules

- Only diagram containers with >3 internal modules
- Each component gets a name, responsibility, and pattern label
- Show dependencies on external containers (database, cache, external APIs)
- Keep component count manageable (5-10 per container)
- Name components using domain language that will be consistent with database entities and API endpoints

---

## 5. Sequence Diagrams

### Purpose

Show how components interact over time for key workflows. Sequence diagrams make the dynamic behavior of the architecture visible.

### When to Create

Create sequence diagrams for workflows that:
- Cross **>=3 participants** (containers, external systems, actors)
- Represent **critical user journeys** (auth, primary CRUD, real-time updates)
- Involve **complex interactions** (async processing, callbacks, error handling)

Minimum: **2 sequence diagrams** for MVP workflows.

### Technique

1. **Identify workflows** — Pull from user stories. Look for stories that involve multiple containers or external systems.
2. **Pick participants** — List the actors, containers, and external systems involved.
3. **Draw happy path first** — Show the successful flow end-to-end.
4. **Note error paths** — Use `Note` elements or `alt` blocks for error handling.
5. **Include async flows** — Show WebSocket pushes, queue processing, callbacks.

### Workflow Selection Guide

| Priority | Workflow Type | Example |
|----------|--------------|---------|
| HIGH | Authentication/authorization | Login, token refresh, permission check |
| HIGH | Primary CRUD operation | Create/read the main domain entity |
| HIGH | Real-time updates | WebSocket push, live dashboard refresh |
| MEDIUM | External integration | Webhook receipt, API sync |
| MEDIUM | Async processing | Background job, notification dispatch |
| LOW | Admin/configuration | Settings change, user management |

### Mermaid Sequence Tips

```
sequenceDiagram
    participant U as User
    participant W as Web App
    participant A as API Server
    participant D as Database

    U->>W: Action (solid arrow = synchronous)
    W->>A: API call
    A->>D: Query
    D-->>A: Result (dashed = response)
    A-->>W: Response
    W-->>U: Display

    Note over A,D: Async operations use different arrows
    A-)Q: Publish event (open arrow = async)
```

### Rules

- Minimum 2 sequence diagrams for MVP workflows
- Show participants in left-to-right order of the flow
- Use solid arrows for requests, dashed for responses
- Use open arrows for async/fire-and-forget messages
- Reference related user stories (US-xxx) in diagram title or description
- Include both success and error paths (at minimum, note where errors are handled)

---

## 6. Quality Attribute Patterns

Architectural patterns mapped to quality attributes. Use these to populate the Quality Attribute Mapping section.

### Performance

| Pattern | What It Does | When to Apply |
|---------|-------------|---------------|
| Caching layer (Redis, Memcached) | Reduces database load for repeated reads | Dashboard load time targets, high read:write ratio |
| CDN (CloudFront, Cloudflare) | Serves static assets from edge locations | Frontend performance targets, geographically distributed users |
| Connection pooling | Reuses database connections | High concurrent request targets |
| Async processing (queues) | Offloads heavy work from request path | Operations >500ms that don't need immediate response |
| Database indexing | Speeds up common queries | Query performance targets on specific data access patterns |
| Pagination | Limits data transfer per request | Large dataset responses |

### Scalability

| Pattern | What It Does | When to Apply |
|---------|-------------|---------------|
| Horizontal scaling (load balancer) | Distributes load across instances | Concurrent user targets beyond single-instance capacity |
| Database read replicas | Distributes read load | Read-heavy workloads, reporting queries |
| Database sharding | Distributes data across nodes | Data volume beyond single-node capacity [FUTURE for most MVPs] |
| Stateless services | Enables horizontal scaling | Any service that needs to scale |
| Event-driven architecture | Decouples producers from consumers | Variable processing loads, multiple consumers |

### Availability

| Pattern | What It Does | When to Apply |
|---------|-------------|---------------|
| Health checks | Detects unhealthy instances | Any production deployment |
| Circuit breakers | Prevents cascade failures from external dependencies | External API integrations |
| Graceful degradation | System works with reduced functionality | Features dependent on external systems |
| Redundancy | Eliminates single points of failure | Availability targets >99% |
| Retry with backoff | Handles transient failures | Network calls to external services |

### Security

| Pattern | What It Does | When to Apply |
|---------|-------------|---------------|
| Auth boundary (API gateway) | Centralizes authentication/authorization | Any multi-container system |
| JWT / OAuth2 | Stateless authentication | SPA + API architecture |
| Network segmentation | Isolates database from public internet | Any production deployment |
| Encryption in transit (TLS) | Protects data between services | ALWAYS |
| Encryption at rest | Protects stored data | Sensitive data, compliance requirements |
| Input validation middleware | Prevents injection attacks | All API endpoints |
| Rate limiting | Prevents abuse/DDoS | Public-facing APIs |

### Maintainability

| Pattern | What It Does | When to Apply |
|---------|-------------|---------------|
| Modular design | Isolates changes to specific modules | Any project >1 sprint |
| Dependency injection | Decouples components, enables testing | API servers, business logic layers |
| Interface segregation | Prevents coupling to unused interfaces | Shared service boundaries |
| Structured logging | Enables debugging and monitoring | Any production system |
| Configuration externalization | Enables environment-specific behavior | Multi-environment deployment |

### Applying Patterns to QA-xxx Requirements

For each QA-xxx in the scope document:
1. Identify the quality attribute category (performance, scalability, etc.)
2. Match the specific target to applicable patterns from the tables above
3. Identify which containers/components implement the pattern
4. Document the mapping in the Quality Attribute Mapping table
5. Mark confidence level: ✅ if pattern is proven for this target, 🔶 if assumed sufficient
