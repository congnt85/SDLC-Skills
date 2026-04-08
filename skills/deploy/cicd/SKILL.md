---
name: deploy-cicd
description: >
  Create or refine a CI/CD pipeline definition from dev-workflow, test-strategy,
  and tech-stack artifacts. Defines pipeline stages, triggers, quality gates,
  deployment strategies, security scanning, and build configuration.
  ONLY activated by command: `/deploy-cicd`. Use `--create` or `--refine` to set mode.
  NEVER auto-trigger based on keywords.
argument-hint: "--create|--refine"
version: "1.0"
category: sdlc
phase: deploy
prev_phase: impl-workflow
next_phase: deploy-release
---

# CI/CD Pipeline Skill

## Purpose

Create or refine a CI/CD pipeline document (`cicd-pipeline-draft.md`) that defines the complete pipeline architecture -- stages, triggers, quality gates, artifact management, deployment strategies, and security scanning.

The CI/CD pipeline bridges "how we develop" (dev-workflow) and "how we ship" (deployment) by automating the path from code commit to production deployment.

---

## Two Modes

### Mode 1: Create (`--create`)

Generate a CI/CD pipeline definition from development workflow, test strategy, and technology stack.

| Input | Required | Source |
|-------|----------|--------|
| Dev workflow (final) | Yes | `sdlc/impl/final/dev-workflow-final.md` or user-specified path |
| Test strategy (final) | Yes | `sdlc/test/final/test-strategy-final.md` or user-specified path |
| Tech stack (final) | Yes | `sdlc/design/final/tech-stack-final.md` or user-specified path |
| Architecture (final) | No | `sdlc/design/final/architecture-final.md` — service topology, deployment targets |
| Codegen plan (final) | No | `sdlc/impl/final/codegen-plan-final.md` — project structure, build commands |
| DoR/DoD (final) | No | `sdlc/impl/final/dor-dod-final.md` — DoD for deployment gates |

### Mode 2: Refine (`--refine`)

Improve existing CI/CD pipeline definition based on user feedback.

| Input | Required | Source |
|-------|----------|--------|
| Existing pipeline draft | Yes | `sdlc/deploy/draft/cicd-pipeline-draft.md` or `sdlc/deploy/draft/cicd-pipeline-v{N}.md` |
| Review report / feedback | Yes | User provides directly or as `sdlc/deploy/input/review-report.md` |
| Additional details | No | New information the user wants to add |

---

## Output

| Mode | Output File | Location |
|------|------------|----------|
| Create | `cicd-pipeline-draft.md` | `sdlc/deploy/draft/` |
| Refine | `cicd-pipeline-v{N}.md` | `sdlc/deploy/draft/` (N = next version number) |

When user is satisfied -> they copy from `sdlc/deploy/draft/` to `sdlc/deploy/final/cicd-pipeline-final.md`.

---

## Workflow

### Step 1: Determine Mode

- User passes `--refine` argument → **Mode 2 (Refine)**
- User passes `--create` argument → **Mode 1 (Create)**
- No argument specified AND existing draft exists in `sdlc/deploy/draft/` → Ask: "A draft already exists. Use `--create` to start fresh or `--refine` to improve it."
- No argument specified AND no draft exists → **Mode 1 (Create)**

### Step 2: Read Knowledge and Rules

Read these files in order:

1. `skills/shared/rules/doc-standards.md` -- document formatting standards
2. `skills/shared/rules/quality-rules.md` -- confidence marking, readiness assessment
3. `skills/shared/rules/output-rules.md` -- versioning, input resolution, diff summary
4. `deploy/shared/rules/deploy-rules.md` -- deployment phase rules
5. `deploy/cicd/knowledge/cicd-pipeline-guide.md` -- pipeline design techniques
6. `deploy/cicd/rules/output-rules.md` -- CI/CD-specific output rules
7. `deploy/cicd/templates/output-template.md` -- expected output structure

### Step 3: Resolve Input

**File Type Conversion** (applies to all file inputs):

Before reading any input file, check its extension:
- `.md` → Read directly, no conversion needed
- `.pdf` → Run `/read-pdf <path> sdlc/deploy/input/` → read the converted .md
- `.docx` / `.doc` → Run `/read-word <path> sdlc/deploy/input/` → read the converted .md
- `.xlsx` / `.xls` → Run `/read-excel <path> sdlc/deploy/input/` → read the converted .md
- `.pptx` / `.ppt` → Run `/read-ppt <path> sdlc/deploy/input/` → read the converted .md

