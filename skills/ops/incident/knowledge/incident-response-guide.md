# Incident Response Guide

This guide provides domain knowledge and techniques for building incident response processes. Use these patterns when defining incident response for any project.

---

## 1. Severity Classification

Severity levels should be based on **user impact**, not internal technical metrics. A server running at 95% CPU is not an incident unless it affects users. A single broken button that prevents checkout is a high-severity incident regardless of server health.

### User-Impact-Based Severity Model

**SEV-1 -- Critical / Complete Outage**
- **User Impact**: All or most users cannot use the product. Core functionality is completely unavailable.
- **Business Impact**: Revenue loss, SLA breach, reputational damage.
- **Examples**: Database unreachable, full application crash, payment system down, complete network failure, data breach confirmed.
- **Response Time**: Immediate (less than 5 minutes to begin response).
- **Who is Paged**: All on-call engineers, engineering management, executive stakeholders.
- **Duration Threshold**: If unresolved in 30 minutes, escalate to next management tier.

**SEV-2 -- Major / Significant Degradation**
- **User Impact**: A major feature or a significant percentage of users are affected. Core flows still work but important functionality is broken or severely degraded.
- **Business Impact**: Partial revenue impact, customer complaints increasing, SLO at risk.
- **Examples**: Search broken, notifications not delivering, API latency 10x normal for 25%+ of requests, authentication intermittently failing, a key third-party integration down.
- **Response Time**: Within 15 minutes.
- **Who is Paged**: Primary on-call engineer, team lead.
- **Duration Threshold**: If unresolved in 1 hour, escalate.

**SEV-3 -- Minor / Limited Impact**
- **User Impact**: A non-critical feature is broken or a small subset of users is affected. Workarounds exist.
- **Business Impact**: Minimal revenue impact, isolated customer complaints.
- **Examples**: Export feature broken, UI rendering issue on one browser, slow performance on a non-critical page, email notifications delayed by minutes.
- **Response Time**: Within 1 hour during business hours.
- **Who is Paged**: On-call engineer via low-urgency notification (no page).
- **Duration Threshold**: If unresolved in 4 hours, consider escalation.

**SEV-4 -- Informational / Cosmetic**
- **User Impact**: No meaningful user impact. Cosmetic issues, minor bugs, or internal tooling problems.
- **Business Impact**: None.
- **Examples**: Typo in UI, internal dashboard slow, non-user-facing log errors, dev environment flakiness.
- **Response Time**: Next business day.
- **Who is Paged**: Nobody -- tracked as a ticket.
- **Duration Threshold**: Handled through normal sprint work.

### Calibrating Against SLAs

When scope or SLA documents specify availability targets (e.g., 99.5% uptime), severity levels should align:

- **SEV-1** triggers when the system is below its SLA threshold
- **SEV-2** triggers when the system is at risk of breaching SLA within the current measurement window
- **SEV-3/4** do not typically threaten SLA compliance

### Common Mistakes in Severity Classification

- **Too many SEV-1s**: If everything is critical, nothing is critical. Reserve SEV-1 for true outages.
- **Severity by caller seniority**: The VP reporting a broken button does not make it SEV-1. Classify by user impact.
- **No examples**: Abstract definitions lead to inconsistent classification. Always include concrete examples.
- **Missing response times**: Severity without response expectations is just a label, not a process.

---

## 2. Incident Command System

The Incident Command System (ICS) adapted for software provides clear roles during incidents. Every incident needs someone in charge, someone communicating, someone fixing, and someone recording.

### Core Roles

**Incident Commander (IC)**
- **Authority**: Final decision-maker during the incident. Can authorize rollbacks, request resources, approve external communications.
- **Responsibilities**:
  - Declare incident severity
  - Assign roles to responders
  - Drive triage and maintain focus on resolution
  - Make go/no-go decisions (rollback, failover, customer notification)
  - Coordinate across teams
  - Authorize escalations
- **Who**: Typically the on-call engineer initially, then handed off to a senior engineer or engineering manager for SEV-1/2.
- **Key Skill**: Keeping the team focused. The IC does not debug -- they coordinate.

