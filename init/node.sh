#!/usr/bin/env bash
# Node toolchain: pnpm via corepack

set -e

echo "==> Setting up Node..."

# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
# in lieu of restarting the shell
\. "$HOME/.nvm/nvm.sh"
# Download and install Node.js:
nvm install 24

if command -v npm &> /dev/null; then
    echo "Installing pnpm via corepack..."
    npm install -g corepack
    corepack enable pnpm
    export PNPM_HOME="$HOME/Library/pnpm"
    export PATH="$PNPM_HOME:$PATH"
    if ! command -v pnpm &>/dev/null; then
        pnpm setup
    fi
    echo "pnpm version: $(pnpm -v)"
else
    echo "npm not found. Install Node first (included in Brewfile)."
    exit 1
fi

echo "==> Node setup complete!"
