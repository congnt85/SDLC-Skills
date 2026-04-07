# Output Rules -- init/scope

Scope-specific output constraints. These supplement the project-wide rules in `skills/shared/rules/`.

---

## Scope Content Rules

### SCP-01: Feature Traceability to Charter
Every in-scope feature MUST trace to at least one charter objective or success metric.
If a feature appears in scope but not in the charter, tag it as `[NEW -- added during scope definition]` and create a Q&A asking if it should be in scope.

### SCP-02: Persona Volume Required
Every persona MUST include an estimated user volume (even if rough).
- Acceptable: "~500 initially, ~2000 by year 2"
- Not acceptable: "many users" or blank

If volume is unknown, mark as ASSUMED and create Q&A.

### SCP-03: Feature Complexity Sizing
Every feature in the Feature Inventory MUST have a complexity estimate:
- XS (< 1 day), S (1-3 days), M (3-5 days), L (1-2 weeks), XL (2+ weeks)
- L and XL features MUST be decomposed into sub-features
- If complexity is unknown, mark as ASSUMED with best estimate

### SCP-04: Quality Attributes Must Be Measurable
Quality attributes MUST have:
- A specific, measurable target (not "fast" or "reliable")
- A measurement method (how will we verify?)

If target is vague, mark as ASSUMED and suggest a quantified alternative.
See INIT-04 for examples of good vs bad quality attributes.

### SCP-05: Feature ID Consistency
- Feature IDs (SCP-xxx) from the charter MUST be preserved in scope
- New features added during scope get the next sequential ID
- Sub-features use dot notation: SCP-001.1, SCP-001.2
- Integration IDs use INT- prefix
- Quality attribute IDs use QA- prefix

### SCP-06: Persona-Feature Coverage
Every Must Have feature MUST map to at least one persona.
Every Primary persona MUST have at least one Must Have feature.
If gaps exist, create Q&A entries.

### SCP-07: System Context Diagram Required
The scope document MUST include a Mermaid C4 Context diagram showing:
- The system being built (center)
- All identified external systems
- All identified user types
- Relationship labels describing the interaction

---

## Format Rules

### SCP-08: Section Order
Scope output MUST follow the section order in `init/shared/templates/scope/scope-template.md`.
Do not add, remove, or reorder sections.

### SCP-09: ID Prefixes

| Section | Prefix |
|---------|--------|
| Features (in-scope) | SCP- |
| Features (out-of-scope) | OUT- |
| Sub-features | SCP-{parent}.{N} |
| Integrations | INT- |
| Quality attributes | QA- |
| Q&A entries | Q- |

### SCP-10: Confidence Coverage
The Readiness Assessment MUST count items from these sections:
- Features (each feature/sub-feature is 1 item)
- Personas (each persona is 1 item)
- Integrations (each integration is 1 item)
- Quality attributes (each attribute is 1 item)

Project boundaries and change control are structural -- not counted in readiness.

---

## Refine Mode Rules

### SCP-11: Quality Scorecard First
In refine mode, BEFORE applying changes, generate a Quality Scorecard covering:
- Completeness: Are all scope sections populated?
- Clarity: Are feature descriptions specific enough for requirements phase?
- Quantification: Are quality attributes measurable? Are complexity estimates present?
- Consistency: Do feature IDs match charter? Do personas map to features?
- Traceability: Does every feature trace to a charter objective?

Present this scorecard to the user before asking what to improve.

### SCP-12: Decomposition Check
Each refine round should check for features that are still too large:
- Any L/XL feature without sub-features should be flagged
- Suggest decomposition for any feature described in more than 2 sentences

### SCP-13: TBD Reduction Target
Each refine round should aim to reduce [TBD] count by at least 30%.
If no TBDs were resolved, flag this in the Diff Summary.
