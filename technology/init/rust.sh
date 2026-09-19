#!/usr/bin/env bash
# Rust toolchain via rustup

set -e

echo "==> Setting up Rust..."

echo "Installing Rust via rustup..."
(set -o pipefail; curl -fsSL https://sh.rustup.rs | sh -s -- -y)

# Source cargo env for this session
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

echo "Installing just-lsp..."
cargo install just-lsp

echo "==> Rust setup complete!"
