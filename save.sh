# Navigate to current file directory
cd "$(dirname "${BASH_SOURCE}")";
git pull origin main;

function doIt() {
	# Save brew file
    brew bundle dump --describe --file=./Brewfile

    # Save relevant config files
    cp ~/.zprofile ./.zprofile
    cp ~/.zshrc ./.zshrc

    # Save Cursor editor settings
    cp ~/Library/Application\ Support/Cursor/User/settings.json ./settings.json

	# Save Ghostty settings
    cp $HOME/Library/Application\ Support/com.mitchellh.ghostty/config ghostty_config

    # Save Starship settings
    cp ~/.starship.toml ./starship.toml

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
