---
name: ops-change
description: >
  Create or refine a change management document defining how production changes
  are requested, reviewed, approved, executed, and tracked. ONLY activated by
  command: `/ops-change`. Use `--create` or `--refine` to set mode. NEVER
  auto-trigger based on keywords.
argument-hint: "--create|--refine [path to release-plan-final.md or cicd-pipeline-final.md] (md/pdf/docx/xlsx/pptx)"
version: "1.0"
category: sdlc
phase: ops
prev_phase: ops-runbook
next_phase: null
---

# Change Management Skill

## Purpose

Create or refine a change management document (`change-mgmt-draft.md`) that defines the complete change management process for production systems. This covers how changes are classified, requested, reviewed, approved, scheduled, executed, verified, and tracked.

The change management skill is the final skill in the entire SDLC system. It closes the loop between deployment (how changes ship) and operations (how changes are governed), ensuring that all production changes are tracked, risk-assessed, reversible, and verified.

---

## Two Modes

### Mode 1: Create (`--create`)

Generate a change management process from release and deployment artifacts.

| Input | Required | Source |
|-------|----------|--------|
| Release plan (final) | Yes | `sdlc/deploy/final/release-plan-final.md` or user-specified path |
| CI/CD pipeline (final) | Yes | `sdlc/deploy/final/cicd-pipeline-final.md` or user-specified path |
| Incident response (final) | No | `sdlc/ops/final/incident-response-final.md` — emergency change handling |
| Monitoring plan (final) | No | `sdlc/ops/final/monitoring-plan-final.md` — change monitoring, rollback triggers |
| Environment spec (final) | No | `sdlc/deploy/final/env-spec-final.md` — environments affected by changes |
| SLA spec (final) | No | `sdlc/ops/final/sla-spec-final.md` — SLO impact assessment for changes |

### Mode 2: Refine (`--refine`)

Improve existing change management document based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing change mgmt draft | Yes | `sdlc/ops/draft/change-mgmt-draft.md` or `sdlc/ops/draft/change-mgmt-v{N}.md` |
| Review report / feedback | Yes | User provides directly or as `sdlc/ops/input/review-report.md` |
| Additional details | No | New information the user wants to add |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `change-mgmt-draft.md` | `sdlc/ops/draft/` |
| Refine | `change-mgmt-v{N}.md` | `sdlc/ops/draft/` (N = next version number) |

When user is satisfied -> they copy from `sdlc/ops/draft/` to `sdlc/ops/final/change-mgmt-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User passes `--refine` argument → **Mode 2 (Refine)**
- User passes `--create` argument → **Mode 1 (Create)**
- No argument specified AND existing draft exists in `sdlc/ops/draft/` → Ask: "A draft already exists. Use `--create` to start fresh or `--refine` to improve it."
- No argument specified AND no draft exists → **Mode 1 (Create)**

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md` -- document formatting standards
2. `skills/shared/rules/quality-rules.md` -- confidence marking, readiness assessment
3. `skills/shared/rules/output-rules.md` -- versioning, input resolution, diff summary
4. `ops/shared/rules/ops-rules.md` -- operations phase rules
5. `ops/change/knowledge/change-management-guide.md` -- change management techniques
6. `ops/change/rules/output-rules.md` -- change-management-specific output rules
7. `ops/change/templates/output-template.md` -- expected output structure

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
For release plan input (required):
1. User specified path?                                -> YES -> read it, copy to sdlc/ops/input/ -> DONE
2. Exists in sdlc/ops/input/release-plan-final.md?     -> YES -> read it -> DONE
3. Exists in sdlc/deploy/final/release-plan-final.md?  -> YES -> read it, copy to sdlc/ops/input/ -> DONE
4. Not found? -> Ask: "No release plan found. Please provide a path or run /deploy-release first."

For CI/CD pipeline input (required):
1. User specified path?                                -> YES -> read it, copy to sdlc/ops/input/ -> DONE
2. Exists in sdlc/ops/input/cicd-pipeline-final.md?    -> YES -> read it -> DONE
3. Exists in sdlc/deploy/final/cicd-pipeline-final.md? -> YES -> read it, copy to sdlc/ops/input/ -> DONE
4. Not found? -> Ask: "No CI/CD pipeline document found. Please provide a path or run /deploy-cicd first."

