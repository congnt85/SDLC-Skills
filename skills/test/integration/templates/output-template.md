# Test Integration Output Template

Use this template for all test-integration-draft.md output. Replace `{placeholders}` with actual content.

---

```markdown
# Integration & NFR Test Cases — {Project Name}

**Version**: draft | v{N}
**Date**: {date}
**Test Cases Reference**: test-cases-draft.md
**Architecture Reference**: architecture-final.md
**Status**: Draft | Under Review | Approved

---

## 1. Test Suite Overview

| Suite ID | Suite Name | Source | Type | Test Cases | Priority |
|----------|-----------|--------|------|-----------|----------|
| TS-INT-001 | {name} | {Component A -> Component B} | Integration | TC-001 — TC-005 | Critical |
| TS-INT-002 | {name} | {Component -> External} | Integration | TC-006 — TC-009 | High |
| TS-NFR-001 | {name} | QA-001 | NFR/Performance | TC-010 — TC-013 | Critical |
| TS-NFR-002 | {name} | QA-004 | NFR/Security | TC-014 — TC-018 | Critical |
| TS-NFR-003 | {name} | QA-002 | NFR/Availability | TC-019 — TC-020 | Critical |

**Summary**:
- Total test suites: {N}
- Total test cases: {N}
- By type: Integration ({N}), Performance ({N}), Security ({N}), Availability ({N}), Data Integrity ({N})
- By priority: Critical ({N}), High ({N}), Medium ({N}), Low ({N})

---

## 2. Integration Test Cases

### TS-INT-001: {Component Interaction Name}

#### TC-001: {Integration Test Title} ✅

| Field | Value |
|-------|-------|
| **ID** | TC-001 |
| **Type** | Integration |
| **Priority** | Critical |
| **Source** | {Component A -> Component B interaction} |
| **Automation** | Automated |

**Preconditions**:
1. {component A is running}
2. {component B is running}
3. {test data exists in both components}

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | {trigger action in component A} | {component A processes and calls component B} |
| 2 | {verify component B received the call} | {component B state updated correctly} |
| 3 | {verify end-to-end result} | {final state is consistent across components} |

**Test Data**:
| Field | Value | Component | Notes |
|-------|-------|-----------|-------|
| {field} | {value} | {component} | {notes} |

**Tags**: integration, happy-path, critical-path

---

### TS-INT-002: {Next Component Interaction}

#### TC-006: {Integration Test Title} ✅
{same format as above}

---

## 3. NFR Test Cases

### TS-NFR-001: Performance Tests (QA-001)

#### TC-010: {Performance Test Title} ✅

| Field | Value |
|-------|-------|
| **ID** | TC-010 |
| **Type** | Performance |
| **Priority** | Critical |
| **Source** | QA-001 |
| **Tool** | {performance testing tool, e.g., k6, JMeter} |

**Scenario**:
- {description of the load scenario and what it simulates}

**Test Configuration**:
| Parameter | Value |
|-----------|-------|
| Virtual users | {N} |
| Ramp-up period | {duration} |
| Sustained duration | {duration} |
| Target endpoint(s) | {endpoint list} |
| Think time | {duration between requests} |

**Test Data Volume**:
| Entity | Count | Notes |
|--------|-------|-------|
| {entity} | {N} | {pre-seeded before test} |

**Acceptance Criteria**:
| Metric | Target | Measurement Method |
|--------|--------|--------------------|
| p95 response time | < {target} | k6 summary / Grafana |
| p99 response time | < {target} | k6 summary / Grafana |
| Error rate | < {target}% | Failed requests / total |
| Throughput | > {target} RPS | Requests per second |

**Tags**: performance, nfr, load-test

---

### TS-NFR-002: Security Tests (QA-004)

#### TC-014: {Security Test Title} ✅

| Field | Value |
|-------|-------|
| **ID** | TC-014 |
| **Type** | Security |
| **Priority** | Critical |
| **Source** | QA-004 |
| **OWASP** | {OWASP Top 10 category, e.g., A03:2021 Injection} |

**Preconditions**:
1. {precondition}

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | {inject malicious input or attempt attack} | {input sanitized or rejected} |
| 2 | {verify no data leaked or unauthorized access} | {response contains only authorized data} |

**Tags**: security, nfr, negative

---

### TS-NFR-003: Availability Tests (QA-002)

#### TC-019: {Availability Test Title} ✅

| Field | Value |
|-------|-------|
| **ID** | TC-019 |
| **Type** | Availability |
| **Priority** | Critical |
| **Source** | QA-002 |
| **Automation** | Automated (requires infrastructure control) |

**Preconditions**:
1. {system is running and healthy}
2. {dependent service is available}

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | {disable or degrade a dependent service} | {application logs warning} |
| 2 | {send request to application} | {application responds with degraded but functional behavior} |
| 3 | {restore dependent service} | {application recovers to full functionality} |

**Tags**: availability, nfr, happy-path

---

## 4. Coverage Matrix

### AC Coverage (Combined: test-cases + test-integration)

| Story | Priority | AC | Functional TCs | Integration/NFR TCs | Coverage |
|-------|----------|-----|----------------|--------------------:|----------|
| US-001 | Must Have | AC-1 | TC-001, TC-002 (test-cases) | TC-001 (this doc) | ✅ Full |
| US-001 | Must Have | AC-2 | TC-003 (test-cases) | — | 🔶 Happy path only |
| US-002 | Must Have | AC-1 | — | — | ❌ Gap |

### API Endpoint Coverage (Combined)

| Endpoint | Happy | Auth | 404 | Validation | Integration | Coverage |
|----------|-------|------|-----|-----------|-------------|----------|
| POST /api/v1/{resource} | TC-xxx (test-cases) | TC-xxx (test-cases) | — | TC-xxx (test-cases) | TC-xxx (this doc) | ✅ Full |

### Risk Coverage

| Risk ID | Risk Description | Test Cases | Coverage |
|---------|-----------------|-----------|----------|
| RISK-001 | {risk description} | TC-xxx (test-cases), TC-xxx (this doc) | ✅ Full |
| RISK-002 | {risk description} | — | ❌ Gap |

### Coverage Summary

| Metric | Total | Covered | Coverage % | Target |
|--------|-------|---------|-----------|--------|
| Must Have ACs | {N} | {N} | {%} | ≥95% |
| Should Have ACs | {N} | {N} | {%} | ≥80% |
| API Endpoints | {N} | {N} | {%} | ≥90% |
| Quality Attributes | {N} | {N} | {%} | 100% |
| High/Critical Risks | {N} | {N} | {%} | 100% |
| Component Interactions | {N} | {N} | {%} | ≥90% |

---

## 5. Q&A Log

| # | Question | Context | Answer | Impact |
|---|----------|---------|--------|--------|
| 1 | {question about architecture interaction or NFR target} | {which TC affected} | {answer or PENDING} | {what changes if answered differently} |

---

## 6. Readiness Assessment

### Confidence Distribution

| Level | Count | % |
|-------|-------|---|
| ✅ CONFIRMED | {N} | {%} |
| 🔶 ASSUMED | {N} | {%} |
| ❓ UNCLEAR | {N} | {%} |

### Coverage Assessment

| Criterion | Status | Notes |
|-----------|--------|-------|
| Key component interactions covered | ✅ Met / ❌ Not Met | {details} |
| All QA attributes tested | ✅ Met / ❌ Not Met | {details} |
| Combined AC coverage ≥95% (Must Have) | ✅ Met / ❌ Not Met | {details} |
| UNCLEAR items ≤10% | ✅ Met / ❌ Not Met | {details} |

### Verdict: {Ready | Partially Ready | Not Ready}

{Justification paragraph explaining the verdict and any blocking issues.}

### Recommended Actions

1. {action to improve coverage or resolve UNCLEAR items}
2. {action}
3. {action}

---

## 7. Approval

| Role | Name | Decision | Date |
|------|------|----------|------|
| QA Lead | | Pending | |
| Technical Lead | | Pending | |
| Product Owner | | Pending | |
```
