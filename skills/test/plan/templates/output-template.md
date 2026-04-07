# Test Plan Output Template

Expected structure for the test plan document.

---

```markdown
# Test Plan -- {Project Name}

**Version**: draft | v{N}
**Date**: {date}
**Test Strategy Reference**: test-strategy-final.md
**Status**: Draft | Under Review | Approved

---

## 1. Test Scope

### In Scope

| Release | Stories | Epics | Test Focus |
|---------|---------|-------|------------|
| MVP (R1) | US-001 through US-{N} | EPIC-001, EPIC-002 | Full coverage |
| R2 | US-{N+1} through US-{M} | EPIC-003, EPIC-004 | Full coverage |

### Out of Scope

| Item | Reason |
|------|--------|
| {item} | {reason -- e.g., deferred to R3, third-party internals} |

### Assumptions

- {assumption about testability -- e.g., "Auth0 login flow tested at integration boundary only"}
- {assumption about data availability}
- {assumption about environment access}

---

## 2. Test Phases

### Phase 1: Sprint Testing (Continuous)

| Field | Value |
|-------|-------|
| **Scope** | Unit + integration tests per sprint |
| **Duration** | Throughout development (Sprint 1 -- Sprint {N}) |
| **Owner** | Development team |
| **Entry Criteria** | Story development started |
| **Exit Criteria** | Coverage targets met, CI green |

**Activities**:
1. Write unit tests alongside feature code
2. Write integration tests for component boundaries
3. Run CI pipeline on every PR

**Deliverables**:
- Sprint test report (coverage, pass rate)

### Phase 2: Feature Testing

| Field | Value |
|-------|-------|
| **Scope** | Functional testing per completed epic |
| **Duration** | {N} days per epic |
| **Owner** | QA team |
| **Entry Criteria** | Epic stories marked Dev Complete, unit tests passing |
| **Exit Criteria** | All ACs verified, no open Critical/High bugs for epic |

**Activities**:
1. Execute functional test cases per AC
2. Exploratory testing of feature workflows
3. Report and triage defects

**Deliverables**:
- Feature test report per epic

### Phase 3: System Testing

| Field | Value |
|-------|-------|
| **Scope** | Full system in staging, cross-epic flows |
| **Duration** | {N} days |
| **Owner** | QA team |
| **Entry Criteria** | All Must Have features complete, staging deployed, test data seeded |
| **Exit Criteria** | 100% critical tests pass, 95% overall pass, no open Critical bugs |

**Activities**:
1. Execute cross-component integration scenarios
2. End-to-end workflow testing
3. Data integrity verification

**Deliverables**:
- System test report

### Phase 4: NFR Testing

| Field | Value |
|-------|-------|
| **Scope** | Performance, security, scalability testing |
| **Duration** | {N} days |
| **Owner** | QA + DevOps |
| **Entry Criteria** | System testing exit criteria met, performance environment ready |
| **Exit Criteria** | All NFR targets met, security scan clean |

**Activities**:
1. Load testing against performance targets
2. Security scanning (OWASP ZAP or equivalent)
3. Scalability testing against growth scenarios

**Deliverables**:
- NFR test report

### Phase 5: Regression + UAT

| Field | Value |
|-------|-------|
| **Scope** | Full regression suite + stakeholder acceptance |
| **Duration** | {N} days |
| **Owner** | QA (regression), Stakeholders (UAT) |
| **Entry Criteria** | System + NFR testing exit criteria met, UAT environment deployed |
| **Exit Criteria** | Full regression pass, stakeholder sign-off obtained |

**Activities**:
1. Execute full regression suite
2. UAT scenario execution by stakeholders
3. Collect and triage stakeholder feedback

**Deliverables**:
- Regression test report
- UAT sign-off document

---

## 3. Test Schedule

```mermaid
gantt
    title Test Schedule
    dateFormat YYYY-MM-DD
    section MVP (R1)
    Sprint Testing        :active, sprint, {start}, {duration}
    Feature Testing       :feat, after sprint, {duration}
    System Testing        :sys, after feat, {duration}
    NFR Testing           :nfr, after feat, {duration}
    Regression + UAT      :uat, after sys, {duration}
    Buffer                :buffer, after uat, {duration}
