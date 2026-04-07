# Technology Stack Selection — TaskFlow

> **Project**: TaskFlow
> **Version**: draft
> **Date Created**: 2026-04-06
> **Last Updated**: 2026-04-06
> **Status**: Draft
> **Author**: AI-Generated
> **Source**: Derived from `scope-final.md` and `charter-final.md`

---

## 1. Stack Summary

| Category | Selected | Version | License | Rationale | Confidence |
|----------|----------|---------|---------|-----------|------------|
| Backend Language | TypeScript | 5.4 | MIT | Type safety, same language as frontend reduces context switching | ✅ CONFIRMED |
| Backend Framework | NestJS | 10.x | MIT | Enterprise-grade modular architecture, excellent TypeScript support | 🔶 ASSUMED |
| Frontend Framework | React | 18.x | MIT | Team has 3+ years experience, largest ecosystem for UI components | ✅ CONFIRMED |
| Database (Primary) | PostgreSQL | 16 | PostgreSQL License | JSONB support for flexible sprint data, proven reliability at scale | ✅ CONFIRMED |
| Database (Cache) | Redis | 7.x | BSD-3-Clause | Real-time pub/sub for live dashboard updates + caching in one service | 🔶 ASSUMED |
| Message Queue | Redis Streams | 7.x (built-in) | BSD-3-Clause | Avoids separate queue service for MVP, upgrade path to Kafka if needed | 🔶 ASSUMED |
| Cloud/Hosting | AWS | — | Pay-as-you-go | Team experience with AWS, comprehensive managed services | ✅ CONFIRMED |
| CI/CD | GitHub Actions | — | Free for public / usage-based | Already using GitHub for source control, native integration | ✅ CONFIRMED |
| Monitoring | Datadog | — | Usage-based (from $15/host/mo) | Unified APM + logs + metrics, strong AWS integration | 🔶 ASSUMED |
| Authentication | Auth0 | — | Free tier (7K MAU) / usage-based | Scope INT-005 requires OAuth providers (GitHub, GitLab), Auth0 supports both | ✅ CONFIRMED |

**MVP Stack Note**: All technologies listed are required for MVP. Redis Streams replaces a dedicated message queue for MVP; if event volume exceeds 10K/min post-launch, migrate to Kafka `[FUTURE]`.

---

## 2. Decision Matrices

### DM-001: Backend Framework Selection

**Decision**: NestJS 10.x ✅

| Criterion | Weight | NestJS 10.x | Express.js 4.x | Fastify 4.x |
|-----------|--------|-------------|-----------------|-------------|
| Performance (QA-001: < 2s dashboard load) | 4 | 4 (16) | 3 (12) | 5 (20) |
| Scalability (QA-003: 50 concurrent teams) | 4 | 5 (20) | 3 (12) | 4 (16) |
| Team expertise (CON-004: 3-person team) | 3 | 2 (6) | 5 (15) | 2 (6) |
| Maintainability (project lifespan > 3 years) | 4 | 5 (20) | 2 (8) | 4 (16) |
| Community/ecosystem (integration breadth) | 3 | 4 (12) | 5 (15) | 3 (9) |
| Security (QA-004: OWASP compliance) | 4 | 4 (16) | 3 (12) | 3 (12) |
| **Weighted Total** | **22** | **90** | **74** | **79** |

**Rationale**: NestJS wins on maintainability and scalability due to its modular architecture with dependency injection, built-in support for guards/interceptors/pipes that enforce security patterns, and opinionated structure that keeps a growing codebase organized. Fastify is faster in raw throughput but lacks NestJS's architectural guardrails. Express is most familiar to the team but its minimal structure becomes a liability in a multi-year project. The team expertise gap for NestJS is mitigated by its excellent documentation and TypeScript-first approach.
**Confidence**: 🔶 ASSUMED -- NestJS scored highest but team has limited experience. Needs stakeholder buy-in on training investment. Q&A ref: Q-001

### DM-002: Database (Primary) Selection

**Decision**: PostgreSQL 16 ✅

