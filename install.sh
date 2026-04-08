#!/bin/bash
# Install SDLC Skills to Claude Code
# Usage: bash install.sh [--symlink]
#
# Installs each skill as a separate folder under ~/.claude/skills/
# Shared resources are installed alongside skills for self-contained operation.

SKILL_DIR="$HOME/.claude/skills"
SRC_DIR="$(cd "$(dirname "$0")" && pwd)/skills"
MODE="copy"

if [ "$1" = "--symlink" ]; then
  MODE="symlink"
fi

mkdir -p "$SKILL_DIR"

count=0

# Install shared resources (project-wide)
if [ -d "$SRC_DIR/shared" ]; then
  rm -rf "$SKILL_DIR/sdlc-shared"
  if [ "$MODE" = "symlink" ]; then
    ln -s "$SRC_DIR/shared" "$SKILL_DIR/sdlc-shared"
    echo "  Linked: sdlc-shared"
  else
    cp -r "$SRC_DIR/shared" "$SKILL_DIR/sdlc-shared"
    echo "  Installed: sdlc-shared"
  fi
  count=$((count + 1))
fi

# Install utility skills (read-pdf, read-word, read-excel, read-ppt)
if [ -d "$SRC_DIR/shared/utils" ]; then
  for util_dir in "$SRC_DIR"/shared/utils/*/; do
    [ -d "$util_dir" ] || continue
    util=$(basename "$util_dir")
    [ -f "$util_dir/SKILL.md" ] || continue
    target="sdlc-${util}"
    rm -rf "$SKILL_DIR/$target"
    if [ "$MODE" = "symlink" ]; then
      ln -s "$util_dir" "$SKILL_DIR/$target"
      echo "  Linked: $target"
    else
      cp -r "$util_dir" "$SKILL_DIR/$target"
      echo "  Installed: $target"
    fi
    count=$((count + 1))
  done
fi

# Install each phase and its skills
for phase_dir in "$SRC_DIR"/init "$SRC_DIR"/req "$SRC_DIR"/design "$SRC_DIR"/test "$SRC_DIR"/impl "$SRC_DIR"/deploy "$SRC_DIR"/ops; do
  [ -d "$phase_dir" ] || continue
  phase=$(basename "$phase_dir")

  # Install phase shared resources
  if [ -d "$phase_dir/shared" ]; then
    target="sdlc-${phase}-shared"
    rm -rf "$SKILL_DIR/$target"
    if [ "$MODE" = "symlink" ]; then
      ln -s "$phase_dir/shared" "$SKILL_DIR/$target"
      echo "  Linked: $target"
    else
      cp -r "$phase_dir/shared" "$SKILL_DIR/$target"
      echo "  Installed: $target"
    fi
    count=$((count + 1))
  fi

  # Install each skill within the phase
  for skill_dir in "$phase_dir"/*/; do
    [ -d "$skill_dir" ] || continue
    skill=$(basename "$skill_dir")

    # Skip shared/, final/, and other non-skill directories
    [ "$skill" = "shared" ] && continue
    [ "$skill" = "final" ] && continue

    # Only install if SKILL.md exists
    [ -f "$skill_dir/SKILL.md" ] || continue

    target="sdlc-${phase}-${skill}"
    rm -rf "$SKILL_DIR/$target"
    if [ "$MODE" = "symlink" ]; then
      ln -s "$skill_dir" "$SKILL_DIR/$target"
      echo "  Linked: $target"
    else
      cp -r "$skill_dir" "$SKILL_DIR/$target"
      echo "  Installed: $target"
    fi
    count=$((count + 1))
  done
done

# Legacy support: install old-style sdlc-* skills if they exist
for skill in "$SRC_DIR"/sdlc-*; do
  [ -d "$skill" ] || continue
  name=$(basename "$skill")
  rm -rf "$SKILL_DIR/$name"
  if [ "$MODE" = "symlink" ]; then
    ln -s "$skill" "$SKILL_DIR/$name"
    echo "  Linked: $name (legacy)"
  else
    cp -r "$skill" "$SKILL_DIR/$name"
    echo "  Installed: $name (legacy)"
  fi
  count=$((count + 1))
done

echo ""
echo "Done! $count items installed to $SKILL_DIR"
echo ""
echo "Commands (26 skills + 4 utilities, 56 commands):"
echo ""
echo "  Init:   /init-charter  /init-scope  /init-risk"
echo "  Req:    /req-epic  /req-userstory  /req-backlog  /req-trace"
echo "  Design: /design-stack  /design-arch  /design-db  /design-api  /design-adr"
echo "  Test:   /test-strategy  /test-plan  /test-cases"
echo "  Impl:   /impl-sprint  /impl-codegen  /impl-workflow"
echo "  Deploy: /deploy-cicd  /deploy-release  /deploy-env"
echo "  Ops:    /ops-monitor  /ops-incident  /ops-sla  /ops-runbook  /ops-change"
echo "  Utils:  /read-pdf  /read-word  /read-excel  /read-ppt"
echo ""
echo "  Each skill command has a -refine variant (e.g., /init-charter-refine)"
echo "  Skills accept any file type: md, pdf, docx, xlsx, pptx"
echo "  Output goes to sdlc/<phase>/draft/ in your project directory"
echo "  See README.md for full documentation."
