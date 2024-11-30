Here is my custom configuration for my MacBook Pro 2023 (M2 Pro) 😎

# Automated Configs 👨‍💻

First, run the following in your terminal.

```shell
# install xcode CLI & rosetta
# xcode-select --install
touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
softwareupdate -i -a
rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress && \
softwareupdate --install-rosetta --agree-to-license

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
  (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/pham/.zprofile && \
  eval "$(/opt/homebrew/bin/brew shellenv)"

# change default shell
chsh -s $(which zsh)

# generate ssh key, start ssh-agent, add key to agent, copy to clipboard
ssh-keygen -t ed25519 -C "austinpham77@gmail.com" && \
  eval "$(ssh-agent -s)" && \
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519 && \
  pbcopy < ~/.ssh/id_ed25519.pub
```

Save ssh key to [GitHub](https://github.com/settings/keys) then...

```shell
git clone git@github.com:aphamm/.dotfiles.git ~/.dotfiles && \
  cd ~/.dotfiles && git config --global user.name aphamm && \
  git config --global user.email austinpham77@gmail.com && \
  ~/.dotfiles/init.sh
```

# Manual Configs 🤮

- Import `rayconfig` settings with password `austinpham`

- Retreive documents from SSD (`Pham`)

- System Preferences
  - Keyboard > Keyboard Shortcuts >
    - Remove Mission Control
    - Remove Spotlight
    - Save Picture of selected area as file: Shift Command 3
    - Copy picture of selected area to clipboard: Shift Command 4
  - Desktop & Dock > Default web browser > Arc

- [Route system sounds to Apollo Virtual Channels](https://www.youtube.com/watch?v=9K3D7kNb5DI): Audio MIDI Setup > Universal Audio Thunderbolt > Output > Configure Speakers > Apply > Done

## Audio Software

- [UAD Software](https://help.uaudio.com/hc/en-us/articles/360057137692-Apple-Silicon-M1-M2-Compatibility-Info?_gl=1*1qpuawn*_ga*MTYzMjUzNzU0Ny4xNjgwMDI1NTUz*_ga_CPJ5176QFT*MTY4MDAyNTU2NC4xLjEuMTY4MDAyNTkwNy4wLjAuMA..)

- [Soothe2](https://oeksound.com/downloads/)

- [Serum & RC20](https://splice.com/plugins/your-plugins)

- Cracked: fabfilter, valhalla

# Factory Reset

- [System Settings](https://support.apple.com/en-us/102664) > General > Transfer or Reset > Erase All Content and Settings
