# Project Scaffolding Guide

Techniques and patterns for planning project scaffolding from design artifacts. This guide covers how to translate architecture, database, and API designs into a concrete file structure and module plan.

---

## 1. Architecture-to-Structure Mapping

Every architecture component maps to a directory or module in the project structure. The mapping pattern depends on the architectural style.

### Modular Monolith

Each architecture component becomes a module directory under `src/`:

```
src/
├── auth/           # Auth component
├── projects/       # Project management component
├── sprints/        # Sprint management component
├── tasks/          # Task management component
├── notifications/  # Notification component
└── common/         # Shared utilities
```

### Microservices

Each architecture component becomes a separate project/service:

```
services/
├── auth-service/        # Standalone deployable
├── project-service/     # Standalone deployable
├── notification-service/ # Standalone deployable
└── shared/              # Shared libraries (published as packages)
```

### MVC Pattern

Components map to role-based directories:

```
src/
├── controllers/    # HTTP request handlers
├── services/       # Business logic
├── models/         # Data models
├── middleware/     # Request middleware
├── routes/         # Route definitions
└── utils/          # Shared utilities
```

### NestJS Module Pattern

Each component becomes a self-contained NestJS module:

```
src/
├── {module}/
│   ├── {module}.module.ts          # Module definition (imports, providers, exports)
│   ├── {module}.controller.ts      # HTTP request handling
│   ├── {module}.service.ts         # Business logic
│   ├── {module}.repository.ts      # Data access (optional, if not using ORM directly)
│   ├── dto/
│   │   ├── create-{module}.dto.ts  # Request validation for creation
│   │   ├── update-{module}.dto.ts  # Request validation for updates
│   │   └── query-{module}.dto.ts   # Query parameter validation
│   ├── entities/
│   │   └── {module}.entity.ts      # ORM entity/model definition
│   ├── interfaces/
│   │   └── {module}.interface.ts   # TypeScript interfaces
│   └── __tests__/
│       ├── {module}.controller.spec.ts
│       └── {module}.service.spec.ts
```

### React Feature Pattern

Each component becomes a feature directory:

```
src/
├── components/          # Shared/reusable UI components
│   ├── Button/
│   │   ├── Button.tsx
│   │   ├── Button.styles.ts
│   │   └── Button.test.tsx
│   └── Layout/
├── features/            # Feature modules (maps to architecture components)
│   ├── auth/
│   │   ├── components/
│   │   ├── hooks/
│   │   ├── services/
│   │   └── types.ts
│   ├── dashboard/
│   └── settings/
├── hooks/               # Shared custom hooks
├── pages/               # Route-level page components
├── services/            # API client services
├── store/               # State management (Redux/Zustand slices)
└── utils/               # Shared utilities
```

### Mapping Rules

- One architecture component = one module directory (minimum)
- Large components may split into sub-modules if they contain 10+ files
- Cross-cutting concerns (auth, logging, config) become shared modules
- Gateway/proxy components may not need their own module if they are routing-only
- The `common/` or `shared/` directory holds utilities used by 3+ modules

---

## 2. ORM Model Generation

Transform database-final.md table definitions into ORM entity/model files.

### Column Type Mapping

| Database Type | TypeScript/Prisma | Python/SQLAlchemy | Java/JPA |
|--------------|-------------------|-------------------|----------|
| UUID | `string` / `@id @default(uuid())` | `UUID` / `Column(UUID)` | `UUID` / `@Id @GeneratedValue` |
| VARCHAR(N) | `string` / `String @db.VarChar(N)` | `str` / `Column(String(N))` | `String` / `@Column(length=N)` |
| TEXT | `string` / `String` | `str` / `Column(Text)` | `String` / `@Lob` |
| INTEGER | `number` / `Int` | `int` / `Column(Integer)` | `Integer` / `@Column` |
| BOOLEAN | `boolean` / `Boolean` | `bool` / `Column(Boolean)` | `Boolean` / `@Column` |
| TIMESTAMPTZ | `Date` / `DateTime` | `datetime` / `Column(DateTime)` | `Instant` / `@Column` |
| JSONB | `Record<string, any>` / `Json` | `dict` / `Column(JSON)` | `String` / `@Type(JsonType)` |
| DECIMAL(P,S) | `number` / `Decimal` | `Decimal` / `Column(Numeric)` | `BigDecimal` / `@Column` |
| ENUM | `enum` / `enum` | `Enum` / `Column(Enum)` | `enum` / `@Enumerated` |

### Relationship Mapping

| Relationship | Prisma | TypeORM | SQLAlchemy |
|-------------|--------|---------|------------|
| One-to-Many | `posts Post[]` on parent, `author User @relation` on child | `@OneToMany(() => Post, post => post.author)` | `relationship("Post", back_populates="author")` |
| Many-to-One | `author User @relation(fields: [authorId], references: [id])` | `@ManyToOne(() => User, user => user.posts)` | `relationship("User", back_populates="posts")` |
| Many-to-Many | `tags Tag[]` with implicit join table | `@ManyToMany(() => Tag) @JoinTable()` | `relationship("Tag", secondary=post_tags)` |
| One-to-One | `profile Profile?` and `user User @relation` | `@OneToOne(() => Profile) @JoinColumn()` | `relationship("Profile", uselist=False)` |

