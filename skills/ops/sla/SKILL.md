---
name: ops-sla
description: >
  Create or refine an SLA specification defining SLAs, SLOs, SLIs, and error
  budgets — translating quality attributes into measurable, trackable service
  level targets. ONLY activated by commands: `/ops-sla` (create) or
  `/ops-sla-refine` (refine). NEVER auto-trigger based on keywords.
argument-hint: "[path to scope-final.md or monitoring-plan-final.md] (md/pdf/docx/xlsx/pptx)"
version: "1.0"
category: sdlc
phase: ops
prev_phase: ops-incident
next_phase: ops-runbook
---

# SLA/SLO/SLI Specification Skill

## Purpose

Create or refine an SLA specification document (`sla-spec-draft.md`) that defines SLAs, SLOs, SLIs, and error budgets — translating quality attributes (QA-xxx) from the scope document into measurable, trackable service level targets with clear measurement methods, alerting thresholds, and review processes.

The SLA specification bridges "what we monitor" (monitoring plan) and "how we respond" (incident response, runbooks) by defining the targets that monitoring measures and the thresholds that trigger incident response.

---

## Two Modes

### Mode 1: Create (`/ops-sla`)

Generate an SLA specification from scope quality attributes and monitoring plan.

| Input | Required | Source |
|-------|----------|--------|
| Scope (final) | Yes | `sdlc/init/final/scope-final.md` or user-specified path |
| Monitoring plan (final) | Yes | `sdlc/ops/final/monitoring-plan-final.md` or user-specified path |
| Environment spec (final) | No | `sdlc/deploy/final/env-spec-final.md` — infrastructure capabilities |
| Architecture (final) | No | `sdlc/design/final/architecture-final.md` — service boundaries for per-service SLOs |
| Incident response (final) | No | `sdlc/ops/final/incident-response-final.md` — severity calibration for SLO breaches |

### Mode 2: Refine (`/ops-sla-refine`)

Improve existing SLA specification based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing SLA spec draft | Yes | `sdlc/ops/draft/sla-spec-draft.md` or `sdlc/ops/draft/sla-spec-v{N}.md` |
| Review report / feedback | Yes | User provides directly or as `sdlc/ops/input/review-report.md` |
| Additional details | No | New information the user wants to add |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `sla-spec-draft.md` | `sdlc/ops/draft/` |
| Refine | `sla-spec-v{N}.md` | `sdlc/ops/draft/` (N = next version number) |

When user is satisfied -> they copy from `sdlc/ops/draft/` to `sdlc/ops/final/sla-spec-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User runs `/ops-sla-refine` AND existing draft exists in `sdlc/ops/draft/` -> **Mode 2 (Refine)**
- User runs `/ops-sla` -> **Mode 1 (Create)**
- User runs `/ops-sla` but draft already exists -> Ask: "An SLA spec draft already exists. Create new (overwrite) or refine existing?"

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md` -- document formatting standards
2. `skills/shared/rules/quality-rules.md` -- confidence marking, readiness assessment
3. `skills/shared/rules/output-rules.md` -- versioning, input resolution, diff summary
4. `ops/shared/rules/ops-rules.md` -- operations phase rules
5. `ops/sla/knowledge/sla-slo-guide.md` -- SLA/SLO/SLI domain knowledge
6. `ops/sla/rules/output-rules.md` -- SLA-specific output rules
7. `ops/sla/templates/output-template.md` -- expected output structure

### Step 3: Resolve Input

**File Type Conversion** (applies to all file inputs):

Before reading any input file, check its extension:
- `.md` → Read directly, no conversion needed
- `.pdf` → Run `/read-pdf <path> sdlc/ops/input/` → read the converted .md
- `.docx` / `.doc` → Run `/read-word <path> sdlc/ops/input/` → read the converted .md
- `.xlsx` / `.xls` → Run `/read-excel <path> sdlc/ops/input/` → read the converted .md
- `.pptx` / `.ppt` → Run `/read-ppt <path> sdlc/ops/input/` → read the converted .md

Converted files are saved to `sdlc/ops/input/`. If a converted .md already exists and is newer than the source, skip conversion.

**Mode 1 (Create):**

