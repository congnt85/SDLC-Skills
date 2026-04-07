# Implementation Phase Rules

Rules specific to all skills in the implementation phase.

---

## Content Rules

### IMP-01: Trace to Design Artifacts
Every implementation element MUST trace to at least one:
- Architecture component (from architecture-final.md)
- Database table (from database-final.md)
- API endpoint (from api-final.md)
- User story (US-xxx) or acceptance criterion

Implementation without design traceability is scope creep.

### IMP-02: Tech Stack Compliance
All implementation decisions MUST use technologies selected in tech-stack-final.md:
- Languages and versions must match
- Frameworks and versions must match
- Tools and libraries must be from the approved stack
- Any deviation MUST be documented as an ADR

### IMP-03: Task Size Limits
Implementation tasks MUST be small enough to:
- Complete within 1-2 days (max 8 story points per task)
- Be reviewed in a single PR
- Be independently testable
- Tasks exceeding these limits MUST be split

### IMP-04: DoD Compliance
Every task definition MUST reference applicable DoD criteria from dor-dod-final.md.
Task completion checklist MUST include all relevant DoD items.

### IMP-05: Test Coverage Required
Every implementation task MUST include associated test tasks:
- Feature code → unit tests + integration tests
- API endpoints → API tests
- Database changes → migration tests
- Test tasks are NOT optional add-ons; they are part of the story

### IMP-06: No Gold Plating
Implementation MUST match the design — no extra features, no premature optimization:
- Don't add endpoints not in api-final.md
- Don't add tables/columns not in database-final.md
- Don't implement [FUTURE] tagged items unless explicitly prioritized
- Don't add abstraction layers not in architecture-final.md

---

## Artifact Rules

### IMP-07: Sprint Capacity Validation
Sprint plans MUST validate that planned story points fit within team velocity.
Over-committed sprints MUST be flagged.

### IMP-08: Dependency Awareness
Task ordering MUST respect dependencies:
- Database migrations before API endpoints that use them
- Shared modules before features that depend on them
- Auth setup before protected endpoints
- Test infrastructure before test implementation

### IMP-09: Consistent Naming
File names, module names, and directory structure MUST follow tech-stack conventions:
- Match language/framework naming conventions (camelCase, snake_case, etc.)
- Match architecture component names
- Match database entity names

### IMP-10: Approval Section Required
Every implementation artifact MUST include an Approval section with Tech Lead and Scrum Master roles.
