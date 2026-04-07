# SLA/SLO/SLI Guide

This guide provides domain knowledge and techniques for defining service level agreements, objectives, and indicators. Use these patterns when building SLA specifications for any project.

---

## 1. SLI/SLO/SLA Definitions and Relationships

The three concepts form a hierarchy from measurement to commitment:

### SLI (Service Level Indicator)

An SLI is a **quantitative measurement** of a specific aspect of service quality. It answers: "How do we measure this?"

- Always expressed as a ratio or percentage (e.g., successful requests / total requests)
- Must be derived from real metrics collected by the monitoring system
- Should reflect what users experience, not internal system state
- One quality attribute may require multiple SLIs

**Good SLIs**: Request success rate, p95 latency, data freshness percentage
**Bad SLIs**: CPU usage, memory consumption, disk I/O (these are diagnostic metrics, not user-facing)

### SLO (Service Level Objective)

An SLO is an **internal target** for an SLI. It answers: "What level of service do we aim for?"

- Set by the engineering team based on quality attribute requirements
- More aggressive than SLA (provides a buffer before contractual breach)
- Measured over a rolling time window (typically 30 days)
- Breaching an SLO triggers internal action (investigation, feature freeze)
- Directly determines the error budget

**Example**: "99.5% of API requests return successfully over a 30-day rolling window"

### SLA (Service Level Agreement)

An SLA is an **external commitment** with consequences. It answers: "What do we promise our users?"

- Contractual agreement between service provider and customers
- Less aggressive than SLO (e.g., SLO = 99.5%, SLA = 99.0%)
- Breach has financial or contractual consequences (credits, penalties)
- Not all services need external SLAs -- many operate with SLOs only
- SLA targets should be achievable even when SLO is occasionally breached

**Hierarchy flow**: SLI (measurement) -> SLO (internal target on that measurement) -> SLA (external promise, less strict than SLO)

### Why the Gap Between SLO and SLA Matters

The buffer between SLO and SLA gives the team time to:
1. Detect degradation before it becomes a contractual breach
2. Take corrective action (feature freeze, incident response)
3. Consume error budget on planned maintenance and deployments
4. Avoid triggering financial consequences for temporary dips

---

## 2. Choosing SLIs

### SLI Categories

**Availability** -- Is the service up and responding?
- Formula: `successful requests / total requests`
- "Successful" typically means non-5xx responses (excluding client errors 4xx)
- Measured at the load balancer or API gateway level
- Window: per-minute for alerting, 30-day rolling for SLO tracking

**Latency** -- Is the service fast enough?
- Formula: `% of requests completing within threshold`
- Use percentiles, not averages (p50 for typical, p95 for tail, p99 for worst case)
- Threshold derived from quality attributes (e.g., "95% of requests < 2 seconds")
- Measure end-to-end from user perspective when possible

**Correctness** -- Is the service returning correct results?
- Formula: `% of responses that are correct / total responses`
- Harder to measure -- may require synthetic checks or validation endpoints
- Includes data integrity, calculation accuracy, consistency
- Often measured via periodic canary tests

**Freshness** -- Is the data up to date?
- Formula: `% of data updated within freshness window`
- Relevant for systems with async processing, caches, or replication
- Window depends on use case (real-time vs daily batch)
- Measured by checking last-update timestamps

**Durability** -- Is data preserved?
- Formula: `% of data objects successfully stored and retrievable`
- Critical for storage services
- Typically very high targets (99.999999999% for cloud storage)
- Measured via periodic retrieval checks

**Throughput** -- Can the service handle expected load?
- Formula: `% of time throughput exceeds minimum threshold`
- Relevant when minimum capacity is a requirement
- Measured as requests-per-second or transactions-per-second
- Often paired with latency SLI (throughput at acceptable latency)

### Mapping Quality Attributes to SLIs

