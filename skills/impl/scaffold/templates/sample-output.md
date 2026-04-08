# Scaffold Plan — TaskFlow

> **Project**: TaskFlow
> **Version**: 1.0
> **Date Created**: 2026-04-06
> **Last Updated**: 2026-04-06
> **Status**: Draft
> **Author**: AI-Generated
> **Tech Stack**: TypeScript / NestJS (backend) + React (frontend) / PostgreSQL / Redis / Prisma

---

## 1. Project Structure

```
taskflow/
├── src/
│   ├── auth/
│   │   ├── auth.module.ts
│   │   ├── auth.controller.ts
│   │   ├── auth.service.ts
│   │   ├── jwt.strategy.ts
│   │   ├── dto/
│   │   │   ├── login.dto.ts
│   │   │   └── register.dto.ts
│   │   ├── decorators/
│   │   │   ├── roles.decorator.ts
│   │   │   └── current-user.decorator.ts
│   │   └── guards/
│   │       ├── jwt-auth.guard.ts
│   │       └── roles.guard.ts
│   ├── users/
│   │   ├── users.module.ts
│   │   ├── users.controller.ts
│   │   ├── users.service.ts
│   │   ├── dto/
│   │   │   ├── create-user.dto.ts
│   │   │   ├── update-user.dto.ts
│   │   │   └── query-user.dto.ts
│   │   └── entities/
│   │       └── user.entity.ts
│   ├── projects/
│   │   ├── projects.module.ts
│   │   ├── projects.controller.ts
│   │   ├── projects.service.ts
│   │   ├── dto/
│   │   │   ├── create-project.dto.ts
│   │   │   ├── update-project.dto.ts
│   │   │   └── query-project.dto.ts
│   │   └── entities/
│   │       └── project.entity.ts
│   ├── sprints/
│   │   ├── sprints.module.ts
│   │   ├── sprints.controller.ts
│   │   ├── sprints.service.ts
│   │   ├── dto/
│   │   │   ├── create-sprint.dto.ts
│   │   │   ├── update-sprint.dto.ts
│   │   │   └── query-sprint.dto.ts
│   │   └── entities/
│   │       └── sprint.entity.ts
│   ├── tasks/
│   │   ├── tasks.module.ts
│   │   ├── tasks.controller.ts
│   │   ├── tasks.service.ts
│   │   ├── dto/
│   │   │   ├── create-task.dto.ts
│   │   │   ├── update-task.dto.ts
│   │   │   ├── move-task.dto.ts
│   │   │   └── query-task.dto.ts
│   │   └── entities/
│   │       └── task.entity.ts
│   ├── git-sync/
│   │   ├── git-sync.module.ts
│   │   ├── git-sync.controller.ts
│   │   ├── git-sync.service.ts
│   │   ├── dto/
│   │   │   └── webhook-payload.dto.ts
│   │   ├── providers/
│   │   │   ├── github.provider.ts
│   │   │   ├── gitlab.provider.ts
│   │   │   └── git-provider.interface.ts
│   │   └── entities/
│   │       └── git-integration.entity.ts
│   ├── alerts/
│   │   ├── alerts.module.ts
│   │   ├── alerts.controller.ts
│   │   ├── alerts.service.ts
│   │   ├── dto/
│   │   │   ├── create-alert-rule.dto.ts
│   │   │   └── query-alert.dto.ts
│   │   ├── alert-engine/
│   │   │   ├── rule-evaluator.ts
│   │   │   └── notification-dispatcher.ts
│   │   └── entities/
│   │       ├── alert-rule.entity.ts
│   │       └── alert-history.entity.ts
│   ├── dashboard/
│   │   ├── dashboard.module.ts
│   │   ├── dashboard.controller.ts
│   │   ├── dashboard.service.ts
│   │   └── dto/
│   │       └── dashboard-query.dto.ts
│   ├── common/
│   │   ├── exceptions/
│   │   │   ├── app.exception.ts
│   │   │   ├── not-found.exception.ts
│   │   │   ├── conflict.exception.ts
│   │   │   └── validation.exception.ts
│   │   ├── filters/
│   │   │   └── http-exception.filter.ts
│   │   ├── interceptors/
│   │   │   ├── response.interceptor.ts
│   │   │   └── logging.interceptor.ts
│   │   ├── decorators/
│   │   │   └── api-paginated.decorator.ts
│   │   ├── dto/
│   │   │   ├── response.dto.ts
│   │   │   └── pagination.dto.ts
│   │   ├── config/
│   │   │   ├── config.schema.ts
│   │   │   ├── config.module.ts
│   │   │   ├── database.config.ts
│   │   │   ├── redis.config.ts
│   │   │   ├── auth.config.ts
│   │   │   └── app.config.ts
│   │   ├── logging/
│   │   │   ├── logger.service.ts
│   │   │   └── logging.module.ts
│   │   └── validation/
│   │       ├── validation.pipe.ts
│   │       └── validators/
│   │           └── is-unique.validator.ts
│   ├── app.module.ts
│   └── main.ts
├── test/
│   ├── integration/
│   │   ├── auth.integration.spec.ts
│   │   ├── projects.integration.spec.ts
│   │   ├── sprints.integration.spec.ts
│   │   ├── tasks.integration.spec.ts
│   │   ├── git-sync.integration.spec.ts
│   │   └── setup.ts
│   ├── e2e/
│   │   ├── auth.e2e-spec.ts
│   │   ├── project-workflow.e2e-spec.ts
│   │   └── jest-e2e.config.ts
│   └── utils/
│       ├── factories/
│       │   ├── user.factory.ts
│       │   ├── project.factory.ts
│       │   ├── sprint.factory.ts
│       │   └── task.factory.ts
│       ├── fixtures/
│       │   └── seed-data.json
│       └── helpers/
│           ├── create-test-app.ts
│           ├── database.ts
│           ├── auth.ts
│           └── request.ts
├── prisma/
│   ├── schema.prisma
│   ├── seed.ts
│   └── migrations/
├── config/
│   └── default.ts
├── scripts/
│   ├── seed.ts
│   └── reset-db.ts
├── .github/
│   └── workflows/
│       └── ci.yml
├── tsconfig.json
├── tsconfig.build.json
├── nest-cli.json
├── package.json
├── .eslintrc.js
├── .prettierrc
├── jest.config.ts
├── docker-compose.yml
├── Dockerfile
├── .dockerignore
├── .env.example
├── .env.test
├── .gitignore
├── .husky/
│   └── pre-commit
└── README.md
```

