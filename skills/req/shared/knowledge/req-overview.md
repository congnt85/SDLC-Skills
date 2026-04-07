# Requirements Phase Overview

The requirements phase transforms initiation artifacts into implementable, prioritized, traceable requirements. It bridges "what we want to achieve" (charter/scope) and "what we need to build" (design/implementation).

---

## Skills in This Phase

```
/req-epic          → Define epics (theme-level groupings from charter objectives)
     ↓
/req-userstory     → Write user stories with INVEST criteria + Gherkin AC
     ↓
/req-backlog       → Prioritize and order the product backlog (MoSCoW)
     ↓
/req-trace         → Build traceability matrix + DoR/DoD
```

Each skill supports two modes: create and refine.

---

## Artifact Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    INPUTS (from init/final/)                │
│                                                             │
│  charter-final.md    scope-final.md    risk-register-final  │
│  (objectives, OKRs)  (features, personas) (high risks)     │
└────────────┬──────────────┬──────────────┬──────────────────┘
             │              │              │
             ▼              ▼              ▼
      ┌──────────────────────────────────────────┐
      │         /req-epic                        │
      │  Maps objectives → epics                 │
      │  Assigns features to epics               │
      │  Output: epics-draft.md                  │
      └──────────────────┬───────────────────────┘
                         │ promote to req/final/epics-final.md
                         ▼
      ┌──────────────────────────────────────────┐
      │         /req-userstory                   │
      │  Decomposes epics → user stories         │
      │  Writes Gherkin acceptance criteria       │
      │  Adds NFR + spike stories                │
      │  Output: userstories-draft.md            │
      └──────────────────┬───────────────────────┘
                         │ promote to req/final/userstories-final.md
                         ▼
      ┌──────────────────────────────────────────┐
      │         /req-backlog                     │
      │  Applies MoSCoW prioritization           │
      │  Orders by priority + dependencies       │
      │  Groups into releases, marks MVP         │
      │  Output: backlog-draft.md                │
      └──────────────────┬───────────────────────┘
                         │ promote to req/final/backlog-final.md
                         ▼
      ┌──────────────────────────────────────────┐
      │         /req-trace                       │
      │  Builds forward + backward traceability  │
      │  Gap analysis (orphan detection)         │
      │  Generates DoR + DoD                     │
      │  Output: traceability-draft.md           │
      │          dor-dod-draft.md                │
      └──────────────────┬───────────────────────┘
                         │ promote to req/final/
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                   OUTPUTS (req/final/)                      │
│                                                             │
│  epics-final.md       userstories-final.md                  │
│  backlog-final.md     traceability-final.md                 │
│  dor-dod-final.md                                           │
└─────────────────────────────────────────────────────────────┘
```

---

## What This Phase Reads from Init

| Init Artifact | What Req Phase Extracts |
|---------------|------------------------|
| **charter-final.md** | Vision statement, business objectives, OKR success metrics, constraints (budget, timeline), team size |
| **scope-final.md** | Feature inventory (SCP-xxx with sub-features), personas (goals, pain points, scenarios), quality attributes (QA-xxx), integrations (INT-xxx), feature-to-persona map |
| **risk-register-final.md** | High-impact risks (become spike stories), compliance/security risks (become Must Have stories), uncertain assumptions (inform acceptance criteria) |

---

## What Downstream (design/) Needs from This Phase

| Req Artifact | Design Phase Uses It For |
|-------------|--------------------------|
| **epics-final.md** | Architecture phasing — which systems needed in which release |
| **userstories-final.md** | Detailed acceptance criteria drive API endpoint design, database schema, component architecture |
| **backlog-final.md** | Priority ordering informs what to design first, MVP boundary defines v1 architecture scope |
| **traceability-final.md** | Verification that all scope items are covered, dependency map informs build order |
| **dor-dod-final.md** | Quality gates shape CI/CD pipeline design, testing strategy |

---

## Key Principles

1. **Stories describe WHAT, not HOW** — no implementation details, frameworks, or database tables. Those belong to design phase.
2. **Every story traces to a scope feature** — orphan stories without traceability are flagged.
3. **Every epic traces to a charter objective** — ensures all work delivers business value.
4. **Acceptance criteria use Gherkin** — Given/When/Then format for testable, unambiguous criteria.
5. **Stories follow INVEST** — Independent, Negotiable, Valuable, Estimable, Small, Testable.
6. **Estimation uses Fibonacci** — 1, 2, 3, 5, 8, 13 story points. Stories >8 must be split.
7. **MoSCoW prioritization** — Must Have (~60%), Should Have (~20%), Could Have (~20%).
