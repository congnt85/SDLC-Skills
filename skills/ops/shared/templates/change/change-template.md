# Change Management Template

Standard format for tracking production changes.

---

## Change Record

```markdown
### CHG-{NNN}: {Change Title}

| Field | Value |
|-------|-------|
| **Type** | Standard / Normal / Emergency |
| **Risk** | Low / Medium / High |
| **Status** | Requested / Approved / In Progress / Completed / Rolled Back |
| **Requester** | {name} |
| **Approver** | {name} |
| **Scheduled** | {date and time} |
| **Duration** | {estimated duration} |
| **Impact** | {expected impact on users} |

**Description**: {what is being changed and why}

**Rollback Plan**: {how to revert if something goes wrong}

**Verification**: {how to verify the change was successful}

**Communication**: {who to notify before/during/after}
```

---

## Change Types

```markdown
| Type | Risk | Approval | Lead Time | Examples |
|------|------|----------|-----------|----------|
| Standard | Low | Pre-approved | None | Config change, dependency update |
| Normal | Medium | CAB review | 48hr | Feature release, schema migration |
| Emergency | High | Post-hoc | None | Hotfix, security patch |
```

---

## Rules

- All production changes MUST be documented
- Normal and emergency changes MUST have rollback plans
- Emergency changes MUST have post-hoc review within 24 hours
- Change success/failure MUST be recorded for metrics
- Change windows MUST be defined for non-emergency changes
