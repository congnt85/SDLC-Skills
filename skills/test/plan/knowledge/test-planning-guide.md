# Test Planning Guide

Techniques and heuristics for building a detailed, actionable test plan.

---

## 1. Test Scope Definition

### Technique: MVP-Boundary Scoping

Use the backlog's MoSCoW prioritization to define test scope tiers:

- **Must Have stories** = mandatory full test coverage (happy path + negative + edge cases)
- **Should Have stories** = standard test coverage (happy path + key negative cases)
- **Could Have stories** = minimal test coverage (happy path only)
- **Won't Have / deferred** = out of scope for this test plan

### Scoping Decisions

Document explicit scoping decisions:
- **In scope**: All stories in the current release, cross-component integrations, NFR targets
- **Out of scope**: Deferred features, third-party service internals, future release stories
- **Boundary cases**: Items tested at integration boundaries but not internally (e.g., "Auth0 login flow is tested at integration boundary, not Auth0 internals")

### Testability Assumptions

State assumptions about what is testable:
- "API endpoints are testable via automated HTTP calls"
- "UI flows are testable via browser automation"
- "Database migrations are testable via rollback/forward scripts"
- "Third-party webhooks are testable via mock callbacks"

Flag any item where testability is uncertain as UNCLEAR.

---

## 2. Test Phase Design

### Standard Phase Progression

Typical test phases, ordered by when they occur:

| Phase | Timing | Driver | Focus |
|-------|--------|--------|-------|
| Sprint Testing | Each sprint | Developers | Unit + integration tests for new code |
| Feature Testing | After feature complete | QA | Functional testing of completed features per epic |
| Integration Testing | After features merge | QA + Dev | Cross-component and cross-epic interaction testing |
| System Testing | End of release cycle | QA | Full system testing in staging environment |
| NFR Testing | Parallel with system | QA + DevOps | Performance, security, scalability testing |
| Regression Testing | Pre-release | QA | Full regression suite to catch regressions |
| UAT | Pre-release | Stakeholders | User acceptance and sign-off |

### Mapping Phases to Releases

For each release in the backlog:
1. Identify which phases apply (MVP may skip NFR testing if no NFR targets yet)
2. Estimate duration based on story count and complexity
3. Identify phase dependencies (system testing cannot start until feature testing completes)
4. Map phases to sprint boundaries

### Phase Dependencies

Common dependency chains:
- Sprint Testing -> Feature Testing (cannot test feature until stories are done)
- Feature Testing -> Integration Testing (cannot test cross-component until features work individually)
- Integration Testing -> System Testing (cannot test full system until integrations verified)
- System Testing -> Regression + UAT (cannot release until system verified)
- NFR Testing can often run in parallel with System Testing (on a separate environment)

---

## 3. Effort Estimation

### Estimation Heuristics

These are rules of thumb -- adjust based on team experience and project complexity:

| Activity | Estimation Basis | Typical Effort |
|----------|-----------------|----------------|
| Unit tests | Included in story point estimates | Not separately estimated |
| Integration tests | Per integration boundary | ~20% of development effort |
| API tests | Per API resource | ~2-4 hours per resource (full CRUD suite) |
| E2E tests | Per critical user flow | ~4-8 hours per flow |
| Performance tests | Per NFR scenario | ~2-3 days per scenario |
| Security tests | Per application | ~2-3 days for automated scan + manual review |
| Regression suite | Per release | ~1-2 days execution, 2-3 days maintenance |
| UAT | Per release | ~3-5 days (stakeholder availability dependent) |

### Total Testing Effort

Testing effort is typically 30-40% of total project effort:
- Small project (< 20 stories): 30% of development time
- Medium project (20-50 stories): 35% of development time
- Large project (50+ stories): 40% of development time

### Effort Adjustment Factors

Increase estimates when:
- Team is new to the technology (+20-30%)
- Domain is complex (finance, healthcare) (+15-25%)
- High regulatory requirements (+20-30%)
- Multiple integration points (+10-20%)
- First release (no existing regression suite) (+15-20%)

Decrease estimates when:
- Team has mature testing practices (-10-15%)
- Existing test infrastructure can be reused (-10-20%)
- Simple CRUD-heavy application (-10-15%)

---

## 4. Entry/Exit Criteria Design

### Entry Criteria Principles

Entry criteria answer: "What must be true before we can start this test phase?"

Good entry criteria are:
- **Measurable**: Can be objectively verified (not "code is good enough")
- **Binary**: Either met or not met (no partial credit)
- **Actionable**: Clear who is responsible for meeting them
- **Documented**: Written down and agreed upon

Common entry criteria by phase:
- **Feature Testing**: Story marked as "Dev Complete", code merged to feature branch, unit tests passing, code review approved
- **System Testing**: All Must Have stories complete, CI pipeline green, staging environment deployed and verified, test data seeded
- **NFR Testing**: System testing exit criteria met, performance environment provisioned, baseline metrics captured
- **UAT**: System testing and NFR testing exit criteria met, UAT environment deployed, UAT test scripts prepared, UAT participants confirmed