For incident response input (optional):
1. User specified path?                                 -> YES -> read it, copy to sdlc/ops/input/ -> DONE
2. Exists in sdlc/ops/input/incident-response-final.md? -> YES -> read it -> DONE
3. Exists in sdlc/ops/final/incident-response-final.md? -> YES -> read it, copy to sdlc/ops/input/ -> DONE
4. Not found? -> Proceed without incident response document.

For monitoring plan input (optional):
1. User specified path?                                 -> YES -> read it, copy to sdlc/ops/input/ -> DONE
2. Exists in sdlc/ops/input/monitoring-plan-final.md?   -> YES -> read it -> DONE
3. Exists in sdlc/ops/final/monitoring-plan-final.md?   -> YES -> read it, copy to sdlc/ops/input/ -> DONE
4. Not found? -> Proceed without monitoring plan document.

For environment spec input (optional):
1. User specified path?                                -> YES -> read it, copy to sdlc/ops/input/ -> DONE
2. Exists in sdlc/ops/input/env-spec-final.md?         -> YES -> read it -> DONE
3. Exists in sdlc/deploy/final/env-spec-final.md?      -> YES -> read it, copy to sdlc/ops/input/ -> DONE
4. Not found? -> Proceed without environment spec document.

For SLA spec input (optional):
1. User specified path?                                -> YES -> read it, copy to sdlc/ops/input/ -> DONE
2. Exists in sdlc/ops/input/sla-spec-final.md?         -> YES -> read it -> DONE
3. Exists in sdlc/ops/final/sla-spec-final.md?         -> YES -> read it, copy to sdlc/ops/input/ -> DONE
4. Not found? -> Proceed without SLA spec document.
```

**Mode 2 (Refine):**

```
For change mgmt draft:
1. User specified path?                           -> YES -> read it, copy to sdlc/ops/input/ -> DONE
2. Exists in sdlc/ops/input/?                     -> YES -> read it -> DONE
3. Exists in sdlc/ops/draft/ (latest version)?    -> YES -> read it, copy to sdlc/ops/input/ -> DONE
4. Not found? -> FAIL: "No existing change management draft found. Run /ops-change first."

