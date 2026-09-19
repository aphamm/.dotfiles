#!/usr/bin/env bash
# Create symlinks for config files (single-user layout)

set -e

echo "==> Creating symlinks..."

# $DOTFILES_DIR is exported by init.sh; fall back to this script's parent.
DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

symlink_safe() {
    local source="$1" target="$2" label="$3"
    if [ ! -e "$source" ]; then
        echo "Missing required symlink source: $source" >&2
        return 1
    fi
    mkdir -p "$(dirname "$target")"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        mv "$target" "$target.backup.$(date +%s)"
    fi
    [ -L "$target" ] && rm "$target"
    ln -sf "$source" "$target"
    echo "  ✓ $label"
}

# --- shell / machine dotfiles ---
symlink_safe "$DOTFILES_DIR/configs/.gitconfig" "$HOME/.gitconfig" ".gitconfig"
symlink_safe "$DOTFILES_DIR/configs/.zprofile"  "$HOME/.zprofile"  ".zprofile"
symlink_safe "$DOTFILES_DIR/configs/.zshrc"     "$HOME/.zshrc"     ".zshrc"

# --- Codex ---
# Seed a fresh installation; never overwrite app-generated runtime configuration.
mkdir -p "$HOME/.codex"
if [ ! -e "$HOME/.codex/config.toml" ] && [ ! -L "$HOME/.codex/config.toml" ]; then
    install -m 600 "$DOTFILES_DIR/configs/codex.config.toml" "$HOME/.codex/config.toml"
    echo "  ✓ Codex config.toml"
else
    echo "  Codex config.toml already exists; preserving it."
fi

# --- editor (VS Code) ---
symlink_safe "$DOTFILES_DIR/configs/editor.json" \
    "$HOME/Library/Application Support/Code/User/settings.json" "editor.json (VS Code)"

# --- omp config + themes ---
symlink_safe "$DOTFILES_DIR/harness/config.yml" "$HOME/.omp/agent/config.yml" "omp config.yml"
symlink_safe "$DOTFILES_DIR/harness/themes/omp-dark.json"  "$HOME/.omp/agent/themes/omp-dark.json"  "omp theme (dark)"
symlink_safe "$DOTFILES_DIR/harness/themes/omp-light.json" "$HOME/.omp/agent/themes/omp-light.json" "omp theme (light)"

symlink_safe "$DOTFILES_DIR/harness/SYSTEM.md" "$HOME/.omp/agent/SYSTEM.md" "omp SYSTEM.md"

# --- Oh My Pi ---
# omp auto-loads ~/.omp/agent/AGENTS.md as global context (native provider)
# and discovers skills at ~/.agents/skills/*/SKILL.md (agents provider).
symlink_safe "$DOTFILES_DIR/agents/AGENTS.md" "$HOME/.omp/agent/AGENTS.md" "omp AGENTS.md"
symlink_safe "$DOTFILES_DIR/agents/skills"    "$HOME/.agents/skills"      "omp skills (shared)"

echo "==> Symlinks created."