**Communications Lead (Comms)**
- **Authority**: Owns all messaging -- internal and external.
- **Responsibilities**:
  - Post updates to internal channels at defined intervals
  - Update status page
  - Draft customer-facing communications
  - Notify stakeholders (product, sales, support, executives)
  - Manage the communication timeline
- **Who**: Product manager, support lead, or designated engineering manager. NOT the person debugging.
- **Key Skill**: Clear, concise communication under pressure. Translating technical issues into business impact.

**Technical Responder(s)**
- **Authority**: Hands-on debugging and remediation.
- **Responsibilities**:
  - Investigate the issue using monitoring, logs, and runbooks
  - Identify root cause or contributing factors
  - Implement mitigation (rollback, scaling, config change, hotfix)
  - Validate that the fix resolves the issue
  - Communicate findings to IC and Comms
- **Who**: On-call engineer(s), subject matter experts.
- **Key Skill**: Systematic debugging. Follow runbooks before improvising.

**Scribe**
- **Authority**: Records everything for the post-incident review.
- **Responsibilities**:
  - Maintain real-time incident timeline (timestamps + actions)
  - Record decisions and rationale
  - Note who was involved and when
  - Capture hypotheses tested and results
  - Document what worked and what did not
- **Who**: Any available team member. Often a junior engineer -- excellent learning opportunity.
- **Key Skill**: Accurate, timestamped note-taking. Do not editorialize.

### Role Handoffs

- **Shift changes**: For long-running incidents, the IC should hand off every 2-4 hours to prevent fatigue.
- **Handoff protocol**: Outgoing IC briefs incoming IC on current state, hypothesis, actions in progress, and next steps. Handoff is announced in the war room channel.
- **Escalation handoff**: When severity escalates, the IC may hand off to a more senior person. This is not a judgment -- it is appropriate resource allocation.

### Scaling for Team Size

- **Small teams (3-5 people)**: IC and Comms may be the same person for SEV-3/4. Scribe role is combined with Comms. For SEV-1/2, separate all roles.
- **Medium teams (6-15 people)**: All four roles separated for SEV-1/2. Scribe optional for SEV-3/4.
- **Large teams (15+ people)**: May add additional roles: Subject Matter Expert liaison, Customer Support coordinator.

---

## 3. Blameless Post-Mortem Technique

The post-incident review (post-mortem) is the most important part of incident response. Its purpose is to learn and improve, not to assign blame.

### Core Principles of Blameless Culture

1. **People are not the root cause**. Systems that allow a single person to cause an outage are the problem.
2. **Focus on systems and processes**, not individuals. Ask "how did the system allow this?" not "why did you do this?"
3. **Reward transparency**. People who surface problems early should be praised, not punished.
4. **Assume positive intent**. Everyone was trying to do the right thing with the information they had.
5. **Action items fix systems**, not people. "Add a confirmation dialog before destructive operations" not "tell John to be more careful."

### The 5 Whys Technique

The 5 Whys digs past symptoms to find root causes. Ask "why?" repeatedly until you reach a systemic issue.

**Example:**
1. Why did the API go down? -- Because the database ran out of connections.
2. Why did it run out of connections? -- Because a new feature opened connections without closing them.
3. Why were connections not closed? -- Because the connection pool library does not auto-close by default.
4. Why was auto-close not configured? -- Because the setup guide does not mention connection pool configuration.
5. Why does the guide not mention it? -- Because there is no checklist for new service setup covering resource management.

**Root cause**: Missing service setup checklist for resource management patterns.
**Action item**: Create a service setup checklist that includes connection pool, file handle, and thread pool configuration.

### Pitfalls of 5 Whys

- **Stopping too early**: "Human error" is never a root cause. Keep asking why.
- **Single chain of causation**: Incidents often have multiple contributing factors. Branch the 5 Whys when there are multiple contributing paths.
- **Leading questions**: "Why did you deploy without testing?" is accusatory. "Why was the change deployed without passing through the staging environment?" is systemic.

### Post-Mortem Template Structure

