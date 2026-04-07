# Tech Stack Output Template

This is the expected structure for `tech-stack-draft.md` output. Follow this exactly.

---

```markdown
# Technology Stack Selection — {Project Name}

> **Project**: {Project Name}
> **Version**: draft | v{N}
> **Date Created**: {YYYY-MM-DD}
> **Last Updated**: {YYYY-MM-DD}
> **Status**: Draft | Under Review | Approved
> **Author**: AI-Generated
> **Source**: Derived from `scope-final.md` and `charter-final.md`

{If refine mode, include Change Log here}

---

## 1. Stack Summary

| Category | Selected | Version | License | Rationale | Confidence |
|----------|----------|---------|---------|-----------|------------|
| Backend Language | {tech} | {ver} | {license} | {1-line rationale} | {marker} |
| Backend Framework | {tech} | {ver} | {license} | {1-line} | {marker} |
| Frontend Framework | {tech} | {ver} | {license} | {1-line} | {marker} |
| Database (Primary) | {tech} | {ver} | {license} | {1-line} | {marker} |
| Database (Cache) | {tech} | {ver} | {license} | {1-line} | {marker} |
| Message Queue | {tech} | {ver} | {license/pricing} | {1-line} | {marker} |
| Cloud/Hosting | {tech} | — | {pricing model} | {1-line} | {marker} |
| CI/CD | {tech} | — | {pricing model} | {1-line} | {marker} |
| Monitoring | {tech} | {ver} | {pricing model} | {1-line} | {marker} |
| Authentication | {tech/approach} | — | {pricing model} | {1-line} | {marker} |
| {Additional categories as needed} | | | | | |

**MVP Stack Note**: {If MVP differs from full stack, note which rows are [MVP] vs [FUTURE]}

---

## 2. Decision Matrices

### DM-001: {Category} Selection

**Decision**: {chosen technology} ✅

| Criterion | Weight | {Option A} | {Option B} | {Option C} |
|-----------|--------|-----------|-----------|-----------|
| {criterion 1} ({QA/CON ref}) | {1-5} | {1-5} ({weighted}) | {1-5} ({weighted}) | {1-5} ({weighted}) |
| {criterion 2} ({QA/CON ref}) | {1-5} | {1-5} ({weighted}) | {1-5} ({weighted}) | {1-5} ({weighted}) |
| {criterion 3} ({QA/CON ref}) | {1-5} | {1-5} ({weighted}) | {1-5} ({weighted}) | {1-5} ({weighted}) |
| {criterion 4} ({QA/CON ref}) | {1-5} | {1-5} ({weighted}) | {1-5} ({weighted}) | {1-5} ({weighted}) |
| {criterion 5} ({QA/CON ref}) | {1-5} | {1-5} ({weighted}) | {1-5} ({weighted}) | {1-5} ({weighted}) |
| {criterion 6} ({QA/CON ref}) | {1-5} | {1-5} ({weighted}) | {1-5} ({weighted}) | {1-5} ({weighted}) |
| **Weighted Total** | | **{total}** | **{total}** | **{total}** |

**Rationale**: {2-3 sentences explaining the decision, tie-breaking factors if scores are close}
**Confidence**: {marker + annotation}

### DM-002: {Category} Selection

{Repeat same format}

{Continue for all categories...}

---

## 3. Compatibility Matrix

| | {Tech A} | {Tech B} | {Tech C} | {Tech D} | {Tech E} |
|---|---|---|---|---|---|
| **{Tech A}** | — | {✅/⚠️/❌} | {✅/⚠️/❌} | {✅/⚠️/❌} | {✅/⚠️/❌} |
| **{Tech B}** | {✅/⚠️/❌} | — | {✅/⚠️/❌} | {✅/⚠️/❌} | {✅/⚠️/❌} |
| **{Tech C}** | {✅/⚠️/❌} | {✅/⚠️/❌} | — | {✅/⚠️/❌} | {✅/⚠️/❌} |
| **{Tech D}** | {✅/⚠️/❌} | {✅/⚠️/❌} | {✅/⚠️/❌} | — | {✅/⚠️/❌} |
| **{Tech E}** | {✅/⚠️/❌} | {✅/⚠️/❌} | {✅/⚠️/❌} | {✅/⚠️/❌} | — |

**Compatibility Notes**:
- {note about any ⚠️ or ❌ items and their mitigations}

---

## 4. Risk Assessment

| ID | Risk | Impact | Likelihood | Mitigation | Confidence |
|----|------|--------|------------|------------|------------|
| TSK-RISK-001 | {risk description} | High/Med/Low | High/Med/Low | {mitigation plan} | {marker} |
| TSK-RISK-002 | {risk} | {impact} | {likelihood} | {mitigation} | {marker} |
| ... | | | | | |

---

## 5. Version & Upgrade Strategy

| Technology | Current Version | LTS Until | Upgrade Cadence | Notes |
|-----------|----------------|-----------|-----------------|-------|
| {tech} | {ver} | {date or N/A} | {quarterly/semesterly/annually} | {notes} |
| ... | | | | |

**Dependency Management**: {tooling and approach — e.g., npm with package-lock.json, Dependabot for automated PRs}
**Security Patching**: {policy — e.g., critical CVEs patched within 48 hours, high within 1 week}

---

## 6. Budget Impact

| Category | Technology | Cost Model | Estimated Monthly | Estimated Annual |
|----------|-----------|------------|-------------------|-----------------|
| {category} | {tech} | {free/per-seat/usage-based} | ${amount} | ${amount} |
| ... | | | | |
| **Total** | | | **${monthly}** | **${annual}** |

**Notes**:
- {assumptions about usage levels, team size, etc.}

---

## 7. Q&A Log

### Pending

#### Q-{NNN} (related: DM-{NNN} or TSK-RISK-{NNN})
- **Impact**: HIGH / MEDIUM / LOW
- **Question**: {specific question}
- **Context**: {why this matters for the tech stack}
- **Answer**:
- **Status**: Pending

### Answered -- refine mode only

---

## 8. Readiness Assessment

| Metric | Value |
|--------|-------|
| Total items | {N} |
| ✅ CONFIRMED | {X} ({pct}%) |
| 🔶 ASSUMED | {Y} ({pct}%) |
| ❓ UNCLEAR | {Z} ({pct}%) |
| Q&A Pending | {P} (HIGH: {H}, MEDIUM: {M}, LOW: {L}) |
| Q&A Answered | {A} |

**Verdict**: {Ready / Partially Ready / Not Ready}
**Reasoning**: {1-2 sentences}

{If refine mode:}
**Comparison**: CONFIRMED {prev}% -> {current}% ({+/-}%), {N} Q&A resolved

---

{If refine mode, include Diff Summary here}

---

## 9. Approval

| Role | Name | Date | Status |
|------|------|------|--------|
| Technical Lead | | | Pending |
| Architect | | | Pending |
```
