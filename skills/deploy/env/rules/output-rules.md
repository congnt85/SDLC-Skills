# Environment Specification Output Rules

Rules specific to the environment specification skill output. These supplement the shared rules in `skills/shared/rules/` and `deploy/shared/rules/deploy-rules.md`.

---

## ENV-01: Minimum Environment Count

At minimum 3 environments MUST be specified: development, staging, and production. Additional environments (CI, performance) are recommended but not required.

## ENV-02: Infrastructure Sizing Required

Every environment MUST include infrastructure components with explicit sizing: CPU (vCPU), memory (GB), and storage (GB). Vague descriptions like "small" or "medium" are insufficient -- use concrete values.

## ENV-03: Production High Availability

Production environment MUST include high-availability configuration:
- Multi-AZ deployment for database and compute
- Standby/replica for database
- Minimum 2 instances for application tier
- Load balancer with health checks

## ENV-04: Scaling Policies for Production

Scaling policies MUST be defined for production with:
- Auto-scaling metric (CPU, memory, queue depth, or custom)
- Threshold value that triggers scaling (e.g., CPU >70%)
- Minimum and maximum instance counts
- Cooldown period between scaling events

## ENV-05: Network Security

Network security MUST include:
- VPC with CIDR block specification
- Public and private subnet separation
- Security groups with explicit port/source rules
- SSL/TLS configuration with minimum TLS version
- WAF or equivalent for public-facing endpoints (at minimum noted as planned)

## ENV-06: Secret Separation

Configuration management MUST separate secrets from non-secret configuration:
- Secrets stored in dedicated secret management (Secrets Manager, Vault, etc.)
- Non-secret config in parameter store, config files, or environment variables
- Clear categorization of which variables are secrets vs config
- .env.example (or equivalent) documenting all required variables without actual secret values

## ENV-07: Backup Strategy

Backup strategy MUST specify for every database:
- Backup schedule (frequency: daily, hourly, continuous)
- Retention period (e.g., 7 days, 30 days)
- Recovery procedure (step-by-step, not just "restore from backup")
- Point-in-time recovery capability (if supported by database engine)

## ENV-08: RPO and RTO Targets

RPO (Recovery Point Objective) and RTO (Recovery Time Objective) MUST be specified for production:
- RPO: Maximum acceptable data loss (e.g., 1 hour)
- RTO: Maximum acceptable downtime (e.g., 30 minutes)
- Alignment with quality attributes from scope document (QA-xxx availability targets)
- If no scope document available, state assumptions with ASSUMED confidence

## ENV-09: Section Order

Environment specification MUST follow this section order:
1. Environment Overview
2. Infrastructure Topology
3. Service Specifications
4. Networking & Security
5. Configuration Management
6. Scaling Policies
7. Backup & Disaster Recovery
8. Monitoring & Observability
9. Cost Estimation
10. Q&A Log
11. Readiness Assessment
12. Approval

## ENV-10: Confidence on Sizing Decisions

Every sizing decision (instance type, CPU, memory, storage, replicas) and every scaling decision (threshold, min/max) MUST have a confidence marker:
- ✅ CONFIRMED — validated by load testing, vendor recommendation, or explicit stakeholder decision
- 🔶 ASSUMED — based on heuristics, team experience, or similar project benchmarks
- ❓ UNCLEAR — insufficient information, needs stakeholder or architect input

## ENV-11: Refine Mode Scorecard First

In refine mode, the quality scorecard MUST be presented before any changes are applied. The scorecard evaluates the existing draft against all ENV rules and identifies gaps.

## ENV-12: Production Deployment Diagram

A Mermaid deployment diagram MUST be included for the production environment showing:
- All services and their placement (compute, database, cache, CDN)
- Network boundaries (VPC, subnets, availability zones)
- Traffic flow (load balancer to services to data stores)
- External integrations

## ENV-13: Cost Estimation Completeness

Cost estimation MUST include:
- Per-environment monthly cost breakdown (compute, database, cache, storage, network, monitoring)
- Monthly total across all environments
- Annual total projection
- At least one cost optimization recommendation

## ENV-14: Environment Parity Documentation

Staging-to-production parity MUST be explicitly documented:
- What is identical (Docker images, config keys, deployment process)
- What differs and why (instance sizes, replica counts, data, access controls)
- Any parity gaps that could cause staging-passes-but-production-fails scenarios
