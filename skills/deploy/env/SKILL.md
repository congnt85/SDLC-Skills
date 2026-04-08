---
name: deploy-env
description: >
  Create or refine an environment specification from architecture, tech-stack,
  and CI/CD pipeline artifacts. Defines infrastructure topology, service sizing,
  networking, security, scaling policies, backup/DR, and cost estimation for all
  environments. ONLY activated by command: `/deploy-env`. Use `--create` or
  `--refine` to set mode. NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine [path to architecture-final.md or tech-stack-final.md] (md/pdf/docx/xlsx/pptx)"
version: "1.0"
category: sdlc
phase: deploy
prev_phase: deploy-release
next_phase: ops-monitor
---

# Environment Specification Skill

## Purpose

Create or refine an environment specification document (`env-spec-draft.md`) that defines complete infrastructure topology, service configurations, scaling policies, networking, security, and cost estimation for all environments (development through production).

The environment specification bridges "how we deploy" (CI/CD pipeline, release process) and "how we operate" (monitoring, incident response) by defining the target infrastructure that pipelines deploy to and operations teams manage.

---

## Two Modes

### Mode 1: Create (`--create`)

Generate an environment specification from architecture, tech-stack, and CI/CD pipeline artifacts.

| Input | Required | Source |
|-------|----------|--------|
| Architecture (final) | Yes | `sdlc/design/final/architecture-final.md` or user-specified path |
| Tech stack (final) | Yes | `sdlc/design/final/tech-stack-final.md` or user-specified path |
| CI/CD pipeline (final) | Yes | `sdlc/deploy/final/cicd-pipeline-final.md` or user-specified path |
| Scope (final) | No | `sdlc/init/final/scope-final.md` — quality attributes (availability, performance targets) |
| Charter (final) | No | `sdlc/init/final/charter-final.md` — budget constraints |
| Database design (final) | No | `sdlc/design/final/database-final.md` — database sizing, backup requirements |
| Test plan (final) | No | `sdlc/test/final/test-plan-final.md` — test environment requirements |

### Mode 2: Refine (`--refine`)

Improve existing environment specification based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing env spec draft | Yes | `sdlc/deploy/draft/env-spec-draft.md` or `sdlc/deploy/draft/env-spec-v{N}.md` |
| Review report / feedback | Yes | User provides directly or as `sdlc/deploy/input/review-report.md` |
| Additional details | No | New information the user wants to add |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `env-spec-draft.md` | `sdlc/deploy/draft/` |
| Refine | `env-spec-v{N}.md` | `sdlc/deploy/draft/` (N = next version number) |

When user is satisfied -> they copy from `sdlc/deploy/draft/` to `sdlc/deploy/final/env-spec-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User passes `--refine` argument → **Mode 2 (Refine)**
- User passes `--create` argument → **Mode 1 (Create)**
- No argument specified AND existing draft exists in `sdlc/deploy/draft/` → Ask: "A draft already exists. Use `--create` to start fresh or `--refine` to improve it."
- No argument specified AND no draft exists → **Mode 1 (Create)**

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md` -- document formatting standards
2. `skills/shared/rules/quality-rules.md` -- confidence marking, readiness assessment
3. `skills/shared/rules/output-rules.md` -- versioning, input resolution, diff summary
4. `deploy/shared/rules/deploy-rules.md` -- deployment phase rules
5. `deploy/env/knowledge/environment-design-guide.md` -- environment design techniques
6. `deploy/env/rules/output-rules.md` -- environment-specific output rules
7. `deploy/env/templates/output-template.md` -- expected output structure

### Step 3: Resolve Input

**File Type Conversion** (applies to all file inputs):

Before reading any input file, check its extension:
- `.md` → Read directly, no conversion needed
- `.pdf` → Run `/read-pdf <path> sdlc/deploy/input/` → read the converted .md
- `.docx` / `.doc` → Run `/read-word <path> sdlc/deploy/input/` → read the converted .md
- `.xlsx` / `.xls` → Run `/read-excel <path> sdlc/deploy/input/` → read the converted .md
- `.pptx` / `.ppt` → Run `/read-ppt <path> sdlc/deploy/input/` → read the converted .md

Converted files are saved to `sdlc/deploy/input/`. If a converted .md already exists and is newer than the source, skip conversion.

**Mode 1 (Create):**

