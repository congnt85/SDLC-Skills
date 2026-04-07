# Test Cases Output Template

Use this template for all test-cases-draft.md output. Replace `{placeholders}` with actual content.

---

```markdown
# Test Cases — {Project Name}

**Version**: draft | v{N}
**Date**: {date}
**Test Strategy Reference**: test-strategy-final.md
**Test Plan Reference**: test-plan-final.md
**Status**: Draft | Under Review | Approved

---

## 1. Test Suite Overview

| Suite ID | Suite Name | Source | Type | Test Cases | Priority |
|----------|-----------|--------|------|-----------|----------|
| TS-001 | {name} | US-001 | Functional | TC-001 — TC-005 | High |
| TS-002 | {name} | US-002 | Functional | TC-006 — TC-010 | High |
| TS-010 | {name} | /api/v1/projects | API | TC-050 — TC-060 | High |
| TS-020 | {name} | QA-001 | NFR/Performance | TC-100 — TC-103 | Critical |

**Summary**:
- Total test suites: {N}
- Total test cases: {N}
- By type: Functional ({N}), API ({N}), Integration ({N}), NFR ({N})
- By priority: Critical ({N}), High ({N}), Medium ({N}), Low ({N})
- Automation: Automated ({N}), Manual ({N})

---

## 2. Functional Test Cases

### TS-001: {User Story Title} (US-001)

#### TC-001: {Test Case Title} ✅

| Field | Value |
|-------|-------|
| **ID** | TC-001 |
| **Type** | Functional |
| **Priority** | High |
| **Source** | US-001.AC-1 |
| **Automation** | Automated |

**Preconditions**:
1. {precondition 1}
2. {precondition 2}

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | {specific action with concrete values} | {verifiable expected result} |
| 2 | {specific action with concrete values} | {verifiable expected result} |
| 3 | {specific action with concrete values} | {verifiable expected result} |

**Test Data**:
| Field | Value | Notes |
|-------|-------|-------|
| {field} | {concrete value} | {notes} |
| {field} | {concrete value} | {notes} |

**Postconditions**:
1. {postcondition — state after test completes}

**Tags**: functional, happy-path, smoke

---

#### TC-002: {Negative Test Case Title} ✅

| Field | Value |
|-------|-------|
| **ID** | TC-002 |
| **Type** | Functional |
| **Priority** | High |
| **Source** | US-001.AC-1 |
| **Automation** | Automated |

**Preconditions**:
1. {precondition}

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | {action that triggers failure/edge case} | {expected error or behavior} |
| 2 | {verify no side effects} | {system state unchanged} |

**Test Data**:
| Field | Value | Notes |
|-------|-------|-------|
| {field} | {invalid/edge value} | {why this triggers the scenario} |

**Tags**: functional, negative, security

---

### TS-002: {Next User Story Title} (US-002)

#### TC-003: {Test Case Title} ✅
{same format as above}

---

## 3. API Test Cases

### TS-010: {Resource} API Tests (/api/v1/{resource})

#### TC-050: {API Happy Path Title} ✅

| Field | Value |
|-------|-------|
| **ID** | TC-050 |
| **Type** | API |
| **Priority** | High |
| **Source** | POST /api/v1/{resource} |
| **Automation** | Automated |

**Preconditions**:
1. {precondition — user authenticated, data exists, etc.}

**Request**:
```
{METHOD} /api/v1/{resource}
Authorization: Bearer {valid_jwt_token}
Content-Type: application/json

{
  "field1": "concrete_value",
  "field2": 42
}
```

**Expected Response**:
```
HTTP {status_code} {status_text}
Content-Type: application/json

{
  "id": "uuid-format",
  "field1": "concrete_value",
  "field2": 42,
  "created_at": "ISO-8601 timestamp"
}
```

**Assertions**:
- Status code is {expected_status}
- Response body contains `id` field with UUID format
- Response body `field1` equals `"concrete_value"`
- Database table `{table}` has new row with matching values
- Response header `Location` contains resource URL

**Tags**: api, happy-path, smoke

---

#### TC-051: {API Auth Failure Title} ✅

| Field | Value |
|-------|-------|
| **ID** | TC-051 |
| **Type** | API |
| **Priority** | Critical |
| **Source** | POST /api/v1/{resource} |
| **Automation** | Automated |

**Preconditions**:
1. No authentication token available

**Request**:
```
{METHOD} /api/v1/{resource}
Content-Type: application/json

{valid request body — same as happy path}
```

**Expected Response**:
```
HTTP 401 Unauthorized
Content-Type: application/json

{
  "error": "UNAUTHORIZED",
  "message": "Authentication required"
}
```

**Assertions**:
- Status code is 401
- No resource created in database
- Response body contains error code

**Tags**: api, negative, security

---

#### TC-052: {API Not Found Title} ✅

| Field | Value |
|-------|-------|
| **ID** | TC-052 |
| **Type** | API |
| **Priority** | High |
| **Source** | GET /api/v1/{resource}/{id} |
| **Automation** | Automated |

**Preconditions**:
1. User is authenticated
2. Resource ID `{nonexistent_uuid}` does not exist

**Request**:
```
GET /api/v1/{resource}/00000000-0000-0000-0000-000000000000
Authorization: Bearer {valid_jwt_token}
```

**Expected Response**:
```
HTTP 404 Not Found
Content-Type: application/json

