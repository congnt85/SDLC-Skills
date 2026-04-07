# Test Strategy Guide

This guide provides techniques and knowledge for creating effective test strategies. It covers test pyramid design, tool selection frameworks, environment strategy, NFR testing approaches, risk-based prioritization, and coverage target setting.

---

## 1. Test Pyramid Design

The test pyramid is the foundational model for balancing test speed, cost, and confidence. Each level has a distinct purpose.

### 1.1 Unit Testing

**What**: Test individual functions, methods, and classes in isolation. All external dependencies (databases, APIs, file systems) are mocked or stubbed.

**Characteristics**:
- Target: 60-70% of total test count
- Execution time: < 5ms per test
- Runs on: every commit
- Written by: developer who writes the code
- Isolation: complete — no I/O, no network, no shared state

**What to test at this level**:
- Business logic in service classes
- Utility and helper functions
- Data transformations and mappings
- Validation logic
- State machines and conditional flows
- Error handling paths

**What NOT to test at this level**:
- Database queries (use integration tests)
- API endpoint routing (use API tests)
- UI rendering with real DOM (use component tests or E2E)
- Third-party library internals

### 1.2 Integration Testing

**What**: Test interactions between two or more components with real dependencies where practical. Verifies that components work together correctly.

**Characteristics**:
- Target: 20-25% of total test count
- Execution time: 50ms-2s per test
- Runs on: PR merge / pre-merge
- Written by: developer, sometimes QA
- Isolation: per-test database transactions or per-suite containers

**What to test at this level**:
- Service + database interactions (CRUD operations, complex queries)
- Service + cache interactions (cache hit/miss, invalidation)
- Service + message queue (publish/consume)
- Multi-service workflows within a bounded context
- Webhook processing pipelines
- Authentication and authorization flows with real middleware

**Real vs Mock decision**:
- USE REAL: databases, caches, message queues (containerized)
- MOCK: external third-party APIs, payment gateways, email services
- DECISION FACTOR: if you own it and can containerize it, use real

### 1.3 API / Contract Testing

**What**: Test REST/GraphQL endpoints against their specification. Validates request/response schemas, status codes, authentication, error handling, and pagination.

**Characteristics**:
- Target: 5-10% of total test count
- Execution time: 100ms-1s per test
- Runs on: staging deployment
- Written by: QA engineer or developer
- Isolation: dedicated test database with seed data

**What to test at this level**:
- Every endpoint returns correct status codes (200, 201, 400, 401, 403, 404, 500)
- Response body matches API spec schema
- Authentication and authorization enforcement
- Input validation and error messages
- Pagination, filtering, and sorting
- Rate limiting behavior
- CORS headers

**Contract testing**: If the system has multiple consumers, use consumer-driven contract testing (Pact) to ensure API changes do not break consumers.

### 1.4 E2E Testing

**What**: Test complete user workflows through the full stack (UI or API chains). Validates that the system works as a whole from the user's perspective.

**Characteristics**:
- Target: 5-10% of total test count
- Execution time: 5-30s per test
- Runs on: before release / release candidate
- Written by: QA engineer
- Isolation: dedicated environment with known state

**What to test at this level**:
- Critical user journeys only (3-7 flows maximum)
- Happy paths that generate revenue or are legally required
- Cross-system workflows (e.g., signup -> email verification -> first login)
- Flows that have broken in production before

**What NOT to test at this level**:
- Edge cases (handle at unit/integration level)
- Every permutation of a form (handle at unit level)
- Visual styling (use visual regression tools separately)

**Keep E2E suite small**: Every additional E2E test adds maintenance cost and flakiness risk. A 5-minute E2E suite is better than a 30-minute one.

---

## 2. Tool Selection by Tech Stack

Choose test tools based on tech stack compatibility, team familiarity, CI integration capability, and community support.

### 2.1 TypeScript / Node.js

| Purpose | Recommended | Alternative |
|---------|-------------|-------------|
| Unit + Integration | Jest | Vitest |
| TypeScript support | ts-jest | native (Vitest) |
| Mocking | jest.mock / jest-mock-extended | sinon |
| HTTP testing | Supertest | got + nock |
| Component testing | React Testing Library | Enzyme (legacy) |
| E2E | Playwright | Cypress |
| API contract | Pact | Dredd |
| Performance | k6 | Artillery |
| Coverage | Istanbul (c8) | Jest built-in |
| Security SAST | ESLint security plugin | SonarQube |
| Security DAST | OWASP ZAP | Burp Suite |

### 2.2 Python

| Purpose | Recommended | Alternative |
|---------|-------------|-------------|
| Unit + Integration | pytest | unittest |
| Mocking | pytest-mock / unittest.mock | MagicMock |
| HTTP testing | requests + pytest | httpx |
| E2E | Playwright (Python) | Selenium |
| Performance | Locust | k6 |
| Coverage | coverage.py / pytest-cov | — |
| Security | Bandit (SAST) | Safety |

### 2.3 Java / Kotlin

