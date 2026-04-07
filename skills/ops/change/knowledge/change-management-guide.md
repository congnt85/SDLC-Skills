# Change Management Guide

This guide covers change management techniques and best practices for building a change management process document. Use this as domain knowledge when generating or refining change management outputs.

---

## 1. Change Management Principles

Effective change management balances speed with safety. Every production change should be:

### Core Principles

| Principle | Description | Why It Matters |
|-----------|-------------|----------------|
| **Tracked** | Every change is logged with who, what, when, why | Post-incident forensics, audit compliance, trend analysis |
| **Risk-assessed** | Every change has a risk score before execution | Prevents high-risk changes from bypassing review |
| **Reversible** | Every change has a documented rollback plan | Reduces blast radius when changes fail |
| **Verified** | Every change is validated after execution | Catches silent failures before users notice |
| **Approved** | Every change has appropriate review for its risk level | Balances speed (low-risk auto-approved) with safety (high-risk requires CAB) |

### Balancing Speed and Safety

The goal is NOT to slow down changes -- it is to route changes through the right level of review:

- **Low-risk, well-understood changes** should flow fast with minimal friction (pre-approved, automated)
- **Medium-risk changes** need peer review and scheduled execution windows
- **High-risk changes** need formal review, additional testing, and stakeholder awareness
- **Emergency changes** bypass scheduling but require post-hoc review

Teams that over-govern low-risk changes create bottlenecks. Teams that under-govern high-risk changes create incidents. The classification system is the key to getting this right.

---

## 2. Change Classification

Changes are classified by risk level and urgency. The classification determines the approval process, scheduling constraints, and documentation requirements.

### Standard Changes (Pre-approved)

Standard changes are low-risk, well-understood, and frequently performed. They follow a pre-approved procedure and do not require individual review.

**Characteristics:**
- Procedure is documented and repeatable
- Risk is well-understood and consistently low
- Rollback is straightforward or automatic
- Change has been performed successfully many times before

**Examples:**
- Configuration value changes via parameter store or feature flags
- Dependency patch updates (non-breaking, automated by Dependabot/Renovate)
- Feature flag toggles (enabling/disabling features)
- Documentation updates
- Scaling adjustments within pre-approved ranges (e.g., adding replicas 2->4)
- Certificate renewals via automation

**Process:** Execute directly, log automatically. No approval gate needed.

### Normal Changes (Requires Review)

Normal changes carry moderate risk and require review before execution. They are scheduled during change windows.

**Characteristics:**
- Introduces new functionality or modifies existing behavior
- May affect multiple services or components
- Requires testing evidence before approval
- Rollback plan must be documented and tested

**Examples:**
- Feature releases (new endpoints, UI changes, new integrations)
- Database schema migrations (adding columns, modifying indexes)
- Infrastructure changes (new services, network topology changes)
- Third-party integration updates (API version upgrades)
- Major dependency updates (framework version bumps)
- Security policy changes (IAM role modifications, firewall rules)

**Process:** Submit change request -> risk assessment -> CAB/peer review -> schedule in window -> execute -> verify -> close.

### Emergency Changes (Expedited)

Emergency changes address active incidents or critical security vulnerabilities. They bypass normal scheduling but require post-hoc review.

**Characteristics:**
- Addresses an active production incident or critical vulnerability
- Delay would cause ongoing user impact or security exposure
- Cannot wait for the next scheduled change window
- May have reduced testing due to urgency

**Examples:**
- Production hotfixes for user-facing bugs
- Security patches for active vulnerabilities (CVEs)
- Data fixes for corruption or integrity issues
- Rollbacks of failed normal changes
- Emergency scaling for traffic spikes

**Process:** Create emergency change request -> expedited review (1 approver) -> execute immediately -> verify -> post-hoc CAB review within 24 hours -> update runbooks if needed.

---

## 3. Change Advisory Board (CAB)

The CAB is the governance body that reviews and approves changes. Its structure should scale with team size.

### Lightweight CAB (Small Teams, <15 engineers)

For small teams, a formal CAB meeting is overhead. Instead:

