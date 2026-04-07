# Runbook Writing Guide

This guide provides domain knowledge and techniques for creating effective operational runbooks. Use these patterns when building runbooks for any project.

---

## 1. Runbook Structure

Every runbook follows a consistent structure designed for clarity under pressure. An on-call engineer at 3am should be able to pick up any runbook and execute it without prior context.

### Standard Runbook Sections

**Header**
- Runbook ID (RB-{NNN})
- Title (short, descriptive)
- Category (Alert Response / Routine Operations / Deployment / Disaster Recovery)
- Severity (P1-Critical / P2-High / P3-Medium / P4-Low)
- Trigger condition (what causes this runbook to be invoked)
- Last tested date
- Owner (team or individual responsible for maintenance)

**Trigger**
- Exact alert name and condition (metric, threshold, duration)
- Where to see the alert (dashboard URL, PagerDuty, Slack channel)
- What the user experiences when this condition occurs

**Diagnosis**
- Step-by-step investigation with specific commands and URLs
- Decision tree: "If X, go to step Y; otherwise go to step Z"
- Expected output at each step to help the operator confirm they are on track

**Remediation**
- Step-by-step fix actions with exact commands
- Safety checks before destructive actions ("Confirm backup exists before proceeding")
- Multiple remediation paths for different root causes

**Verification**
- How to confirm the fix worked
- Metrics to watch and expected recovery time
- User-facing checks (test the endpoint, verify the page loads)

**Escalation**
- When to escalate (time-based, severity-based, or scope-based)
- Who to contact (name, role, contact method)
- What information to hand off (timeline, steps taken, current state)

### Why This Order Matters

Diagnosis comes before remediation because acting without understanding the problem often makes things worse. Verification comes after remediation because "I ran the fix" is not the same as "the problem is resolved." Escalation is last because most runbooks should resolve the issue -- escalation is the exception path.

---

## 2. Writing Effective Diagnosis Steps

### The Diagnosis Hierarchy

Always follow this order when diagnosing issues:

1. **Check metrics first** -- Dashboards give the fastest overview. Specify the exact dashboard URL and which graph to look at. Example: "Open Datadog APM dashboard at https://app.datadoghq.com/apm/services/api-server and check the error rate graph for the last 30 minutes."

2. **Check logs second** -- Logs give detail. Provide the exact query to run. Example: "Run in CloudWatch Logs Insights: `fields @timestamp, @message | filter @message like /ERROR/ | sort @timestamp desc | limit 50` against log group `/ecs/api-server`."

3. **Check service health third** -- Verify the service is running. Example: "Run `aws ecs describe-services --cluster prod --services api-server --query 'services[0].{desired:desiredCount,running:runningCount,pending:pendingCount}'` to check task counts."

4. **Check dependencies last** -- Verify upstream/downstream services. Example: "Check database connectivity: `aws rds describe-db-instances --db-instance-identifier taskflow-prod --query 'DBInstances[0].DBInstanceStatus'`."

### Diagnosis Anti-Patterns

- **"Check the dashboard"** -- Which dashboard? Which metric? What time range? Be specific.
- **"Look at the logs"** -- Which log group? What query? What pattern are you looking for?
- **"Verify the service is healthy"** -- How? Which endpoint? What does healthy look like?
- **"Ask the team"** -- This is escalation, not diagnosis. Exhaust automated checks first.

### Decision Trees in Diagnosis

Use if/then branching to guide the operator:

```
Step 3: Check recent deployments
  - Run: `aws ecs describe-services --cluster prod --services api-server --query 'services[0].deployments'`
  - IF a deployment is in progress or was deployed in the last 30 minutes:
    -> This is likely deploy-related. Go to Remediation Option A (Rollback).
  - IF no recent deployment:
    -> Check load. Go to Step 4.
```

---

## 3. Writing Effective Remediation Steps

### Command Specificity

Every remediation step should be copy-pasteable. Include the full command with all required parameters.

**Bad:**
```
Restart the service.
```