A good post-mortem includes:

1. **Incident Summary**: One paragraph -- what happened, when, how long, who was affected.
2. **Timeline**: Timestamped sequence of events from first alert to resolution. Include detection time, response start, key decisions, mitigations attempted, and resolution confirmation.
3. **Impact Assessment**: Number of users affected, duration, financial impact, SLA impact. Use monitoring data.
4. **Root Cause Analysis**: 5 Whys or equivalent technique. Distinguish between root cause and contributing factors.
5. **Contributing Factors**: Things that did not cause the incident but made it worse or delayed resolution.
6. **What Went Well**: What worked in the response. Reinforce good practices.
7. **What Went Poorly**: Process failures, gaps in tooling, communication breakdowns. No personal blame.
8. **Action Items**: Specific, measurable, with an owner and a deadline. Categorized as: prevent recurrence, improve detection, improve response.
9. **Lessons Learned**: Key takeaways for the broader team.

### Review Timeline

| Severity | Review Deadline | Meeting Duration | Attendees |
|----------|----------------|------------------|-----------|
| SEV-1 | Within 48 hours | 60-90 minutes | All responders + engineering leads + product |
| SEV-2 | Within 48 hours | 45-60 minutes | All responders + team lead |
| SEV-3 | Within 1 week | 30 minutes | Primary responder + team lead |
| SEV-4 | Not required | N/A | N/A |

---

## 4. Communication During Incidents

Communication failures during incidents cause more damage than the technical issue itself. Customers tolerate outages but not silence.

### Internal Communication

**War Room**
- Create a dedicated Slack channel (e.g., `#inc-YYYY-MM-DD-brief-description`) for SEV-1/2.
- Pin the current status summary and link to the monitoring dashboard.
- Only responders and stakeholders join. No spectators.
- IC posts regular updates even if "no change" -- silence causes anxiety.

**Update Frequency by Severity**

| Severity | Internal Update Frequency | Status Page Update | Customer Comms |
|----------|--------------------------|-------------------|----------------|
| SEV-1 | Every 15 minutes | Every 15-30 minutes | Initial + every 30 minutes |
| SEV-2 | Every 30 minutes | Every 30-60 minutes | If customer-facing, every hour |
| SEV-3 | Every 2 hours | If customer-facing, once | Only if customers report |
| SEV-4 | Ticket updates only | Not needed | Not needed |

**Internal Update Template**

```
[TIMESTAMP] Incident Update -- [TITLE]
Status: Investigating / Identified / Mitigating / Resolved
Severity: SEV-X
Impact: [brief user impact description]
Current Action: [what is being done right now]
Next Step: [what happens next and when]
ETA: [estimated time to resolution, or "unknown"]
Commander: [name]
```

### External Communication

**Status Page Best Practices**
- Update within 5 minutes of confirming SEV-1/2.
- Use plain language. "Some users may experience errors when loading their dashboard" not "HTTP 503 responses from service mesh gateway."
- Provide ETAs when possible, with appropriate hedging. "We expect resolution within 1 hour" not "it will be fixed soon."
- Post a final update confirming resolution and summarizing impact.

**Customer Communication Template (SEV-1)**

```
Subject: [Service Name] -- Service Disruption

We are aware of an issue affecting [brief description of impact].
Our engineering team is actively working on a resolution.

What you may experience:
- [specific user-facing symptoms]

What we are doing:
- [high-level remediation actions]

We will provide updates every [frequency]. For urgent inquiries,
contact [support channel].

Next update: [time]
```

### Stakeholder Notification Matrix

| Stakeholder | SEV-1 | SEV-2 | SEV-3 | SEV-4 |
|-------------|-------|-------|-------|-------|
| Engineering On-Call | Page immediately | Page immediately | Slack notification | Ticket |
| Engineering Manager | Page within 15 min | Slack within 30 min | Email next day | Not notified |
| VP Engineering / CTO | Page within 30 min | Slack within 1 hr | Not notified | Not notified |
| Product Manager | Slack within 15 min | Slack within 30 min | Email next day | Not notified |
| Customer Support | Slack within 10 min | Slack within 15 min | Slack within 1 hr | Not notified |
| Executive Team | Email within 1 hr | Email if >2 hrs | Not notified | Not notified |

