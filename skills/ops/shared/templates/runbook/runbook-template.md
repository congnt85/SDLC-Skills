# Runbook Template

Standard format for operational runbooks.

---

## Runbook Format

```markdown
### RB-{NNN}: {Runbook Title}

| Field | Value |
|-------|-------|
| **Trigger** | {what triggers this runbook — alert name or manual} |
| **Severity** | {typical severity when triggered} |
| **Owner** | {team/role responsible} |
| **Last Tested** | {date} |
| **Estimated Duration** | {time to complete} |

**Diagnosis**:
1. {diagnostic step — what to check first}
2. {diagnostic step — what to check next}

**Remediation**:
1. {remediation step}
2. {remediation step}

**Verification**:
1. {how to verify the issue is resolved}

**Escalation**:
- If not resolved within {time}: escalate to {who}
- If {condition}: escalate to {who}

**Prevention**:
- {what to do to prevent recurrence}
```

---

## Rules

- Every runbook MUST have diagnosis, remediation, and verification steps
- Steps MUST be specific enough for any on-call engineer to follow
- Runbooks MUST be tested periodically (at least quarterly)
- Every production alert MUST link to a runbook
- Runbooks MUST include escalation criteria
