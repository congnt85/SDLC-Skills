# Test Integration Output Rules

These rules govern the structure, content, and quality of the test-integration-draft.md output. Every rule is mandatory.

---

## INT-01: Integration Tests Must Cover Key Component Interactions

Every key component interaction identified in architecture-final.md MUST have at least one integration test case. Key interactions include:
- Service -> Database (CRUD, transactions)
- Service -> Cache (hit, miss, unavailability)
- Service -> External API (webhooks, API calls)
- WebSocket (connection, events, delivery)
- Cross-service communication flows

If an interaction is not tested, it MUST be listed as an explicit gap in the coverage matrix.

## INT-02: NFR Tests Must Map to Quality Attributes

Every NFR test case MUST trace to a quality attribute (QA-xxx) from scope-final.md. Each QA-xxx MUST have at least one NFR test case with:
- Specific test scenario
- Measurable acceptance criteria (targets with units)
- Tool or method for measurement

If scope-final.md is not available, NFR test cases should be based on architecture-final.md quality requirements with 🔶 ASSUMED confidence.

## INT-03: Coverage Matrix Must Reference ALL Acceptance Criteria, Endpoints, and Risks

The coverage matrix MUST be a combined view covering test cases from BOTH test-cases-draft.md and this document. It MUST include:
- Every acceptance criterion from user stories
- Every API endpoint from api-final.md
- Every high/critical risk from risk-register-final.md

Gaps MUST be explicitly identified with ❌ and a note explaining why coverage is missing.

## INT-04: Performance Tests Must Specify User Counts and Response Time Targets

Every performance test case MUST include:
- Virtual user count
- Ramp-up period
- Sustained duration
- Target endpoints
- Think time between requests
- Acceptance criteria with specific metrics (p95, p99, error rate, throughput)
- Measurement tool and method

Vague targets like "should be fast" or "acceptable performance" are prohibited.

## INT-05: Security Tests Must Cover OWASP Top 10 Categories

Security test cases MUST cover at minimum:
- **A01: Broken Access Control** — privilege escalation, missing auth checks
- **A03: Injection** — SQL injection, XSS, command injection
- **A07: Identification and Authentication Failures** — JWT manipulation, brute force, session handling

Additional OWASP categories SHOULD be covered based on the application's risk profile. Each security test MUST specify the attack vector and expected defense.

## INT-06: Standard Test Case Format

Every test case MUST follow the standard format:
- **ID**: `TC-{NNN}` (unique, zero-padded, sequential within this document)
- **Type**: Integration | Performance | Security | Availability | Data Integrity
- **Priority**: Critical | High | Medium | Low
- **Source**: Component interaction | QA-xxx | RISK-xxx
- **Preconditions**: Specific setup requirements
- **Test Steps**: Concrete actions with expected results
- **Test Data**: Concrete values (not placeholders)
- **Tags**: At minimum test type + path type

## INT-07: Confidence Markers on Every Test Case

Every test case MUST have a confidence marker:
- ✅ **CONFIRMED** — requirement is clear, test case directly maps to architecture/QA attribute
- 🔶 **ASSUMED** — requirement required interpretation, test case based on reasonable assumption (state the assumption)
- ❓ **UNCLEAR** — requirement is ambiguous, test case is best-guess (flag for Q&A)
