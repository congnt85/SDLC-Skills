# Code Generation Plan — TaskFlow

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

## 2. Module Specifications

### 2.1 Auth Module

| Field | Value |
|-------|-------|
| **Architecture Component** | Authentication & Authorization |
| **Stories** | US-030, US-031, US-032, US-033 |
| **Dependencies** | Users module |
| **External Services** | Auth0 (identity provider), Redis (session cache) |
| **MVP** | Yes |
| **Confidence** | ✅ CONFIRMED — Source: architecture-final.md Section 3.1 |

**Files to Generate**:

| File | Pattern | Purpose |
|------|---------|---------|
| `auth.module.ts` | Module | Auth module definition with JWT, Passport imports |
| `auth.controller.ts` | Controller | Login, register, refresh token, logout endpoints |
| `auth.service.ts` | Service | Authentication logic, token generation, validation |
| `jwt.strategy.ts` | Strategy | Passport JWT strategy for token validation |
| `dto/login.dto.ts` | DTO | Email + password validation |
| `dto/register.dto.ts` | DTO | Registration fields validation |
| `decorators/roles.decorator.ts` | Decorator | `@Roles('admin', 'member')` metadata decorator |
| `decorators/current-user.decorator.ts` | Decorator | `@CurrentUser()` parameter decorator |
| `guards/jwt-auth.guard.ts` | Guard | JWT token validation guard |
| `guards/roles.guard.ts` | Guard | Role-based access control guard |

**Key Interfaces**:

```typescript
interface IAuthService {
  login(dto: LoginDto): Promise<{ accessToken: string; refreshToken: string }>;
  register(dto: RegisterDto): Promise<User>;
  refreshToken(token: string): Promise<{ accessToken: string }>;
  logout(userId: string): Promise<void>;
  validateUser(email: string, password: string): Promise<User | null>;
}

interface JwtPayload {
  sub: string;       // user ID
  email: string;
  roles: UserRole[];
  iat: number;
  exp: number;
}
```

---

### 2.2 Git Sync Module

| Field | Value |
|-------|-------|
| **Architecture Component** | Git Integration Service |
| **Stories** | US-001, US-002, US-003 |
| **Dependencies** | Projects module, Tasks module |
| **External Services** | GitHub API, GitLab API |
| **MVP** | Yes |
| **Confidence** | ✅ CONFIRMED — Source: architecture-final.md Section 3.5 |

**Files to Generate**:

| File | Pattern | Purpose |
|------|---------|---------|
| `git-sync.module.ts` | Module | Git sync module definition |
| `git-sync.controller.ts` | Controller | Webhook receiver + integration management |
| `git-sync.service.ts` | Service | Sync orchestration, event processing |
| `dto/webhook-payload.dto.ts` | DTO | Webhook payload validation (GitHub/GitLab) |
| `providers/git-provider.interface.ts` | Interface | Abstract git provider contract |
| `providers/github.provider.ts` | Provider | GitHub API implementation |
| `providers/gitlab.provider.ts` | Provider | GitLab API implementation |
| `entities/git-integration.entity.ts` | Entity | Git integration config entity |

**Key Interfaces**:

```typescript
interface IGitProvider {
  validateWebhook(payload: unknown, signature: string): boolean;
  parseEvent(payload: unknown): GitEvent;
  fetchCommit(repo: string, sha: string): Promise<CommitDetail>;
  fetchBranches(repo: string): Promise<Branch[]>;
}

interface GitEvent {
  type: 'push' | 'pull_request' | 'branch' | 'tag';
  repository: string;
  branch: string;
  commits: CommitSummary[];
  author: string;
  timestamp: Date;
}
```

---

### 2.3 Sprints Module

| Field | Value |
|-------|-------|
| **Architecture Component** | Sprint Management |
| **Stories** | US-010, US-011, US-012 |
| **Dependencies** | Projects module, Tasks module |
| **External Services** | — |
| **MVP** | Yes |
| **Confidence** | ✅ CONFIRMED — Source: architecture-final.md Section 3.3 |

**Files to Generate**:

| File | Pattern | Purpose |
|------|---------|---------|
| `sprints.module.ts` | Module | Sprint module definition |
| `sprints.controller.ts` | Controller | Sprint CRUD + start/complete actions |
| `sprints.service.ts` | Service | Sprint lifecycle logic, velocity calc |
| `dto/create-sprint.dto.ts` | DTO | Sprint creation validation |
| `dto/update-sprint.dto.ts` | DTO | Sprint update validation |
| `dto/query-sprint.dto.ts` | DTO | Sprint query filters (status, date range) |
| `entities/sprint.entity.ts` | Entity | Sprint ORM model |

**Key Interfaces**:

```typescript
interface ISprintService {
  findAll(projectId: string, query: QuerySprintDto): Promise<PaginatedResult<Sprint>>;
  findOne(id: string): Promise<Sprint>;
  create(dto: CreateSprintDto): Promise<Sprint>;
  update(id: string, dto: UpdateSprintDto): Promise<Sprint>;
  start(id: string): Promise<Sprint>;
  complete(id: string): Promise<SprintReport>;
  getVelocity(projectId: string, sprintCount: number): Promise<VelocityReport>;
}
```

