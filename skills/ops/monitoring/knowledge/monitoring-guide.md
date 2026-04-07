# Monitoring and Observability Guide

This guide provides domain knowledge for building a comprehensive monitoring plan. Use these techniques and frameworks when generating monitoring plan artifacts.

---

## 1. Three Pillars of Observability

Observability is the ability to understand the internal state of a system by examining its external outputs. The three pillars are complementary — no single pillar is sufficient alone.

### Metrics

Numeric measurements collected over time, aggregated into time series.

- **What**: Counters (monotonically increasing), gauges (point-in-time values), histograms (distributions)
- **Strengths**: Cheap to store, easy to aggregate, fast to query, good for alerting
- **Weaknesses**: Low cardinality — cannot capture per-request detail
- **When to use**: Alerting on thresholds, capacity planning, trend analysis, SLO tracking
- **Examples**: CPU utilization (gauge), request count (counter), response time p95 (histogram)

### Logs

Discrete events with context, emitted at a point in time.

- **What**: Structured (JSON) or unstructured (plain text) records of events
- **Strengths**: High cardinality, rich context, searchable, human-readable
- **Weaknesses**: Expensive to store at scale, hard to aggregate, noisy if not structured
- **When to use**: Debugging specific requests, audit trails, error investigation, compliance
- **Examples**: "User 123 failed login from IP 1.2.3.4", "Payment processing timeout after 30s"

### Traces

The journey of a single request across services, composed of spans.

- **What**: A tree of spans, each representing a unit of work (HTTP call, DB query, cache lookup)
- **Strengths**: Shows causality across services, reveals bottlenecks, maps dependencies
- **Weaknesses**: Expensive at high volume (requires sampling), complex to instrument
- **When to use**: Diagnosing latency in distributed systems, understanding request flow, finding N+1 queries
- **Examples**: API request -> auth check -> DB query -> cache write -> response

### How They Complement Each Other

| Scenario | Start With | Then Use |
|----------|-----------|----------|
| Alert fires: "p95 latency >2s" | **Metrics** (which service, when did it start?) | **Traces** (find slow traces) -> **Logs** (find root cause in slow span) |
| User reports error | **Logs** (find error by user ID / request ID) | **Traces** (see full request path) -> **Metrics** (is it widespread?) |
| Capacity planning | **Metrics** (utilization trends over weeks) | **Logs** (correlate spikes with events) |
| Post-incident review | **Metrics** (timeline of degradation) | **Traces** (sample of affected requests) -> **Logs** (detailed error context) |

---

## 2. RED Method for Services

The RED method defines the three key metrics every service endpoint should expose. It is the standard for application-level monitoring.

### Rate

- **Definition**: Requests per second hitting the service
- **Why it matters**: Establishes baseline traffic, detects traffic spikes and drops
- **Alert on**: Sudden drops (possible upstream failure), sustained spikes (possible DDoS or viral load)
- **Break down by**: Endpoint, HTTP method, status code family (2xx, 4xx, 5xx)

### Errors

- **Definition**: Failed requests per second (or error rate as percentage)
- **Why it matters**: Direct proxy for user impact — errors mean users cannot accomplish their goal
- **Alert on**: Error rate exceeding SLO threshold (e.g., >1% for 5 minutes)
- **Break down by**: Error type (5xx server, 4xx client, timeout), endpoint, downstream dependency

### Duration (Latency)

- **Definition**: Time to serve a request, measured as distribution (p50, p95, p99)
- **Why it matters**: Slow responses degrade user experience even without errors
- **Alert on**: p95 or p99 exceeding SLO threshold (e.g., p95 >500ms for 5 minutes)
- **Why percentiles, not averages**: Averages hide tail latency. A p50 of 50ms with p99 of 5s means 1% of users wait 100x longer.

### Golden Signals (Google SRE)

The RED method aligns with Google's four golden signals:

| Golden Signal | RED Equivalent | Infrastructure Equivalent |
|--------------|---------------|--------------------------|
| **Latency** | Duration | N/A (service-level concept) |
| **Traffic** | Rate | N/A (service-level concept) |
| **Errors** | Errors | Error count (USE method) |
| **Saturation** | N/A | Saturation (USE method) |

Apply RED to every service boundary: API endpoints, message consumers, background job processors, WebSocket handlers.

---

## 3. USE Method for Infrastructure

The USE method defines the three key metrics for every infrastructure resource (CPU, memory, disk, network, connections).