### Validation Mapping

| Constraint | class-validator (NestJS) | Pydantic (FastAPI) | Hibernate (Java) |
|-----------|--------------------------|--------------------|--------------------|
| Required | `@IsNotEmpty()` | `Field(...)` | `@NotNull` |
| Max length | `@MaxLength(N)` | `Field(max_length=N)` | `@Size(max=N)` |
| Email | `@IsEmail()` | `EmailStr` | `@Email` |
| Enum | `@IsEnum(MyEnum)` | `Literal[...]` | `@Enumerated` |
| UUID | `@IsUUID()` | `UUID4` | `@Type(UUID)` |
| Min/Max | `@Min(N)` / `@Max(N)` | `Field(ge=N, le=N)` | `@Min(N)` / `@Max(N)` |
| Optional | `@IsOptional()` | `Optional[T] = None` | nullable in `@Column` |

### Entity File Template

For each database table, produce:
1. Entity/model class with column type annotations
2. Relationship decorators linking to related entities
3. Enum definitions (if table uses enums, define them in a shared `enums.ts` or inline)
4. Validation decorators for DTO generation reference
5. Indexes and unique constraints as decorators

---

## 3. API Route Scaffolding

Transform api-final.md endpoint definitions into controller/route file plans.

### Resource-to-Controller Mapping

Each API resource group becomes one controller file:
- `/api/v1/projects/**` -> `projects.controller.ts`
- `/api/v1/users/**` -> `users.controller.ts`
- `/api/v1/sprints/**` -> `sprints.controller.ts`

### Endpoint-to-Handler Mapping

| HTTP Method | CRUD Operation | Handler Name | DTO |
|------------|---------------|-------------|-----|
| GET (list) | Read all | `findAll()` | QueryDto (pagination, filters) |
| GET (one) | Read one | `findOne(id)` | - (path param) |
| POST | Create | `create(dto)` | CreateDto |
| PUT/PATCH | Update | `update(id, dto)` | UpdateDto |
| DELETE | Delete | `remove(id)` | - (path param) |
| POST (action) | Custom action | `{action}(dto)` | ActionDto |

### DTO Generation Pattern

For each resource, plan these DTOs:
- **CreateXxxDto**: Required fields for creation (no id, no timestamps)
- **UpdateXxxDto**: Optional fields for partial update (PartialType of Create)
- **QueryXxxDto**: Pagination (page, limit) + filter fields + sort options
- **ResponseXxxDto**: Full entity representation for API responses (optional, can use entity directly)

### Auth/Middleware Mapping

| API Requirement | NestJS Implementation | Express Implementation |
|----------------|----------------------|----------------------|
| Auth required | `@UseGuards(JwtAuthGuard)` | `authMiddleware` on route |
| Role required | `@Roles('admin')` + `@UseGuards(RolesGuard)` | `roleMiddleware('admin')` |
| Rate limiting | `@Throttle(limit, ttl)` | `rateLimit({ max, windowMs })` |
| Validation | `@UsePipes(ValidationPipe)` | `validate(schema)` middleware |
| File upload | `@UseInterceptors(FileInterceptor)` | `multer` middleware |

### Controller File Template

For each controller, plan:
1. Class with route prefix decorator (`@Controller('api/v1/resource')`)
2. Constructor with service injection
3. Handler methods matching each endpoint
4. DTO references for request validation
5. Guard/decorator references for auth and rate limiting
6. Swagger/OpenAPI decorators for documentation

---

## 4. Configuration Best Practices

Essential configuration files organized by concern.

### TypeScript Configuration

```
tsconfig.json          # Base config: strict mode, path aliases, target
tsconfig.build.json    # Build-specific: exclude tests, include src only
tsconfig.test.json     # Test-specific: include test files (optional)
```

Key settings:
- `"strict": true` -- always enable strict mode
- `"paths"` -- module aliases (`@/common/*`, `@/modules/*`)
- `"esModuleInterop": true` -- CommonJS compatibility
- `"resolveJsonModule": true` -- import JSON files

### Linting and Formatting

```
.eslintrc.js           # ESLint config: extends recommended + TypeScript
.prettierrc            # Prettier config: consistent formatting
.eslintignore          # Exclude dist, node_modules, coverage
```

Key settings:
- Extend `@typescript-eslint/recommended` and `prettier`
- Add project-specific rules (naming conventions, import order)
- Single quotes, trailing commas, semicolons (or match team preference)

### Testing Configuration

```
jest.config.ts         # Jest config (or vitest.config.ts for Vitest)
```

Key settings:
- `moduleNameMapper` matching tsconfig paths
- `coverageThreshold` (statements, branches, functions, lines)
- `testMatch` patterns for unit vs integration vs e2e
- Separate test projects for different test types if needed

### Docker Configuration

```
Dockerfile             # Multi-stage build (build, test, production)
docker-compose.yml     # Local development services
docker-compose.test.yml # Test environment (optional)
.dockerignore          # Exclude node_modules, .git, etc.
```

