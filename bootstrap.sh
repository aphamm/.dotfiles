#!/usr/bin/env bash

# brew bundle dump --force --describe --file=~/.dotfiles/Brewfile
brew update
brew upgrade
brew bundle --file=~/.dotfiles/Brewfile
brew pin python@3.12
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

# schedule reboot
sudo pmset repeat restart MTWRFS  05:00:00