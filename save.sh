# Navigate to current file directory
cd "$(dirname "${BASH_SOURCE}")";
git pull origin main;

# Save brew file
brew bundle dump --describe --file=./Brewfile

# Save VSCode settings

cp ~/Library/Application\ Support/Code/User/settings.json ./settings.json 

# Save terminal settings
defaults export com.apple.Terminal ./terminal.plist