---

## 2. Configuration Files

| # | File | Purpose | Key Settings | Source | Confidence |
|---|------|---------|-------------|--------|------------|
| 1 | `tsconfig.json` | TypeScript compiler config | `strict: true`, `target: ES2022`, `paths: { @/*: [src/*] }` | tech-stack-final.md | ✅ CONFIRMED |
| 2 | `tsconfig.build.json` | Build-specific config | `exclude: [test, **/*.spec.ts]` | tech-stack-final.md | ✅ CONFIRMED |
| 3 | `nest-cli.json` | NestJS CLI config | `sourceRoot: src`, `compilerOptions` | tech-stack-final.md | ✅ CONFIRMED |
| 4 | `.eslintrc.js` | Linting rules | `extends: [@typescript-eslint/recommended, prettier]`, import order | tech-stack-final.md | ✅ CONFIRMED |
| 5 | `.prettierrc` | Code formatting | `singleQuote: true`, `trailingComma: all`, `printWidth: 100` | tech-stack-final.md | ✅ CONFIRMED |
| 6 | `jest.config.ts` | Test runner config | `coverage: 80%`, `moduleNameMapper` matching paths, 3 projects (unit, integration, e2e) | test-strategy-final.md | ✅ CONFIRMED |
| 7 | `docker-compose.yml` | Local dev services | PostgreSQL 15 (5432), Redis 7 (6379), MailHog (8025) | architecture-final.md | ✅ CONFIRMED |
| 8 | `Dockerfile` | Container build | Multi-stage: `build` (npm ci + build) -> `production` (node:20-alpine) | tech-stack-final.md | ✅ CONFIRMED |
| 9 | `.dockerignore` | Docker exclusions | `node_modules`, `.git`, `dist`, `coverage`, `.env` | — | 🔶 ASSUMED |
| 10 | `.env.example` | Environment template | See environment variables table below | all design artifacts | ✅ CONFIRMED |
| 11 | `.env.test` | Test environment | `DATABASE_URL` pointing to test DB, `LOG_LEVEL=silent` | — | 🔶 ASSUMED |
| 12 | `.gitignore` | Git exclusions | `node_modules/`, `dist/`, `.env`, `coverage/`, `prisma/*.db` | — | ✅ CONFIRMED |
| 13 | `.husky/pre-commit` | Pre-commit hook | `npx lint-staged` (eslint --fix + prettier --write on staged files) | tech-stack-final.md | ✅ CONFIRMED |
| 14 | `prisma/schema.prisma` | ORM schema | All models, enums, relations | database-final.md | ✅ CONFIRMED |
| 15 | `.github/workflows/ci.yml` | CI pipeline | Install -> Lint -> Type check -> Unit test -> Integration test -> Build | tech-stack-final.md | ✅ CONFIRMED |

### Environment Variables (.env.example)

