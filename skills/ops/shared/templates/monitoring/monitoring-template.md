# Monitoring Template

Standard format for defining monitoring and alerting configurations.

---

## Dashboard Specification

```markdown
### Dashboard: {Name}

| Field | Value |
|-------|-------|
| **Purpose** | {what this dashboard shows} |
| **Audience** | {who uses this dashboard} |
| **Refresh** | {refresh interval} |

**Panels**:
| Panel | Metric | Visualization | Alert Threshold |
|-------|--------|--------------|-----------------|
| {name} | {metric} | Line/Gauge/Table | {threshold} |
```

---

## Alert Specification

```markdown
### Alert: {Name}

| Field | Value |
|-------|-------|
| **Metric** | {metric name and source} |
| **Condition** | {threshold and duration} |
| **Severity** | Critical / Warning / Info |
| **Channel** | {notification channel} |
| **Runbook** | {link to runbook} |
| **Actions** | {immediate actions} |
```

---

## Rules

- Every service MUST have health check monitoring
- Dashboards MUST be organized by audience (engineering, management)
- Alerts MUST reference runbooks
- Alert thresholds MUST be based on SLO targets
