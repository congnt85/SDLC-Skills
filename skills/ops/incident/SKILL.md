---
name: ops-incident
description: >
  Create or refine an incident response document defining severity levels,
  roles, escalation matrix, communication plan, and post-incident review
  process. ONLY activated by commands: `/ops-incident` (create) or
  `/ops-incident-refine` (refine). NEVER auto-trigger based on keywords.
argument-hint: "[path to monitoring-plan-final.md or env-spec-final.md] (md/pdf/docx/xlsx/pptx)"
version: "1.0"
category: sdlc
phase: ops
prev_phase: ops-monitor
next_phase: ops-sla
---

# Incident Response Skill

## Purpose

Create or refine an incident response document (`incident-response-draft.md`) that defines the complete incident response process -- severity levels, incident roles, response workflow, escalation matrix, communication plan, post-incident review process, and incident metrics.

The incident response document bridges "how we detect problems" (monitoring and alerting) and "what we promise" (SLAs) by defining how the team organizes, communicates, and resolves incidents when alerts fire.

---

## Two Modes

### Mode 1: Create (`/ops-incident`)

Generate an incident response document from monitoring plan and infrastructure artifacts.

| Input | Required | Source |
|-------|----------|--------|
| Monitoring plan (final) | Yes | `sdlc/ops/final/monitoring-plan-final.md` or user-specified path |
| Environment spec (final) | Yes | `sdlc/deploy/final/env-spec-final.md` or user-specified path |
| Architecture (final) | No | `sdlc/design/final/architecture-final.md` -- service dependencies for impact analysis |
| Scope (final) | No | `sdlc/init/final/scope-final.md` -- availability targets for severity calibration |
| Charter (final) | No | `sdlc/init/final/charter-final.md` -- team structure for on-call assignments |
| Release plan (final) | No | `sdlc/deploy/final/release-plan-final.md` -- rollback procedures |

### Mode 2: Refine (`/ops-incident-refine`)

Improve existing incident response document based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing incident response draft | Yes | `sdlc/ops/draft/incident-response-draft.md` or `sdlc/ops/draft/incident-response-v{N}.md` |
| Review report / feedback | Yes | User provides directly or as `sdlc/ops/input/review-report.md` |
| Additional details | No | New information the user wants to add |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `incident-response-draft.md` | `sdlc/ops/draft/` |
| Refine | `incident-response-v{N}.md` | `sdlc/ops/draft/` (N = next version number) |

When user is satisfied -> they copy from `sdlc/ops/draft/` to `sdlc/ops/final/incident-response-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User runs `/ops-incident-refine` AND existing draft exists in `sdlc/ops/draft/` -> **Mode 2 (Refine)**
- User runs `/ops-incident` -> **Mode 1 (Create)**
- User runs `/ops-incident` but draft already exists -> Ask: "An incident response draft already exists. Create new (overwrite) or refine existing?"

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md` -- document formatting standards
2. `skills/shared/rules/quality-rules.md` -- confidence marking, readiness assessment
3. `skills/shared/rules/output-rules.md` -- versioning, input resolution, diff summary
4. `ops/shared/rules/ops-rules.md` -- operations phase rules
5. `ops/incident/knowledge/incident-response-guide.md` -- incident response techniques
6. `ops/incident/rules/output-rules.md` -- incident-specific output rules
7. `ops/incident/templates/output-template.md` -- expected output structure

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
For monitoring plan input (required):
1. User specified path?                                 -> YES -> read it, copy to sdlc/ops/input/ -> DONE
2. Exists in sdlc/ops/input/monitoring-plan-final.md?   -> YES -> read it -> DONE
3. Exists in sdlc/ops/final/monitoring-plan-final.md?   -> YES -> read it, copy to sdlc/ops/input/ -> DONE
4. Not found? -> Ask: "No monitoring plan found. Please provide a path or run /ops-monitor first."

For environment spec input (required):
1. User specified path?                                 -> YES -> read it, copy to sdlc/ops/input/ -> DONE
2. Exists in sdlc/ops/input/env-spec-final.md?          -> YES -> read it -> DONE
3. Exists in sdlc/deploy/final/env-spec-final.md?       -> YES -> read it, copy to sdlc/ops/input/ -> DONE
4. Not found? -> Ask: "No environment spec found. Please provide a path or run /deploy-env first."

