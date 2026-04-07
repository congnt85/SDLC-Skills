# Development Workflow Template

Standard format for defining development processes and CI integration.

---

## Branching Strategy

```markdown
### Branch Model: {Git Flow / GitHub Flow / Trunk-Based}

| Branch | Purpose | Lifetime | Merges To |
|--------|---------|----------|-----------|
| main | Production code | Permanent | — |
| develop | Integration branch | Permanent | main |
| feature/{ticket} | Feature development | Sprint | develop |
| bugfix/{ticket} | Bug fixes | Days | develop |
| hotfix/{ticket} | Production fixes | Hours | main + develop |
| release/{version} | Release preparation | Days | main + develop |
```

---

## PR Process

```markdown
### Pull Request Checklist

| # | Check | Required | Automated |
|---|-------|----------|-----------|
| 1 | {check} | Yes/No | Yes/No |
| 2 | {check} | Yes/No | Yes/No |

### Review Requirements
| Criteria | Requirement |
|----------|-------------|
| Minimum reviewers | {N} |
| Required reviewers | {roles} |
| Auto-merge | {conditions} |
```

---

## CI Pipeline Stages

```markdown
| Stage | Trigger | Steps | Gate |
|-------|---------|-------|------|
| Lint | PR opened | ESLint, Prettier check | Must pass |
| Unit Test | PR opened | Jest unit tests | Must pass, coverage ≥{N}% |
| Integration Test | PR approved | Testcontainers | Must pass |
| Build | PR merged | Docker build | Must succeed |
| Deploy Staging | Merge to develop | Deploy to staging | Must succeed |
| E2E Test | Staging deploy | Playwright | Must pass |
| Deploy Prod | Release tag | Deploy to production | Manual approval |
```

---

## Rules

- Branching strategy MUST support the team's release cadence
- All PRs MUST pass CI checks before merge
- Code review MUST be required for all changes
- CI pipeline MUST run tests from test-strategy-final.md
- Hotfix workflow MUST be defined for production incidents
- Environment promotion MUST be automated where possible
