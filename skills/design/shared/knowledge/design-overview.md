# Design Phase Overview

The design phase transforms requirements into technical blueprints. It defines HOW to build what the requirements phase defined as WHAT. This is where technology decisions are made, architecture is defined, and technical specifications are created.

---

## Skills in This Phase

```
/design-stack       → Select technology stack (languages, frameworks, services)
     ↓
/design-arch        → Define system architecture (C4 diagrams, component design)
     ↓
/design-db          → Design database schema (ERD, tables, relationships)
     ↓
/design-api         → Design API contracts (endpoints, payloads, auth)
     ↓
/design-adr         → Document Architecture Decision Records (can run anytime)
```

Each skill supports two modes: create and refine.

---

## Artifact Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    INPUTS                                    │
│                                                              │
│  From init/final/:                  From req/final/:         │
│  - charter-final.md (constraints)   - epics-final.md         │
│  - scope-final.md (quality attrs)   - userstories-final.md   │
│  - risk-register-final.md           - backlog-final.md       │
│                                     - dor-dod-final.md       │
└────────────┬──────────────────────────┬──────────────────────┘
             │                          │
             ▼                          ▼
      ┌──────────────────────────────────────────┐
      │         /design-stack                    │
      │  Evaluate and select technologies        │
      │  Output: tech-stack-draft.md             │
      └──────────────────┬───────────────────────┘
                         │ promote to design/final/
                         ▼
      ┌──────────────────────────────────────────┐
      │         /design-arch                     │
      │  Define system architecture (C4)         │
      │  Output: architecture-draft.md           │
      └──────────────────┬───────────────────────┘
                         │ promote to design/final/
                    ┌────┴────┐
                    ▼         ▼
      ┌─────────────────┐  ┌─────────────────────┐
      │  /design-db     │  │  /design-api        │
      │  Database schema│  │  API contracts      │
      │  ERD, tables    │  │  Endpoints, payloads│
      └────────┬────────┘  └──────────┬──────────┘
               │                      │
               ▼                      ▼
      ┌──────────────────────────────────────────┐
      │         /design-adr                      │
      │  Document key technical decisions        │
      │  Output: adr/adr-{NNN}-draft.md          │
      └──────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                   OUTPUTS (design/final/)                    │
│                                                              │
│  tech-stack-final.md    architecture-final.md                │
│  database-final.md      api-final.md                         │
│  adr/adr-001-final.md   adr/adr-002-final.md  ...           │
└─────────────────────────────────────────────────────────────┘
```

---

## What This Phase Reads

| Source | What Design Extracts |
|--------|---------------------|
| **charter-final.md** | Constraints (budget, timeline, team), technology mandates |
| **scope-final.md** | Quality attributes (performance, scalability, security), integrations (INT-xxx), system context diagram |
| **risk-register-final.md** | Technical risks, integration risks, performance risks |
| **epics-final.md** | Epic structure for architecture phasing |
| **userstories-final.md** | Acceptance criteria drive API endpoints, data entities, component interactions |
| **backlog-final.md** | MVP boundary determines v1 architecture scope, release grouping informs phased delivery |
| **dor-dod-final.md** | DoD criteria shape CI/CD pipeline and testing requirements |

---

## What Downstream Needs

| Design Artifact | Test Phase Uses | Impl Phase Uses | Deploy Phase Uses |
|----------------|-----------------|-----------------|-------------------|
| **tech-stack-final.md** | Test tool selection | Dev environment setup, coding standards | Build pipeline config |
| **architecture-final.md** | Integration test scope, component test boundaries | Module structure, service boundaries | Service deployment topology |
| **database-final.md** | Test data setup, migration testing | ORM models, migration scripts | Database provisioning |
| **api-final.md** | API test cases, contract tests | Endpoint implementation | API gateway config |
| **adr/*.md** | Test rationale for decisions | Implementation guidance | Deployment constraints |

---

## Key Principles

1. **Technology decisions belong here** — init and req phases must NOT make tech choices. Design is where languages, frameworks, databases, and cloud services are selected.
2. **Justify every decision** — use decision matrices with weighted criteria, not opinions.
3. **Design for requirements** — every design choice traces back to a requirement, quality attribute, or constraint.
4. **C4 model for architecture** — use Context, Container, Component, Code diagrams (Mermaid).
5. **API-first design** — define API contracts before implementation.
6. **ADRs for significant decisions** — document WHY, not just WHAT.
7. **Quality attributes drive architecture** — performance, scalability, security requirements shape design choices.
