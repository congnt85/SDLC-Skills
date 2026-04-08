---
name: read-excel
description: >
  Convert an Excel spreadsheet (.xlsx) to markdown format. Reads spreadsheet
  content and outputs markdown tables for each sheet.
  ONLY activated by command: `/read-excel`.
  NEVER auto-trigger based on keywords.
argument-hint: "[path to XLSX file] [output directory]"
version: "1.0"
category: sdlc-utility
---

# Excel to Markdown Converter

## Purpose

Read an Excel spreadsheet (.xlsx) and convert its content to markdown format with tables. Used internally by SDLC skills when users provide Excel files as input.

---

## Workflow

1. **Validate Input**
   - Verify the file exists and has `.xlsx` or `.xls` extension
   - Determine output path: if output directory provided, use it; otherwise use same directory as source file

2. **Read Spreadsheet Content**
   - Try `python3` with `openpyxl`: `python3 -c "import openpyxl; ..."`
   - If not available, try `ssconvert` (Gnumeric): `ssconvert "{input}" "{output}.csv"`
   - As last resort, try `python3` with `csv` module on exported CSV

3. **Convert to Markdown**
   - Create one section per worksheet: `## Sheet: {sheet-name}`
   - Convert each sheet to a markdown table
   - Use first row as table header
   - Handle merged cells by repeating values
   - Skip completely empty rows/columns
   - Format numbers and dates appropriately
   - Add a header comment: `<!-- Converted from: {original-filename} on {date} -->`

4. **Write Output**
   - Write to `{output-dir}/{original-name}.md`
   - Report: "Converted {filename}.xlsx → {filename}.md ({N} sheets, {M} rows)"

---

## Scope Rules

### This skill DOES:
- Read Excel spreadsheets (.xlsx, .xls) and extract data
- Convert sheets to markdown tables
- Handle multiple worksheets
- Format numbers and dates

### This skill does NOT:
- Preserve cell formatting (colors, fonts, borders)
- Execute or evaluate formulas (reads calculated values only)
- Extract charts or images
- Modify the original spreadsheet
- Handle password-protected files
