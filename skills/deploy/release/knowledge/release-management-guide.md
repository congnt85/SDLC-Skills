# Release Management Guide

This guide covers release management techniques and best practices for building a release plan. Use this as domain knowledge when generating or refining release plan outputs.

---

## 1. Semantic Versioning

Semantic Versioning (semver.org) uses the format **MAJOR.MINOR.PATCH**.

### Version Bump Rules

| Component | When to Bump | Example |
|-----------|-------------|---------|
| **MAJOR** | Incompatible API changes, breaking changes, major architectural shifts | 1.0.0 -> 2.0.0 |
| **MINOR** | New functionality added in a backward-compatible manner | 1.0.0 -> 1.1.0 |
| **PATCH** | Backward-compatible bug fixes only | 1.0.0 -> 1.0.1 |

### Pre-release Identifiers

Pre-release versions use a hyphen suffix:

- **-alpha.N** — Internal testing. Not feature-complete. May be unstable. Example: `0.1.0-alpha.1`
- **-beta.N** — Stakeholder preview. Feature-complete for the release scope but may have known issues. Example: `0.1.0-beta.1`
- **-rc.N** — Release candidate. Believed ready for production. Only critical fixes allowed after this point. Example: `0.1.0-rc.1`

Pre-release precedence: `alpha < beta < rc < release`. So `1.0.0-alpha.1 < 1.0.0-beta.1 < 1.0.0-rc.1 < 1.0.0`.

### Build Metadata

Build metadata uses a plus suffix: `1.0.0+build.123`, `1.0.0+20260401`. Build metadata MUST be ignored when determining version precedence -- two versions that differ only in build metadata are equal.

### Pre-production Versioning

- Use **0.x.y** for all pre-production releases (before first GA). The leading zero signals that the API is not yet stable.
- **0.1.0** = first MVP alpha/beta. Anything may change.
- **0.x.y** increments follow semver rules but with the understanding that breaking changes can happen in minor bumps.
- **1.0.0** = first production-ready (GA) release. This is a deliberate decision, not an accident.

### Common Mistakes

- Bumping PATCH for new features (should be MINOR)
- Skipping version numbers (1.0.0 -> 1.2.0 without a 1.1.0) -- allowed but confusing
- Using 1.0.0 too early before the product is production-ready
- Not resetting PATCH to 0 when bumping MINOR (1.2.3 -> 1.3.0, not 1.3.3)
- Treating pre-release versions as stable releases

---

## 2. Release Types & Processes

### Regular Release (Planned)

A scheduled release that follows the full process:

1. **Code freeze** -- Stop merging feature branches. Only bug fixes allowed.
2. **Release branch** -- Create `release/vX.Y.Z` from main/develop.
3. **Staging deploy** -- Deploy release branch to staging environment.
4. **Testing** -- QA runs regression tests, stakeholders do UAT.
5. **Approval** -- Collect sign-offs per approval matrix.
6. **Production deploy** -- Deploy to production via CI/CD pipeline.
7. **Verification** -- Run smoke tests, monitor metrics.
8. **Announcement** -- Notify stakeholders, update changelog, close milestone.

Timeline: typically 2-5 days from code freeze to production.

### Hotfix Release (Unplanned)

An emergency fix for a critical production issue:

1. **Branch** -- Create `hotfix/vX.Y.Z` from the production tag (not from develop).
2. **Fix** -- Apply the minimal fix. No feature work.
3. **Review** -- Expedited code review (at least one reviewer).
4. **Test** -- Automated tests + targeted manual testing of the fix.
5. **Deploy** -- Deploy directly to production.
6. **Backport** -- Merge the fix back to develop/main.
7. **Post-mortem** -- Document what happened, why, and how to prevent recurrence.

Timeline: target 2-4 hours from detection to production deploy.

### Feature Release (Flag-based)

A release that enables a feature already deployed behind a feature flag:

