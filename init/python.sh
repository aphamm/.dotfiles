#!/usr/bin/env bash
# Python toolchain: uv + ruff

set -e

echo "==> Setting up Python..."

# Install uv (fast Python package manager)
echo "Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh

# Add uv to PATH for this session
if [ -f "$HOME/.local/bin/env" ]; then
    source "$HOME/.local/bin/env"
fi

# Install tooling
if command -v uv &> /dev/null; then
    echo "Installing Python dev tools..."
    uv tool install ruff@latest          # Linter + formatter (replaces flake8, black, isort)
    uv tool install basedpyright@latest  # Type checker + LSP for editors
    uv tool install pytest@latest        # Test runner
    uv tool install vulture@latest       # Dead code finder
    uv tool install radon@latest         # Cyclomatic complexity analyzer
fi

echo "==> Python setup complete!"