Converted files are saved to `sdlc/deploy/input/`. If a converted .md already exists and is newer than the source, skip conversion.

Note: Files auto-resolved from `sdlc/` pipeline are always .md and skip conversion.

**Mode 1 (Create):**

```
For dev workflow input (required):
1. Exists in sdlc/impl/final/dev-workflow-final.md?        -> YES -> read it -> DONE
2. User specified a different path?                        -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/deploy/input/dev-workflow-final.md?      -> YES -> read it -> DONE
4. Not found? -> Ask: "No dev workflow found. Please provide a path or run /impl-workflow first."

For test strategy input (required):
1. Exists in sdlc/test/final/test-strategy-final.md?      -> YES -> read it -> DONE
2. User specified a different path?                        -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/deploy/input/test-strategy-final.md?     -> YES -> read it -> DONE
4. Not found? -> Ask: "No test strategy found. Please provide a path or run /test-strategy first."

For tech stack input (required):
1. Exists in sdlc/design/final/tech-stack-final.md?       -> YES -> read it -> DONE
2. User specified a different path?                        -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/deploy/input/tech-stack-final.md?        -> YES -> read it -> DONE
4. Not found? -> Ask: "No tech stack found. Please provide a path or run /design-stack first."

For architecture input (optional):
1. Exists in sdlc/design/final/architecture-final.md?     -> YES -> read it -> DONE
2. User specified a different path?                        -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/deploy/input/architecture-final.md?      -> YES -> read it -> DONE
4. Not found? -> Proceed without architecture document.

For codegen plan input (optional):
1. Exists in sdlc/impl/final/codegen-plan-final.md?       -> YES -> read it -> DONE
2. User specified a different path?                        -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/deploy/input/codegen-plan-final.md?      -> YES -> read it -> DONE
4. Not found? -> Proceed without codegen plan.

For DoR/DoD input (optional):
1. Exists in sdlc/impl/final/dor-dod-final.md?            -> YES -> read it -> DONE
2. User specified a different path?                        -> YES -> read it, convert if needed -> DONE
3. Exists in sdlc/deploy/input/dor-dod-final.md?           -> YES -> read it -> DONE
4. Not found? -> Proceed without DoR/DoD.
```

**Mode 2 (Refine):**

```
For pipeline draft:
1. User specified path?                        -> YES -> read it, copy to sdlc/deploy/input/ -> DONE
2. Exists in sdlc/deploy/input/?               -> YES -> read it -> DONE
3. Exists in sdlc/deploy/draft/ (latest version)? -> YES -> read it, copy to sdlc/deploy/input/ -> DONE
4. Not found? -> FAIL: "No existing pipeline draft found. Run /deploy-cicd first."

For review report:
1. User provided feedback directly in message? -> Save to sdlc/deploy/input/review-report.md
2. User specified path?                        -> read it, copy to sdlc/deploy/input/
3. Exists in sdlc/deploy/input/review-report.md? -> read it
4. Not found? -> Ask: "What feedback do you have on the current pipeline definition?"
```

### Step 4: Generate (Mode-specific)

**Mode 1 -- Create:**

Work through the pipeline document **section by section, incrementally**:

1. **Pipeline Overview** -- Define pipeline architecture
   - Select CI/CD platform based on tech-stack (GitHub Actions, GitLab CI, etc.)
   - Define trigger strategy (PR events, merge to main, release tags)
   - Generate Mermaid diagram showing pipeline flow with parallelization
   - Identify pipeline types (PR pipeline vs deploy pipeline)
   - Present proposed structure to user before detailing

2. **Pipeline Stages** -- Detail each stage
   - For each stage: trigger, steps, environment, timeout, gate type (blocking/advisory), artifacts produced, failure action
   - Stages: lint/format, type check/compile, unit test, integration test, security scan, build artifact/Docker image, deploy staging, E2E test, deploy production, smoke test
   - Match test stages to test-strategy-final.md tools and coverage gates
   - Map build steps to tech-stack-final.md build tools and frameworks

3. **Build Configuration** -- Define build process
   - Dockerfile (multi-stage build if containerized)
   - Build caching strategy (dependency cache, Docker layer cache)
   - Artifact storage (container registry, artifact repository)
   - Version tagging strategy (git SHA, semver, etc.)