docker-compose services:
- Application server (with hot reload for dev)
- Database (PostgreSQL, MySQL, etc.)
- Cache (Redis, Memcached)
- Message broker (RabbitMQ, Kafka) if needed
- Mail server (MailHog for dev)

### Environment Configuration

```
.env.example           # Template with ALL variables documented
.env.test              # Test-specific overrides
```

Every environment variable MUST be documented:
- Name, type, default value, description
- Mark required vs optional
- Group by concern (database, auth, external services, feature flags)

### Git Configuration

```
.gitignore             # Standard ignore patterns for language/framework
.husky/
  pre-commit           # Lint-staged (format + lint on commit)
  commit-msg           # Commitlint (conventional commits)
```

### CI Configuration

```
.github/workflows/
  ci.yml               # Lint -> Test -> Build pipeline
  deploy.yml           # Deploy pipeline (if in scope)
```

CI pipeline stages:
1. Install dependencies
2. Lint (ESLint + Prettier check)
3. Type check (tsc --noEmit)
4. Unit tests (with coverage)
5. Integration tests
6. Build
7. (Optional) E2E tests
8. (Optional) Deploy

---

## 5. Test Infrastructure Setup

Plan the test directory structure and support files.

### Co-located vs Separated Tests

**Co-located** (recommended for unit tests):
```
src/
├── users/
│   ├── users.service.ts
│   ├── users.service.spec.ts     # Unit test next to source
│   └── __tests__/
│       └── users.integration.spec.ts
```

**Separated** (recommended for integration and e2e):
```
test/
├── integration/
│   ├── users.integration.spec.ts
│   └── setup.ts                  # Test database, test app
├── e2e/
│   ├── users.e2e-spec.ts
│   └── playwright.config.ts
└── utils/
    ├── factories/                # Test data builders
    ├── fixtures/                 # Static test data
    └── helpers/                  # Test utilities
```

### Test Utilities to Plan

| Utility | Purpose | Files |
|---------|---------|-------|
| Test App Factory | Create configured app instance for testing | `test/utils/create-test-app.ts` |
| Database Setup | Reset/seed test database before tests | `test/utils/database.ts` |
| Auth Helper | Generate test JWT tokens | `test/utils/auth.ts` |
| Data Factories | Build test entities with defaults | `test/utils/factories/{entity}.factory.ts` |
| Request Helper | Typed HTTP request wrapper | `test/utils/request.ts` |
| Fixtures | Static test data (JSON, SQL) | `test/utils/fixtures/` |

### Coverage Configuration

Plan coverage thresholds per test type:
- **Unit tests**: 80%+ line coverage on business logic
- **Integration tests**: Cover all API endpoints and database operations
- **E2E tests**: Cover critical user flows

---

## 6. Shared Module Patterns

Common utilities that every project needs, planned as shared modules.

### Error Handling

| File | Purpose |
|------|---------|
| `common/exceptions/app.exception.ts` | Base application exception class |
| `common/exceptions/not-found.exception.ts` | Resource not found (404) |
| `common/exceptions/conflict.exception.ts` | Duplicate/conflict (409) |
| `common/exceptions/validation.exception.ts` | Validation failure (422) |
| `common/filters/http-exception.filter.ts` | Global exception filter — catches all exceptions, formats standard error response |

### Logging

| File | Purpose |
|------|---------|
| `common/logging/logger.service.ts` | Structured logging wrapper (Winston/Pino) |
| `common/logging/logging.interceptor.ts` | Request/response logging interceptor |
| `common/logging/logging.module.ts` | Logger module with configuration |

Log format: JSON structured logs with request ID, timestamp, level, context, message, and metadata.

### Auth Middleware

| File | Purpose |
|------|---------|
| `common/auth/jwt.strategy.ts` | JWT validation strategy |
| `common/auth/auth.guard.ts` | Route guard enforcing authentication |
| `common/auth/roles.guard.ts` | Role-based access control guard |
| `common/auth/roles.decorator.ts` | `@Roles('admin')` decorator |
| `common/auth/current-user.decorator.ts` | `@CurrentUser()` parameter decorator |

### Validation

| File | Purpose |
|------|---------|
| `common/validation/validation.pipe.ts` | Global validation pipe configuration |
| `common/validation/validators/` | Custom validators (IsUnique, IsExisting, etc.) |

### Response Formatting

| File | Purpose |
|------|---------|
| `common/response/response.interceptor.ts` | Wraps all responses in standard envelope |
| `common/response/response.dto.ts` | Standard response shape: `{ data, meta, errors }` |
| `common/response/pagination.dto.ts` | Pagination metadata: `{ page, limit, total, totalPages }` |

### Config Validation

| File | Purpose |
|------|---------|
| `common/config/config.schema.ts` | Environment variable validation schema (Joi/Zod) |
| `common/config/config.module.ts` | Config module with validated environment |
| `common/config/database.config.ts` | Database connection configuration |
| `common/config/auth.config.ts` | Auth/JWT configuration |
| `common/config/app.config.ts` | General app configuration (port, cors, etc.) |
