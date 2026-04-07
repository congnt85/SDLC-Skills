# Output Rules -- deploy/release

Release-plan-specific output constraints. These supplement the project-wide rules in `skills/shared/rules/` and phase rules in `deploy/shared/rules/`.

---

## Release Plan Content Rules

### REL-01: Semantic Versioning Required
Versioning strategy MUST follow Semantic Versioning (semver.org) with MAJOR.MINOR.PATCH format. Pre-release identifiers and build metadata rules MUST be documented.

### REL-02: Release Types Required
Release types MUST define at least three categories: regular (planned), hotfix (emergency), and rollback procedure. Each type MUST document its distinct process, timeline, and approval requirements.

### REL-03: Release Process Flowchart
Release process MUST include a Mermaid flowchart showing the end-to-end workflow from code freeze to post-release verification. Steps MUST have owners and time targets.

### REL-04: Changelog Traceability
Changelog format MUST trace entries to user stories (US-xxx) or tickets from the backlog. The mapping from conventional commit prefixes to changelog sections MUST be documented.

### REL-05: Approval Matrix Required
Release approval MUST specify approvers and approval criteria by release type. Approval turnaround time targets MUST be defined for each type.

### REL-06: Multi-layer Rollback
Rollback procedure MUST cover three layers: application rollback, database rollback, and configuration rollback. Each layer MUST document the method, steps, and target recovery time.

### REL-07: Rollback Time Targets
Every rollback procedure MUST specify a target time (e.g., <5min for application rollback, <15min for database rollback). These targets MUST be measurable and testable.

### REL-08: Calendar Alignment
Release calendar MUST align with backlog releases (MVP, R2, R3) and charter timeline constraints. Planned dates MUST reference the source milestone.

### REL-09: Section Order
Output MUST follow this section order: Versioning Strategy -> Release Types -> Release Process -> Changelog Management -> Release Approval -> Rollback Procedures -> Release Calendar -> Release Metrics -> Q&A Log -> Readiness Assessment -> Approval.

### REL-10: Confidence Markers
Every release process decision (versioning scheme, release cadence, rollback targets, approval matrix, DORA targets) MUST carry a confidence marker: ✅ CONFIRMED, 🔶 ASSUMED, or ❓ UNCLEAR.

### REL-11: Refine Mode Scorecard
In refine mode, output MUST begin with a Quality Scorecard covering: versioning completeness, release type coverage, process clarity, changelog traceability, approval rigor, rollback feasibility, calendar alignment, and metrics coverage.

### REL-12: DORA Metrics Required
Release plan MUST define all four DORA metrics (deployment frequency, lead time for changes, change failure rate, MTTR) with initial targets appropriate to team maturity.

### REL-13: Code Freeze Periods
Code freeze periods MUST be specified for each planned release. Duration and rules (what is allowed during freeze) MUST be documented.

### REL-14: Communication Plan
Communication plan MUST define who is notified at each release stage (pre-release, deploy, post-deploy, rollback). Channels and message templates SHOULD be included.

---

## Format Rules

### REL-15: Section Order Enforcement
Release plan output MUST follow the section order in `deploy/release/templates/output-template.md`.

### REL-16: ID References
The release plan references existing IDs (US-xxx, EPIC-xxx) from backlog and stories. It does NOT create new story or epic IDs but MAY define release IDs (REL-xxx).

### REL-17: Confidence Coverage
The Readiness Assessment counts each major decision as 1 item for confidence tallying.

---

## Refine Mode Rules

### REL-18: Quality Scorecard First
In refine mode, generate Quality Scorecard covering:
- Versioning: Is semver correctly defined with bump triggers?
- Release Types: Are all types (regular, hotfix, rollback) covered?
- Process: Is the workflow clear with owners and SLAs?
- Changelog: Is traceability to stories established?
- Approval: Are criteria and approvers defined per type?
- Rollback: Are all layers covered with time targets?
- Calendar: Does it align with backlog milestones?
- Metrics: Are all four DORA metrics defined with targets?

### REL-19: TBD Reduction Target
Each refine round should aim to resolve outstanding issues by at least 30%.
