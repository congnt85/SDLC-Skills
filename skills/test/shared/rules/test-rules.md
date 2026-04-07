# Test Phase Rules

Rules specific to all skills in the test phase.

---

## Content Rules

### TST-01: Trace to Requirements
Every test case MUST trace to at least one:
- Acceptance criterion (US-xxx.AC-N)
- Quality attribute (QA-xxx)
- Risk mitigation (RISK-xxx)
- API endpoint specification
- Database constraint

Tests that don't trace to requirements are waste.

### TST-02: Test Pyramid Compliance
Test strategy MUST follow the test pyramid:
- Unit tests: highest volume (60-70% of tests)
- Integration tests: moderate volume (20-25%)
- API/contract tests: targeted (5-10%)
- E2E tests: minimal, high-value flows only (5-10%)

Inverting the pyramid (more E2E than unit) MUST be flagged as a risk.

### TST-03: Risk-Based Prioritization
Test coverage MUST be prioritized by risk:
- High-risk features (from risk register) → comprehensive test coverage
- Must Have stories → full AC coverage
- Should/Could Have → at minimum happy path coverage

### TST-04: NFR Test Scenarios Required
Every quality attribute (QA-xxx) from scope MUST have at least one test scenario:
- Performance targets → load/stress test scenarios
- Availability targets → failover/recovery test scenarios
- Security requirements → security test scenarios
- Scalability targets → scalability test scenarios

### TST-05: Negative Testing Required
For every happy-path test case, at least one negative/edge-case test MUST exist:
- Invalid input handling
- Authorization failures
- Resource not found
- Boundary conditions
- Concurrent access

### TST-06: Test Data Strategy Required
Test plans MUST define:
- How test data is created (fixtures, factories, seeds)
- How test data is isolated (per-test, per-suite)
- How test data is cleaned up
- Sensitive data handling (no production PII in test data)

### TST-07: Automation First
All tests at unit, integration, and API levels MUST be automatable.
Manual testing is only acceptable for:
- Exploratory testing
- Usability testing
- Visual regression (until automated)

### TST-08: Test Independence
Tests MUST NOT depend on:
- Execution order
- Other tests' side effects
- Shared mutable state
- External service availability (use mocks/stubs for unit tests)

### TST-09: DoD Alignment
Test exit criteria MUST align with Definition of Done (DoD) from `dor-dod-final.md`.
Every DoD criterion related to testing MUST map to a specific test activity.

### TST-10: Coverage Targets Required
Test strategy MUST specify measurable coverage targets:
- Code coverage percentage (line and branch)
- Requirement coverage (% of ACs with test cases)
- Risk coverage (% of identified risks with test scenarios)

---

## Artifact Rules

### TST-11: Mermaid Diagrams for Test Architecture
Test strategy MUST include at least one diagram showing:
- Test levels and their scope
- Test environment topology
- CI/CD test pipeline stages

### TST-12: Test Case Format Consistency
All test cases MUST use the same format:
- Unique ID (TC-xxx)
- Title, priority, type, source reference
- Preconditions, steps, expected results, test data

### TST-13: Approval Section Required
Every test artifact MUST include an Approval section with QA Lead and Technical Lead roles.
