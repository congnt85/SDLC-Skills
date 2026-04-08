# User Story Template — Implementation Ready

---

## 📌 Story Header

| Field | Value |
|-------|-------|
| **Story ID** | [US-XXX] |
| **Title** | [Short descriptive name] |
| **Epic/Feature** | [Parent epic] |
| **Priority** | [P0-Critical / P1-High / P2-Medium / P3-Low] |
| **Story Points** | [1 / 2 / 3 / 5 / 8 / 13] |
| **Sprint** | [Sprint X] |
| **Assignee** | [Developer name] |
| **Status** | [Todo / In Progress / Review / Done] |

---

## 1. User Story

**As a** [specific role/persona],
**I want** [specific action/capability],
**So that** [measurable business value/outcome].

---

## 2. Context & Background

> Why does this story exist? What problem does it solve?
> Link to related documents, Figma designs, or previous discussions.

- **Related docs:** [links]
- **Figma/Design:** [links]
- **Dependencies:** [US-YYY, US-ZZZ]
- **Blocked by:** [if any]

---

## 3. Acceptance Criteria

Use Given/When/Then format. Cover **happy path, edge cases, and error cases**.

### Happy Path
```gherkin
Scenario: [Descriptive scenario name]
  Given [precondition/initial state]
  And [additional context if needed]
  When [action performed by user]
  Then [expected outcome]
  And [additional verifiable result]
```

### Edge Cases
```gherkin
Scenario: [Edge case description]
  Given [unusual but valid condition]
  When [action]
  Then [expected behavior]
```

### Error Cases
```gherkin
Scenario: [Error scenario description]
  Given [condition that leads to error]
  When [action]
  Then [error handling behavior]
  And [user-facing error message: "..."]
```

---

## 4. Business Rules & Constraints

List specific rules that govern the logic:

- [ ] Rule 1: [e.g., "Maximum 5 items per cart for guest users"]
- [ ] Rule 2: [e.g., "Price calculation must include VAT 10%"]
- [ ] Rule 3: [e.g., "Email must be verified before checkout"]

---

## 5. UI/UX Specification

### Screen/Component
- **Screen name:** [e.g., Product Detail Page]
- **Component:** [e.g., Add to Cart Button]
- **Figma link:** [URL]

### UI Behavior
| User Action | UI Response |
|-------------|------------|
| Click "Add to Cart" | Show success toast, update cart badge count |
| Click when out of stock | Button disabled, show "Out of Stock" label |
| Click when not logged in | Redirect to login page with return URL |

### Responsive Behavior
- **Desktop (≥1024px):** [behavior]
- **Tablet (768-1023px):** [behavior]
- **Mobile (<768px):** [behavior]

### Loading & Empty States
- **Loading:** [skeleton / spinner / placeholder]
- **Empty:** [message + CTA if applicable]
- **Error:** [inline error / toast / modal]

---

## 6. Technical Specification

### API Contract

**Endpoint:** `[METHOD] /api/v1/resource`

**Request:**
```json
{
  "field1": "string (required) — description",
  "field2": 0,           // number (optional) — description
  "field3": true          // boolean (required) — description
}
```

**Response — Success (200):**
```json
{
  "status": "success",
  "data": {
    "id": "uuid",
    "field1": "value"
  }
}
```

**Response — Error (4xx/5xx):**
```json
{
  "status": "error",
  "code": "ERROR_CODE",
  "message": "Human readable message"
}
```

### Data Model Changes

```
Table: table_name
- new_column_1: VARCHAR(255) NOT NULL
- new_column_2: INTEGER DEFAULT 0
- Index: idx_table_column1 ON (new_column_1)
```

### Key Technical Decisions
- **Approach:** [e.g., "Use optimistic update for cart operations"]
- **Caching:** [e.g., "Cache product list for 5 min using Redis"]
- **3rd Party:** [e.g., "Use Stripe API for payment processing"]

---

## 7. Validation Rules

| Field | Rule | Error Message |
|-------|------|---------------|
| email | Required, valid email format | "Please enter a valid email" |
| password | Min 8 chars, 1 uppercase, 1 number | "Password must be at least 8 characters with 1 uppercase and 1 number" |
| phone | Optional, E.164 format | "Invalid phone number format" |

---

## 8. Non-Functional Requirements

- **Performance:** [e.g., "API response < 200ms at P95"]
- **Security:** [e.g., "Input sanitization required", "Rate limit: 100 req/min"]
- **Accessibility:** [e.g., "WCAG 2.1 AA compliance"]
- **Logging:** [e.g., "Log all payment transactions with correlation ID"]
- **Analytics:** [e.g., "Track add_to_cart event with product_id, quantity"]

---

## 9. Test Scenarios

> For QA — concrete test cases derived from acceptance criteria.

| # | Scenario | Precondition | Steps | Expected Result |
|---|----------|-------------|-------|-----------------|
| 1 | [Happy path] | [Setup] | 1. Do X → 2. Do Y | [Result] |
| 2 | [Edge case] | [Setup] | 1. Do X → 2. Do Y | [Result] |
| 3 | [Error case] | [Setup] | 1. Do X → 2. Do Y | [Error handled] |

---

## 10. Out of Scope

> Explicitly state what is NOT included to prevent scope creep.

- ❌ [Feature/behavior that might be assumed but is not in this story]
- ❌ [Related functionality deferred to another story]

---

## 11. Open Questions

> Track unresolved decisions. Must be resolved before moving to "In Progress".

| # | Question | Owner | Status | Resolution |
|---|----------|-------|--------|------------|
| 1 | [Question?] | [Name] | ⏳ Open | — |
| 2 | [Question?] | [Name] | ✅ Resolved | [Answer] |

---

## 12. Definition of Done (DoD)

- [ ] Code implemented and self-reviewed
- [ ] Unit tests written (coverage ≥ 80%)
- [ ] Integration tests for API endpoints
- [ ] Code review approved (≥ 1 reviewer)
- [ ] UI matches Figma design (pixel-perfect check)
- [ ] Responsive tested on 3 breakpoints
- [ ] No critical/major SonarQube issues
- [ ] API documentation updated (Swagger/OpenAPI)
- [ ] QA tested and approved
- [ ] Product Owner accepted

---

*Template version: 1.0 | Last updated: [date]*