| Criterion | Weight | PostgreSQL 16 | MySQL 8.x | MongoDB 7.x |
|-----------|--------|---------------|-----------|-------------|
| Performance (QA-001: < 2s load, complex queries) | 4 | 5 (20) | 4 (16) | 3 (12) |
| Scalability (QA-003: 50 teams, growing data) | 4 | 4 (16) | 4 (16) | 5 (20) |
| Data integrity (sprint data must be accurate) | 5 | 5 (25) | 4 (20) | 3 (15) |
| JSONB support (flexible webhook payloads) | 4 | 5 (20) | 3 (12) | 5 (20) |
| Team expertise (CON-004) | 3 | 4 (12) | 4 (12) | 2 (6) |
| Maturity (QA-002: 99.5% availability) | 4 | 5 (20) | 5 (20) | 4 (16) |
| **Weighted Total** | **24** | **113** | **96** | **89** |

**Rationale**: PostgreSQL wins decisively on data integrity and JSONB support. TaskFlow stores structured sprint/ticket data (relational) alongside semi-structured Git webhook payloads (JSONB), making PostgreSQL's hybrid capabilities ideal. MongoDB's document model would require application-level joins for sprint analytics queries. MySQL lacks native JSONB indexing. PostgreSQL 16 also brings performance improvements for parallel query execution relevant to analytics workloads.
**Confidence**: ✅ CONFIRMED -- Team has PostgreSQL experience, and the data model clearly requires relational + JSONB capabilities.

### DM-003: Real-Time Strategy Selection

**Decision**: Redis Pub/Sub (via Redis 7.x) ✅

| Criterion | Weight | Redis Pub/Sub | Socket.io (standalone) | Pusher |
|-----------|--------|---------------|----------------------|--------|
| Performance (QA-001: real-time < 1s latency) | 5 | 5 (25) | 4 (20) | 4 (20) |
| Cost (CON-002: MVP budget < $50K) | 4 | 5 (20) | 5 (20) | 2 (8) |
| Operational simplicity (CON-004: small team) | 4 | 5 (20) | 3 (12) | 5 (20) |
| Scalability (QA-003: 50 concurrent teams) | 4 | 4 (16) | 3 (12) | 5 (20) |
| Team expertise (CON-004) | 3 | 3 (9) | 4 (12) | 4 (12) |
| Dual-use cache+pubsub (reduce infrastructure) | 3 | 5 (15) | 1 (3) | 1 (3) |
| **Weighted Total** | **23** | **105** | **79** | **83** |

**Rationale**: Redis Pub/Sub wins because TaskFlow already needs Redis for caching (dashboard performance), and Redis 7.x provides pub/sub natively -- eliminating a separate real-time service. This reduces infrastructure cost and operational burden for a 3-person team. Socket.io would require a separate process and doesn't provide caching. Pusher is fully managed but adds $99+/mo cost and vendor lock-in. At MVP scale (50 teams), Redis handles the pub/sub volume easily; if scaling beyond 500 concurrent connections, evaluate dedicated WebSocket infrastructure.
**Confidence**: 🔶 ASSUMED -- Dual-use Redis strategy is cost-effective for MVP but needs validation that pub/sub throughput meets real-time requirements under load. Q&A ref: Q-002

---

## 3. Compatibility Matrix

| | TypeScript 5.4 | NestJS 10.x | PostgreSQL 16 | Redis 7.x | React 18.x |
|---|---|---|---|---|---|
| **TypeScript 5.4** | — | ✅ Native | ✅ via Prisma | ✅ via ioredis | ✅ Native (JSX/TSX) |
| **NestJS 10.x** | ✅ Built for TS | — | ✅ Prisma module | ✅ @nestjs/redis | ✅ Serves React SPA |
| **PostgreSQL 16** | ✅ Prisma types | ✅ Prisma module | — | -- N/A | -- N/A |
| **Redis 7.x** | ✅ ioredis types | ✅ @nestjs/redis | -- N/A | — | ⚠️ Via backend WS |
| **React 18.x** | ✅ TSX support | ✅ REST/WS client | -- N/A | ⚠️ Via backend WS | — |

