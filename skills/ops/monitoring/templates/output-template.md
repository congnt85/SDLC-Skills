# Monitoring Plan Output Template

This is the expected structure for `monitoring-plan-draft.md` output. Follow this exactly.

---

```markdown
# Monitoring Plan — {Project Name}

> **Project**: {Project Name}
> **Version**: draft | v{N}
> **Date Created**: {YYYY-MM-DD}
> **Last Updated**: {YYYY-MM-DD}
> **Status**: Draft | Under Review | Approved
> **Author**: AI-Generated
> **Source**: Based on `env-spec-final.md` and `architecture-final.md`

{If refine mode, include Change Log here}

---

## 1. Monitoring Strategy

### 1.1 Approach

{Brief description of the overall monitoring philosophy — proactive vs reactive, observability goals, and how monitoring supports reliability targets.}

### 1.2 Three Pillars

| Pillar | Tool/Platform | Purpose | Coverage |
|--------|-------------|---------|----------|
| **Metrics** | {e.g., Datadog, Prometheus} | {purpose} | {what is covered} |
| **Logs** | {e.g., Datadog Logs, ELK Stack} | {purpose} | {what is covered} |
| **Traces** | {e.g., Datadog APM, Jaeger} | {purpose} | {what is covered} |

### 1.3 Monitoring Architecture

```mermaid
graph LR
    subgraph "Data Sources"
        APP[Application Services]
        INFRA[Infrastructure]
        LB[Load Balancer]
        DB[Database]
        CACHE[Cache]
    end

    subgraph "Collection"
        AGENT[Monitoring Agent<br/>{agent name}]
        LOG_SHIP[Log Shipper<br/>{shipper name}]
    end

    subgraph "Platform"
        METRICS_DB[Metrics Store<br/>{platform}]
        LOG_DB[Log Store<br/>{platform}]
        TRACE_DB[Trace Store<br/>{platform}]
    end

    subgraph "Output"
        DASH[Dashboards]
        ALERTS[Alert Engine]
        ONCALL[On-Call Routing<br/>{tool}]
    end

    APP --> AGENT
    INFRA --> AGENT
    APP --> LOG_SHIP
    AGENT --> METRICS_DB
    AGENT --> TRACE_DB
    LOG_SHIP --> LOG_DB
    METRICS_DB --> DASH
    METRICS_DB --> ALERTS
    LOG_DB --> DASH
    TRACE_DB --> DASH
    ALERTS --> ONCALL