- **Async review**: Change requests posted in a dedicated channel (Slack #changes, GitHub Discussions)
- **Tech lead reviews** daily, approves or requests more info
- **Weekly sync** (15-30 min): Review upcoming normal changes for the week, discuss any patterns in recent changes
- **Emergency**: Tech lead or engineering manager approves via Slack/PagerDuty DM

This model works because small teams have high context -- everyone generally knows what everyone else is working on.

### Formal CAB (Larger Teams, 15+ engineers)

For larger teams or regulated environments:

- **Weekly CAB meeting** (30-60 min): Review all pending normal change requests
- **Standing members**: Engineering manager, tech leads from each team, QA lead, SRE/platform lead
- **Advisory members** (invited as needed): Security, DBA, product manager
- **Quorum**: At least 3 standing members must approve
- **Pre-read**: Change requests submitted 48hr before meeting with full documentation

### Decision Criteria

Regardless of CAB model, reviewers evaluate:

| Criterion | What to Check |
|-----------|---------------|
| **Risk score** | Is the risk level appropriate? Has the scoring been done honestly? |
| **Impact analysis** | What services/users are affected? What is the blast radius? |
| **Rollback plan** | Is there a tested rollback procedure? What is the target rollback time? |
| **Test evidence** | Has the change been tested? What environments? What test coverage? |
| **Dependencies** | Does this change depend on or conflict with other pending changes? |
| **Timing** | Is the change window appropriate? Any conflicts with blackouts? |
| **Communication** | Have affected stakeholders been notified? |

---

## 4. Change Windows and Blackout Periods

Change windows define when changes are allowed. The goal is to execute changes when the team is available to respond if something goes wrong.

### Defining Change Windows

**Good change window characteristics:**
- Team is fully staffed and alert (not Friday afternoon, not late night)
- Business traffic is lower (not during peak hours if possible)
- Sufficient time to monitor after deployment (not right before end of day)
- Support is available if needed (not during holidays)

**Common patterns:**
- **Weekday mid-morning to mid-afternoon**: Tuesday-Thursday, 10am-4pm (team timezone)
- **Avoid Mondays**: Teams are ramping up, catching up on context from the weekend
- **Avoid Fridays**: No one wants to debug a failed deploy over the weekend
- **Avoid end of day**: Insufficient monitoring time post-change

### Blackout Periods

Blackout periods are times when NO normal changes are allowed:

| Blackout Type | Duration | Rationale |
|---------------|----------|-----------|
| **Release day buffer** | Release day +/- 1 day | Avoid compounding changes with major releases |
| **Holidays** | Company holidays + 1 day buffer | Reduced staff availability |
| **Active incidents** | Until incident resolved | Avoid making a bad situation worse |
| **Major events** | Event period + buffer | Product launches, sales events, demos |
| **End of quarter** | Last 2-3 business days | Financial reporting, compliance freezes |

**Emergency changes are exempt from blackout periods** but require post-hoc review.

### Timezone Considerations

For globally distributed teams:
- Define change windows in UTC or the primary team timezone
- Ensure at least one reviewer is available in the change window
- Consider "follow the sun" change windows for 24/7 operations
- Document which timezone the change window refers to

---

## 5. Risk Scoring for Changes

Every change gets a risk score that determines its review requirements.

### Impact x Likelihood Matrix

Use a 3x3 matrix for simplicity (5x5 for larger organizations):

|  | Low Likelihood | Medium Likelihood | High Likelihood |
|--|---------------|-------------------|-----------------|
| **High Impact** | 3 (Medium) | 6 (High) | 9 (Critical) |
| **Medium Impact** | 2 (Low) | 4 (Medium) | 6 (High) |
| **Low Impact** | 1 (Low) | 2 (Low) | 3 (Medium) |

### Impact Factors

| Factor | Low (1) | Medium (2) | High (3) |
|--------|---------|------------|----------|
| **Services affected** | 1 service, non-critical | 2-3 services, or 1 critical | 4+ services, or core critical path |
| **Users affected** | Internal only | Subset of users | All users |
| **Data risk** | No data changes | Read-only data changes | Data mutations, schema changes |
| **Reversibility** | Instant rollback (feature flag, blue/green) | Rollback possible (<15 min) | Difficult rollback (data migration, schema change) |

### Likelihood Factors

| Factor | Low (1) | Medium (2) | High (3) |
|--------|---------|------------|----------|
| **Test coverage** | Full automated test suite passing | Partial coverage, manual testing done | Minimal testing, novel code path |
| **Change familiarity** | Done many times before (standard) | Done a few times, well-documented | First time, or significantly different from previous |
| **Previous failure history** | No recent failures for similar changes | Occasional issues with similar changes | Recent failures with similar changes |
| **Complexity** | Single config change, feature flag | Multi-service coordinated change | Database migration + code change + config change |

### Risk Score Thresholds

| Score | Risk Level | Requirements |
|-------|-----------|-------------|
| 1-2 | Low | May qualify as standard change (pre-approved) |
| 3-4 | Medium | Normal review by tech lead or peer |
| 5-6 | High | CAB review required, additional testing |
| 7-9 | Critical | Full CAB review, stakeholder notification, extended monitoring post-change |

---

## 6. Change Metrics and Improvement

Track change metrics to identify trends, improve processes, and demonstrate operational maturity.

### Core Metrics

| Metric | Definition | Target | Why It Matters |
|--------|-----------|--------|----------------|
| **Change volume** | Number of changes per week/month | Track trend (no fixed target) | Indicator of deployment frequency and system churn |
| **Change success rate** | Successful changes / total changes | >95% | Primary indicator of change management effectiveness |
| **Failed change rate** | Failed changes / total changes | <5% | Inverse of success rate, tracks reliability |
| **Emergency change ratio** | Emergency changes / total changes | <5% | High ratio indicates poor planning or instability |
| **Mean change duration** | Average time from start to close | <30 min for standard, <2hr for normal | Measures efficiency of change process |
| **MTTR for failed changes** | Mean time to restore after a failed change | <15 min | Measures rollback effectiveness |
| **Change-related incidents** | Incidents caused by changes / total incidents | Track trend, reduce over time | Measures whether changes are a primary incident source |

### Improvement Cycle

1. **Collect**: Log every change with type, risk score, duration, outcome
2. **Analyze**: Weekly/monthly review of change metrics, look for trends
3. **Correlate**: Map changes to incidents -- which changes caused problems?
4. **Improve**: Update processes based on findings:
   - Promote frequently successful normal changes to standard (pre-approved)
   - Add review gates for change types that frequently fail
   - Update risk scoring based on actual failure data
   - Improve runbooks for changes that take too long
5. **Share**: Publish change metrics to the team, celebrate improvements

### Maturity Indicators

| Level | Characteristics |
|-------|----------------|
| **Ad hoc** | Changes happen without tracking, no formal process |
| **Defined** | Change types defined, basic logging in place |
| **Managed** | Risk scoring active, CAB reviews normal changes, metrics tracked |
| **Optimized** | Automated change tracking, standard changes fully automated, metrics drive improvement |
