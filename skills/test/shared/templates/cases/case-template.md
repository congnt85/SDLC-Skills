# Test Case Template

Standard format for writing individual test cases.

---

## Test Case Format

```markdown
### TC-{NNN}: {Test Case Title}

| Field | Value |
|-------|-------|
| **ID** | TC-{NNN} |
| **Title** | {descriptive title} |
| **Type** | Unit / Integration / API / E2E / Performance / Security |
| **Priority** | Critical / High / Medium / Low |
| **Source** | US-{xxx}.AC-{N} / QA-{xxx} / RISK-{xxx} / API endpoint |
| **Automation** | Automated / Manual / To Be Automated |
| **Component** | {which component/module} |

**Preconditions**:
1. {precondition 1}
2. {precondition 2}

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | {action} | {expected result} |
| 2 | {action} | {expected result} |
| 3 | {action} | {expected result} |

**Test Data**:
| Input | Value | Notes |
|-------|-------|-------|
| {field} | {value} | {notes} |

**Postconditions**:
- {system state after test}

**Tags**: {comma-separated: smoke, regression, happy-path, edge-case, security, performance}
```

---

## Test Suite Structure

```markdown
### TS-{NNN}: {Test Suite Title}

| Field | Value |
|-------|-------|
| **Source** | US-{xxx} / EPIC-{xxx} / QA-{xxx} |
| **Type** | {test level} |
| **Test Cases** | TC-{NNN} through TC-{NNN} |
| **Priority** | {overall suite priority} |
```

---

## Test Case Summary Table

```markdown
| TC ID | Title | Type | Priority | Source | Automation | Status |
|-------|-------|------|----------|--------|------------|--------|
| TC-001 | {title} | Unit | High | US-001.AC-1 | Automated | Draft |
```

---

## Rules

- Every test case MUST have a unique ID (TC-{NNN})
- Every test case MUST trace to a source (AC, QA, RISK, or API endpoint)
- Test steps MUST be specific and reproducible
- Expected results MUST be verifiable (not vague like "works correctly")
- Test data MUST be specified (not "use valid data")
- Priority MUST match source priority (Must Have story → Critical/High test)
- Tags MUST include at least: test type and path type (happy-path/edge-case)
