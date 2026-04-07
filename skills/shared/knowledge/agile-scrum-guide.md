# Agile/Scrum Methodology Reference

Reference guide for Agile/Scrum practices used across all SDLC skills.

---

## Core Principles

1. **Individuals and interactions** over processes and tools
2. **Working software** over comprehensive documentation
3. **Customer collaboration** over contract negotiation
4. **Responding to change** over following a plan

---

## Scrum Roles

| Role | Responsibilities |
|------|-----------------|
| **Product Owner** | Backlog management, acceptance criteria, priority decisions, stakeholder communication |
| **Scrum Master** | Process facilitation, impediment removal, team coaching, ceremony facilitation |
| **Development Team** | Self-organizing, cross-functional, delivers increments, estimates work |

---

## Scrum Events

| Event | Duration (2-week sprint) | Purpose |
|-------|-------------------------|---------|
| **Sprint Planning** | 2-4 hours | Select stories, define sprint goal, create task breakdown |
| **Daily Stand-up** | 15 minutes | Sync: what I did, what I'll do, blockers |
| **Sprint Review** | 1-2 hours | Demo increment to stakeholders, gather feedback |
| **Sprint Retrospective** | 1-1.5 hours | What went well, what to improve, action items |
| **Backlog Refinement** | 1-2 hours (ongoing) | Clarify stories, estimate, split large items |

---

## Sprint Structure

```
Sprint N (2 weeks)
├── Day 1: Sprint Planning
│   ├── Select stories from prioritized backlog
│   ├── Define sprint goal
│   └── Break stories into tasks
├── Days 2-9: Development
│   ├── Daily stand-ups
│   ├── Code, test, review
│   └── Backlog refinement (mid-sprint)
├── Day 10: Sprint Review + Retrospective
│   ├── Demo working increment
│   ├── Stakeholder feedback
│   └── Team retrospective
└── Output: Potentially shippable increment
```

---

## Estimation

### Story Points (Fibonacci Scale)

| Points | Complexity | Example |
|--------|-----------|---------|
| 1 | Trivial — well-understood, minimal effort | Change button label |
| 2 | Simple — small, clear implementation | Add form field |
| 3 | Moderate — straightforward with minor unknowns | Simple CRUD endpoint |
| 5 | Medium — multiple components, some complexity | Search with filters |
| 8 | Large — significant effort, integration points | Auth flow |
| 13 | Very large — should probably split | Reporting dashboard |
| 21 | Epic-sized — must split before sprint | Payment processing |

### Velocity

- **Velocity** = average story points completed per sprint (last 3-5 sprints)
- Use velocity to forecast: `remaining points / velocity = sprints needed`
- New teams: estimate 30-40% of theoretical capacity for first sprint

---

## User Story Format

```
As a [persona/role],
I want [capability/action],
So that [benefit/value].
```

### INVEST Criteria

| Criterion | Question |
|-----------|----------|
| **I**ndependent | Can it be developed without depending on another story? |
| **N**egotiable | Is the implementation flexible? |
| **V**aluable | Does it deliver value to user or business? |
| **E**stimable | Can the team estimate the effort? |
| **S**mall | Can it complete within one sprint? |
| **T**estable | Can we write a test to verify it? |

---

## Acceptance Criteria (Gherkin Format)

```gherkin
Scenario: {Descriptive name}
  Given {precondition / initial context}
  And {additional precondition if needed}
  When {action / trigger}
  And {additional action if needed}
  Then {expected outcome}
  And {additional outcome if needed}
```

---

## Prioritization: MoSCoW Method

| Priority | Meaning | Effort Guideline |
|----------|---------|-----------------|
| **Must Have** | Project fails without it | ~60% of total effort |
| **Should Have** | Important, but workarounds exist | ~20% of total effort |
| **Could Have** | Nice to have, enhances experience | ~20% of total effort |
| **Won't Have** | Explicitly excluded from this release | Documented for future |

---

## Definition of Ready (DoR)

A story is ready for sprint planning when:
- [ ] Written in "As a... I want... So that..." format
- [ ] Acceptance criteria defined (Given/When/Then)
- [ ] Estimated (story points assigned)
- [ ] Small enough for one sprint (≤ 8 points)
- [ ] Dependencies identified and resolved
- [ ] No open questions

## Definition of Done (DoD)

A story is done when:
- [ ] Code written and follows standards
- [ ] Peer reviewed (PR approved)
- [ ] Unit tests passing
- [ ] Integration tests passing
- [ ] Acceptance criteria verified
- [ ] Documentation updated
- [ ] Merged to main branch
- [ ] Product Owner accepted
