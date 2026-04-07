# Technology Decision Matrix Template

Standard format for evaluating and selecting technologies.

---

## Decision Matrix

```markdown
### {Category} Selection (e.g., Backend Framework, Database, etc.)

**Decision**: {chosen technology}

| Criterion | Weight | {Option A} | {Option B} | {Option C} |
|-----------|--------|-----------|-----------|-----------|
| {criterion 1} | {1-5} | {1-5} ({score}) | {1-5} ({score}) | {1-5} ({score}) |
| {criterion 2} | {1-5} | {1-5} ({score}) | {1-5} ({score}) | {1-5} ({score}) |
| ... | | | | |
| **Weighted Total** | | **{total}** | **{total}** | **{total}** |

**Rationale**: {1-2 sentences explaining the decision}
```

---

## Standard Criteria

| Criterion | Description | When to Weight High |
|-----------|-------------|-------------------|
| Performance | Runtime speed, throughput, latency | Performance-critical systems (QA-001) |
| Scalability | Handles growth in users/data/traffic | High scalability targets (QA-003) |
| Team expertise | Current team knowledge and experience | Tight timeline, small team |
| Community/ecosystem | Libraries, plugins, community size | Need many integrations |
| Learning curve | Time to become productive | New team members expected |
| Maturity | Stability, production-readiness, LTS | Enterprise / compliance needs |
| Security | Known vulnerabilities, security features | Sensitive data, compliance (QA-004) |
| Cost | Licensing, hosting, operational costs | Budget-constrained projects |
| Maintainability | Code readability, tooling, debugging | Long-lived products |
| Hiring market | Availability of developers with this skill | Growing team planned |

---

## Scoring Guide

| Score | Meaning |
|-------|---------|
| 5 | Excellent — best-in-class for this criterion |
| 4 | Good — strong choice, minor limitations |
| 3 | Adequate — meets needs, some trade-offs |
| 2 | Weak — significant limitations |
| 1 | Poor — major concerns |

**Weighted score** = Weight × Score

---

## Rules

- At least 2 alternatives considered for each technology decision
- Weight must reflect project priorities (from quality attributes and constraints)
- Total weight across criteria should sum to a reasonable range (15-25)
- Document why the winning option was chosen, not just that it scored highest
- If scores are close (within 10%), note the tie-breaking factor
