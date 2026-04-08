# Evolution Analysis Report Template

Standard template for skill evolution analysis output.

---

## Template

```markdown
# Skill Evolution Analysis

> **Target Skill**: {phase}/{skill} (v{current_version})
> **Analysis Date**: {YYYY-MM-DD HH:MM:SS}
> **Analysis ID**: {yyyy-mm-dd-hh-mm-ss}
> **Trigger**: Quality Scorecard from `{artifact_file_name}`

---

## 1. Scorecard Summary

### Original Scorecard

{Paste the complete quality scorecard from the refine output}

### Gap Analysis

| Dimension | Score | Target | Gap | Action Required |
|-----------|-------|--------|-----|-----------------|
| Completeness | {N}/5 | 4 | {gap or "—"} | {Yes/No} |
| Clarity | {N}/5 | 4 | {gap or "—"} | {Yes/No} |
| Consistency | {N}/5 | 4 | {gap or "—"} | {Yes/No} |
| Quantification | {N}/5 | 4 | {gap or "—"} | {Yes/No} |
| Traceability | {N}/5 | 4 | {gap or "—"} | {Yes/No} |
| **Average** | **{avg}/5** | **4** | **{gap}** | |

**Dimensions requiring evolution**: {list dimensions with score < 4}

---

## 2. Diff Analysis (Draft vs Final)

### 2.1 Summary Statistics

| Change Category | Count | Examples |
|----------------|-------|---------|
| Sections added | {N} | {brief list} |
| Sections removed | {N} | {brief list} |
| Sections restructured | {N} | {brief list} |
| Content additions | {N} | — |
| Content corrections | {N} | — |
| Content removals | {N} | — |
| Wording/clarity fixes | {N} | — |
| Quantification upgrades | {N} | — |
| Formatting changes | {N} | (not analyzed individually) |
| **Total substantive changes** | **{N}** | |

### 2.2 Detailed Changes

#### Change C-{N}: {Brief description}

- **Location**: {Section heading in the artifact}
- **Type**: {Addition / Correction / Removal / Restructure / Quantification / Wording}
- **Classification**: {Knowledge Gap / Template Gap / Rule Gap / Workflow Gap / Calibration Gap / Input Miss / Project-Specific}

**Draft version:**
> {What the skill produced (quote or summarize)}

**Final version:**
> {What the user changed it to (quote or summarize)}

**Why the user changed it**: {Analysis of the motivation behind this change}

{Repeat for each substantive change. Number sequentially: C-1, C-2, ...}

---

## 3. Root Cause Analysis

### RCA-{N}: {Root cause title}

- **Scorecard dimension(s)**: {which dimensions this affects}
- **Related changes**: C-{N}, C-{M}, ...
- **Skill layer**: {SKILL.md / knowledge / rules / templates / sample-output}
- **Specific file**: `skills/{phase}/{skill}/{path}`
- **Specific section**: {section heading or "N/A — new addition needed"}
- **Diagnosis**: {Why the skill definition caused this problem. Be specific about what's missing or wrong in the target file.}

{Repeat for each root cause. Number sequentially: RCA-1, RCA-2, ...}

---

## 4. Proposed Changes

### PC-{N}: {Proposed change title}

- **Priority**: {HIGH / MEDIUM / LOW}
- **Root cause**: RCA-{N}
- **Scorecard impact**: {dimension} {current}/5 → {expected}/5
- **Target file**: `skills/{phase}/{skill}/{path}`
- **Target section**: {section heading or "New section"}
- **Change type**: {Add / Modify / Remove}
- **Approval**: ⏳ PENDING

**Current content:**
```
{Existing text in the target file, or "N/A — new addition"}
```

**Proposed content:**
```
{Exact text to replace with or add. Must be copy-paste ready.}
```

**Rationale**: {1-2 sentences explaining why this change addresses the root cause and is generalizable (not project-specific)}

{Repeat for each proposed change. Number sequentially: PC-1, PC-2, ...}

### Project-Specific Observations

{List any changes from the diff analysis that are project-specific and NOT proposed as skill changes. Explain why each is project-specific.}

| # | Change | Reason Not Proposed |
|---|--------|-------------------|
| 1 | {description} | {why it's project-specific} |

### Shared/Cross-Skill Issues

{Flag any issues that belong to shared resources or other skills}

| # | Target | Issue | Recommendation |
|---|--------|-------|---------------|
| 1 | `{path}` | {description} | Manual review recommended |

---

## 5. Evolution Assessment

### Metrics

| Metric | Value |
|--------|-------|
| Scorecard average (current) | {N}/5 |
| Dimensions below target (< 4) | {N}/5 |
| Total draft→final changes analyzed | {N} |
| Changes classified as project-specific | {N} |
| Root causes identified | {N} |
| Proposed changes | {N} (HIGH: {H}, MEDIUM: {M}, LOW: {L}) |
| Estimated post-evolution average | {N}/5 |
| Shared/cross-skill issues flagged | {N} |

### Previous Evolutions

{If evolution history exists for this skill:}

| Evolution | Date | Version | Avg Score Before | Changes Applied |
|-----------|------|---------|-----------------|----------------|
| {timestamp} | {date} | {version} | {score} | {N} |

{If no previous evolutions: "This is the first evolution for this skill."}

### Next Steps

1. Review each proposed change (PC-1 through PC-{N}) above
2. Mark each as ✅ APPROVED or ❌ REJECTED by editing the **Approval** field
3. Run `/skill-evolution --apply {phase}/{skill}` to apply approved changes
```

---

## Notes

- All proposed changes must have copy-paste-ready content (not descriptions of what to write)
- The "Current content" block must match the actual file content exactly
- Project-specific observations help the user understand why some changes were not proposed
- Shared/cross-skill issues ensure nothing is lost even though this skill cannot fix them
