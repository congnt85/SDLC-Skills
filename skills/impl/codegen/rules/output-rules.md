# Codegen Plan Output Rules

Rules specific to the code generation plan skill output. These extend the shared rules in `skills/shared/rules/` and `impl/shared/rules/impl-rules.md`.

---

## Structure Rules

### CDG-02: Complete Component Coverage
Every architecture component in architecture-final.md MUST map to at least one module specification in the codegen plan. No architecture component may be left unmapped. Cross-cutting components (auth, logging, config) map to shared/common modules.

### CDG-03: Complete Database Coverage
Every database table in database-final.md MUST have a corresponding ORM model/entity specification in the codegen plan. Entity specifications MUST include column types, relationships, validations, and enum definitions.

### CDG-04: Complete API Coverage
Every API resource in api-final.md MUST have a corresponding controller/route specification. Each endpoint MUST map to a handler method with HTTP method, path, DTO reference, auth requirements, and source story.

### CDG-05: Story Traceability
Every module specification MUST reference its source user stories (US-xxx). Modules without story references indicate either missing traceability or infrastructure modules (which should reference architecture components instead).

---

## Content Rules

### CDG-07: Test Strategy Alignment
Test infrastructure specifications MUST match the testing tools and structure defined in test-strategy-final.md (when available). Test directory layout, frameworks, and coverage thresholds MUST align with the test strategy.

### CDG-08: Complete File Inventory
The file inventory section MUST list ALL files planned for generation. Every file MUST include: file path, purpose, source reference (design artifact), and MVP status. The inventory summary MUST provide counts by category (source, test, config).

---

## Format Rules

### CDG-09: Section Order
The codegen plan MUST follow this section order:
1. Module Specifications
2. ORM Models
3. API Route Scaffolding
4. Test Infrastructure
5. File Inventory
6. Q&A Log
7. Readiness Assessment
8. Approval

Sections MUST NOT be reordered or omitted (except sections with no applicable content, which include a "Not applicable" note).

### CDG-10: Confidence Markers Required
Every module specification, ORM model, API route group, and configuration file MUST have a confidence marker (CONFIRMED / ASSUMED / UNCLEAR). Confidence is inherited from the source design artifact when possible.

### CDG-11: Refine Mode Scorecard First
In refine mode, the output MUST begin with a Quality Scorecard comparing the current version against rules CDG-01 through CDG-14, showing pass/fail status before presenting the updated plan.

---

## Naming and Scope Rules

### CDG-12: Framework Naming Conventions
All file names, module names, and directory names MUST follow the conventions of the selected language and framework:
- NestJS: kebab-case files, PascalCase classes (`users.controller.ts`, `UsersController`)
- React: PascalCase components, camelCase hooks (`UserProfile.tsx`, `useAuth.ts`)
- Python: snake_case files and functions, PascalCase classes
- Go: lowercase packages, CamelCase exports

### CDG-14: MVP Identification
Every module in the module specifications MUST be tagged as either MVP or `[FUTURE]`. MVP modules are those required for the minimum viable product. Non-MVP modules are planned but not included in initial implementation sprints. The file inventory MUST filter by MVP status.
