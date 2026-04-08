#!/bin/bash
# Install SDLC Skills to Claude Code
# Usage: bash install.sh [options] [target-path]
#
# Options:
#   --symlink    Symlink instead of copy (for development)
#   -g, --global Install to ~/.claude/skills/ (global)
#
# Arguments:
#   target-path  Project directory to install into (default: global)
#
# Examples:
#   ./install.sh /path/to/my-project        # Install into my-project/.claude/skills/
#   ./install.sh --symlink /path/to/project  # Symlink into project
#   ./install.sh -g                          # Install globally (~/.claude/skills/)
#   ./install.sh --symlink -g               # Symlink globally

SRC_DIR="$(cd "$(dirname "$0")" && pwd)/skills"
MODE="copy"
TARGET_PATH=""
GLOBAL=false

for arg in "$@"; do
  case "$arg" in
    --symlink) MODE="symlink" ;;
    -g|--global) GLOBAL=true ;;
    -*) echo "Unknown option: $arg"; exit 1 ;;
    *) TARGET_PATH="$arg" ;;
  esac
done

# Determine install directory
if [ "$GLOBAL" = true ]; then
  SKILL_DIR="$HOME/.claude/skills"
  echo "Installing globally to $SKILL_DIR"
elif [ -n "$TARGET_PATH" ]; then
  # Resolve to absolute path
  TARGET_PATH="$(cd "$TARGET_PATH" 2>/dev/null && pwd)" || { echo "Error: Directory '$2' not found."; exit 1; }
  SKILL_DIR="$TARGET_PATH/.claude/skills"
  echo "Installing to project: $TARGET_PATH"
else
  echo "Usage: ./install.sh [--symlink] <target-path>"
  echo "       ./install.sh [--symlink] -g"
  echo ""
  echo "  <target-path>  Project directory to install into"
  echo "  -g, --global   Install to ~/.claude/skills/"
  echo "  --symlink      Symlink instead of copy"
  exit 1
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

# Install utility skills (read-pdf, read-word, read-excel, read-ppt, skill-evolution)
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
echo "Commands (29 skills + 5 utilities):"
echo ""
echo "  Init:   /init-charter  /init-scope  /init-risk"
echo "  Req:    /req-epic  /req-userstory  /req-backlog  /req-trace"
echo "  Design: /design-stack  /design-arch  /design-db  /design-api  /design-api-security  /design-adr"
echo "  Test:   /test-strategy  /test-plan  /test-cases  /test-integration"
echo "  Impl:   /impl-sprint  /impl-scaffold  /impl-codegen  /impl-workflow"
echo "  Deploy: /deploy-cicd  /deploy-release  /deploy-env"
echo "  Ops:    /ops-monitor  /ops-incident  /ops-sla  /ops-runbook  /ops-change"
echo "  Utils:  /read-pdf  /read-word  /read-excel  /read-ppt  /skill-evolution"
echo ""
echo "  Each skill supports --create, --refine, and --score modes"
echo "  Skills accept any file type: md, pdf, docx, xlsx, pptx"
echo "  Output goes to sdlc/<phase>/draft/ in your project directory"
