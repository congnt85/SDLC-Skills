---
name: ops-monitor
description: >
  Create or refine a monitoring plan defining the monitoring, alerting, and
  observability strategy — what to monitor, alert thresholds, dashboards, log
  aggregation, and distributed tracing. ONLY activated by command: `/ops-monitor`.
  Use `--create`, `--refine`, or `--score` to set mode. NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine|--score"
version: "1.0"
category: sdlc
phase: ops
prev_phase: deploy-env
next_phase: ops-incident
---

# Monitoring Plan Skill

## Purpose

Create or refine a monitoring plan document (`monitoring-plan-draft.md`) that defines the complete monitoring, alerting, and observability strategy for the system. This covers what to monitor across infrastructure and application layers, alert thresholds and escalation, dashboard specifications, log aggregation, distributed tracing, and on-call setup.

The monitoring plan bridges "where we run" (environment specification) and "how we respond" (incident response) by defining the signals, thresholds, and dashboards that detect problems before users do — and route those problems to the right people.

---

## Three Modes

### Mode 1: Create (`--create`)

Generate a monitoring plan from environment specification and architecture artifacts.

| Input | Required | Source |
|-------|----------|--------|
| Environment spec (final) | Yes | `sdlc/deploy/final/env-spec-final.md` or user-specified path |
| Architecture (final) | Yes | `sdlc/design/final/architecture-final.md` or user-specified path |
| Tech stack (final) | No | `sdlc/design/final/tech-stack-final.md` — monitoring tools (Datadog, Prometheus, etc.) |
| Scope (final) | No | `sdlc/init/final/scope-final.md` — quality attributes for SLO-based alert thresholds |
| Risk register (final) | No | `sdlc/init/final/risk-register-final.md` — failure scenarios to monitor |

### Mode 2: Refine (`--refine`)

Improve existing monitoring plan based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing monitoring plan draft | Yes | `sdlc/ops/draft/monitoring-plan-draft.md` or `sdlc/ops/draft/monitoring-plan-v{N}.md` |
| Review report / feedback | Yes | User provides directly or as `sdlc/ops/input/review-report.md` |
| Additional details | No | New information the user wants to add |

### Mode 3: Score (`--score`)

Evaluate artifact quality with a detailed scoreboard.

| Input | Required | Source |
|-------|----------|--------|
| Artifact to score | Yes | `sdlc/ops/draft/monitoring-plan-draft.md` or latest `monitoring-plan-v{N}.md` or `sdlc/ops/final/monitoring-plan-final.md`, or user-specified path |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `monitoring-plan-draft.md` | `sdlc/ops/draft/` |
| Refine | `monitoring-plan-v{N}.md` | `sdlc/ops/draft/` (N = next version number) |
| Score | `monitoring-plan-scoreboard.md` | `sdlc/ops/draft/` |

When user is satisfied -> they copy from `sdlc/ops/draft/` to `sdlc/ops/final/monitoring-plan-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User passes `--refine` argument → **Mode 2 (Refine)**
- User passes `--score` argument → **Mode 3 (Score)**
- User passes `--create` argument → **Mode 1 (Create)**
- No argument specified AND existing draft exists in `sdlc/ops/draft/` → Ask: "A draft already exists. Use `--create` to start fresh or `--refine` to improve it."
- No argument specified AND no draft exists → **Mode 1 (Create)**

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md` -- document formatting standards
2. `skills/shared/rules/quality-rules.md` -- confidence marking, readiness assessment
3. `skills/shared/rules/output-rules.md` -- versioning, input resolution, diff summary
4. `ops/shared/rules/ops-rules.md` -- operations phase rules
5. `ops/monitoring/knowledge/monitoring-guide.md` -- monitoring and observability techniques
6. `ops/monitoring/rules/output-rules.md` -- monitoring-specific output rules
7. `ops/monitoring/templates/output-template.md` -- expected output structure
8. `skills/shared/knowledge/scoring-guide.md` -- scoring methodology (Mode 3 only)
9. `skills/shared/rules/scoring-rules.md` -- scoring output rules (Mode 3 only)
10. `skills/shared/templates/scoreboard-output-template.md` -- scoreboard format (Mode 3 only)