```

| Phase | Start | End | Duration | Dependencies | Owner |
|-------|-------|-----|----------|--------------|-------|
| Sprint Testing | {date} | {date} | {duration} | Development started | Dev team |
| Feature Testing | {date} | {date} | {duration} | Epics Dev Complete | QA team |
| System Testing | {date} | {date} | {duration} | Feature Testing exit met | QA team |
| NFR Testing | {date} | {date} | {duration} | Feature Testing exit met | QA + DevOps |
| Regression + UAT | {date} | {date} | {duration} | System + NFR exit met | QA + Stakeholders |
| **Buffer** | {date} | {date} | {duration} | -- | -- |

**Total test phase duration**: {N} days (excluding sprint testing)
**Buffer**: {N} days ({%} of total)

---

## 4. Resource Allocation

| Role | Person/Team | Allocation | Phases | Skills Required |
|------|------------|------------|--------|-----------------|
| Developer | {name/team} | {%} | Sprint Testing, Feature Testing support | {tech stack skills} |
| QA Lead | {name} | {%} | Feature, System, NFR, Regression | {testing tool skills} |
| QA Engineer | {name} | {%} | Feature, System, Regression | {testing skills} |
| DevOps | {name} | {%} | NFR, Environment setup | {infra skills} |

### Tool Licenses

| Tool | Licenses Needed | Cost | Procurement Status |
|------|----------------|------|--------------------|
| {tool} | {count} | {cost} | {status: Available / Needed / Ordered} |

---

## 5. Entry/Exit Criteria

### Entry Criteria

| ID | Phase | Criterion | Verification |
|----|-------|-----------|--------------|
| ENTRY-01 | Feature Testing | Epic stories Dev Complete | JIRA status check |
| ENTRY-02 | System Testing | All Must Have stories complete | Backlog review |
| ENTRY-03 | System Testing | Staging environment deployed | Deployment verification |
| ENTRY-04 | System Testing | Test data seeded | Data verification script |
| ENTRY-05 | NFR Testing | Performance environment provisioned | Infra health check |
| ENTRY-06 | UAT | System + NFR exit criteria met | Test report review |

### Exit Criteria

| ID | Phase | Criterion | Metric | Target | DoD Ref |
|----|-------|-----------|--------|--------|---------|
| EXIT-01 | Sprint Testing | Code coverage | Line coverage | >= {X}% | DOD-{N} |
| EXIT-02 | Sprint Testing | CI pipeline | Pass rate | 100% green | DOD-{N} |
| EXIT-03 | Feature Testing | AC verification | AC pass rate | 100% critical | DOD-{N} |
| EXIT-04 | System Testing | System tests | Pass rate | >= 95% | DOD-{N} |
| EXIT-05 | System Testing | Critical bugs | Open count | 0 Critical | DOD-{N} |
| EXIT-06 | NFR Testing | Performance targets | Response time | < {N}ms p95 | DOD-{N} |
| EXIT-07 | Regression + UAT | Regression suite | Pass rate | 100% critical | DOD-{N} |
| EXIT-08 | Regression + UAT | Stakeholder sign-off | Sign-off obtained | Yes | DOD-{N} |

---

## 6. Environment Plan

| Environment | Owner | Ready By | Infrastructure | Data |
|-------------|-------|----------|----------------|------|
| Local dev | Developers | Day 1 | Developer machines | Fixtures/seeds |
| CI | DevOps | Sprint 1 | {CI provider} | Ephemeral test DB |
| Staging | DevOps | Sprint {N} | {cloud/on-prem} | Production-like synthetic |
| Performance | DevOps | Sprint {N} | {cloud/on-prem, dedicated} | Production-scale synthetic |
| UAT | DevOps | Sprint {N} | {cloud/on-prem} | Curated UAT dataset |

### Service Dependencies

| Dependency | Approach | Owner |
|-----------|----------|-------|
| {external service} | {mock / sandbox / live} | {owner} |

---

## 7. Test Deliverables

| Deliverable | Format | Frequency | Audience |
|-------------|--------|-----------|----------|
| Sprint test report | Markdown summary | Per sprint | Scrum team |
| Feature test report | Detailed report per epic | Per epic completion | QA Lead, Tech Lead |
| System test report | Comprehensive test results | End of system testing | Project team |
| NFR test report | Performance/security results | End of NFR testing | Tech Lead, DevOps |
| Final test summary | Go/no-go recommendation | Pre-release | Stakeholders |
| Coverage report | Tool-generated | Per sprint | Dev team |
| Defect report | Bug tracker export | Weekly during test phases | Project team |

---

## 8. Test Risks & Mitigations

| ID | Risk | Impact | Likelihood | Mitigation | Owner |
|----|------|--------|------------|------------|-------|
| TR-001 | {risk description} | High/Med/Low | High/Med/Low | {specific mitigation} | {owner} |
| TR-002 | {risk description} | High/Med/Low | High/Med/Low | {specific mitigation} | {owner} |

---

## 9. Defect Management

### Severity Definitions

| Severity | Definition | Example | Fix SLA |
|----------|-----------|---------|---------|
| Critical | System unusable or data corruption | {project-specific example} | {SLA} |
| High | Major feature broken, painful workaround | {project-specific example} | {SLA} |
| Medium | Feature degraded, easy workaround | {project-specific example} | {SLA} |
| Low | Cosmetic or minor issue | {project-specific example} | {SLA} |

### Priority vs Severity

Priority is determined during triage based on severity, frequency, business impact, and workaround availability. A Critical severity bug in an unused feature may be Medium priority.

### Triage Process

- **During test phases**: Daily 15-minute triage standup
- **During sprints**: Weekly bug review
- **Pre-release**: Daily triage until zero Critical/High bugs

### Regression Policy

Regression testing is triggered when:
- Any Critical or High severity bug is fixed
- More than 3 Medium severity bugs are fixed in one sprint
- A fix touches shared code (utilities, middleware, schema)
- Pre-release (full regression regardless)

---

## 10. Q&A Log

| ID | Question | Priority | Source | Answer | Status |
|----|----------|----------|--------|--------|--------|
| Q-01 | {question} | HIGH/MED/LOW | {section} | {answer or pending} | Open/Resolved |

---

## 11. Readiness Assessment

### Confidence Summary

| Level | Count | Percentage |
|-------|-------|------------|
| CONFIRMED | {N} | {%} |
| ASSUMED | {N} | {%} |
| UNCLEAR | {N} | {%} |

### Verdict: {Ready / Partially Ready / Not Ready}

{Rationale for verdict}

### Recommendations

1. {recommendation to improve readiness}
2. {recommendation to resolve UNCLEAR items}

---

## 12. Approval

| Role | Name | Decision | Date |
|------|------|----------|------|
| QA Lead | | Pending | |
| Technical Lead | | Pending | |
| Project Manager | | Pending | |
```
