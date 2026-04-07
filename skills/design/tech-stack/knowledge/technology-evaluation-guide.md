# Technology Evaluation Guide

Techniques for identifying, evaluating, and selecting technologies for a project stack.

---

## Technique 1: Category Identification

Determine what technology decisions the project needs to make.

### Standard Categories

Every web/cloud project typically needs decisions in these categories:

| Category | Examples | When Required |
|----------|----------|---------------|
| Backend Language | TypeScript, Python, Go, Java, C# | Always |
| Backend Framework | NestJS, Express, Django, Spring Boot | Always |
| Frontend Framework | React, Vue, Angular, Svelte | If project has a web UI |
| Database (Primary) | PostgreSQL, MySQL, MongoDB, DynamoDB | Always |
| Database (Cache) | Redis, Memcached, Valkey | If performance targets require caching |
| Message Queue | RabbitMQ, Kafka, Redis Streams, SQS | If async processing or event-driven |
| Cloud/Hosting | AWS, GCP, Azure, Vercel, Railway | Always |
| CI/CD | GitHub Actions, GitLab CI, Jenkins | Always |
| Monitoring | Datadog, Grafana+Prometheus, New Relic | If availability targets > 99% |
| Authentication | Auth0, Cognito, Keycloak, custom | If user authentication required |
| Testing Framework | Jest, Vitest, pytest, JUnit | Always (may follow from language choice) |
| Container Runtime | Docker, Podman | If containerized deployment |
| Orchestration | Kubernetes, ECS, Docker Compose | If multi-service architecture |
| Search Engine | Elasticsearch, Meilisearch, Algolia | If full-text search required |
| CDN | CloudFront, Cloudflare, Fastly | If global distribution needed |
| File Storage | S3, GCS, Azure Blob | If file upload/download required |
| Email Service | SendGrid, SES, Postmark | If email notifications required |

### When to Add Custom Categories

Add a category when:
- A scope integration (INT-xxx) requires a specific technology type not in the standard list
- A quality attribute (QA-xxx) demands a specialized tool (e.g., QA for "real-time" may need a WebSocket library decision)
- The project domain has unique needs (e.g., ML projects need model serving, geospatial projects need map libraries)

### When to Skip Categories

Skip a category when:
- The project does not require that capability (e.g., no message queue for a simple CRUD app)
- The technology is mandated by a constraint with no alternatives (e.g., "Must use PostgreSQL" -- still document it, but decision matrix is unnecessary)
- The technology follows automatically from another decision (e.g., testing framework follows from language choice -- still document, but can be brief)

---

## Technique 2: Criteria Weighting from Requirements

Criteria weights should not be arbitrary. Derive them from project context.

### Mapping Quality Attributes to Criteria

| Quality Attribute | Maps to Criteria | Weight Guidance |
|-------------------|------------------|-----------------|
| QA-xxx Performance (e.g., < 2s load) | Performance, Scalability | Weight 4-5 |
| QA-xxx Availability (e.g., 99.5%) | Maturity, Community/ecosystem | Weight 4-5 |
| QA-xxx Security (e.g., OWASP compliance) | Security | Weight 5 |
| QA-xxx Maintainability | Maintainability, Learning curve | Weight 3-4 |
| QA-xxx Scalability (e.g., 10K concurrent) | Scalability, Performance | Weight 4-5 |

### Mapping Constraints to Criteria

| Constraint Type | Maps to Criteria | Weight Guidance |
|-----------------|------------------|-----------------|
| CON-xxx Budget (e.g., < $50K) | Cost | Weight 4-5 |
| CON-xxx Timeline (e.g., 6 months) | Learning curve, Team expertise, Maturity | Weight 4-5 |
| CON-xxx Team size (e.g., 3 developers) | Team expertise, Learning curve | Weight 4-5 |
| CON-xxx Compliance (e.g., SOC2) | Security, Maturity | Weight 5 |
| CON-xxx Platform (e.g., must run on AWS) | N/A (eliminates non-AWS options) | Filter, not weight |

### Mapping Team Skills to Criteria

If the charter or scope describes team composition:
- Team has strong experience with Technology X -> Weight "Team expertise" criterion 3-4
- Team is all junior developers -> Weight "Learning curve" criterion 4-5
- Team is hiring -> Weight "Hiring market" criterion 3-4
- Small team, tight deadline -> Weight "Team expertise" and "Maturity" high (4-5)

### Weight Calibration Rules

- Total weight across all criteria should be 15-25 for a 6-criterion matrix
- No single criterion should have weight 1 unless truly irrelevant (if irrelevant, remove it)
- At least one criterion must have weight >= 4 (otherwise no priorities exist)
- Different categories may have different weight distributions (e.g., database weights Performance higher than CI/CD does)

---

## Technique 3: Evaluation Methodology

How to score technologies fairly and accurately.

### Research Before Scoring

For each technology alternative:
- Check official documentation for claimed capabilities
- Check benchmark comparisons (TechEmpower, DB benchmarks)
- Check GitHub stars, npm weekly downloads, PyPI downloads as ecosystem health proxies
- Check Stack Overflow question volume and answer quality
- Check "awesome-{technology}" lists for ecosystem breadth
- Check release history (frequency, breaking changes, deprecation patterns)

### Score Against Project Needs

Score each technology 1-5 against the criterion as it applies to THIS project:

| Score | Meaning |
|-------|---------|
| 5 | Excellent -- best option for this project's specific needs |
| 4 | Good -- strong fit with minor gaps |
| 3 | Adequate -- meets needs but with trade-offs |
| 2 | Weak -- significant gaps for this project |
| 1 | Poor -- major concerns for this use case |