### Step 3: Resolve Input

**File Type Conversion** (applies to all file inputs):

Before reading any input file, check its extension:
- `.md` → Read directly, no conversion needed
- `.pdf` → Run `/read-pdf <path> sdlc/ops/input/` → read the converted .md
- `.docx` / `.doc` → Run `/read-word <path> sdlc/ops/input/` → read the converted .md
- `.xlsx` / `.xls` → Run `/read-excel <path> sdlc/ops/input/` → read the converted .md
- `.pptx` / `.ppt` → Run `/read-ppt <path> sdlc/ops/input/` → read the converted .md

Converted files are saved to `sdlc/ops/input/`. If a converted .md already exists and is newer than the source, skip conversion.

Note: Files auto-resolved from `sdlc/` pipeline are always .md and skip conversion.

**Mode 1 (Create):**

```
For environment spec input (required):
1. Exists in sdlc/deploy/final/env-spec-final.md?         -> YES -> read it -> DONE
2. User specified a different path?                        -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/ops/input/env-spec-final.md?             -> YES -> read it -> DONE
4. Not found? -> Ask: "No environment specification found. Please provide a path or run /deploy-env first."

For architecture input (required):
1. Exists in sdlc/design/final/architecture-final.md?     -> YES -> read it -> DONE
2. User specified a different path?                        -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/ops/input/architecture-final.md?         -> YES -> read it -> DONE
4. Not found? -> Ask: "No architecture document found. Please provide a path or run /design-arch first."

For scope input (optional — quality attributes for SLO-based alert thresholds):
1. Exists in sdlc/init/final/scope-final.md?               -> YES -> read it -> DONE
2. User specified a different path?                        -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/ops/input/scope-final.md?                -> YES -> read it -> DONE
4. Not found? -> Proceed without scope document.

For tech stack input (optional):
1. Exists in sdlc/design/final/tech-stack-final.md?       -> YES -> read it -> DONE
2. User specified a different path?                        -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/ops/input/tech-stack-final.md?           -> YES -> read it -> DONE
4. Not found? -> Proceed without tech stack document.

For risk register input (optional):
1. Exists in sdlc/init/final/risk-register-final.md?      -> YES -> read it -> DONE
2. User specified a different path?                        -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/ops/input/risk-register-final.md?        -> YES -> read it -> DONE
4. Not found? -> Proceed without risk register document.
```

**Mode 2 (Refine):**

```
For monitoring plan draft:
1. User specified path?                           -> YES -> read it, copy to sdlc/ops/input/ -> DONE
2. Exists in sdlc/ops/input/?                     -> YES -> read it -> DONE
3. Exists in sdlc/ops/draft/ (latest version)?    -> YES -> read it, copy to sdlc/ops/input/ -> DONE
4. Not found? -> FAIL: "No existing monitoring plan draft found. Run /ops-monitor first."

For review report:
1. User provided feedback directly in message?    -> Save to sdlc/ops/input/review-report.md
2. User specified path?                           -> read it, copy to sdlc/ops/input/
3. Exists in sdlc/ops/input/review-report.md?    -> read it
4. Not found? -> Ask: "What feedback do you have on the current monitoring plan?"
```

**Mode 3 (Score):**

```
For artifact to score (required):
1. User specified a path?                                     → Read it → DONE
2. Exists in sdlc/ops/final/monitoring-plan-final.md?             → Read it → DONE
3. Exists as sdlc/ops/draft/monitoring-plan-v{N}.md (latest N)?   → Read it → DONE
4. Exists as sdlc/ops/draft/monitoring-plan-draft.md?             → Read it → DONE
5. Not found? → Ask: "Provide the path to the artifact to score."
```

### Step 4: Generate (Mode-specific)

**Mode 1 -- Create:**

Work through the monitoring plan **section by section, incrementally**:

1. **Monitoring Strategy** -- Three pillars and tooling
   - Define approach across three pillars: metrics, logs, traces
   - Identify monitoring tools from tech-stack-final.md (or recommend defaults)
   - Generate Mermaid diagram showing monitoring architecture (data flow from sources to dashboards)
   - Present strategy to user before detailing

