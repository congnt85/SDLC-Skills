# Initiation Phase Overview

The initiation phase takes a vague project idea and produces structured artifacts that downstream phases consume. It answers: **What are we building, why, for whom, and what could go wrong?**

---

## Skills in This Phase

```
/init-charter → /init-scope → /init-risk
```

| Skill | Purpose | Input | Output |
|-------|---------|-------|--------|
| charter | Define project vision, objectives, constraints | Vague idea | `charter-final.md` |
| scope | Define features, personas, boundaries, quality attributes | Charter | `scope-final.md` |
| risk | Identify and assess project risks | Charter, scope | `risk-register-final.md` |

## Artifact Flow

```
User's vague idea
       │
       ▼
  charter/draft/ ←→ refine loop
       │
       ▼ (promote to final)
  init/final/charter-final.md
       │
       ├──────────────────────────┐
       ▼                          ▼
  scope/draft/ ←→ refine     risk/draft/ ←→ refine
       │                          │
       ▼                          ▼
  init/final/scope-final.md  init/final/risk-register-final.md
       │                          │
       └──────────┬───────────────┘
                  ▼
            req/ phase reads from init/final/
```

## What Downstream Needs from This Phase

### `req/` phase reads:

| Artifact | Fields Extracted | Used For |
|----------|-----------------|----------|
| `charter-final.md` | Vision, objectives, SMART metrics | Epic validation, acceptance criteria |
| `scope-final.md` | Feature inventory, personas, quality attributes, in/out boundaries | Epic creation, story writing, NFR stories |
| `risk-register-final.md` | High-impact risks, compliance risks | Spike stories, Must Have security stories |

### `design/` phase reads:

| Artifact | Fields Extracted | Used For |
|----------|-----------------|----------|
| `charter-final.md` | Budget, timeline, team size, tech mandates | Tech stack constraints, architecture decisions |
| `scope-final.md` | Quality attributes, user roles, system context | Architecture patterns, API boundaries |

## Key Rules for Initiation Skills

1. Accept vague input — use [TBD] and ASSUMED markers, don't block progress
2. Push for specificity — reject "good performance", ask for "< 200ms API response"
3. No technical decisions — tech stack, framework, database choices belong to `design/` phase
4. Every item must have a confidence marker (CONFIRMED / ASSUMED / UNCLEAR)
5. Generate incrementally — section by section, confirm with user, then continue