---

### 2.4 Alerts Module

| Field | Value |
|-------|-------|
| **Architecture Component** | Alert Engine |
| **Stories** | US-020, US-021, US-022 |
| **Dependencies** | Projects module, Sprints module, Tasks module |
| **External Services** | Redis (pub/sub for real-time alerts), Email service |
| **MVP** | No `[FUTURE]` |
| **Confidence** | 🔶 ASSUMED — Reasoning: Alert engine is documented in architecture but may be deferred. Q&A ref: Q-001 |

**Files to Generate**:

| File | Pattern | Purpose |
|------|---------|---------|
| `alerts.module.ts` | Module | Alert module definition |
| `alerts.controller.ts` | Controller | Alert rule CRUD + history query |
| `alerts.service.ts` | Service | Alert rule management |
| `dto/create-alert-rule.dto.ts` | DTO | Alert rule creation validation |
| `dto/query-alert.dto.ts` | DTO | Alert history query filters |
| `alert-engine/rule-evaluator.ts` | Engine | Evaluates alert conditions against metrics |
| `alert-engine/notification-dispatcher.ts` | Engine | Dispatches notifications (email, in-app, webhook) |
| `entities/alert-rule.entity.ts` | Entity | Alert rule configuration entity |
| `entities/alert-history.entity.ts` | Entity | Alert trigger history entity |

**Key Interfaces**:

```typescript
interface IRuleEvaluator {
  evaluate(rule: AlertRule, context: MetricContext): EvaluationResult;
  evaluateAll(projectId: string): Promise<EvaluationResult[]>;
}

interface INotificationDispatcher {
  dispatch(alert: TriggeredAlert, channels: NotificationChannel[]): Promise<void>;
}
```

---

### 2.5 Remaining Modules (Summary)

| Module | Component | Stories | MVP | Confidence |
|--------|-----------|---------|-----|------------|
| Users | User Management | US-030, US-034 | Yes | ✅ CONFIRMED |
| Projects | Project Management | US-004, US-005, US-006 | Yes | ✅ CONFIRMED |
| Tasks | Task Management | US-013, US-014, US-015, US-016 | Yes | ✅ CONFIRMED |
| Dashboard | Reporting & Analytics | US-025, US-026, US-027 | Yes | 🔶 ASSUMED |

---

## 3. ORM Models

### 3.1 User

**Source Table**: `users` from database-final.md
**Confidence**: ✅ CONFIRMED

```typescript
// prisma/schema.prisma excerpt
model User {
  id          String      @id @default(uuid()) @db.Uuid
  email       String      @unique @db.VarChar(255)
  name        String      @db.VarChar(100)
  avatarUrl   String?     @db.VarChar(500) @map("avatar_url")
  role        UserRole    @default(MEMBER)
  isActive    Boolean     @default(true) @map("is_active")
  lastLoginAt DateTime?   @map("last_login_at") @db.Timestamptz
  createdAt   DateTime    @default(now()) @map("created_at") @db.Timestamptz
  updatedAt   DateTime    @updatedAt @map("updated_at") @db.Timestamptz

  // Relationships
  projects         ProjectMember[]
  assignedTasks    Task[]          @relation("assignee")
  createdTasks     Task[]          @relation("creator")
  comments         Comment[]

  @@map("users")
}

enum UserRole {
  ADMIN
  MEMBER
  VIEWER
}
```

---

### 3.2 Project

**Source Table**: `projects` from database-final.md
**Confidence**: ✅ CONFIRMED

```typescript
model Project {
  id          String        @id @default(uuid()) @db.Uuid
  name        String        @db.VarChar(200)
  key         String        @unique @db.VarChar(10)
  description String?       @db.Text
  status      ProjectStatus @default(ACTIVE)
  repoUrl     String?       @db.VarChar(500) @map("repo_url")
  createdAt   DateTime      @default(now()) @map("created_at") @db.Timestamptz
  updatedAt   DateTime      @updatedAt @map("updated_at") @db.Timestamptz

  // Relationships
  members     ProjectMember[]
  sprints     Sprint[]
  tasks       Task[]
  gitIntegrations GitIntegration[]

  @@map("projects")
}

enum ProjectStatus {
  ACTIVE
  ARCHIVED
  COMPLETED
}
```

---

### 3.3 Sprint

**Source Table**: `sprints` from database-final.md
**Confidence**: ✅ CONFIRMED

```typescript
model Sprint {
  id          String       @id @default(uuid()) @db.Uuid
  projectId   String       @map("project_id") @db.Uuid
  name        String       @db.VarChar(100)
  goal        String?      @db.Text
  status      SprintStatus @default(PLANNING)
  startDate   DateTime?    @map("start_date") @db.Date
  endDate     DateTime?    @map("end_date") @db.Date
  velocity    Int?
  createdAt   DateTime     @default(now()) @map("created_at") @db.Timestamptz
  updatedAt   DateTime     @updatedAt @map("updated_at") @db.Timestamptz

  // Relationships
  project     Project      @relation(fields: [projectId], references: [id])
  tasks       Task[]

  @@map("sprints")
}

enum SprintStatus {
  PLANNING
  ACTIVE
  COMPLETED
  CANCELLED
}
```

