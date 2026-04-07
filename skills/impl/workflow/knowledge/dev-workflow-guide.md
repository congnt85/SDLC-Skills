# Development Workflow Guide

This guide covers techniques and patterns for defining a team's development workflow — how code moves from a developer's machine to production.

---

## 1. Branching Strategy Selection

### GitHub Flow

Simple model: main branch + feature branches.

**How it works:**
- `main` is always deployable
- Create feature branch from `main`
- Open PR when ready for review
- Merge to `main` after approval + CI pass
- Deploy `main` to production after merge

**Best for:**
- Small teams (2-6 developers)
- Continuous deployment (deploy multiple times per day)
- Web applications and SaaS products
- Single deployable unit (monolith or modular monolith)
- Teams that do not need scheduled releases

**Strengths:** Minimal ceremony, fast feedback, simple mental model.
**Weaknesses:** No staging branch, harder to manage multiple release versions.

### Git Flow

Structured model: main, develop, feature, release, and hotfix branches.

**How it works:**
- `main` holds production code (tagged releases)
- `develop` is the integration branch
- Feature branches created from `develop`, merged back to `develop`
- Release branches created from `develop` for stabilization
- Hotfix branches created from `main` for emergency fixes
- Release and hotfix branches merge to both `main` and `develop`

**Best for:**
- Larger teams (6+ developers)
- Scheduled releases (weekly, biweekly, monthly)
- Products requiring multiple supported versions
- Teams needing a formal release stabilization period

**Strengths:** Clear release process, parallel release preparation, version management.
**Weaknesses:** More ceremony, slower feedback loop, merge complexity.

### Trunk-Based Development

Minimal branching: main branch + very short-lived branches (less than 1 day).

**How it works:**
- All developers commit to `main` (or very short-lived branches)
- Feature branches live less than 1 day
- Incomplete features hidden behind feature flags
- Continuous integration runs on every commit
- Release from `main` at any time (release branches optional for stabilization)

**Best for:**
- Experienced teams with strong CI discipline
- Teams with comprehensive automated testing
- Products using feature flags for release control
- High-frequency deployment (multiple times per day)

**Strengths:** Fastest feedback, minimal merge conflicts, continuous integration by design.
**Weaknesses:** Requires mature CI/CD, feature flag management overhead, demands discipline.

### Decision Criteria

| Factor | GitHub Flow | Git Flow | Trunk-Based |
|--------|------------|----------|-------------|
| Team size | Small (2-6) | Large (6+) | Any (with maturity) |
| Release cadence | Continuous | Scheduled | Continuous |
| CI maturity | Medium | Low-Medium | High |
| Feature flags | Optional | Rarely needed | Required |
| Version support | Single | Multiple | Single |
| Ceremony level | Low | High | Very low |
| Merge complexity | Low | Medium-High | Very low |

**Recommendation approach:** Start with GitHub Flow unless you have a specific reason for the others. Move to Trunk-Based as CI maturity increases. Use Git Flow only when scheduled releases or multiple versions are genuinely required.

---

## 2. Branch Naming Conventions

### Standard Format

```
{type}/{ticket-id}-{short-description}
```

### Branch Types

| Type | Purpose | Example |
|------|---------|---------|
| `feature/` | New functionality | `feature/US-001-github-webhook` |
| `bugfix/` | Non-urgent bug fix | `bugfix/US-010-board-loading-error` |
| `hotfix/` | Urgent production fix | `hotfix/PROD-042-auth-bypass` |
| `chore/` | Maintenance, dependencies | `chore/upgrade-nestjs-10` |
| `docs/` | Documentation only | `docs/api-authentication-guide` |
| `refactor/` | Code restructuring | `refactor/US-015-extract-auth-module` |
| `test/` | Test additions only | `test/US-020-webhook-integration` |

### Naming Rules

- **Lowercase only** -- no uppercase letters
- **Hyphens as separators** -- no underscores or spaces
- **Include ticket ID** -- for traceability to backlog items
- **Max 50 characters** -- keep it readable in git log
- **Imperative description** -- describe what the branch does, not what it is
- **No special characters** -- only alphanumeric, hyphens, and forward slash

### Examples

Good:
- `feature/US-001-github-webhook`
- `bugfix/US-010-fix-board-loading`
- `hotfix/PROD-042-patch-auth-bypass`

