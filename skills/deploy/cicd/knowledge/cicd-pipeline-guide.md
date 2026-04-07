# CI/CD Pipeline Design Guide

Techniques for designing robust, secure, and performant CI/CD pipelines from development workflow, test strategy, and technology stack inputs.

---

## Topic 1: Pipeline Architecture Patterns

Choose a pipeline architecture based on project complexity, team size, and deployment targets.

### Linear Pipeline

Stages run sequentially, one after another.

```
commit -> lint -> build -> test -> security -> deploy-staging -> e2e -> deploy-prod
```

- **When to use**: Small projects, single-service applications, teams < 5 developers
- **Pros**: Simple to understand, easy to debug, deterministic execution order
- **Cons**: Slow (no parallelization), bottleneck on long stages

### Fan-Out / Fan-In Pipeline

Independent stages run in parallel, then converge at a gate.

```
commit -> lint ──┐
         build ──┼── gate -> deploy-staging -> e2e -> deploy-prod
         test  ──┘
```

- **When to use**: Medium projects where lint/build/test are independent
- **Pros**: Faster feedback, efficient resource usage
- **Cons**: Slightly more complex configuration, requires merge gate logic

### Matrix Pipeline

Build and test across multiple configurations (OS, runtime version, etc.).

```
commit -> build(node18) + build(node20) + build(node22) -> gate -> deploy
```

- **When to use**: Libraries, packages consumed by others, cross-platform applications
- **Pros**: Catches compatibility issues early, ensures broad support
- **Cons**: Multiplies build minutes, longer total duration

### Environment Promotion Pipeline

Artifacts are built once, then promoted through environments.

```
commit -> build -> push artifact -> deploy-dev -> test -> deploy-staging -> e2e -> approve -> deploy-prod
```

- **When to use**: Any production application (recommended default)
- **Pros**: Same artifact tested and deployed everywhere, eliminates "works on my machine"
- **Cons**: Requires artifact registry, environment-specific configuration management

### Decision Matrix

| Factor | Linear | Fan-Out | Matrix | Promotion |
|--------|--------|---------|--------|-----------|
| Team size < 5 | Best | Good | Overkill | Good |
| Team size 5-15 | OK | Best | If needed | Best |
| Single service | Best | Good | N/A | Good |
| Multi-service | Poor | Good | N/A | Best |
| Library/SDK | OK | OK | Best | N/A |
| Production app | OK | Good | Optional | Best |

---

## Topic 2: Stage Design

Each pipeline stage has a specific purpose, expected duration, and failure criteria.

### Build Stages

| Stage | Purpose | Typical Duration | Failure Criteria |
|-------|---------|-----------------|------------------|
| **Lint / Format** | Code style enforcement | 1-3 min | Any lint error or format violation |
| **Type Check** | Static type verification | 1-2 min | Type errors (tsc, mypy, etc.) |
| **Compile / Bundle** | Produce build artifacts | 2-5 min | Compilation errors, bundle size exceeds limit |
| **Docker Build** | Create container image | 3-8 min | Dockerfile errors, image build failure |

### Test Stages

| Stage | Purpose | Typical Duration | Failure Criteria | Trigger |
|-------|---------|-----------------|------------------|---------|
| **Unit Tests** | Fast, isolated function tests | 1-5 min | Test failure or coverage < threshold | Every commit/PR |
| **Integration Tests** | Component interaction tests | 3-10 min | Test failure, service dependency issues | PR merge |
| **E2E Tests** | Full workflow validation | 5-20 min | Test failure, environment issues | Pre-deploy |
| **Smoke Tests** | Post-deploy health validation | 1-3 min | Critical path failure | Post-deploy |

### Security Stages

| Stage | Purpose | Typical Duration | Blocking? |
|-------|---------|-----------------|-----------|
| **SAST** | Static analysis of source code | 2-5 min | Blocking for critical/high |
| **SCA / Dependency Scan** | Known vulnerability in dependencies | 1-3 min | Blocking for critical |
| **Container Scan** | Vulnerabilities in Docker image | 2-5 min | Blocking for critical/high |
| **Secret Detection** | Leaked credentials in code | 1-2 min | Blocking (always) |
| **DAST** | Dynamic testing of running application | 10-30 min | Advisory (scheduled, not per-PR) |

### Deploy Stages

| Stage | Purpose | Typical Duration | Gate |
|-------|---------|-----------------|------|
| **Push Artifact** | Store build output (registry, S3) | 1-3 min | Blocking |
| **Deploy Staging** | Deploy to staging environment | 2-5 min | Blocking |
| **Deploy Production** | Deploy to production | 2-10 min | Manual approval + blocking |
| **Smoke Verify** | Validate production deployment | 1-3 min | Blocking (triggers rollback) |

---

## Topic 3: Deployment Strategies

### Rolling Update

Gradually replace old instances with new ones.

```
[v1] [v1] [v1] [v1]
[v2] [v1] [v1] [v1]  <- one instance updated
[v2] [v2] [v1] [v1]  <- two instances updated
[v2] [v2] [v2] [v2]  <- complete
```

