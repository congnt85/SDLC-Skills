# Vision Workshop Guide

Techniques for extracting and refining a compelling project vision from vague input.

---

## Technique 1: The 5 Whys for Vision

When the user provides a vague idea, dig deeper with progressive "why" questions:

1. **What** do you want to build? → Get the basic concept
2. **Who** is it for? → Identify target users
3. **Why** do they need it? → Uncover the real problem
4. **Why** isn't the current solution good enough? → Find the differentiator
5. **Why** now? → Understand urgency and timing

**Example:**
```
User: "I want to build a task management app"

1. What: A task management application
2. Who: Remote development teams of 5-50 people
3. Why: They lose track of sprint progress across distributed members
4. Why not current: Jira requires too much manual updating, teams stop using it
5. Why now: Our company just went fully remote, existing tools don't work
```

---

## Technique 2: Problem-Solution Framing

Structure the conversation around the problem first, solution second:

### Questions to Ask

**Problem exploration:**
- "What's the most painful thing about the current situation?"
- "How much time/money is wasted because of this problem?"
- "Who suffers the most from this problem?"
- "What have you tried before? Why didn't it work?"

**Solution framing:**
- "If this project succeeds perfectly, what does the world look like?"
- "What's the ONE thing this system must do well?"
- "What would make users switch from their current approach?"
- "What's the minimum viable version of this?"

---

## Technique 3: Constraint Extraction

Users often know their constraints better than their requirements. Use constraints to shape the vision:

| Question | What It Reveals |
|----------|----------------|
| "When do you need this by?" | Timeline pressure → MVP scope |
| "How many people will build this?" | Team size → architecture complexity |
| "What's the budget?" | Financial constraints → build vs buy |
| "What technology must you use?" | Tech mandates → stack constraints |
| "Who needs to approve this?" | Governance → stakeholder map |
| "Are there regulations to follow?" | Compliance → non-negotiable requirements |

---

## Technique 4: Anti-Requirements

Sometimes it's easier to define what the project is NOT:

- "What should this project NOT try to solve?"
- "What features would be nice but aren't essential for v1?"
- "What existing systems should this NOT replace?"
- "What user types are NOT the target audience?"

Anti-requirements prevent scope creep and sharpen the vision.

---

## Technique 5: Success Scenario

Ask the user to describe success in concrete terms:

> "Imagine it's 6 months after launch. The project is a huge success. What specifically happened?"

Then extract:
- **Measurable outcomes** → become success metrics
- **User behaviors** → become user stories
- **Business results** → become business justification

---

## Working with Vague Input

### Input Quality Levels

| Level | Example | Approach |
|-------|---------|----------|
| **One-liner** | "Build a CRM" | Use all 5 techniques above, extensive questioning |
| **Paragraph** | "We need a CRM for our sales team to track leads and deals" | Clarify specifics: who, how many, what's the current process |
| **Detailed brief** | Multi-paragraph description with some requirements | Validate understanding, fill gaps, push for SMART metrics |
| **Existing docs** | BRD, PRD, or other documentation | Extract and structure, identify gaps, create Q&A for ambiguities |

### Rules for Handling Vagueness

1. **Never reject vague input** — work with whatever the user gives
2. **Generate what you can** — fill in reasonable assumptions, mark as 🔶 ASSUMED
3. **Ask one section at a time** — don't overwhelm with 20 questions
4. **Offer options when uncertain** — "This could be A or B — which fits better?"
5. **Use [TBD] generously** — unknowns are normal at this stage, flag and move on
