# Navigate to current file directory
cd "$(dirname "${BASH_SOURCE}")";
git pull origin main;

function doIt() {
	# Save brew file
    brew bundle dump --describe --file=./Brewfile2

    # Save relevant config files
    cp ~/.starship.toml ./.starship.toml
    cp ~/.zprofile ./.zprofile
    cp ~/.zshrc ./.zshrc

    # Save VS code settings
    cp ~/Library/Application\ Support/Code/User/settings.json ./settings.json
    cp ~/Library/Application\ Support/Code/User/keybindings.json ./keybindings.json

    # Save Ghostty settings
    cp $HOME/Library/Application\ Support/com.mitchellh.ghostty/config ghostty_config

    # Save Zen profile files
    for profile_dir in /Users/apham/Library/Application\ Support/zen/Profiles/*; do

      chrome_dir="$profile_dir/chrome"

      # Check if the chrome directory exists within the profile directory
      if [[ ! -d "$chrome_dir" ]]; then
        continue
      fi

      userChrome_css=$(find "$chrome_dir" -maxdepth 1 -type f -name "userChrome.css" -print0 | xargs -0)
      userContent_css=$(find "$chrome_dir" -maxdepth 1 -type f -name "userContent.css" -print0 | xargs -0)

      if [[ -n "$userChrome_css" ]]; then
        echo "Saving userChrome.css in $profile_dir"
        cp "$userChrome_css" "$HOME/.dotfiles/"
      fi

      if [[ -n "$userContent_css" ]]; then
        echo "Saving userContent.css in $profile_dir"
        cp "$userContent_css" "$HOME/.dotfiles/"
      fi

    done
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
