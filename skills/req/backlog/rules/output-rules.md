# Output Rules -- req/backlog

Backlog-specific output constraints. These supplement the project-wide rules in `skills/shared/rules/` and phase rules in `req/shared/rules/`.

---

## Backlog Content Rules

### BKL-01: Complete Story Inclusion
Every story from `userstories-final.md` MUST appear in the backlog.
No stories may be silently dropped. If a story should be excluded, move it to Won't Have with a reason.

### BKL-02: Ordered Backlog
The backlog MUST be ordered by rank (1 = highest priority, build first).
Every story has a unique rank number.

### BKL-03: Priority Ordering
Must Have stories MUST be ranked above Should Have stories, which MUST be ranked above Could Have stories. Exception: a Should Have dependency of a Must Have story may be ranked within the Must Have section.

### BKL-04: Dependency Ordering
Dependencies MUST be ranked higher (earlier) than their dependents.
If US-003 depends on US-002, then US-002 must have a lower rank number.

### BKL-05: MoSCoW Distribution Check
MoSCoW distribution SHOULD approximate 60/20/20 by points.
- If Must Have > 70%: Flag as "Scope may be too ambitious for timeline"
- If Must Have < 40%: Flag as "MVP may lack critical mass"

### BKL-06: Capacity Validation
Total Must Have points MUST be validated against estimated velocity and available sprints.
If Must Have exceeds available capacity, flag as a HIGH-impact risk with Q&A entry.

### BKL-07: Split Resolution
Stories tagged `[SPLIT RECOMMENDED]` in userstories-final.md MUST be noted in the backlog.
Suggest they be resolved before the backlog is finalized.

### BKL-08: Release Grouping
Stories SHOULD be grouped into releases:
- Release 1 / MVP: All Must Have stories
- Release 2+: Should Have, then Could Have
Release grouping is recommended but not required for the first draft.

### BKL-09: MVP Boundary Required
The backlog MUST explicitly mark the MVP boundary -- the dividing line between Must Have and Should Have stories.

### BKL-10: Confidence Inheritance
Backlog entries inherit confidence from their source stories.
The backlog does not add new confidence assessments -- it carries forward from userstories.

---

## Format Rules

### BKL-11: Section Order
Backlog output MUST follow the section order in `req/backlog/templates/output-template.md`.

### BKL-12: ID References
The backlog references existing IDs (US-xxx, EPIC-xxx) from stories and epics.
It does NOT create new ID prefixes.

### BKL-13: Confidence Coverage
The Readiness Assessment counts each backlog entry as 1 item (confidence inherited from story).

---

## Refine Mode Rules

### BKL-14: Quality Scorecard First
In refine mode, generate Quality Scorecard covering:
- Completeness: Are all stories from userstories-final.md included?
- Ordering: Are dependencies respected? Are priorities ordered correctly?
- Capacity: Do Must Have points fit within velocity and timeline?
- Distribution: Is MoSCoW approximately 60/20/20?
- MVP: Is the MVP boundary clearly marked?

### BKL-15: TBD Reduction Target
Each refine round should aim to resolve outstanding issues by at least 30%.
