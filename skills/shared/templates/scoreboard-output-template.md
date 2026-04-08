# Scoreboard Output Template

Standard template for `--score` mode output across all skills.

---

## Template

```markdown
# Quality Scoreboard

> **Artifact**: `{artifact file path}`
> **Target Skill**: {phase}/{skill} (v{version})
> **Evaluation Date**: {YYYY-MM-DD HH:MM:SS}
> **Artifact Version**: {draft / v{N} / final}

---

## Quality Scorecard

| Dimension | Score (1-5) | Notes |
|-----------|------------|-------|
| Completeness | {1-5} | {Evidence-based notes — cite specific sections} |
| Clarity | {1-5} | {Evidence-based notes — cite specific sections} |
| Consistency | {1-5} | {Evidence-based notes — cite specific sections} |
| Quantification | {1-5} | {Evidence-based notes — cite specific sections} |
| Traceability | {1-5} | {Evidence-based notes — cite specific sections} |
| **Average** | **{avg}** | |

---

## Dimension Details

### Completeness ({score}/5)

**Evidence:**
- {Specific observation 1 with section reference}
- {Specific observation 2 with section reference}

**Missing or incomplete:**
- {Section or content that is expected but missing/shallow, or "None" if score is 5}

### Clarity ({score}/5)

**Evidence:**
- {Specific observation 1 with section reference}
- {Specific observation 2 with section reference}

**Ambiguity found:**
- {Specific vague or unclear items with location, or "None"}

### Consistency ({score}/5)

**Evidence:**
- {Specific observation 1 with section reference}
- {Specific observation 2 with section reference}

**Inconsistencies found:**
- {Specific cross-reference or terminology issues, or "None"}

### Quantification ({score}/5)

**Evidence:**
- {Specific observation 1 with section reference}
- {Specific observation 2 with section reference}

**Vague metrics:**
- {Items that should have numbers but don't, or "None"}

### Traceability ({score}/5)

**Evidence:**
- {Specific observation 1 with section reference}
- {Specific observation 2 with section reference}

**Traceability gaps:**
- {Items without source references or broken trace chains, or "None"}

---

## Skill Rules Compliance

| Rule ID | Rule Description | Status | Notes |
|---------|-----------------|--------|-------|
| {rule-id} | {brief description} | {✅ PASS / ❌ FAIL / ⚠️ PARTIAL} | {details if FAIL or PARTIAL} |

**Compliance rate**: {passed}/{total} rules ({percentage}%)

---

## Issues Found

| # | Dimension | Section | Issue | Severity |
|---|-----------|---------|-------|----------|
| 1 | {dimension} | {section in artifact} | {specific issue description} | {HIGH/MED/LOW} |

**Summary**: {total} issues (HIGH: {N}, MED: {N}, LOW: {N})

---

## Recommendations

{Ordered by priority — HIGH severity issues first, then lowest-scoring dimensions}

1. **[{severity}]** {Actionable recommendation with specific section and expected outcome}
2. **[{severity}]** {Actionable recommendation}
3. **[{severity}]** {Actionable recommendation}

---

## Scoreboard Summary

| Metric | Value |
|--------|-------|
| Average score | {avg}/5 |
| Lowest dimension | {dimension} ({score}/5) |
| Highest dimension | {dimension} ({score}/5) |
| Total issues | {N} (HIGH: {H}, MED: {M}, LOW: {L}) |
| Rules compliance | {passed}/{total} ({percentage}%) |
| Recommendations | {N} |

**Overall Verdict**: {🟢 Strong (avg ≥ 4.0) / 🟡 Adequate (avg 3.0-3.9) / 🔴 Needs Work (avg < 3.0)}
```
