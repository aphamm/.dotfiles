#!/usr/bin/env bash
set -e  # Exit on first error

# Navigate to the technology directory and expose it to sourced setup scripts
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"
export DOTFILES_DIR
cd "$DOTFILES_DIR"

echo "aphamm/.dotfiles setup"
echo ""

# Pull latest without making network/auth failures invisible.
if ! git pull --recurse-submodules --ff-only; then
    echo "Warning: repository update failed; continuing with the local checkout." >&2
fi

# Ask for the administrator password upfront, keep alive for macOS prefs
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# --- Homebrew + packages ---
source "$DOTFILES_DIR/init/brew.sh"
echo ""

# --- Language toolchains ---
source "$DOTFILES_DIR/init/python.sh"; echo ""
source "$DOTFILES_DIR/init/node.sh";   echo ""
source "$DOTFILES_DIR/init/rust.sh";   echo ""

# --- Codex CLI ---
echo "Installing Codex CLI..."
(set -o pipefail; curl -fsSL https://chatgpt.com/codex/install.sh | sh)
echo ""

# --- Skill submodules (pinned; update deliberately via `just pull-external`) ---
git -C "$DOTFILES_DIR/.." submodule update --init --recursive
echo ""

# --- Symlinks (dotfiles + AI config) ---
source "$DOTFILES_DIR/init/symlinks.sh"
echo ""

# --- macOS system preferences ---
source "$DOTFILES_DIR/init/macos.sh"
echo ""

echo "Setup complete. Run: source ~/.zshrc"
