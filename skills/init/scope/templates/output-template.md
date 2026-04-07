# Scope Output Template

This is the expected structure for `scope-draft.md` output. Follow this exactly.

---

```markdown
# Project Scope: {Project Name}

> **Project**: {Project Name}
> **Version**: {1.0}
> **Date Created**: {YYYY-MM-DD}
> **Last Updated**: {YYYY-MM-DD}
> **Status**: Draft
> **Author**: AI-Generated
> **Source**: Expands scope section from `charter-final.md`

{If refine mode, include Change Log here}

---

## 1. Project Boundaries

{ASCII boundary diagram showing in-scope and out-of-scope items}

---

## 2. Feature Inventory

| ID | Feature | Description | Priority | Complexity | Dependencies | Confidence |
|----|---------|-------------|----------|-----------|-------------|------------|

### Feature Breakdown (for M/L/XL features)

#### SCP-{NNN}: {Feature Name}

| Sub-feature | Description | Priority | Confidence |
|-------------|-------------|----------|------------|

{Repeat for each decomposed feature}

---

## 3. User Roles / Personas

### Persona: {Name} ({Role})

| Field | Description |
|-------|-------------|
| **Role** | {role} |
| **Goals** | {top 3} |
| **Pain Points** | {top 3} |
| **Technical Proficiency** | Low / Medium / High |
| **Usage Frequency** | Daily / Weekly / Occasional |
| **Estimated Volume** | {count} |
| **Key Scenarios** | {top 3-5} |
| **Primary / Secondary** | {type} |
| **Confidence** | {marker} |

{Repeat for each persona}

### Persona-to-Feature Map

| Feature | {Persona 1} | {Persona 2} | ... |
|---------|------------|------------|-----|

---

## 4. System Context

### External Systems & Integrations

| ID | External System | Direction | Data Exchanged | Purpose | Confidence |
|----|----------------|-----------|---------------|---------|------------|

### System Context Diagram

{Mermaid C4Context diagram}

---

## 5. Quality Attributes (Non-Functional Requirements)

| ID | Attribute | Requirement | Measurement | Priority | Confidence |
|----|-----------|------------|-------------|----------|------------|

---

## 6. Scope Change Control

### Change Request Process
{Standard 5-step process}

### Change Request Template
{Standard template}

---

## Q&A Log

### Pending (waiting)

#### Q-{NNN} (related: {item IDs})
- **Impact**: HIGH / MEDIUM / LOW
- **Question**: {specific question}
- **Context**: {why this matters}
- **Answer**:
- **Status**: Pending

### Answered -- refine mode only
{Previously answered Q&A entries}

---

## Readiness Assessment

| Metric | Value |
|--------|-------|
| Total items | {N} |
| CONFIRMED | {X} ({pct}%) |
| ASSUMED | {Y} ({pct}%) |
| UNCLEAR | {Z} ({pct}%) |
| Q&A Pending | {P} (HIGH: {H}, MEDIUM: {M}, LOW: {L}) |

**Verdict**: {Ready / Partially Ready / Not Ready}
**Reasoning**: {1-2 sentences}

{If refine mode:}
**Comparison**: CONFIRMED {prev}% -> {current}% ({+/-}%), {N} Q&A resolved

---

{If refine mode, include Diff Summary here}

---

## Approval

| Role | Name | Date | Status |
|------|------|------|--------|
| Project Sponsor | | | Pending |
| Product Owner | | | Pending |
```