```
For scope input (required):
1. User specified path?                                 -> YES -> read it, copy to sdlc/ops/input/ -> DONE
2. Exists in sdlc/ops/input/scope-final.md?             -> YES -> read it -> DONE
3. Exists in sdlc/init/final/scope-final.md?             -> YES -> read it, copy to sdlc/ops/input/ -> DONE
4. Not found? -> Ask: "No scope document found. Please provide a path or run /init-scope first."

For monitoring plan input (required):
1. User specified path?                                 -> YES -> read it, copy to sdlc/ops/input/ -> DONE
2. Exists in sdlc/ops/input/monitoring-plan-final.md?   -> YES -> read it -> DONE
3. Exists in sdlc/ops/final/monitoring-plan-final.md?   -> YES -> read it, copy to sdlc/ops/input/ -> DONE
4. Not found? -> Ask: "No monitoring plan found. Please provide a path or run /ops-monitor first."

For environment spec input (optional):
1. User specified path?                                 -> YES -> read it, copy to sdlc/ops/input/ -> DONE
2. Exists in sdlc/ops/input/env-spec-final.md?          -> YES -> read it -> DONE
3. Exists in sdlc/deploy/final/env-spec-final.md?       -> YES -> read it, copy to sdlc/ops/input/ -> DONE
4. Not found? -> Proceed without environment spec.

For architecture input (optional):
1. User specified path?                                 -> YES -> read it, copy to sdlc/ops/input/ -> DONE
2. Exists in sdlc/ops/input/architecture-final.md?      -> YES -> read it -> DONE
3. Exists in sdlc/design/final/architecture-final.md?   -> YES -> read it, copy to sdlc/ops/input/ -> DONE
4. Not found? -> Proceed without architecture document.

For incident response input (optional):
1. User specified path?                                 -> YES -> read it, copy to sdlc/ops/input/ -> DONE
2. Exists in sdlc/ops/input/incident-response-final.md? -> YES -> read it -> DONE
3. Exists in sdlc/ops/final/incident-response-final.md? -> YES -> read it, copy to sdlc/ops/input/ -> DONE
4. Not found? -> Proceed without incident response document.
```

**Mode 2 (Refine):**

```
For SLA spec draft:
1. User specified path?                              -> YES -> read it, copy to sdlc/ops/input/ -> DONE
2. Exists in sdlc/ops/input/?                        -> YES -> read it -> DONE
3. Exists in sdlc/ops/draft/ (latest version)?       -> YES -> read it, copy to sdlc/ops/input/ -> DONE
4. Not found? -> FAIL: "No existing SLA spec draft found. Run /ops-sla first."

For review report:
1. User provided feedback directly in message?       -> Save to sdlc/ops/input/review-report.md
2. User specified path?                              -> read it, copy to sdlc/ops/input/
3. Exists in sdlc/ops/input/review-report.md?        -> read it
4. Not found? -> Ask: "What feedback do you have on the current SLA specification?"
```

### Step 4: Generate (Mode-specific)

**Mode 1 -- Create:**

Work through the SLA specification **section by section, incrementally**:

1. **SLI/SLO/SLA Hierarchy** -- Explain relationship, define for this project
   - Define the three concepts: SLI (measurement), SLO (internal target), SLA (external commitment)
   - Explain how they relate in a hierarchy
   - Identify which quality attributes (QA-xxx) map to which SLI categories
   - Present hierarchy to user before detailing

2. **SLI Definitions** -- For each quality attribute
   - Map each QA-xxx to one or more SLIs
   - For each SLI: what is measured, measurement method, data source, time window
   - Cross-reference monitoring plan for available metrics
   - Ensure SLIs are measurable with existing monitoring infrastructure

3. **SLO Targets** -- Internal targets per SLI
   - Derive SLO target from QA-xxx requirement
   - Specify measurement window (e.g., 30-day rolling)
   - Calculate error budget from target (budget = 100% - SLO)
   - Define consequences when SLO is breached (internal)

4. **SLA Commitments** -- External commitments (if applicable)
   - SLA targets less aggressive than SLOs (buffer for internal catch)
   - Specify contractual consequences for SLA breach
   - If no external SLA needed, state explicitly and skip

5. **Error Budgets** -- Calculation and management
   - Calculate error budget per SLO (monthly)
   - Define tracking method (burn rate calculation)
   - Define policy tiers: normal operation, investigation, feature freeze, incident response
   - Specify who owns error budget decisions