---

### 3.4 Task

**Source Table**: `tasks` from database-final.md
**Confidence**: ✅ CONFIRMED

```typescript
model Task {
  id          String       @id @default(uuid()) @db.Uuid
  projectId   String       @map("project_id") @db.Uuid
  sprintId    String?      @map("sprint_id") @db.Uuid
  assigneeId  String?      @map("assignee_id") @db.Uuid
  creatorId   String       @map("creator_id") @db.Uuid
  title       String       @db.VarChar(300)
  description String?      @db.Text
  status      TaskStatus   @default(TODO)
  priority    TaskPriority @default(MEDIUM)
  storyPoints Int?         @map("story_points")
  labels      String[]     @default([])
  dueDate     DateTime?    @map("due_date") @db.Date
  completedAt DateTime?    @map("completed_at") @db.Timestamptz
  createdAt   DateTime     @default(now()) @map("created_at") @db.Timestamptz
  updatedAt   DateTime     @updatedAt @map("updated_at") @db.Timestamptz

  // Relationships
  project     Project      @relation(fields: [projectId], references: [id])
  sprint      Sprint?      @relation(fields: [sprintId], references: [id])
  assignee    User?        @relation("assignee", fields: [assigneeId], references: [id])
  creator     User         @relation("creator", fields: [creatorId], references: [id])
  comments    Comment[]

  @@index([projectId, status])
  @@index([sprintId])
  @@index([assigneeId])
  @@map("tasks")
}

enum TaskStatus {
  TODO
  IN_PROGRESS
  IN_REVIEW
  DONE
  CANCELLED
}

enum TaskPriority {
  CRITICAL
  HIGH
  MEDIUM
  LOW
}
```

---

## 4. API Route Scaffolding

### 4.1 Projects Routes

**Source**: `projects` resource from api-final.md
**Controller File**: `src/projects/projects.controller.ts`
**Confidence**: ✅ CONFIRMED

| Method | Path | Handler | DTO | Auth | Rate Limit | Stories |
|--------|------|---------|-----|------|------------|---------|
| GET | `/api/v1/projects` | `findAll` | `QueryProjectDto` | Required | — | US-004 |
| GET | `/api/v1/projects/:id` | `findOne` | — | Required | — | US-004 |
| POST | `/api/v1/projects` | `create` | `CreateProjectDto` | Required | 10/min | US-005 |
| PATCH | `/api/v1/projects/:id` | `update` | `UpdateProjectDto` | Required | — | US-006 |
| DELETE | `/api/v1/projects/:id` | `remove` | — | Admin | — | US-006 |
| POST | `/api/v1/projects/:id/members` | `addMember` | `AddMemberDto` | Required | — | US-005 |
| DELETE | `/api/v1/projects/:id/members/:userId` | `removeMember` | — | Required | — | US-005 |

**Middleware/Guards**: `JwtAuthGuard` (all), `RolesGuard` (delete), `ProjectMemberGuard` (member actions)

---

### 4.2 Sprints Routes

**Source**: `sprints` resource from api-final.md
**Controller File**: `src/sprints/sprints.controller.ts`
**Confidence**: ✅ CONFIRMED

| Method | Path | Handler | DTO | Auth | Rate Limit | Stories |
|--------|------|---------|-----|------|------------|---------|
| GET | `/api/v1/projects/:projectId/sprints` | `findAll` | `QuerySprintDto` | Required | — | US-010 |
| GET | `/api/v1/sprints/:id` | `findOne` | — | Required | — | US-010 |
| POST | `/api/v1/projects/:projectId/sprints` | `create` | `CreateSprintDto` | Required | 5/min | US-011 |
| PATCH | `/api/v1/sprints/:id` | `update` | `UpdateSprintDto` | Required | — | US-011 |
| POST | `/api/v1/sprints/:id/start` | `start` | — | Required | — | US-012 |
| POST | `/api/v1/sprints/:id/complete` | `complete` | — | Required | — | US-012 |
| GET | `/api/v1/projects/:projectId/velocity` | `getVelocity` | — | Required | — | US-012 |

**Middleware/Guards**: `JwtAuthGuard` (all), `ProjectMemberGuard` (project-scoped routes)

---

### 4.3 Tasks Routes

**Source**: `tasks` resource from api-final.md
**Controller File**: `src/tasks/tasks.controller.ts`
**Confidence**: ✅ CONFIRMED

| Method | Path | Handler | DTO | Auth | Rate Limit | Stories |
|--------|------|---------|-----|------|------------|---------|
| GET | `/api/v1/projects/:projectId/tasks` | `findAll` | `QueryTaskDto` | Required | — | US-013 |
| GET | `/api/v1/tasks/:id` | `findOne` | — | Required | — | US-013 |
| POST | `/api/v1/projects/:projectId/tasks` | `create` | `CreateTaskDto` | Required | 20/min | US-014 |
| PATCH | `/api/v1/tasks/:id` | `update` | `UpdateTaskDto` | Required | — | US-015 |
| PATCH | `/api/v1/tasks/:id/move` | `move` | `MoveTaskDto` | Required | — | US-016 |
| DELETE | `/api/v1/tasks/:id` | `remove` | — | Required | — | US-015 |
| POST | `/api/v1/tasks/:id/comments` | `addComment` | `CreateCommentDto` | Required | 30/min | US-013 |

