# Release Plan Output Template

This is the expected structure for `release-plan-draft.md` output. Follow this exactly.

---

```markdown
# Release Plan: {Project Name}

> **Project**: {Project Name}
> **Version**: {1.0}
> **Date Created**: {YYYY-MM-DD}
> **Last Updated**: {YYYY-MM-DD}
> **Status**: Draft
> **Author**: AI-Generated
> **Source**: Derived from `cicd-pipeline-final.md` and `backlog-final.md`

{If refine mode, include Change Log here}

---

## 1. Versioning Strategy

| Aspect | Value | Confidence |
|--------|-------|------------|
| Versioning scheme | Semantic Versioning (MAJOR.MINOR.PATCH) | {marker} |
| Initial version | {0.1.0 / 1.0.0 / etc.} | {marker} |
| First GA version | {1.0.0} | {marker} |
| Pre-release format | {-alpha.N, -beta.N, -rc.N} | {marker} |
| Build metadata format | {+build.NNN / +YYYYMMDD} | {marker} |

### Version Bump Triggers

| Bump | Trigger | Example |
|------|---------|---------|
| MAJOR | {Breaking API changes, major architecture shifts} | {1.0.0 -> 2.0.0} |
| MINOR | {New features, backward-compatible additions} | {1.0.0 -> 1.1.0} |
| PATCH | {Bug fixes, backward-compatible corrections} | {1.0.0 -> 1.0.1} |

### Pre-release Progression

{version}-alpha.N -> {version}-beta.N -> {version}-rc.N -> {version}

- **Alpha**: {description of alpha stage}
- **Beta**: {description of beta stage}
- **Release Candidate**: {description of RC stage}

---

## 2. Release Types

### Release Type Summary

| Type | Cadence | Process | Approval | Freeze Period | Timeline |
|------|---------|---------|----------|---------------|----------|
| Major | {frequency} | Full | {approvers} | {duration} | {target} |
| Minor | {frequency} | Standard | {approvers} | {duration} | {target} |
| Patch | {frequency} | Expedited | {approvers} | {duration} | {target} |
| Hotfix | As needed | Emergency | {approvers} | None | {target} |

### Major Release Process

{Detailed steps for major releases}

### Minor Release Process

{Detailed steps for minor releases}

### Patch Release Process

{Detailed steps for patch releases}

### Hotfix Release Process

{Detailed steps for hotfix releases}

---

## 3. Release Process

### Workflow Diagram

```mermaid
flowchart TD
    A[{step 1}] --> B[{step 2}]
    B --> C[{step 3}]
    C --> D{Decision}
    D -->|Yes| E[{step 4}]
    D -->|No| F[{step fix}]
    F --> C
    E --> G[{step 5}]
    G --> H[{step 6}]
```

### Process Steps

| Step | Action | Owner | SLA | Entry Criteria | Exit Criteria |
|------|--------|-------|-----|---------------|---------------|
| 1 | {action} | {owner} | {time} | {criteria} | {criteria} |
| 2 | {action} | {owner} | {time} | {criteria} | {criteria} |
| ... | | | | | |

### Code Freeze Rules

| Rule | Detail | Confidence |
|------|--------|------------|
| Freeze duration | {N days before release} | {marker} |
| Allowed during freeze | {bug fixes, docs only} | {marker} |
| Freeze exception process | {who can approve exceptions} | {marker} |

---

## 4. Changelog Management

### Format

{Keep a Changelog format with sections: Added, Changed, Deprecated, Removed, Fixed, Security}

### Commit-to-Changelog Mapping

| Commit Prefix | Changelog Section |
|--------------|-------------------|
| `feat:` | Added |
| `fix:` | Fixed |
| `perf:` | Changed |
| `BREAKING CHANGE:` | Added (with breaking notice) |
| `deprecate:` | Deprecated |
| `security:` | Security |
| `docs:`, `style:`, `refactor:`, `test:`, `ci:`, `chore:` | (omit from user-facing changelog) |

### Automation Tool

{Tool name}: {how it auto-generates changelog from commits}

### Example Changelog Entry

```markdown
## [{version}] - {YYYY-MM-DD}

### Added
- {feature description} ({US-xxx})

