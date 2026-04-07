# Test Strategy Output Rules

These rules govern the structure, content, and quality of test strategy documents produced by the test-strategy skill.

---

## STR-01: Test Pyramid Completeness

Test pyramid MUST define all 4 levels: unit, integration, API, and E2E. Each level MUST specify scope, tools, responsibility, automation target, coverage target, and CI stage.

**Check**: Count test levels defined. Must be exactly 4.

---

## STR-02: Tool-Stack Compatibility

Every test tool selected MUST be compatible with the tech stack defined in `tech-stack-final.md`. Incompatible tool selections (e.g., JUnit for a Node.js project, pytest for a Java project) are a validation failure.

**Check**: For each tool, verify the tool's ecosystem matches the project's primary language and framework.

---

## STR-03: NFR Test Coverage

Every quality attribute (QA-xxx) from `scope-final.md` MUST have a corresponding entry in the NFR Testing Approach section. Each entry MUST specify: test type, tool, target metric, and acceptance criteria.

**Check**: Count QA-xxx IDs in scope vs NFR testing table rows. Must match.

---

## STR-04: Measurable Coverage Targets

Coverage targets MUST be measurable with specific percentages. Vague targets like "high coverage" or "adequate testing" are not acceptable. Each target MUST specify: metric name, percentage, measurement tool, and enforcement mechanism (CI gate or advisory).

**Check**: Every row in the Coverage Targets table has a numeric percentage.

---

## STR-05: Risk-Based Prioritization Traceability

If `risk-register-final.md` is available, the Risk-Based Test Prioritization section MUST reference specific risk IDs (RISK-xxx). Each high-severity risk MUST have at least one test scenario mapped to it.

**Check**: RISK-xxx IDs in strategy match those in risk register.

---

## STR-06: Environment Minimum

Test environment strategy MUST define at least 3 environments: local development, CI, and staging. Each environment MUST specify: purpose, infrastructure, data approach, and external service strategy (mock vs real).

**Check**: Count environments defined. Must be >= 3.

---

## STR-07: Test Data Completeness

Test data strategy MUST address all 4 aspects: creation (how test data is generated), isolation (how tests avoid interfering with each other), cleanup (how test data is removed), and sensitive data handling (how PII/secrets are managed).

**Check**: All 4 aspects present in test data table.

---

## STR-08: Section Order

Sections MUST appear in this order:
1. Test Approach Overview
2. Test Levels
3. Test Architecture (Mermaid diagram)
4. Tool Selection
5. Test Environment Strategy
6. NFR Testing Approach
7. Risk-Based Test Prioritization
8. Coverage Targets
9. Test Data Strategy
10. Q&A Log
11. Readiness Assessment
12. Approval

**Check**: Section headings appear in the specified order.

---

## STR-09: Confidence Markers on Decisions

Every strategy decision MUST carry a confidence marker: ✅ CONFIRMED, 🔶 ASSUMED, or ❓ UNCLEAR. Decisions include: tool selections, coverage targets, environment choices, NFR thresholds, and prioritization assignments.

**Check**: No decision row or item lacks a confidence marker.

---

## STR-10: Refine Mode Scorecard

In refine mode, the output MUST begin with a quality scorecard showing: previous version scores, current version scores, and improvement delta. The scorecard MUST be presented to the user before applying changes.

**Check**: Scorecard section present at top of refine output.

---

## STR-11: CI/CD Pipeline Integration

The strategy MUST specify which tests run at which CI/CD pipeline stage. At minimum, define tests for: commit stage, PR stage, deploy stage, and release stage.

**Check**: Pipeline stage mapping table present with >= 4 stages.

---

## STR-12: Test Architecture Diagram

A Mermaid diagram showing the test architecture MUST be included. The diagram MUST show: test levels, their scope boundaries, and CI pipeline integration. This satisfies test phase rule TST-11.

**Check**: Mermaid code block present with test architecture content.

---

## STR-13: Automation Target

An overall automation percentage target MUST be specified. The target for unit + integration + API tests combined SHOULD be >= 90%. Any manual testing MUST be explicitly justified (e.g., exploratory testing, visual testing, accessibility audits).

**Check**: Automation percentage stated. Manual testing items have justification.

---

## STR-14: MVP Test Scope

If the project has a defined MVP scope (from backlog-final.md), the strategy MUST separately identify the MVP test scope — which tests are needed for MVP launch vs full product. This enables test effort prioritization.

**Check**: If backlog has MVP markers, MVP test scope section is present.
