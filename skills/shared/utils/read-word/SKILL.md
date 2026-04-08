---
name: read-word
description: >
  Convert a Word document (.docx) to markdown format. Reads document content
  and outputs a structured markdown file preserving headings, tables, and lists.
  ONLY activated by command: `/read-word`.
  NEVER auto-trigger based on keywords.
argument-hint: "[path to DOCX file] [output directory]"
version: "1.0"
category: sdlc-utility
---

# Word Document to Markdown Converter

## Purpose

Read a Word document (.docx) and convert its content to markdown format. Used internally by SDLC skills when users provide Word documents as input.

---

## Workflow

1. **Validate Input**
   - Verify the file exists and has `.docx` or `.doc` extension
   - Determine output path: if output directory provided, use it; otherwise use same directory as source file

2. **Read Document Content**
   - Use available tools to read the .docx file content
   - If direct reading fails, try using `pandoc` to convert: `pandoc -f docx -t markdown "{input}" -o "{output}"`
   - If pandoc is not available, try `python3 -c "import docx; ..."` with python-docx
   - As last resort, use `unzip` to extract XML and parse document.xml

3. **Convert to Markdown**
   - Preserve document structure: headings (H1-H6), paragraphs, lists (ordered/unordered)
   - Convert tables to markdown table format
   - Preserve emphasis (bold, italic, underline→bold)
   - Handle numbered lists and bullet lists
   - Add a header comment: `<!-- Converted from: {original-filename} on {date} -->`

4. **Write Output**
   - Write to `{output-dir}/{original-name}.md`
   - Report: "Converted {filename}.docx → {filename}.md ({N} lines)"

---

## Scope Rules

### This skill DOES:
- Read Word documents (.docx, .doc) and extract text content
- Convert structured content to markdown format
- Preserve headings, tables, lists, and basic formatting

### This skill does NOT:
- Extract embedded images (text only)
- Preserve complex formatting (columns, text boxes, shapes)
- Modify the original document
- Handle corrupted or password-protected files