2. **Infrastructure Monitoring** -- Per-component monitoring
   - For each component from env-spec-final.md: CPU, memory, disk, network
   - Health check endpoints and intervals
   - USE method metrics (Utilization, Saturation, Errors) per resource
   - Map infrastructure components to specific metrics and thresholds

3. **Application Monitoring** -- Service-level metrics
   - For each service from architecture-final.md: RED metrics (Rate, Errors, Duration)
   - Request rate, error rate, latency distribution (p50/p95/p99)
   - Business metrics (domain-specific KPIs)
   - Dependency health (downstream service and database call metrics)

4. **Alert Definitions** -- Per-alert specifications
   - For each alert: metric, condition, severity (Critical/Warning/Info), notification channel, runbook link, recommended action
   - Derive thresholds from SLO targets in scope-final.md (or quality attributes QA-xxx)
   - Apply alert design principles: symptoms over causes, every alert actionable
   - Map risk scenarios from risk-register-final.md to specific alerts

5. **Dashboard Specifications** -- Per-dashboard panel lists
   - System Overview dashboard (traffic light health, key metrics at a glance)
   - Service Deep Dive dashboard (per-service RED, dependency map)
   - Infrastructure dashboard (resource utilization, scaling events)
   - Define panels, data sources, and refresh intervals for each

6. **Log Management** -- Logging strategy
   - Structured log format (JSON) with standard fields
   - Log levels and when to use each (ERROR, WARN, INFO, DEBUG)
   - Aggregation pipeline (source -> collector -> storage -> search)
   - Retention policy (hot, cold, archive)
   - Sensitive data handling (redaction, PII avoidance)

7. **Distributed Tracing** -- Trace configuration
   - Trace propagation mechanism and instrumentation
   - Sampling strategy (production vs staging)
   - Correlation IDs across services
   - Key trace paths to instrument (user-facing request flows)

8. **On-Call Setup** -- Rotation and escalation
   - On-call rotation schedule (cadence, team size)
   - Primary and secondary responder roles
   - Alert routing by severity to notification channels
   - Escalation paths with time thresholds per severity level
   - Handoff procedures

For each section:
- Apply confidence markers (CONFIRMED / ASSUMED / UNCLEAR)
- Inherit confidence from source documents where applicable
- Create Q&A entries for ASSUMED and UNCLEAR items
- Present section to user before moving to next

**Mode 2 -- Refine:**

1. Read existing monitoring plan draft (baseline)
2. Read review report / user feedback
3. Run Quality Scorecard analysis
4. Present scorecard to user
5. Apply improvements:
   - Address user feedback point by point
   - Resolve Q&A entries from previous version
   - Upgrade confidence levels where possible
   - Refine alert thresholds based on new information
   - Update dashboards and on-call setup as needed
6. Tag all changes: `[UPDATED]` for modified items, `[NEW]` for additions
7. Preserve CONFIRMED items unless user explicitly contradicts them
8. Write improved version to `sdlc/ops/draft/monitoring-plan-v{N}.md`

**Mode 3 -- Score:**

1. **Read Context** — Read this skill's own `templates/output-template.md` and `rules/output-rules.md` to understand expected structure and quality constraints.

2. **Score Each Dimension** — Evaluate the artifact against all 5 quality dimensions (Completeness, Clarity, Consistency, Quantification, Traceability):
   - For each dimension, cite at least 2 specific evidence items from the artifact
   - Score using criteria from `skills/shared/knowledge/scoring-guide.md`
   - Record issues found during scoring

3. **Check Skill Rules Compliance** — For each rule in this skill's `rules/output-rules.md`:
   - ✅ PASS — artifact fully complies
   - ❌ FAIL — artifact clearly violates
   - ⚠️ PARTIAL — artifact partially complies

4. **Compile Issues** — Gather all issues from dimension scoring and rules compliance:
   - Assign severity: HIGH / MED / LOW
   - Link each to its dimension and artifact section

5. **Generate Recommendations** — 3-7 actionable recommendations:
   - HIGH severity issues first, then lowest-scoring dimensions
   - Each specifies: what to change, where, expected result

6. **Calculate Summary** — Average score, lowest/highest dimensions, overall verdict (🟢 Strong ≥4.0 / 🟡 Adequate 3.0-3.9 / 🔴 Needs Work <3.0)

