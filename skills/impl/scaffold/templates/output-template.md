# Scaffold Plan Output Template

Expected structure for the project scaffolding plan artifact.

---

```markdown
# Scaffold Plan — {Project Name}

> **Project**: {Project Name}
> **Version**: {1.0}
> **Date Created**: {YYYY-MM-DD}
> **Last Updated**: {YYYY-MM-DD}
> **Status**: {Draft / In Review / Approved}
> **Author**: AI-Generated
> **Tech Stack**: {primary language + framework}

---

## 1. Project Structure

Full directory tree mirroring architecture components.

```
{project-name}/
├── src/
│   ├── {module-a}/
│   │   ├── ...
│   ├── {module-b}/
│   │   └── ...
│   ├── common/
│   │   ├── exceptions/
│   │   ├── filters/
│   │   ├── guards/
│   │   ├── interceptors/
│   │   ├── decorators/
│   │   ├── config/
│   │   └── logging/
│   ├── app.module.ts
│   └── main.ts
├── test/
│   ├── integration/
│   ├── e2e/
│   └── utils/
│       ├── factories/
│       ├── fixtures/
│       └── helpers/
├── prisma/
│   ├── schema.prisma
│   └── migrations/
├── config/
├── scripts/
├── .github/
│   └── workflows/
├── tsconfig.json
├── package.json
├── Dockerfile
├── docker-compose.yml
├── .env.example
├── .gitignore
└── README.md
```

---

## 2. Configuration Files

| # | File | Purpose | Key Settings | Source | Confidence |
|---|------|---------|-------------|--------|------------|
| 1 | `tsconfig.json` | TypeScript compiler | strict, paths, target ES2022 | tech-stack-final.md | {marker} |
| 2 | `tsconfig.build.json` | Build config | exclude tests | tech-stack-final.md | {marker} |
| 3 | `.eslintrc.js` | Linting rules | @typescript-eslint, prettier | tech-stack-final.md | {marker} |
| 4 | `.prettierrc` | Code formatting | singleQuote, trailingComma | tech-stack-final.md | {marker} |
| 5 | `jest.config.ts` | Test runner | coverage 80%, moduleNameMapper | test-strategy-final.md | {marker} |
| 6 | `docker-compose.yml` | Local dev services | DB, cache, mail | architecture-final.md | {marker} |
| 7 | `Dockerfile` | Container build | multi-stage (build, prod) | tech-stack-final.md | {marker} |
| 8 | `.env.example` | Environment template | all vars documented | all design artifacts | {marker} |
| 9 | `.gitignore` | Git exclusions | node_modules, dist, .env | — | {marker} |
| 10 | `.husky/pre-commit` | Git hooks | lint-staged | tech-stack-final.md | {marker} |
| 11 | `prisma/schema.prisma` | ORM schema | models, enums, relations | database-final.md | {marker} |
| 12 | `.github/workflows/ci.yml` | CI pipeline | lint, test, build | tech-stack-final.md | {marker} |

### Environment Variables

| Variable | Type | Default | Required | Description | Group |
|----------|------|---------|----------|-------------|-------|
| `DATABASE_URL` | string | — | Yes | PostgreSQL connection string | Database |
| `REDIS_URL` | string | `redis://localhost:6379` | No | Redis connection string | Cache |
| `JWT_SECRET` | string | — | Yes | JWT signing secret | Auth |
| `JWT_EXPIRES_IN` | string | `15m` | No | JWT token expiration | Auth |
| `PORT` | number | `3000` | No | Application port | App |
| ... | ... | ... | ... | ... | ... |

---

## 3. Shared Utilities

| # | Utility | Purpose | Files | Confidence |
|---|---------|---------|-------|------------|
| 1 | Error Handling | Custom exceptions + global filter | `common/exceptions/`, `common/filters/http-exception.filter.ts` | {marker} |
| 2 | Logging | Structured JSON logging | `common/logging/logger.service.ts`, `common/logging/logging.interceptor.ts` | {marker} |
| 3 | Auth Guards | JWT validation + role-based access | `common/guards/jwt-auth.guard.ts`, `common/guards/roles.guard.ts`, `common/decorators/` | {marker} |
| 4 | Validation | Global validation pipe + custom validators | `common/validation/validation.pipe.ts`, `common/validation/validators/` | {marker} |
| 5 | Response Envelope | Standard API response wrapper | `common/interceptors/response.interceptor.ts`, `common/dto/response.dto.ts` | {marker} |
| 6 | Config Validation | Environment variable validation | `common/config/config.schema.ts`, `common/config/*.config.ts` | {marker} |

---

## 4. Q&A Log

### Q-001 (related: {item IDs})
- **Impact**: HIGH / MEDIUM / LOW
- **Question**: {specific question}
- **Context**: {why this matters}
- **Answer**: {empty for create, filled for refine}
- **Status**: Pending

> Repeat for each question.

---

## 5. Readiness Assessment

| Metric | Value |
|--------|-------|
| Total items | {N} |
| CONFIRMED | {X} ({X/N x 100}%) |
| ASSUMED | {Y} ({Y/N x 100}%) |
| UNCLEAR | {Z} ({Z/N x 100}%) |
| Q&A Pending | {P} (HIGH: {H}, MEDIUM: {M}, LOW: {L}) |
| Q&A Answered | {A} |

**Verdict**: {Ready / Partially Ready / Not Ready}

**Reasoning**: {1-2 sentences explaining the verdict}

---

## 6. Approval

| Role | Name | Decision | Date |
|------|------|----------|------|
| Tech Lead | | Pending | |
| Architect | | Pending | |
```

---

## Change Log Template (for refine mode)

```markdown
## Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | YYYY-MM-DD | Initial creation |
| 2.0 | YYYY-MM-DD | {summary of changes} |
```

## Diff Summary Template (for refine mode)

```markdown
## Diff Summary (v{N-1} -> v{N})

| Category | Count |
|----------|-------|
| Items updated | {N} |
| Items added | {N} |
| Items removed | {N} |
| Q&A resolved | {N} |
| Q&A new | {N} |
| Confidence upgrades | {N} |

### Key Changes
- {bullet list of significant changes}
```
