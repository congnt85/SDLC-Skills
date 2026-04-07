# ADR Output Template

This is the expected structure for `adr-{NNN}-{slug}-draft.md` output. Follow this exactly.

---

```markdown
# ADR-{NNN}: {Title in Imperative Form}

> **Date**: {YYYY-MM-DD}
> **Status**: Proposed | Accepted | Rejected | Deprecated | Superseded
> **Deciders**: {who is involved in this decision}
> **Author**: AI-Generated
> **Supersedes**: ADR-{NNN} (if applicable, otherwise omit)
> **Superseded by**: ADR-{NNN} (if applicable, otherwise omit)

{If refine mode, include Change Log here}

---

## Context

{What is the issue that motivates this decision? Be specific — reference the exact
problem, not a generic category. Describe the forces at play: business drivers,
technical constraints, quality requirements, and risks.}

**Requirements Trace**:
- {QA-xxx}: {quality attribute driving this decision} — ✅/🔶/❓
- {CON-xxx}: {constraint influencing this decision} — ✅/🔶/❓
- {US-xxx}: {user story requiring this capability} — ✅/🔶/❓
- {RISK-xxx}: {risk this decision mitigates} — ✅/🔶/❓

---

## Decision

{What is the change being proposed or adopted? State it clearly in one sentence.}

**We will {action} {chosen option} because {primary rationale}.** — ✅/🔶/❓

{Expand on the decision with 1-2 paragraphs of supporting detail if needed.}

---

## Alternatives Considered

### Option A: {Name} {CHOSEN}

{1-2 sentence description of this option}

| Pros | Cons |
|------|------|
| {pro 1} — ✅/🔶 | {con 1} — ✅/🔶 |
| {pro 2} — ✅/🔶 | {con 2} — ✅/🔶 |
| {pro 3} — ✅/🔶 | {con 3} — ✅/🔶 |

### Option B: {Name} {REJECTED}

{1-2 sentence description of this option}

| Pros | Cons |
|------|------|
| {pro 1} — ✅/🔶 | {con 1} — ✅/🔶 |
| {pro 2} — ✅/🔶 | {con 2} — ✅/🔶 |

### Option C: {Name} {REJECTED}

{1-2 sentence description of this option}

| Pros | Cons |
|------|------|
| {pro 1} — ✅/🔶 | {con 1} — ✅/🔶 |
| {pro 2} — ✅/🔶 | {con 2} — ✅/🔶 |

**Decision Rationale**: {Why Option A was chosen over B and C. What was the tie-breaking
factor? Reference specific requirements (QA-xxx, CON-xxx) that tipped the scale.}

---

## Consequences

### Positive
- {What becomes easier, better, or de-risked} — ✅/🔶
- {What capability is enabled} — ✅/🔶
- {What risk is mitigated} — ✅/🔶

### Negative
- {What becomes harder or constrained} — ✅/🔶
- {What new risk is introduced} — ✅/🔶
- {What cost increases} — ✅/🔶

### Neutral
- {What changes but is neither clearly positive nor negative} — ✅/🔶

---

## Compliance

| Aspect | Impact | Notes |
|--------|--------|-------|
| Security | {positive/negative/neutral} | {specific details} |
| Performance | {positive/negative/neutral} | {specific details} |
| Cost | {positive/negative/neutral} | {specific details, include estimates if possible} |
| Compliance/Legal | {positive/negative/neutral} | {specific details} |

---

## Related Decisions

| ADR | Relationship | Notes |
|-----|-------------|-------|
| ADR-{NNN} | {Depends on / Conflicts with / Supersedes / Related to} | {brief explanation} |

{If no related ADRs exist yet, note: "No related ADRs at this time."}

---

## Q&A Log

| ID | Question | Priority | Answer | Status |
|----|----------|----------|--------|--------|
| Q-001 | {open question about this decision} | HIGH/MED/LOW | {answer if known} | Open/Resolved |
| Q-002 | {another question} | HIGH/MED/LOW | {answer if known} | Open/Resolved |

---

## Readiness Assessment

| Metric | Count |
|--------|-------|
| ✅ CONFIRMED | {N} |
| 🔶 ASSUMED | {N} |
| ❓ UNCLEAR | {N} |
| **Readiness** | {percentage}% CONFIRMED |

**Verdict**: {READY — >=70% confirmed / CONDITIONAL — 50-69% / NOT READY — <50%}

{In refine mode, include comparison with previous version:
"Previous: X% → Current: Y% (+Z%)"}

---

## Approval

| Role | Name | Decision | Date |
|------|------|----------|------|
| Technical Lead | | Pending | |
| Architect | | Pending | |
```

---

## Final Output Path

| Mode | File Pattern | Example |
|------|-------------|---------|
| Create | `draft/adr-{NNN}-{slug}-draft.md` | `draft/adr-001-adopt-modular-monolith-draft.md` |
| Refine | `draft/adr-{NNN}-{slug}-draft.md` (update in place) | `draft/adr-001-adopt-modular-monolith-draft.md` |
| Promoted | `design/final/adr/adr-{NNN}-{slug}-final.md` | `design/final/adr/adr-001-adopt-modular-monolith-final.md` |
