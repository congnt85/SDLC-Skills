# ADR Output Rules

Rules specific to the ADR skill output. These supplement the shared design rules (DES-xx).

---

## Title and Status Rules

### ADR-01: Imperative Title Required
Every ADR MUST have a title in imperative form. Use "Use X for Y", "Adopt X Architecture", "Implement X via Y" — NOT "X Selection", "Database Choice", or "About Authentication". The title should state the decision, not the topic.

### ADR-02: Valid Status Required
Every ADR MUST have a status from the allowed set: `Proposed`, `Accepted`, `Rejected`, `Deprecated`, `Superseded`. New ADRs default to `Proposed`. Status transitions must follow the lifecycle: Proposed → Accepted/Rejected, Accepted → Deprecated/Superseded.

---

## Traceability Rules

### ADR-03: Context Must Trace to Requirements
The Context section MUST reference at least one requirement identifier (QA-xxx, CON-xxx, US-xxx, RISK-xxx). ADRs that cannot be traced to a requirement should be questioned — if no requirement drives the decision, is it really necessary?

---

## Alternatives Rules

### ADR-04: Minimum Two Alternatives
At least 2 alternatives MUST be documented, each with pros and cons in tabular format. The chosen option MUST be included as one of the alternatives and marked as `CHOSEN`. All other alternatives are marked `REJECTED`. A Decision Rationale paragraph MUST explain why the chosen option won over the others.

---

## Consequences Rules

### ADR-05: Balanced Consequences Required
The Consequences section MUST include both positive AND negative impacts. Every decision has trade-offs — an ADR with only positive consequences is incomplete. Neutral consequences are optional but encouraged.

---

## Numbering and Naming Rules

### ADR-06: Sequential Numbering
ADR numbers are sequential, zero-padded to 3 digits (001, 002, ...), and NEVER reused. When a new ADR is created, scan `draft/` for existing `adr-{NNN}-*-draft.md` files and use max(NNN) + 1. If no ADRs exist, start at 001.

### ADR-07: File Naming Convention
File naming MUST follow: `adr-{NNN}-{kebab-case-slug}-draft.md`. The slug is 3-5 words in kebab-case derived from the title. Examples:
- `adr-001-adopt-modular-monolith-draft.md`
- `adr-002-use-postgresql-primary-db-draft.md`
- `adr-003-use-redis-for-caching-draft.md`

---

## Lifecycle Rules

### ADR-08: Superseded ADRs Must Link to Successor
When an ADR status is changed to `Superseded`, it MUST include a `Superseded by: ADR-{NNN}` field linking to the replacement ADR. The successor ADR MUST include a `Supersedes: ADR-{NNN}` field linking back.

### ADR-09: Deprecated ADRs Must Explain Why
When an ADR status is changed to `Deprecated`, it MUST include an explanation of why the decision no longer applies (requirements changed, technology evolved, problem no longer exists, etc.).

---

## Structure Rules

### ADR-10: Section Order
ADR document MUST follow this section order:
1. Title (as H1: `# ADR-{NNN}: {Title}`)
2. Metadata (Date, Status, Deciders, Supersedes/Superseded by)
3. Context
4. Decision
5. Alternatives Considered
6. Consequences (Positive, Negative, Neutral)
7. Compliance
8. Related Decisions
9. Q&A Log
10. Readiness Assessment
11. Approval

---

## Confidence Rules

### ADR-11: Confidence Markers on Decisions
Confidence markers MUST be applied to:
- The main decision statement (✅ CONFIRMED / 🔶 ASSUMED / ❓ UNCLEAR)
- Each alternative assessment (are the pros/cons validated or assumed?)
- Each consequence (confirmed impact or assumed impact?)

A new ADR typically starts with the decision as 🔶 ASSUMED and progresses to ✅ CONFIRMED after stakeholder review.

---

## Refine Mode Rules

### ADR-12: Refine Mode Scorecard First
Refine mode MUST show a quality scorecard FIRST, before applying changes. The scorecard evaluates:
- Title format (imperative form? clear decision statement?)
- Context traceability (at least one requirement referenced?)
- Alternatives completeness (>=2 alternatives with pros/cons?)
- Consequences balance (both positive and negative listed?)
- Compliance section coverage (all aspects addressed?)
- Confidence distribution (% CONFIRMED vs ASSUMED vs UNCLEAR)
- Status transition validity (if status is changing)
