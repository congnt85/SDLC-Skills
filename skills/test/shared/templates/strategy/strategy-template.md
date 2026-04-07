# Test Strategy Template

Standard format for defining the overall testing approach.

---

## Strategy Structure

```markdown
### Test Level: {Level Name}

| Field | Value |
|-------|-------|
| **Scope** | {what this level tests} |
| **Tools** | {testing frameworks/tools} |
| **Responsibility** | {who writes/maintains these tests} |
| **Automation** | Yes / Partial / Manual |
| **Coverage Target** | {percentage or metric} |
| **Runs In** | {CI stage / manual trigger / schedule} |

**Includes**:
- {type of test 1}
- {type of test 2}

**Excludes**:
- {what this level does NOT test}
```

---

## Test Pyramid Diagram

```mermaid
graph TB
    E2E["E2E Tests<br/>5-10%<br/>High-value flows"]
    API["API/Contract Tests<br/>5-10%<br/>Endpoint validation"]
    INT["Integration Tests<br/>20-25%<br/>Component interactions"]
    UNIT["Unit Tests<br/>60-70%<br/>Business logic"]
    
    E2E --> API --> INT --> UNIT
    
    style UNIT fill:#4CAF50,color:#fff
    style INT fill:#8BC34A,color:#fff
    style API fill:#FFC107,color:#000
    style E2E fill:#FF9800,color:#fff
```

---

## Tool Selection Table

```markdown
| Purpose | Tool | Version | License | Justification |
|---------|------|---------|---------|---------------|
| Unit testing | {tool} | {ver} | {license} | {why chosen} |
| Integration testing | {tool} | {ver} | {license} | {why chosen} |
| API testing | {tool} | {ver} | {license} | {why chosen} |
| E2E testing | {tool} | {ver} | {license} | {why chosen} |
| Mocking/stubbing | {tool} | {ver} | {license} | {why chosen} |
| Code coverage | {tool} | {ver} | {license} | {why chosen} |
| Performance testing | {tool} | {ver} | {license} | {why chosen} |
| Security testing | {tool} | {ver} | {license} | {why chosen} |
```

---

## Coverage Target Table

```markdown
| Metric | Target | Measurement Tool | Enforcement |
|--------|--------|-----------------|-------------|
| Line coverage | {%} | {tool} | CI gate / advisory |
| Branch coverage | {%} | {tool} | CI gate / advisory |
| AC coverage | {%} | Manual tracking | Review gate |
| Risk coverage | {%} | Manual tracking | Review gate |
```

---

## Rules

- Test strategy MUST cover all test pyramid levels
- Tool selection MUST be compatible with tech stack (from tech-stack-final.md)
- Coverage targets MUST be measurable and enforced
- NFR testing approach MUST address all quality attributes (QA-xxx)
- Test environment requirements MUST be specified
