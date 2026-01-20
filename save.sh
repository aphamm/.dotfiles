#!/usr/bin/env bash
cd "$(dirname "${BASH_SOURCE}")"
git pull origin main

# Only Brewfile needs explicit saving (it's generated, not symlinked)
brew bundle dump --describe --force --file=./Brewfile

echo "Brewfile saved. Other configs are symlinked (no save needed)."
