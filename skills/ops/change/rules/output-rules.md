# Output Rules -- ops/change

Change-management-specific output constraints. These supplement the project-wide rules in `skills/shared/rules/` and phase rules in `ops/shared/rules/`.

---

## Change Management Content Rules

### CHG-01: Change Types Required
Change types MUST define three categories: Standard (pre-approved, low risk), Normal (requires review), and Emergency (expedited for incidents). Each type MUST document criteria, examples, approval requirements, and execution constraints.

### CHG-02: Change Process Flowchart
Change request process MUST include a Mermaid flowchart showing the end-to-end workflow from request submission to change closure. Steps MUST have owners and SLA targets.

### CHG-03: CAB or Review Process Defined
A Change Advisory Board or equivalent review process MUST be defined with membership, meeting cadence, and decision criteria. The process MUST scale appropriately to team size.

### CHG-04: Change Windows Specified
Change windows MUST specify allowed days, times, and timezone. Blackout periods MUST be defined (release day buffer, holidays, active incidents). Emergency change exemptions MUST be documented.

### CHG-05: Risk Assessment Criteria Defined
Risk assessment MUST include an impact x likelihood scoring matrix. Risk factors MUST be enumerated (scope, reversibility, test coverage, failure history). Score thresholds for escalated review MUST be defined.

### CHG-06: Rollback Required for Normal and Emergency Changes
Normal and emergency changes MUST document a rollback plan. Rollback criteria (when to trigger) and target rollback time MUST be specified.

### CHG-07: Emergency Post-Hoc Review
Emergency changes MUST require a post-hoc review within 24 hours of execution. The review MUST assess whether the change should be formalized, whether runbooks need updating, and whether the root cause has been addressed.

### CHG-08: Change Tracking Required
Change tracking MUST define a change log format with at minimum: change ID, date, type, description, risk score, outcome, and duration. The log MUST be maintained for all change types.

### CHG-09: Metrics Defined with Targets
Change metrics MUST include at minimum: change success rate (target >95%), failed change rate, emergency change ratio, and mean change duration. Targets MUST be specified for each metric.

### CHG-10: Section Order
Output MUST follow this section order: Change Types -> Change Request Process -> Change Advisory Board -> Change Windows -> Risk Assessment -> Change Execution -> Change Tracking -> Emergency Change Process -> Q&A Log -> Readiness Assessment -> Approval.

### CHG-11: Confidence Markers
Every change management decision (change classification criteria, approval requirements, window schedules, risk thresholds, metric targets) MUST carry a confidence marker: ✅ CONFIRMED, 🔶 ASSUMED, or ❓ UNCLEAR.

### CHG-12: Refine Mode Scorecard
In refine mode, output MUST begin with a Quality Scorecard covering: change type completeness, process clarity, CAB appropriateness, window coverage, risk assessment rigor, rollback feasibility, tracking completeness, and metrics coverage.

---

## Format Rules

### CHG-13: Section Order Enforcement
Change management output MUST follow the section order in `ops/change/templates/output-template.md`.

### CHG-14: ID References
The change management document references existing IDs from other artifacts (e.g., release IDs from release plan, severity levels from incident response). It MAY define change IDs (CHG-xxx) for the change log.

### CHG-15: Confidence Coverage
The Readiness Assessment counts each major decision as 1 item for confidence tallying.

---

## Refine Mode Rules

### CHG-16: Quality Scorecard First
In refine mode, generate Quality Scorecard covering:
- Change Types: Are all three types (standard, normal, emergency) well-defined with criteria?
- Process: Is the change request workflow clear with owners and SLAs?
- CAB: Is the review process appropriate for team size?
- Windows: Are change windows and blackouts specified?
- Risk: Is the scoring matrix complete with thresholds?
- Rollback: Are rollback plans required with time targets?
- Tracking: Is the change log format complete?
- Metrics: Are all key metrics defined with targets?

### CHG-17: TBD Reduction Target
Each refine round should aim to resolve outstanding issues by at least 30%.