**Middleware/Guards**: `JwtAuthGuard` (all), `TaskOwnerGuard` (update/delete)

---

### 4.4 Webhooks Routes

**Source**: `webhooks` resource from api-final.md
**Controller File**: `src/git-sync/git-sync.controller.ts`
**Confidence**: ✅ CONFIRMED

| Method | Path | Handler | DTO | Auth | Rate Limit | Stories |
|--------|------|---------|-----|------|------------|---------|
| POST | `/api/v1/webhooks/github` | `handleGitHub` | `WebhookPayloadDto` | Webhook Secret | 100/min | US-001 |
| POST | `/api/v1/webhooks/gitlab` | `handleGitLab` | `WebhookPayloadDto` | Webhook Secret | 100/min | US-002 |
| GET | `/api/v1/projects/:projectId/integrations` | `findIntegrations` | — | Required | — | US-003 |
| POST | `/api/v1/projects/:projectId/integrations` | `createIntegration` | `CreateIntegrationDto` | Required | 5/min | US-003 |
| DELETE | `/api/v1/integrations/:id` | `removeIntegration` | — | Required | — | US-003 |

**Middleware/Guards**: `WebhookSignatureGuard` (webhook routes), `JwtAuthGuard` (integration management)

---

## 5. Configuration Files

| # | File | Purpose | Key Settings | Source |
|---|------|---------|-------------|--------|
| 1 | `tsconfig.json` | TypeScript compiler config | `strict: true`, `target: ES2022`, `paths: { @/*: [src/*] }` | tech-stack-final.md |
| 2 | `tsconfig.build.json` | Build-specific config | `exclude: [test, **/*.spec.ts]` | tech-stack-final.md |
| 3 | `nest-cli.json` | NestJS CLI config | `sourceRoot: src`, `compilerOptions` | tech-stack-final.md |
| 4 | `.eslintrc.js` | Linting rules | `extends: [@typescript-eslint/recommended, prettier]`, import order | tech-stack-final.md |
| 5 | `.prettierrc` | Code formatting | `singleQuote: true`, `trailingComma: all`, `printWidth: 100` | tech-stack-final.md |
| 6 | `jest.config.ts` | Test runner config | `coverage: 80%`, `moduleNameMapper` matching paths, 3 projects (unit, integration, e2e) | test-strategy-final.md |
| 7 | `docker-compose.yml` | Local dev services | PostgreSQL 15 (5432), Redis 7 (6379), MailHog (8025) | architecture-final.md |
| 8 | `Dockerfile` | Container build | Multi-stage: `build` (npm ci + build) -> `production` (node:20-alpine) | tech-stack-final.md |
| 9 | `.dockerignore` | Docker exclusions | `node_modules`, `.git`, `dist`, `coverage`, `.env` | — |
| 10 | `.env.example` | Environment template | See environment variables table below | all design artifacts |
| 11 | `.env.test` | Test environment | `DATABASE_URL` pointing to test DB, `LOG_LEVEL=silent` | — |
| 12 | `.gitignore` | Git exclusions | `node_modules/`, `dist/`, `.env`, `coverage/`, `prisma/*.db` | — |
| 13 | `.husky/pre-commit` | Pre-commit hook | `npx lint-staged` (eslint --fix + prettier --write on staged files) | tech-stack-final.md |
| 14 | `prisma/schema.prisma` | ORM schema | All models, enums, relations (see Section 3) | database-final.md |
| 15 | `.github/workflows/ci.yml` | CI pipeline | Install -> Lint -> Type check -> Unit test -> Integration test -> Build | tech-stack-final.md |

### Environment Variables (.env.example)

| Variable | Type | Default | Required | Description |
|----------|------|---------|----------|-------------|
| **Database** | | | | |
| `DATABASE_URL` | string | — | Yes | PostgreSQL connection string |
| `DATABASE_POOL_MIN` | number | `2` | No | Minimum connection pool size |
| `DATABASE_POOL_MAX` | number | `10` | No | Maximum connection pool size |
| **Redis** | | | | |
| `REDIS_URL` | string | `redis://localhost:6379` | Yes | Redis connection URL |
| `REDIS_PREFIX` | string | `taskflow:` | No | Key prefix for namespacing |
| **Auth** | | | | |
| `AUTH0_DOMAIN` | string | — | Yes | Auth0 tenant domain |
| `AUTH0_CLIENT_ID` | string | — | Yes | Auth0 application client ID |
| `AUTH0_CLIENT_SECRET` | string | — | Yes | Auth0 application client secret |
| `JWT_SECRET` | string | — | Yes | JWT signing secret (fallback) |
| `JWT_EXPIRATION` | string | `15m` | No | Access token TTL |
| `JWT_REFRESH_EXPIRATION` | string | `7d` | No | Refresh token TTL |
| **Application** | | | | |
| `PORT` | number | `3000` | No | HTTP server port |
| `NODE_ENV` | string | `development` | No | Environment name |
| `CORS_ORIGINS` | string | `http://localhost:5173` | No | Allowed CORS origins (comma-separated) |
| `LOG_LEVEL` | string | `info` | No | Logging level (debug, info, warn, error) |
| **External Services** | | | | |
| `GITHUB_WEBHOOK_SECRET` | string | — | Yes | GitHub webhook signature secret |
| `GITLAB_WEBHOOK_SECRET` | string | — | Yes | GitLab webhook signature secret |
| `SMTP_HOST` | string | `localhost` | No | SMTP server host |
| `SMTP_PORT` | number | `1025` | No | SMTP server port |
| **Feature Flags** | | | | |
| `ENABLE_GIT_SYNC` | boolean | `true` | No | Enable/disable git sync |
| `ENABLE_ALERTS` | boolean | `false` | No | Enable/disable alert engine |