- **Zero downtime**: Yes (if health checks pass)
- **Rollback speed**: Slow (must redeploy previous version)
- **Infrastructure cost**: No extra (in-place replacement)
- **Complexity**: Low
- **Best for**: Staging environments, low-risk services, cost-sensitive deployments

### Blue-Green Deployment

Run two identical environments; switch traffic instantly.

```
[Blue: v1] <- traffic    [Green: v2] <- idle
[Blue: v1] <- idle       [Green: v2] <- traffic  (switch)
```

- **Zero downtime**: Yes (instant switch)
- **Rollback speed**: Instant (switch back to blue)
- **Infrastructure cost**: 2x (duplicate environment)
- **Complexity**: Medium
- **Best for**: Production environments, high-availability requirements, databases with backward-compatible migrations

### Canary Deployment

Route a small percentage of traffic to the new version, then gradually increase.

```
[v1: 100%]
[v1: 95%] [v2: 5%]   <- canary deployed
[v1: 80%] [v2: 20%]  <- metrics look good
[v1: 50%] [v2: 50%]  <- continued rollout
[v2: 100%]            <- complete
```

- **Zero downtime**: Yes
- **Rollback speed**: Fast (route 100% back to v1)
- **Infrastructure cost**: Slightly more (canary instances)
- **Complexity**: High (requires traffic splitting, metric comparison)
- **Best for**: High-traffic applications, ML model deployments, feature-sensitive changes

### Feature Flags

Deploy code but control activation via configuration.

```
deploy v2 with feature_x=disabled
enable feature_x for internal users
enable feature_x for 10% of users
enable feature_x for all users
```

- **Zero downtime**: Yes (deployment is separate from activation)
- **Rollback speed**: Instant (disable flag)
- **Infrastructure cost**: None extra
- **Complexity**: Code complexity (flag management, cleanup)
- **Best for**: Large features, gradual rollout, A/B testing

### Decision Matrix

| Factor | Rolling | Blue-Green | Canary | Feature Flags |
|--------|---------|-----------|--------|---------------|
| Team < 5 | Best | OK | Overkill | If needed |
| Team 5-20 | Good | Best | Good | Good |
| Budget-sensitive | Best | Poor | Good | Best |
| High availability | OK | Best | Best | Good |
| Instant rollback needed | Poor | Best | Good | Best |
| Database migrations | OK | Best | Complex | N/A |
| Gradual exposure needed | No | No | Best | Best |

---

## Topic 4: Docker & Container Build

### Multi-Stage Build Pattern

Separate build dependencies from runtime to minimize image size and attack surface.

```dockerfile
# Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --production=false
COPY . .
RUN npm run build

# Stage 2: Runtime
FROM node:20-alpine
WORKDIR /app
RUN addgroup -g 1001 appgroup && adduser -u 1001 -G appgroup -s /bin/sh -D appuser
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
USER appuser
EXPOSE 3000
CMD ["node", "dist/main.js"]
```

### Layer Caching Optimization

Order Dockerfile instructions from least to most frequently changing:

1. Base image (rarely changes)
2. System dependencies (rarely changes)
3. Package manager lockfile + install (changes when dependencies update)
4. Application source code (changes every commit)

### Security Best Practices

| Practice | Why |
|----------|-----|
| Use non-root user (`USER appuser`) | Limits container escape impact |
| Use minimal base image (alpine, distroless) | Fewer CVEs, smaller attack surface |
| Never `COPY . .` before dependency install | Breaks layer cache |
| No secrets in image (use runtime env vars) | Secrets in layers are extractable |
| Pin base image version (`node:20.11-alpine`) | Reproducible builds |
| Run `npm ci` not `npm install` | Deterministic dependency resolution |

### Version Tagging Strategy

| Tag | Format | Purpose |
|-----|--------|---------|
| Git SHA short | `abc1234` | Unique per commit, traceable |
| Semver | `v1.2.3` | Release versioning |
| Branch | `main`, `develop` | Latest from branch (mutable) |
| Latest | `latest` | Convenience (never use in production) |

Recommended: Tag images with both git SHA and semver on release.

```
myapp:abc1234          <- every build
myapp:v1.2.3           <- on release tag
myapp:v1.2.3-abc1234   <- combined (most traceable)
```

### Registry Management

- Use private registries (ECR, GCR, ACR, GitLab Registry)
- Enable image scanning on push (most registries support this)
- Set lifecycle policies to clean up old images (e.g., keep last 50 tagged images)
- Use immutable tags in production (never overwrite a tag)

---

## Topic 5: Pipeline Security

### Secret Management

**Never** store secrets inline in pipeline configuration files.

| Approach | Platform | Example |
|----------|----------|---------|
| GitHub Secrets | GitHub Actions | `${{ secrets.AWS_ACCESS_KEY_ID }}` |
| GitLab CI/CD Variables | GitLab CI | `$AWS_ACCESS_KEY_ID` (protected, masked) |
| AWS Secrets Manager | Any | Fetch at runtime via SDK |
| HashiCorp Vault | Any | Dynamic secrets, leasing, rotation |
| SOPS | Any | Encrypted files in repo, decrypted at build |