{
  "error": "NOT_FOUND",
  "message": "{Resource} not found"
}
```

**Assertions**:
- Status code is 404
- Response body contains meaningful error message

**Tags**: api, negative, edge-case

---

## 4. Integration Test Cases

### TS-030: {Component Interaction} Integration Tests

#### TC-080: {Integration Test Title} ✅

| Field | Value |
|-------|-------|
| **ID** | TC-080 |
| **Type** | Integration |
| **Priority** | High |
| **Source** | {component A → component B interaction} |
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

## 5. NFR Test Cases

### TS-020: Performance Tests (QA-001)

#### TC-100: {Performance Test Title} ✅

| Field | Value |
|-------|-------|
| **ID** | TC-100 |
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

### TS-021: Security Tests (QA-004)

#### TC-110: {Security Test Title} ✅

| Field | Value |
|-------|-------|
| **ID** | TC-110 |
| **Type** | Security |
| **Priority** | Critical |
| **Source** | QA-004 |
| **OWASP** | {OWASP Top 10 category, e.g., A03:2021 Injection} |

**Preconditions**:
1. {precondition}

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | {inject malicious input} | {input sanitized or rejected} |
| 2 | {verify no data leaked} | {response contains only authorized data} |

**Tags**: security, nfr, negative

---

## 6. Test Data Specifications

### Test Data Set: {name}

**Purpose**: {what tests this data set supports}

| Entity | Count | Key Fields | Relationships | Creation Method |
|--------|-------|-----------|---------------|----------------|
| {entity} | {N} | {key fields with sample values} | {FK relationships} | Seed / Factory / Manual |
| {entity} | {N} | {key fields with sample values} | {FK relationships} | Seed / Factory / Manual |

**Setup Script**: {location or description of setup automation}

**Teardown**: {how test data is cleaned up — transaction rollback, truncate, delete}

---

## 7. Coverage Matrix

### AC Coverage

| Story | Priority | AC | Test Cases | Coverage |
|-------|----------|-----|-----------|----------|
| US-001 | Must Have | AC-1 | TC-001, TC-002 | ✅ Full |
| US-001 | Must Have | AC-2 | TC-003 | 🔶 Happy path only |
| US-002 | Must Have | AC-1 | — | ❌ Gap |

### API Endpoint Coverage

| Endpoint | Happy | Auth | 404 | Validation | Other | Coverage |
|----------|-------|------|-----|-----------|-------|----------|
| GET /api/v1/projects | TC-050 | TC-051 | — | — | — | 🔶 Partial |
| POST /api/v1/projects | TC-055 | TC-056 | — | TC-057 | TC-058 (409) | ✅ Full |

### Risk Coverage

| Risk ID | Risk Description | Test Cases | Coverage |
|---------|-----------------|-----------|----------|
| RISK-001 | {risk description} | TC-xxx, TC-yyy | ✅ Full |
| RISK-002 | {risk description} | — | ❌ Gap |

### Coverage Summary

| Metric | Total | Covered | Coverage % | Target |
|--------|-------|---------|-----------|--------|
| Must Have ACs | {N} | {N} | {%} | ≥95% |
| Should Have ACs | {N} | {N} | {%} | ≥80% |
| API Endpoints | {N} | {N} | {%} | ≥90% |
| Quality Attributes | {N} | {N} | {%} | 100% |
| High/Critical Risks | {N} | {N} | {%} | 100% |

---

## 8. Q&A Log

| # | Question | Context | Answer | Impact |
|---|----------|---------|--------|--------|
| 1 | {question about ambiguous requirement} | {which TC affected} | {answer or PENDING} | {what changes if answered differently} |

---

## 9. Readiness Assessment

### Confidence Distribution

| Level | Count | % |
|-------|-------|---|
| ✅ CONFIRMED | {N} | {%} |
| 🔶 ASSUMED | {N} | {%} |
| ❓ UNCLEAR | {N} | {%} |

### Coverage Assessment

| Criterion | Status | Notes |
|-----------|--------|-------|
| Must Have AC coverage ≥95% | ✅ Met / ❌ Not Met | {details} |
| API endpoint coverage ≥90% | ✅ Met / ❌ Not Met | {details} |
| All QA attributes tested | ✅ Met / ❌ Not Met | {details} |
| UNCLEAR items ≤10% | ✅ Met / ❌ Not Met | {details} |

### Verdict: {Ready | Partially Ready | Not Ready}

{Justification paragraph explaining the verdict and any blocking issues.}

### Recommended Actions

1. {action to improve coverage or resolve UNCLEAR items}
2. {action}
3. {action}

---

## 10. Approval

| Role | Name | Decision | Date |
|------|------|----------|------|
| QA Lead | | Pending | |
| Technical Lead | | Pending | |
| Product Owner | | Pending | |
```