---

## 6. Test Infrastructure

### 6.1 Directory Structure

```
test/
├── integration/
│   ├── auth.integration.spec.ts
│   ├── projects.integration.spec.ts
│   ├── sprints.integration.spec.ts
│   ├── tasks.integration.spec.ts
│   ├── git-sync.integration.spec.ts
│   └── setup.ts
├── e2e/
│   ├── auth.e2e-spec.ts
│   ├── project-workflow.e2e-spec.ts
│   └── jest-e2e.config.ts
└── utils/
    ├── factories/
    │   ├── user.factory.ts
    │   ├── project.factory.ts
    │   ├── sprint.factory.ts
    │   └── task.factory.ts
    ├── fixtures/
    │   └── seed-data.json
    └── helpers/
        ├── create-test-app.ts
        ├── database.ts
        ├── auth.ts
        └── request.ts
```

Co-located unit tests: `src/{module}/__tests__/{module}.service.spec.ts` next to source files.

### 6.2 Test Configuration

| Config | Setting | Value |
|--------|---------|-------|
| Framework | Test runner | Jest 29 |
| Coverage | Statement threshold | 80% |
| Coverage | Branch threshold | 75% |
| Coverage | Function threshold | 80% |
| Coverage | Line threshold | 80% |
| Unit | Pattern | `src/**/*.spec.ts` |
| Unit | Timeout | 5000ms |
| Integration | Pattern | `test/integration/**/*.spec.ts` |
| Integration | Timeout | 30000ms |
| Integration | Setup | `test/integration/setup.ts` (Prisma test client + DB reset) |
| E2E | Pattern | `test/e2e/**/*.spec.ts` |
| E2E | Timeout | 60000ms |
| E2E | Setup | `test/e2e/jest-e2e.config.ts` (full app bootstrap) |

### 6.3 Test Utilities

| Utility | Purpose | File |
|---------|---------|------|
| Test App Factory | Creates NestJS `TestingModule` with overridden providers, configures test database | `test/utils/helpers/create-test-app.ts` |
| Database Helper | Resets test database between tests using Prisma `$executeRaw`, seeds base data | `test/utils/helpers/database.ts` |
| Auth Helper | Generates valid JWT tokens for test users with configurable roles | `test/utils/helpers/auth.ts` |
| Request Helper | Supertest wrapper with `.asUser(role)` fluent API for authenticated requests | `test/utils/helpers/request.ts` |
| User Factory | Builds `User` entities with sensible defaults, supports `.withRole()` overrides | `test/utils/factories/user.factory.ts` |
| Project Factory | Builds `Project` entities with auto-generated key, supports `.withMembers()` | `test/utils/factories/project.factory.ts` |
| Sprint Factory | Builds `Sprint` entities linked to project, supports `.withStatus()` | `test/utils/factories/sprint.factory.ts` |
| Task Factory | Builds `Task` entities with linked project/sprint, supports `.withAssignee()` | `test/utils/factories/task.factory.ts` |

---

## 7. Shared Utilities

| # | Utility | Purpose | Files | Confidence |
|---|---------|---------|-------|------------|
| 1 | Error Handling | Custom exception classes (NotFound, Conflict, Validation) + global `HttpExceptionFilter` that formats all errors into `{ statusCode, message, error, timestamp, path }` | `common/exceptions/*.ts`, `common/filters/http-exception.filter.ts` | ✅ CONFIRMED |
| 2 | Logging | Structured JSON logging via Pino with request ID correlation. `LoggingInterceptor` logs method, URL, status code, and duration for every request. | `common/logging/logger.service.ts`, `common/logging/logging.interceptor.ts`, `common/logging/logging.module.ts` | ✅ CONFIRMED |
| 3 | Auth Guards | `JwtAuthGuard` validates Bearer token. `RolesGuard` checks `@Roles()` metadata. `@CurrentUser()` decorator extracts user from request. | `auth/guards/*.ts`, `auth/decorators/*.ts` | ✅ CONFIRMED |
| 4 | Validation | Global `ValidationPipe` with `whitelist: true`, `forbidNonWhitelisted: true`, `transform: true`. Custom `IsUnique` validator for DB uniqueness checks. | `common/validation/validation.pipe.ts`, `common/validation/validators/is-unique.validator.ts` | ✅ CONFIRMED |
| 5 | Response Envelope | `ResponseInterceptor` wraps all successful responses into `{ data, meta }`. `PaginationDto` provides `{ page, limit, total, totalPages }` for list endpoints. | `common/interceptors/response.interceptor.ts`, `common/dto/response.dto.ts`, `common/dto/pagination.dto.ts` | 🔶 ASSUMED |
| 6 | Config Validation | Zod schema validating all environment variables at startup. Separate config classes for database, Redis, auth, and app settings. Fails fast on missing required vars. | `common/config/config.schema.ts`, `common/config/config.module.ts`, `common/config/*.config.ts` | 🔶 ASSUMED |

