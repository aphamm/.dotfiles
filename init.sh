# brew bundle dump --force --describe --file=~/.dotfiles/Brewfile
brew bundle --file=~/.dotfiles/Brewfile

# schedule reboot
sudo pmset repeat restart MTWRFS  05:00:00

# create symlinks
rm ~/.zshrc
ln -s ~/.dotfiles/.zshrc ~/.zshrc
rm ~/.config/starship.toml
ln -s ~/.dotfiles/starship.toml ~/.config/starship.toml
rm ~/Library/Application\ Support/Code/User/settings.json
ls -s ~/.dotfiles/settings.json ~/Library/Application\ Support/Code/User/settings.json