For architecture input (optional):
1. User specified path?                                 -> YES -> read it, copy to sdlc/ops/input/ -> DONE
2. Exists in sdlc/ops/input/architecture-final.md?      -> YES -> read it -> DONE
3. Exists in sdlc/design/final/architecture-final.md?   -> YES -> read it, copy to sdlc/ops/input/ -> DONE
4. Not found? -> Proceed without architecture document.

For scope input (optional):
1. User specified path?                                 -> YES -> read it, copy to sdlc/ops/input/ -> DONE
2. Exists in sdlc/ops/input/scope-final.md?             -> YES -> read it -> DONE
3. Exists in sdlc/init/final/scope-final.md?             -> YES -> read it, copy to sdlc/ops/input/ -> DONE
4. Not found? -> Proceed without scope document.

For charter input (optional):
1. User specified path?                                 -> YES -> read it, copy to sdlc/ops/input/ -> DONE
2. Exists in sdlc/ops/input/charter-final.md?           -> YES -> read it -> DONE
3. Exists in sdlc/init/final/charter-final.md?           -> YES -> read it, copy to sdlc/ops/input/ -> DONE
4. Not found? -> Proceed without charter document.

For release plan input (optional):
1. User specified path?                                 -> YES -> read it, copy to sdlc/ops/input/ -> DONE
2. Exists in sdlc/ops/input/release-plan-final.md?      -> YES -> read it -> DONE
3. Exists in sdlc/deploy/final/release-plan-final.md?   -> YES -> read it, copy to sdlc/ops/input/ -> DONE
4. Not found? -> Proceed without release plan document.
```

**Mode 2 (Refine):**

```
For incident response draft:
1. User specified path?                              -> YES -> read it, copy to sdlc/ops/input/ -> DONE
2. Exists in sdlc/ops/input/?                        -> YES -> read it -> DONE
3. Exists in sdlc/ops/draft/ (latest version)?       -> YES -> read it, copy to sdlc/ops/input/ -> DONE
4. Not found? -> FAIL: "No existing incident response draft found. Run /ops-incident first."

