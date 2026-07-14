#!/usr/bin/env bash
set -euo pipefail

VAULT_PATH=""
while [ $# -gt 0 ]; do
    case "$1" in
        --vault-path) VAULT_PATH="$2"; shift 2 ;;
        --vault-path=*) VAULT_PATH="${1#*=}"; shift ;;
        *) shift ;;
    esac
done

SKILLS_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_SKILLS_DIR="$HOME/.claude/skills"
CLAUDE_DIR="$HOME/.claude"

mkdir -p "$CLAUDE_SKILLS_DIR"

# Cross-platform "make target identical to source" — real symlinks on
# Unix; on Windows (no admin/Developer Mode needed) a hardlink for the
# single CLAUDE.md file and a directory junction for memory/.
link_file() {
    src="$1"; dest="$2"
    if [ "$(uname -o 2>/dev/null || true)" = "Msys" ] || [ "$(uname -o 2>/dev/null || true)" = "Cygwin" ]; then
        rm -f "$dest"
        cmd.exe /c mklink /H "$(cygpath -w "$dest")" "$(cygpath -w "$src")" >/dev/null
    else
        ln -sf "$src" "$dest"
    fi
}

link_dir() {
    src="$1"; dest="$2"
    if [ "$(uname -o 2>/dev/null || true)" = "Msys" ] || [ "$(uname -o 2>/dev/null || true)" = "Cygwin" ]; then
        rm -rf "$dest"
        cmd.exe /c mklink /J "$(cygpath -w "$dest")" "$(cygpath -w "$src")" >/dev/null
    else
        ln -sfn "$src" "$dest"
    fi
}

# Global CLAUDE.md — Juanes' personal profile, injected into every session
link_file "$SKILLS_REPO/soul/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "linked:  soul/CLAUDE.md -> ~/.claude/CLAUDE.md"

# Vault project memory/ folder — needs the vault checkout path to compute
# the project slug Claude Code uses under ~/.claude/projects/<slug>/
if [ -n "$VAULT_PATH" ]; then
    VAULT_ABS="$(cd "$VAULT_PATH" && pwd)"
    # Same slug rule Claude Code uses: every ':', '\', '/', '.' -> '-'
    SLUG="$(echo "$VAULT_ABS" | sed -E 's#^/([a-zA-Z])/#\1:/#' | sed -E 's/[:\\\/.]/-/g')"
    PROJECT_DIR="$CLAUDE_DIR/projects/$SLUG"
    mkdir -p "$PROJECT_DIR"
    link_dir "$SKILLS_REPO/memory" "$PROJECT_DIR/memory"
    echo "linked:  memory/ -> ~/.claude/projects/$SLUG/memory"
else
    echo "skipped: vault memory/ link (pass --vault-path <path-to-vault-checkout> to enable)"
fi

for skill_dir in "$SKILLS_REPO"/*/ "$SKILLS_REPO"/.agents/skills/*/; do
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