Bad:
- `Feature/US-001` (uppercase)
- `us-001` (no type prefix)
- `feature/implement_the_new_github_webhook_integration_for_boards` (too long)
- `johns-branch` (no ticket, no type)

---

## 3. Pull Request Best Practices

### PR Size Guidelines

| Size | Lines Changed | Recommendation |
|------|--------------|----------------|
| Small | < 200 | Ideal -- easy to review thoroughly |
| Medium | 200-400 | Acceptable -- review in one session |
| Large | 400-600 | Flag -- consider splitting |
| Too large | > 600 | Split required -- break into stacked or sequential PRs |

**Why small PRs matter:** Review quality drops sharply above 400 lines. Large PRs get rubber-stamped. Small PRs get merged faster and have fewer defects.

### PR Template

A good PR template captures:
- **Title**: Imperative mood, reference ticket (e.g., "US-001: Add GitHub webhook endpoint")
- **Description**: What changed and WHY (not just what)
- **Related tickets**: Link to backlog items for traceability
- **Changes**: Bullet list of key changes
- **Screenshots**: Required for UI changes
- **Testing**: How to verify the change
- **Checklist**: DoD items, tests, docs, migrations

### Review Assignment Strategies

| Strategy | How it works | Best for |
|----------|-------------|----------|
| Round-robin | Rotate through team members | Equal load distribution |
| Expertise-based | Assign by domain knowledge | Complex domains |
| CODEOWNERS | Auto-assign by file path | Large repos with clear ownership |
| Self-select | Developers pick from queue | Autonomous teams |

### Merge Strategies

| Strategy | Result | Best for |
|----------|--------|----------|
| Squash merge | One commit per PR on main | Clean linear history, GitHub Flow |
| Merge commit | Preserve branch history | Git Flow, audit trail |
| Rebase merge | Linear history without merge commits | Trunk-Based, clean git log |

**Recommendation:** Squash merge for most teams. It keeps `main` history clean and each commit corresponds to one PR/feature.

---

## 4. Code Review Standards

### What Reviewers Should Check

| Category | What to look for | Priority |
|----------|-----------------|----------|
| **Correctness** | Does it work? Edge cases handled? | Critical |
| **Design** | Does it fit the architecture? Right abstractions? | High |
| **Security** | Input validation? Auth checks? SQL injection? XSS? | Critical |
| **Testing** | Adequate coverage? Right test types? Edge cases? | High |
| **Readability** | Can others understand this in 6 months? | Medium |
| **Performance** | N+1 queries? Memory leaks? Unnecessary loops? | Medium |
| **Error handling** | Failures handled gracefully? Logging adequate? | High |

### What NOT to Review Manually

- **Style and formatting** -- automate with Prettier, Black, gofmt
- **Linting violations** -- automate with ESLint, Pylint, Clippy
- **Import ordering** -- automate with eslint-plugin-import, isort
- **Type errors** -- automate with TypeScript, mypy, type checkers

**Rule:** If a machine can check it, do not ask a human to check it.

### Review Turnaround SLA

| PR Type | Turnaround | Rationale |
|---------|-----------|-----------|
| Feature PR | < 4 hours (business hours) | Balance between speed and thoroughness |
| Bugfix PR | < 4 hours (business hours) | Same as feature |
| Hotfix PR | < 1 hour (any time) | Production is impacted |
| Chore/Docs PR | < 8 hours (business hours) | Lower urgency |

### Review Etiquette

- **Be specific** -- point to the exact line, explain why it is a problem
- **Suggest alternatives** -- do not just say "this is wrong", show a better way
- **Prefix nitpicks** -- use "nit:" for non-blocking style comments
- **Distinguish blockers** -- clearly mark "BLOCKER:" for must-fix items
- **Praise good work** -- call out clever solutions and clean code
- **Assume good intent** -- ask "why was this done this way?" before criticizing
- **Approve with comments** -- if only nitpicks remain, approve and trust the author

---

## 5. CI Pipeline Design

### Pipeline Stages

#### Pre-commit (Local)

Runs on the developer's machine before each commit.

- **Tools**: husky + lint-staged (Node.js), pre-commit (Python)
- **Checks**: lint, format, type check on staged files only
- **Duration target**: < 10 seconds
- **Purpose**: Catch trivial issues before they hit CI

