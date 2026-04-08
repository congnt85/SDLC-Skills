---
name: ops-runbook
description: >
  Create or refine operational runbooks from monitoring plan, environment spec,
  and incident response artifacts. Defines step-by-step procedures for alert
  response, routine operations, deployment, and disaster recovery. ONLY
  activated by command: `/ops-runbook`. Use `--create` or `--refine` to set
  mode. NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine"
version: "1.0"
category: sdlc
phase: ops
prev_phase: ops-sla
next_phase: ops-change
---

# Operational Runbook Skill

## Purpose

Create or refine an operational runbook document (`runbooks-draft.md`) that provides step-by-step procedures for responding to alerts, performing routine operations, handling deployments, and recovering from disasters.

Runbooks bridge monitoring (what to watch) and incident response (how to escalate) by defining the exact actions an on-call engineer takes when an alert fires or an operational task is due. Every procedure is written to be executable at 3am by an engineer who may not have authored the runbook.

---

## Two Modes

### Mode 1: Create (`--create`)

Generate operational runbooks from monitoring plan, environment specification, and supporting artifacts.

| Input | Required | Source |
|-------|----------|--------|
| Monitoring plan (final) | Yes | `sdlc/ops/final/monitoring-plan-final.md` or user-specified path |
| Environment spec (final) | Yes | `sdlc/deploy/final/env-spec-final.md` or user-specified path |
| Incident response (final) | No | `sdlc/ops/final/incident-response-final.md` — severity levels, escalation paths |
| Architecture (final) | No | `sdlc/design/final/architecture-final.md` — service dependencies for impact analysis |
| Database design (final) | No | `sdlc/design/final/database-final.md` — database operations procedures |
| CI/CD pipeline (final) | No | `sdlc/deploy/final/cicd-pipeline-final.md` — deployment/rollback procedures |

### Mode 2: Refine (`--refine`)

Improve existing runbooks based on user feedback, fire drill results, or incident learnings.

| Input | Required | Source |
|-------|----------|--------|
| Existing runbooks draft | Yes | `sdlc/ops/draft/runbooks-draft.md` or `sdlc/ops/draft/runbooks-v{N}.md` |
| Review report / feedback | Yes | User provides directly or as `sdlc/ops/input/review-report.md` |
| Additional details | No | New information the user wants to add |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `runbooks-draft.md` | `sdlc/ops/draft/` |
| Refine | `runbooks-v{N}.md` | `sdlc/ops/draft/` (N = next version number) |

When user is satisfied -> they copy from `sdlc/ops/draft/` to `sdlc/ops/final/runbooks-final.md`.

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
4. `ops/runbook/knowledge/runbook-writing-guide.md` -- runbook design techniques
5. `ops/runbook/rules/output-rules.md` -- runbook-specific output rules
6. `ops/runbook/templates/output-template.md` -- expected output structure

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
For monitoring plan input (required):
1. Exists in sdlc/ops/final/monitoring-plan-final.md?     -> YES -> read it -> DONE
2. User specified a different path?                        -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/ops/input/monitoring-plan-final.md?      -> YES -> read it -> DONE
4. Not found? -> Ask: "No monitoring plan found. Please provide a path or run /ops-monitor first."

For environment spec input (required):
1. Exists in sdlc/deploy/final/env-spec-final.md?         -> YES -> read it -> DONE
2. User specified a different path?                        -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/ops/input/env-spec-final.md?             -> YES -> read it -> DONE
4. Not found? -> Ask: "No environment spec found. Please provide a path or run /deploy-env first."

For incident response input (optional):
1. Exists in sdlc/ops/final/incident-response-final.md?   -> YES -> read it -> DONE
2. User specified a different path?                        -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/ops/input/incident-response-final.md?    -> YES -> read it -> DONE
4. Not found? -> Proceed without incident response document.