**Compatibility Notes**:
- **Redis <-> React (⚠️)**: React does not connect to Redis directly. Real-time updates flow through NestJS WebSocket gateway (NestJS receives Redis pub/sub events and forwards to React clients via WebSocket). This is the standard architecture pattern -- not a limitation.
- **ORM Selection**: Prisma was selected over TypeORM for the NestJS + PostgreSQL integration. Prisma provides type-safe queries generated from the schema, better developer experience, and more predictable query generation. TypeORM is also compatible but has weaker TypeScript integration.
- **All core pairs are ✅**: TypeScript, NestJS, PostgreSQL, and Redis have mature, well-maintained integration libraries with full type support.

---

## 4. Risk Assessment

| ID | Risk | Impact | Likelihood | Mitigation | Confidence |
|----|------|--------|------------|------------|------------|
| TSK-RISK-001 | NestJS learning curve -- team has Express experience but no NestJS experience. Estimated 2-week ramp-up per developer. | Medium | High | 1) 3-day NestJS workshop before Sprint 1. 2) Use NestJS CLI scaffolding to follow conventions. 3) Pair programming during Sprint 1-2. 4) Fallback: Express.js is viable (scored 74 vs 90, acceptable trade-off). | 🔶 ASSUMED |
| TSK-RISK-002 | Redis single-point-of-failure -- Redis serves both cache and real-time pub/sub. If Redis goes down, both features fail simultaneously. | High | Low | 1) Deploy Redis with AWS ElastiCache (automatic failover). 2) Application-level graceful degradation: dashboard shows stale data with "updating..." indicator if Redis is unavailable. 3) Health check alerts via Datadog. | 🔶 ASSUMED |
| TSK-RISK-003 | Datadog cost scaling -- Datadog pricing scales with hosts and log volume. At 10+ hosts, cost exceeds $500/mo. | Medium | Medium | 1) Start with 2-3 hosts for MVP (estimated $100/mo). 2) Set log retention to 15 days for non-critical logs. 3) Evaluate Grafana + Prometheus as self-hosted alternative if costs exceed $300/mo. 4) Use Datadog's committed-use discounts. | 🔶 ASSUMED |
| TSK-RISK-004 | Auth0 vendor lock-in -- switching auth providers requires migration of user accounts, tokens, and OAuth configurations. | Medium | Low | 1) Abstract auth behind a NestJS AuthModule interface. 2) Store user profiles in TaskFlow's own database (PostgreSQL), not only in Auth0. 3) Auth0's free tier covers 7,000 MAU which is sufficient for first 12 months. 4) If migration needed, Keycloak is a self-hosted alternative. | 🔶 ASSUMED |

---

## 5. Version & Upgrade Strategy

| Technology | Current Version | LTS Until | Upgrade Cadence | Notes |
|-----------|----------------|-----------|-----------------|-------|
| TypeScript | 5.4 | N/A (quarterly releases) | Quarterly (minor) | Follow NestJS compatibility matrix |
| NestJS | 10.x | ~2 years from release | Semesterly (minor), annually (major) | Wait 1 month after major release for ecosystem catch-up |
| React | 18.x | Supported until 19.x stable | Annually (major) | Evaluate React 19 after 6 months of stable release |
| PostgreSQL | 16 | Nov 2028 | Annually (major) | Use pg_upgrade for major version migrations |
| Redis | 7.x | N/A (latest stable) | Annually | Monitor Valkey fork as potential future alternative |
| Node.js | 20 LTS | Apr 2026 | Annually (LTS to LTS) | Runtime for TypeScript/NestJS |
| Prisma | 5.x | N/A | Quarterly | Pin exact versions, test migrations before upgrading |

**Dependency Management**: pnpm with pnpm-lock.yaml for deterministic installs. Dependabot configured for automated dependency update PRs (weekly for patch, monthly for minor). Manual review required for major version bumps.

**Security Patching**: Critical CVEs (CVSS >= 9.0) patched within 48 hours. High CVEs (CVSS 7.0-8.9) patched within 1 week. Medium/Low CVEs addressed in next scheduled dependency update cycle. Automated alerts via GitHub Dependabot security advisories and Datadog.

---

## 6. Budget Impact

