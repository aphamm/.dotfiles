# Configs

Here are my custom config files for my MacBook setup.

install xcode

```
xcode-select --install
```

install rosetta

```
softwareupdate --install-rosetta
```

install homebrew

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/pham/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

[github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

```
# generate ssh key
ssh-keygen -t ed25519 -C "austinpham77@gmail.com"
# start ssh-agent in background
eval "$(ssh-agent -s)"
# create file to load keys
echo "Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519" >> ~/.ssh/config
# add key to ssh-agent
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
# copy ssh public key to clipboard
pbcopy < ~/.ssh/id_ed25519.pub
# add key on github
```

clone repo into home

```
git clone git@github.com:onlypham/.dotfiles.git
```

install brewfiles

```
brew bundle --file=~/.dotfiles/Brewfile
brew bundle dump --force --describe --file=~/.dotfiles/Brewfile # update dependencies
```

raycast password: austinpham

[uad software](https://www.uaudio.com/downloads/uad)
