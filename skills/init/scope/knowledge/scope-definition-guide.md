# Scope Definition Guide

Techniques for expanding a charter's high-level scope into a detailed, actionable scope document.

---

## Technique 1: Feature Decomposition

Break high-level features into manageable sub-features using progressive elaboration.

### The Decomposition Rule

| Feature Complexity | Action |
|-------------------|--------|
| XS (< 1 day) | No decomposition needed |
| S (1-3 days) | No decomposition needed |
| M (3-5 days) | Decompose into 2-4 sub-features |
| L (1-2 weeks) | Decompose into 3-6 sub-features |
| XL (2+ weeks) | Must decompose — too large for a single feature |

### Decomposition Checklist

For each feature, ask:
1. Can this be delivered independently? If no, identify dependencies
2. Can this be tested independently? If no, it may be too tightly coupled
3. Does this serve one persona or many? If many, consider splitting by persona
4. Does this have a single workflow or multiple? If multiple, split by workflow

### Example

```
Charter feature: "Git integration" (SCP-001)

Decomposed:
  SCP-001.1: Webhook receiver (accept GitHub/GitLab events)     — Must Have, S
  SCP-001.2: Event parser (extract commit/PR/branch data)       — Must Have, M
  SCP-001.3: Ticket mapper (match events to tickets via branch) — Must Have, M
  SCP-001.4: Status updater (change ticket status from events)  — Must Have, M
  SCP-001.5: Manual override (allow users to correct mappings)  — Should Have, S
```

---

## Technique 2: MoSCoW Prioritization

Assign priority using MoSCoW to distinguish essential from optional scope.

| Priority | Meaning | Guideline |
|----------|---------|-----------|
| **Must Have** | System doesn't work without it | ~60% of features |
| **Should Have** | Important, painful to leave out | ~20% of features |
| **Could Have** | Nice to have, only if time permits | ~20% of features |
| **Won't Have** | Explicitly excluded from this release | Documented in Out-of-Scope |

### MoSCoW Decision Questions

- "If we don't build this, can the user still accomplish their primary goal?" -> If yes, it's not Must Have
- "Would a user choose a competitor if we don't have this?" -> If yes, Should Have
- "Has any stakeholder specifically asked for this?" -> If no, Could Have at best
- "Does this depend on features we haven't confirmed yet?" -> Risky for Must Have

---

## Technique 3: Persona Discovery

Extract personas from the charter's target audience and vision statement.

### Discovery Questions

1. **Who uses the system directly?** -> Primary personas
2. **Who benefits without directly using it?** -> Secondary or excluded
3. **Who administers or configures the system?** -> Admin persona
4. **Who pays for the system?** -> Buyer persona (may differ from user)
5. **Who might resist or be harmed by the system?** -> Negative stakeholder

### Persona Validation Checklist

- [ ] Each persona represents a distinct set of goals (not just a job title)
- [ ] Personas cover at least 80% of expected usage
- [ ] Each persona has specific, observable behaviors (not demographics)
- [ ] Pain points are about the problem domain, not system features
- [ ] Scenarios describe tasks, not screens or UI elements

### Common Persona Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| "The User" | Too generic, no differentiation | Split by role, goal, or frequency |
| "The Admin" only | Ignores end users | Add personas for each user type |
| 10+ personas | Too many, can't prioritize | Merge similar, exclude edge cases |
| Demographic-only | Age/gender don't drive features | Focus on goals and behaviors |

---

## Technique 4: Integration Mapping

Identify all external system touchpoints systematically.

### Integration Discovery Questions

1. **Data sources**: "Where does the system get its input data from?"
2. **Data sinks**: "Where does the system send output data to?"
3. **Auth providers**: "How do users authenticate? (SSO, OAuth, LDAP?)"
4. **Notification channels**: "How does the system communicate with users? (email, Slack, push?)"
5. **Payment/billing**: "Does the system handle money? Through what service?"
6. **Analytics**: "What analytics or monitoring tools are needed?"
7. **Legacy systems**: "What existing systems must this coexist with?"

### Integration Classification

| Direction | Meaning | Examples |
|-----------|---------|---------|
| IN | System receives data | Webhooks, API polling, file import |
| OUT | System sends data | Notifications, reports, API calls |
| BI (Bidirectional) | Both directions | Two-way sync, real-time collaboration |

---

## Technique 5: Quality Attribute Elicitation

Extract measurable quality requirements from vague expectations.

### The Quantification Ladder

When users say vague things, climb the ladder:

```
Level 0 (Vague):    "It should be fast"
Level 1 (Relative):  "Faster than our current system"
Level 2 (Bounded):   "Under 1 second"
Level 3 (SMART):     "API response < 200ms at P95 under 1000 concurrent users"
```

Always push to Level 3. If user can't specify, use Level 2 and mark as ASSUMED.

### Standard Quality Attribute Prompts

| Attribute | Prompt |
|-----------|--------|
| Performance | "What's the acceptable response time? How many concurrent users?" |
| Availability | "How much downtime is acceptable? Is 24/7 needed?" |
| Scalability | "How many users/records/transactions at launch? In 1 year? In 3 years?" |
| Security | "What data is sensitive? Any compliance requirements (SOC 2, HIPAA, GDPR)?" |
| Accessibility | "Any accessibility standards required (WCAG)? Target audience limitations?" |
| Maintainability | "How often will the system change? Who maintains it?" |

---

## Working with Charter Input

### Mapping Charter to Scope

| Charter Section | Scope Section(s) |
|----------------|------------------|
| Vision (target audience) | Personas |
| In-Scope features | Feature Inventory (expanded) |
| Out-of-Scope | Project Boundaries |
| Success Metrics | Quality Attributes (partially) |
| Constraints (technical) | System Context |
| Dependencies (external) | System Context, Integrations |
| Assumptions | Inherited as scope assumptions |

### Confidence Inheritance

When carrying information from charter to scope:
- Charter CONFIRMED -> Scope CONFIRMED (unless scope adds detail that's assumed)
- Charter ASSUMED -> Scope ASSUMED (inherit the uncertainty)
- Charter UNCLEAR -> Scope UNCLEAR (don't upgrade without evidence)
- New scope items not in charter -> Default to ASSUMED

### Gap Detection

After mapping charter to scope, check for:
1. **Features without personas**: Who uses this feature? If unclear, add Q&A
2. **Personas without features**: This persona has no features — are they really in scope?
3. **Features without quality attributes**: What's the performance expectation for this feature?
4. **Integrations without features**: What features depend on this integration?
