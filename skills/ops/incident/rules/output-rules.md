# Incident Response Output Rules

Rules specific to the incident response skill output. These supplement the shared rules in `skills/shared/rules/` and `ops/shared/rules/ops-rules.md`.

---

## INC-01: Severity Definitions Required

All four severity levels (SEV-1 through SEV-4) MUST be defined, each with:
- Clear user-impact-based criteria
- At least two concrete examples relevant to the project
- Response time target
- Who is paged/notified

## INC-02: Response Times Per Severity

Response time targets MUST be specified for each severity level:
- SEV-1: Less than 5 minutes to begin response
- SEV-2: Less than 15 minutes to begin response
- SEV-3: Less than 1 hour during business hours
- SEV-4: Next business day

Actual targets may vary but MUST be explicitly stated.

## INC-03: Incident Roles Defined

All four incident roles MUST be defined with responsibilities:
- Incident Commander
- Communications Lead
- Technical Responder
- Scribe

Each role MUST specify: who fills it, their responsibilities, and their decision authority.

## INC-04: Escalation Matrix Required

Escalation matrix MUST include for each severity level:
- Escalation trigger (time threshold, no response, scope increase)
- Escalation chain (who is contacted at each tier)
- Response time expectation at each tier
- Automatic escalation rules when no acknowledgment is received

## INC-05: Communication Templates Required

Communication templates MUST be provided for:
- Internal status updates (at minimum for SEV-1/2)
- External status page updates (at minimum for SEV-1/2)
- Customer/stakeholder email (for SEV-1)
- Post-resolution summary

## INC-06: Post-Mortem Within 48 Hours

Post-incident review MUST be required within:
- 48 hours for SEV-1 and SEV-2 incidents
- 1 week for SEV-3 incidents
- SEV-4 does not require a formal post-mortem

The post-mortem template MUST include: timeline, impact, root cause (5 Whys), contributing factors, action items with owners and deadlines.

## INC-07: Mermaid Flowcharts for Response Process

The response process (Detection -> Triage -> Investigation -> Mitigation -> Resolution -> Post-Mortem) MUST include at least one Mermaid flowchart showing the complete workflow with decision points.

## INC-08: Incident Metrics Defined

The following incident metrics MUST be defined with measurement method and targets:
- MTTD (Mean Time to Detect)
- MTTR (Mean Time to Resolve)
- Incident frequency (by severity, monthly)
- Repeat incident rate

## INC-09: Blameless Culture Explicitly Stated

The document MUST explicitly state blameless post-mortem principles:
- Focus on systems and processes, not individuals
- Action items fix systems, not people
- No punitive action for honest mistakes
- Reward transparency and early reporting

## INC-10: Section Order

Incident response document MUST follow this section order:
1. Severity Definitions
2. Incident Roles
3. Response Process
4. Escalation Matrix
5. Communication Plan
6. Post-Incident Review
7. Incident Metrics
8. Q&A Log
9. Readiness Assessment
10. Approval

## INC-11: Confidence Markers on All Decisions

Every decision (response time target, escalation threshold, communication cadence, metric target) MUST have a confidence marker:
- CONFIRMED -- validated by team agreement, industry standard, or organizational policy
- ASSUMED -- based on best practices or similar team experience
- UNCLEAR -- needs team or stakeholder input before finalizing

## INC-12: Refine Mode Scorecard First

In refine mode, the quality scorecard MUST be presented before any changes are applied. The scorecard evaluates the existing draft against all INC rules and identifies gaps.

## INC-13: On-Call Coverage 24/7 for Production

On-call rotation MUST provide 24/7 coverage for production systems:
- Primary and secondary on-call defined
- Rotation schedule (weekly or biweekly)
- Handoff procedure between shifts
- Compensation or time-off policy noted (or flagged as UNCLEAR)

## INC-14: Status Page Integration

Status page integration MUST be defined:
- Which tool or service hosts the status page
- Who has permission to update it
- Update cadence per severity level
- What components are tracked on the status page
- How the status page is linked from the main product
