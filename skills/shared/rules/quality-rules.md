# Quality Rules

Rules applied to ALL skills across all SDLC phases.

---

## Confidence Marking

Every item in an output artifact MUST be marked with one of three confidence levels:

| Marker | Symbol | When to Use | Required Annotation |
|--------|--------|-------------|---------------------|
| CONFIRMED | ✅ | Source explicitly states this, or user confirmed | `Source: {where}` |
| ASSUMED | 🔶 | Not explicitly stated but reasonably inferred from context | `Reasoning: {why}` + `Q&A ref: Q-xxx` |
| UNCLEAR | ❓ | Insufficient information to determine | `Q&A ref: Q-xxx` + `Impact: HIGH/MEDIUM/LOW` |

### Rules

- CR-01: Every item MUST have exactly one confidence marker
- CR-02: CONFIRMED items MUST cite their source (document section, user statement, prior artifact)
- CR-03: ASSUMED items MUST include reasoning AND a Q&A entry for confirmation
- CR-04: UNCLEAR items MUST include a Q&A entry AND an impact assessment
- CR-05: Never fabricate information as CONFIRMED — if source doesn't explicitly state it, mark ASSUMED or UNCLEAR

---

## Q&A Log

Every output with ASSUMED or UNCLEAR items MUST include a Q&A Log section at the end.

### Q&A Entry Format

```markdown
### Q-{NNN} (related: {item IDs})
- **Impact**: {HIGH / MEDIUM / LOW}
- **Question**: {Specific, actionable question}
- **Context**: {Why this matters, what's missing}
- **Answer**: {Empty for create mode, filled for refine mode}
- **Status**: ⏳ Pending / ✅ Answered / 🔄 Need Clarification
```

### Rules

- QA-01: Questions MUST be specific enough for a stakeholder to answer directly
- QA-02: Sort questions by Impact: HIGH first
- QA-03: Every ASSUMED/UNCLEAR item MUST reference a Q-xxx entry
- QA-04: In refine mode, answered questions update related items and change their confidence level
- QA-05: Every output MUST have at least 1 Q&A entry — no input is ever perfectly complete

---

## Readiness Assessment

Every output MUST end with a Readiness Assessment section.

### Format

```markdown
## Readiness Assessment

| Metric | Value |
|--------|-------|
| Total items | {N} |
| ✅ CONFIRMED | {X} ({X/N × 100}%) |
| 🔶 ASSUMED | {Y} ({Y/N × 100}%) |
| ❓ UNCLEAR | {Z} ({Z/N × 100}%) |
| Q&A Pending | {P} (HIGH: {H}, MEDIUM: {M}, LOW: {L}) |
| Q&A Answered | {A} |

**Verdict**: {✅ Ready / ⚠️ Partially Ready / ❌ Not Ready}

**Reasoning**: {1-2 sentences explaining the verdict}
```

### Verdict Thresholds

| Verdict | Condition | Action |
|---------|-----------|--------|
| ✅ Ready | ≥90% CONFIRMED, no UNCLEAR with HIGH impact | Promote to `final/`, proceed to next skill |
| ⚠️ Partially Ready | 70-90% CONFIRMED, no blocking UNCLEARs | Can proceed with caution, refine remaining items |
| ❌ Not Ready | <70% CONFIRMED OR any UNCLEAR with HIGH impact | Must refine before proceeding |

---

## Refine Mode Rules

### RM-01: Never Rebuild from Scratch
Refine mode MUST use the existing draft as baseline. Only update items affected by user feedback.

### RM-02: Mark Changes
- Items changed: tag with `[UPDATED]` and brief description of what changed
- Items added: tag with `[NEW]`
- Items removed: tag with `[REMOVED — reason]`

### RM-03: Version Tracking
- Increment version number on each refine pass
- Include a Change Log section showing what changed in this version

### RM-04: Readiness Comparison
In refine mode, compare readiness with previous version:
- % CONFIRMED: {previous}% → {current}% ({+/-X}%)
- Q&A resolved this round: {N}

### RM-05: Preserve Confirmed Items
Items already marked CONFIRMED MUST NOT be changed unless user feedback explicitly contradicts them.

---

## Scope Rules (Universal)

### SR-01: Stay in Your Lane
Each skill has defined boundaries. Never produce output that belongs to another skill's domain.

### SR-02: Flag, Don't Block
If information is missing, mark it UNCLEAR and continue. Never stop the workflow because of missing data.

### SR-03: No Technical Decisions in Non-Technical Skills
Initiation and requirements skills MUST NOT make technology choices. Mark tech-related assumptions as ASSUMED with Q&A.

### SR-04: Traceability
Every item should be traceable — either to a source document, a user statement, or a Q&A answer.