**Good:**
```
Restart the API server ECS service:
  aws ecs update-service \
    --cluster prod \
    --service api-server \
    --force-new-deployment \
    --query 'service.deployments[0].{status:status,desired:desiredCount,running:runningCount}'
  Expected: status=PRIMARY, desired=2, running will increment from 0 to 2 over ~3 minutes.
```

### Safety Checks Before Destructive Actions

Always verify before taking destructive action:

```
Step 2: Kill the long-running query
  SAFETY CHECK: Confirm this is not a migration or scheduled job:
    SELECT pid, query_start, state, query
    FROM pg_stat_activity
    WHERE pid = {PID_FROM_STEP_1};
  If the query is a known migration -> DO NOT KILL. Escalate to DBA.
  If the query is an application query running >10 minutes -> proceed to kill:
    SELECT pg_terminate_backend({PID_FROM_STEP_1});
```

### Multiple Remediation Paths

Many alerts have different root causes requiring different fixes. Structure as options:

```
Remediation Option A: Deploy-related (recent deploy in last 30 minutes)
  1. Roll back to previous task definition...

Remediation Option B: Load-related (no recent deploy, high traffic)
  1. Scale up the service...

Remediation Option C: Dependency failure (upstream service down)
  1. Enable circuit breaker...
```

### Temporary vs Permanent Fixes

Clearly distinguish between band-aid fixes and root cause resolution:

```
TEMPORARY FIX (restore service now):
  Increase connection pool size: ...

PERMANENT FIX (schedule for next sprint):
  Investigate connection leak in authentication middleware.
  Track as: JIRA ticket or TODO.
```

---

## 4. Runbook Categories

### Alert Response Runbooks

Triggered by monitoring alerts. One runbook per alert from the monitoring plan.

**Characteristics:**
- Urgent: someone is being paged
- Time-sensitive: SLA clock is ticking
- Must be executable by any on-call engineer, not just the service owner
- Include estimated time to resolve (helps decide whether to escalate early)

**Common alert response runbooks:**
- Error rate spike (5xx errors)
- Latency degradation (p99 above threshold)
- Resource exhaustion (CPU, memory, disk, connections)
- Service unavailability (health check failures)
- Certificate expiration warnings
- Queue depth growth (processing backlog)

### Routine Operations Runbooks

Scheduled maintenance tasks that keep the system healthy.

**Characteristics:**
- Non-urgent: scheduled during maintenance windows
- Preventive: done to avoid future incidents
- Repeatable: run on a regular cadence (daily, weekly, monthly)
- Should include verification that the maintenance achieved its goal

**Common routine operations:**
- Database maintenance (vacuum, analyze, reindex)
- Backup verification (restore to test instance, validate data)
- Log rotation and archival
- SSL/TLS certificate renewal
- Dependency security patches (npm audit, pip audit)
- Disk space cleanup (old logs, temp files, Docker images)
- Access review (remove stale credentials, rotate keys)

### Deployment Runbooks

Procedures for releasing software to production.

**Characteristics:**
- Semi-urgent: coordinated, but time-boxed
- Risk-managed: include rollback procedures for every deploy step
- Coordinated: may require communication with stakeholders
- Ordered: steps must execute in sequence (database migration before code deploy, etc.)

**Common deployment runbooks:**
- Standard deployment (CI passes, deploy to staging, verify, deploy to prod)
- Emergency rollback (revert to previous known-good version)
- Database migration (schema changes with backward compatibility checks)
- Hotfix deployment (bypass normal flow for critical fixes)
- Feature flag rollout (gradual enable with monitoring)

### Disaster Recovery Runbooks

Procedures for recovering from major failures.

**Characteristics:**
- Critical: system is down or data is at risk
- Complex: multiple steps across multiple services
- Ordered: must follow dependency chain (database before API, API before workers)
- Tested: must be validated through periodic fire drills
- Communicated: include status page and stakeholder notification steps

