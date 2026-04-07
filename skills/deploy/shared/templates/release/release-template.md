# Release Management Template

Standard format for defining release processes.

---

## Release Checklist

```markdown
### Release {version}

| Field | Value |
|-------|-------|
| **Version** | {semver} |
| **Release Date** | {date} |
| **Release Manager** | {name} |
| **Type** | Major / Minor / Patch / Hotfix |
| **Status** | Planning / Ready / Deploying / Deployed / Rolled Back |

**Pre-Release Checklist**:
- [ ] All tests pass on staging
- [ ] Performance benchmarks met
- [ ] Security scan clean
- [ ] Changelog generated
- [ ] Stakeholder sign-off obtained
- [ ] Rollback plan verified

**Post-Release Checklist**:
- [ ] Production smoke tests pass
- [ ] Monitoring dashboards checked
- [ ] Release notes published
- [ ] Team notified
```

---

## Changelog Format

```markdown
## [{version}] — {date}

### Added
- {new feature} (US-xxx)

### Changed
- {modification} (US-xxx)

### Fixed
- {bug fix} (BUG-xxx)

### Security
- {security fix}
```

---

## Rules

- Every release MUST have a version following semantic versioning
- Changelog MUST trace changes to user stories or bug tickets
- Pre-release and post-release checklists MUST be completed
- Rollback plan MUST be verified before every release
- Release approval MUST be obtained from designated stakeholders