| Quality Attribute | Primary SLI Category | Secondary SLI |
|-------------------|---------------------|---------------|
| Performance | Latency (p95, p99) | Throughput |
| Availability | Availability (success rate) | -- |
| Scalability | Throughput under load | Latency under load |
| Security | Auth success rate | Error rate on auth endpoints |
| Usability | Frontend load time | Time to interactive |
| Maintainability | Deployment success rate | Mean time to deploy |
| Reliability | Availability + Correctness | Durability |
| Data Integrity | Correctness | Freshness |

---

## 3. Setting SLO Targets

### Deriving from Quality Attributes

Quality attributes (QA-xxx) define what the system should achieve. SLOs translate these into measurable targets:

1. **Read the QA requirement**: "System shall respond to API requests within 2 seconds for 95% of requests"
2. **Extract the SLI**: p95 API latency
3. **Extract the target**: 95% of requests < 2 seconds
4. **Set the SLO**: 95% of requests complete in < 2s over a 30-day rolling window
5. **Set the SLA** (if external): 90% of requests complete in < 2s (less aggressive)

### Realistic vs Aspirational Targets

**Do not set aspirational targets.** SLOs should reflect what users actually need and what the system can realistically achieve.

| Target | Monthly Downtime Allowed | Cost Implications |
|--------|-------------------------|-------------------|
| 99.0% | 7.3 hours | Low -- single instance, basic monitoring |
| 99.5% | 3.6 hours | Moderate -- redundancy, auto-recovery |
| 99.9% | 43.8 minutes | High -- multi-AZ, hot standby, 24/7 on-call |
| 99.95% | 21.9 minutes | Very high -- multi-region, automated failover |
| 99.99% | 4.4 minutes | Extreme -- full redundancy everywhere, dedicated SRE team |

**Rule of thumb**: Each additional "9" roughly doubles or triples operational cost. Only commit to what the quality attributes demand and the budget supports.

### The "Nines" Trap

Common mistake: Setting 99.99% availability because "it sounds professional." Consider:
- A small team (3-5 engineers) cannot realistically maintain 99.99% without 24/7 on-call
- Most internal tools and early-stage products only need 99.0-99.5%
- Set targets based on actual user impact, not industry bragging rights

---

## 4. Error Budget Calculation and Management

### What Is an Error Budget?

The error budget is the **allowed amount of unreliability** derived from the SLO:

```
Error Budget = 100% - SLO Target
```

**Example**: SLO = 99.5% availability -> Error Budget = 0.5%

Over a 30-day window (720 hours):
- 0.5% error budget = 3.6 hours of allowed downtime
- Or equivalently: 0.5% of requests can fail

### Monthly Error Budget Calculation

For request-based SLIs:
```
Monthly budget (requests) = Total monthly requests x (1 - SLO)
Budget consumed = Failed requests / Budget total x 100%
```

For time-based SLIs:
```
Monthly budget (minutes) = 30 days x 24 hours x 60 minutes x (1 - SLO)
Budget consumed = Downtime minutes / Budget total x 100%
```

### Burn Rate

Burn rate measures how fast the error budget is being consumed relative to the expected rate:

```
Burn rate = Actual error rate / (1 - SLO)
```

- Burn rate = 1.0: consuming budget at exactly the expected rate (will exhaust at end of window)
- Burn rate = 2.0: consuming at 2x rate (will exhaust at window midpoint)
- Burn rate = 14.4: consuming at 14.4x rate (will exhaust in 1/14.4 of window -- ~50 hours for 30-day window)

### Error Budget Policies

Define clear actions based on budget consumption level:

| Budget Consumed | State | Policy |
|----------------|-------|--------|
| 0-50% | **Normal** | Normal development velocity. Deploy freely. Error budget is healthy. |
| 50-80% | **Investigate** | Investigate top error sources. Prioritize reliability fixes. Continue feature work with caution. |
| 80-100% | **Feature Freeze** | Freeze non-critical deployments. Focus engineering effort on reliability. Only ship fixes that improve SLO. |
| 100%+ | **Incident Response** | Treat as ongoing incident. All hands on reliability. No feature deployments until budget recovers. Post-incident review required. |