For review report:
1. User provided feedback directly in message?    -> Save to sdlc/ops/input/review-report.md
2. User specified path?                           -> read it, copy to sdlc/ops/input/
3. Exists in sdlc/ops/input/review-report.md?     -> read it
4. Not found? -> Ask: "What feedback do you have on the current change management document?"
```

### Step 4: Generate (Mode-specific)

**Mode 1 -- Create:**

Work through the change management document **section by section, incrementally**:

1. **Change Types** -- Classification and criteria
   - Define three change types: Standard (pre-approved, low risk), Normal (requires review), Emergency (expedited for incidents)
   - For each type: criteria, examples, approval requirements, execution constraints
   - Map change types to release types from release-plan-final.md
   - Present classification to user before detailing

2. **Change Request Process** -- End-to-end workflow
   - Define process: Request -> Risk Assess -> Route by Type -> Review/Approve -> Schedule -> Execute -> Verify -> Close
   - Generate Mermaid flowchart showing the complete change lifecycle
   - Define owners and SLAs for each step
   - Map to CI/CD pipeline stages from cicd-pipeline-final.md

3. **Change Advisory Board** -- Review and governance
   - Define CAB membership (who reviews changes)
   - Meeting cadence (async review vs scheduled sync)
   - Decision criteria (risk, impact, rollback plan, test evidence)
   - Scale CAB process to team size (lightweight for small teams, formal for larger)

4. **Change Windows** -- Scheduling constraints
   - Define regular change windows (days, times, timezone)
   - Blackout periods (release days, holidays, during incidents)
   - Emergency change exemptions
   - Align with release calendar from release-plan-final.md

5. **Risk Assessment** -- Per-change risk scoring
   - Impact x Likelihood matrix (3x3 or 5x5)
   - Risk factors: scope of change, reversibility, test coverage, previous failure history
   - Risk score thresholds for additional review requirements
   - Map known risks from monitoring-plan-final.md if available

6. **Change Execution** -- Pre/during/post checklists
   - Pre-change checklist: verify rollback plan, notify team, check monitoring baseline
   - Execution steps: follow runbook/deploy process, monitor metrics
   - Post-change verification: health checks, error rate monitoring, soak period
   - Rollback criteria: when to trigger rollback, who decides, target time

7. **Change Tracking** -- Logging and metrics
   - Change log format (change ID, date, type, description, risk, outcome, duration)
   - Metrics: change volume, success rate, failed change rate, mean change duration
   - Targets for each metric
   - Correlation analysis: changes vs incidents

8. **Emergency Change Process** -- Expedited handling
   - Expedited approval flow (reduced reviewer count)
   - Generate Mermaid flowchart for emergency change lifecycle
   - Post-hoc review requirement (within 24 hours)
   - Integration with incident response process from incident-response-final.md

For each section:
- Apply confidence markers (CONFIRMED / ASSUMED / UNCLEAR)
- Inherit confidence from source documents where applicable
- Create Q&A entries for ASSUMED and UNCLEAR items
- Present section to user before moving to next

**Mode 2 -- Refine:**

1. Read existing change management draft (baseline)
2. Read review report / user feedback
3. Run Quality Scorecard analysis
4. Present scorecard to user
5. Apply improvements:
   - Address user feedback point by point
   - Resolve Q&A entries from previous version
   - Upgrade confidence levels where possible
   - Refine risk assessment criteria based on new information
   - Update change windows and CAB process as needed
6. Tag all changes: `[UPDATED]` for modified items, `[NEW]` for additions
7. Preserve CONFIRMED items unless user explicitly contradicts them
8. Write improved version to `sdlc/ops/draft/change-mgmt-v{N}.md`

### Step 5: Validate Output

Check against rules:
- Every item has a confidence marker (CR-01)
- Change types defined: standard, normal, emergency (CHG-01)
- Change request process includes Mermaid flowchart (CHG-02)
- CAB or review process defined with membership and cadence (CHG-03)
- Change windows specified with blackout periods (CHG-04)
- Risk assessment criteria defined with scoring matrix (CHG-05)
- Rollback required for normal and emergency changes (CHG-06)
- Emergency changes require post-hoc review within 24hr (CHG-07)
- Change tracking and logging format defined (CHG-08)
- Metrics defined with targets (CHG-09)
- Section order matches template (CHG-10)
- Confidence markers on every item (CHG-11)
- Refine mode shows quality scorecard first (CHG-12)

### Step 6: Readiness Assessment

Generate assessment per `skills/shared/templates/readiness-assessment.md`:
- Count items by confidence level (each change type is 1 item, each process step is 1 item, each metric is 1 item)
- Calculate readiness verdict
- In refine mode: compare with previous version

### Step 7: Output

- **Create mode**: Write to `sdlc/ops/draft/change-mgmt-draft.md`
- **Refine mode**: Write to `sdlc/ops/draft/change-mgmt-v{N}.md`, include Change Log and Diff Summary

Tell the user:
> **Change Management Document {created/refined}!**
> - Output: `sdlc/ops/draft/change-mgmt-{version}.md`
> - Readiness: {verdict}
> - Change types: {count} (Standard: {S}, Normal: {N}, Emergency: {E})
> - Process steps: {count}
> - Metrics defined: {count}
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/ops-change --refine`
> - When satisfied, copy to `sdlc/ops/final/change-mgmt-final.md`
> - This is the final skill in the SDLC pipeline -- your operational documentation is complete!

---

## Scope Rules

### This skill DOES:
- Define change types (standard, normal, emergency) with criteria and examples
- Specify the change request process from request to close with Mermaid flowchart
- Define Change Advisory Board membership, cadence, and decision criteria
- Specify change windows, blackout periods, and scheduling constraints
- Create risk assessment criteria with impact/likelihood scoring matrix
- Define change execution checklists (pre-change, during, post-change)
- Specify change tracking format, metrics, and improvement targets
- Define emergency change process with expedited approval and post-hoc review

### This skill does NOT:
- Execute changes or deploy code (that's DevOps work and CI/CD pipeline execution)
- Define the deployment process itself (belongs to `deploy/cicd` skill)
- Define incident response procedures (belongs to `ops/incident` skill)
- Create operational runbooks (belongs to `ops/runbook` skill)
- Define SLA/SLO contracts (belongs to `ops/sla` skill)
- Define monitoring and alerting (belongs to `ops/monitoring` skill)
- Modify source documents -- it reads them as input
