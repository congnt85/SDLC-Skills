# Codegen Plan Output Template

Expected structure for the code generation plan artifact.

---

```markdown
# Code Generation Plan — {Project Name}

> **Project**: {Project Name}
> **Version**: {1.0}
> **Date Created**: {YYYY-MM-DD}
> **Last Updated**: {YYYY-MM-DD}
> **Status**: {Draft / In Review / Approved}
> **Author**: AI-Generated
> **Tech Stack**: {primary language + framework}
> **Scaffold Plan**: {scaffold-plan-final.md version reference}

---

## 1. Module Specifications

### 1.1 {Module Name} Module

| Field | Value |
|-------|-------|
| **Architecture Component** | {component from architecture-final.md} |
| **Stories** | US-xxx, US-xxx |
| **Dependencies** | {other modules this module depends on} |
| **External Services** | {databases, caches, APIs} |
| **MVP** | Yes / No |
| **Confidence** | ✅ CONFIRMED / 🔶 ASSUMED / ❓ UNCLEAR |

**Files to Generate**:

| File | Pattern | Purpose |
|------|---------|---------|
| `{module}.module.ts` | Module | Module definition with imports, providers, exports |
| `{module}.controller.ts` | Controller | HTTP request handling for {resource} |
| `{module}.service.ts` | Service | Business logic for {domain} |
| `dto/create-{module}.dto.ts` | DTO | Request validation for creation |
| `dto/update-{module}.dto.ts` | DTO | Request validation for updates |
| `dto/query-{module}.dto.ts` | DTO | Query parameter validation |
| `entities/{module}.entity.ts` | Entity | ORM model definition |
| `interfaces/{module}.interface.ts` | Interface | TypeScript type definitions |

**Key Interfaces**:

```typescript
// Primary service interface
interface I{Module}Service {
  findAll(query: Query{Module}Dto): Promise<PaginatedResult<{Module}>>;
  findOne(id: string): Promise<{Module}>;
  create(dto: Create{Module}Dto): Promise<{Module}>;
  update(id: string, dto: Update{Module}Dto): Promise<{Module}>;
  remove(id: string): Promise<void>;
}
```

> Repeat section 1.x for each module.

---

## 2. ORM Models

### 2.1 {Entity Name}

**Source Table**: `{table_name}` from database-final.md
**Confidence**: ✅ CONFIRMED / 🔶 ASSUMED / ❓ UNCLEAR

```typescript
// Entity definition showing types, decorators, and relationships
@Entity('table_name')
class {EntityName} {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 255 })
  name: string;

  @Column({ type: 'enum', enum: {EnumName} })
  status: {EnumName};

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  // Relationships
  @ManyToOne(() => {RelatedEntity}, (entity) => entity.{field})
  {relation}: {RelatedEntity};

  @OneToMany(() => {RelatedEntity}, (entity) => entity.{field})
  {relations}: {RelatedEntity}[];
}
```

**Enums**:

```typescript
enum {EnumName} {
  VALUE_A = 'value_a',
  VALUE_B = 'value_b',
}
```

> Repeat section 2.x for each database table.

---

## 3. API Route Scaffolding

### 3.1 {Resource} Routes

**Source**: `{resource}` from api-final.md
**Controller File**: `src/{module}/{module}.controller.ts`
**Confidence**: ✅ CONFIRMED / 🔶 ASSUMED / ❓ UNCLEAR

| Method | Path | Handler | DTO | Auth | Rate Limit | Stories |
|--------|------|---------|-----|------|------------|---------|
| GET | `/api/v1/{resource}` | `findAll` | `Query{Resource}Dto` | Required | — | US-xxx |
| GET | `/api/v1/{resource}/:id` | `findOne` | — | Required | — | US-xxx |
| POST | `/api/v1/{resource}` | `create` | `Create{Resource}Dto` | Required | 10/min | US-xxx |
| PATCH | `/api/v1/{resource}/:id` | `update` | `Update{Resource}Dto` | Required | — | US-xxx |
| DELETE | `/api/v1/{resource}/:id` | `remove` | — | Admin | — | US-xxx |

**Middleware/Guards**:
- `JwtAuthGuard` — all routes
- `RolesGuard` — delete operations (admin only)
- `ValidationPipe` — POST/PATCH routes

> Repeat section 3.x for each API resource group.

---

## 4. Test Infrastructure

### 4.1 Directory Structure

```
test/
├── integration/
│   ├── {module}.integration.spec.ts
│   └── setup.ts
├── e2e/
│   ├── {module}.e2e-spec.ts
│   └── playwright.config.ts (or jest-e2e.config.ts)
└── utils/
    ├── factories/
    │   └── {entity}.factory.ts
    ├── fixtures/
    │   └── {entity}.fixture.json
    └── helpers/
        ├── create-test-app.ts
        ├── database.ts
        ├── auth.ts
        └── request.ts
