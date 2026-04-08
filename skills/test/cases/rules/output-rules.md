# Test Cases Output Rules

These rules govern the structure, content, and quality of the test-cases-draft.md output. Every rule is mandatory.

---

## TCS-01: Unique Test Case IDs

Every test case MUST have a unique ID in the format `TC-{NNN}` (zero-padded, sequential). IDs MUST NOT be reused or skipped within a document.

## TCS-02: Traceability Required

Every test case MUST trace to exactly one source:
- `US-xxx.AC-N` — acceptance criterion from a user story
- API endpoint (e.g., `POST /api/v1/projects`)

No orphan test cases allowed. If a test case cannot be traced, it should not exist.

## TCS-03: Specific and Reproducible Steps

Test steps MUST be specific enough that any team member can execute them independently. Prohibited vague steps:
- "Enter valid data" → specify the exact data values
- "Verify it works" → specify what "works" means (status code, DB state, UI element)
- "Set up the system" → list exact precondition steps
- "Check the response" → specify which fields and values to verify

## TCS-04: Verifiable Expected Results

Expected results MUST be verifiable assertions, not subjective descriptions:
- "Response status code is 201" — verifiable
- "Response body contains `id` field with UUID format" — verifiable
- "Database `tasks` table has new row with `status='TODO'`" — verifiable
- "Works correctly" — NOT verifiable
- "Page loads properly" — NOT verifiable
- "User experience is good" — NOT verifiable

## TCS-05: Concrete Test Data

Test data MUST use concrete values, not placeholders:
- `name: "TaskFlow Alpha"` — concrete
- `email: "alice.johnson@example.com"` — concrete
- `priority: 3` — concrete
- `name: {valid_name}` — NOT concrete (placeholder)
- `email: <user_email>` — NOT concrete (placeholder)
- `priority: {number}` — NOT concrete (placeholder)

## TCS-06: Must Have Story Coverage

Every acceptance criterion from Must Have user stories MUST have:
- At least one **happy-path** test case
- At least one **negative or edge-case** test case

No exceptions. If an AC is ambiguous, create the test case with 🔶 ASSUMED confidence and note the assumption.

## TCS-07: API Endpoint Coverage

Every API endpoint documented in api-final.md MUST have at minimum:
- One **happy-path** test case (valid request → success response)
- One **auth failure** test case (missing/invalid token → 401/403)
- One **not found** test case (invalid resource ID → 404)

Additional test cases (validation, conflict, rate limiting) are required for POST/PUT/PATCH endpoints.

## TCS-08: Suite Organization

Test cases MUST be organized into test suites with IDs in the format `TS-{NNN}`:
- One suite per user story (functional tests)
- One suite per API resource (API tests)

## TCS-09: Document Section Order

The output document MUST follow this section order:
1. Suite Overview (summary table)
2. Functional Test Cases (by suite)
3. API Test Cases (by suite)
4. Test Data Specifications
5. Q&A Log
6. Readiness Assessment
7. Approval

No sections may be omitted. Empty sections must state "No {type} test cases identified" with justification.

## TCS-10: Confidence Markers

Every test case MUST have a confidence marker:
- ✅ **CONFIRMED** — AC is clear and unambiguous, test case directly maps to requirement
- 🔶 **ASSUMED** — AC required interpretation, test case based on reasonable assumption (state the assumption)
- ❓ **UNCLEAR** — AC is ambiguous or incomplete, test case is best-guess (flag for Q&A)

## TCS-11: Refine Mode Scorecard

In refine mode, the output MUST begin with a quality scorecard showing:
- Total test cases by type (functional, API)
- Total test cases by priority (Critical, High, Medium, Low)
- AC coverage percentage (Must Have, Should Have, Could Have)
- API endpoint coverage percentage
- Confidence distribution
- Changes made in this refinement cycle

## TCS-12: Priority Assignment

Every test case MUST have a priority level:
- **Critical** — Must run every build, CI gate blocker
- **High** — Must run every build
- **Medium** — Must run every release
- **Low** — Periodic or manual execution

Priority must align with the source requirement's priority (Must Have -> Critical/High, Should Have -> High/Medium, Could Have -> Medium/Low).

## TCS-13: Tags Required

Every test case MUST include tags with at minimum:
- **Test type**: `functional`, `api`
- **Path type**: `happy-path`, `negative`, `edge-case`, `boundary`
- **Optional**: `smoke`, `regression`, `critical-path`, `exploratory`

## TCS-14: MVP Boundary

Test cases for MVP (Must Have + Should Have) features MUST be clearly identified. Test cases for non-MVP (Could Have + Won't Have) features MUST be tagged with `[FUTURE]` and excluded from coverage calculations.
