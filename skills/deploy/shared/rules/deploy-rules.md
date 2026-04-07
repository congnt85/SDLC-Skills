# Deploy Phase Rules

Rules specific to all skills in the deploy phase.

---

## Content Rules

### DEP-01: Infrastructure as Code
All environment configurations MUST be defined as code (Terraform, CloudFormation, Docker Compose, Kubernetes manifests, etc.). No manual console-only configurations.

### DEP-02: Environment Parity
Staging and production environments MUST use the same:
- Docker images / runtime versions
- Infrastructure topology (scaled down is OK, different architecture is not)
- Configuration structure (different values are OK, different keys are not)
- Deployment process

### DEP-03: Secret Management
Secrets MUST NOT be stored in:
- Source code or config files
- Docker images
- CI/CD pipeline definitions (inline)

Secrets MUST be managed via dedicated secret management (AWS Secrets Manager, HashiCorp Vault, GitHub Secrets, etc.).

### DEP-04: Rollback Capability
Every deployment MUST have a documented rollback procedure:
- Application rollback (previous version)
- Database rollback (migration revert or forward-fix)
- Configuration rollback
- Rollback MUST be testable and tested

### DEP-05: Health Checks Required
Every deployed service MUST expose:
- Liveness probe (is the process running?)
- Readiness probe (is it ready to serve traffic?)
- Health check endpoint with dependency status

### DEP-06: Zero-Downtime Deployments
Production deployments MUST use a strategy that avoids downtime:
- Blue-green deployment
- Canary deployment
- Rolling update
- The chosen strategy MUST be documented with rationale

### DEP-07: Pipeline Security
CI/CD pipelines MUST include:
- Dependency vulnerability scanning
- Container image scanning (if applicable)
- Secret detection (prevent accidental commits)
- Least-privilege access for pipeline credentials

### DEP-08: Trace to Requirements
Deployment configurations MUST trace to:
- Quality attributes (QA-xxx) — availability, performance SLAs
- Constraints (CON-xxx) — budget, compliance
- Architecture decisions — deployment topology from architecture-final.md

---

## Artifact Rules

### DEP-09: Mermaid Diagrams Required
Pipeline architecture and environment topology MUST include Mermaid diagrams.

### DEP-10: Cost Estimation Required
Environment specifications MUST include estimated monthly/annual costs.
Pipeline costs (build minutes, storage) MUST be estimated.

### DEP-11: Approval Section Required
Every deploy artifact MUST include an Approval section with DevOps Lead and Technical Lead roles.