1. **Verify** -- Confirm the feature works in production (shadow/canary testing done).
2. **Enable** -- Flip the feature flag for target users or all users.
3. **Monitor** -- Watch metrics for anomalies.
4. **Announce** -- Notify stakeholders.

Timeline: minutes to hours. No code deployment needed.

### Rollback (Not a Release)

Rollback is not a "release" but follows a documented process:

1. **Detect** -- Monitoring alert or user report.
2. **Decide** -- Incident commander decides to rollback within defined time threshold.
3. **Revert** -- Deploy previous known-good version.
4. **Verify** -- Confirm rollback resolved the issue.
5. **Communicate** -- Update status page, notify stakeholders.
6. **Post-mortem** -- Analyze root cause, plan forward-fix.

---

## 3. Changelog Best Practices

### Keep a Changelog Format

The standard format (keepachangelog.com) organizes changes by type:

```markdown
## [1.2.0] - 2026-07-15

### Added
- Task dependency visualization on sprint board (US-040)
- Velocity chart with historical data (US-041)

### Changed
- Improved webhook retry logic with exponential backoff

### Deprecated
- Legacy CSV export (use JSON export instead)

### Removed
- Unused /api/v1/legacy endpoint

### Fixed
- Sprint board not updating when task moved via API (US-012)
- Incorrect burndown calculation for partial-day work

### Security
- Updated dependency X to patch CVE-2026-XXXX
```

### Auto-generation from Conventional Commits

Map conventional commit prefixes to changelog sections:

| Commit Prefix | Changelog Section |
|--------------|-------------------|
| `feat:` | Added |
| `fix:` | Fixed |
| `docs:` | (omit from user-facing changelog) |
| `style:` | (omit) |
| `refactor:` | (omit or Changed if user-facing) |
| `perf:` | Changed |
| `test:` | (omit) |
| `build:` | (omit) |
| `ci:` | (omit) |
| `chore:` | (omit) |
| `BREAKING CHANGE:` | (flag in Added/Changed with breaking notice) |
| `security:` or `vuln:` | Security |
| `deprecate:` | Deprecated |

Tools: `standard-version`, `conventional-changelog`, `release-please`, `semantic-release`.

### Traceability

- Every user-facing changelog entry SHOULD reference a user story ID (US-xxx) or ticket number.
- Link to pull requests for developer audience.
- Include the full diff link between versions at the bottom.

### Audience

Write for two audiences:
- **Developers**: Technical details, API changes, breaking changes, migration steps.
- **Stakeholders**: Business value, new capabilities, resolved issues in plain language.

Do NOT include internal refactors, test improvements, or CI changes in user-facing changelogs.

---

## 4. Release Approval Workflow

### Gate Criteria

Before any release can be approved, these criteria must be met:

| Criterion | Evidence | Tool |
|-----------|----------|------|
| All CI tests pass | Green pipeline | CI/CD system |
| Code coverage meets threshold | Coverage report (e.g., >= 80%) | Coverage tool |
| No Critical or High severity bugs | Bug tracker query | Issue tracker |
| Performance benchmarks met | Load test results | Performance tool |
| Security scan clean | SAST/DAST report, no critical findings | Security scanner |
| Stakeholder demo completed | Demo sign-off (for minor/major releases) | Meeting notes |
| Changelog reviewed | Changelog PR approved | Git platform |
| Rollback plan documented | Rollback section in release plan | Release plan |

### Approvers by Release Type

| Release Type | Approvers | Target Turnaround |
|-------------|-----------|-------------------|
| Patch (bug fixes only) | Tech Lead | 1 hour |
| Minor (new features) | Tech Lead + Product Manager | 4 hours |
| Major (breaking changes) | Tech Lead + PM + Stakeholders | 24 hours |
| Hotfix (emergency) | Tech Lead (post-deploy review by PM) | 30 minutes |

### Evidence Package

For each release, assemble:
1. Test execution report (pass/fail counts, duration)
2. Code coverage report (line and branch coverage)
3. Security scan results (SAST, dependency audit)
4. Performance test results (if applicable)
5. Changelog draft
6. Known issues list (if any)

