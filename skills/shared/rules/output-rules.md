# Output Rules

Rules governing how ALL skills produce and manage output files.

---

## File Management

### OUT-01: Write to `draft/` Only
Skills MUST write output to their own `draft/` folder. Never write directly to `final/`.

### OUT-02: User Promotes to `final/`
Only the user decides when an artifact is ready. The skill recommends via Readiness Assessment, but the user copies from `draft/` to `phase/final/`.

### OUT-03: Versioned Drafts
Each refine pass creates a new version in `draft/`:
- First creation: `{topic}-draft.md`
- Refine round 1: `{topic}-v2.md`
- Refine round 2: `{topic}-v3.md`
- Keep all versions — never overwrite previous drafts

### OUT-04: Copy Input for Traceability
When input is resolved from a user-specified path or a previous skill's `final/` folder, the skill MUST copy the file into its own `input/` folder before processing. This ensures each skill's `input/` is a complete snapshot of what it used.

---

## Input Resolution

### Priority Order (highest to lowest)

```
1. User-specified path     → read it, copy to own input/ → DONE
2. Own input/ folder       → read it → DONE  
3. Previous skill's final/ (within phase)
   or previous phase's final/ (cross-phase)
                           → read it, copy to own input/ → DONE
4. FAIL — ask user to provide
```

### Rules

- IR-01: Once all required inputs are resolved at any priority level, STOP — do not check lower priorities
- IR-02: Always copy external files to own `input/` (from user path or previous skill's output)
- IR-03: Files already in own `input/` are used as-is (no copy needed)
- IR-04: If a required input is missing at all levels, ask the user — do not guess or fabricate

---

## Output Structure

### Every Output File MUST Include

1. **Document header** (per `doc-standards.md`)
2. **Change Log** (for v2+ documents)
3. **Content sections** (per skill's `output-template.md`)
4. **Q&A Log** (per `quality-rules.md`)
5. **Readiness Assessment** (per `quality-rules.md`)

### Change Log Format (for refine mode)

```markdown
## Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | YYYY-MM-DD | Initial creation |
| 2.0 | YYYY-MM-DD | Updated X based on review feedback, resolved Q-001 through Q-005 |
```

---

## Naming Conventions

### Item IDs

Each skill defines its own ID prefix. IDs MUST be:
- Sequential within a document (no gaps)
- Unique within a document
- Referenced consistently across sections (cross-reference index)

### Standard Prefixes by Phase

| Phase | Prefix Examples |
|-------|----------------|
| init | `VIS-`, `CHR-`, `SCP-`, `RISK-` |
| req | `EPIC-`, `US-`, `AC-`, `REQ-` |
| design | `ARCH-`, `DB-`, `API-`, `ADR-` |
| test | `TS-`, `TP-`, `TC-` |
| impl | `SPR-`, `TASK-` |
| deploy | `CI-`, `REL-`, `ENV-` |
| ops | `MON-`, `INC-`, `SLA-`, `RUN-`, `CHG-` |

---

## Diff Summary

In refine mode, every output MUST end with a Diff Summary before the Readiness Assessment:

```markdown
## Diff Summary (v{N-1} → v{N})

| Category | Count |
|----------|-------|
| Items updated | {N} |
| Items added | {N} |
| Items removed | {N} |
| Q&A resolved | {N} |
| Q&A new | {N} |
| Confidence upgrades (🔶→✅) | {N} |
| Confidence upgrades (❓→✅) | {N} |
| Confidence upgrades (❓→🔶) | {N} |

### Key Changes
- {Bullet list of the most significant changes}
```
