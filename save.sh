#!/usr/bin/env bash
cd "$(dirname "${BASH_SOURCE}")"
git pull origin main

echo "Enter your GitHub username:"
read -r USERNAME

PERSONAL_DIR="./personal/$USERNAME"

if [ ! -d "$PERSONAL_DIR" ]; then
    echo "Error: No personal config found for '$USERNAME'"
    echo "Run bootstrap.sh first to create your personal config."
    exit 1
fi

# Save shared Brewfile (team tools)
brew bundle dump --describe --force --file=./Brewfile

# Save personal Brewfile (only packages not in shared Brewfile)
# This captures any additional tools the user has installed
brew bundle dump --describe --force --file="$PERSONAL_DIR/Brewfile.tmp"

# Filter out packages already in shared Brewfile
if [ -f "$PERSONAL_DIR/Brewfile" ]; then
    # Keep header comment from existing personal Brewfile
    head -2 "$PERSONAL_DIR/Brewfile" > "$PERSONAL_DIR/Brewfile.new"
    # Add packages from tmp that aren't in shared Brewfile
    grep -vFf ./Brewfile "$PERSONAL_DIR/Brewfile.tmp" >> "$PERSONAL_DIR/Brewfile.new" 2>/dev/null || true
    mv "$PERSONAL_DIR/Brewfile.new" "$PERSONAL_DIR/Brewfile"
fi
rm -f "$PERSONAL_DIR/Brewfile.tmp"

echo ""
echo "Saved:"
echo "  - ./Brewfile (shared team tools)"
echo "  - $PERSONAL_DIR/Brewfile (your personal tools)"
echo ""
echo "Other configs are symlinked (no save needed)."
