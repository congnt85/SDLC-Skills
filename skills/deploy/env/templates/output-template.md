# Environment Specification Output Template

This is the expected structure for `env-spec-draft.md` output. Follow this exactly.

---

```markdown
# Environment Specification — {Project Name}

> **Project**: {Project Name}
> **Version**: draft | v{N}
> **Date Created**: {YYYY-MM-DD}
> **Last Updated**: {YYYY-MM-DD}
> **Status**: Draft | Under Review | Approved
> **Author**: AI-Generated
> **Source**: Based on `architecture-final.md`, `tech-stack-final.md`, and `cicd-pipeline-final.md`

{If refine mode, include Change Log here}

---

## 1. Environment Overview

{Brief description of the environment strategy — how many environments, why, and how they relate to the development lifecycle.}

### Environment Comparison

| Attribute | Development | CI | Staging | Performance | Production |
|-----------|-------------|-----|---------|-------------|------------|
| **Purpose** | {purpose} | {purpose} | {purpose} | {purpose} | {purpose} |
| **Infrastructure** | {type} | {type} | {type} | {type} | {type} |
| **Scale** | {description} | {description} | {description} | {description} | {description} |
| **Data** | {strategy} | {strategy} | {strategy} | {strategy} | {strategy} |
| **Access** | {who} | {who} | {who} | {who} | {who} |
| **Availability** | {target} | {target} | {target} | {target} | {target} |
| **Estimated Cost** | {$/mo} | {$/mo} | {$/mo} | {$/mo} | {$/mo} |

{Remove columns for environments that don't apply (e.g., Performance if not needed).}

---

## 2. Infrastructure Topology

### 2.1 Production Topology

```mermaid
graph TB
    subgraph "Internet"
        Users[Users / Clients]
    end

    subgraph "VPC — {CIDR}"
        subgraph "Public Subnet"
            ALB[Load Balancer<br/>{service}]
            NAT[NAT Gateway]
        end

        subgraph "Private App Subnet — AZ-1"
            APP1[{Service Name}<br/>{instance type}<br/>{CPU}, {RAM}]
        end

        subgraph "Private App Subnet — AZ-2"
            APP2[{Service Name}<br/>{instance type}<br/>{CPU}, {RAM}]
        end

        subgraph "Private Data Subnet — AZ-1"
            DB1[{Database}<br/>{instance type}<br/>Primary]
            CACHE1[{Cache}<br/>{instance type}<br/>Primary]
        end

        subgraph "Private Data Subnet — AZ-2"
            DB2[{Database}<br/>{instance type}<br/>Standby]
            CACHE2[{Cache}<br/>{instance type}<br/>Replica]
        end
    end

    subgraph "Edge"
        CDN[{CDN Service}]
        DNS[{DNS Service}]
    end

    Users --> DNS --> CDN
    Users --> DNS --> ALB
    ALB --> APP1
    ALB --> APP2
    APP1 --> DB1
    APP2 --> DB1
    APP1 --> CACHE1
    APP2 --> CACHE1
    DB1 -.-> DB2
    CACHE1 -.-> CACHE2