```

### 4.2 Test Configuration

| Config | Setting | Value |
|--------|---------|-------|
| Framework | Test runner | {Jest / Vitest / Playwright} |
| Coverage | Statement threshold | {80%} |
| Coverage | Branch threshold | {75%} |
| Coverage | Function threshold | {80%} |
| Unit | Pattern | `**/*.spec.ts` |
| Integration | Pattern | `test/integration/**/*.spec.ts` |
| E2E | Pattern | `test/e2e/**/*.spec.ts` |
| Timeout | Unit | {5000ms} |
| Timeout | Integration | {30000ms} |
| Timeout | E2E | {60000ms} |

### 4.3 Test Utilities

| Utility | Purpose | File |
|---------|---------|------|
| Test App Factory | Creates NestJS test module with mocked providers | `test/utils/helpers/create-test-app.ts` |
| Database Helper | Reset and seed test database | `test/utils/helpers/database.ts` |
| Auth Helper | Generate test JWT tokens for different roles | `test/utils/helpers/auth.ts` |
| Request Helper | Typed supertest wrapper with auth | `test/utils/helpers/request.ts` |
| Entity Factories | Build test entities with sensible defaults | `test/utils/factories/*.factory.ts` |
| Fixtures | Static test data for deterministic tests | `test/utils/fixtures/*.fixture.json` |

---

## 5. File Inventory

### 5.1 Source Files

| # | File Path | Purpose | Source | MVP |
|---|-----------|---------|--------|-----|
| 1 | `src/{module}/{module}.module.ts` | {Module} module definition | architecture-final.md | Yes |
| 2 | `src/{module}/{module}.controller.ts` | {Module} HTTP handlers | api-final.md | Yes |
| 3 | `src/{module}/{module}.service.ts` | {Module} business logic | architecture-final.md | Yes |
| ... | ... | ... | ... | ... |

### 5.2 Test Files

| # | File Path | Purpose | Source | MVP |
|---|-----------|---------|--------|-----|
| 1 | `src/{module}/__tests__/{module}.service.spec.ts` | Unit test for service | — | Yes |
| 2 | `test/integration/{module}.integration.spec.ts` | Integration test | — | Yes |
| ... | ... | ... | ... | ... |

### 5.3 Summary

| Category | Count |
|----------|-------|
| Source files | {N} |
| Test files | {N} |
| **Total** | **{N}** |
| MVP files | {N} |
| [FUTURE] files | {N} |

---

## 6. Q&A Log

### Q-001 (related: {item IDs})
- **Impact**: HIGH / MEDIUM / LOW
- **Question**: {specific question}
- **Context**: {why this matters}
- **Answer**: {empty for create, filled for refine}
- **Status**: ⏳ Pending

> Repeat for each question.

---

## 7. Readiness Assessment

| Metric | Value |
|--------|-------|
| Total items | {N} |
| ✅ CONFIRMED | {X} ({X/N x 100}%) |
| 🔶 ASSUMED | {Y} ({Y/N x 100}%) |
| ❓ UNCLEAR | {Z} ({Z/N x 100}%) |
| Q&A Pending | {P} (HIGH: {H}, MEDIUM: {M}, LOW: {L}) |
| Q&A Answered | {A} |

**Verdict**: {✅ Ready / ⚠️ Partially Ready / ❌ Not Ready}

**Reasoning**: {1-2 sentences explaining the verdict}

---

## 8. Approval

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
