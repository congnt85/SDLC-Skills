# Output Rules — design/api-security

API security and contract constraints. These supplement the project-wide rules in `skills/shared/rules/` and the design phase rules in `design/shared/rules/design-rules.md`.

---

## Authentication Rules

### SEC-01: Authentication Mechanism Required
The document MUST specify:
- Authentication mechanism (Bearer JWT, API Key, OAuth2)
- How to include credentials in requests (header name, format)
- Token format and claims (for JWT)

### SEC-02: Role Permission Matrix
The role permissions matrix MUST cover ALL endpoints from the api-draft.md document.
Every endpoint × role combination must have an explicit access decision (✅/❌/own).

### SEC-03: Token Lifecycle
The document MUST document:
- Access token expiry duration
- Refresh token flow (if applicable)
- Token revocation mechanism

---

## Pagination Rules

### SEC-04: Pagination Documentation
Pagination parameters MUST be documented for all list endpoints identified in api-draft.md:
- Query parameters (page/limit or cursor-based)
- Default and maximum values
- Response meta format with example

---

## Rate Limiting Rules

### SEC-05: Rate Limit Tiers
Rate limit tiers MUST include at minimum:
- Anonymous (unauthenticated) tier
- Authenticated (standard) tier
- Elevated tier (for high-throughput operations)

Each tier MUST specify: requests per time window (e.g., "100/min").

### SEC-06: Rate Limit Headers
Rate limit response headers MUST be documented:
- `X-RateLimit-Limit`
- `X-RateLimit-Remaining`
- `X-RateLimit-Reset`
- HTTP 429 response format with `Retry-After` header

---

## WebSocket Rules

### SEC-07: WebSocket Auth
If WebSocket section exists, it MUST document:
- Connection URL pattern
- Authentication mechanism for WebSocket connections
- Channel subscription model

---

## Format Rules

### SEC-08: Section Order
Output MUST follow this section order:
1. Authentication & Authorization
2. Pagination & Filtering
3. Rate Limiting
4. WebSocket API (if applicable)
5. Q&A Log
6. Readiness Assessment
7. Approval

### SEC-09: Confidence Markers
Every specification item MUST have a confidence marker (✅/🔶/❓).

### SEC-10: Refine Mode Scorecard
In refine mode, generate quality scorecard BEFORE applying changes.