---

## 5. Rollback Strategy

### Application Rollback

- **Method**: Deploy the previous Docker image, container task definition, or build artifact.
- **Target time**: < 5 minutes.
- **Prerequisite**: Previous version's artifact must be retained (do not delete old images/artifacts for at least N releases).
- **Steps**: Trigger rollback deployment -> verify health checks pass -> run smoke tests -> confirm.
- **Blue/green or canary**: If using blue/green deployment, rollback is instant (switch traffic back). If using canary, stop the rollout and route 100% to old version.

### Database Rollback

- **Preferred approach**: Forward-fix. Write a new migration that fixes the issue rather than rolling back the schema change.
- **Why forward-fix**: Rollback migrations are risky -- you cannot safely drop a column that received new data, and rollback migrations are rarely tested.
- **When rollback migration is needed**: Must be pre-written and tested as part of the release. Only safe for additive changes (add column, add table). Never drop columns with data in a rollback.
- **Target time**: < 15 minutes (including verification).
- **Rule**: Every migration MUST have a corresponding rollback migration, tested in CI, even if forward-fix is preferred.

### Configuration Rollback

- **Method**: Revert the configuration change in the config management system (e.g., AWS Parameter Store, Consul, environment variables).
- **Target time**: < 5 minutes.
- **Steps**: Identify changed config -> revert to previous value -> restart affected services (or wait for config reload) -> verify.
- **Version control**: All configuration changes should be version-controlled or have audit trails.

### Communication During Rollback

| Audience | Channel | Timing | Content |
|----------|---------|--------|---------|
| Engineering team | Slack/Teams #deployments | Immediately | "Rolling back vX.Y.Z due to [issue]. ETA: [time]." |
| On-call team | PagerDuty/Slack | Immediately | Incident details, rollback status |
| Status page | Public status page | Within 5 minutes | "We are aware of an issue and are working on a fix." |
| Stakeholders | Email / Slack | Within 30 minutes | Summary of impact, rollback confirmation, next steps |
| End users | In-app banner (if severe) | As needed | "We experienced a brief issue. Service has been restored." |

---

## 6. DORA Metrics

The four key metrics from the DORA (DevOps Research and Assessment) team measure software delivery performance.

### The Four Metrics

| Metric | Definition | How to Measure |
|--------|-----------|----------------|
| **Deployment Frequency** | How often code is deployed to production | Count production deployments per time period |
| **Lead Time for Changes** | Time from first commit to production deployment | Measure commit timestamp to deploy timestamp |
| **Change Failure Rate** | Percentage of deployments causing a failure in production | Failed deploys / total deploys |
| **Mean Time to Recovery (MTTR)** | Time from failure detection to service restoration | Incident start to resolution timestamp |

### Performance Targets by Maturity

| Metric | Elite | High | Medium | Low |
|--------|-------|------|--------|-----|
| Deployment Frequency | Multiple per day | Weekly to monthly | Monthly to semi-annually | Semi-annually+ |
| Lead Time for Changes | < 1 hour | 1 day to 1 week | 1 week to 1 month | 1-6 months |
| Change Failure Rate | < 15% | 16-30% | 16-30% | > 30% |
| MTTR | < 1 hour | < 1 day | < 1 day | 1 week+ |

### Implementation Guidance

- **Start tracking from day one.** Even rough metrics are better than none.
- **Automate measurement.** Use CI/CD pipeline events, deployment timestamps, and incident tracking to calculate metrics automatically.
- **Set realistic initial targets.** New teams should target "High" performance, not "Elite."
- **Improve iteratively.** Focus on one metric at a time. Deployment frequency and lead time are often the easiest to improve first.
- **Tooling**: GitHub Actions (deploy events), Datadog/Grafana (dashboards), PagerDuty/Opsgenie (MTTR), custom scripts pulling from CI/CD API.
- **Review cadence**: Monthly review in retrospectives. Quarterly trend analysis.
