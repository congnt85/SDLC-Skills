# SLA Specification Output Rules

Rules specific to the SLA specification skill output. These supplement the shared rules in `skills/shared/rules/` and `ops/shared/rules/ops-rules.md`.

---

## SLA-01: Every Quality Attribute Must Have SLI + SLO

Every quality attribute (QA-xxx) from the scope document MUST be mapped to at least one SLI with a corresponding SLO target. If a quality attribute cannot be meaningfully measured, document why with an UNCLEAR confidence marker and create a Q&A entry.

## SLA-02: SLI Measurement Method Required

Every SLI MUST specify:
- Metric name (exact name as it appears in monitoring)
- Measurement formula (e.g., `successful requests / total requests`)
- Data source (e.g., ALB access logs, Prometheus counter, CloudWatch metric)
- Measurement window (e.g., per-minute for alerting, 30-day rolling for SLO tracking)

Vague descriptions like "measure availability" are insufficient.

## SLA-03: SLO Targets Derive from Quality Attributes

SLO targets MUST be traceable to quality attribute requirements (QA-xxx). Each SLO MUST include:
- Reference to source QA-xxx
- How the target was derived (direct mapping or interpretation)
- Justification if the target differs from the QA requirement

## SLA-04: Error Budgets Calculated

Every SLO MUST have a calculated error budget including:
- Budget formula: `100% - SLO target`
- Monthly budget in concrete terms (hours of downtime, number of failed requests, etc.)
- Current tracking method (how budget consumption is measured)

## SLA-05: SLA Less Aggressive Than SLO

If external SLA commitments are defined, every SLA target MUST be less aggressive (lower) than the corresponding SLO target. The gap between SLO and SLA MUST be documented with rationale. If no external SLA is needed, this MUST be explicitly stated.

## SLA-06: Burn Rate Alerts Defined

At least two burn rate alert tiers MUST be defined:
- Fast burn: short window (1-5 minutes), high burn rate (10x+), triggers immediate page
- Slow burn: longer window (1-6 hours), moderate burn rate (3-6x), triggers ticket or notification

Each alert MUST specify: window, burn rate threshold, severity, and action.

## SLA-07: Review Cadence Specified

SLO review process MUST include:
- Monthly operational review (attendees, agenda, duration)
- Quarterly strategic review (attendees, agenda, target adjustment criteria)
- Triggers for ad-hoc review (incident, architecture change, etc.)

## SLA-08: Section Order

SLA specification MUST follow this section order:
1. SLI/SLO/SLA Hierarchy
2. SLI Definitions
3. SLO Targets
4. SLA Commitments
5. Error Budgets
6. SLO Dashboard
7. Review Process
8. Q&A Log
9. Readiness Assessment
10. Approval

## SLA-09: Confidence Markers on Every Item

Every SLI definition, SLO target, SLA commitment, error budget policy, and alert threshold MUST have a confidence marker:
- ✅ CONFIRMED -- validated by stakeholder decision, load testing, or historical data
- 🔶 ASSUMED -- based on quality attributes, industry benchmarks, or team experience
- ❓ UNCLEAR -- insufficient information, needs stakeholder or architect input

## SLA-10: Refine Mode Scorecard First

In refine mode, the quality scorecard MUST be presented before any changes are applied. The scorecard evaluates the existing draft against all SLA rules and identifies gaps.

## SLA-11: Dashboard Spec Required

SLO dashboard specification MUST include:
- Key metrics displayed per SLI/SLO (current value, trend, budget remaining)
- Burn rate visualization (fast and slow burn indicators)
- Reporting cadence (daily automated, weekly summary, monthly report)
- Target audience (engineering, product, leadership)

## SLA-12: Per-Service SLOs for Multi-Service Architectures

When the architecture defines multiple services, SLOs MUST be defined at both:
- **Service level**: individual service availability, latency
- **System level**: end-to-end user journey (composite SLO)

The relationship between service-level and system-level SLOs MUST be documented (e.g., if 3 services each have 99.9% availability, composite availability is ~99.7%).
