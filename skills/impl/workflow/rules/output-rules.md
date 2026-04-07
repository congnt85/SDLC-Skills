# Workflow Output Rules

These rules govern the structure and content of the development workflow document (`dev-workflow-draft.md`). All rules are mandatory unless stated otherwise.

---

## WFL-01: Branching Strategy Justification

Branching strategy MUST be explicitly selected with justification tied to team context. The justification MUST reference at least two of: team size, release cadence, CI maturity, deployment model. Do not default to a model without explaining why it fits.

## WFL-02: Branch Naming with Ticket ID

Branch naming convention MUST include ticket ID for traceability. Format: `{type}/{ticket-id}-{short-description}`. Branches without ticket IDs break the link between code changes and backlog items.

## WFL-03: PR Checklist Includes DoD

PR checklist MUST include Definition of Done items from `dor-dod-final.md` when available. If DoD is not available, the PR checklist MUST include at minimum: tests pass, no linting errors, documentation updated, no unresolved TODOs. Mark DoD-sourced items with confidence marker.

## WFL-04: Review Count and SLA

Code review MUST specify minimum reviewer count and turnaround SLA for each PR type (feature, hotfix, chore). Reviewer count SHOULD scale with team size: 1 reviewer for teams of 2-4, 2 reviewers for teams of 5+. SLA MUST distinguish business hours from any-time (hotfix).

## WFL-05: CI Pipeline Covers Test Strategy

CI pipeline MUST include all test stages defined in `test-strategy-final.md`. Every test type (unit, integration, E2E, performance) MUST appear in at least one pipeline stage. If a test type from the strategy is excluded, it MUST be justified with a Q&A entry.

## WFL-06: Blocking vs Advisory Stages

CI pipeline MUST clearly mark each stage as **Blocking** (must pass to proceed) or **Advisory** (informational, does not block). At minimum, lint, type check, unit tests, and build MUST be blocking. Performance and coverage checks MAY be advisory.

## WFL-07: Commit Message Format

Commit message format MUST be specified and enforceable via tooling (e.g., commitlint). The format MUST define allowed types, scope requirements, and subject line rules. Conventional Commits format is RECOMMENDED.

## WFL-08: Hotfix Process Required

Hotfix process MUST be defined with expedited review rules that are distinct from normal PR review. MUST include: branch creation source, scope limitation, reviewer count reduction, merge targets, deployment path, and post-incident review requirement.

## WFL-09: Section Order

Document MUST follow this section order:
1. Branching Strategy
2. Pull Request Process
3. Code Review Standards
4. CI/CD Pipeline
5. Coding Standards
6. Hotfix Process
7. Release Process
8. Environment Promotion
9. Q&A Log
10. Readiness Assessment
11. Approval

Sections MUST NOT be reordered or omitted.

## WFL-10: Confidence Markers on Decisions

Every workflow decision MUST have a confidence marker:
- ✅ **CONFIRMED** -- validated by team input or explicit user confirmation
- 🔶 **ASSUMED** -- reasonable default based on context, needs team validation
- ❓ **UNCLEAR** -- insufficient information, requires clarification

Decisions include: branching model, merge strategy, reviewer count, SLAs, CI stages, commit format, hotfix rules, versioning strategy, and rollback procedures.

## WFL-11: Refine Mode Scorecard First

In refine mode, the output MUST begin with a Quality Scorecard showing the current state of the workflow document before changes. The scorecard MUST include: confidence distribution, rule compliance, coverage of test strategy stages, and identified gaps.

## WFL-12: CI Pipeline Mermaid Diagram

CI pipeline section MUST include at least one Mermaid diagram showing the flow from commit to production. The diagram MUST show: stages, gates (blocking vs advisory), and decision points (PR merged, release trigger). Additional Mermaid diagrams for hotfix flow are RECOMMENDED.

## WFL-13: Semver Release Versioning

Release process MUST define a version tagging strategy using Semantic Versioning (MAJOR.MINOR.PATCH). MUST specify what triggers each version component bump. Tag format MUST be defined (e.g., `v1.0.0`). Changelog generation method MUST be specified.

## WFL-14: Rollback Procedures Per Environment

Rollback procedure MUST be documented for each environment (staging, production at minimum). Each rollback MUST specify: trigger condition (when to rollback), rollback method (revert commit, redeploy previous tag, feature flag), verification steps, and communication requirements.
