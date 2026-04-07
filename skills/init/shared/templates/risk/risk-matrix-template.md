# Risk Matrix Template

Pre-populated common software project risks as starting points.
Users should review, adjust scores, and add project-specific risks.

---

## Common Software Project Risks

| ID | Category | Description | P | I | Score | Response | Mitigation |
|----|----------|-------------|---|---|-------|----------|------------|
| RISK-001 | Scope | Requirements not fully understood, leading to rework | 4 | 4 | 16 | Mitigate | Iterative refinement of requirements, regular PO reviews |
| RISK-002 | Resource | Key team member unavailable during critical phase | 3 | 4 | 12 | Mitigate | Cross-train team, document knowledge, avoid single points of failure |
| RISK-003 | Technical | Integration with external system more complex than estimated | 3 | 3 | 9 | Mitigate | Spike/PoC for integration early, budget extra time |
| RISK-004 | Schedule | Dependencies on external teams cause delays | 3 | 3 | 9 | Mitigate | Identify dependencies early, establish SLAs, create buffer |
| RISK-005 | Technical | Performance requirements not achievable with chosen architecture | 2 | 5 | 10 | Avoid | Performance PoC before committing, load test early |
| RISK-006 | Scope | Scope creep due to stakeholder additions | 4 | 3 | 12 | Mitigate | Scope change control process, clear charter boundaries |
| RISK-007 | External | Third-party API changes or becomes unavailable | 2 | 4 | 8 | Transfer | Abstraction layer, vendor SLA, fallback provider |
| RISK-008 | Organizational | Budget reduced mid-project | 2 | 5 | 10 | Accept | Prioritized backlog (MoSCoW), MVP can ship with Must-Haves only |
| RISK-009 | Technical | Security vulnerability in dependency | 3 | 4 | 12 | Mitigate | Dependency scanning, automated alerts, patch process |
| RISK-010 | Schedule | Underestimated complexity of core features | 4 | 3 | 12 | Mitigate | Spike uncertain features, three-point estimation, buffer |

---

## Risk Categories Checklist

Use this checklist to ensure all risk areas are covered:

### Technical
- [ ] Technology maturity and team expertise
- [ ] Integration complexity with external systems
- [ ] Performance and scalability requirements
- [ ] Security vulnerabilities and compliance
- [ ] Data migration from legacy systems
- [ ] Technical debt accumulation

### Resource
- [ ] Key person dependency (bus factor)
- [ ] Skill gaps in required technologies
- [ ] Team availability and competing priorities
- [ ] Contractor/vendor reliability

### Schedule
- [ ] Unrealistic timeline commitments
- [ ] External dependency delays
- [ ] Regulatory approval timelines
- [ ] Holiday/vacation impact on velocity

### Scope
- [ ] Requirements volatility / scope creep
- [ ] Unclear acceptance criteria
- [ ] Conflicting stakeholder priorities
- [ ] Missing edge cases discovered late

### External
- [ ] Third-party service changes or outages
- [ ] Regulatory or compliance changes
- [ ] Market or competitive changes
- [ ] Vendor lock-in risks

### Organizational
- [ ] Stakeholder or sponsor support changes
- [ ] Budget or funding changes
- [ ] Organizational restructuring
- [ ] Competing project priorities
