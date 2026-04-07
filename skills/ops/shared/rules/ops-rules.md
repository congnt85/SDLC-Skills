# Operations Phase Rules

Rules specific to all skills in the operations phase.

---

## Content Rules

### OPS-01: Trace to Quality Attributes
Every operational target (SLA, SLO, alert threshold) MUST trace to:
- Quality attributes (QA-xxx) from scope
- Availability, performance, or security requirements
- Risk mitigations (RISK-xxx) from risk register

### OPS-02: Alert on Symptoms, Not Causes
Alerts MUST fire on user-facing symptoms (error rate, latency, availability), not internal causes (CPU usage, memory). Internal metrics are for diagnosis, not alerting. Exception: resource exhaustion alerts (disk >90%, connection pool >80%) as leading indicators.

### OPS-03: Every Alert Must Be Actionable
Every alert MUST have:
- A clear description of what is wrong
- A link to the relevant runbook
- Expected severity and urgency
- No alert should fire without a defined response action

### OPS-04: Incident Severity Definitions Required
Incident severity levels MUST be explicitly defined with:
- Clear criteria for each level
- Response time expectations
- Escalation triggers
- Examples for each level

### OPS-05: Blameless Post-Incident Reviews
Post-incident reviews MUST focus on:
- What happened (timeline)
- Why it happened (root cause analysis)
- How to prevent recurrence (action items)
- Never on who caused it

### OPS-06: Runbooks for Every Alert
Every production alert MUST reference a runbook that describes:
- How to diagnose the issue
- Step-by-step remediation
- Escalation criteria
- Verification steps

### OPS-07: Change Tracking Required
All production changes MUST be:
- Documented before execution
- Reviewed and approved
- Reversible (or justified if not)
- Tracked with outcomes recorded

---

## Artifact Rules

### OPS-08: Mermaid Diagrams for Workflows
Incident response, escalation, and change management workflows MUST include Mermaid flowcharts.

### OPS-09: Metrics Must Be Measurable
All SLIs, SLOs, and alert thresholds MUST specify:
- Exact metric name and source
- Measurement method (how to query/calculate)
- Time window (per-minute, per-hour, 30-day rolling)

### OPS-10: Approval Section Required
Every ops artifact MUST include an Approval section with DevOps Lead and Engineering Manager roles.
