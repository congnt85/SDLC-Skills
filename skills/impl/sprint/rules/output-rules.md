# Output Rules -- impl/sprint

Sprint plan-specific output constraints. These supplement the project-wide rules in `skills/shared/rules/` and phase rules in `impl/shared/rules/`.

---

## Sprint Plan Content Rules

### SPR-01: Sprint Goal Required
Every sprint MUST have a clear, 1-sentence sprint goal.
The goal must be specific and measurable — not "work on tasks" but "Dev Dana can connect a GitHub repo and see commits on the sprint board."

### SPR-02: Capacity Validation
Committed story points MUST NOT exceed team capacity.
Flag any sprint with >90% utilization as over-committed.
Include utilization percentage in every sprint plan table.

### SPR-03: DoR Validation Required
Every story planned for a sprint MUST be validated against the Definition of Ready from dor-dod-final.md.
Reference specific DoR criteria by ID (DOR-xxx).

### SPR-04: DoR Failures Flagged
Stories failing DoR MUST be flagged with:
- Specific criteria that failed
- Gap description
- Remediation action (which skill to run or what info is needed)
- Whether the story should be deferred or included with remediation tasks

### SPR-05: Task Size Limits
Every story MUST be decomposed into tasks of 2-8 hours each (per IMP-03).
Tasks outside this range MUST be split (if too large) or combined (if too small).

### SPR-06: Task Dependencies Explicit
Task dependencies MUST be explicit using task IDs (T-xxx depends on T-yyy).
No implicit ordering — if Task B cannot start until Task A completes, state it.

### SPR-07: DoD Mapping Required
Every task MUST reference applicable DoD criteria by ID (DOD-xxx) from dor-dod-final.md (per IMP-04).
The DoD checklist section must list all criteria and which task types they apply to.

### SPR-08: Test Task Inclusion
Every feature implementation task MUST have associated test tasks (per IMP-05):
- Feature code -> unit tests + integration tests
- API endpoints -> API tests
- Database changes -> migration tests
Test tasks are not optional; they are part of the story's task breakdown.

### SPR-09: Section Order
Sprint plan output MUST follow this section order:
1. Sprint Overview
2. DoR Validation
3. Sprint Plans (per sprint: goal, stories, capacity, task breakdown)
4. Team Assignments (summary)
5. Sprint Dependencies (Mermaid diagram)
6. Definition of Done Checklist
7. Q&A Log
8. Readiness Assessment
9. Approval

### SPR-10: Confidence Markers
Confidence markers (CONFIRMED / ASSUMED / UNCLEAR) MUST appear on:
- Velocity assumptions
- Capacity estimates
- Team assignments
- Sprint goals (if dependent on unconfirmed scope)
- External dependency resolutions

### SPR-11: Refine Mode Scorecard
In refine mode, generate a Quality Scorecard BEFORE applying changes, covering:
- Sprint goals: Clear and achievable?
- Capacity: Utilization within 60-80%?
- DoR compliance: All stories validated?
- Task granularity: All tasks 2-8 hours?
- Dependencies: Explicit and acyclic?
- DoD mapping: Every task references DoD criteria?
- Test coverage: Every feature task has a test task?

### SPR-12: Buffer Allocation
Sprint plan MUST include buffer of 10-20% of capacity for unplanned work.
Buffer must be visible in the capacity table as a separate row or column.

### SPR-13: Dependency Visualization
Cross-sprint dependencies MUST be visualized using a Mermaid diagram.
Include both sprint-level flow and key task-level dependencies within sprints.

### SPR-14: MVP Detail Level
MVP sprints (Release 1) MUST be planned in full detail — task-level breakdown, assignments, dependencies.
Post-MVP sprints (Release 2+) can be planned at high level — stories committed, capacity estimate, sprint goal only.
