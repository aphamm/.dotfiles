#!/usr/bin/env bash
# Homebrew installation and package management

set -e

echo "==> Setting up Homebrew..."

brew_retry() {
    local attempt=1
    local max_attempts=4
    local retry_delay=30
    local output
    local status

    while true; do
        output="$("$@" 2>&1)" && {
            [ -n "$output" ] && printf '%s\n' "$output"
            return 0
        }

        status=$?
        [ -n "$output" ] && printf '%s\n' "$output"

        if ! printf '%s\n' "$output" | grep -Eq "already locked|Another .*brew vendor-install ruby|Failed to upgrade Homebrew Portable Ruby"; then
            return "$status"
        fi

        if [ "$attempt" -ge "$max_attempts" ]; then
            return "$status"
        fi

        echo "Homebrew is busy with another Ruby install; retrying in ${retry_delay}s..."
        sleep "$retry_delay"
        attempt=$((attempt + 1))
    done
}

# Install homebrew (if not already installed)
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Detect Homebrew path (Apple Silicon vs Intel)
if [ -f "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
else
    echo "Error: Could not find Homebrew installation"
    exit 1
fi

# Update homebrew + personal tap
brew_retry brew update
brew_retry brew tap aphamm/ztk https://github.com/aphamm/ztk

# Trust non-official taps so brew upgrade/bundle auto-load their formulae when
# HOMEBREW_REQUIRE_TAP_TRUST is set (Homebrew 4.x security gate).
brew trust --tap aphamm/ztk buo/cask-upgrade 2>/dev/null || true

# Upgrade already-installed formulae (not casks — those are managed explicitly)
brew_retry brew upgrade --formula

# Install everything from the Brewfile
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    echo "Installing tools from Brewfile..."
    brew_retry brew bundle --file="$DOTFILES_DIR/Brewfile"
fi

# Remove outdated versions from cellar
brew_retry brew cleanup

echo "==> Homebrew setup complete!"
