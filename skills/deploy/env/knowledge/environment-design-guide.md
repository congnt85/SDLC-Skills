# Environment Design Guide

This guide provides domain knowledge and techniques for designing environment specifications. Use these patterns when building environment specs for any project.

---

## 1. Environment Tier Design

Every project needs multiple environments to support the development lifecycle. Each tier serves a distinct purpose with different requirements for resources, data, and access.

### Standard Tiers

**Development (Local)**
- **Infrastructure**: Docker Compose on developer machines
- **Resources**: Minimal -- enough to run the full stack locally
- **Data strategy**: Seed data or local fixtures; never production data
- **Access**: Individual developers, unrestricted
- **Purpose**: Fast iteration, debugging, feature development
- **Refresh cadence**: Rebuilt on demand (docker-compose up)
- **Cost**: $0 (runs on developer hardware)

**CI (Continuous Integration)**
- **Infrastructure**: Ephemeral containers spun up per pipeline run
- **Resources**: Minimal, disposable -- fresh database per run
- **Data strategy**: Migration + seed scripts; clean state every run
- **Access**: Automated only (pipeline service accounts)
- **Purpose**: Automated testing, build validation, quality gates
- **Refresh cadence**: Created and destroyed per pipeline execution
- **Cost**: Included in CI/CD platform costs (build minutes)

**Staging**
- **Infrastructure**: Production-mirror at smaller scale (same services, fewer/smaller instances)
- **Resources**: 50% of production sizing (enough to validate behavior, not performance)
- **Data strategy**: Anonymized production subset or representative synthetic data
- **Access**: Development team + QA; restricted from external users
- **Purpose**: Integration testing, UAT, pre-production validation, deploy rehearsal
- **Refresh cadence**: Persistent; data refreshed weekly or on demand
- **Cost**: 25-40% of production cost

**Performance (Load Testing)**
- **Infrastructure**: Production-scale resources, dedicated environment
- **Resources**: Matches production sizing to produce meaningful benchmarks
- **Data strategy**: Production-scale synthetic dataset (realistic volume)
- **Access**: Performance engineering team; time-boxed availability
- **Purpose**: Load testing, stress testing, capacity planning, performance benchmarks
- **Refresh cadence**: Provisioned on demand; torn down after test cycles
- **Cost**: Production-level but only active during test windows (typically 2-4 weeks per quarter)

**Production**
- **Infrastructure**: Full scale, high-availability, multi-AZ deployment
- **Resources**: Sized for expected load with headroom for spikes
- **Data strategy**: Real user data with encryption at rest and in transit
- **Access**: Operations team only; strict access controls, audit logging
- **Purpose**: Serving real users; must meet SLA commitments
- **Refresh cadence**: Persistent; never refreshed, only upgraded
- **Cost**: Largest cost center; optimize through reserved instances and right-sizing

### Access Control per Tier

| Environment | SSH/Shell Access | Database Access | Deploy Access | Log Access |
|-------------|-----------------|-----------------|---------------|------------|
| Development | Developer (local) | Developer (local) | Developer (local) | Developer (local) |
| CI | None (automated) | Pipeline only | Pipeline only | Pipeline logs |
| Staging | Dev team (limited) | Dev team (read-only) | Pipeline + leads | Dev team |
| Performance | Perf engineers | Perf engineers (read) | Pipeline + leads | Perf engineers |
| Production | Ops team only | Ops team (read-only, audited) | Pipeline only (approved) | Ops team + on-call |

---

## 2. Infrastructure Sizing

### Start Small, Scale Up

The most common mistake is over-provisioning for MVP. Start with minimum viable infrastructure and scale based on observed metrics. The cost of scaling up is low; the cost of paying for unused resources is ongoing.

### MVP Sizing Heuristics by Workload

**Web API Server**
- Start: 2 instances, 0.5 vCPU, 1GB RAM each
- Handles: ~200-500 requests/second per instance (typical CRUD API)
- Scale trigger: CPU sustained >70% for 5 minutes
- Scale ceiling: 6-8 instances before considering architecture changes

**Relational Database (PostgreSQL/MySQL)**
- Start: Single instance, 2 vCPU, 4GB RAM, 50GB SSD (gp3)
- Handles: ~500 connections, moderate query complexity
- Scale trigger: CPU sustained >70%, read IOPS >1000, connection count >80% max
- Scale path: Vertical first (bigger instance), then read replicas for read-heavy workloads

**Cache (Redis/Memcached)**
- Start: Single node, 1-2 vCPU, 1.5GB RAM
- Handles: ~10,000 operations/second, ~1M cached items
- Scale trigger: Memory usage >80%, cache hit rate <90%, evictions increasing
- Scale path: Add replica for HA, then cluster mode for horizontal scaling

