# Estimation Methods

Reference for estimation techniques used across initiation (budget), requirements (story points), and implementation (sprint planning) phases.

---

## 1. Three-Point Estimation (PERT)

Used for: budget estimates, timeline estimates, effort estimates.

### Formula

```
Expected = (Optimistic + 4 × Most Likely + Pessimistic) / 6
Standard Deviation = (Pessimistic - Optimistic) / 6
```

### Template

| Item | Optimistic (O) | Most Likely (M) | Pessimistic (P) | Expected | SD |
|------|----------------|-----------------|------------------|----------|----|
| {item} | {best case} | {realistic} | {worst case} | (O+4M+P)/6 | (P-O)/6 |

### Confidence Ranges

| Range | Probability |
|-------|------------|
| Expected ± 1 SD | ~68% confident |
| Expected ± 2 SD | ~95% confident |
| Expected ± 3 SD | ~99.7% confident |

### When to Use
- Budget estimation in charter
- Timeline estimation for milestones
- Effort estimation when historical data is limited

---

## 2. Analogous Estimation

Used for: early-stage estimates when a similar past project exists.

### Process

1. Identify a comparable past project
2. Note its actual cost/duration/effort
3. Identify key differences (scope, complexity, team, technology)
4. Adjust up or down based on differences

### Template

| Factor | Past Project | This Project | Adjustment |
|--------|-------------|-------------|------------|
| Scope | {description} | {description} | {+/- %}  |
| Complexity | {H/M/L} | {H/M/L} | {+/- %} |
| Team size | {N} | {N} | {+/- %} |
| Team experience | {H/M/L} | {H/M/L} | {+/- %} |
| Technology | {known/new} | {known/new} | {+/- %} |
| **Past actual** | {value} | | |
| **Adjusted estimate** | | {value} | {total %} |

### When to Use
- Early charter stage when scope is vague
- Quick sanity check against other methods

---

## 3. Parametric Estimation

Used for: cost estimates based on measurable parameters.

### Common Parameters

| Parameter | Unit Cost | Formula |
|-----------|----------|---------|
| Developer-month | ${rate}/month | Team size × months × rate |
| Story point | ${cost}/point | Total points × cost per point |
| API endpoint | {hours}/endpoint | Endpoints × hours × hourly rate |
| Database table | {hours}/table | Tables × hours × hourly rate |
| Screen/page | {hours}/screen | Screens × hours × hourly rate |

### Template

| Category | Quantity | Unit Cost | Subtotal | Confidence |
|----------|----------|-----------|----------|------------|
| Development | {N} developer-months | ${rate} | ${total} | {H/M/L} |
| Infrastructure | {N} months | ${rate}/month | ${total} | {H/M/L} |
| Licenses | {N} seats | ${rate}/seat | ${total} | {H/M/L} |
| **Subtotal** | | | **${total}** | |
| Contingency (15-20%) | | | ${buffer} | |
| **Total** | | | **${grand}** | |

### When to Use
- Budget section of charter (after scope is understood)
- Sprint capacity planning (story points per sprint)

---

## 4. T-Shirt Sizing

Used for: quick relative sizing before detailed estimation.

| Size | Relative Effort | Story Points Equivalent | Example |
|------|----------------|------------------------|---------|
| XS | Trivial | 1 | Config change |
| S | Small | 2-3 | Single component |
| M | Medium | 5 | Feature with a few parts |
| L | Large | 8 | Multi-component feature |
| XL | Very large — split it | 13+ | System-level feature |

### When to Use
- Epic sizing during initiation/requirements
- Quick backlog triage before detailed estimation
- When team hasn't calibrated on story points yet

---

## 5. Build vs Buy Analysis

Used for: charter budget decisions on components.

### Template

| Factor | Build | Buy/SaaS | Score (1-5) Build | Score (1-5) Buy |
|--------|-------|----------|-------------------|-----------------|
| Upfront cost | Development time | License/subscription | | |
| Ongoing cost | Maintenance effort | Subscription renewal | | |
| Time to market | Weeks/months to build | Days to integrate | | |
| Customizability | Full control | Limited to vendor API | | |
| Team expertise | Need to learn/build | Need to learn vendor | | |
| Risk | Quality depends on team | Vendor dependency | | |
| **Total** | | | **/30** | **/30** |

### Decision Guide
- Build score > Buy score by 5+: Build
- Scores within 5: Consider hybrid (buy + customize)
- Buy score > Build score by 5+: Buy
