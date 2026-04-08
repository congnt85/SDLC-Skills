# Scoring Rules

Rules governing the `--score` mode output across all skills.

---

### SCR-01: Evidence-Based Scoring

Every dimension score MUST cite at least 2 specific evidence items from the artifact. No score without evidence.

**Valid**: "Completeness: 3/5 — Section 'Dependency Map' is a stub with only 2 sentences. Table in Section 2.1 has 3 empty cells."
**Invalid**: "Completeness: 3/5 — Could be more complete."

### SCR-02: Full Dimension Coverage

All 5 dimensions MUST be scored. No dimension may be skipped or marked "N/A".

### SCR-03: Integer Scores Only

Scores MUST be integers from 1 to 5. No half-points, decimals, or ranges.

### SCR-04: Issue Traceability

Every issue in the Issues Found table MUST link to exactly one scorecard dimension and name a specific section in the artifact.

### SCR-05: Severity Assignment

Every issue MUST have exactly one severity:
- **HIGH**: Blocks the artifact from being usable in the next phase
- **MED**: Degrades quality but doesn't block progression
- **LOW**: Polish-level improvement

### SCR-06: Actionable Recommendations

Every recommendation MUST be actionable — specifying what to change, where to change it, and the expected result.

**Valid**: "Replace 'high availability' in Section 4.2 SLA table with a specific numeric target (e.g., 99.9% uptime measured monthly)"
**Invalid**: "Improve quantification"

### SCR-07: Recommendation Limit

Output between 3 and 7 recommendations. Fewer than 3 suggests insufficient analysis. More than 7 overwhelms the user.

### SCR-08: Context-Aware Scoring

Scoring MUST consider the target skill's specific rules and templates, not just generic quality. Read the skill's `rules/output-rules.md` and `templates/output-template.md` to calibrate expectations.

### SCR-09: Scorecard Isolation

The `--score` mode ONLY produces a scoreboard. It does NOT modify the artifact, suggest rewrites, or generate improved content. Artifact improvement belongs to `--refine` mode. Skill improvement belongs to `/skill-evolution`.

### SCR-10: Skill Rules Compliance Check

The output MUST include a section checking compliance with the skill's specific rules (rule IDs from `rules/output-rules.md`). Each rule is marked:
- ✅ PASS — artifact fully complies
- ❌ FAIL — artifact clearly violates
- ⚠️ PARTIAL — artifact partially complies (explain what's missing)