```

### 2.2 Per-Environment Infrastructure

#### Development

| Component | Service | Details | Confidence |
|-----------|---------|---------|------------|
| {component} | {service} | {sizing details} | ✅/🔶/❓ |

#### Staging

| Component | Service | Details | Confidence |
|-----------|---------|---------|------------|
| {component} | {service} | {sizing details} | ✅/🔶/❓ |

#### Production

| Component | Service | Details | Confidence |
|-----------|---------|---------|------------|
| {component} | {service} | {sizing details} | ✅/🔶/❓ |

{Repeat for each environment.}

---

## 3. Service Specifications

### 3.1 {Service Name} (e.g., API Server)

| Attribute | Development | Staging | Production | Confidence |
|-----------|-------------|---------|------------|------------|
| **Platform** | {e.g., Docker Compose} | {e.g., ECS Fargate} | {e.g., ECS Fargate} | ✅/🔶/❓ |
| **Instances** | {count} | {count} | {min}-{max} | ✅/🔶/❓ |
| **CPU** | {vCPU} | {vCPU} | {vCPU} | ✅/🔶/❓ |
| **Memory** | {GB} | {GB} | {GB} | ✅/🔶/❓ |
| **Storage** | {GB, type} | {GB, type} | {GB, type} | ✅/🔶/❓ |
| **Health Check** | {endpoint, interval} | {endpoint, interval} | {endpoint, interval} | ✅/🔶/❓ |
| **Scaling** | None | None | {policy} | ✅/🔶/❓ |

### 3.2 {Service Name} (e.g., Database)

| Attribute | Development | Staging | Production | Confidence |
|-----------|-------------|---------|------------|------------|
| **Platform** | {e.g., Docker PostgreSQL} | {e.g., RDS} | {e.g., RDS Multi-AZ} | ✅/🔶/❓ |
| **Instance Type** | N/A | {type} | {type} | ✅/🔶/❓ |
| **CPU** | {vCPU} | {vCPU} | {vCPU} | ✅/🔶/❓ |
| **Memory** | {GB} | {GB} | {GB} | ✅/🔶/❓ |
| **Storage** | {GB, type} | {GB, type} | {GB, type} | ✅/🔶/❓ |
| **HA** | None | None | {strategy} | ✅/🔶/❓ |
| **Backups** | None | {schedule} | {schedule} | ✅/🔶/❓ |

{Repeat for each service: cache, workers, CDN, etc.}

---

## 4. Networking & Security

### 4.1 VPC Design

| Attribute | Value | Confidence |
|-----------|-------|------------|
| **VPC CIDR** | {e.g., 10.0.0.0/16} | ✅/🔶/❓ |
| **Public Subnets** | {count} x {CIDR blocks} | ✅/🔶/❓ |
| **Private App Subnets** | {count} x {CIDR blocks} | ✅/🔶/❓ |
| **Private Data Subnets** | {count} x {CIDR blocks} | ✅/🔶/❓ |
| **Availability Zones** | {count} ({list}) | ✅/🔶/❓ |
| **NAT Gateway** | {count, placement} | ✅/🔶/❓ |

### 4.2 Security Groups

| Security Group | Inbound Rules | Outbound Rules | Purpose | Confidence |
|---------------|---------------|----------------|---------|------------|
| {SG name} | {port} from {source} | {port} to {destination} | {purpose} | ✅/🔶/❓ |

### 4.3 SSL/TLS Configuration

| Attribute | Value | Confidence |
|-----------|-------|------------|
| **Certificate Provider** | {e.g., ACM, Let's Encrypt} | ✅/🔶/❓ |
| **Minimum TLS Version** | {e.g., TLS 1.2} | ✅/🔶/❓ |
| **SSL Termination** | {e.g., At ALB} | ✅/🔶/❓ |
| **HSTS** | {enabled/disabled, max-age} | ✅/🔶/❓ |
| **WAF** | {enabled/planned, rules} | ✅/🔶/❓ |

### 4.4 Access Control per Environment

| Environment | SSH/Shell | Database | Deploy | Logs | Confidence |
|-------------|-----------|----------|--------|------|------------|
| {env} | {who} | {who} | {who} | {who} | ✅/🔶/❓ |

---

## 5. Configuration Management

### 5.1 Environment Variable Inventory

| Variable | Category | Source | Dev | Staging | Production | Confidence |
|----------|----------|--------|-----|---------|------------|------------|
| {VAR_NAME} | Config / Secret / Flag | {source} | {value/placeholder} | {value/placeholder} | {value/placeholder} | ✅/🔶/❓ |

### 5.2 Configuration Sources

| Source | Purpose | Environments | Tool/Service | Confidence |
|--------|---------|-------------|--------------|------------|
| {source} | {what it stores} | {which envs} | {tool} | ✅/🔶/❓ |

### 5.3 Secret Management

| Secret | Service | Rotation Policy | Access | Confidence |
|--------|---------|----------------|--------|------------|
| {secret name} | {e.g., Secrets Manager} | {e.g., 90 days} | {who/what} | ✅/🔶/❓ |

### 5.4 Feature Flags

| Flag | Purpose | Default (Dev) | Default (Staging) | Default (Prod) | Confidence |
|------|---------|---------------|-------------------|----------------|------------|
| {FLAG_NAME} | {purpose} | {value} | {value} | {value} | ✅/🔶/❓ |

---

## 6. Scaling Policies

### 6.1 Compute Scaling

| Service | Metric | Threshold | Min | Max | Cooldown | Confidence |
|---------|--------|-----------|-----|-----|----------|------------|
| {service} | {CPU/Memory/Custom} | {e.g., >70%} | {min instances} | {max instances} | {seconds} | ✅/🔶/❓ |

### 6.2 Database Scaling

| Database | Current Sizing | Scale Trigger | Scale Action | Timeline | Confidence |
|----------|---------------|---------------|--------------|----------|------------|
| {db name} | {current spec} | {trigger condition} | {action: vertical, read replica, etc.} | {when to apply} | ✅/🔶/❓ |

### 6.3 Cache Scaling

| Cache | Current Sizing | Scale Trigger | Scale Action | Confidence |
|-------|---------------|---------------|--------------|------------|
| {cache name} | {current spec} | {trigger condition} | {action} | ✅/🔶/❓ |

---

## 7. Backup & Disaster Recovery

### 7.1 Backup Schedule

| Resource | Method | Frequency | Retention | Location | Confidence |
|----------|--------|-----------|-----------|----------|------------|
| {resource} | {method} | {frequency} | {retention} | {where stored} | ✅/🔶/❓ |

### 7.2 Recovery Targets

| Metric | Target | Justification | Confidence |
|--------|--------|---------------|------------|
| **RPO** (Recovery Point Objective) | {e.g., 1 hour} | {why this target} | ✅/🔶/❓ |
| **RTO** (Recovery Time Objective) | {e.g., 30 minutes} | {why this target} | ✅/🔶/❓ |

### 7.3 Recovery Procedure

{Step-by-step recovery procedure for the most critical failure scenario (database failure):}

1. {Step 1: Detect — how is the failure detected?}
2. {Step 2: Assess — what is the impact?}
3. {Step 3: Recover — what actions to take?}
4. {Step 4: Validate — how to confirm recovery?}
5. {Step 5: Post-mortem — what to document?}

---

## 8. Monitoring & Observability

### 8.1 Health Checks

| Service | Endpoint | Interval | Timeout | Healthy Threshold | Confidence |
|---------|----------|----------|---------|-------------------|------------|
| {service} | {path} | {seconds} | {seconds} | {count} | ✅/🔶/❓ |

### 8.2 Key Metrics

| Metric | Source | Threshold | Alert | Confidence |
|--------|--------|-----------|-------|------------|
| {metric name} | {service} | {warning/critical threshold} | {who gets notified} | ✅/🔶/❓ |

### 8.3 Log Aggregation

| Source | Destination | Retention | Confidence |
|--------|------------|-----------|------------|
| {log source} | {e.g., CloudWatch Logs, Datadog} | {retention period} | ✅/🔶/❓ |

> **Note**: Detailed monitoring dashboards, alert rules, and escalation procedures are defined in the ops phase (`/ops-monitor`).

---

## 9. Cost Estimation

### 9.1 Per-Environment Breakdown

#### Development

| Resource | Service | Monthly Cost | Notes |
|----------|---------|-------------|-------|
| {resource} | {service} | ${amount} | {notes} |
| **Subtotal** | | **${total}** | |

#### Staging

| Resource | Service | Monthly Cost | Notes |
|----------|---------|-------------|-------|
| {resource} | {service} | ${amount} | {notes} |
| **Subtotal** | | **${total}** | |

#### Production

| Resource | Service | Monthly Cost | Notes |
|----------|---------|-------------|-------|
| {resource} | {service} | ${amount} | {notes} |
| **Subtotal** | | **${total}** | |

{Repeat for each environment.}

### 9.2 Total Cost Summary

| Environment | Monthly | Annual | % of Total |
|-------------|---------|--------|------------|
| Development | ${amount} | ${amount} | {%} |
| Staging | ${amount} | ${amount} | {%} |
| Production | ${amount} | ${amount} | {%} |
| **Total** | **${amount}** | **${amount}** | **100%** |

### 9.3 Cost Optimization Recommendations

| # | Recommendation | Estimated Savings | When to Apply | Confidence |
|---|---------------|-------------------|---------------|------------|
| 1 | {recommendation} | {$/mo or %} | {timeline} | ✅/🔶/❓ |

### 9.4 Budget Alignment

{Reference charter budget constraints (CON-xxx) and confirm whether estimated costs fit within budget. Flag any overruns.}

---

## 10. Environment Parity

### Staging vs Production Parity

| Aspect | Identical? | Staging | Production | Risk if Different |
|--------|-----------|---------|------------|-------------------|
| Docker images | {Yes/No} | {detail} | {detail} | {risk} |
| Config keys | {Yes/No} | {detail} | {detail} | {risk} |
| Config values | {Yes/No} | {detail} | {detail} | {risk} |
| Instance sizes | {Yes/No} | {detail} | {detail} | {risk} |
| Replica count | {Yes/No} | {detail} | {detail} | {risk} |
| Database engine | {Yes/No} | {detail} | {detail} | {risk} |
| Network topology | {Yes/No} | {detail} | {detail} | {risk} |
| SSL/TLS | {Yes/No} | {detail} | {detail} | {risk} |
| Third-party integrations | {Yes/No} | {detail} | {detail} | {risk} |

---

## 11. Q&A Log

| ID | Question | Raised By | Priority | Answer | Status | Confidence |
|----|----------|-----------|----------|--------|--------|------------|
| Q-001 | {question} | {source} | HIGH/MED/LOW | {answer or "Pending"} | Open/Resolved | ✅/🔶/❓ |

---

## 12. Readiness Assessment

### Confidence Summary

| Level | Count | Percentage |
|-------|-------|------------|
| ✅ CONFIRMED | {n} | {%} |
| 🔶 ASSUMED | {n} | {%} |
| ❓ UNCLEAR | {n} | {%} |
| **Total Items** | {n} | 100% |

### Verdict: {READY / PARTIALLY READY / NOT READY}

{Justification for verdict. List critical gaps if not ready.}

### Key Risks

| # | Risk | Impact | Mitigation |
|---|------|--------|------------|
| 1 | {risk description} | {impact} | {mitigation} |

---

## 13. Approval

| Role | Name | Decision | Date | Signature |
|------|------|----------|------|-----------|
| DevOps Lead | {name} | Approved / Rejected / Conditional | {date} | _________ |
| Technical Lead | {name} | Approved / Rejected / Conditional | {date} | _________ |
| Engineering Manager | {name} | Approved / Rejected / Conditional | {date} | _________ |

**Conditions / Comments:**
{Any conditions for approval or comments from reviewers.}
```
