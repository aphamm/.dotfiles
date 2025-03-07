# Navigate to current file directory
cd "$(dirname "${BASH_SOURCE}")";
git pull origin main;

function doIt() {
	# Save brew file
    brew bundle dump --describe --file=./Brewfile

    # Save relevant config files
    cp ~/.starship.toml ./.starship.toml
    cp ~/.zprofile ./.zprofile
    cp ~/.zshrc ./.zshrc

    # Save VS Code settings
    cp ~/Library/Application\ Support/Code/User/settings.json ./settings.json
    cp ~/Library/Application\ Support/Code/User/keybindings.json ./keybindings.json
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your dotfiles directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