Do NOT score based on general reputation. A technology can be world-class but score 2 if it doesn't fit the project's constraints.

### Ecosystem Maturity Assessment

| Signal | Healthy Ecosystem | Concerning Ecosystem |
|--------|-------------------|---------------------|
| Age | > 5 years in production | < 2 years, pre-1.0 |
| Releases | Regular (monthly/quarterly) | Sporadic or stalled |
| GitHub stars | > 10K (for major tools) | < 1K |
| npm/PyPI downloads | > 100K weekly | < 10K weekly |
| Stack Overflow | Many answered questions | Few questions, low answer rate |
| Corporate backing | Major company or foundation | Single maintainer |
| Security response | Published CVE process | No security policy |

### License Compatibility Assessment

| License | Commercial Use | Copyleft Risk | Notes |
|---------|---------------|---------------|-------|
| MIT | Yes | None | Most permissive |
| Apache-2.0 | Yes | None | Patent grant included |
| BSD-2/BSD-3 | Yes | None | Permissive |
| ISC | Yes | None | Simplified MIT |
| MPL-2.0 | Yes | File-level | Modified files must stay MPL |
| LGPL-2.1/3.0 | Yes | Library-level | Dynamic linking OK, static linking problematic |
| GPL-2.0/3.0 | Caution | Strong | Derivative works must be GPL |
| AGPL-3.0 | Caution | Network | Server-side use triggers copyleft |
| SSPL | Caution | Very strong | MongoDB's license, not OSI-approved |
| Proprietary | Check terms | N/A | May require paid license |

Rule: If the project is proprietary/commercial, avoid GPL/AGPL dependencies unless isolated (e.g., development tools only, not runtime dependencies).

### Security Track Record Assessment

For each technology, assess:
- **CVE count (last 3 years)**: How many known vulnerabilities?
- **Response time**: How fast are security patches released?
- **Severity distribution**: Mostly low/medium or frequent critical/high?
- **Security policy**: Does the project have a SECURITY.md or responsible disclosure process?
- **Default security**: Are secure defaults enabled (e.g., parameterized queries, CSRF protection)?

---

## Technique 4: Compatibility Matrix

After selecting individual technologies, verify they work together.

### Key Compatibility Checks

| Pair | What to Verify |
|------|---------------|
| Language <-> Framework | Framework is built for/supports the language natively |
| Framework <-> Database | ORM/driver availability and maturity |
| Framework <-> Cache | Client library availability and connection pooling |
| Framework <-> Message Queue | Client library, async support |
| Cloud <-> All Services | All selected technologies available as managed services or deployable |
| CI/CD <-> Language/Framework | Build tool support, test runner support, deployment actions |
| Monitoring <-> Framework | APM agent availability, log format compatibility |
| Auth <-> Framework | SDK/middleware availability |

### Compatibility Scoring

| Symbol | Meaning |
|--------|---------|
| ✅ | Native/first-class support, well-documented |
| ⚠️ | Works but requires plugin, adapter, or extra configuration |
| ❌ | Known incompatibility or no support |
| -- | Not applicable (technologies don't interact) |

### Known Anti-Patterns

Technology combinations that frequently cause issues:

| Combination | Issue |
|-------------|-------|
| MongoDB + complex transactions | MongoDB transactions are limited vs relational DBs |
| Microservices + small team (<4) | Operational overhead exceeds team capacity |
| Kubernetes + MVP/startup | Over-engineering for early-stage projects |
| Multiple languages in backend | Increases hiring and maintenance complexity |
| Self-hosted auth + small team | Security expertise required, liability risk |
| Bleeding-edge framework + enterprise | Stability and support concerns |

---

## Technique 5: Version Strategy

How to choose and manage technology versions.

### Version Selection Rules

1. **Prefer LTS releases** for production dependencies
   - Node.js: Use LTS (even-numbered) releases
   - PostgreSQL: Use latest stable release (5-year support window)
   - Java: Use LTS releases (11, 17, 21)

2. **Match major versions** across related tools
   - TypeScript version should be compatible with the framework's supported range
   - ORM version should match database driver requirements
   - Test framework version should match the language/framework version

3. **Pin versions in production**, use ranges in libraries
   - Application: Pin exact versions (`"react": "18.2.0"`)
   - Library: Use compatible ranges (`"react": "^18.0.0"`)

### Upgrade Cadence Planning

| Technology Type | Recommended Cadence | Reasoning |
|----------------|---------------------|-----------|
| Language runtime | Annually (LTS to LTS) | Major versions need testing |
| Framework | Semesterly or on minor releases | Balance features vs stability |
| Database | Annually or on major releases | Migration risk, test thoroughly |
| Dependencies | Monthly (minor/patch) | Security patches, bug fixes |
| OS/container base | Quarterly | Security patches |

### Dependency Management Tooling

| Language | Package Manager | Lock File | Audit Tool |
|----------|----------------|-----------|------------|
| JavaScript/TypeScript | npm / pnpm / yarn | package-lock.json / pnpm-lock.yaml | npm audit / pnpm audit |
| Python | pip / poetry | requirements.txt / poetry.lock | pip-audit / safety |
| Go | go modules | go.sum | govulncheck |
| Java | Maven / Gradle | pom.xml / build.gradle.kts | OWASP dependency-check |
| C# | NuGet | packages.lock.json | dotnet list package --vulnerable |
