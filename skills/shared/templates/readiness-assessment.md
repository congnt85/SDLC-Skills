# Readiness Assessment Template

Standard template for the Readiness Assessment section at the end of every artifact.

---

## Template

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

**Reasoning**: {1-2 sentences explaining the verdict — what's strong, what's blocking}

{If refine mode, include comparison:}
**Comparison with v{N-1}**: CONFIRMED {prev}% → {current}% ({+/-X}%), {N} Q&A resolved this round
```

## Verdict Logic

```
IF confirmed_pct >= 90 AND unclear_high_count == 0:
    verdict = "✅ Ready"
ELIF confirmed_pct >= 70 AND unclear_high_count == 0:
    verdict = "⚠️ Partially Ready"
ELSE:
    verdict = "❌ Not Ready"
```
