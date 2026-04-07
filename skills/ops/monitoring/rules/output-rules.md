# Monitoring Output Rules

Rules specific to the monitoring plan skill output. These supplement the shared rules in `skills/shared/rules/` and `ops/shared/rules/ops-rules.md`.

---

## MON-01: Infrastructure Coverage

Every infrastructure component from the environment specification MUST have monitoring defined. This includes compute (ECS, EC2, Lambda), database (RDS, DynamoDB), cache (ElastiCache, Redis), load balancer (ALB, NLB), storage (S3), and CDN (CloudFront). No component may be left unmonitored.

## MON-02: RED Metrics for Every Service

Every application service MUST have RED metrics defined:
- **Rate**: Requests per second (or messages per second for async services)
- **Errors**: Error count and error rate (percentage of failed requests)
- **Duration**: Latency distribution with at minimum p50, p95, and p99 percentiles

## MON-03: Alert Completeness

Every alert definition MUST specify all five fields:
- **Metric**: What is being measured (metric name or query)
- **Condition**: Threshold value and evaluation window (e.g., ">5% for 5 minutes")
- **Severity**: Critical, Warning, or Info
- **Channel**: Notification destination (PagerDuty, Slack channel, email)
- **Runbook**: Reference to a runbook or action description (e.g., "See RUN-003" or inline steps)

## MON-04: SLO-Derived Thresholds

Alert thresholds MUST derive from SLO targets when available. If scope-final.md contains quality attributes (QA-xxx) for availability, latency, or error rate, those values must be used as the basis for alert thresholds. If no SLOs exist, state threshold assumptions with ASSUMED confidence.

## MON-05: Minimum Dashboard Count

At least 3 dashboards MUST be defined:
1. **System Overview** -- Health status of all services at a glance
2. **Service Deep Dive** -- Per-service RED metrics, dependencies, recent deploys
3. **Infrastructure** -- Resource utilization (CPU, memory, disk, network) per component

Each dashboard must list its panels, data sources, and target audience.

## MON-06: Structured Log Format

Log format MUST be structured (JSON) with at minimum these standard fields:
- `timestamp` (ISO 8601, UTC)
- `level` (ERROR, WARN, INFO, DEBUG)
- `service` (emitting service name)
- `traceId` (distributed trace correlation ID)
- `message` (human-readable description)

## MON-07: Log Retention Policy

Log retention policy MUST be specified with at minimum:
- Hot storage duration and platform (e.g., 30 days in Datadog)
- Cold storage duration and platform (e.g., 90 days in S3)
- Archive policy for compliance if applicable

## MON-08: Section Order

Monitoring plan MUST follow this section order:
1. Monitoring Strategy
2. Infrastructure Monitoring
3. Application Monitoring
4. Alert Definitions
5. Dashboard Specifications
6. Log Management
7. Distributed Tracing
8. On-Call Setup
9. Q&A Log
10. Readiness Assessment
11. Approval

## MON-09: Confidence on Alert Thresholds

Every alert threshold MUST have a confidence marker:
- ✅ CONFIRMED -- validated by load testing, historical data, or explicit SLO agreement
- 🔶 ASSUMED -- based on industry best practices, similar project benchmarks, or team experience
- ❓ UNCLEAR -- insufficient information, needs performance baseline or stakeholder input

## MON-10: Refine Mode Scorecard First

In refine mode, the quality scorecard MUST be presented before any changes are applied. The scorecard evaluates the existing draft against all MON rules and identifies gaps.

## MON-11: On-Call Rotation Required

On-call rotation MUST be defined with:
- Rotation cadence (weekly, bi-weekly)
- Team size and roles (primary, secondary)
- Escalation paths with time thresholds per severity level
- Handoff procedures

## MON-12: Severity Consistency

Alert severity definitions MUST be consistent with incident severity levels:
- Critical alerts map to SEV-1 incidents (immediate page, user-facing outage)
- Warning alerts map to SEV-2 incidents (investigate within hours, degradation)
- Info alerts are non-incident notifications (review next business day)

## MON-13: Business Metrics Required

Business metrics MUST be included alongside technical metrics. Examples include active users, transactions processed, revenue-impacting operations, and domain-specific KPIs. Technical monitoring alone is insufficient -- the plan must answer "is the business healthy?"

## MON-14: Monitoring Architecture Diagram

A Mermaid diagram showing the monitoring architecture MUST be included. The diagram should show:
- Data sources (applications, infrastructure)
- Collection agents or exporters
- Monitoring platform(s)
- Alerting pipeline
- Dashboard and notification destinations