---

## 8. File Inventory

### 8.1 Source Files

| # | File Path | Purpose | Source | MVP |
|---|-----------|---------|--------|-----|
| 1 | `src/main.ts` | Application entry point | architecture-final.md | Yes |
| 2 | `src/app.module.ts` | Root module definition | architecture-final.md | Yes |
| 3 | `src/auth/auth.module.ts` | Auth module definition | architecture-final.md | Yes |
| 4 | `src/auth/auth.controller.ts` | Auth endpoints | api-final.md | Yes |
| 5 | `src/auth/auth.service.ts` | Auth business logic | architecture-final.md | Yes |
| 6 | `src/auth/jwt.strategy.ts` | JWT validation strategy | architecture-final.md | Yes |
| 7 | `src/auth/dto/login.dto.ts` | Login request validation | api-final.md | Yes |
| 8 | `src/auth/dto/register.dto.ts` | Register request validation | api-final.md | Yes |
| 9 | `src/auth/decorators/roles.decorator.ts` | Roles metadata decorator | architecture-final.md | Yes |
| 10 | `src/auth/decorators/current-user.decorator.ts` | Current user extractor | architecture-final.md | Yes |
| 11 | `src/auth/guards/jwt-auth.guard.ts` | JWT auth guard | architecture-final.md | Yes |
| 12 | `src/auth/guards/roles.guard.ts` | Role-based access guard | architecture-final.md | Yes |
| 13 | `src/users/users.module.ts` | Users module definition | architecture-final.md | Yes |
| 14 | `src/users/users.controller.ts` | Users endpoints | api-final.md | Yes |
| 15 | `src/users/users.service.ts` | Users business logic | architecture-final.md | Yes |
| 16 | `src/users/dto/create-user.dto.ts` | User creation validation | api-final.md | Yes |
| 17 | `src/users/dto/update-user.dto.ts` | User update validation | api-final.md | Yes |
| 18 | `src/users/dto/query-user.dto.ts` | User query filters | api-final.md | Yes |
| 19 | `src/projects/projects.module.ts` | Projects module definition | architecture-final.md | Yes |
| 20 | `src/projects/projects.controller.ts` | Projects endpoints | api-final.md | Yes |
| 21 | `src/projects/projects.service.ts` | Projects business logic | architecture-final.md | Yes |
| 22 | `src/projects/dto/create-project.dto.ts` | Project creation validation | api-final.md | Yes |
| 23 | `src/projects/dto/update-project.dto.ts` | Project update validation | api-final.md | Yes |
| 24 | `src/projects/dto/query-project.dto.ts` | Project query filters | api-final.md | Yes |
| 25 | `src/sprints/sprints.module.ts` | Sprints module definition | architecture-final.md | Yes |
| 26 | `src/sprints/sprints.controller.ts` | Sprints endpoints | api-final.md | Yes |
| 27 | `src/sprints/sprints.service.ts` | Sprints business logic | architecture-final.md | Yes |
| 28 | `src/sprints/dto/create-sprint.dto.ts` | Sprint creation validation | api-final.md | Yes |
| 29 | `src/sprints/dto/update-sprint.dto.ts` | Sprint update validation | api-final.md | Yes |
| 30 | `src/sprints/dto/query-sprint.dto.ts` | Sprint query filters | api-final.md | Yes |
| 31 | `src/tasks/tasks.module.ts` | Tasks module definition | architecture-final.md | Yes |
| 32 | `src/tasks/tasks.controller.ts` | Tasks endpoints | api-final.md | Yes |
| 33 | `src/tasks/tasks.service.ts` | Tasks business logic | architecture-final.md | Yes |
| 34 | `src/tasks/dto/create-task.dto.ts` | Task creation validation | api-final.md | Yes |
| 35 | `src/tasks/dto/update-task.dto.ts` | Task update validation | api-final.md | Yes |
| 36 | `src/tasks/dto/move-task.dto.ts` | Task move validation | api-final.md | Yes |
| 37 | `src/tasks/dto/query-task.dto.ts` | Task query filters | api-final.md | Yes |
| 38 | `src/git-sync/git-sync.module.ts` | Git sync module definition | architecture-final.md | Yes |
| 39 | `src/git-sync/git-sync.controller.ts` | Webhook + integration endpoints | api-final.md | Yes |
| 40 | `src/git-sync/git-sync.service.ts` | Git sync orchestration | architecture-final.md | Yes |
| 41 | `src/git-sync/dto/webhook-payload.dto.ts` | Webhook payload validation | api-final.md | Yes |
| 42 | `src/git-sync/providers/git-provider.interface.ts` | Git provider contract | architecture-final.md | Yes |
| 43 | `src/git-sync/providers/github.provider.ts` | GitHub API integration | architecture-final.md | Yes |
| 44 | `src/git-sync/providers/gitlab.provider.ts` | GitLab API integration | architecture-final.md | Yes |
| 45 | `src/alerts/alerts.module.ts` | Alerts module definition | architecture-final.md | No |
| 46 | `src/alerts/alerts.controller.ts` | Alert rule endpoints | api-final.md | No |
| 47 | `src/alerts/alerts.service.ts` | Alert rule management | architecture-final.md | No |
| 48 | `src/alerts/dto/create-alert-rule.dto.ts` | Alert rule validation | api-final.md | No |
| 49 | `src/alerts/dto/query-alert.dto.ts` | Alert history filters | api-final.md | No |
| 50 | `src/alerts/alert-engine/rule-evaluator.ts` | Rule condition evaluation | architecture-final.md | No |
| 51 | `src/alerts/alert-engine/notification-dispatcher.ts` | Notification dispatch | architecture-final.md | No |
| 52 | `src/dashboard/dashboard.module.ts` | Dashboard module definition | architecture-final.md | Yes |
| 53 | `src/dashboard/dashboard.controller.ts` | Dashboard endpoints | api-final.md | Yes |
| 54 | `src/dashboard/dashboard.service.ts` | Reporting/analytics logic | architecture-final.md | Yes |
| 55 | `src/dashboard/dto/dashboard-query.dto.ts` | Dashboard query filters | api-final.md | Yes |
| 56 | `src/common/exceptions/app.exception.ts` | Base exception class | — | Yes |
| 57 | `src/common/exceptions/not-found.exception.ts` | 404 exception | — | Yes |
| 58 | `src/common/exceptions/conflict.exception.ts` | 409 exception | — | Yes |
| 59 | `src/common/exceptions/validation.exception.ts` | 422 exception | — | Yes |
| 60 | `src/common/filters/http-exception.filter.ts` | Global exception filter | — | Yes |
| 61 | `src/common/interceptors/response.interceptor.ts` | Response envelope wrapper | — | Yes |
| 62 | `src/common/interceptors/logging.interceptor.ts` | Request/response logging | — | Yes |
| 63 | `src/common/dto/response.dto.ts` | Standard response shape | — | Yes |
| 64 | `src/common/dto/pagination.dto.ts` | Pagination metadata | — | Yes |
| 65 | `src/common/config/config.schema.ts` | Env var validation schema | — | Yes |
| 66 | `src/common/config/config.module.ts` | Config module | — | Yes |
| 67 | `src/common/config/database.config.ts` | Database config | — | Yes |
| 68 | `src/common/config/redis.config.ts` | Redis config | — | Yes |
| 69 | `src/common/config/auth.config.ts` | Auth/JWT config | — | Yes |
| 70 | `src/common/config/app.config.ts` | App config (port, CORS) | — | Yes |
| 71 | `src/common/logging/logger.service.ts` | Structured logger | — | Yes |
| 72 | `src/common/logging/logging.module.ts` | Logger module | — | Yes |
| 73 | `src/common/validation/validation.pipe.ts` | Global validation pipe | — | Yes |
| 74 | `src/common/validation/validators/is-unique.validator.ts` | DB uniqueness validator | — | Yes |
| 75 | `src/common/decorators/api-paginated.decorator.ts` | Swagger pagination decorator | — | Yes |