**Background Workers**
- Start: 1 instance, 0.25-0.5 vCPU, 512MB RAM
- Handles: Queue processing, async jobs, scheduled tasks
- Scale trigger: Queue depth >100 sustained, job latency increasing
- Scale path: Add worker instances (horizontally scalable)

**Static Assets / CDN**
- Start: S3 bucket + CDN (CloudFront/CloudFlare)
- Handles: Unlimited with CDN caching
- Scale trigger: N/A (CDN scales automatically)
- Optimization: Set appropriate cache TTLs (24hr for assets, shorter for HTML)

### Right-Sizing Process

1. Deploy with MVP sizing
2. Monitor for 2 weeks under real traffic patterns
3. Review CPU, memory, I/O, and network utilization
4. Adjust: if consistently <30% utilization, scale down; if >70%, scale up
5. Repeat quarterly or after significant feature launches

---

## 3. Cloud Service Selection

### AWS Services Mapped to Architecture Components

| Component | AWS Service | Purpose |
|-----------|------------|---------|
| Container orchestration | ECS (Fargate) | Serverless container hosting, no cluster management |
| Container orchestration (alt) | EKS | Managed Kubernetes for complex workloads |
| Relational database | RDS (PostgreSQL/MySQL) | Managed database with automated backups |
| Cache | ElastiCache (Redis) | In-memory caching and pub/sub |
| Object storage | S3 | Static assets, file uploads, backups |
| CDN | CloudFront | Edge caching for static assets and API |
| Load balancer | ALB (Application LB) | HTTP/HTTPS routing, path-based routing |
| DNS | Route 53 | Domain management, health-check routing |
| SSL/TLS | ACM (Certificate Manager) | Free SSL certificates, auto-renewal |
| Monitoring | CloudWatch | Metrics, logs, alarms |
| Secrets | Secrets Manager | Secret rotation, access-controlled secrets |
| Configuration | Systems Manager Parameter Store | Non-secret configuration, hierarchical |
| Message queue | SQS | Async job processing, decoupling |
| Notifications | SNS | Alerting, event fanout |

### Equivalent Services (Cross-Cloud Reference)

| Component | AWS | GCP | Azure |
|-----------|-----|-----|-------|
| Containers | ECS/Fargate | Cloud Run | Container Apps |
| Kubernetes | EKS | GKE | AKS |
| Database | RDS | Cloud SQL | Azure SQL / PostgreSQL |
| Cache | ElastiCache | Memorystore | Azure Cache for Redis |
| Object storage | S3 | Cloud Storage | Blob Storage |
| CDN | CloudFront | Cloud CDN | Azure CDN |
| Load balancer | ALB | Cloud Load Balancing | Application Gateway |
| Secrets | Secrets Manager | Secret Manager | Key Vault |
| Monitoring | CloudWatch | Cloud Monitoring | Azure Monitor |

### Managed vs Self-Hosted Decision

**Always prefer managed services for MVP.** The rationale:

- **Managed**: Higher per-unit cost, but zero operational overhead. Team focuses on product, not infrastructure. Includes automated backups, patching, scaling.
- **Self-hosted**: Lower per-unit cost, but requires DevOps expertise, on-call burden, patching responsibility, backup management.

**When to consider self-hosted**:
- Cost exceeds 3x managed equivalent at scale
- Specific configuration needs not supported by managed service
- Compliance requires infrastructure in specific locations/configurations
- Team has dedicated DevOps/SRE capacity

---

## 4. Networking Design

### VPC Architecture

Standard VPC layout for a web application:

```
VPC (e.g., 10.0.0.0/16)
├── Public Subnets (2+ AZs)
│   ├── Load Balancer (ALB)
│   ├── NAT Gateway
│   └── Bastion Host (if needed)
├── Private App Subnets (2+ AZs)
│   ├── Application servers / containers
│   └── Background workers
└── Private Data Subnets (2+ AZs)
    ├── Database (RDS)
    └── Cache (ElastiCache)
```

### Subnet Design

- **Public subnets**: Resources that need direct internet access (load balancer ingress, NAT gateway egress)
- **Private app subnets**: Application tier; outbound internet via NAT Gateway, no inbound from internet
- **Private data subnets**: Data tier; no internet access, only accessible from app subnets
- **Multi-AZ**: Minimum 2 availability zones for high availability

### Security Groups (Principle of Least Privilege)

| Security Group | Inbound | Outbound | Purpose |
|---------------|---------|----------|---------|
| ALB-SG | 80/443 from 0.0.0.0/0 | App port to App-SG | Public traffic entry |
| App-SG | App port from ALB-SG only | 5432 to DB-SG, 6379 to Cache-SG, 443 to internet (via NAT) | Application tier |
| DB-SG | 5432 from App-SG only | None | Database access |
| Cache-SG | 6379 from App-SG only | None | Cache access |

