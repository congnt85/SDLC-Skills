# Skill Anatomy Guide

Understanding what each part of a skill controls, so evolution analysis can target the right files.

---

## 1. SKILL.md — Workflow Controller

**Controls**: Execution flow, mode selection, input resolution, step ordering.

**What it defines**:
- Frontmatter metadata (name, version, phase, prev/next phase)
- Two modes: Create and Refine with their input tables
- 7-step workflow (mode detection → read knowledge → resolve input → generate → validate → readiness → output)
- Scope rules (what the skill does and does not do)

**Problems traceable to SKILL.md**:
- Wrong execution order (steps out of sequence)
- Missing or ambiguous workflow instructions (skill produces inconsistent results)
- Input resolution failures (skill can't find required files)
- Mode detection issues (wrong mode triggered)
- Scope violations (skill does things it shouldn't or misses things it should)

**Evolution targets in SKILL.md**:
- Clarify ambiguous step instructions
- Add missing sub-steps within a step
- Fix input resolution logic (priority order, fallback paths)
- Adjust scope rules to match actual usage patterns

---

## 2. knowledge/*.md — Domain Expertise

**Controls**: Quality and depth of generated content. Knowledge files teach the skill domain-specific techniques, patterns, and best practices.

**What it defines**:
- Domain techniques (e.g., epic decomposition, risk identification methods)
- Terminology and definitions
- Patterns and examples
- Decision frameworks and heuristics

**Problems traceable to knowledge files**:
- Content quality gaps (skill produces shallow or incorrect content)
- Missing techniques (user had to add approaches the skill didn't know)
- Wrong domain assumptions (skill applied techniques inappropriate for the context)
- Incomplete coverage (skill missed important aspects of the domain)

**Evolution targets in knowledge files**:
- Add missing techniques or patterns discovered from draft→final comparison
- Correct inaccurate domain guidance
- Add examples that illustrate common pitfalls
- Expand coverage of under-addressed areas

---

## 3. rules/output-rules.md — Validation Rules

**Controls**: Output quality enforcement. Rules define constraints that the skill checks during validation (Step 5).

**What it defines**:
- Rule IDs (e.g., EPC-01, REQ-05) for traceability
- Specific validation checks (structural, content, cross-reference)
- Required vs recommended constraints
- Phase-specific and skill-specific quality criteria

**Problems traceable to rules**:
- Unenforced constraints (user had to manually fix consistency issues)
- Missing rules (a quality dimension has no validation coverage)
- Overly strict rules (skill rejects valid outputs or over-constrains creativity)
- Conflicting rules (two rules produce contradictory requirements)

**Evolution targets in rules**:
- Add new rules for recurring quality issues
- Tighten vague rules with specific criteria
- Relax over-strict rules that cause false positives
- Resolve conflicts between rules

---

## 4. templates/output-template.md — Output Structure

**Controls**: Document structure, section ordering, and expected content layout.

**What it defines**:
- Section headings and hierarchy
- Required vs optional sections
- Table formats and column definitions
- Placeholder descriptions for each field

**Problems traceable to output template**:
- Missing sections (user added entire sections not in the template)
- Wrong section order (user restructured the document)
- Inadequate section descriptions (skill filled sections with wrong content type)
- Missing table columns or fields (user added columns the template didn't specify)

**Evolution targets in output template**:
- Add new sections that users consistently create
- Reorder sections to match logical flow
- Clarify section descriptions to prevent content misplacement
- Add missing table columns or fields

---

## 5. templates/sample-output.md — Quality Calibration

**Controls**: Quality expectations and content depth. The sample shows the skill what "good" looks like.

**What it defines**:
- Expected level of detail per section
- Tone and writing style
- Appropriate level of quantification
- Cross-referencing patterns

**Problems traceable to sample output**:
- Wrong quality calibration (skill produces too shallow or too verbose output)
- Misleading example (sample demonstrates a pattern that doesn't generalize)
- Missing cross-reference patterns (skill doesn't link items the way it should)
- Inconsistent with template (sample doesn't match the current template structure)

**Evolution targets in sample output**:
- Align with updated template structure
- Improve quality calibration (more/less detail where needed)
- Fix misleading patterns
- Add cross-reference examples

---

## 6. Phase Shared Resources — Inherited Context

**Location**: `skills/<phase>/shared/` (rules, knowledge, templates)

**Controls**: Phase-wide standards inherited by all skills in the phase.

**Important**: Evolution skill should NOT modify phase shared resources directly. If analysis identifies a problem in shared resources, flag it as:

> **Shared Resource Issue**: `<phase>/shared/<file>` — {description of the problem}. Manual review recommended. Changing shared resources affects all skills in the `<phase>` phase.

---

## 7. Project Shared Resources — Global Standards

**Location**: `skills/shared/` (rules, knowledge, templates)

**Controls**: Project-wide standards inherited by all skills.

**Important**: Evolution skill should NEVER modify project shared resources. Flag as:

> **Global Resource Issue**: `shared/<file>` — {description of the problem}. Manual review required. Changing global resources affects ALL 26 skills.

---

## Targeting Guide: Problem → File Mapping

| Symptom | Most Likely Target | Check Also |
|---------|-------------------|------------|
| Missing section in output | `templates/output-template.md` | `templates/sample-output.md` |
| Shallow/incorrect content | `knowledge/*.md` | `templates/sample-output.md` |
| Inconsistency in output | `rules/output-rules.md` | `SKILL.md` Step 5 |
| Wrong document structure | `templates/output-template.md` | `SKILL.md` Step 4 |
| Missing cross-references | `rules/output-rules.md` | `templates/output-template.md` |
| Vague/unmeasurable items | `knowledge/*.md` | `rules/output-rules.md` |
| Wrong workflow behavior | `SKILL.md` | — |
| Quality calibration off | `templates/sample-output.md` | `knowledge/*.md` |
| Scope violation | `SKILL.md` Scope Rules | — |
