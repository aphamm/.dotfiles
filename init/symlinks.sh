#!/usr/bin/env bash
# Create symlinks for config files (single-user, flat layout)

set -e

echo "==> Creating symlinks..."

# $DOTFILES_DIR is exported by init.sh; fall back to this script's parent.
DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

symlink_safe() {
    local source="$1" target="$2" label="$3"
    [ -e "$source" ] || return 0
    mkdir -p "$(dirname "$target")"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        mv "$target" "$target.backup.$(date +%s)"
    fi
    [ -L "$target" ] && rm "$target"
    ln -sf "$source" "$target"
    echo "  ✓ $label"
}

# --- shell / machine dotfiles ---
symlink_safe "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig" ".gitconfig"
symlink_safe "$DOTFILES_DIR/.zprofile"  "$HOME/.zprofile"  ".zprofile"
symlink_safe "$DOTFILES_DIR/.zshrc"     "$HOME/.zshrc"     ".zshrc"

# --- editor (VS Code) ---
symlink_safe "$DOTFILES_DIR/editor.json" \
    "$HOME/Library/Application Support/Code/User/settings.json" "editor.json (VS Code)"

# --- Claude Code ---
symlink_safe "$DOTFILES_DIR/agents/claude/CLAUDE.md"     "$HOME/.claude/CLAUDE.md"     "claude CLAUDE.md"
symlink_safe "$DOTFILES_DIR/agents/claude/settings.json" "$HOME/.claude/settings.json" "claude settings.json"
symlink_safe "$DOTFILES_DIR/agents/claude/scripts"       "$HOME/.claude/scripts"       "claude scripts"
symlink_safe "$DOTFILES_DIR/agents/skills"               "$HOME/.claude/skills"        "skills (shared)"

# --- Codex CLI ---
symlink_safe "$DOTFILES_DIR/agents/codex/AGENTS.md" "$HOME/.codex/AGENTS.md" "codex AGENTS.md"

# Symlink each skill into ~/.codex/skills/ (preserve .system/ dir)
mkdir -p "$HOME/.codex/skills"
for link in "$HOME/.codex/skills"/*; do
    if [ -L "$link" ] && [ ! -e "$link" ]; then
        rm "$link"
        echo "  ✓ pruned orphaned codex skill: $(basename "$link")"
    fi
done
for skill_dir in "$DOTFILES_DIR/agents/skills"/*; do
    [ -f "$skill_dir/SKILL.md" ] || continue
    symlink_safe "$skill_dir" "$HOME/.codex/skills/$(basename "$skill_dir")" "codex skill: $(basename "$skill_dir")"
done

echo "==> Symlinks created."