| Category | Technology | Cost Model | Estimated Monthly | Estimated Annual |
|----------|-----------|------------|-------------------|-----------------|
| Cloud Infrastructure | AWS (EC2, RDS, ElastiCache, S3, ALB) | Pay-as-you-go | $800 | $9,600 |
| Database | AWS RDS PostgreSQL (db.t3.medium) | Pay-as-you-go | $120 | $1,440 |
| Cache/Real-time | AWS ElastiCache Redis (cache.t3.small) | Pay-as-you-go | $50 | $600 |
| Monitoring | Datadog (2 hosts + APM + logs) | Usage-based | $100 | $1,200 |
| Authentication | Auth0 (free tier, < 7K MAU) | Free tier | $0 | $0 |
| CI/CD | GitHub Actions (Team plan) | Per-seat + minutes | $25 | $300 |
| Domain + TLS | AWS Route 53 + ACM | Pay-as-you-go | $5 | $60 |
| **Total** | | | **$1,100** | **$13,200** |

**Notes**:
- AWS estimates assume MVP scale: 2 application instances, 1 RDS instance, 1 ElastiCache node, minimal S3 storage.
- Auth0 free tier covers up to 7,000 monthly active users. At current projections (50 teams x ~10 users = 500 MAU), this is sufficient for 12+ months.
- Datadog estimate assumes 2 hosts with APM enabled and 15-day log retention. Costs scale linearly with additional hosts.
- All open-source technologies (TypeScript, NestJS, React, PostgreSQL, Redis) have $0 licensing cost.
- Budget constraint CON-002 (< $50K first year): $13,200 infrastructure + estimated $0 licensing = well within budget, leaving room for development costs.

---

## 7. Q&A Log

### Pending

#### Q-001 (related: DM-001, TSK-RISK-001)
- **Impact**: HIGH
- **Question**: Is the team willing to invest 2 weeks in NestJS training before Sprint 1, or should we use Express.js (familiar but lower long-term maintainability)?
- **Context**: NestJS scored 90 vs Express's 74 in the decision matrix. The 16-point gap comes from maintainability and scalability -- critical for a multi-year product. However, the team has zero NestJS experience. Express would eliminate the learning curve risk but may create technical debt as the codebase grows.
- **Answer**:
- **Status**: Pending

#### Q-002 (related: DM-003)
- **Impact**: MEDIUM
- **Question**: Should we defer Kubernetes to post-MVP, using a simpler deployment model (ECS or even EC2 + Docker Compose) for launch?
- **Context**: Kubernetes adds operational complexity that may overwhelm a 3-person team. ECS provides container orchestration with less overhead. Docker Compose on EC2 is simplest but limits horizontal scaling. The availability target (QA-002: 99.5%) can be met with ECS multi-AZ deployment without Kubernetes.
- **Answer**:
- **Status**: Pending

#### Q-003 (related: DM-001)
- **Impact**: LOW
- **Question**: Should we consider GraphQL instead of REST for the API layer, given the dashboard's need for flexible data queries?
- **Context**: The sprint dashboard (SCP-002) displays heterogeneous data (tickets, Git events, CI/CD status) that may benefit from GraphQL's query flexibility. However, NestJS supports both REST and GraphQL, so this decision can be deferred to the API design phase (`/design-api`) without affecting the tech stack.
- **Answer**: Deferred to `/design-api` phase. NestJS supports both REST and GraphQL, so the tech stack selection does not constrain this decision.
- **Status**: Resolved

---

## 8. Readiness Assessment

| Metric | Value |
|--------|-------|
| Total items | 10 |
| ✅ CONFIRMED | 6 (60%) |
| 🔶 ASSUMED | 4 (40%) |
| ❓ UNCLEAR | 0 (0%) |
| Q&A Pending | 2 (HIGH: 1, MEDIUM: 1, LOW: 0) |
| Q&A Answered | 1 |

**Verdict**: ⚠️ Partially Ready

**Reasoning**: Core technologies (TypeScript, React, PostgreSQL, AWS, GitHub Actions, Auth0) are confirmed based on team experience, project constraints, and scope requirements. Four decisions (NestJS, Redis, Redis Streams, Datadog) are assumed based on decision matrix analysis but need stakeholder validation -- particularly the NestJS choice which carries a training investment. No unclear items remain. Architecture design (`/design-arch`) can proceed using the confirmed stack; assumed items should be validated before Sprint 1 implementation begins.

---

## 9. Approval

| Role | Name | Date | Status |
|------|------|------|--------|
| Technical Lead | [TBD] | | Pending |
| Architect | [TBD] | | Pending |
