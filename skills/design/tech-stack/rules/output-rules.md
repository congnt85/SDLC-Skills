# Output Rules -- design/tech-stack

Tech-stack-specific output constraints. These supplement the project-wide rules in `skills/shared/rules/` and phase rules in `design/shared/rules/`.

---

## Decision Matrix Rules

### TSK-01: Decision Matrix Required
Every technology category MUST have a decision matrix with >= 2 alternatives scored.
If a technology is mandated by a constraint (e.g., "must use PostgreSQL"), document the constraint reference instead of a matrix but still document the version and license.

### TSK-02: Criteria Weight Traceability
Criteria weights MUST trace to quality attributes (QA-xxx) or constraints (CON-xxx).
Each criterion in a decision matrix must include a parenthetical source reference:
`Performance (QA-001: < 2s load time) | Weight: 5`

### TSK-03: Version Specification
Every selected technology MUST specify an exact version or version range.

| Acceptable | Not acceptable |
|-----------|----------------|
| `TypeScript 5.4` | `TypeScript` |
| `PostgreSQL 16.x` | `PostgreSQL (latest)` |
| `React ^18.2.0` | `React 18+` |

### TSK-04: License Specification
License type MUST be specified for every technology.
Use SPDX identifiers: MIT, Apache-2.0, BSD-3-Clause, GPL-3.0, etc.
For commercial/SaaS products, specify the pricing model (free tier, per-seat, usage-based).

### TSK-05: Security Assessment
Every technology MUST list its security assessment:
- Number of CVEs in the last 3 years (or "None known")
- Last major vulnerability date and severity (or "No major vulnerabilities")
- Security disclosure process (has SECURITY.md or equivalent)

### TSK-06: Compatibility Matrix Required
A compatibility matrix MUST verify no conflicts between selected technologies.
Every pair of technologies that interact at runtime MUST have a compatibility entry.
Any entry marked ⚠️ MUST have a mitigation note.

### TSK-07: Integration Coverage
The stack MUST address all integrations from scope (INT-xxx).
For each INT-xxx, either:
- A selected technology directly satisfies it, OR
- A note explains how the stack will support it

### TSK-08: Section Order
Tech stack output MUST follow this section order:
1. Stack Summary
2. Decision Matrices
3. Compatibility Matrix
4. Risk Assessment
5. Version & Upgrade Strategy
6. Budget Impact
7. Q&A Log
8. Readiness Assessment
9. Approval

Do not add, remove, or reorder sections.

### TSK-09: ID Prefixes

| Section | Prefix | Example |
|---------|--------|---------|
| Decision matrices | DM- | DM-001, DM-002 |
| Risks | TSK-RISK- | TSK-RISK-001 |
| Q&A entries | Q- | Q-001 |

---

## Content Rules

### TSK-10: Confidence Markers on Decisions
Every technology decision MUST have a confidence marker:
- ✅ CONFIRMED — Technology mandated by constraint or confirmed by stakeholder
- 🔶 ASSUMED — Technology selected based on analysis but not stakeholder-confirmed
- ❓ UNCLEAR — Multiple viable options, needs stakeholder input to decide

### TSK-11: Quality Scorecard in Refine Mode
In refine mode, BEFORE applying changes, generate a Quality Scorecard covering:
- Matrix completeness: Do all categories have decision matrices?
- Weight traceability: Do criteria weights reference QA-xxx / CON-xxx?
- Version coverage: Are all versions specified?
- License coverage: Are all licenses documented?
- Security coverage: Are all security assessments present?
- Compatibility coverage: Is the compatibility matrix complete?
- Budget coverage: Are costs estimated?

Present this scorecard to the user before asking what to improve.

### TSK-12: Team Expertise Risk
If the team has zero experience with a selected technology, it MUST be flagged as a risk (TSK-RISK-xxx) with a mitigation plan including:
- Training timeline (hours/days)
- Training resources (courses, docs, workshops)
- Fallback technology if learning curve is unacceptable

### TSK-13: Budget Impact Required
Budget impact MUST be calculated for every technology:
- Open-source: $0 licensing, but note infrastructure cost
- SaaS/commercial: Monthly and annual cost estimates
- Cloud services: Estimated usage-based cost for MVP scale
- Total estimated annual cost MUST be provided

### TSK-14: MVP Stack Identification
If the full stack differs from MVP needs, the MVP stack MUST be identified separately:
- Mark technologies as `[MVP]` or `[FUTURE]`
- MVP stack should minimize cost, complexity, and learning curve
- Note which technologies will be added post-MVP and why

---

## Refine Mode Rules

### TSK-15: TBD Reduction Target
Each refine round should aim to reduce TBD/UNCLEAR count by at least 30%.
If no TBDs were resolved, flag this in the Diff Summary.