---

## 5. Incident Metrics and Improvement

You cannot improve what you do not measure. Track incident response metrics to identify trends and drive improvement.

### Key Metrics

**MTTD -- Mean Time to Detect**
- Definition: Time from when the incident begins (first user impact) to when the team is alerted.
- Target: Less than 5 minutes for SEV-1/2 (via automated monitoring), less than 15 minutes for SEV-3.
- Improvement lever: Better monitoring coverage, lower alert thresholds, synthetic monitoring.

**MTTR -- Mean Time to Resolve**
- Definition: Time from incident detection to full resolution (service restored to normal).
- Target: Varies by severity -- SEV-1 target is typically under 1 hour, SEV-2 under 4 hours.
- Improvement lever: Better runbooks, faster rollback procedures, pre-staged fixes.

**MTTA -- Mean Time to Acknowledge**
- Definition: Time from alert firing to human acknowledgment.
- Target: Less than 5 minutes for SEV-1, less than 15 minutes for SEV-2.
- Improvement lever: On-call rotation health, paging tool configuration, escalation automation.

**Incident Frequency**
- Track total incidents per month, broken down by severity.
- Trend should be flat or declining. Increasing frequency indicates systemic issues.

**Repeat Incidents**
- Track incidents with the same root cause recurring within 90 days.
- Target: Zero repeats. A repeat incident means the action items from the post-mortem were insufficient.

**Escalation Rate**
- Percentage of incidents that required escalation beyond the first responder.
- High escalation rate may indicate: insufficient training, missing runbooks, or incorrect initial severity classification.

### Monthly Review Process

Hold a monthly incident review meeting to:
1. Review all incidents from the previous month
2. Analyze MTTD/MTTR trends
3. Identify repeat incident patterns
4. Review outstanding post-mortem action items
5. Adjust severity definitions if classification was inconsistent
6. Update runbooks based on new incident types
7. Celebrate improvements (faster response times, fewer incidents)

### Trend Analysis

Look for patterns in:
- **Time of day**: Are incidents clustered around deployments? After-hours?
- **Day of week**: More incidents on deploy days?
- **Service**: Which service causes the most incidents?
- **Root cause category**: Infrastructure? Code bugs? Configuration? Third-party?
- **Team**: Are some teams' services more incident-prone? (Systemic issue, not blame.)

---

## 6. War Room Etiquette

During active incidents, the war room (physical or virtual) is the coordination center. Effective war room behavior accelerates resolution.

### Rules of Engagement

1. **IC is in charge**. Respect the command structure. If you disagree with a decision, raise it once, then follow the IC's call.
2. **Focus on resolution, not root cause**. Root cause analysis happens in the post-mortem, not during the incident. Stop the bleeding first.
3. **Speak in facts, not theories**. "The error rate jumped to 15% at 14:32" not "I think the database might be slow."
4. **Announce actions before taking them**. "I am going to restart the API service in production" -- wait for IC acknowledgment.
5. **No blame**. "The config change introduced a regression" not "John broke production."
6. **Keep the channel clear**. Side discussions go to threads. The main channel is for status updates and decisions.
7. **Respect the scribe**. Speak clearly and timestamp your findings so the scribe can record accurately.
8. **Signal when you need help**. "I am blocked on database access and need someone from the DBA team" -- the IC will coordinate.

### Decision Authority During Incidents

| Decision | Authority | Approval Needed |
|----------|-----------|----------------|
| Rollback to previous version | IC | No (pre-authorized for SEV-1/2) |
| Scale infrastructure up | IC or Responder | IC acknowledgment |
| Modify database data | IC + DB owner | Written approval in war room |
| Customer communication | IC + Comms Lead | IC approval before sending |
| Escalate severity | IC | No |
| Bring in additional responders | IC | No |
| All-hands (cancel other work) | Engineering Manager | VP approval for SEV-1 |