```
For architecture input (required):
1. User specified path?                                -> YES -> read it, copy to sdlc/deploy/input/ -> DONE
2. Exists in sdlc/deploy/input/architecture-final.md? -> YES -> read it -> DONE
3. Exists in sdlc/design/final/architecture-final.md? -> YES -> read it, copy to sdlc/deploy/input/ -> DONE
4. Not found? -> Ask: "No architecture document found. Please provide a path or run /design-arch first."

For tech stack input (required):
1. User specified path?                                -> YES -> read it, copy to sdlc/deploy/input/ -> DONE
2. Exists in sdlc/deploy/input/tech-stack-final.md?   -> YES -> read it -> DONE
3. Exists in sdlc/design/final/tech-stack-final.md?   -> YES -> read it, copy to sdlc/deploy/input/ -> DONE
4. Not found? -> Ask: "No tech stack found. Please provide a path or run /design-stack first."

For CI/CD pipeline input (required):
1. User specified path?                                -> YES -> read it, copy to sdlc/deploy/input/ -> DONE
2. Exists in sdlc/deploy/input/cicd-pipeline-final.md? -> YES -> read it -> DONE
3. Exists in sdlc/deploy/final/cicd-pipeline-final.md? -> YES -> read it, copy to sdlc/deploy/input/ -> DONE
4. Not found? -> Ask: "No CI/CD pipeline found. Please provide a path or run /deploy-cicd first."

For scope input (optional):
1. User specified path?                                -> YES -> read it, copy to sdlc/deploy/input/ -> DONE
2. Exists in sdlc/deploy/input/scope-final.md?        -> YES -> read it -> DONE
3. Exists in sdlc/init/final/scope-final.md?           -> YES -> read it, copy to sdlc/deploy/input/ -> DONE
4. Not found? -> Proceed without scope document.

For charter input (optional):
1. User specified path?                                -> YES -> read it, copy to sdlc/deploy/input/ -> DONE
2. Exists in sdlc/deploy/input/charter-final.md?      -> YES -> read it -> DONE
3. Exists in sdlc/init/final/charter-final.md?         -> YES -> read it, copy to sdlc/deploy/input/ -> DONE
4. Not found? -> Proceed without charter document.

For database design input (optional):
1. User specified path?                                -> YES -> read it, copy to sdlc/deploy/input/ -> DONE
2. Exists in sdlc/deploy/input/database-final.md?     -> YES -> read it -> DONE
3. Exists in sdlc/design/final/database-final.md?     -> YES -> read it, copy to sdlc/deploy/input/ -> DONE
4. Not found? -> Proceed without database document.

For test plan input (optional):
1. User specified path?                                -> YES -> read it, copy to sdlc/deploy/input/ -> DONE
2. Exists in sdlc/deploy/input/test-plan-final.md?    -> YES -> read it -> DONE
3. Exists in sdlc/test/final/test-plan-final.md?       -> YES -> read it, copy to sdlc/deploy/input/ -> DONE
4. Not found? -> Proceed without test plan document.
```

**Mode 2 (Refine):**

```
For env spec draft:
1. User specified path?                           -> YES -> read it, copy to sdlc/deploy/input/ -> DONE
2. Exists in sdlc/deploy/input/?                  -> YES -> read it -> DONE
3. Exists in sdlc/deploy/draft/ (latest version)? -> YES -> read it, copy to sdlc/deploy/input/ -> DONE
4. Not found? -> FAIL: "No existing env spec draft found. Run /deploy-env first."

For review report:
1. User provided feedback directly in message?    -> Save to sdlc/deploy/input/review-report.md
2. User specified path?                           -> read it, copy to sdlc/deploy/input/
3. Exists in sdlc/deploy/input/review-report.md? -> read it
4. Not found? -> Ask: "What feedback do you have on the current environment specification?"
```

### Step 4: Generate (Mode-specific)

**Mode 1 -- Create:**

Work through the environment specification **section by section, incrementally**:

1. **Environment Overview** -- Define all environments
   - Identify environments: Development, CI, Staging, Performance (if applicable), Production
   - For each: purpose, access level, data strategy, refresh cadence
   - Generate comparison table (environments x attributes)
   - Present proposed environment list to user before detailing

2. **Infrastructure Topology** -- Per environment details
   - For each environment: compute, database, cache, storage, CDN, load balancer
   - Generate Mermaid deployment diagram for production topology
   - Show component placement across availability zones
   - Map architecture components to cloud services (from tech-stack-final.md)

3. **Service Specifications** -- Detailed sizing
   - For each service per environment: instance type/size, CPU, memory, storage, scaling policy, replicas
   - Use architecture-final.md for service list
   - Apply sizing heuristics from knowledge base
   - Document sizing rationale and scale triggers

4. **Networking & Security** -- Network architecture
   - VPC design with CIDR blocks, subnets (public/private)
   - Security groups with ingress/egress rules (principle of least privilege)
   - SSL/TLS configuration (certificate management, TLS version)
   - WAF rules for public endpoints
   - Access control per environment (who can access what)

5. **Configuration Management** -- Config strategy
   - Environment variable inventory (categorized: app config, secrets, feature flags)
   - Config source hierarchy (defaults, overrides, secrets)
   - Secret management approach (AWS Secrets Manager, Vault, etc.)
   - Config-as-code strategy (how config is versioned and deployed)
   - .env.example reference for local development

6. **Scaling Policies** -- Auto-scaling rules
   - Compute auto-scaling: CPU/memory thresholds, min/max instances, cooldown
   - Database scaling: read replicas, connection pooling, vertical scaling triggers
   - Cache scaling: memory thresholds, cluster mode considerations
   - Queue/worker scaling: queue depth triggers, concurrency limits