### Utilization

- **Definition**: Percentage of time the resource is busy (or percentage of capacity used)
- **Examples**: CPU utilization %, memory used / total, disk space used / total
- **Alert on**: Sustained high utilization (>80%) indicates need to scale

### Saturation

- **Definition**: Queue depth or backlog — work the resource cannot serve immediately
- **Examples**: CPU run queue length, disk I/O queue depth, network socket backlog, connection pool wait count
- **Why it matters**: Saturation is the leading indicator. High utilization is fine if saturation is zero. High saturation means users are waiting.
- **Alert on**: Saturation > 0 sustained (e.g., run queue > 2x CPU count for 5 minutes)

### Errors

- **Definition**: Count of error events on the resource
- **Examples**: Disk read/write errors, network packet errors, ECC memory corrections, connection refused count
- **Alert on**: Any non-zero error count for hardware errors; threshold for soft errors

### Applying USE to Common Resources

| Resource | Utilization | Saturation | Errors |
|----------|------------|------------|--------|
| **CPU** | % busy (user + system) | Run queue length, load average | Machine check exceptions |
| **Memory** | % used, % available | Swap usage, OOM kill count | ECC corrections |
| **Disk** | % space used, IOPS used/max | I/O queue depth, await time | Read/write errors |
| **Network** | Bandwidth used/capacity | Socket backlog, retransmits | Packet errors, drops |
| **Connections** | Active / max pool size | Wait queue length | Connection refused, timeout |

**Key principle**: Alert on saturation before hitting utilization limits. A database at 60% CPU but with growing connection queue depth is more urgent than one at 85% CPU with no saturation.

---

## 4. Alert Design

### Principles

1. **Alert on symptoms, not causes**: Alert on "error rate >5%" (symptom users feel), not "CPU >90%" (cause that may or may not affect users). Use cause-based metrics for dashboards, not pages.
2. **Every alert must be actionable**: If the responder cannot take a meaningful action when alerted, it should be a dashboard metric or an info-level notification, not an alert.
3. **No alert fatigue**: Fewer, high-quality alerts are better than many noisy ones. Every ignored alert trains people to ignore all alerts. Target: <5 critical alerts per on-call shift.
4. **Include runbook reference**: Every alert must link to a runbook that tells the responder what to check and what to do. No alert without a runbook.
5. **Set appropriate urgency**: Not everything needs to page someone at 3 AM. Use severity levels to route appropriately.

### Severity Levels

| Severity | Definition | Response Time | Notification | Examples |
|----------|-----------|---------------|-------------|----------|
| **Critical (SEV-1)** | User-facing outage or data loss risk | Immediate (page) | PagerDuty / phone call | Service down, error rate >10%, data corruption |
| **Warning (SEV-2)** | Degradation, approaching limits | Investigate within hours | Slack channel, email | p95 latency >2x normal, disk >80%, cert expiry <14d |
| **Info (SEV-3)** | Notable event, no action needed | Review next business day | Dashboard, log | Deploy completed, scaling event, config change |

### Alert Specification Template