### Dependency Scanning Tools

| Tool | Languages | Integration |
|------|-----------|-------------|
| `npm audit` | Node.js | Built-in, free |
| `pip audit` | Python | pip-audit package |
| Snyk | Multi-language | CLI, GitHub integration |
| Dependabot | Multi-language | GitHub native, auto-PRs |
| Renovate | Multi-language | Self-hosted or Mend.io |
| OWASP Dependency-Check | Java, .NET | CLI, CI plugin |

### Container Scanning Tools

| Tool | Features | Cost |
|------|----------|------|
| Trivy | OS + app vulnerabilities, fast | Free / open source |
| Grype | OS + app vulnerabilities | Free / open source |
| AWS ECR Scanning | Basic scanning on push | Included with ECR |
| Snyk Container | Deep analysis, fix advice | Paid |

### Secret Detection Tools

| Tool | Features | Cost |
|------|----------|------|
| gitleaks | Git history scanning, pre-commit hook | Free / open source |
| trufflehog | Deep scanning, verified secrets | Free / open source |
| GitHub Secret Scanning | Automatic, partner alerts | Free for public repos |
| GitLab Secret Detection | Built-in CI template | Included with GitLab |

### SAST Tools by Language

| Language | Tools |
|----------|-------|
| JavaScript/TypeScript | ESLint security plugin, Semgrep, SonarQube |
| Python | Bandit, Semgrep, SonarQube |
| Java | SpotBugs, PMD, SonarQube |
| Go | gosec, staticcheck, Semgrep |
| C/C++ | Cppcheck, Clang-Tidy, SonarQube |

### Least-Privilege Pipeline Credentials

- Use short-lived tokens (OIDC federation) instead of long-lived API keys
- Scope credentials to minimum required permissions (e.g., ECR push only, not admin)
- Rotate credentials on a schedule (90 days maximum)
- Audit credential usage via cloud provider logs

---

## Topic 6: Pipeline Optimization

### Caching Strategies

| Cache Type | What to Cache | Expected Savings |
|------------|--------------|-----------------|
| **Dependency cache** | `node_modules`, `.pip`, `.m2` | 30-60% of install time |
| **Docker layer cache** | Build layers via BuildKit | 50-80% of build time |
| **Build cache** | Compiled output, transpiled code | 20-40% of build time |
| **Test cache** | Test results for unchanged files | Variable |

#### GitHub Actions Caching Example

```yaml
- uses: actions/cache@v4
  with:
    path: ~/.npm
    key: npm-${{ hashFiles('**/package-lock.json') }}
    restore-keys: npm-
```

#### Docker BuildKit Cache Example

```yaml
- uses: docker/build-push-action@v5
  with:
    cache-from: type=gha
    cache-to: type=gha,mode=max
```

### Parallelization

Run independent stages simultaneously to reduce total pipeline duration.

```yaml
# These can run in parallel:
- lint          # ~2 min
- typecheck     # ~1 min
- unit-tests    # ~3 min

# Gate: all above must pass

# Then sequential:
- build         # ~4 min
- deploy        # ~3 min
```

**Total**: 3 min (parallel) + 4 min + 3 min = 10 min
**Without parallel**: 2 + 1 + 3 + 4 + 3 = 13 min

### Conditional Stages

Skip expensive stages when they are not needed.

| Condition | Skip Stage |
|-----------|------------|
| Only docs changed (`docs/**`, `*.md`) | Skip build, test, deploy |
| Only config changed (`.env.example`) | Skip build, run config validation |
| Dependency lockfile unchanged | Skip dependency install (use cache) |
| No source code changes | Skip lint, typecheck, unit tests |

#### GitHub Actions Path Filter Example

```yaml
on:
  pull_request:
    paths-ignore:
      - 'docs/**'
      - '*.md'
      - 'LICENSE'
```

### Duration Targets

| Pipeline Type | Target | Rationale |
|--------------|--------|-----------|
| PR / Feature branch | < 15 min | Developer waits for feedback |
| Main branch deploy | < 10 min | Fast path to staging |
| Production deploy | < 15 min | Including approval wait time |
| Hotfix deploy | < 10 min | Emergency path, minimal gates |

If pipeline exceeds targets:
1. Profile each stage to find bottlenecks
2. Parallelize independent stages
3. Add caching for slow install/build steps
4. Consider splitting into separate workflows (PR vs deploy)

### Cost Estimation

| Provider | Pricing Model | Approximate Cost |
|----------|--------------|-----------------|
| GitHub Actions | $0.008/min (Linux) | ~$40-80/mo for small team |
| GitLab CI | 400 min/mo free, then $10/1000 min | ~$30-60/mo for small team |
| AWS CodeBuild | $0.005/min (general1.small) | ~$25-50/mo for small team |
| Self-hosted runner | Infrastructure cost only | Variable (EC2, on-prem) |

Cost reduction strategies:
- Use caching to reduce build minutes
- Use conditional stages to skip unnecessary work
- Use spot/preemptible instances for self-hosted runners
- Schedule non-urgent jobs (DAST, full security scan) during off-peak hours
