# Operational Runbooks Output Template

This is the expected structure for `runbooks-draft.md` output. Follow this exactly.

---

```markdown
# Operational Runbooks — {Project Name}

> **Project**: {Project Name}
> **Version**: draft | v{N}
> **Date Created**: {YYYY-MM-DD}
> **Last Updated**: {YYYY-MM-DD}
> **Status**: Draft | Under Review | Approved
> **Author**: AI-Generated
> **Source**: Based on `monitoring-plan-final.md` and `env-spec-final.md`

{If refine mode, include Change Log here}

---

## 1. Runbook Inventory

| ID | Title | Category | Trigger | Severity | Last Tested | Confidence |
|----|-------|----------|---------|----------|-------------|------------|
| RB-001 | {title} | Alert Response | {alert name / condition} | P1/P2/P3/P4 | {date or "Not yet tested"} | ✅/🔶/❓ |
| RB-002 | {title} | Alert Response | {alert name / condition} | P1/P2/P3/P4 | {date or "Not yet tested"} | ✅/🔶/❓ |
| RB-{NNN} | {title} | Routine Ops | {schedule / trigger} | P3/P4 | {date or "Not yet tested"} | ✅/🔶/❓ |
| RB-{NNN} | {title} | Deployment | {trigger} | P2/P3 | {date or "Not yet tested"} | ✅/🔶/❓ |
| RB-{NNN} | {title} | Disaster Recovery | {failure scenario} | P1 | {date or "Not yet tested"} | ✅/🔶/❓ |

---

## 2. Alert Response Runbooks

### RB-{NNN}: {Alert Title}

> **Category**: Alert Response
> **Severity**: P{N} — {Critical/High/Medium/Low}
> **Trigger**: {Exact alert condition — metric, threshold, duration}
> **Impact**: {What users experience when this alert fires}
> **Estimated Resolution Time**: {X minutes}
> **Owner**: {Team or individual}
> **Last Tested**: {date or "Not yet tested"}
> **Confidence**: ✅/🔶/❓

#### Diagnosis

1. **Check {metric/dashboard}**
   ```
   {exact command or URL}
   ```
   - Expected: {what normal looks like}
   - If abnormal: {what to look for, go to step N}

2. **Check {logs}**
   ```
   {exact log query}
   ```
   - Look for: {pattern or error message}
   - If {condition}: go to Remediation Option A
   - If {other condition}: go to Remediation Option B

3. **Check {service health}**
   ```
   {exact command}
   ```
   - Expected: {healthy state description}

4. **Check {dependencies}**
   ```
   {exact command}
   ```
   - If {dependency} is down: {note impact, may need separate runbook}

#### Remediation

**Option A: {Root Cause Description} (e.g., Deploy-related)**

1. {Step with exact command}
   ```
   {command}
   ```
   - SAFETY CHECK: {what to verify before proceeding}

2. {Next step}
   ```
   {command}
   ```
   - Expected: {what success looks like}

**Option B: {Alternative Root Cause} (e.g., Load-related)**

1. {Step with exact command}
   ```
   {command}
   ```

2. {Next step}
   ```
   {command}
   ```

#### Verification

1. **Check metrics recovery**
   ```
   {command or URL to check the metric that triggered the alert}
   ```
   - Expected: {metric} returns below {threshold} within {timeframe}

2. **Test user-facing functionality**
   ```
   {curl command or URL to test}
   ```
   - Expected: {HTTP 200, response time <Xms, etc.}

3. **Monitor for recurrence**
   - Watch for {duration} to confirm stability
   - If alert re-fires: escalate

#### Escalation

| Condition | Escalate To | Contact | Information to Provide |
|-----------|------------|---------|----------------------|
| Not resolved within {X} minutes | {Role/Team} | {contact method} | {what to hand off} |
| {Severity threshold} | {Role/Team} | {contact method} | {what to hand off} |
| Root cause unknown | {Role/Team} | {contact method} | {timeline, steps taken, current state} |

---

{Repeat for each alert response runbook}

---

## 3. Routine Operations Runbooks

### RB-{NNN}: {Operation Title}

> **Category**: Routine Operations
> **Schedule**: {frequency — daily/weekly/monthly/quarterly}
> **Responsible**: {team or role}
> **Estimated Duration**: {X minutes/hours}
> **Last Tested**: {date or "Not yet tested"}
> **Confidence**: ✅/🔶/❓

#### Prerequisites

- {Access requirements}
- {Tools needed}
- {Maintenance window confirmation if applicable}

#### Procedure

1. {Step with exact command}
   ```
   {command}
   ```
   - Expected: {output description}

2. {Next step}
   ```
   {command}
   ```

{Continue for all steps}

#### Verification

1. {How to confirm the operation succeeded}
   ```
   {command}
   ```
   - Expected: {success criteria}

#### Rollback (if applicable)

1. {How to undo if something goes wrong}

---

{Repeat for each routine operations runbook}

---

## 4. Deployment Runbooks

### RB-{NNN}: {Deployment Type Title}

> **Category**: Deployment
> **Trigger**: {When this procedure is used}
> **Severity**: P{N}
> **Estimated Duration**: {X minutes}
> **Owner**: {Team or role}
> **Last Tested**: {date or "Not yet tested"}
> **Confidence**: ✅/🔶/❓

#### Pre-Deployment Checks

1. {Verification step}
   ```
   {command}
   ```
   - Required: {condition that must be true to proceed}

2. {Next check}
   - Required: {condition}

#### Deployment Steps

1. {Step with exact command}
   ```
   {command}
   ```
   - Expected: {output}

2. {Next step}
   ```
   {command}
   ```

#### Post-Deployment Verification

1. {Smoke test or health check}
   ```
   {command}
   ```
   - Expected: {success criteria}

2. **Monitor for {duration}**
   - Watch: {metrics/dashboards}
   - Alert threshold: {what triggers rollback}

#### Rollback Procedure

1. {Rollback step}
   ```
   {command}
   ```

2. {Verification after rollback}
   ```
   {command}
   ```

#### Communication

- [ ] Notify {stakeholders} before deployment
- [ ] Update status page if user-facing
- [ ] Notify {stakeholders} after completion

---

{Repeat for each deployment runbook}

---

## 5. Disaster Recovery Runbooks

### RB-{NNN}: {DR Scenario Title}

> **Category**: Disaster Recovery
> **Trigger**: {Failure scenario that activates this runbook}
> **Severity**: P1 — Critical
> **RPO Target**: {from env-spec-final.md}
> **RTO Target**: {from env-spec-final.md}
> **Estimated Recovery Time**: {X minutes/hours}
> **Owner**: {Team or role}
> **Last Tested**: {date or "Not yet tested"}
> **Confidence**: ✅/🔶/❓

#### Prerequisites

- {Access requirements — admin/root level}
- {Backup availability confirmation}
- {Communication channel established}

#### Recovery Steps

1. **Assess the situation**
   ```
   {command to check current state}
   ```
   - Determine: {what to assess}

2. **Notify stakeholders**
   - Update status page: {URL}
   - Notify: {channels}
   - Message template: "{suggested message}"

3. {Recovery step with command}
   ```
   {command}
   ```
   - Expected: {output}
   - Wait: {estimated time}

4. {Next recovery step}
   ```
   {command}
   ```

{Continue for all steps, following dependency order}

#### Data Validation

1. {Verify data integrity after recovery}
   ```
   {query or command}
   ```
   - Expected: {what constitutes valid data}

2. {Additional validation}
   ```
   {command}
   ```

#### Service Restoration

1. {Bring service back to users}
   ```
   {command}
   ```

2. **Verify user-facing functionality**
   ```
   {command}
   ```

#### Post-Recovery

- [ ] Update status page — resolved
- [ ] Document timeline of events
- [ ] Schedule post-mortem within 48 hours
- [ ] File ticket for root cause fix

---

{Repeat for each DR runbook}

---

## 6. Runbook Testing Schedule

### Testing Calendar

| Runbook ID | Title | Category | Method | Frequency | Next Test | Environment | Responsible |
|-----------|-------|----------|--------|-----------|-----------|-------------|-------------|
| RB-{NNN} | {title} | {category} | Tabletop / Live Drill | {frequency} | {date} | {env} | {who} |

### Testing Procedures

**Tabletop Drill**
1. Assemble the on-call team
2. Present the failure scenario
3. Walk through the runbook step by step (no execution)
4. Verify commands are syntactically correct and URLs are valid
5. Record any issues or missing steps
6. Update the runbook

**Live Fire Drill**
1. Schedule maintenance window in {environment}
2. Inject the failure condition (or simulate it)
3. Execute the runbook from start to finish
4. Record time-to-complete and any deviations
5. Compare actual vs documented outcomes
6. Update the runbook with corrections

### Test Results Log

| Date | Runbook | Method | Result | Time | Issues Found | Updated? |
|------|---------|--------|--------|------|-------------|----------|
| {date} | RB-{NNN} | {method} | Pass/Fail | {duration} | {issues or "None"} | Yes/No |

---

## 7. Q&A Log

| ID | Question | Raised By | Priority | Answer | Status | Confidence |
|----|----------|-----------|----------|--------|--------|------------|
| Q-001 | {question} | {source} | HIGH/MED/LOW | {answer or "Pending"} | Open/Resolved | ✅/🔶/❓ |

---

## 8. Readiness Assessment

### Confidence Summary

| Level | Count | Percentage |
|-------|-------|------------|
| ✅ CONFIRMED | {n} | {%} |
| 🔶 ASSUMED | {n} | {%} |
| ❓ UNCLEAR | {n} | {%} |
| **Total Items** | {n} | 100% |

### Alert Coverage

| Metric | Value |
|--------|-------|
| Total alerts in monitoring plan | {n} |
| Alerts with runbooks | {n} |
| Coverage | {%} |

### Verdict: {READY / PARTIALLY READY / NOT READY}

{Justification for verdict. List critical gaps if not ready.}

### Key Risks

| # | Risk | Impact | Mitigation |
|---|------|--------|------------|
| 1 | {risk description} | {impact} | {mitigation} |

---

## 9. Approval

| Role | Name | Decision | Date | Signature |
|------|------|----------|------|-----------|
| SRE / Ops Lead | {name} | Approved / Rejected / Conditional | {date} | _________ |
| Technical Lead | {name} | Approved / Rejected / Conditional | {date} | _________ |
| Engineering Manager | {name} | Approved / Rejected / Conditional | {date} | _________ |

**Conditions / Comments:**
{Any conditions for approval or comments from reviewers.}
```
