Here is my custom configuration for my MacBook Pro 2023 (M2 Pro) 😎

# Automated Configs 👨‍💻

First, run the `init.sh` script

```shell
# install xcode
xcode-select --install 

# install rosetta
softwareupdate --install-rosetta

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/pham/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# generate ssh key
ssh-keygen -t ed25519 -C "austinpham77@gmail.com"

# start ssh-agent in background
eval "$(ssh-agent -s)"

# add key to ssh-agent
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# copy ssh public key to clipboard
pbcopy < ~/.ssh/id_ed25519.pub
```

Save ssh key to [GitHub](https://github.com/settings/keys) then...

```shell
git clone git@github.com:aphamm/.dotfiles.git ~/.dotfiles
~/.dotfiles/setup.sh
```

# Manual Configs 🤮

- Import `pham.rayconfig` settings with password `austinpham`

- Retreive documents from SSD (`Pham`, `Documents`)

- System Preferences
  - Keyboard > Keyboard Shortcuts >
    - Remove Missiong Control
    - Save Picture of selected area as file: Shift Command 3
    - Copy picture of selected area to clipboard: Shift Command 4

## Audio Software

- [uad software](https://help.uaudio.com/hc/en-us/articles/360057137692-Apple-Silicon-M1-M2-Compatibility-Info?_gl=1*1qpuawn*_ga*MTYzMjUzNzU0Ny4xNjgwMDI1NTUz*_ga_CPJ5176QFT*MTY4MDAyNTU2NC4xLjEuMTY4MDAyNTkwNy4wLjAuMA..)

- [soothe2](https://oeksound.com/downloads/)

- [serum/rc20](https://splice.com/plugins/your-plugins)

- [Route system sounds to Apollo Virtual Channels](https://www.youtube.com/watch?v=9K3D7kNb5DI): Audio MIDI Setup > Universal Audio Thunderbolt > Output > Configure Speakers > Apply > Done

- cracked plugins: fabfilter, valhalla

## Other Software

- [Keynote](https://www.apple.com/keynote/)

# Factory Reset

- [System Settings](https://support.apple.com/en-us/102664) > General > Transfer or Reset > Erase All Content and Settings