```

---

## 2. Infrastructure Monitoring

### 2.1 {Component Name} (e.g., ECS / Compute)

| Metric | Method | Threshold (Warning) | Threshold (Critical) | Confidence |
|--------|--------|---------------------|----------------------|------------|
| CPU Utilization | {source} | {e.g., >70% for 10min} | {e.g., >90% for 5min} | ✅/🔶/❓ |
| Memory Utilization | {source} | {threshold} | {threshold} | ✅/🔶/❓ |
| {additional metric} | {source} | {threshold} | {threshold} | ✅/🔶/❓ |

### 2.2 {Component Name} (e.g., RDS / Database)

| Metric | Method | Threshold (Warning) | Threshold (Critical) | Confidence |
|--------|--------|---------------------|----------------------|------------|
| {metric} | {source} | {threshold} | {threshold} | ✅/🔶/❓ |

### 2.3 {Component Name} (e.g., ElastiCache / Cache)

| Metric | Method | Threshold (Warning) | Threshold (Critical) | Confidence |
|--------|--------|---------------------|----------------------|------------|
| {metric} | {source} | {threshold} | {threshold} | ✅/🔶/❓ |

### 2.4 {Component Name} (e.g., ALB / Load Balancer)

| Metric | Method | Threshold (Warning) | Threshold (Critical) | Confidence |
|--------|--------|---------------------|----------------------|------------|
| {metric} | {source} | {threshold} | {threshold} | ✅/🔶/❓ |

{Repeat for each infrastructure component: S3, CloudFront, NAT Gateway, etc.}

---

## 3. Application Monitoring

### 3.1 {Service Name} — RED Metrics

| Metric | Measurement | SLO Target | Alert Threshold | Confidence |
|--------|------------|------------|-----------------|------------|
| **Rate** | {e.g., requests/sec} | {target} | {threshold} | ✅/🔶/❓ |
| **Errors** | {e.g., error rate %} | {target} | {threshold} | ✅/🔶/❓ |
| **Duration (p50)** | {e.g., ms} | {target} | {threshold} | ✅/🔶/❓ |
| **Duration (p95)** | {e.g., ms} | {target} | {threshold} | ✅/🔶/❓ |
| **Duration (p99)** | {e.g., ms} | {target} | {threshold} | ✅/🔶/❓ |

{Repeat for each service.}

### 3.2 Business Metrics

| Metric | Description | Source | Expected Range | Alert Condition | Confidence |
|--------|------------|--------|----------------|-----------------|------------|
| {e.g., Active Users} | {description} | {source} | {range} | {condition} | ✅/🔶/❓ |

---

## 4. Alert Definitions

### 4.1 Alert Summary

| # | Alert Name | Metric | Condition | Severity | Channel | Runbook | Confidence |
|---|-----------|--------|-----------|----------|---------|---------|------------|
| 1 | {name} | {metric} | {condition} | Critical/Warning/Info | {channel} | {runbook ref} | ✅/🔶/❓ |

### 4.2 Alert Details

#### Alert {#}: {Alert Name}

| Attribute | Value |
|-----------|-------|
| **Metric** | {metric name or query} |
| **Condition** | {threshold and evaluation window} |
| **Severity** | {Critical / Warning / Info} |
| **Channel** | {notification destination} |
| **Runbook** | {runbook reference} |
| **Recommended Action** | {what the responder should do first} |
| **SLO Basis** | {which SLO/QA target this derives from, or "Industry best practice"} |
| **Confidence** | ✅/🔶/❓ |

{Repeat for each alert.}

---

## 5. Dashboard Specifications

### 5.1 {Dashboard Name} (e.g., System Overview)

**Audience**: {who uses this dashboard}
**Refresh Rate**: {interval}
**Default Time Range**: {e.g., Last 1 hour}

| Panel | Type | Data Source | Description |
|-------|------|-----------|-------------|
| {panel name} | {graph/table/status/heatmap} | {metric or query} | {what it shows} |

### 5.2 {Dashboard Name} (e.g., Service Deep Dive)

**Audience**: {who uses this dashboard}
**Refresh Rate**: {interval}
**Default Time Range**: {e.g., Last 1 hour}

| Panel | Type | Data Source | Description |
|-------|------|-----------|-------------|
| {panel name} | {type} | {source} | {description} |

### 5.3 {Dashboard Name} (e.g., Infrastructure)

**Audience**: {who uses this dashboard}
**Refresh Rate**: {interval}
**Default Time Range**: {e.g., Last 4 hours}

| Panel | Type | Data Source | Description |
|-------|------|-----------|-------------|
| {panel name} | {type} | {source} | {description} |

---

## 6. Log Management

### 6.1 Log Format

```json
{
  "timestamp": "{ISO 8601}",
  "level": "{ERROR|WARN|INFO|DEBUG}",
  "service": "{service-name}",
  "traceId": "{trace-id}",
  "spanId": "{span-id}",
  "message": "{human-readable message}",
  "{additional fields}": "{values}"
}
```

### 6.2 Log Levels

| Level | Usage | Production Default | Examples |
|-------|-------|-------------------|----------|
| ERROR | {when to use} | ON | {examples} |
| WARN | {when to use} | ON | {examples} |
| INFO | {when to use} | ON | {examples} |
| DEBUG | {when to use} | OFF | {examples} |

### 6.3 Log Aggregation Pipeline

| Source | Collector | Destination | Confidence |
|--------|----------|-------------|------------|
| {service/component} | {agent/shipper} | {platform} | ✅/🔶/❓ |

### 6.4 Log Retention

| Tier | Duration | Storage | Purpose | Confidence |
|------|----------|---------|---------|------------|
| Hot | {days} | {platform} | {purpose} | ✅/🔶/❓ |
| Cold | {days} | {platform} | {purpose} | ✅/🔶/❓ |
| Archive | {months/years} | {platform} | {purpose} | ✅/🔶/❓ |

### 6.5 Sensitive Data Handling

| Data Type | Policy | Implementation |
|-----------|--------|---------------|
| {e.g., Passwords} | {Never log} | {enforcement mechanism} |
| {e.g., Email} | {Redact} | {masking approach} |

---

## 7. Distributed Tracing

### 7.1 Tracing Configuration

| Attribute | Value | Confidence |
|-----------|-------|------------|
| **Platform** | {e.g., Datadog APM, Jaeger} | ✅/🔶/❓ |
| **Instrumentation** | {e.g., dd-trace-js, OpenTelemetry} | ✅/🔶/❓ |
| **Propagation Format** | {e.g., W3C Trace Context, Datadog headers} | ✅/🔶/❓ |

### 7.2 Sampling Strategy

| Environment | Sample Rate | Rationale | Confidence |
|-------------|------------|-----------|------------|
| {env} | {rate} | {why} | ✅/🔶/❓ |

### 7.3 Key Trace Paths

| # | Path | Services Involved | Why Traced |
|---|------|-------------------|-----------|
| 1 | {e.g., User login} | {service list} | {rationale} |

### 7.4 Correlation IDs

| ID Type | Header/Field | Generated By | Propagated To |
|---------|-------------|-------------|---------------|
| {e.g., Trace ID} | {header name} | {service} | {downstream services} |

---

## 8. On-Call Setup

### 8.1 Rotation Schedule

| Attribute | Value | Confidence |
|-----------|-------|------------|
| **Cadence** | {e.g., Weekly} | ✅/🔶/❓ |
| **Team Size** | {number} | ✅/🔶/❓ |
| **Roles** | {e.g., Primary + Secondary} | ✅/🔶/❓ |
| **Handoff** | {e.g., Every Monday 10:00 AM} | ✅/🔶/❓ |
| **Tool** | {e.g., PagerDuty} | ✅/🔶/❓ |

### 8.2 Alert Routing

| Severity | Notification Channel | Response Time | Escalation |
|----------|---------------------|---------------|------------|
| Critical | {e.g., PagerDuty -> phone} | {time} | {escalation rule} |
| Warning | {e.g., Slack #alerts} | {time} | {escalation rule} |
| Info | {e.g., Dashboard only} | {time} | None |

### 8.3 Escalation Paths

| Step | Timeframe | Action | Contact |
|------|-----------|--------|---------|
| 1 | {e.g., 0-5 min} | {action} | {who} |
| 2 | {e.g., 5-15 min} | {action} | {who} |
| 3 | {e.g., 15-30 min} | {action} | {who} |

---

## 9. Q&A Log

| ID | Question | Raised By | Priority | Answer | Status | Confidence |
|----|----------|-----------|----------|--------|--------|------------|
| Q-001 | {question} | {source} | HIGH/MED/LOW | {answer or "Pending"} | Open/Resolved | ✅/🔶/❓ |

---

## 10. Readiness Assessment

### Confidence Summary

| Level | Count | Percentage |
|-------|-------|------------|
| ✅ CONFIRMED | {n} | {%} |
| 🔶 ASSUMED | {n} | {%} |
| ❓ UNCLEAR | {n} | {%} |
| **Total Items** | {n} | 100% |

### Verdict: {READY / PARTIALLY READY / NOT READY}

{Justification for verdict. List critical gaps if not ready.}

### Key Risks

| # | Risk | Impact | Mitigation |
|---|------|--------|------------|
| 1 | {risk description} | {impact} | {mitigation} |

---

## 11. Approval

| Role | Name | Decision | Date | Signature |
|------|------|----------|------|-----------|
| SRE Lead | {name} | Approved / Rejected / Conditional | {date} | _________ |
| Technical Lead | {name} | Approved / Rejected / Conditional | {date} | _________ |
| Engineering Manager | {name} | Approved / Rejected / Conditional | {date} | _________ |

**Conditions / Comments:**
{Any conditions for approval or comments from reviewers.}
```
