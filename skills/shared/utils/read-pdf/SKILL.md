---
name: read-pdf
description: >
  Convert a PDF file to markdown format. Reads PDF content and outputs
  a structured markdown file preserving headings, tables, and lists.
  ONLY activated by command: `/read-pdf`.
  NEVER auto-trigger based on keywords.
argument-hint: "[path to PDF file] [output directory]"
version: "1.0"
category: sdlc-utility
---

# PDF to Markdown Converter

## Purpose

Read a PDF file and convert its content to markdown format. Used internally by SDLC skills when users provide PDF files as input.

---

## Workflow

1. **Validate Input**
   - Verify the file exists and has `.pdf` extension
   - Determine output path: if output directory provided, use it; otherwise use same directory as source file

2. **Read PDF Content**
   - Use the Read tool to read the PDF file (Claude Code natively supports PDF reading)
   - Extract all text content, preserving structure

3. **Convert to Markdown**
   - Preserve document structure: headings, paragraphs, lists, tables
   - Convert any detected tables to markdown table format
   - Preserve emphasis (bold, italic) where detectable
   - Add a header comment: `<!-- Converted from: {original-filename} on {date} -->`

4. **Write Output**
   - Write to `{output-dir}/{original-name}.md`
   - Report: "Converted {filename}.pdf → {filename}.md ({N} lines)"

---

## Scope Rules

### This skill DOES:
- Read PDF files and extract text content
- Convert structured content to markdown format
- Preserve headings, tables, lists, and basic formatting

### This skill does NOT:
- Extract images from PDFs (text only)
- Perform OCR on scanned documents
- Modify the original PDF file
- Process password-protected PDFs