Every alert should specify:
- **Name**: Human-readable identifier (e.g., "API Error Rate Critical")
- **Metric**: What is measured (e.g., `http_requests_total{status=~"5.."}`)
- **Condition**: Threshold and window (e.g., ">5% for 5 minutes")
- **Severity**: Critical / Warning / Info
- **Channel**: Where notification goes (PagerDuty, Slack #alerts, email)
- **Runbook**: Link to runbook with investigation steps
- **Action**: Recommended first response (e.g., "Check deployment timeline, review recent changes")

### Anti-Patterns to Avoid

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| Too many alerts | Alert fatigue, responders ignore pages | Consolidate, raise thresholds, use severity levels |
| Alerting on metrics without context | CPU >90% is meaningless without knowing if users are affected | Alert on user-facing symptoms (error rate, latency) |
| No runbook reference | Responder wastes time figuring out what to do | Every alert gets a runbook before going live |
| Alerting on every single error | Noise — some errors are expected (404s, rate limits) | Alert on error rate thresholds, not individual errors |
| Flapping alerts | Alert fires and resolves repeatedly | Add hysteresis (longer evaluation windows, resolve delay) |
| Same threshold for all environments | Staging alerts create noise | Only page on production, use lower severity for staging |

---

## 5. Dashboard Design

### Layers

| Layer | Purpose | Refresh Rate | Retention |
|-------|---------|-------------|-----------|
| **Overview** | System health at a glance — all services, traffic light status | 30s - 1min | 30 days |
| **Service** | Per-service deep dive — RED metrics, dependencies, recent deploys | 30s - 1min | 30 days |
| **Infrastructure** | Resource utilization — CPU, memory, disk, network per component | 1min - 5min | 90 days |

### Audience

| Audience | Focus | Key Panels | Update Frequency |
|----------|-------|-----------|-----------------|
| **On-call engineer** | Real-time health, active alerts, recent changes | Alert status, error rate, latency, deploy marker | Every 30 seconds |
| **Engineering team** | Performance debugging, optimization | Per-endpoint latency, slow queries, trace samples | During work hours |
| **Management** | Availability, SLO compliance, trends | SLO burn rate, uptime %, incident count, MTTR | Daily / weekly |

### Layout Principles

1. **Most important panels top-left**: Users read left-to-right, top-to-bottom. Put system health status, error rates, and active alerts in the top-left quadrant.
2. **Consistent color coding**: Green = healthy, Yellow = warning, Red = critical. Never use red for normal state.
3. **Time range alignment**: All panels on a dashboard should use the same time range. Provide time range picker at dashboard level.
4. **Deploy markers**: Overlay deploy events on time-series charts to correlate changes with metric shifts.
5. **No vanity metrics**: Every panel should help answer "is there a problem?" or "where is the problem?" Remove panels that are "interesting but not actionable."
6. **Link to traces and logs**: Dashboard panels should link to relevant trace search or log queries for drill-down.

---

## 6. Structured Logging

### Format

Use JSON format for all application logs. This enables machine parsing, filtering, and aggregation.

```json
{
  "timestamp": "2026-04-06T10:30:00.123Z",
  "level": "ERROR",
  "service": "api-server",
  "traceId": "abc123def456",
  "spanId": "span789",
  "userId": "usr_42",
  "method": "POST",
  "path": "/api/v1/tasks",
  "statusCode": 500,
  "duration": 1523,
  "message": "Failed to create task: database connection timeout",
  "error": {
    "type": "ConnectionTimeoutError",
    "message": "Connection pool exhausted after 5000ms",
    "stack": "..."
  },
  "context": {
    "taskName": "Sprint Review",
    "projectId": "proj_99"
  }
}
```

### Standard Fields

Every log entry MUST include these fields:

| Field | Type | Description |
|-------|------|-------------|
| `timestamp` | ISO 8601 | When the event occurred (UTC) |
| `level` | String | ERROR, WARN, INFO, DEBUG |
| `service` | String | Which service emitted the log |
| `traceId` | String | Distributed trace correlation ID |
| `message` | String | Human-readable description |

Additional fields are recommended based on context (userId, method, path, statusCode, duration, error).

### Log Levels

| Level | When to Use | Production Default | Examples |
|-------|------------|-------------------|----------|
| **ERROR** | Unrecoverable failure, user impact, data integrity risk | ON | DB connection failure, unhandled exception, payment processing error |
| **WARN** | Recoverable issue, degraded behavior, approaching limits | ON | Retry succeeded, cache miss fallback, rate limit approached |
| **INFO** | Business events, state changes, request lifecycle | ON | User created, order placed, deployment started, config loaded |
| **DEBUG** | Diagnostic detail, variable values, flow tracing | OFF | SQL query text, request/response bodies, cache key lookup |

### Sensitive Data Rules

- **NEVER log**: Passwords, API keys, tokens, credit card numbers, SSN
- **NEVER log**: Full request/response bodies that may contain PII
- **Redact**: Email addresses (show first 3 chars + domain), phone numbers, IP addresses (in GDPR contexts)
- **Mask**: User IDs are acceptable if they are opaque identifiers (not email or name)

### Retention Policy

| Tier | Duration | Storage | Purpose |
|------|----------|---------|---------|
| **Hot** | 30 days | Primary log platform (Datadog, Elasticsearch) | Active search, debugging, alert correlation |
| **Cold** | 90 days | Object storage (S3 Glacier, GCS Nearline) | Incident review, compliance queries |
| **Archive** | 1 year | Deep archive (S3 Glacier Deep Archive) | Regulatory compliance, legal holds |

Cost optimization: Move logs from hot to cold storage automatically. Only archive logs required by compliance (audit logs, access logs, financial transaction logs).
