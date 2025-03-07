#!/usr/bin/env bash

# Navigate to current file directory
cd "$(dirname "${BASH_SOURCE}")";
git pull origin main;

# Install brew packages
eval "$(/opt/homebrew/bin/brew shellenv)"

# Use latest homebrew
brew update

# Upgrade already-installed formulae
brew upgrade

# Install via Brewflie
brew bundle --file=./Brewfile

# Remove outdated versions from cellar
brew cleanup

# Install uv (Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Add $HOME/.local/bin to your PATH
source $HOME/.local/bin/env

# Download and install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# In lieu of restarting the shell
\. "$HOME/.nvm/nvm.sh"

# Download and install Node.js
nvm install 22

# Download and install pnpm
npm install --global corepack@latest
corepack enable pnpm

# Install Rustup tool, which installs Rust
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

# Copy VS code settings
cp ./settings.json ~/Library/Application\ Support/Code/User/settings.json
cp ./keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json

# Copy relevant configuration files
# https://github.com/mathiasbynens/dotfiles/blob/main/bootstrap.sh
function doIt() {
	rsync --include ".starship.toml" \
		--include ".zprofile" \
		--include ".zshrc" \
		--exclude "*" \
		-avh --no-perms . ~;
	source ~/.zprofile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;

source ./config.sh
