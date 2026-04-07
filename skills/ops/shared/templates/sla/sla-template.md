# SLA/SLO/SLI Template

Standard format for defining service level agreements, objectives, and indicators.

---

## SLI/SLO Specification

```markdown
### SLO: {Name}

| Field | Value |
|-------|-------|
| **SLI** | {what is measured — e.g., request success rate} |
| **Measurement** | {how to calculate — e.g., successful requests / total requests} |
| **Data Source** | {metric source — e.g., Datadog APM} |
| **SLO Target** | {target — e.g., 99.5%} |
| **Window** | {time window — e.g., 30-day rolling} |
| **Error Budget** | {allowed failures — e.g., 0.5% = ~3.6 hrs/month} |
| **Source** | {QA-xxx from scope} |

**Alert Thresholds**:
| Level | Condition | Action |
|-------|-----------|--------|
| Warning | Error budget 50% consumed | Review and investigate |
| Critical | Error budget 80% consumed | Freeze non-critical changes |
| Breach | Error budget exhausted | Incident response |
```

---

## SLA Table

```markdown
| Service | Metric | SLA Target | Penalty | Measurement |
|---------|--------|------------|---------|-------------|
| {service} | {metric} | {target} | {penalty} | {how measured} |
```

---

## Rules

- Every SLO MUST have a corresponding SLI with measurement method
- SLO targets MUST derive from quality attributes (QA-xxx)
- Error budgets MUST be calculated and tracked
- SLA targets MUST be less aggressive than SLO targets (SLO = internal, SLA = external)