For architecture input (optional):
1. Exists in sdlc/design/final/architecture-final.md?     -> YES -> read it -> DONE
2. User specified a different path?                        -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/ops/input/architecture-final.md?         -> YES -> read it -> DONE
4. Not found? -> Proceed without architecture document.

For database design input (optional):
1. Exists in sdlc/design/final/database-final.md?         -> YES -> read it -> DONE
2. User specified a different path?                        -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/ops/input/database-final.md?             -> YES -> read it -> DONE
4. Not found? -> Proceed without database document.

For CI/CD pipeline input (optional):
1. Exists in sdlc/deploy/final/cicd-pipeline-final.md?    -> YES -> read it -> DONE
2. User specified a different path?                        -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/ops/input/cicd-pipeline-final.md?        -> YES -> read it -> DONE
4. Not found? -> Proceed without CI/CD pipeline document.
```

**Mode 2 (Refine):**

```
For runbooks draft:
1. User specified path?                              -> YES -> read it, copy to sdlc/ops/input/ -> DONE
2. Exists in sdlc/ops/input/?                        -> YES -> read it -> DONE
3. Exists in sdlc/ops/draft/ (latest version)?       -> YES -> read it, copy to sdlc/ops/input/ -> DONE
4. Not found? -> FAIL: "No existing runbooks draft found. Run /ops-runbook first."

