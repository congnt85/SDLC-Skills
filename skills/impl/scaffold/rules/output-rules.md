# Scaffold Plan Output Rules

Rules specific to the project scaffolding plan skill output. These extend the shared rules in `skills/shared/rules/` and `impl/shared/rules/impl-rules.md`.

---

## Structure Rules

### SCF-01: Directory Structure Mirrors Architecture
The project directory structure MUST mirror architecture components from architecture-final.md. Each component maps to at least one directory under `src/`. Directory names follow framework conventions (kebab-case for NestJS modules, PascalCase for React components).

### SCF-02: Tech Stack Version Compliance
Configuration file specifications MUST match the versions and tools selected in tech-stack-final.md. Do not introduce tools or versions not in the approved tech stack. Any deviation MUST be documented as a Q&A entry with HIGH impact.

### SCF-03: Environment Variable Documentation
Every environment variable referenced in the plan MUST be documented in the .env.example specification with: variable name, type, default value (or "required"), and description. Variables MUST be grouped by concern (database, auth, external services, feature flags).

### SCF-04: Shared Utility Coverage
The shared utilities section MUST address all cross-cutting concerns identified in the architecture: error handling, logging, authentication/authorization, validation, response formatting, and configuration validation. Each utility MUST list its files and purpose.

---

## Format Rules

### SCF-05: Section Order
The scaffold plan MUST follow this section order:
1. Project Structure
2. Configuration Files
3. Shared Utilities
4. Q&A Log
5. Readiness Assessment
6. Approval

Sections MUST NOT be reordered or omitted (except sections with no applicable content, which include a "Not applicable" note).

### SCF-06: Framework Naming Conventions
All directory names MUST follow the conventions of the selected language and framework:
- NestJS: kebab-case directories (`auth/`, `users/`, `common/`)
- React: PascalCase components, camelCase hooks (`components/`, `features/`, `hooks/`)
- Python: snake_case packages (`auth/`, `users/`, `common/`)
- Go: lowercase packages (`auth/`, `users/`, `common/`)

### SCF-07: Confidence Markers Required
Every configuration file entry and shared utility module MUST have a confidence marker (CONFIRMED / ASSUMED / UNCLEAR). Confidence is inherited from the source design artifact when possible.

### SCF-08: Refine Mode Scorecard First
In refine mode, the output MUST begin with a Quality Scorecard comparing the current version against rules SCF-01 through SCF-08, showing pass/fail status before presenting the updated plan.
