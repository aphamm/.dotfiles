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
  eval "$(/opt/homebrew/bin/brew shellenv)"

# generate ssh key, start ssh-agent, add key to agent, copy to clipboard
ssh-keygen -t ed25519 -C "austinpham77@gmail.com" && \
  eval "$(ssh-agent -s)" && \
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519 && \
  pbcopy < ~/.ssh/id_ed25519.pub
```

Save ssh key to [GitHub](https://github.com/settings/keys) then...

```shell
git clone git@github.com:aphamm/.dotfiles.git ~/.dotfiles && \
  cd ~/.dotfiles && ./bootstrap.sh
```

# Manual Configs 🤮

- Import `rayconfig` settings with password `austinpham`

- Retreive documents from SSD (`Pham`)

- System Preferences
  - Battery >
    - Low Power Mode > Always
    - Options > Optimize video streaming while on battery > On
  - Appearance
    - Appearance > Dark
  - Control Center
    - Accessibility Shortcuts > Show in Control Center
    - Music Recognition > Show in Control Center
    - Menu Bar Only >
      - Spotlight > Don't Show in Menu Bar
  - Displays
    - Preset > Apple Display (P3-500 nits)
  - Notifications > Turn off All
    - Allow notifications when the screen is locked > Off
  - Keyboard >
    - Keyboard Shortcuts >
      - Screenshots > 
        - Save picture of screen as a file > Off
        - Copy picture of screen to the clipboard > Off
        - Save picture of selected area as file > Shift Command 3
        - Copy picture of selected area to clipboard > Shift Command 4
      - Spotlight >
        - Show Spotlight search > Off
- [Route system sounds to Apollo Virtual Channels](https://www.youtube.com/watch?v=9K3D7kNb5DI): Audio MIDI Setup > Universal Audio Thunderbolt > Output > Configure Speakers > Apply > Done

## Audio Software

- [UAD Software](https://help.uaudio.com/hc/en-us/articles/360057137692-Apple-Silicon-M1-M2-Compatibility-Info?_gl=1*1qpuawn*_ga*MTYzMjUzNzU0Ny4xNjgwMDI1NTUz*_ga_CPJ5176QFT*MTY4MDAyNTU2NC4xLjEuMTY4MDAyNTkwNy4wLjAuMA..)

- [Soothe2](https://oeksound.com/downloads/)

- [Serum & RC20](https://splice.com/plugins/your-plugins)

- Cracked: fabfilter, valhalla

# Factory Reset

- [System Settings](https://support.apple.com/en-us/102664) > General > Transfer or Reset > Erase All Content and Settings
