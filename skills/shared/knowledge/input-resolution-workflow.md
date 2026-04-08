# Input Resolution Workflow

Standard workflow for resolving skill inputs. Referenced by each SKILL.md instead of duplicating inline.

---

## File Type Conversion

Before reading any input file, check its extension:
- `.md` → Read directly, no conversion needed
- `.pdf` → Run `/read-pdf <path> sdlc/{phase}/input/` → read the converted .md
- `.docx` / `.doc` → Run `/read-word <path> sdlc/{phase}/input/` → read the converted .md
- `.xlsx` / `.xls` → Run `/read-excel <path> sdlc/{phase}/input/` → read the converted .md
- `.pptx` / `.ppt` → Run `/read-ppt <path> sdlc/{phase}/input/` → read the converted .md

Converted files are saved to `sdlc/{phase}/input/`. If a converted .md already exists and is newer than the source, skip conversion.

Note: Files auto-resolved from `sdlc/` pipeline are always .md and skip conversion.

---

## Input Resolution — Create Mode

For each input declared in the skill's input table, resolve using this priority order:

```
1. Exists in the Default Path (e.g., sdlc/{source-phase}/final/)?  → Read it, copy to sdlc/{phase}/input/ → DONE
2. User specified a different path?                                 → Read it, convert if needed, copy to sdlc/{phase}/input/ → DONE
3. Exists in sdlc/{phase}/input/?                                   → Read it → DONE
4. Not found?
   - If Required → FAIL with the Fallback message from the input table
   - If Optional → Proceed without, note missing context in Q&A
```

Rules: IR-01 through IR-04 from `skills/shared/rules/output-rules.md` apply.

---

## Input Resolution — Refine Mode

```
For existing draft (required):
1. User specified path?                                             → Read it, copy to sdlc/{phase}/input/ → DONE
2. Exists in sdlc/{phase}/input/?                                   → Read it → DONE
3. Exists in sdlc/{phase}/draft/ (latest version)?                  → Read it, copy to sdlc/{phase}/input/ → DONE
4. Not found? → FAIL: "No existing draft found. Run the create mode first."

For review report / feedback (required):
1. User provided feedback directly in message?                      → Save to sdlc/{phase}/input/review-report.md
2. User specified path?                                             → Read it, copy to sdlc/{phase}/input/
3. Exists in sdlc/{phase}/input/review-report.md?                   → Read it
4. Not found? → Ask: "What feedback do you have on the current draft?"
```

---

## Input Resolution — Score Mode

Handled by `skills/shared/knowledge/score-workflow.md`.
