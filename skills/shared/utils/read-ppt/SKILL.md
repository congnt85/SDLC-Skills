---
name: read-ppt
description: >
  Convert a PowerPoint presentation (.pptx) to markdown format. Reads slide
  content and outputs structured markdown preserving slide titles and content.
  ONLY activated by command: `/read-ppt`.
  NEVER auto-trigger based on keywords.
argument-hint: "[path to PPTX file] [output directory]"
version: "1.0"
category: sdlc-utility
---

# PowerPoint to Markdown Converter

## Purpose

Read a PowerPoint presentation (.pptx) and convert its content to markdown format. Used internally by SDLC skills when users provide PowerPoint files as input.

---

## Workflow

1. **Validate Input**
   - Verify the file exists and has `.pptx` or `.ppt` extension
   - Determine output path: if output directory provided, use it; otherwise use same directory as source file

2. **Read Presentation Content**
   - Try `python3` with `python-pptx`: `python3 -c "from pptx import Presentation; ..."`
   - If not available, try `pandoc`: `pandoc -f pptx -t markdown "{input}" -o "{output}"`
   - As last resort, use `unzip` to extract XML and parse slide*.xml files

3. **Convert to Markdown**
   - Create one section per slide: `## Slide {N}: {slide-title}`
   - Extract slide title as heading
   - Extract body text preserving bullet points as markdown lists
   - Convert any tables in slides to markdown tables
   - Extract speaker notes as blockquotes: `> **Speaker Notes:** {notes}`
   - Add a header comment: `<!-- Converted from: {original-filename} on {date} -->`

4. **Write Output**
   - Write to `{output-dir}/{original-name}.md`
   - Report: "Converted {filename}.pptx → {filename}.md ({N} slides)"

---

## Scope Rules

### This skill DOES:
- Read PowerPoint presentations (.pptx, .ppt) and extract text content
- Convert slide titles, body text, and speaker notes to markdown
- Convert tables within slides to markdown tables
- Preserve slide ordering and structure

### This skill does NOT:
- Extract images, charts, or SmartArt (text only)
- Preserve animations or transitions
- Preserve complex layouts (text boxes positioned on slides)
- Modify the original presentation
- Handle password-protected files
