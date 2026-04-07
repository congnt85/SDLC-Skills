# Design Phase Rules

Rules specific to all skills in the design phase.

---

## Content Rules

### DES-01: Justify Technology Decisions
Every technology choice MUST be justified with:
- A decision matrix (weighted criteria scoring) OR
- An ADR documenting alternatives considered, criteria, and rationale

"Team familiarity" alone is not sufficient justification. It can be ONE criterion among several.

### DES-02: Trace to Requirements
Every design element MUST trace to at least one:
- User story (US-xxx) or acceptance criteria
- Quality attribute (QA-xxx)
- Constraint (CON-xxx)
- Risk mitigation (RISK-xxx)

Designs that don't trace to requirements are scope creep.

### DES-03: Quality Attributes Drive Architecture
Architecture decisions MUST explicitly address quality attributes from scope:
- Performance targets → caching strategy, async processing, CDN
- Scalability targets → horizontal scaling, load balancing, database sharding
- Availability targets → redundancy, failover, health checks
- Security requirements → auth, encryption, input validation

### DES-04: Use Standard Notations
Design artifacts MUST use standard notations:
- Architecture: C4 model (Context, Container, Component) in Mermaid
- Database: ERD notation in Mermaid
- API: RESTful conventions or GraphQL schema
- Sequence diagrams: Mermaid sequence diagrams

### DES-05: No Premature Optimization
Design for current requirements and stated scalability targets. Do NOT design for:
- Load 100x beyond stated targets
- Features not in the backlog
- Integrations not in scope

Design for the MVP first, note extensibility points for future releases.

### DES-06: Consistency Across Artifacts
- Entity names MUST be consistent across database, API, and architecture diagrams
- Service names MUST match between architecture and deployment diagrams
- API endpoints MUST match the data entities in the database schema

### DES-07: Security by Design
Every design artifact MUST address security:
- Tech stack: known vulnerability assessment
- Architecture: authentication, authorization boundaries
- Database: encryption at rest, access control
- API: input validation, rate limiting, authentication

---

## Artifact Rules

### DES-08: Mermaid Diagrams Required
Architecture, database, and API designs MUST include Mermaid diagrams.
Text descriptions alone are insufficient for technical design.

### DES-09: ADR for Significant Decisions
Any decision that meets one of these criteria MUST have an ADR:
- Affects more than one component/service
- Is difficult or expensive to reverse
- Has multiple viable alternatives that were considered
- Involves trade-offs that stakeholders should understand

### DES-10: Cross-Reference to Stories
Database tables MUST reference which stories use them.
API endpoints MUST reference which stories they implement.
Architecture components MUST reference which epics they serve.

### DES-11: Approval Section Required
Every design artifact MUST include an Approval section with Technical Lead and Architect roles.

### DES-12: MVP Scope First
Design the MVP architecture first. Note extension points for R2/R3 features but don't over-engineer. Mark non-MVP elements with `[FUTURE]` tag.
