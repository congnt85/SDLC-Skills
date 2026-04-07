# Quality Scorecard Template

Standard template for evaluating artifact quality during refine mode.

---

## Template

```markdown
## Quality Scorecard

| Dimension | Score (1-5) | Notes |
|-----------|------------|-------|
| Completeness | {1-5} | {Are all expected sections present and populated?} |
| Clarity | {1-5} | {Is the content unambiguous and actionable?} |
| Consistency | {1-5} | {Do cross-references match? Are terms used consistently?} |
| Quantification | {1-5} | {Are metrics specific and measurable, not vague?} |
| Traceability | {1-5} | {Can every item be traced to a source?} |
| **Average** | **{avg}** | |

### Issues Found

| # | Dimension | Section | Issue | Severity |
|---|-----------|---------|-------|----------|
| 1 | {dimension} | {section} | {specific issue} | {HIGH/MED/LOW} |

### Recommendations

- {Actionable recommendation 1}
- {Actionable recommendation 2}
```

## Scoring Guide

| Score | Meaning |
|-------|---------|
| 1 | Critical gaps — section missing or mostly empty |
| 2 | Major issues — present but vague, inconsistent, or incomplete |
| 3 | Acceptable — covers the basics but lacks depth or precision |
| 4 | Good — thorough, specific, minor improvements possible |
| 5 | Excellent — comprehensive, quantified, consistent, traceable |
