# Test Phase Overview

The test phase transforms design artifacts into a comprehensive testing strategy, detailed test plans, and executable test cases. It defines WHAT to test, HOW to test, and the specific test scenarios that verify requirements are met.

---

## Skills in This Phase

```
/test-strategy    → Define testing approach, tools, environments, coverage targets
     ↓
/test-plan        → Create detailed test plan with schedule, resources, entry/exit criteria
     ↓
/test-cases       → Write specific test cases with steps, data, expected results
```

Each skill supports two modes: create and refine.

---

## Artifact Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    INPUTS                                    │
│                                                              │
│  From req/final/:                  From design/final/:       │
│  - userstories-final.md (ACs)     - tech-stack-final.md     │
│  - backlog-final.md (MVP scope)   - architecture-final.md   │
│  - dor-dod-final.md (DoD)         - database-final.md       │
│  - epics-final.md                 - api-final.md            │
│                                   - adr/*.md                 │
│  From init/final/:                                           │
│  - scope-final.md (QA attrs)                                 │
│  - risk-register-final.md                                    │
└────────────┬──────────────────────────┬──────────────────────┘
             │                          │
             ▼                          ▼
      ┌──────────────────────────────────────────┐
      │         /test-strategy                   │
      │  Testing approach, tools, coverage       │
      │  Output: test-strategy-draft.md          │
      └──────────────────┬───────────────────────┘
                         │ promote to test/final/
                         ▼
      ┌──────────────────────────────────────────┐
      │         /test-plan                       │
      │  Schedule, resources, entry/exit         │
      │  Output: test-plan-draft.md              │
      └──────────────────┬───────────────────────┘
                         │ promote to test/final/
                         ▼
      ┌──────────────────────────────────────────┐
      │         /test-cases                      │
      │  Specific test scenarios + steps         │
      │  Output: test-cases-draft.md             │
      └──────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                   OUTPUTS (test/final/)                       │
│                                                              │
│  test-strategy-final.md    test-plan-final.md                │
│  test-cases-final.md                                         │
└─────────────────────────────────────────────────────────────┘
```

---

## What This Phase Reads

| Source | What Test Extracts |
|--------|---------------------|
| **userstories-final.md** | Acceptance criteria → test cases (primary source) |
| **backlog-final.md** | MVP boundary → test scope priority, release grouping → test phases |
| **dor-dod-final.md** | DoD criteria → test exit criteria, quality gates |
| **epics-final.md** | Epic grouping → test suite organization |
| **scope-final.md** | Quality attributes (QA-xxx) → NFR test scenarios, performance targets |
| **risk-register-final.md** | High risks → risk-based test prioritization |
| **tech-stack-final.md** | Technologies → test tool selection, framework compatibility |
| **architecture-final.md** | Components → integration test boundaries, sequence flows → E2E scenarios |
| **database-final.md** | Tables/relationships → data integrity tests, migration tests |
| **api-final.md** | Endpoints → API test cases, contract tests, error handling tests |

---

## What Downstream Needs

| Test Artifact | Impl Phase Uses | Deploy Phase Uses |
|--------------|-----------------|-------------------|
| **test-strategy-final.md** | Test framework setup, CI test configuration | Pipeline test stage config |
| **test-plan-final.md** | Sprint test allocation, resource planning | Environment provisioning |
| **test-cases-final.md** | Test implementation, TDD guidance | Smoke test selection for deployment |

---

## Key Principles

1. **Requirements drive tests** — every test case traces to an acceptance criterion, quality attribute, or risk.
2. **Test pyramid** — more unit tests, fewer E2E tests. Unit → Integration → API → E2E.
3. **Risk-based prioritization** — high-risk areas get more test coverage.
4. **Shift left** — define tests early, automate everything possible.
5. **DoD compliance** — test exit criteria align with Definition of Done.
6. **Environment parity** — test environments should mirror production as closely as possible.
7. **Test independence** — tests should not depend on execution order or shared mutable state.
