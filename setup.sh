# install brew files
# update via `brew bundle dump --force --describe --file=~/.dotfiles/Brewfile`
brew bundle --file=~/.dotfiles/Brewfile # homebrew installs pip pointing to homebrew'd Python3

# copy .zshrc to home
cat ~/.dotfiles/.zshrc >> ~/.zshrc

# schedule reboot
sudo pmset repeat restart MTWRFS  05:00:00