### Fixed
- {fix description} ({US-xxx})
```

### Story Traceability

{How changelog entries link back to user stories (US-xxx) and PRs}

---

## 5. Release Approval

### Approval Criteria

| Criterion | Required For | Evidence | Confidence |
|-----------|-------------|----------|------------|
| All CI tests pass | All releases | Green pipeline | {marker} |
| Code coverage >= {threshold}% | All releases | Coverage report | {marker} |
| No Critical/High bugs | All releases | Bug tracker query | {marker} |
| Performance benchmarks met | Minor, Major | Load test report | {marker} |
| Security scan clean | All releases | SAST/DAST report | {marker} |
| Stakeholder demo | Major | Demo sign-off | {marker} |
| Changelog reviewed | Minor, Major | PR approval | {marker} |

### Approvers Matrix

| Release Type | Approvers | Turnaround SLA | Confidence |
|-------------|-----------|----------------|------------|
| Patch | {approver} | {time} | {marker} |
| Minor | {approvers} | {time} | {marker} |
| Major | {approvers} | {time} | {marker} |
| Hotfix | {approver} | {time} | {marker} |

---

## 6. Rollback Procedures

### Application Rollback

| Aspect | Detail | Confidence |
|--------|--------|------------|
| Method | {deploy previous image/artifact} | {marker} |
| Target time | {< X minutes} | {marker} |
| Steps | {step-by-step} | {marker} |
| Verification | {smoke tests, health checks} | {marker} |

### Database Rollback

| Aspect | Detail | Confidence |
|--------|--------|------------|
| Preferred approach | {forward-fix} | {marker} |
| Rollback migration | {pre-written, tested in CI} | {marker} |
| Target time | {< X minutes} | {marker} |
| Constraints | {cannot drop columns with data} | {marker} |

### Configuration Rollback

| Aspect | Detail | Confidence |
|--------|--------|------------|
| Method | {revert config, restart services} | {marker} |
| Target time | {< X minutes} | {marker} |
| Config management | {tool/system used} | {marker} |

### Rollback Communication

| Audience | Channel | Timing | Message Template |
|----------|---------|--------|-----------------|
| {audience} | {channel} | {when} | {template} |
| ... | | | |

---

## 7. Release Calendar

### Planned Releases

| Release | Version | Target Date | Scope | Stories | Points | Confidence |
|---------|---------|-------------|-------|---------|--------|------------|
| MVP | {vX.Y.Z} | {date} | {scope summary} | {N} | {X} | {marker} |
| R2 | {vX.Y.Z} | {date} | {scope summary} | {N} | {X} | {marker} |
| R3 | {vX.Y.Z} | {date} | {scope summary} | {N} | {X} | {marker} |
| GA | {vX.Y.Z} | {date} | {scope summary} | {N} | {X} | {marker} |

### Release Cadence (Post-GA)

| Type | Cadence | Day of Week | Confidence |
|------|---------|-------------|------------|
| Minor | {frequency} | {day} | {marker} |
| Patch | {frequency} | {day} | {marker} |

### Code Freeze Schedule

| Release | Freeze Start | Freeze End | Duration |
|---------|-------------|------------|----------|
| {release} | {date} | {date} | {N days} |
| ... | | | |

### Blackout Periods

| Period | Dates | Reason |
|--------|-------|--------|
| {name} | {date range} | {reason} |

---

## 8. Release Metrics (DORA)

### Metric Definitions

| Metric | Definition | Measurement Method | Confidence |
|--------|-----------|-------------------|------------|
| Deployment Frequency | {how often to production} | {tool/method} | {marker} |
| Lead Time for Changes | {commit to production} | {tool/method} | {marker} |
| Change Failure Rate | {% deploys causing failure} | {tool/method} | {marker} |
| MTTR | {time to recover from failure} | {tool/method} | {marker} |

### Initial Targets

| Metric | Target | Maturity Level | Confidence |
|--------|--------|---------------|------------|
| Deployment Frequency | {target} | {level} | {marker} |
| Lead Time for Changes | {target} | {level} | {marker} |
| Change Failure Rate | {target} | {level} | {marker} |
| MTTR | {target} | {level} | {marker} |

### Improvement Plan

| Quarter | Focus Metric | Current | Target | Actions |
|---------|-------------|---------|--------|---------|
| {Q} | {metric} | {value} | {target} | {actions} |

---

## Q&A Log

### Pending

#### Q-001 (related: {section})
- **Impact**: {HIGH / MEDIUM / LOW}
- **Question**: {question}
- **Context**: {why this matters}
- **Answer**:
- **Status**: Pending

### Answered -- refine mode only

---

## Readiness Assessment

| Metric | Value |
|--------|-------|
| Total items | {N} |
| ✅ CONFIRMED | {X} ({pct}%) |
| 🔶 ASSUMED | {Y} ({pct}%) |
| ❓ UNCLEAR | {Z} ({pct}%) |
| Q&A Pending | {P} (HIGH: {H}, MEDIUM: {M}, LOW: {L}) |

**Verdict**: {Ready / Partially Ready / Not Ready}
**Reasoning**: {1-2 sentences}

---

## Approval

| Role | Name | Date | Status |
|------|------|------|--------|
| Tech Lead | | | Pending |
| Product Manager | | | Pending |
| Release Manager | | | Pending |
```
