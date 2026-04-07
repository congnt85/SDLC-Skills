# User Story Template

Standard format for defining user stories during requirements definition.

---

## Story Card

```markdown
### US-{NNN}: {Title}

| Field | Value |
|-------|-------|
| **ID** | US-{NNN} |
| **Epic** | EPIC-{NNN}: {epic title} |
| **Feature** | SCP-{NNN}: {feature name} |
| **Story** | As a {persona}, I want to {action}, so that {benefit}. |
| **Priority** | Must Have / Should Have / Could Have |
| **Story Points** | {1 / 2 / 3 / 5 / 8 / 13} |
| **Personas** | {who benefits} |
| **Dependencies** | {US-xxx IDs or "None"} |
| **Tags** | {optional: [NFR], [SPIKE], [SPLIT RECOMMENDED]} |
| **Confidence** | {✅ CONFIRMED / 🔶 ASSUMED / ❓ UNCLEAR} |

#### Acceptance Criteria

##### US-{NNN}.AC-1: {scenario name}

```gherkin
Scenario: {descriptive name}
  Given {precondition}
  When {action}
  Then {expected result}
```

##### US-{NNN}.AC-2: {edge case or error scenario}

```gherkin
Scenario: {descriptive name}
  Given {precondition}
  When {action}
  Then {expected result}
```

#### INVEST Check

| Criterion | Pass? | Notes |
|-----------|-------|-------|
| Independent | Yes/No | {can develop without other stories?} |
| Negotiable | Yes/No | {describes outcome, not solution?} |
| Valuable | Yes/No | {delivers value to persona?} |
| Estimable | Yes/No | {team can estimate?} |
| Small | Yes/No | {fits in one sprint? <=8 points?} |
| Testable | Yes/No | {has verifiable AC?} |
```

---

## Story Summary Table

```markdown
| ID | Epic | Feature | Title | Persona | Priority | Points | Tags | Confidence |
|----|------|---------|-------|---------|----------|--------|------|------------|
| US-001 | EPIC-001 | SCP-001.1 | {title} | Dev Dana | Must Have | 3 | — | ✅ |
```

---

## Persona Coverage Matrix

```markdown
| Persona | Must Have | Should Have | Could Have | Total Stories | Total Points |
|---------|----------|-------------|------------|--------------|-------------|
| Dev Dana | US-001, US-002 | US-005 | — | 3 | 11 |
| SM Sam | US-010, US-011 | US-020 | US-025 | 4 | 14 |
```

---

## Special Story Types

### NFR Stories (Non-Functional Requirements)

Stories derived from quality attributes (QA-xxx in scope). Tagged with `[NFR]`.

```markdown
### US-{NNN}: [NFR] {Quality attribute title}

| Field | Value |
|-------|-------|
| **Epic** | EPIC-{NNN}: Platform Foundation [CROSS-CUTTING] |
| **Feature** | QA-{NNN}: {attribute} |
| **Story** | As any user, I want {quality expectation}, so that {benefit}. |
| **Tags** | [NFR] |
```

### Spike Stories (Research/Investigation)

Stories derived from high-impact risks (RISK-xxx). Tagged with `[SPIKE]`.

```markdown
### US-{NNN}: [SPIKE] {Investigation title}

| Field | Value |
|-------|-------|
| **Epic** | EPIC-{NNN} |
| **Source** | RISK-{NNN}: {risk description} |
| **Story** | As a developer, I want to {investigate/validate something}, so that {we can confirm feasibility}. |
| **Tags** | [SPIKE] |
| **Time-box** | {max effort — e.g., "2 days"} |
```

---

## Rules

- Every story follows "As a [persona], I want [action], so that [benefit]" format
- At least 2 acceptance criteria per story (happy path + edge case)
- Acceptance criteria use Given/When/Then (Gherkin) format
- Story points on Fibonacci scale (1, 2, 3, 5, 8, 13)
- Stories >8 points flagged `[SPLIT RECOMMENDED]`
- Stories of 13 points must include splitting suggestion
- INVEST check table included for each story
