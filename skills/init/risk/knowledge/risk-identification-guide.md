# Risk Identification Guide

Techniques for systematically identifying project risks from charter and scope documents.

---

## Technique 1: Assumption-Based Risk Discovery

Every assumption in the charter is a potential risk. For each assumption, ask: "What if this is wrong?"

### Process

1. List all charter assumptions (ASM-xxx)
2. For each assumption, create a risk:
   - Risk description = inverse of the assumption
   - Impact = the "Impact if Wrong" column from the charter
   - Probability = how confident are we in this assumption?

### Example

```
Charter assumption:
  ASM-002: Teams use branch naming conventions (e.g., feature/TASK-123)
  Impact if Wrong: Can't map commits to tickets

Derived risk:
  RISK-xxx: Target teams may not use consistent branch naming conventions,
            preventing automatic commit-to-ticket mapping
  Category: Technical
  Probability: 3 (Possible — convention usage varies widely)
  Impact: 4 (Major — core feature fails without workaround)
  Response: Mitigate — survey target teams' Git practices; build configurable
            parsing rules as fallback
```

---

## Technique 2: Dependency-Based Risk Discovery

Every dependency in the charter is a potential risk. External dependencies are especially risky.

### Questions for Each Dependency

1. "What if this dependency is delayed?" -> Schedule risk
2. "What if this dependency is unavailable?" -> Technical risk
3. "What if this dependency changes its API/terms?" -> External risk
4. "What if this dependency costs more than expected?" -> Budget risk
5. "Do we have a fallback if this dependency fails?" -> If no, risk is higher

### Dependency Risk Scoring Guide

| Factor | Lower Risk | Higher Risk |
|--------|-----------|-------------|
| Type | Internal | External (third-party) |
| Control | We control it | Someone else controls it |
| History | Reliable, no past issues | Has caused problems before |
| Alternatives | Alternatives exist | Single source, no fallback |
| Timeline | Flexible delivery | Hard deadline |

---

## Technique 3: Constraint-Based Risk Discovery

Constraints limit options. When constraints tighten, risks materialize.

### For Each Constraint, Ask:

- **Timeline constraint**: "What if development takes longer than expected? What's cut first?"
- **Budget constraint**: "What if costs exceed estimates? What's the contingency?"
- **Technical constraint**: "What if the required technology can't meet requirements?"
- **Resource constraint**: "What if key people leave or are reassigned?"
- **Regulatory constraint**: "What if compliance requirements change?"

### Constraint Interaction Risks

Some of the worst risks come from constraints interacting:
- Fixed timeline + fixed scope = quality risk
- Fixed budget + scope creep = resource burnout risk
- Fixed technology + performance requirements = feasibility risk

---

## Technique 4: Scope-Based Risk Discovery

Complex features and integrations carry inherent risk.

### Feature Complexity Risks

| Feature Size | Risk Level | Why |
|-------------|-----------|-----|
| XS-S | Low | Well-understood, quick to build |
| M | Medium | Some unknowns, manageable |
| L | High | Significant unknowns, decomposition needed |
| XL | Very High | Major unknowns, must be broken down |

### Integration Risks

For each integration (INT-xxx) in the scope:
1. **API stability**: "Does this API change frequently?"
2. **Authentication**: "How complex is the auth flow?"
3. **Data volume**: "How much data flows through this integration?"
4. **Latency**: "What happens if the external system is slow?"
5. **Availability**: "What happens if the external system is down?"

### Quality Attribute Risks

For each quality attribute (QA-xxx) in the scope:
1. **Performance**: "Can we actually achieve this target with the expected architecture?"
2. **Scalability**: "What breaks first when load increases?"
3. **Security**: "What's the attack surface?"
4. **Availability**: "What are the single points of failure?"

---

## Technique 5: Category Sweep

Systematically check each risk category to avoid blind spots.

### Checklist Approach

Go through each category and brainstorm risks:

**Technical risks** (things that might not work):
- New or unfamiliar technology
- Complex integrations
- Performance under load
- Data migration challenges
- Security vulnerabilities

**Resource risks** (people problems):
- Key person dependency (bus factor = 1)
- Skill gaps in critical areas
- Team morale or burnout
- Competing priorities for shared resources

**Schedule risks** (timing problems):
- Optimistic estimates
- External dependency delays
- Approval or review bottlenecks
- Holiday/vacation impact
- Sequential dependencies with no buffer

**Scope risks** (building the wrong thing):
- Requirements ambiguity
- Stakeholder disagreements
- Feature creep via "small" additions
- Missing edge cases discovered late

**External risks** (things outside our control):
- Third-party service changes
- Regulatory changes
- Market or competitive shifts
- Vendor pricing changes

**Organizational risks** (company-level issues):
- Sponsor support waning
- Budget cuts mid-project
- Reorganization affecting team
- Competing project priorities

---

## Technique 6: Pre-Mortem

Imagine the project has failed. Work backward to identify why.

### Process

1. State: "It's 6 months from now. The project has failed spectacularly."
2. Ask: "What went wrong?" for each area:
   - "The technology didn't work because..."
   - "We ran out of time because..."
   - "The team fell apart because..."
   - "The stakeholders pulled support because..."
   - "Users rejected the product because..."
3. For each "because", create a risk with mitigation

### Example Pre-Mortem Risks

```
"The project failed because..."
  ...Git webhook data wasn't rich enough to determine ticket status accurately
  -> RISK: Webhook payloads may lack sufficient data for status mapping
  -> Mitigation: PoC in Sprint 0 to validate webhook payload contents

  ...the team spent 2 months on the real-time infrastructure and ran out of time
  -> RISK: Real-time updates may consume disproportionate development effort
  -> Mitigation: Start with polling (simpler), upgrade to WebSocket if time permits

  ...no one used it because the dashboard was too slow
  -> RISK: Dashboard performance degrades with large teams/many tickets
  -> Mitigation: Performance testing from Sprint 2, set P95 latency targets
```

---

## Risk Scoring Calibration

### Common Scoring Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| Everything is "Medium" | No differentiation, no prioritization | Force-rank: at least one High and one Low |
| Ignoring correlation | Risks compound when they trigger together | Note risk interactions in descriptions |
| Optimism bias | Scoring probability too low for uncomfortable risks | Use pre-mortem to challenge assumptions |
| Impact inflation | Everything is "Critical" | Ask: "Would this actually stop the project?" |

### Scoring Anchors

Use these anchors to calibrate scores consistently:

| Score | Probability Anchor | Impact Anchor |
|-------|-------------------|---------------|
| 1 | "This has almost never happened on projects like this" | "A 1-hour inconvenience" |
| 2 | "This happened once in the last 5 projects" | "A day of rework" |
| 3 | "This happens about half the time" | "A sprint of rework" |
| 4 | "This has happened on most projects" | "A month of delay" |
| 5 | "This almost always happens" | "Project cancellation territory" |