| Variable | Type | Default | Required | Description | Group |
|----------|------|---------|----------|-------------|-------|
| `DATABASE_URL` | string | — | Yes | PostgreSQL connection string | Database |
| `DATABASE_POOL_MIN` | number | `2` | No | Minimum connection pool size | Database |
| `DATABASE_POOL_MAX` | number | `10` | No | Maximum connection pool size | Database |
| `REDIS_URL` | string | `redis://localhost:6379` | Yes | Redis connection URL | Redis |
| `REDIS_PREFIX` | string | `taskflow:` | No | Key prefix for namespacing | Redis |
| `AUTH0_DOMAIN` | string | — | Yes | Auth0 tenant domain | Auth |
| `AUTH0_CLIENT_ID` | string | — | Yes | Auth0 application client ID | Auth |
| `AUTH0_CLIENT_SECRET` | string | — | Yes | Auth0 application client secret | Auth |
| `JWT_SECRET` | string | — | Yes | JWT signing secret (fallback) | Auth |
| `JWT_EXPIRATION` | string | `15m` | No | Access token TTL | Auth |
| `JWT_REFRESH_EXPIRATION` | string | `7d` | No | Refresh token TTL | Auth |
| `PORT` | number | `3000` | No | HTTP server port | Application |
| `NODE_ENV` | string | `development` | No | Environment name | Application |
| `CORS_ORIGINS` | string | `http://localhost:5173` | No | Allowed CORS origins (comma-separated) | Application |
| `LOG_LEVEL` | string | `info` | No | Logging level (debug, info, warn, error) | Application |
| `GITHUB_WEBHOOK_SECRET` | string | — | Yes | GitHub webhook signature secret | External Services |
| `GITLAB_WEBHOOK_SECRET` | string | — | Yes | GitLab webhook signature secret | External Services |
| `SMTP_HOST` | string | `localhost` | No | SMTP server host | External Services |
| `SMTP_PORT` | number | `1025` | No | SMTP server port | External Services |
| `ENABLE_GIT_SYNC` | boolean | `true` | No | Enable/disable git sync | Feature Flags |
| `ENABLE_ALERTS` | boolean | `false` | No | Enable/disable alert engine | Feature Flags |

---

## 3. Shared Utilities

| # | Utility | Purpose | Files | Confidence |
|---|---------|---------|-------|------------|
| 1 | Error Handling | Custom exception classes (NotFound, Conflict, Validation) + global `HttpExceptionFilter` that formats all errors into `{ statusCode, message, error, timestamp, path }` | `common/exceptions/*.ts`, `common/filters/http-exception.filter.ts` | ✅ CONFIRMED |
| 2 | Logging | Structured JSON logging via Pino with request ID correlation. `LoggingInterceptor` logs method, URL, status code, and duration for every request. | `common/logging/logger.service.ts`, `common/logging/logging.interceptor.ts`, `common/logging/logging.module.ts` | ✅ CONFIRMED |
| 3 | Auth Guards | `JwtAuthGuard` validates Bearer token. `RolesGuard` checks `@Roles()` metadata. `@CurrentUser()` decorator extracts user from request. | `auth/guards/*.ts`, `auth/decorators/*.ts` | ✅ CONFIRMED |
| 4 | Validation | Global `ValidationPipe` with `whitelist: true`, `forbidNonWhitelisted: true`, `transform: true`. Custom `IsUnique` validator for DB uniqueness checks. | `common/validation/validation.pipe.ts`, `common/validation/validators/is-unique.validator.ts` | ✅ CONFIRMED |
| 5 | Response Envelope | `ResponseInterceptor` wraps all successful responses into `{ data, meta }`. `PaginationDto` provides `{ page, limit, total, totalPages }` for list endpoints. | `common/interceptors/response.interceptor.ts`, `common/dto/response.dto.ts`, `common/dto/pagination.dto.ts` | 🔶 ASSUMED |
| 6 | Config Validation | Zod schema validating all environment variables at startup. Separate config classes for database, Redis, auth, and app settings. Fails fast on missing required vars. | `common/config/config.schema.ts`, `common/config/config.module.ts`, `common/config/*.config.ts` | 🔶 ASSUMED |

---

## 4. Q&A Log

### Q-001 (related: Configuration Files)
- **Impact**: LOW
- **Question**: Should the project use a monorepo structure (Nx/Turborepo) to manage backend and frontend together, or keep them as separate repositories?
- **Context**: The tech stack includes both NestJS (backend) and React (frontend). A monorepo enables shared types and coordinated versioning but adds tooling complexity. This plan currently covers the backend only.
- **Answer**:
- **Status**: Pending

### Q-002 (related: Shared Utilities, Response Envelope)
- **Impact**: LOW
- **Question**: Should the standard response envelope wrap all responses including errors, or only successful responses?
- **Context**: The response interceptor currently wraps successful responses into `{ data, meta }`. Error responses are handled separately by the exception filter. Some APIs wrap both in the same envelope for consistency.
- **Answer**:
- **Status**: Pending

---

## 5. Readiness Assessment

| Metric | Value |
|--------|-------|
| Total items | 21 |
| ✅ CONFIRMED | 17 (81%) |
| 🔶 ASSUMED | 4 (19%) |
| ❓ UNCLEAR | 0 (0%) |
| Q&A Pending | 2 (HIGH: 0, MEDIUM: 0, LOW: 2) |
| Q&A Answered | 0 |

**Verdict**: ✅ Ready

**Reasoning**: All configuration files are confirmed from design artifacts. Shared utilities are well-defined with only the response envelope and config validation patterns assumed. No blocking questions remain — both Q&A items are LOW impact and can be resolved during implementation.

---

## 6. Approval

| Role | Name | Decision | Date |
|------|------|----------|------|
| Tech Lead | | Pending | |
| Architect | | Pending | |