#### PR Pipeline

Runs on every push to a PR branch.

- **Stages**: lint -> type check -> unit tests -> integration tests -> build -> coverage report
- **Duration target**: < 15 minutes total
- **Gate**: All stages must pass before merge is allowed (blocking)
- **Parallelism**: Run lint + type check in parallel, then tests, then build

#### Post-merge Pipeline

Runs after PR is merged to main/develop.

- **Stages**: deploy to staging -> E2E tests -> performance check
- **Duration target**: < 15 minutes
- **Gate**: E2E tests blocking (rollback staging if fail), performance advisory
- **Trigger**: Automatic on merge to main

#### Release Pipeline

Runs when a release is triggered.

- **Stages**: deploy to production -> smoke tests -> monitoring check
- **Duration target**: < 10 minutes (deploy + verify)
- **Gate**: All stages blocking
- **Trigger**: Manual (tag push) or automatic (depending on branching model)

### Cache Strategies

- **Package manager cache** -- cache node_modules, pip packages, go modules between runs
- **Docker layer cache** -- cache Docker build layers for faster image builds
- **Build cache** -- cache compiled outputs (TypeScript, Webpack, etc.)
- **Test cache** -- cache test dependencies (testcontainers images, browser binaries)

### Pipeline Optimization

- Run independent stages in parallel (lint + type check)
- Fail fast: put fastest checks first
- Use incremental builds where possible
- Cache aggressively but invalidate correctly
- Use matrix builds for multi-version testing only when needed

---

## 6. Commit Message Format

### Conventional Commits

```
{type}({scope}): {description}

{body}

{footer}
```

### Commit Types

| Type | Purpose | Triggers |
|------|---------|----------|
| `feat` | New feature | Minor version bump |
| `fix` | Bug fix | Patch version bump |
| `chore` | Maintenance | No version bump |
| `docs` | Documentation | No version bump |
| `test` | Test changes | No version bump |
| `refactor` | Code restructuring | No version bump |
| `perf` | Performance improvement | Patch version bump |
| `ci` | CI/CD changes | No version bump |
| `style` | Formatting only | No version bump |

### Rules

- **Subject line**: imperative mood, lowercase, no period, max 72 chars
- **Scope**: module or component name (e.g., `auth`, `board`, `webhook`)
- **Body**: explain WHY the change was made, not WHAT was changed
- **Footer**: reference issues (Closes #123), note breaking changes

### Examples

```
feat(webhook): add GitHub webhook endpoint for board sync

Implements the webhook receiver that listens for GitHub issue events
and creates corresponding cards on the board. Uses HMAC signature
verification for security.

Closes US-001
```

```
fix(board): prevent duplicate cards on concurrent webhook events

Added idempotency check using GitHub event ID to prevent duplicate
card creation when webhooks are retried.

Closes US-010
```

### Enforcement

- **commitlint** -- validates commit message format on commit (via husky)
- **CI check** -- validate all PR commit messages in CI pipeline
- **Benefits**: auto-generated changelogs, semantic version bumps, clear git history

---

## 7. Hotfix Process

### When to Hotfix

A hotfix is appropriate when:
- Production is broken or degraded
- Users are actively impacted
- The fix cannot wait for the next regular release
- Security vulnerability is discovered

A hotfix is NOT appropriate for:
- Non-critical bugs that can wait
- Feature changes disguised as fixes
- Performance improvements (unless causing outages)

### Hotfix Steps

1. **Create hotfix branch** from `main` (not `develop`): `hotfix/PROD-xxx-description`
2. **Minimal fix only** -- fix the reported issue, nothing else. No refactoring, no cleanup.
3. **Expedited review** -- 1 reviewer (not the usual 2), turnaround < 1 hour
4. **Merge to main** -- squash merge, deploy immediately
5. **Cherry-pick to develop** (Git Flow) or let main propagate (GitHub Flow)
6. **Deploy immediately** to production
7. **Post-incident review** within 24 hours -- root cause, prevention, timeline

### Hotfix Rules

- Hotfix should ONLY fix the reported issue -- nothing else
- Scope creep in hotfixes is the #1 cause of hotfix failures
- If the fix is complex (> 2 hours), consider a rollback instead
- Always run the full PR pipeline even for hotfixes (no skipping tests)
- Document the hotfix in the incident log
