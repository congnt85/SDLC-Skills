# Operational Runbook Output Rules

Rules specific to the operational runbook skill output. These supplement the shared rules in `skills/shared/rules/`.

---

## RBK-01: Alert Coverage

Every alert defined in the monitoring plan MUST have a corresponding runbook. No alert should fire without a documented response procedure. Cross-reference the monitoring plan alert list and verify 1:1 coverage.

## RBK-02: Runbook Completeness

Every runbook MUST include all four response sections:
- **Diagnosis**: Step-by-step investigation procedure
- **Remediation**: Step-by-step fix actions (at least one path)
- **Verification**: How to confirm the fix worked
- **Escalation**: When and to whom to escalate

Omitting any section results in a validation failure.

## RBK-03: Step Specificity

Every step MUST be specific enough for a 3am on-call engineer to execute without guessing:
- Commands MUST include full syntax with parameters (not "restart the service" but the actual CLI command)
- URLs MUST be complete (not "check the dashboard" but the full dashboard URL or path)
- Expected output MUST be described (what does success look like at this step?)
- Time estimates SHOULD be included for steps that take time (e.g., "wait ~3 minutes for tasks to stabilize")

## RBK-04: Routine Operations Required

Routine operations runbooks MUST be present for at minimum:
- Database maintenance (backup verification, vacuum/reindex or equivalent)
- Certificate renewal (SSL/TLS certificate check and renewal procedure)
- Dependency security updates (package audit and patch procedure)

Additional routine runbooks are recommended but not required: log rotation, disk cleanup, access review.

## RBK-05: Deployment Runbooks Required

Deployment runbooks MUST be present for at minimum:
- Standard deployment (normal release process end-to-end)
- Emergency rollback (revert to previous known-good version)

Additional deployment runbooks are recommended: database migration, hotfix deployment, feature flag rollout.

## RBK-06: Disaster Recovery Runbook Required

At least one disaster recovery runbook MUST be present covering full or partial system recovery. The DR runbook MUST:
- Reference RPO/RTO targets from the environment specification
- Include dependency-ordered service startup sequence
- Include data validation steps after recovery
- Include stakeholder communication steps

## RBK-07: Testing Schedule Defined

A runbook testing schedule MUST be defined specifying:
- Which runbooks are tested
- Testing method (tabletop, live drill, chaos engineering)
- Testing frequency (quarterly, monthly, etc.)
- Testing environment (staging, DR environment, etc.)
- Responsible party (who runs the drill)

## RBK-08: Section Order

Runbook document MUST follow this section order:
1. Runbook Inventory
2. Alert Response Runbooks
3. Routine Operations Runbooks
4. Deployment Runbooks
5. Disaster Recovery Runbooks
6. Runbook Testing Schedule
7. Q&A Log
8. Readiness Assessment
9. Approval

## RBK-09: Confidence Markers

Every runbook MUST have a confidence marker at the runbook level:
- ✅ CONFIRMED — procedure validated through testing or production execution
- 🔶 ASSUMED — procedure based on documentation, vendor guides, or team experience but not yet tested
- ❓ UNCLEAR — procedure has gaps, missing commands, or unverified assumptions

Individual steps within a runbook inherit the runbook-level confidence unless explicitly marked otherwise.

## RBK-10: Refine Mode Scorecard First

In refine mode, the quality scorecard MUST be presented before any changes are applied. The scorecard evaluates the existing draft against all RBK rules and identifies gaps.

## RBK-11: Runbook ID Format

Every runbook MUST have a unique ID in the format `RB-{NNN}` (e.g., RB-001, RB-012). IDs are assigned sequentially and never reused. The runbook inventory table MUST list all IDs.

## RBK-12: Last-Tested Date

Every runbook MUST track a "Last Tested" date:
- Set to "Not yet tested" on initial creation
- Updated after each successful drill or production execution
- Runbooks not tested within their scheduled cadence should be flagged in the readiness assessment
