# Epic Decomposition Guide

Techniques for mapping charter objectives and scope features into well-structured epics.

---

## Technique 1: Objective-to-Epic Mapping

Start from charter objectives and create epics that deliver on each.

### Process

1. List all charter objectives and their key results (OKRs)
2. For each objective, identify which scope features contribute to it
3. Group features that share the same objective into an epic
4. If an objective requires multiple distinct capabilities, create multiple epics

### Example

```
Charter Objective 1: "Eliminate manual sprint status updates"
  Key Results: >80% tickets auto-updated, SM time < 5 min/day

  Contributing features:
    SCP-001: Git Integration (auto-detect commits, PRs)
    SCP-002: Sprint Dashboard (real-time board)

  These are distinct capabilities → 2 separate epics:
    EPIC-001: Real-Time Git Sync (SCP-001)
    EPIC-002: Sprint Visibility Dashboard (SCP-002)
```

### Decision: One Epic or Two?

| Merge into one epic when... | Split into separate epics when... |
|---------------------------|----------------------------------|
| Features share the same user workflow | Features serve different personas |
| Features can't deliver value independently | Features can be shipped independently |
| Combined = 3-8 stories | Combined > 8 stories |
| Same team would build both | Different teams/skills needed |

---

## Technique 2: Feature Clustering

Group scope features by affinity (shared persona, shared domain, shared integration).

### Clustering Dimensions

| Dimension | Example |
|-----------|---------|
| **By persona** | All features primarily used by "SM Sam" |
| **By domain** | All features related to "Git integration" |
| **By integration** | All features that depend on GitHub API |
| **By workflow** | All features in the "sprint planning" workflow |
| **By data entity** | All features that operate on "tickets" |

### Process

1. Create a feature affinity matrix (features as rows, dimensions as columns)
2. Identify clusters of features that score high on the same dimensions
3. Each cluster becomes an epic candidate
4. Validate: does each cluster deliver coherent, independent value?

---

## Technique 3: Cross-Cutting Concern Identification

Some capabilities don't map neatly to a single objective but are needed by multiple epics.

### Common Cross-Cutting Concerns

| Concern | Typical Features | Epic Tag |
|---------|-----------------|----------|
| Authentication & Authorization | Login, SSO, roles, permissions | [CROSS-CUTTING] |
| Security | Encryption, audit logging, compliance | [CROSS-CUTTING] |
| Performance & Scalability | Caching, optimization, load handling | [CROSS-CUTTING] |
| Infrastructure | CI/CD for the product itself, monitoring | [CROSS-CUTTING] |
| Data Migration | Import from existing systems | [CROSS-CUTTING] |
| Developer Experience | API documentation, SDK, onboarding | [CROSS-CUTTING] |

### Rules for Cross-Cutting Epics

- Always tag with `[CROSS-CUTTING]`
- Link to "supports all objectives" rather than a single objective
- These epics often have Must Have priority because other epics depend on them
- Place them early in the dependency chain

---

## Technique 4: Epic Sizing Heuristics

### Ideal Epic Size

| Metric | Ideal Range | Too Small | Too Large |
|--------|------------|-----------|-----------|
| Stories | 3-8 | < 3 (merge with another) | > 12 (split) |
| Story points | 15-40 | < 10 (merge) | > 60 (split) |
| Sprint span | 1-3 sprints | < 1 sprint (just a story) | > 4 sprints (split by milestone) |

### Splitting Oversized Epics

If an epic is too large, split by:

1. **By milestone/phase**: MVP vs enhancement vs optimization
2. **By persona**: Core user epic vs admin epic
3. **By workflow stage**: Setup/config epic vs daily use epic vs reporting epic
4. **By integration**: One epic per external system
5. **By data scope**: Read-only epic vs read-write epic

### Merging Undersized Epics

If an epic has fewer than 3 stories:
- Can it merge with a related epic without losing clarity?
- Is it really a story masquerading as an epic?
- Is it a spike that should be a single story instead?

---

## Technique 5: Spike Epic for High Risks

When the risk register contains HIGH-severity risks with technical uncertainty, create a spike epic.

### When to Create a Spike Epic

- Risk score >= 15 (High or Critical)
- Risk involves technical feasibility uncertainty
- Multiple related risks can be grouped into investigation themes

### Spike Epic Structure

```
EPIC-xxx: Technical Validation [SPIKE]
  Objective: Reduce technical uncertainty before committing to full implementation
  Features: None (research-oriented, not feature-delivering)
  Stories: Time-boxed investigation tasks (1-2 days each)
  Success Criteria: Each spike produces a documented decision (proceed / pivot / abandon)
  Priority: Must Have (typically Sprint 0 or Sprint 1)
```

### Example

```
RISK-001: Webhook payloads may lack sufficient data (Score: 15)
RISK-002: Branch naming conventions may vary (Score: 16)

→ EPIC-007: Git Integration Validation [SPIKE]
    US-026: [SPIKE] Test GitHub webhook payloads (2 days)
    US-027: [SPIKE] Survey target team branch naming conventions (1 day)
    US-028: [SPIKE] Prototype ticket mapper with real data (3 days)
```

---

## Working with Charter and Scope Input

### Extraction Checklist

From charter, extract:
- [ ] All business objectives (Section 3)
- [ ] All key results / success metrics (Section 3)
- [ ] In-scope features (Section 4) — carry forward IDs
- [ ] Out-of-scope items — verify none accidentally included
- [ ] Constraints that affect epic sizing (timeline, budget, team size)
- [ ] Pending Q&A items that may affect epic structure

From scope, extract:
- [ ] Feature inventory with sub-features (Section 2)
- [ ] Feature priorities (Must/Should/Could)
- [ ] Feature complexity estimates (XS/S/M/L/XL)
- [ ] Personas and persona-to-feature map (Section 3)
- [ ] Quality attributes (Section 5) — NFR stories
- [ ] Integrations (Section 4) — may drive epic boundaries

### Confidence Inheritance

| Source Confidence | Epic Confidence |
|-------------------|-----------------|
| Charter objective ✅ CONFIRMED | Epic ✅ CONFIRMED |
| Scope feature ✅ CONFIRMED | Feature assignment ✅ CONFIRMED |
| Scope feature 🔶 ASSUMED | Feature assignment 🔶 ASSUMED |
| Inferred grouping (not in charter/scope) | 🔶 ASSUMED with Q&A |
| Risk-derived spike | 🔶 ASSUMED |
