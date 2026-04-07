# Test Plan Output Rules

Rules specific to the test plan skill output.

---

## PLN-01: Test Scope Aligns with MVP Boundary

Test scope MUST align with the MVP boundary from `backlog-final.md`. Must Have stories MUST have full test coverage. Should/Could Have stories MUST be explicitly categorized by coverage level. Out-of-scope items MUST list the reason for exclusion.

## PLN-02: Test Phases Map to Release Structure

Test phases MUST map to the release/sprint structure from `backlog-final.md`. Each release MUST have its own set of test phases. Phase timing MUST align with sprint boundaries.

## PLN-03: Entry Criteria Are Measurable

Entry criteria MUST be measurable and verifiable. Each entry criterion MUST specify how it is verified (e.g., "CI pipeline green" not "code is ready"). Vague criteria like "good enough" or "mostly done" are NOT acceptable.

## PLN-04: Exit Criteria Align with DoD

Exit criteria MUST align with the Definition of Done from `dor-dod-final.md`. Each testing-related DoD criterion MUST map to at least one exit criterion. Exit criteria MUST include specific numeric targets (e.g., "95% pass rate" not "most tests pass").

## PLN-05: Resource Allocation Is Realistic

Resource allocation MUST be realistic given team constraints from charter or project context. Over-allocation (> 100% per person across all activities) MUST be flagged. Skill gaps MUST be identified with mitigation (training, hiring, contracting).

## PLN-06: Schedule Includes Dependencies

Test schedule MUST include dependencies between phases. Phase start dates MUST respect dependency chains (e.g., system testing cannot start before feature testing completes). Critical path MUST be identified.

## PLN-07: Environment Plan Specifies Timeline and Ownership

Environment plan MUST specify provisioning timeline (ready-by date) and ownership (who provisions and maintains). Infrastructure requirements and data preparation approach MUST be documented per environment.

## PLN-08: Defect Severity Definitions Are Explicit

Defect severity definitions MUST include concrete examples relevant to the project. Each severity level MUST have a fix SLA. The distinction between severity and priority MUST be documented.

## PLN-09: Section Order

Document MUST follow this section order:
1. Test Scope
2. Test Phases
3. Test Schedule
4. Resource Allocation
5. Entry/Exit Criteria
6. Environment Plan
7. Test Deliverables
8. Test Risks & Mitigations
9. Defect Management
10. Q&A Log
11. Readiness Assessment
12. Approval

## PLN-10: Confidence Markers on All Estimates

Every planning estimate (duration, effort, dates, resource allocation) MUST have a confidence marker. Schedule dates derived from backlog are CONFIRMED. Estimates based on heuristics are ASSUMED. Estimates with insufficient information are UNCLEAR.

## PLN-11: Refine Mode Shows Quality Scorecard First

In refine mode, the quality scorecard MUST be presented to the user BEFORE any changes are made. The scorecard evaluates the current draft against all PLN rules.

## PLN-12: Schedule Includes Buffer Time

Test schedule MUST include buffer time of at least 10% of total test phase duration. Buffer MUST be explicitly shown in the schedule table. Buffer rationale MUST be documented (e.g., "3 days buffer for 30 days of test phases").

## PLN-13: Test Risks Have Mitigation Plans

Every test risk MUST have a specific mitigation plan. Mitigations MUST be actionable (not "hope it doesn't happen"). Each risk MUST have an owner responsible for monitoring and mitigation.

## PLN-14: MVP Test Plan Identified Separately

If the test plan covers multiple releases, the MVP (R1) test plan MUST be identifiable as a standalone subset. MVP test phases, schedule, and criteria MUST be readable independently of later releases.
