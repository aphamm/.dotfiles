# Configs

Here are my custom config files for my MacBook setup.

```
$ xcode-select --install
$ softwareupdate --install-rosetta # intel processor
```
Create GitHub Links
- [SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

Clone this remote repo
```
$ git clone git@github.com:onlypham/.dotfiles.git
```


Install Brew
```
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew bundle --file=~/.dotfiles/Brewfile
brew bundle dump --force --describe --file=~/.dotfiles/Brewfile # update dependencies
```
Import Raycast 
password: austinpham

Spotify

Zoom

Appstore
- Pages

ssh-copy-id remote_username@server_ip_address


iTerm2 Settings

[Fonts](https://www.jetbrains.com/lp/mono/)

Todo Items
[ ] Look more into Starship Configurations
[ ] Update BrewLock
[ ] Update Rayconfig
[ ] Get better VS Code iTerm colors & update congid
[ ] Update readme...


Compress tar archive
tar -czvf LotsOfFiles.tgz LotsOfFiles

UNcompress a tar archive
tar -xvf LotsOfFiles.tgz