**Common DR runbooks:**
- Database point-in-time recovery (restore from backup/snapshot)
- Single service recovery (restart, redeploy, or failover one service)
- Full system recovery (ordered restart of all services from scratch)
- Data corruption recovery (identify scope, restore from backup, replay events)
- Region failover (if multi-region architecture)

---

## 5. Runbook Testing

### Why Test Runbooks

Untested runbooks fail when you need them most. Common failure modes:
- Commands have changed (CLI version upgrade, API deprecation)
- URLs are broken (dashboard moved, renamed)
- Permissions are insufficient (IAM role changed, access key rotated)
- Steps are missing (an undocumented prerequisite)
- Recovery procedure does not actually recover the system

### Fire Drill Approach

**Tabletop drill**: Walk through the runbook step by step without executing. Verify that each step makes sense and commands are syntactically correct. Good for initial validation and quarterly reviews.

**Live fire drill**: Execute the runbook in a staging or test environment. Verify that commands work, outputs match expectations, and the procedure achieves its goal. Required for DR runbooks and deployment runbooks.

**Chaos engineering**: Inject the failure in a controlled environment and execute the runbook under realistic conditions. Best validation but highest effort. Use for P1 runbooks.

### Testing Cadence

| Runbook Category | Testing Method | Frequency | Environment |
|-----------------|---------------|-----------|-------------|
| Alert Response (P1) | Tabletop + Live drill | Quarterly | Staging |
| Alert Response (P2-P4) | Tabletop | Bi-annually | N/A |
| Routine Operations | Execute normally | Per schedule | Production |
| Deployment | Live drill | Monthly (part of normal deploy) | Staging + Prod |
| Disaster Recovery | Live drill | Quarterly | Staging or dedicated DR env |

### Recording Results

After every drill, record:
- Date executed
- Who executed it
- Pass/fail for each step
- Time to complete (actual vs estimated)
- Issues discovered (commands failed, steps missing, unclear instructions)
- Updates made to the runbook as a result

Update the runbook's "Last Tested" date after every successful drill.

---

## 6. Automation Path

### The Runbook Maturity Model

Runbooks evolve through four levels of maturity:

**Level 1: Manual Runbook (Document)**
- Written procedures executed by a human
- Starting point for every operational procedure
- Value: captures institutional knowledge, enables any team member to respond

**Level 2: Scripted Runbook (Semi-automated)**
- Diagnosis and remediation steps converted to scripts
- Human decides when to run the script and reviews output
- Value: reduces human error, faster execution, consistent results

**Level 3: Automated Runbook (Triggered)**
- Scripts triggered automatically by alerts
- Human reviews results and handles exceptions
- Value: faster MTTR, reduced on-call burden, 24/7 response capability

**Level 4: Self-Healing (Autonomous)**
- System detects, diagnoses, remediates, and verifies without human intervention
- Human notified after the fact for review
- Value: near-zero MTTR for known failure modes, minimal on-call interruption

### Prioritizing Automation

Not every runbook should be automated. Prioritize based on:

1. **Frequency**: High-frequency runbooks benefit most from automation (weekly cert check > annual DR)
2. **MTTR impact**: Runbooks where human response time dominates MTTR (3am alert response vs business-hours maintenance)
3. **Risk of human error**: Runbooks with destructive steps benefit from scripted safety checks
4. **Complexity**: Simple, deterministic runbooks are easiest to automate; complex judgment calls stay manual

### Automation Decision Matrix

| Frequency | MTTR Impact | Risk | Recommendation |
|-----------|------------|------|----------------|
| Daily+ | High | High | Automate to Level 3-4 |
| Weekly | High | Medium | Script to Level 2, plan Level 3 |
| Monthly | Medium | Low | Manual with scripts for complex steps |
| Quarterly+ | Low | Low | Manual runbook sufficient |

### From Runbook to Automation: The Process

1. Write the manual runbook (this skill)
2. Execute it several times, refine steps
3. Identify steps that are purely mechanical (no judgment needed)
4. Script those steps, keep human decision points
5. Add monitoring on the script execution
6. Gradually remove human decision points as confidence grows
7. Full automation with human notification
