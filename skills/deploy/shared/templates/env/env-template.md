# Environment Specification Template

Standard format for defining deployment environments.

---

## Environment Card

```markdown
### Environment: {Name}

| Field | Value |
|-------|-------|
| **Name** | {Development / Staging / Production} |
| **Purpose** | {what this environment is used for} |
| **URL** | {base URL} |
| **Cloud Provider** | {provider} |
| **Region** | {region} |
| **Owner** | {team/person} |
| **Access** | {who can access} |

**Infrastructure**:
| Component | Service | Spec | Scaling |
|-----------|---------|------|---------|
| Application | {service type} | {CPU/RAM} | {scaling policy} |
| Database | {service type} | {instance type} | {replicas} |
| Cache | {service type} | {instance type} | {cluster size} |

**Configuration**:
| Variable | Value | Source |
|----------|-------|--------|
| {var} | {value or reference} | {secret store / config} |
```

---

## Environment Comparison Table

```markdown
| Aspect | Development | Staging | Production |
|--------|-------------|---------|------------|
| Purpose | {purpose} | {purpose} | {purpose} |
| Scale | {scale} | {scale} | {scale} |
| Data | {data approach} | {data approach} | {data approach} |
| Access | {access} | {access} | {access} |
| Cost | {cost} | {cost} | {cost} |
```

---

## Rules

- Every environment MUST specify infrastructure components with sizing
- Configuration variables MUST be documented (values can be references)
- Scaling policies MUST be defined for production
- Cost estimates MUST be included for each environment
- Data strategy (real/synthetic/subset) MUST be defined per environment
- Network access controls MUST be specified