For review report:
1. User provided feedback directly in message?       -> Save to sdlc/ops/input/review-report.md
2. User specified path?                              -> read it, copy to sdlc/ops/input/
3. Exists in sdlc/ops/input/review-report.md?        -> read it
4. Not found? -> Ask: "What feedback do you have on the current runbooks?"
```

### Step 4: Generate (Mode-specific)

**Mode 1 -- Create:**

Work through the runbooks **section by section, incrementally**:

1. **Runbook Inventory** -- Catalog all runbooks
   - Extract every alert from monitoring-plan-final.md; each alert gets a runbook
   - Identify routine operations from env-spec-final.md (backups, cert renewal, maintenance)
   - Identify deployment procedures from cicd-pipeline-final.md
   - Identify DR scenarios from env-spec-final.md backup/recovery section
   - Assign runbook IDs (RB-{NNN}), trigger conditions, severity, and category
   - Present inventory to user before detailing individual runbooks

2. **Alert Response Runbooks** -- One per alert
   - For each alert from monitoring plan, create a full runbook:
     - **Trigger**: Exact alert condition (metric, threshold, duration)
     - **Impact**: What users experience when this alert fires
     - **Diagnosis**: Step-by-step (check metrics first, then logs, then service health); specific commands and URLs
     - **Remediation**: Step-by-step actions (specific commands with parameters, safety checks before destructive actions)
     - **Verification**: How to confirm the fix worked (check metrics return to normal, test endpoint)
     - **Escalation**: When to escalate, who to contact, what information to provide
   - Cross-reference incident response severity levels if available

3. **Routine Operations Runbooks** -- Scheduled maintenance
   - Database maintenance (vacuum, reindex, backup verification)
   - Log rotation and cleanup
   - Certificate renewal
   - Dependency security updates
   - For each: schedule, procedure, verification, responsible party

4. **Deployment Runbooks** -- Release procedures
   - Standard deployment (pre-checks, deploy, verify, monitor)
   - Emergency rollback (identify issue, rollback steps, verify, communicate)
   - Database migration (backup first, run migration, verify, rollback plan)
   - Hotfix deployment (branch, test, deploy, verify)
   - Reference CI/CD pipeline stages where applicable

5. **Disaster Recovery Runbooks** -- Recovery procedures
   - Database point-in-time recovery
   - Service recovery (single service failure)
   - Full system recovery (dependency-ordered startup)
   - For each: prerequisites, step-by-step, verification, communication plan
   - Reference RPO/RTO targets from env-spec-final.md

6. **Runbook Testing Schedule** -- Fire drill plan
   - Which runbooks to test, when, and by whom
   - Testing methodology (tabletop vs live fire drill)
   - Result recording and runbook update process

For each section:
- Apply confidence markers (CONFIRMED / ASSUMED / UNCLEAR)
- Inherit confidence from source documents where applicable
- Create Q&A entries for ASSUMED and UNCLEAR items
- Present section to user before moving to next

**Mode 2 -- Refine:**

1. Read existing runbooks draft (baseline)
2. Read review report / user feedback
3. Run Quality Scorecard analysis
4. Present scorecard to user
5. Apply improvements:
   - Address user feedback point by point
   - Resolve Q&A entries from previous version
   - Upgrade confidence levels where possible
   - Add missing runbooks for new alerts or procedures
   - Improve step specificity based on fire drill results
   - Update commands/URLs if infrastructure changed
6. Tag all changes: `[UPDATED]` for modified items, `[NEW]` for additions
7. Preserve CONFIRMED items unless user explicitly contradicts them
8. Write improved version to `sdlc/ops/draft/runbooks-v{N}.md`

### Step 5: Validate Output

Check against rules:
- Every item has a confidence marker (CR-01)
- Every alert from monitoring plan has a runbook (RBK-01)
- Every runbook has diagnosis + remediation + verification + escalation (RBK-02)
- Steps are specific with commands and URLs (RBK-03)
- Routine operations runbooks present (DB maintenance, cert renewal) (RBK-04)
- Deployment runbooks present (deploy, rollback) (RBK-05)
- DR runbooks present (RBK-06)
- Testing schedule defined (RBK-07)
- Section order matches template (RBK-08)
- Confidence markers on every step and decision (RBK-09)
- Refine mode scorecard presented first (RBK-10)
- Runbook IDs follow RB-{NNN} format (RBK-11)
- Last-tested date tracked per runbook (RBK-12)
- Approval section present

### Step 6: Readiness Assessment

Generate assessment per `skills/shared/templates/readiness-assessment.md`:
- Count items by confidence level (each runbook is 1 item, each step within a runbook is 1 item)
- Calculate readiness verdict
- In refine mode: compare with previous version

### Step 7: Output

- **Create mode**: Write to `sdlc/ops/draft/runbooks-draft.md`
- **Refine mode**: Write to `sdlc/ops/draft/runbooks-v{N}.md`, include Change Log and Diff Summary

Tell the user:
> **Operational Runbooks {created/refined}!**
> - Output: `sdlc/ops/draft/runbooks-{version}.md`
> - Readiness: {verdict}
> - Total runbooks: {count} (Alert: {a}, Routine: {r}, Deployment: {d}, DR: {dr})
> - Alert coverage: {covered}/{total alerts} alerts from monitoring plan
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/ops-runbook --refine`
> - When satisfied, copy to `sdlc/ops/final/runbooks-final.md`
> - Then run `/ops-change` to define change management procedures

---

## Scope Rules

### This skill DOES:
- Create step-by-step runbooks for every alert from the monitoring plan
- Define routine operations procedures (DB maintenance, cert renewal, dependency updates)
- Define deployment procedures (standard deploy, rollback, migration, hotfix)
- Define disaster recovery procedures (database restore, service recovery, full system recovery)
- Specify diagnosis steps with concrete commands, URLs, and metrics to check
- Specify remediation steps with copy-pasteable commands and safety checks
- Define verification steps to confirm remediation worked
- Define escalation paths with contact information and handoff procedures
- Establish a runbook testing schedule with fire drill methodology

### This skill does NOT:
- Implement automation or scripts (that is engineering implementation work)
- Define monitoring alerts or dashboards (belongs to `ops/monitor` skill)
- Define incident severity levels or response processes (belongs to `ops/incident` skill)
- Define SLA/SLO targets (belongs to `ops/sla` skill)
- Define change management procedures (belongs to `ops/change` skill)
- Execute actual infrastructure changes -- it documents procedures only
- Modify source documents -- it reads them as input