7. **Backup & Disaster Recovery** -- Data protection
   - Database backup schedule and retention policy
   - Point-in-time recovery configuration
   - RPO and RTO targets (aligned with scope quality attributes)
   - Recovery procedure (step-by-step)
   - Manual snapshot policy (before releases, before migrations)

8. **Monitoring & Observability** -- Monitoring hooks
   - Health check endpoints per service
   - Log aggregation strategy
   - Metrics collection (infrastructure + application)
   - Alerting integration points (detailed in ops phase)
   - Link to future ops-monitor skill for full monitoring setup

9. **Cost Estimation** -- Financial planning
   - Per environment: monthly compute, database, cache, storage, network, monitoring costs
   - Total monthly and annual costs
   - Cost optimization recommendations
   - Budget alignment (reference charter constraints if available)

For each section:
- Apply confidence markers (CONFIRMED / ASSUMED / UNCLEAR)
- Inherit confidence from source documents where applicable
- Create Q&A entries for ASSUMED and UNCLEAR items
- Present section to user before moving to next

**Mode 2 -- Refine:**

1. Read existing env spec draft (baseline)
2. Read review report / user feedback
3. Run Quality Scorecard analysis
4. Present scorecard to user
5. Apply improvements:
   - Address user feedback point by point
   - Resolve Q&A entries from previous version
   - Upgrade confidence levels where possible
   - Refine sizing and scaling based on new information
   - Update cost estimates if infrastructure changes
6. Tag all changes: `[UPDATED]` for modified items, `[NEW]` for additions
7. Preserve CONFIRMED items unless user explicitly contradicts them
8. Write improved version to `sdlc/deploy/draft/env-spec-v{N}.md`

### Step 5: Validate Output

Check against rules:
- Every item has a confidence marker (CR-01)
- At least 3 environments specified: dev, staging, production (ENV-01)
- Every environment includes infrastructure sizing: CPU, memory, storage (ENV-02)
- Production includes high-availability configuration (ENV-03)
- Scaling policies defined for production with thresholds and limits (ENV-04)
- Network security includes VPC, security groups, SSL/TLS (ENV-05)
- Secrets separated from non-secret configuration (ENV-06)
- Backup strategy with schedule, retention, recovery procedure (ENV-07)
- RPO and RTO targets specified for production (ENV-08)
- Section order matches template (ENV-09)
- Confidence markers on every sizing and scaling decision (ENV-10)
- Mermaid deployment diagram for production topology (ENV-12)
- Cost estimation with monthly and annual totals per environment (ENV-13)
- Staging/production parity documented with differences justified (ENV-14)
- Secrets use secret management, never inline (DEP-03)
- Health checks defined for every deployed service (DEP-05)
- Approval section present (DEP-11)

### Step 6: Readiness Assessment

Generate assessment per `skills/shared/templates/readiness-assessment.md`:
- Count items by confidence level (each service spec is 1 item, each scaling policy is 1 item, each network rule is 1 item)
- Calculate readiness verdict
- In refine mode: compare with previous version

### Step 7: Output

- **Create mode**: Write to `sdlc/deploy/draft/env-spec-draft.md`
- **Refine mode**: Write to `sdlc/deploy/draft/env-spec-v{N}.md`, include Change Log and Diff Summary

Tell the user:
> **Environment Specification {created/refined}!**
> - Output: `sdlc/deploy/draft/env-spec-{version}.md`
> - Readiness: {verdict}
> - Environments: {count} ({list})
> - Services: {total} across all environments
> - Monthly cost: ~${estimate} (annual: ~${estimate})
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/deploy-env --refine`
> - When satisfied, copy to `sdlc/deploy/final/env-spec-final.md`
> - Then run `/ops-monitor` to define monitoring and alerting

---

## Scope Rules

### This skill DOES:
- Define infrastructure topology for all environments (dev through production)
- Specify service sizing (CPU, memory, storage, replicas) per environment
- Design networking architecture (VPC, subnets, security groups, SSL/TLS)
- Define configuration management strategy (env vars, secrets, feature flags)
- Specify scaling policies (auto-scaling thresholds, min/max instances)
- Define backup and disaster recovery procedures (schedule, RPO/RTO)
- Estimate costs per environment (monthly and annual)
- Document environment parity between staging and production

### This skill does NOT:
- Implement actual infrastructure (that's DevOps implementation work -- Terraform, CloudFormation, etc.)
- Define monitoring dashboards or alert rules (belongs to `ops/monitor` skill)
- Manage incidents or runbooks (belongs to `ops/incident` and `ops/runbook` skills)
- Define CI/CD pipeline stages (belongs to `deploy/cicd` skill)
- Define release versioning or changelog (belongs to `deploy/release` skill)
- Make architecture decisions (belongs to `design/` phase)
- Modify source documents -- it reads them as input