### Exit Criteria Principles

Exit criteria answer: "What must be true before we can consider this test phase done?"

Good exit criteria are:
- **Quantitative**: Include specific numbers (95% pass rate, not "most tests pass")
- **Aligned with DoD**: Map directly to Definition of Done criteria
- **Risk-aware**: Higher standards for critical functionality
- **Achievable**: Realistic given team capacity and timeline

Common exit criteria by phase:
- **Sprint Testing**: Coverage targets met (line >= X%, branch >= Y%), CI green, no open blockers
- **Feature Testing**: All ACs verified, 100% critical tests pass, 95% high tests pass, no open Critical/High bugs for this feature
- **System Testing**: All cross-component flows pass, 100% critical tests pass, 95% overall pass rate, no open Critical bugs, coverage >= target
- **NFR Testing**: All performance targets met (response time, throughput, error rate), security scan clean (no Critical/High findings), scalability targets verified
- **UAT**: Stakeholder sign-off obtained, all critical UAT scenarios pass, feedback documented and triaged

### Mapping Exit Criteria to DoD

For each DoD criterion from dor-dod-final.md:
1. Identify which test phase verifies it
2. Create a specific exit criterion that demonstrates compliance
3. Reference the DoD item (e.g., "DoD-03: Coverage >= 80%")

---

## 5. Defect Management Process

### Severity Classification

Define severity based on user/business impact:

| Severity | Definition | Characteristics |
|----------|-----------|----------------|
| Critical | System is unusable or data is corrupted | Production down, data loss, security breach, no workaround |
| High | Major feature is broken or severely degraded | Core workflow blocked, workaround exists but is painful |
| Medium | Feature works but with noticeable issues | Degraded experience, easy workaround available |
| Low | Cosmetic or minor issue | Typo, alignment, minor UI glitch, no functional impact |

### Priority vs Severity

Severity = impact on the user. Priority = urgency of the fix.

A Critical severity bug in an unused feature might be Medium priority.
A Low severity bug on the login page might be High priority.

Priority is determined during triage based on:
- Severity
- Frequency (how many users are affected)
- Business impact (revenue, reputation, compliance)
- Workaround availability

### Triage Process

Recommended triage cadence:
- **During active test phases**: Daily 15-minute triage standup
- **During sprints**: Part of daily standup or weekly bug review
- **Pre-release**: Daily triage until zero Critical/High bugs

Triage workflow:
1. New bug reported -> Status: Open
2. Triage meeting -> Assign severity, priority, sprint
3. Developer picks up -> Status: In Progress
4. Fix implemented -> Status: Fixed (triggers regression test)
5. QA verifies fix -> Status: Verified (or Reopened)
6. Release deployed -> Status: Closed

### Fix SLA by Severity

| Severity | Response Time | Fix Time | Regression Test |
|----------|-------------|----------|----------------|
| Critical | 1 hour | 4 hours | Immediate, full regression |
| High | 4 hours | 24 hours | Same sprint, targeted regression |
| Medium | 1 business day | Current sprint | Next regression cycle |
| Low | 3 business days | Next sprint or backlog | Next regression cycle |

### Regression Testing Policy

Regression testing is triggered when:
- Any Critical or High severity bug is fixed
- More than 3 Medium severity bugs are fixed in one sprint
- A fix touches shared code (utilities, middleware, database schema)
- Pre-release (full regression regardless)

---

## 6. Test Reporting

### What to Report

| Metric | Description | Frequency |
|--------|------------|-----------|
| Test execution progress | Tests planned vs executed vs passed vs failed | Daily during test phases |
| Coverage metrics | Code coverage (line/branch), requirement coverage | Per sprint |
| Defect metrics | Open/closed/by severity, find rate, fix rate | Daily during test phases |
| Risk status | Testing risks status (mitigated/open/realized) | Weekly |
| Environment status | Environment availability and health | Daily during test phases |
| Schedule adherence | Planned vs actual timeline | Weekly |

### Report Types

- **Sprint Test Report**: Summary of testing completed in the sprint. Audience: Scrum team.
- **Feature Test Report**: Detailed results per epic/feature. Audience: QA Lead, Tech Lead.
- **System Test Report**: Full system testing results with coverage analysis. Audience: Project team.
- **NFR Test Report**: Performance/security results against targets. Audience: Tech Lead, DevOps.
- **Final Test Summary**: Pre-release summary for go/no-go decision. Audience: Stakeholders.

### Dashboard Metrics for Stakeholders

Key metrics for executive dashboard:
- Overall test pass rate (%)
- Open bug count by severity (bar chart)
- Test execution burndown (planned vs actual)
- Coverage trend (sprint over sprint)
- Defect discovery vs resolution rate
