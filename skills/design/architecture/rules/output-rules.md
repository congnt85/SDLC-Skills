# Architecture Output Rules

Rules specific to the architecture skill output. These supplement the shared design rules (DES-xx).

---

## Diagram Rules

### ARC-01: C4 Level 1 Required
C4 Level 1 (System Context) diagram is REQUIRED. Every architecture document MUST include a system context diagram showing actors, the system, and external systems.

### ARC-02: C4 Level 2 Required with Technology Labels
C4 Level 2 (Container) diagram is REQUIRED. Every container MUST include the technology name (e.g., "React 18.x", "PostgreSQL 16"). Containers without technology labels violate this rule.

### ARC-03: C4 Level 3 for Complex Containers
C4 Level 3 (Component) diagram is REQUIRED for containers with >3 internal modules. Containers with 3 or fewer responsibilities do not need component diagrams.

### ARC-04: Sequence Diagrams for Complex Workflows
Sequence diagrams are REQUIRED for workflows involving >3 participants (actors, containers, external systems). At minimum, critical auth and primary CRUD workflows must be diagrammed.

### ARC-05: Mermaid Syntax Required
All diagrams MUST use Mermaid syntax. No proprietary diagram formats, image-only diagrams, or ASCII art substitutes. Diagrams must be renderable by standard Mermaid tooling.

---

## Traceability Rules

### ARC-06: Container-to-Tech-Stack Traceability
Every container MUST map to a technology from tech-stack-final.md. No container may introduce a technology not selected in the tech stack. If a gap is found, flag it as ❓ UNCLEAR with a Q&A entry.

### ARC-07: External System Traceability
Every external system in the architecture MUST correspond to a scope integration (INT-xxx). External systems not in scope are out of bounds. If an integration is missing from scope, flag as ❓ UNCLEAR.

### ARC-08: Quality Attribute Coverage
Quality attribute mapping MUST address ALL QA-xxx items from scope-final.md. Every quality attribute must have at least one architectural response with specific patterns/components identified. No QA-xxx may be left unmapped.

---

## Scope Rules

### ARC-09: MVP vs Future Distinction
Architecture MUST distinguish MVP scope from future scope. Non-MVP elements MUST be tagged with `[FUTURE]`. The architecture should be designed for MVP first with clear extension points for future releases.

### ARC-10: Section Order
Architecture document MUST follow this section order:
1. Architecture Overview
2. System Context (C4 Level 1)
3. Container Diagram (C4 Level 2)
4. Component Diagrams (C4 Level 3)
5. Key Workflow Sequences
6. Quality Attribute Mapping
7. Deployment Overview
8. Architecture Principles
9. Q&A Log
10. Readiness Assessment
11. Approval

---

## Consistency Rules

### ARC-11: Entity Name Consistency
Entity names MUST be consistent with what will be used in database and API design (DES-06). Use the same naming conventions throughout: if the architecture calls it "Sprint", the database table should be "sprints" and the API endpoint should be "/sprints". Document the naming convention used.

### ARC-12: Confidence Markers Required
Every architectural decision MUST have a confidence marker:
- ✅ CONFIRMED — validated by requirements, constraints, or user confirmation
- 🔶 ASSUMED — reasonable assumption, needs validation
- ❓ UNCLEAR — needs stakeholder input, has Q&A entry

---

## Mode-Specific Rules

### ARC-13: Refine Mode Scorecard
Refine mode MUST show a quality scorecard FIRST, before applying changes. The scorecard evaluates:
- Diagram completeness (all required levels present?)
- Technology traceability (all containers mapped to tech stack?)
- QA coverage (all QA-xxx addressed?)
- Sequence diagram coverage (key workflows diagrammed?)
- Confidence distribution (% CONFIRMED vs ASSUMED vs UNCLEAR)

### ARC-14: Minimum Sequence Diagrams
At least 2 sequence diagrams MUST be included for MVP workflows. Recommended minimum set:
- Authentication/authorization flow
- Primary domain operation (the main thing the system does)
- Real-time update flow (if applicable)
