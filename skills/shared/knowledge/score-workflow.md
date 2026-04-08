# Score Workflow

Standard workflow for `--score` mode across all skills. Referenced by each SKILL.md instead of duplicating inline.

---

## Prerequisites

Read these files before scoring:

1. `skills/shared/knowledge/scoring-guide.md` — scoring methodology and dimension criteria
2. `skills/shared/rules/scoring-rules.md` — scoring output rules (SCR-01 through SCR-10)
3. `skills/shared/templates/scoreboard-output-template.md` — scoreboard format

Also read the target skill's own resources:

4. `{skill}/rules/output-rules.md` — skill-specific quality constraints
5. `{skill}/templates/output-template.md` — expected output structure

---

## Resolve Artifact

```
1. User specified a path?                                     → Read it → DONE
2. Exists in sdlc/{phase}/final/{artifact}-final.md?          → Read it → DONE
3. Exists as sdlc/{phase}/draft/{artifact}-v{N}.md (latest N)?→ Read it → DONE
4. Exists as sdlc/{phase}/draft/{artifact}-draft.md?          → Read it → DONE
5. Not found? → Ask: "Provide the path to the artifact to score."
```

---

## Score Steps

### 1. Read Context

Read the target skill's own `templates/output-template.md` and `rules/output-rules.md` to understand expected structure and quality constraints.

### 2. Score Each Dimension

Evaluate the artifact against all 5 quality dimensions (Completeness, Clarity, Consistency, Quantification, Traceability):
- For each dimension, cite at least 2 specific evidence items from the artifact
- Score using criteria from `skills/shared/knowledge/scoring-guide.md`
- Record issues found during scoring

### 3. Check Skill Rules Compliance

For each rule in the target skill's `rules/output-rules.md`:
- ✅ PASS — artifact fully complies
- ❌ FAIL — artifact clearly violates
- ⚠️ PARTIAL — artifact partially complies (explain what's missing)

### 4. Compile Issues

Gather all issues from dimension scoring and rules compliance:
- Assign severity: HIGH / MED / LOW
- Link each to its dimension and artifact section

### 5. Generate Recommendations

3-7 actionable recommendations:
- HIGH severity issues first, then lowest-scoring dimensions
- Each specifies: what to change, where, expected result

### 6. Calculate Summary

Average score, lowest/highest dimensions, overall verdict:
- 🟢 Strong (avg ≥ 4.0)
- 🟡 Adequate (avg 3.0-3.9)
- 🔴 Needs Work (avg < 3.0)

---

## Validate Score Output

Check against scoring rules:
- All 5 dimensions scored with evidence (SCR-01, SCR-02)
- Integer scores 1-5 (SCR-03)
- Issues linked to dimensions and sections (SCR-04, SCR-05)
- Recommendations are actionable, 3-7 count (SCR-06, SCR-07)
- Scoring used this skill's own rules/templates as context (SCR-08)
- Score mode only produces scoreboard, no artifact modification (SCR-09)
- Rules compliance section present (SCR-10)

---

## Output

Write to `sdlc/{phase}/draft/{artifact}-scoreboard.md`

Tell the user:
> **Scoreboard complete!**
> - Output: `sdlc/{phase}/draft/{artifact}-scoreboard.md`
> - Average: {avg}/5 — {verdict}
> - Lowest: {dimension} ({score}/5)
> - Issues: {N} (HIGH: {H}, MED: {M}, LOW: {L})
>
> **Next steps:**
> - Run `/{command} --refine` to address issues
> - Or run `/skill-evolution --analyze {phase}/{skill}` to improve the skill definition itself