4. **Deployment Strategies** -- Per-environment strategy
   - For each environment (staging, production): strategy type, health checks, rollback triggers
   - Justify strategy choice based on risk tolerance and availability requirements
   - Reference architecture-final.md for deployment targets if available

5. **Security Pipeline** -- Security scanning integration
   - Dependency scanning (npm audit, pip audit, etc.)
   - Container scanning (Trivy, Grype, etc.)
   - Secret detection (gitleaks, trufflehog)
   - SAST/DAST integration where applicable
   - Gate type per scanner (blocking vs advisory)

6. **Pipeline Performance** -- Optimization targets
   - Target total duration per pipeline type (PR, deploy)
   - Parallelization strategy
   - Caching strategy and estimated savings
   - Cost estimation (build minutes, infrastructure)

7. **Notification & Monitoring** -- Alerting and visibility
   - Build failure notifications (channels, recipients)
   - Deployment event alerts
   - Pipeline dashboards and metrics

For each section:
- Apply confidence markers (CONFIRMED / ASSUMED / UNCLEAR)
- Inherit confidence from source documents where applicable
- Create Q&A entries for ASSUMED and UNCLEAR items
- Present section to user before moving to next

**Mode 2 -- Refine:**

1. Read existing pipeline draft (baseline)
2. Read review report / user feedback
3. Run Quality Scorecard analysis
4. Present scorecard to user
5. Apply improvements:
   - Address user feedback point by point
   - Resolve Q&A entries from previous version
   - Upgrade confidence levels where possible
   - Improve stage definitions for clarity and completeness
   - Refine deployment strategies based on new information
6. Tag all changes: `[UPDATED]` for modified items, `[NEW]` for additions
7. Preserve CONFIRMED items unless user explicitly contradicts them
8. Write improved version to `sdlc/deploy/draft/cicd-pipeline-v{N}.md`

### Step 5: Validate Output

Check against rules:
- Every item has a confidence marker (CR-01)
- Pipeline includes build, test, security scan, and deploy stages (CIC-01)
- Every stage has trigger, gate type, and timeout (CIC-02)
- Mermaid diagram present (CIC-03)
- Test stages match test-strategy-final.md (CIC-04)
- Deployment strategy per environment with justification (CIC-05)
- Rollback procedure defined (CIC-06)
- Security scanning includes dependency + secret detection (CIC-07)
- Secrets use secret management, never inline (CIC-08)
- Section order matches template (CIC-09)
- Pipeline duration targets specified (CIC-12)
- Caching strategy documented (CIC-13)
- Cost estimation included (CIC-14)
- Approval section present (INIT-07)

### Step 6: Readiness Assessment

Generate assessment per `skills/shared/templates/readiness-assessment.md`:
- Count items by confidence level (each stage is 1 item, each strategy decision is 1 item)
- Calculate readiness verdict
- In refine mode: compare with previous version

### Step 7: Output

- **Create mode**: Write to `sdlc/deploy/draft/cicd-pipeline-draft.md`
- **Refine mode**: Write to `sdlc/deploy/draft/cicd-pipeline-v{N}.md`, include Change Log and Diff Summary

Tell the user:
> **CI/CD Pipeline {created/refined}!**
> - Output: `sdlc/deploy/draft/cicd-pipeline-{version}.md`
> - Readiness: {verdict}
> - Stages: {total} ({blocking}: blocking, {advisory}: advisory)
> - Deployment: {strategies listed per environment}
> - Q&A pending: {N} (HIGH: {H})
>
> **Next steps:**
> - Review the output and provide feedback via `/deploy-cicd --refine`
> - When satisfied, copy to `sdlc/deploy/final/cicd-pipeline-final.md`
> - Then run `/deploy-release` to define the release process

---

## Scope Rules

### This skill DOES:
- Define pipeline stages, triggers, and quality gates
- Configure build processes and artifact management
- Specify deployment strategies per environment
- Integrate security scanning into the pipeline
- Estimate pipeline performance and costs
- Define notification and monitoring for pipeline events

### This skill does NOT:
- Implement actual pipeline files (that's DevOps implementation work)
- Manage environment configurations (belongs to `deploy/env` skill)
- Define release versioning and changelog process (belongs to `deploy/release` skill)
- Create test cases or test plans (belongs to `test/` phase)
- Make architecture decisions (belongs to `design/` phase)
- Modify source documents -- it reads them as input