6. **SLO Dashboard** -- What to display
   - Key metrics per SLI/SLO
   - Burn rate alerts (fast burn, slow burn)
   - Reporting cadence (daily automated, weekly review, monthly report)
   - Dashboard layout and audience

7. **Review Process** -- Ongoing governance
   - Monthly operational SLO review (what to check, who attends)
   - Quarterly strategic review (target adjustment criteria)
   - Triggers for ad-hoc review (major incident, architecture change)

For each section:
- Apply confidence markers (CONFIRMED / ASSUMED / UNCLEAR)
- Inherit confidence from source documents where applicable
- Create Q&A entries for ASSUMED and UNCLEAR items
- Present section to user before moving to next

**Mode 2 -- Refine:**

1. Read existing SLA spec draft (baseline)
2. Read review report / user feedback
3. Run Quality Scorecard analysis
4. Present scorecard to user
5. Apply improvements:
   - Address user feedback point by point
   - Resolve Q&A entries from previous version
   - Upgrade confidence levels where possible
   - Refine SLO targets based on new information
   - Update error budget calculations if targets change
6. Tag all changes: `[UPDATED]` for modified items, `[NEW]` for additions
7. Preserve CONFIRMED items unless user explicitly contradicts them
8. Write improved version to `sdlc/ops/draft/sla-spec-v{N}.md`

### Step 5: Validate Output

Check against rules:
- Every QA-xxx has at least one SLI + SLO (SLA-01)
- SLI measurement method specified for every SLI (SLA-02)
- SLO targets derive from QA-xxx requirements (SLA-03)
- Error budgets calculated for every SLO (SLA-04)
- SLA targets less aggressive than SLO targets (SLA-05)
- Burn rate alerts defined with thresholds (SLA-06)
- Review cadence specified (monthly + quarterly) (SLA-07)
- Section order matches template (SLA-08)
- Confidence markers on every item (SLA-09)
- Refine mode presents scorecard first (SLA-10)
- Dashboard spec with metrics and reporting cadence (SLA-11)
- Per-service SLOs for multi-service architectures (SLA-12)
- Metrics must be measurable with exact source and method (OPS-09)
- Approval section present (OPS-10)

### Step 6: Readiness Assessment

Generate assessment per `skills/shared/templates/readiness-assessment.md`:
- Count items by confidence level (each SLI is 1 item, each SLO is 1 item, each error budget policy is 1 item)
- Calculate readiness verdict
- In refine mode: compare with previous version

### Step 7: Output

- **Create mode**: Write to `sdlc/ops/draft/sla-spec-draft.md`
- **Refine mode**: Write to `sdlc/ops/draft/sla-spec-v{N}.md`, include Change Log and Diff Summary

Tell the user:
> **SLA Specification {created/refined}!**
> - Output: `sdlc/ops/draft/sla-spec-{version}.md`
> - Readiness: {verdict}
> - SLIs defined: {count} (mapped from {N} quality attributes)
> - SLOs with error budgets: {count}
> - SLA commitments: {count or "None (internal only)"}
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/ops-sla-refine`
> - When satisfied, copy to `sdlc/ops/final/sla-spec-final.md`
> - Then run `/ops-runbook` to define operational runbooks

---

## Scope Rules

### This skill DOES:
- Define SLIs (what to measure) mapped from quality attributes (QA-xxx)
- Set SLO targets (internal) derived from quality attribute requirements
- Define SLA commitments (external, if applicable) with consequences
- Calculate error budgets per SLO with burn rate tracking
- Specify error budget policies (normal, investigation, freeze, incident)
- Define SLO dashboard requirements and reporting cadence
- Establish SLO review process (monthly operational, quarterly strategic)
- Map SLIs to monitoring plan metrics for measurement feasibility

### This skill does NOT:
- Implement monitoring or alerting (belongs to `ops/monitoring` skill)
- Handle incident response procedures (belongs to `ops/incident` skill)
- Define operational runbooks (belongs to `ops/runbook` skill)
- Manage change control processes (belongs to `ops/change` skill)
- Design infrastructure or environments (belongs to `deploy/` phase)
- Make architecture decisions (belongs to `design/` phase)
- Modify source documents -- it reads them as input
