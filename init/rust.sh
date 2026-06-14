#!/usr/bin/env bash
# Rust toolchain via rustup

set -e

echo "==> Setting up Rust..."

echo "Installing Rust via rustup..."
curl https://sh.rustup.rs -sSf | sh -s -- -y

# Source cargo env for this session
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

echo "==> Rust setup complete!"
