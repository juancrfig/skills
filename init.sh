#!/usr/bin/env bash
set -euo pipefail

SKILLS_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_SKILLS_DIR="$HOME/.claude/skills"

mkdir -p "$CLAUDE_SKILLS_DIR"

for skill_dir in "$SKILLS_REPO"/*/; do
    [ -f "${skill_dir}SKILL.md" ] || continue

    skill_name="$(basename "$skill_dir")"
    target="$CLAUDE_SKILLS_DIR/$skill_name"

    if [ -L "$target" ]; then
        ln -sfn "$skill_dir" "$target"
        echo "updated: $skill_name"
    elif [ -e "$target" ]; then
        echo "skipped: $skill_name (exists and is not a symlink)"
    else
        ln -s "$skill_dir" "$target"
        echo "linked:  $skill_name"
    fi
done

echo "done — skills available in $CLAUDE_SKILLS_DIR"
