# Operations Phase Overview

The operations phase defines how the production system is monitored, maintained, and improved after deployment. It covers monitoring and alerting, incident response, SLA management, operational runbooks, and change management. This is the final SDLC phase — it ensures the system remains healthy, reliable, and responsive to issues.

---

## Skills in This Phase

```
/ops-monitor      → Define monitoring, alerting, and observability strategy
     ↓
/ops-incident     → Define incident response process and escalation procedures
     ↓
/ops-sla          → Define SLAs/SLOs/SLIs and compliance tracking
     ↓
/ops-runbook      → Create operational runbooks for common procedures
     ↓
/ops-change       → Define change management process for production changes
```

Each skill supports two modes: create and refine.

---

## Artifact Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    INPUTS                                    │
│                                                              │
│  From deploy/final/:               From design/final/:      │
│  - env-spec-final.md               - architecture-final.md  │
│  - cicd-pipeline-final.md          - tech-stack-final.md    │
│  - release-plan-final.md                                     │
│                                    From init/final/:         │
│  From req/final/:                  - scope-final.md (QA)    │
│  - dor-dod-final.md               - charter-final.md       │
│  - backlog-final.md               - risk-register-final.md  │
└────────────┬──────────────────────────┬──────────────────────┘
             │                          │
             ▼                          ▼
      ┌──────────────────────────────────────────┐
      │         /ops-monitor                     │
      │  Monitoring, alerting, dashboards        │
      │  Output: monitoring-plan-draft.md        │
      └──────────────────┬───────────────────────┘
                         │
                         ▼
      ┌──────────────────────────────────────────┐
      │         /ops-incident                    │
      │  Incident response, escalation           │
      │  Output: incident-response-draft.md      │
      └──────────────────┬───────────────────────┘
                         │
                         ▼
      ┌──────────────────────────────────────────┐
      │         /ops-sla                         │
      │  SLAs, SLOs, SLIs, error budgets         │
      │  Output: sla-spec-draft.md               │
      └──────────────────┬───────────────────────┘
                         │
                         ▼
      ┌──────────────────────────────────────────┐
      │         /ops-runbook                     │
      │  Operational procedures                  │
      │  Output: runbooks-draft.md               │
      └──────────────────┬───────────────────────┘
                         │
                         ▼
      ┌──────────────────────────────────────────┐
      │         /ops-change                      │
      │  Change management process               │
      │  Output: change-mgmt-draft.md            │
      └──────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                   OUTPUTS (ops/final/)                        │
│                                                              │
│  monitoring-plan-final.md    incident-response-final.md      │
│  sla-spec-final.md           runbooks-final.md               │
│  change-mgmt-final.md                                        │
└─────────────────────────────────────────────────────────────┘
```

---

## What This Phase Reads

| Source | What Ops Extracts |
|--------|---------------------|
| **env-spec-final.md** | Infrastructure components to monitor, scaling policies, health checks |
| **architecture-final.md** | Service dependencies, component interactions, failure modes |
| **tech-stack-final.md** | Monitoring tools (Datadog, etc.), logging framework |
| **scope-final.md** | Quality attributes → SLA targets (availability, performance) |
| **risk-register-final.md** | Operational risks, failure scenarios |
| **cicd-pipeline-final.md** | Deployment frequency, rollback procedures |
| **release-plan-final.md** | Release cadence, change windows |
| **charter-final.md** | Team structure, support responsibilities |

---

## Key Principles

1. **Observability over monitoring** — collect metrics, logs, and traces; correlate across services.
2. **SLO-driven operations** — define SLOs from quality attributes, measure with SLIs, manage error budgets.
3. **Blameless incident response** — focus on system improvement, not individual blame.
4. **Automate responses** — automate common remediation actions via runbooks.
5. **Change management** — all production changes are tracked, reviewed, and reversible.
6. **Continuous improvement** — post-incident reviews drive system and process improvements.
7. **On-call sustainability** — fair rotation, reasonable alert volumes, clear escalation paths.