| Purpose | Recommended | Alternative |
|---------|-------------|-------------|
| Unit + Integration | JUnit 5 | TestNG |
| Mocking | Mockito | PowerMock |
| HTTP testing | RestAssured | Spring MockMvc |
| E2E | Selenium | Playwright (Java) |
| Performance | JMeter | Gatling |
| Coverage | JaCoCo | Cobertura |
| Security | SpotBugs + FindSecBugs | SonarQube |

### 2.4 Go

| Purpose | Recommended | Alternative |
|---------|-------------|-------------|
| Unit + Integration | testing (stdlib) | — |
| Assertions | testify | gomega |
| HTTP testing | httptest (stdlib) | — |
| Mocking | gomock | testify/mock |
| E2E | Playwright (Go) | Selenium |
| Performance | k6 | vegeta |
| Coverage | go test -cover | — |

### 2.5 Selection Criteria

When choosing tools, evaluate against these criteria (weight 1-5):

| Criterion | Weight | Question |
|-----------|--------|----------|
| Tech stack compatibility | 5 | Does it work natively with our language/framework? |
| Team familiarity | 4 | Has the team used it before? |
| CI integration | 4 | Does it produce machine-readable reports (JUnit XML, LCOV)? |
| Community support | 3 | Active maintenance? Good docs? Stack Overflow presence? |
| License | 3 | Is the license compatible with our project? |
| Performance | 2 | How fast does it run the test suite? |
| Learning curve | 2 | How long to become productive? |

---

## 3. Environment Strategy

### 3.1 Local Development Environment

**Purpose**: Fast feedback loop for developers writing and debugging tests.

**Characteristics**:
- All dependencies run locally (Docker Compose or in-memory alternatives)
- Mocked external services (third-party APIs, email, payment)
- Environment variables from `.env.test`
- Database: real (containerized) for integration tests, mocked for unit tests
- Startup time: < 30 seconds

**Best practices**:
- Provide a single command to start all dependencies: `docker compose up -d`
- Provide a single command to run all tests: `npm test` or `pytest`
- Support running a single test file for fast iteration
- Hot reload for test-driven development

### 3.2 CI Environment

**Purpose**: Automated verification on every push/PR. The source of truth for test results.

**Characteristics**:
- Ephemeral: created fresh for each pipeline run
- Containerized dependencies (testcontainers or Docker Compose)
- Fresh database per run (no shared state between runs)
- Parallel test execution (sharding) for speed
- Machine-readable report output (JUnit XML, coverage LCOV)

**Pipeline stages**:
1. **Commit stage** (< 5 min): lint, type check, unit tests, coverage check
2. **PR stage** (< 15 min): integration tests, API tests, security scans
3. **Deploy stage** (< 30 min): E2E smoke tests against staging
4. **Release stage** (< 60 min): full E2E suite, performance tests

### 3.3 Staging Environment

**Purpose**: Production-like environment for final validation before release.

**Characteristics**:
- Mirrors production infrastructure (same cloud services, same configuration)
- Real integrations with sandbox/dev instances of external services
- Representative test data (production-like volume and variety)
- Accessible to QA team for manual exploratory testing
- Shared environment — coordinate access

### 3.4 Performance Environment

**Purpose**: Dedicated environment for load, stress, and soak testing. Isolated from other test activities.

**Characteristics**:
- Production-scale infrastructure (same instance types, same database size)
- Production-representative data volume
- Isolated network — no interference from other testing
- Monitoring and observability enabled (same as production)
- Used periodically (pre-release, not on every PR)

### 3.5 Mock vs Real Decision Matrix

| Dependency | Local | CI | Staging | Performance |
|------------|-------|----|---------|-------------|
| Own database | Real (container) | Real (container) | Real (managed) | Real (managed) |
| Own cache | Real (container) | Real (container) | Real (managed) | Real (managed) |
| Own message queue | Real (container) | Real (container) | Real (managed) | Real (managed) |
| Third-party API | Mock | Mock | Sandbox | Mock (controlled load) |
| Email service | Mock | Mock | Sandbox | Mock |
| Payment gateway | Mock | Mock | Sandbox | Mock |
| Auth provider | Mock or local | Mock or local | Real (dev tenant) | Mock |

---

## 4. NFR Testing Approaches

### 4.1 Performance Testing

**Types**:
- **Load testing**: Verify system handles expected concurrent load. Run at 1x expected peak for baseline.
- **Stress testing**: Find breaking point. Gradually increase load beyond capacity until errors/timeouts occur.
- **Spike testing**: Sudden burst of traffic (e.g., 10x normal in 10 seconds). Verify auto-scaling and recovery.
- **Soak testing**: Sustained load over extended period (4-8 hours). Detect memory leaks, connection pool exhaustion, log disk fill.

**Key metrics**:
| Metric | What it measures | Typical target |
|--------|-----------------|----------------|
| Response time p50 | Median user experience | < 200ms API, < 1s page load |
| Response time p95 | Tail latency | < 500ms API, < 3s page load |
| Response time p99 | Worst case | < 1s API, < 5s page load |
| Throughput (RPS) | System capacity | Depends on expected load |
| Error rate | Reliability under load | < 0.1% at expected load |
| CPU utilization | Resource efficiency | < 70% at expected load |
| Memory utilization | Resource efficiency | < 80% at expected load |

