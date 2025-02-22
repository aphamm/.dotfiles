#!/usr/bin/env bash

git config --global user.name aphamm
git config --global user.email austinpham77@gmail.com

# brew bundle dump --force --describe
brew update
brew upgrade
brew bundle --file=~/.dotfiles/Brewfile
brew cleanup

# https://github.com/mathiasbynens/dotfiles/blob/main/bootstrap.sh
cd "$(dirname "${BASH_SOURCE}")";

git pull origin main;

function doIt() {
	rsync --exclude ".git/" \
		--exclude ".gitignore/" \
		--exclude ".DS_Store" \
		--exclude ".osx" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "Brewfile" \
		--exclude "pham.rayconfig" \
		--exclude "settings.json" \
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

# install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# schedule reboot
sudo pmset repeat restart MTWRFS  05:00:00

# download Node.js and pnpm 
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

\. "$HOME/.nvm/nvm.sh"

nvm install 22
corepack enable pnpm