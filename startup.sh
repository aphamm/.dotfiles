# clone repo into home
git clone git@github.com:onlypham/.dotfiles.git ~/.dotfiles

# install brew files
# update via `brew bundle dump --force --describe --file=~/.dotfiles/Brewfile`
brew bundle --file=~/.dotfiles/Brewfile

# install python packages
pip install virtualenv
pip install virtualenvwrapper

# copy .zshrc to home
cat ~/.dotfiles/.zshrc >> ~/.zshrc