### 8.2 Test Files

| # | File Path | Purpose | Source | MVP |
|---|-----------|---------|--------|-----|
| 1 | `src/auth/__tests__/auth.service.spec.ts` | Auth service unit tests | — | Yes |
| 2 | `src/users/__tests__/users.service.spec.ts` | Users service unit tests | — | Yes |
| 3 | `src/projects/__tests__/projects.service.spec.ts` | Projects service unit tests | — | Yes |
| 4 | `src/sprints/__tests__/sprints.service.spec.ts` | Sprints service unit tests | — | Yes |
| 5 | `src/tasks/__tests__/tasks.service.spec.ts` | Tasks service unit tests | — | Yes |
| 6 | `src/git-sync/__tests__/git-sync.service.spec.ts` | Git sync service unit tests | — | Yes |
| 7 | `src/dashboard/__tests__/dashboard.service.spec.ts` | Dashboard service unit tests | — | Yes |
| 8 | `test/integration/auth.integration.spec.ts` | Auth flow integration tests | — | Yes |
| 9 | `test/integration/projects.integration.spec.ts` | Project CRUD integration tests | — | Yes |
| 10 | `test/integration/sprints.integration.spec.ts` | Sprint lifecycle integration tests | — | Yes |
| 11 | `test/integration/tasks.integration.spec.ts` | Task CRUD + move integration tests | — | Yes |
| 12 | `test/integration/git-sync.integration.spec.ts` | Webhook processing integration tests | — | Yes |
| 13 | `test/integration/setup.ts` | Integration test setup (Prisma client, DB reset) | — | Yes |
| 14 | `test/e2e/auth.e2e-spec.ts` | Auth end-to-end flow | — | Yes |
| 15 | `test/e2e/project-workflow.e2e-spec.ts` | Full project workflow E2E | — | Yes |
| 16 | `test/e2e/jest-e2e.config.ts` | E2E test configuration | — | Yes |
| 17 | `test/utils/factories/user.factory.ts` | User test data factory | — | Yes |
| 18 | `test/utils/factories/project.factory.ts` | Project test data factory | — | Yes |
| 19 | `test/utils/factories/sprint.factory.ts` | Sprint test data factory | — | Yes |
| 20 | `test/utils/factories/task.factory.ts` | Task test data factory | — | Yes |
| 21 | `test/utils/fixtures/seed-data.json` | Static seed data | — | Yes |
| 22 | `test/utils/helpers/create-test-app.ts` | Test app factory | — | Yes |
| 23 | `test/utils/helpers/database.ts` | Test database helper | — | Yes |
| 24 | `test/utils/helpers/auth.ts` | Test auth helper | — | Yes |
| 25 | `test/utils/helpers/request.ts` | Test request helper | — | Yes |