### Who Owns the Error Budget?

- **SRE / Platform team** tracks consumption and enforces policies
- **Product team** decides how to spend the budget (features vs reliability)
- **Engineering leadership** resolves conflicts between velocity and reliability
- Error budget is a shared resource -- everyone benefits from protecting it

---

## 5. SLO-Based Alerting

### Multi-Window, Multi-Burn-Rate Alerts

The industry best practice (from Google SRE) uses multiple detection windows:

**Fast burn alert** (catch rapid degradation):
- Short window: 5 minutes at 14.4x burn rate (exhausts 1-hour budget)
- Triggers: Page on-call immediately
- Example: If 30-day SLO is 99.5%, alert when 5-minute error rate > 7.2%

**Slow burn alert** (catch gradual degradation):
- Medium window: 6 hours at 6x burn rate (exhausts budget in 5 days)
- Triggers: Create ticket, notify team during business hours
- Example: If 30-day SLO is 99.5%, alert when 6-hour error rate > 3%

**Budget consumption alert** (track overall health):
- Check: Daily budget consumption percentage
- Triggers: Slack notification at 50%, 80%, and 100% thresholds
- Example: "SLO error budget is 75% consumed with 12 days remaining in window"

### Why Not Alert on Every SLO Dip?

- Momentary dips are normal and expected (that is what the error budget is for)
- Alerting on every dip causes alert fatigue and erodes on-call trust
- Burn rate alerts distinguish "normal noise" from "genuine degradation"
- The goal is to alert only when the error budget is at risk of exhaustion

### Alert Configuration Table

| Alert Name | SLI | Burn Rate | Window | Severity | Action |
|------------|-----|-----------|--------|----------|--------|
| Fast burn - availability | Request success rate | 14.4x | 5 min | P1 (page) | Page on-call, follow runbook |
| Slow burn - availability | Request success rate | 6x | 6 hours | P2 (ticket) | Create ticket, investigate in business hours |
| Budget alert - availability | Request success rate | N/A | 30-day | P3 (notify) | Slack notification at thresholds |

---

## 6. SLO Review Cadence

### Monthly Operational Review

**Purpose**: Check SLO health and error budget status.
**Attendees**: Engineering lead, SRE/ops representative, product owner.
**Duration**: 30 minutes.

**Agenda**:
1. SLO status for each service (met/breached, budget remaining)
2. Incidents that consumed error budget
3. Top error contributors
4. Upcoming changes that may impact SLOs (releases, migrations)
5. Action items for at-risk SLOs

### Quarterly Strategic Review

**Purpose**: Evaluate whether SLO targets are still appropriate.
**Attendees**: Engineering leadership, product leadership, SRE/ops lead.
**Duration**: 60 minutes.

**Agenda**:
1. SLO trend analysis (3-month view)
2. Customer satisfaction correlation
3. Target adjustment proposals (tighter or looser)
4. New SLIs needed (new features, new services)
5. SLI retirement (deprecated features)
6. Error budget policy effectiveness

### Triggers for Ad-Hoc Review

- Major incident (SEV-1 or SEV-2) that exhausted error budget
- Significant architecture change (new service, migration)
- Customer complaint pattern indicating SLO gaps
- Three consecutive months of SLO breach
- New product launch or feature that changes usage patterns

### SLO Adjustment Criteria

**Tighten SLO** (make more strict) when:
- Current SLO is consistently met with large budget remaining (>80% unspent)
- Customer expectations have increased
- Infrastructure improvements enable better reliability
- Competitive pressure demands higher availability

**Loosen SLO** (make less strict) when:
- SLO is consistently breached despite best efforts
- Cost of maintaining current target exceeds business value
- User research shows lower target is acceptable
- Team size or on-call capacity has decreased

**Never adjust SLOs to hide poor performance.** Adjustment should be a deliberate strategic decision, not a reaction to a bad month.
