# Incident Response Template

Standard format for incident management processes.

---

## Incident Record

```markdown
### INC-{NNN}: {Incident Title}

| Field | Value |
|-------|-------|
| **Severity** | SEV-1 / SEV-2 / SEV-3 / SEV-4 |
| **Status** | Detected / Investigating / Mitigated / Resolved / Post-Mortem |
| **Detected** | {timestamp} |
| **Resolved** | {timestamp} |
| **Duration** | {duration} |
| **Impact** | {user impact description} |
| **Commander** | {incident commander} |
| **Related Alert** | {alert name} |

**Timeline**:
| Time | Action | Owner |
|------|--------|-------|
| {time} | {action} | {owner} |
```

---

## Escalation Matrix

```markdown
| Severity | Response Time | Escalation After | Notify |
|----------|-------------|-----------------|--------|
| SEV-1 | {time} | {duration} | {who} |
| SEV-2 | {time} | {duration} | {who} |
```

---

## Rules

- Every incident MUST have a severity, commander, and timeline
- SEV-1 and SEV-2 incidents MUST have post-incident reviews
- Escalation paths MUST be defined for each severity level
- Communication templates MUST exist for stakeholder updates
