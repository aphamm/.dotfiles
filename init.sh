#!/usr/bin/env bash
set -e  # Exit on first error

# Navigate to repo root and expose it to sourced setup scripts
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"
export DOTFILES_DIR
cd "$DOTFILES_DIR"

echo "aphamm/.dotfiles setup"
echo ""

# Pull latest (best effort — fresh clones / detached states shouldn't abort)
git pull --recurse-submodules --ff-only 2>/dev/null || true

# Ask for the administrator password upfront, keep alive for macOS prefs
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# --- Homebrew + packages ---
source "$DOTFILES_DIR/init/brew.sh"
echo ""

# --- Language toolchains ---
source "$DOTFILES_DIR/init/python.sh"; echo ""
source "$DOTFILES_DIR/init/node.sh";   echo ""
source "$DOTFILES_DIR/init/go.sh";     echo ""
source "$DOTFILES_DIR/init/rust.sh";   echo ""

# --- Claude Code (native installer; self-updates in place, so guard re-runs) ---
command -v claude &> /dev/null || curl -fsSL https://claude.ai/install.sh | bash
echo ""

# --- Skill submodules (Claude/Codex skills live in agents/external) ---
git submodule update --init --remote 2>&1 || true
echo ""

# --- Symlinks (dotfiles + AI config) ---
source "$DOTFILES_DIR/init/symlinks.sh"
echo ""

# --- macOS system preferences ---
source "$DOTFILES_DIR/init/macos.sh"
echo ""

# --- Tests (non-fatal) ---
if command -v just &> /dev/null; then
    just test || echo "⚠ some tests failed"
fi
echo ""

echo "Setup complete. Run: source ~/.zshrc"
