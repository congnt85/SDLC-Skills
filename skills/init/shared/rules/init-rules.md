# Initiation Phase Rules

Rules specific to all skills in the initiation phase.

---

## Content Rules

### INIT-01: Accept Vagueness Gracefully
Users may start with just a sentence. Never reject input for being too vague.
Instead: generate what you can, mark unknowns as ASSUMED or UNCLEAR, and create Q&A entries.

### INIT-02: Push for SMART Criteria
Every metric, goal, or requirement MUST be pushed toward SMART:
- **S**pecific: What exactly?
- **M**easurable: How will we measure?
- **A**chievable: Is it realistic?
- **R**elevant: Does it align with objectives?
- **T**ime-bound: By when?

If user provides vague metrics (e.g., "improve performance"), mark as 🔶 ASSUMED with a Q&A asking for quantification.

### INIT-03: No Technical Decisions
Initiation skills MUST NOT recommend or decide:
- Programming languages or frameworks
- Database engines
- Cloud providers or hosting
- Architecture patterns (monolith, microservices)

These belong to the `design/` phase. If technical constraints exist (e.g., "must use AWS"), document them as constraints, not decisions.

### INIT-04: Quantify Quality Attributes
Quality attributes MUST be expressed as measurable requirements:

| Bad (reject) | Good (accept) |
|--------------|---------------|
| "Fast" | "API response < 200ms at P95" |
| "Highly available" | "99.9% uptime (8.76 hours downtime/year)" |
| "Scalable" | "Support 10,000 concurrent users" |
| "Secure" | "SOC 2 Type II compliant, data encrypted at rest" |
| "User-friendly" | "New user completes core task in < 3 minutes" |

### INIT-05: Document Assumptions Explicitly
Every assumption MUST be documented with:
- What is assumed
- Impact if the assumption is wrong
- How and when it will be validated

### INIT-06: Flag Scope Creep
If new features or requirements emerge during charter/scope creation that weren't in the original idea, flag them explicitly:
- Add to the In-Scope list with `[NEW — added during initiation]` tag
- Or add to Out-of-Scope with reason for exclusion

---

## Artifact Rules

### INIT-07: Approval Section Required
Every initiation artifact MUST include an Approval section at the end:

```markdown
## Approval

| Role | Name | Date | Status |
|------|------|------|--------|
| Project Sponsor | {name} | {date} | ☐ Pending |
| Product Owner | {name} | {date} | ☐ Pending |
```

### INIT-08: Cross-Reference Consistency
- Project name MUST be identical across all initiation artifacts
- Stakeholder names/roles MUST be consistent
- Feature names in scope MUST match features referenced in charter
- Risk IDs in risk register MUST be unique and sequential

### INIT-09: TBD Tracking
All `[TBD]` placeholders MUST be tracked:
- Each [TBD] should have a note about when/how it will be resolved
- Refine mode should actively try to resolve [TBD]s
- Readiness Assessment counts [TBD]s as UNCLEAR items