**Tools**: k6 (scriptable, CI-friendly), JMeter (GUI, complex scenarios), Locust (Python), Artillery (Node.js), Gatling (JVM).

### 4.2 Security Testing

**Layers**:
1. **SAST (Static Application Security Testing)**: Analyze source code for vulnerabilities. Run in CI on every PR. Tools: ESLint security plugin, Bandit, SpotBugs, SonarQube.
2. **Dependency scanning**: Check for known vulnerabilities in dependencies. Run in CI. Tools: npm audit, Snyk, Dependabot, Safety (Python).
3. **DAST (Dynamic Application Security Testing)**: Scan running application for vulnerabilities. Run against staging. Tools: OWASP ZAP, Burp Suite.
4. **Penetration testing**: Manual or semi-automated deep testing. Periodic (quarterly or pre-major-release). Internal team or external firm.

**OWASP Top 10 checklist** — verify test coverage for:
- A01: Broken Access Control
- A02: Cryptographic Failures
- A03: Injection
- A04: Insecure Design
- A05: Security Misconfiguration
- A06: Vulnerable Components
- A07: Authentication Failures
- A08: Data Integrity Failures
- A09: Logging Failures
- A10: SSRF

### 4.3 Availability Testing

**Types**:
- **Failover testing**: Kill primary instance, verify secondary takes over within SLA.
- **Recovery testing**: Simulate failure, measure time to recover (RTO).
- **Chaos testing**: Inject random failures (network partition, disk full, process kill). Tools: Chaos Monkey, Litmus, Gremlin.
- **Graceful degradation testing**: Disable non-critical services, verify core functionality continues.

**Metrics**: Recovery Time Objective (RTO), Recovery Point Objective (RPO), uptime percentage.

### 4.4 Scalability Testing

**Types**:
- **Horizontal scaling**: Add application instances, verify load distribution and session handling.
- **Database scaling**: Test connection pool limits, read replica lag, query performance at scale.
- **Cache scaling**: Test cache eviction under memory pressure, cold-start performance.
- **Data volume testing**: Run with 10x and 100x current data volume.

---

## 5. Risk-Based Test Prioritization

### 5.1 Risk-Test Matrix

Create a mapping between risks (from risk-register-final.md) and test scenarios:

| Risk ID | Risk Description | Severity | Likelihood | Risk Score | Test Scenarios | Test Level | Priority |
|---------|-----------------|----------|------------|------------|----------------|------------|----------|
| RISK-001 | {description} | {H/M/L} | {H/M/L} | {score} | {scenarios} | {level} | {P1/P2/P3} |

### 5.2 Priority Assignment

- **P1 (Critical)**: Risk score High. Full path coverage: happy path + all error paths + edge cases + performance. Automated. Run on every PR.
- **P2 (Important)**: Risk score Medium. Happy path + key error paths. Automated. Run on PR merge.
- **P3 (Standard)**: Risk score Low. Happy path only. Automated where cost-effective. Run before release.

### 5.3 Critical Path Analysis

From architecture sequence diagrams, identify the critical paths — the longest chains of component interactions for key user flows. These paths get:
- Integration tests covering the full chain
- Performance tests measuring end-to-end latency
- Failure injection tests at each component boundary

---

## 6. Coverage Target Setting

### 6.1 Code Coverage Guidelines

| Target | Recommendation | Rationale |
|--------|---------------|-----------|
| Line coverage | 80% | Covers most code paths without chasing diminishing returns |
| Branch coverage | 70% | More meaningful than line coverage, catches missed conditionals |
| Function coverage | 90% | Ensures all public APIs are exercised |
| 100% coverage | NOT recommended | Diminishing returns, leads to brittle tests that test implementation not behavior |

**Enforcement strategy**:
- Set as CI gate (fail the build if coverage drops below threshold)
- Use coverage ratchet: new code must not decrease overall coverage
- Exclude generated code, type definitions, and configuration files from coverage
- Track coverage trends over time (should be stable or increasing)

### 6.2 Requirement Coverage

| Priority | Target | Rationale |
|----------|--------|-----------|
| Must Have AC | 100% | Core functionality, cannot ship without verification |
| Should Have AC | 80% | Important but some can be verified manually |
| Could Have AC | 50% | Nice-to-have, manual verification acceptable |
| Won't Have AC | 0% | Not in scope |

### 6.3 Risk Coverage

| Risk Severity | Target | Approach |
|--------------|--------|----------|
| Critical | 100% | Full automated coverage, all paths |
| High | 90% | Automated happy + error paths |
| Medium | 70% | Automated happy path + key errors |
| Low | 50% | Automated happy path |

### 6.4 Mutation Testing

For critical business logic (payment processing, access control, data calculations):
- Use mutation testing to verify test quality (not just code coverage)
- Tools: Stryker (JS/TS), mutmut (Python), PIT (Java)
- Target: > 80% mutation score for critical modules
- Run periodically (weekly or pre-release), not on every PR (too slow)