For review report:
1. User provided feedback directly in message?       -> Save to sdlc/ops/input/review-report.md
2. User specified path?                              -> read it, copy to sdlc/ops/input/
3. Exists in sdlc/ops/input/review-report.md?        -> read it
4. Not found? -> Ask: "What feedback do you have on the current incident response document?"
```

### Step 4: Generate (Mode-specific)

**Mode 1 -- Create:**

Work through the incident response document **section by section, incrementally**:

1. **Severity Definitions** -- SEV-1 through SEV-4
   - Define each severity with clear criteria based on user impact
   - Include concrete examples mapped to the project's services and alerts
   - Specify response time targets for each severity level
   - Map monitoring alerts to severity levels (from monitoring-plan-final.md)
   - Calibrate against availability targets (from scope-final.md if available)
   - Present severity table to user before proceeding

2. **Incident Roles** -- Who does what during an incident
   - Define four core roles: Incident Commander, Communications Lead, Technical Responder, Scribe
   - Specify responsibilities for each role at each severity level
   - Define handoff procedures (shift changes, commander rotation)
   - Map roles to team structure (from charter-final.md if available)
   - Define on-call rotation structure

3. **Response Process** -- Detection through post-mortem
   - Define the full lifecycle: Detection -> Triage -> Investigation -> Mitigation -> Resolution -> Post-Mortem
   - Generate Mermaid flowchart for the response process
   - Detail each phase with entry/exit criteria and time expectations
   - Include decision points (escalate? rollback? page additional responders?)
   - Reference rollback procedures (from release-plan-final.md if available)

4. **Escalation Matrix** -- When and to whom
   - Define escalation triggers per severity level
   - Specify escalation chain with response time at each tier
   - Include automatic escalation rules (no response within N minutes -> next tier)
   - Define management notification thresholds
   - Include after-hours and weekend escalation differences

5. **Communication Plan** -- Internal and external
   - Internal: Slack channels, war room creation, update frequency per severity
   - External: Status page updates, customer communication, stakeholder emails
   - Provide communication templates for each severity level
   - Define who approves external communications
   - Specify status page integration and update cadence

6. **Post-Incident Review** -- Blameless retrospective
   - Define timeline for post-incident review (within 48hr for SEV-1/2, within 1 week for SEV-3)
   - Provide post-mortem template (timeline, impact, root cause, contributing factors, action items)
   - Specify 5 Whys technique for root cause analysis
   - Define action item tracking (owner, deadline, follow-up cadence)
   - Explicitly state blameless culture principles

7. **Incident Metrics** -- Measuring response effectiveness
   - Define MTTD (Mean Time to Detect), MTTR (Mean Time to Resolve)
   - Track incident frequency by severity
   - Track repeat incidents (same root cause recurring)
   - Define review cadence for metrics (monthly)
   - Set improvement targets for each metric

For each section:
- Apply confidence markers (CONFIRMED / ASSUMED / UNCLEAR)
- Inherit confidence from source documents where applicable
- Create Q&A entries for ASSUMED and UNCLEAR items
- Present section to user before moving to next

**Mode 2 -- Refine:**

1. Read existing incident response draft (baseline)
2. Read review report / user feedback
3. Run Quality Scorecard analysis
4. Present scorecard to user
5. Apply improvements:
   - Address user feedback point by point
   - Resolve Q&A entries from previous version
   - Upgrade confidence levels where possible
   - Refine severity definitions based on new information
   - Update escalation and communication details
6. Tag all changes: `[UPDATED]` for modified items, `[NEW]` for additions
7. Preserve CONFIRMED items unless user explicitly contradicts them
8. Write improved version to `sdlc/ops/draft/incident-response-v{N}.md`

### Step 5: Validate Output

Check against rules:
- Every item has a confidence marker (CR-01)
- Severity levels SEV-1 through SEV-4 defined with criteria, examples, response times (INC-01)
- Response times specified per severity level (INC-02)
- All four incident roles defined with responsibilities (INC-03)
- Escalation matrix with triggers, chains, and response times (INC-04)
- Communication templates for each severity level (INC-05)
- Post-mortem required for SEV-1/2 within 48 hours (INC-06)
- Mermaid flowchart for response process (INC-07)
- Incident metrics defined with targets (INC-08)
- Blameless culture explicitly stated (INC-09)
- Section order matches template (INC-10)
- Confidence markers on all decisions (INC-11)
- Refine mode scorecard presented first (INC-12)
- On-call coverage 24/7 for production (INC-13)
- Status page integration defined (INC-14)
- Approval section present (OPS-10)

### Step 6: Readiness Assessment

Generate assessment per `skills/shared/templates/readiness-assessment.md`:
- Count items by confidence level (each severity definition is 1 item, each role is 1 item, each escalation rule is 1 item, each template is 1 item)
- Calculate readiness verdict
- In refine mode: compare with previous version

### Step 7: Output

- **Create mode**: Write to `sdlc/ops/draft/incident-response-draft.md`
- **Refine mode**: Write to `sdlc/ops/draft/incident-response-v{N}.md`, include Change Log and Diff Summary

Tell the user:
> **Incident Response Document {created/refined}!**
> - Output: `sdlc/ops/draft/incident-response-{version}.md`
> - Readiness: {verdict}
> - Severity Levels: {count} defined
> - Incident Roles: {count} defined
> - Escalation Tiers: {count} per severity
> - Communication Templates: {count}
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/ops-incident-refine`
> - When satisfied, copy to `sdlc/ops/final/incident-response-final.md`
> - Then run `/ops-sla` to define SLA targets and error budgets

---

## Scope Rules

### This skill DOES:
- Define severity levels (SEV-1 through SEV-4) with criteria and response times
- Define incident roles (Commander, Communications Lead, Responder, Scribe)
- Define the response process from detection through post-mortem
- Define escalation matrix with triggers and chains per severity
- Define communication plan for internal and external stakeholders
- Define post-incident review process with blameless culture principles
- Define incident metrics (MTTD, MTTR, frequency, repeat rate)
- Provide communication templates per severity level

### This skill does NOT:
- Implement monitoring or alerting (belongs to `ops/monitor` skill)
- Define SLA/SLO targets or error budgets (belongs to `ops/sla` skill)
- Create operational runbooks for specific issues (belongs to `ops/runbook` skill)
- Define change management processes (belongs to `ops/change` skill)
- Configure actual alerting tools or PagerDuty (that's implementation work)
- Modify source documents -- it reads them as input
