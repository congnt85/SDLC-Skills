# Skill Evolution Output Rules

Rules governing the quality of evolution analysis reports and patch notes.

---

## Analysis Report Rules

### EVO-01: File-Level Specificity

Every proposed change MUST name the exact file path (relative to `skills/`) and section heading to modify.

**Valid**: `skills/req/epic/templates/output-template.md` → Section "## Epic Card Format"
**Invalid**: "Update the epic template"

### EVO-02: Scorecard Linkage

Every proposed change MUST reference at least one scorecard dimension it addresses and the expected score improvement.

**Valid**: "Addresses Completeness (currently 2 → expected 4)"
**Invalid**: "This will improve the output"

### EVO-03: Comprehensive Diff Coverage

The diff analysis MUST account for every substantive change between draft and final versions. Formatting-only changes (whitespace, line breaks, markdown syntax) MAY be grouped as "{N} formatting changes" without individual analysis.

A "substantive change" is any modification that alters meaning, adds/removes information, or changes document structure.

### EVO-04: Root Cause Attribution

Every proposed change MUST attribute the root cause to exactly one skill layer:
- `SKILL.md` (workflow)
- `knowledge/*.md` (domain expertise)
- `rules/output-rules.md` (validation)
- `templates/output-template.md` (structure)
- `templates/sample-output.md` (calibration)

"Unknown cause" or "multiple causes" is not acceptable. If a change addresses multiple layers, create separate proposed changes for each layer.

### EVO-05: Priority Assignment

Every proposed change MUST have exactly one priority level:
- **HIGH**: Would prevent a score of 1-2 on any dimension, or addresses a missing section/major structural issue
- **MEDIUM**: Would improve a score of 3 to 4+, or addresses recurring content quality issues
- **LOW**: Would improve a score of 4 to 5, polish-level improvement

### EVO-06: No Over-Fitting

Proposed changes MUST be generalizable across different projects. If a change only applies to the specific project that triggered the analysis, it MUST be flagged as "PROJECT-SPECIFIC" and MUST NOT be included in the proposed changes list.

**Test**: "Would this change help the skill produce better output for a completely different project?" If no → project-specific.

### EVO-07: Backward Compatibility

Proposed changes MUST NOT invalidate existing valid outputs. Specifically:
- Adding a new required template section → mark as "[Recommended]" for one version before making required
- Removing a rule → only if the rule is proven counterproductive
- Changing rule criteria → document the change in patch note

---

## Apply Mode Rules

### EVO-08: Approval Required

The `--apply` mode MUST only execute changes that appear in an `analysis.md` file. No ad-hoc changes outside the analysis scope.

If the user wants changes not in the analysis, they should either:
1. Re-run `--analyze` with updated input
2. Make manual changes themselves

### EVO-09: Atomic Changes

Each proposed change (PC-N) is applied or skipped independently. Partial application is valid. The apply mode MUST handle each PC-N as a standalone unit.

### EVO-10: Version Bump Required

After any successful apply, the target skill's `SKILL.md` version field MUST be bumped:
- **Minor** (e.g., 1.0 → 1.1): Changes to rules, templates, knowledge, or sample output
- **Major** (e.g., 1.0 → 2.0): Changes to SKILL.md workflow steps

### EVO-11: Patch Note Completeness

`patch-note.md` MUST include:
- Every file that was modified (with path)
- The before and after content for each change
- Changes that were proposed but skipped (with reason)
- Summary metrics (proposed / applied / skipped / files modified)
- Version change (old → new)

---

## General Rules

### EVO-12: Shared Resource Boundary

Evolution MUST NOT modify files in `skills/shared/` or `skills/<phase>/shared/`. If analysis identifies issues traceable to shared resources, flag them as:

> **Shared Resource Issue**: `{path}` — {description}. Manual review recommended.

### EVO-13: Evolution History Preservation

Every evolution run MUST create its artifacts in a new timestamp directory: `skills/<phase>/<skill>/evolution/<yyyy-mm-dd-hh-mm-ss>/`

Previous evolution directories MUST NOT be modified or deleted.

### EVO-14: Single Skill Scope

Each evolution run targets exactly one skill. Cross-skill evolution proposals MUST be flagged as out-of-scope:

> **Cross-Skill Issue**: Belongs to `<phase>/<skill>` — {description}.