### 8.3 Configuration Files

| # | File Path | Purpose | Source | MVP |
|---|-----------|---------|--------|-----|
| 1 | `tsconfig.json` | TypeScript compiler config | tech-stack-final.md | Yes |
| 2 | `tsconfig.build.json` | Build-specific config | tech-stack-final.md | Yes |
| 3 | `nest-cli.json` | NestJS CLI config | tech-stack-final.md | Yes |
| 4 | `.eslintrc.js` | Linting rules | tech-stack-final.md | Yes |
| 5 | `.prettierrc` | Code formatting | tech-stack-final.md | Yes |
| 6 | `jest.config.ts` | Test runner config | test-strategy-final.md | Yes |
| 7 | `docker-compose.yml` | Local dev services | architecture-final.md | Yes |
| 8 | `Dockerfile` | Container image build | tech-stack-final.md | Yes |
| 9 | `.dockerignore` | Docker build exclusions | — | Yes |
| 10 | `.env.example` | Environment variable template | all design artifacts | Yes |
| 11 | `.env.test` | Test environment config | — | Yes |
| 12 | `.gitignore` | Git exclusions | — | Yes |
| 13 | `.husky/pre-commit` | Pre-commit lint hook | tech-stack-final.md | Yes |
| 14 | `prisma/schema.prisma` | ORM schema definition | database-final.md | Yes |
| 15 | `prisma/seed.ts` | Database seed script | database-final.md | Yes |
| 16 | `.github/workflows/ci.yml` | CI pipeline | tech-stack-final.md | Yes |
| 17 | `package.json` | Dependencies and scripts | tech-stack-final.md | Yes |
| 18 | `scripts/seed.ts` | Seed script runner | — | Yes |
| 19 | `scripts/reset-db.ts` | Database reset utility | — | Yes |

### 8.4 Summary

| Category | Count |
|----------|-------|
| Source files | 75 |
| Test files | 25 |
| Configuration files | 19 |
| **Total** | **119** |
| MVP files | 112 |
| `[FUTURE]` files | 7 |

---

## 9. Q&A Log

### Q-001 (related: Alerts Module)
- **Impact**: MEDIUM
- **Question**: Should the Alert Engine module be included in MVP or deferred to a later release?
- **Context**: The architecture document includes the alert engine as a component, but it has complex dependencies on metrics aggregation and notification infrastructure. Deferring it reduces MVP scope by 7 files.
- **Answer**:
- **Status**: ⏳ Pending

### Q-002 (related: Configuration Files)
- **Impact**: LOW
- **Question**: Should the project use a monorepo structure (Nx/Turborepo) to manage backend and frontend together, or keep them as separate repositories?
- **Context**: The tech stack includes both NestJS (backend) and React (frontend). A monorepo enables shared types and coordinated versioning but adds tooling complexity. This plan currently covers the backend only.
- **Answer**:
- **Status**: ⏳ Pending

### Q-003 (related: ORM Models)
- **Impact**: LOW
- **Question**: Should the project use Prisma Client directly in services, or add a repository abstraction layer between services and the ORM?
- **Context**: Direct Prisma usage is simpler and recommended by NestJS + Prisma guides. A repository layer adds abstraction but increases file count by ~8 files. The architecture document does not specify a preference.
- **Answer**:
- **Status**: ⏳ Pending

---

## 10. Readiness Assessment

| Metric | Value |
|--------|-------|
| Total items | 14 |
| ✅ CONFIRMED | 10 (71%) |
| 🔶 ASSUMED | 3 (22%) |
| ❓ UNCLEAR | 1 (7%) |
| Q&A Pending | 3 (HIGH: 0, MEDIUM: 1, LOW: 2) |
| Q&A Answered | 0 |

**Verdict**: ⚠️ Partially Ready

**Reasoning**: Core modules (auth, users, projects, sprints, tasks, git-sync) are fully confirmed from design artifacts. The alerts module MVP status and two architectural decisions (monorepo, repository pattern) need stakeholder input before finalizing. No HIGH impact questions block progress.

---

## 11. Approval

| Role | Name | Decision | Date |
|------|------|----------|------|
| Tech Lead | | Pending | |
| Architect | | Pending | |