### Step 5: Validate Output

Check against rules:
- Every item has a confidence marker (CR-01)
- Every infrastructure component from env-spec has monitoring defined (MON-01)
- Every service has RED metrics (Rate, Errors, Duration) (MON-02)
- Every alert specifies metric, condition, severity, channel, and runbook reference (MON-03)
- Alert thresholds derive from SLO targets or quality attributes (MON-04)
- At least 3 dashboards defined: overview, service, infrastructure (MON-05)
- Log format is structured (JSON) with standard fields (MON-06)
- Log retention policy is specified (MON-07)
- Section order matches template (MON-08)
- Confidence markers on every alert threshold (MON-09)
- Refine mode shows quality scorecard first (MON-10)
- On-call rotation defined with escalation paths (MON-11)
- Alert severity consistent with incident severity levels (MON-12)
- Business metrics included alongside technical metrics (MON-13)
- Mermaid diagram showing monitoring architecture included (MON-14)

**Mode 3 (Score) — additional checks:**
- All 5 dimensions scored with evidence (SCR-01, SCR-02)
- Integer scores 1-5 (SCR-03)
- Issues linked to dimensions and sections (SCR-04, SCR-05)
- Recommendations are actionable, 3-7 count (SCR-06, SCR-07)
- Scoring used this skill's own rules/templates as context (SCR-08)
- Rules compliance section present (SCR-10)

### Step 6: Readiness Assessment

Generate assessment per `skills/shared/templates/readiness-assessment.md`:
- Count items by confidence level (each alert is 1 item, each dashboard is 1 item, each metric is 1 item)
- Calculate readiness verdict
- In refine mode: compare with previous version

### Step 7: Output

- **Create mode**: Write to `sdlc/ops/draft/monitoring-plan-draft.md`
- **Refine mode**: Write to `sdlc/ops/draft/monitoring-plan-v{N}.md`, include Change Log and Diff Summary

Tell the user:
> **Monitoring Plan {created/refined}!**
> - Output: `sdlc/ops/draft/monitoring-plan-{version}.md`
> - Readiness: {verdict}
> - Alerts: {count} (Critical: {C}, Warning: {W}, Info: {I})
> - Dashboards: {count}
> - Services monitored: {count}
> - Infrastructure components: {count}
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/ops-monitor --refine`
> - When satisfied, copy to `sdlc/ops/final/monitoring-plan-final.md`
> - Then run `/ops-incident` to define incident response procedures

**Mode 3 (Score):**

- Write to `sdlc/ops/draft/monitoring-plan-scoreboard.md`

Tell the user:
> **Scoreboard complete!**
> - Output: `sdlc/ops/draft/monitoring-plan-scoreboard.md`
> - Average: {avg}/5 — {verdict}
> - Lowest: {dimension} ({score}/5)
> - Issues: {N} (HIGH: {H}, MED: {M}, LOW: {L})
>
> **Next steps:**
> - Run `/ops-monitor --refine` to address issues
> - Or run `/skill-evolution --analyze ops/monitoring` to improve the skill definition itself

---

## Scope Rules

### This skill DOES:
- Define monitoring strategy across three pillars (metrics, logs, traces)
- Specify infrastructure monitoring per component (CPU, memory, disk, network, health checks)
- Define application monitoring with RED metrics per service
- Create alert definitions with thresholds, severities, channels, and runbook references
- Specify dashboard layouts for engineering, operations, and management audiences
- Define structured logging format, levels, aggregation, and retention
- Configure distributed tracing strategy (propagation, sampling, correlation)
- Set up on-call rotation, escalation paths, and alert routing

### This skill does NOT:
- Implement monitoring infrastructure (that's DevOps work -- Terraform modules, Datadog agent install, etc.)
- Define incident response procedures (belongs to `ops/incident` skill)
- Define SLA/SLO contracts (belongs to `ops/sla` skill)
- Create operational runbooks (belongs to `ops/runbook` skill)
- Define change management processes (belongs to `ops/change` skill)
- Define environment infrastructure (belongs to `deploy/env` skill)
- Modify source documents -- it reads them as input
