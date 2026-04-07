# CI/CD Pipeline Template

Standard format for defining CI/CD pipeline configurations.

---

## Pipeline Stage Format

```markdown
### Stage: {Stage Name}

| Field | Value |
|-------|-------|
| **Trigger** | {what triggers this stage} |
| **Runner** | {execution environment} |
| **Timeout** | {max duration} |
| **Gate** | Blocking / Advisory |
| **Artifacts** | {what this stage produces} |

**Steps**:
1. {step 1}
2. {step 2}

**Environment Variables**:
| Variable | Source | Description |
|----------|--------|-------------|
| {var} | {source} | {desc} |

**Failure Action**: {what happens on failure}
```

---

## Pipeline Overview Diagram

```mermaid
graph LR
    A[Source] --> B[Build]
    B --> C[Test]
    C --> D[Staging]
    D --> E[Production]
```

---

## Rules

- Every stage MUST specify trigger, gate type, and failure action
- Blocking stages MUST pass before next stage runs
- Pipeline MUST include build, test, and deploy stages at minimum
- Secret variables MUST reference secret store, not inline values
- Pipeline duration targets MUST be specified
