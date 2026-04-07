# Persona Template

Template for defining user personas during scope definition.

---

## Persona Card

```markdown
### Persona: {Memorable Name} ({Role})

**Photo placeholder**: {Brief description of this persona's archetype}

| Field | Description |
|-------|-------------|
| **Role** | {Their role — e.g., "E-commerce store owner"} |
| **Age Range** | {Typical age range — e.g., "30-50"} |
| **Technical Proficiency** | Low / Medium / High |
| **Usage Frequency** | Daily / Weekly / Occasional |
| **Estimated Volume** | {How many users of this type — e.g., "~500 initially"} |
| **Primary / Secondary** | Primary = core user, Secondary = important but not main focus |

**Goals** (what they want to accomplish):
1. {Goal 1 — the main thing they need the system for}
2. {Goal 2}
3. {Goal 3}

**Pain Points** (current frustrations):
1. {Pain 1 — what's broken or hard today}
2. {Pain 2}
3. {Pain 3}

**Key Scenarios** (top things they do with the system):
1. {Scenario 1 — e.g., "Creates a new order and assigns it to a vendor"}
2. {Scenario 2}
3. {Scenario 3}
4. {Scenario 4}
5. {Scenario 5}

**Quote**: "{A one-sentence quote that captures this persona's core need}"
```

---

## Persona Prioritization Table

```markdown
| Persona | Type | Justification |
|---------|------|---------------|
| {Name 1} | Primary | {Why this is the core user — most stories target them} |
| {Name 2} | Primary | {Why this is also a core user} |
| {Name 3} | Secondary | {Important but not the primary focus} |
| {Name 4} | Excluded | {Why this user type is out of scope for this release} |
```

## Rules

- At least 2 personas, maximum 5 (more = too diffuse)
- At least 1 Primary persona
- Each persona must have measurable volume (estimated user count)
- Scenarios should map to features in the Feature Inventory
