# Output Rules -- deploy/cicd

CI/CD pipeline-specific output constraints. These supplement the project-wide rules in `skills/shared/rules/` and phase rules in `deploy/shared/rules/`.

---

## Pipeline Content Rules

### CIC-01: Minimum Pipeline Stages
Pipeline MUST include at minimum: build, test, security scan, and deploy stages.
A pipeline missing any of these four categories is incomplete and must not be submitted.

### CIC-02: Stage Specification
Every stage MUST specify:
- **Trigger**: What event initiates this stage (PR, merge, tag, schedule)
- **Gate type**: Blocking (must pass) or Advisory (may fail without stopping pipeline)
- **Timeout**: Maximum duration before the stage is killed

### CIC-03: Pipeline Diagram
Pipeline MUST include a Mermaid diagram showing:
- Stage flow (sequential and parallel)
- Gate/merge points
- Pipeline type labels (PR pipeline vs deploy pipeline)

### CIC-04: Test Strategy Alignment
Test stages MUST match `test-strategy-final.md`:
- Same test tools (e.g., Jest, Cypress, etc.)
- Same coverage gates (e.g., 80% line coverage)
- Same test categories (unit, integration, E2E)

If test-strategy specifies a tool or gate, the pipeline must reference it. If the pipeline omits or changes a test tool, it must include a Q&A entry explaining why.

### CIC-05: Per-Environment Deployment Strategy
Deployment strategy MUST be specified for each environment (staging, production, etc.) with justification:
- Why this strategy was chosen for this environment
- Trade-offs acknowledged (cost, complexity, rollback speed)

### CIC-06: Rollback Procedure
Rollback procedure MUST be defined as automated or semi-automated with clear steps:
- Trigger condition (health check failure, error rate threshold, manual)
- Rollback action (redeploy previous version, switch traffic, revert migration)
- Verification step (smoke test after rollback)

### CIC-07: Minimum Security Scanning
Security scanning MUST include at minimum:
- Dependency scanning (npm audit, pip audit, Snyk, etc.)
- Secret detection (gitleaks, trufflehog, etc.)

Additional scanning (container scanning, SAST, DAST) is recommended but not required.

### CIC-08: Secret Management
Pipeline secrets MUST reference a secret management solution:
- GitHub Secrets, GitLab CI/CD Variables, AWS Secrets Manager, Vault, etc.
- Secrets MUST NEVER appear inline in pipeline configuration examples
- If example YAML is included, use placeholder syntax (e.g., `${{ secrets.API_KEY }}`)

---

## Format Rules

### CIC-09: Section Order
CI/CD pipeline output MUST follow this section order:
1. Pipeline Overview (with Mermaid diagram)
2. Pipeline Stages (detailed per-stage specifications)
3. Build Configuration (Dockerfile, caching, artifacts)
4. Deployment Strategies (per-environment)
5. Security Pipeline (scanning tools, gates)
6. Pipeline Performance (targets, caching, costs)
7. Notification & Monitoring
8. Q&A Log
9. Readiness Assessment
10. Approval

Do not add, remove, or reorder sections.

### CIC-10: Confidence Markers
Every pipeline configuration decision MUST carry a confidence marker:
- ✅ CONFIRMED — derived directly from source documents (tech-stack, test-strategy, dev-workflow)
- 🔶 ASSUMED — reasonable inference not explicitly stated in source documents
- ❓ UNCLEAR — requires stakeholder input to resolve

### CIC-11: Quality Scorecard in Refine Mode
In refine mode, BEFORE applying changes, generate a Quality Scorecard covering:
- **Completeness**: Are all required stages present? All environments covered?
- **Alignment**: Do test stages match test-strategy? Do build tools match tech-stack?
- **Security**: Are all minimum security scans included?
- **Performance**: Are duration targets specified? Is caching documented?
- **Rollback**: Is rollback procedure defined for each environment?

Present this scorecard to the user before asking what to improve.

---

## Performance Rules

### CIC-12: Duration Targets
Pipeline duration targets MUST be specified for:
- PR / feature branch pipeline (recommended: < 15 min)
- Deploy / main branch pipeline (recommended: < 10 min)

If estimated duration exceeds targets, include optimization recommendations.

### CIC-13: Caching Strategy
Caching strategy MUST be documented:
- What is cached (dependencies, Docker layers, build output)
- Cache key strategy (lockfile hash, branch, etc.)
- Estimated time savings

### CIC-14: Cost Estimation
Cost estimation MUST include:
- Build minutes per month (estimated from pipeline frequency and duration)
- Infrastructure costs (artifact registry, runners if self-hosted)
- Total estimated monthly cost

---

## Refine Mode Rules

### CIC-15: TBD Reduction Target
Each refine round should aim to reduce [TBD] count by at least 30%.
If no TBDs were resolved, flag this in the Diff Summary.

### CIC-16: ID Prefixes

| Section | Prefix |
|---------|--------|
| Pipeline stages | STG- |
| Q&A entries | Q- |
