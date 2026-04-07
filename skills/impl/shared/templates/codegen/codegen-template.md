# Code Generation Plan Template

Standard format for defining project scaffolding and module structure.

---

## Project Structure

```markdown
### Directory Layout

```
{project-root}/
├── src/
│   ├── {module-a}/
│   │   ├── {module-a}.controller.ts
│   │   ├── {module-a}.service.ts
│   │   ├── {module-a}.module.ts
│   │   ├── dto/
│   │   └── entities/
│   ├── {module-b}/
│   └── common/
├── test/
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── prisma/
│   ├── schema.prisma
│   └── migrations/
├── config/
└── scripts/
```
```

---

## Module Specification

```markdown
### Module: {Name}

| Field | Value |
|-------|-------|
| **Architecture Component** | {component from architecture-final.md} |
| **Stories** | US-xxx, US-xxx |
| **Dependencies** | {other modules} |
| **External Services** | {APIs, databases, caches} |

**Files to Generate**:
| File | Purpose | Template |
|------|---------|----------|
| {file} | {purpose} | {pattern: controller/service/repository/dto/entity} |

**Key Interfaces**:
```typescript
interface {Name} {
  {method}({params}): {return};
}
```
```

---

## Configuration Files

```markdown
| File | Purpose | Key Settings |
|------|---------|-------------|
| tsconfig.json | TypeScript config | strict mode, paths |
| .eslintrc | Linting | rules, extends |
| .prettierrc | Formatting | style rules |
| jest.config | Test config | coverage thresholds |
| docker-compose.yml | Local dev | services, ports |
| .env.example | Environment vars | required vars |
```

---

## Rules

- Directory structure MUST mirror architecture components
- Module boundaries MUST match architecture component boundaries
- Every module MUST have its own test directory or co-located tests
- Configuration files MUST match tech stack selections
- Environment variables MUST be documented with .env.example
- Generated code MUST follow language/framework conventions
