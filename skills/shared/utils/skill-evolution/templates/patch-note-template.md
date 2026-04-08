# Patch Note Template

Standard template for documenting skill evolution changes after apply mode.

---

## Template

```markdown
# Skill Evolution Patch Note

> **Target Skill**: {phase}/{skill}
> **Version**: {old_version} → {new_version}
> **Evolution Date**: {YYYY-MM-DD HH:MM:SS}
> **Analysis ID**: {timestamp}
> **Analysis Source**: `skills/{phase}/{skill}/evolution/{timestamp}/analysis.md`

---

## Changes Applied

### {N}. {Change title} (PC-{N})

- **File**: `skills/{phase}/{skill}/{path}`
- **Section**: {section heading}
- **Type**: {Add / Modify / Remove}
- **Priority**: {HIGH / MEDIUM / LOW}
- **Scorecard impact**: {dimension} {before}/5 → {expected}/5

**Before:**
```
{Original text from the file. "N/A" for additions.}
```

**After:**
```
{New text written to the file. "N/A" for removals.}
```

{Repeat for each applied change}

---

## Changes Skipped

| PC# | Title | Priority | Reason |
|-----|-------|----------|--------|
| PC-{N} | {title} | {HIGH/MED/LOW} | {❌ REJECTED by user / DEFERRED / reason} |

{If no changes were skipped: "All proposed changes were applied."}

---

## Shared/Cross-Skill Issues (Flagged, Not Applied)

| # | Target | Issue |
|---|--------|-------|
| {N} | `{path}` | {description} |

{If none: "No shared or cross-skill issues identified."}

---

## Summary

| Metric | Value |
|--------|-------|
| Changes proposed | {N} |
| Changes applied | {N} |
| Changes skipped | {N} |
| Files modified | {list of file paths} |
| Version bump | {old} → {new} |
| Bump type | {Minor (rules/templates/knowledge) / Major (workflow)} |

---

## Evolution History

| # | Date | Version | Changes | Scorecard Avg |
|---|------|---------|---------|---------------|
| {previous entries from prior patch notes} |
| **Current** | {date} | {new_version} | {N applied} | {pre-evolution avg}/5 |
```

---

## Notes

- Before/after blocks must contain the exact text, not descriptions
- For additions, "Before" is "N/A"
- For removals, "After" is "N/A"
- Evolution history table accumulates across all evolutions of this skill
- Version bump type determines minor vs major increment