### SSL/TLS Configuration

- Use ACM (AWS) or Let's Encrypt for certificate management
- Terminate SSL at the load balancer (simplifies certificate management)
- HTTPS only -- redirect HTTP to HTTPS
- Minimum TLS version: 1.2 (TLS 1.3 preferred)
- HSTS header enabled with 1-year max-age
- WAF for public-facing endpoints (rate limiting, common attack patterns)

---

## 5. Configuration Management

### Configuration Hierarchy

Configuration flows from least specific to most specific, with later values overriding earlier ones:

```
1. Application defaults (hardcoded sensible defaults)
   ↓ overridden by
2. Environment-specific config (Parameter Store / config files)
   ↓ overridden by
3. Secrets (Secrets Manager / Vault)
   ↓ overridden by
4. Runtime overrides (feature flags, dynamic config)
```

### Configuration Categories

**Application Config (non-secret)**
- Database host, port, database name
- Cache host, port
- Log level, log format
- Feature flags
- API rate limits, pagination defaults
- Storage: AWS Parameter Store, config files, environment variables

**Secrets (sensitive)**
- Database password
- API keys (third-party services)
- JWT signing keys
- OAuth client secrets
- Encryption keys
- Storage: AWS Secrets Manager, HashiCorp Vault

**Infrastructure Config**
- Instance types, scaling parameters
- VPC CIDR blocks, subnet ranges
- Security group rules
- Storage: Terraform variables, CloudFormation parameters

### 12-Factor App Principles

- **Config in environment, not code**: No configuration values in source code
- **Strict separation**: Same codebase deploys to all environments; only config differs
- **.env.example**: Committed to repo with placeholder values; documents all required variables
- **.env**: Never committed; each environment provides its own values

### Feature Flags

**MVP approach**: Simple environment variables (FEATURE_X_ENABLED=true/false)
- Pros: Zero additional infrastructure, simple to understand
- Cons: Requires redeploy to change, no gradual rollout

**Scale approach**: Dedicated feature flag service (LaunchDarkly, Unleash, Flagsmith)
- Pros: Runtime toggling, percentage rollouts, user targeting, audit trail
- Cons: Additional cost and dependency
- When to adopt: After MVP stabilizes, when A/B testing or gradual rollouts become necessary

---

## 6. Cost Estimation Techniques

### AWS Pricing Models

**On-Demand (default)**
- Pay per hour/second of usage
- Maximum flexibility, no commitment
- Best for: MVP phase, unpredictable workloads, development environments

**Reserved Instances (1-year or 3-year)**
- Commit to consistent usage for discounts
- Savings: 30-40% (1-year) or 50-60% (3-year)
- Best for: Production databases, persistent compute after traffic patterns stabilize
- When to adopt: After 3+ months of stable production usage

**Spot Instances**
- Use spare AWS capacity at up to 90% discount
- Can be interrupted with 2-minute notice
- Best for: CI/CD runners, batch processing, performance testing
- Never use for: Production application servers, databases

**Savings Plans**
- Flexible alternative to Reserved Instances
- Commit to a dollar amount per hour, applied across services
- Best for: Organizations with multiple services and variable instance types

### Cost Estimation Process

1. **List all resources** per environment (compute, database, cache, storage, network, monitoring)
2. **Use cloud calculator** (AWS Pricing Calculator, GCP Pricing Calculator)
3. **Add 20% buffer** for data transfer, logging, unexpected usage
4. **Multiply by environment count** (staging ~30% of production, dev ~$0)
5. **Review monthly** and adjust based on actual usage

### Cost Optimization Strategies

- **Right-size instances**: Monitor utilization; downsize if consistently <30%
- **Auto-scaling**: Scale down during off-peak hours (if applicable)
- **Reserved instances**: Commit after 3+ months of stable usage
- **S3 lifecycle policies**: Move infrequently accessed data to cheaper storage tiers
- **NAT Gateway optimization**: Consolidate outbound traffic, use VPC endpoints for AWS services
- **Log retention**: Set appropriate retention periods (30 days hot, archive to S3 Glacier)
- **Spot instances for CI**: Use spot for build runners (acceptable interruption risk)

### Monthly Cost Review Cadence

- **Week 1-4 (launch)**: Daily cost monitoring, catch runaway resources
- **Month 2-3**: Weekly review, identify optimization opportunities
- **Month 4+**: Monthly review, reserved instance planning
- **Quarterly**: Architecture-level cost optimization review
