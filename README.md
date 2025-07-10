Here is my custom configuration for my MacBook Air 2025 (M4) 😎

# Automated Configs 👨‍💻

First, run the following in your terminal.

```shell
# install xcode CLI & rosetta
# xcode-select --install
touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
softwareupdate -i -a
rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress && \
softwareupdate --install-rosetta --agree-to-license

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

- Retrieve documents from SSD (`Pham`)

- Import `rayconfig` settings with password `austinpham`

- System Preferences

  - Battery >
    - Options > Optimize video streaming while on battery > On
  - Control Center >
    - Bluetooth > Show in Menu Bar
    - Accessibility Shortcuts > Show in Control Center
    - Battery >
      - Show Percentage > On
      - Show Energy Mode > Always
    - Music Recognition > Show in Control Center
    - Menu Bar Only >
      - Spotlight > Don't Show in Menu Bar
    - Automatically hide and show the menu bar > Always
  - Desktop & Dock >
    - Show indicators for open applications > Off
    - Show suggested and recent apps in Dock > Off
  - Displays >
    - More Space
    - Automatically adjust brightness > Off
    - Night Shift >
      - Schedule > Sunset to Sunrise
      - Color temperature > More Warm
  - Apple Intelligence & Siri >
    - Apple Intelligence > Off
    - Siri > Off
  - Spotlight > Turn off All
  - Notifications > Turn off All
    - Allow notifications when the screen is locked > Off
  - Focus >
    - Share across devices > On
  - Screen Time >
    - Share across devices > On
  - Keyboard >
    - Keyboard Shortcuts >
      - Screenshots >
        - Save picture of screen as a file > Off
        - Copy picture of screen to the clipboard > Off
        - Save picture of selected area as file > Shift Command 3
        - Copy picture of selected area to clipboard > Shift Command 4
      - Spotlight >
        - Show Spotlight search > Off

- Finder Settings

  - General >
    - Show these items on the desktop > None
    - New Finder windows show > apham
  - Sidebar >
    - Favorites > AirDrop, Applications, Downloads, austin
    - Locations > apham's MacBook Air, External disks
  - Advanced >
    - Show warning before changing an extension > Off
    - Show warning before removing from iCloud Drive > Off

- Zen Settings

  - Sync via Mozilla
  - Keyboard Shortcuts
    - Toggle Compact Mode > Shift + Command + S
    - Take Screenshot > Not Set
  - about:config >
    - browser.tabs.allow_transparent_browser > false
    - zen.theme.content-element-separation = 0

- SelfControl Settings

  - [Add blocklist](https://www.refocusapp.co/articles/porn-sites-to-block)

## Audio Production

- Brew Install: [Ableton Suite 12](https://www.ableton.com/en/live/), [Soundtoys](https://www.soundtoys.com/), [iLok License Manger](https://www.ilok.com/#!license-manager)

- [UAD Software](https://help.uaudio.com/hc/en-us/articles/360057137692-Apple-Silicon-M1-M2-Compatibility-Info?_gl=1*1qpuawn*_ga*MTYzMjUzNzU0Ny4xNjgwMDI1NTUz*_ga_CPJ5176QFT*MTY4MDAyNTU2NC4xLjEuMTY4MDAyNTkwNy4wLjAuMA..)

- [Soothe2](https://oeksound.com/downloads/)

- [Splice (Serum 2 & RC2)](https://splice.com/plugins/your-plugins)

- [FabFilter](https://www.fabfilter.com/download)

- [Valhalla](https://valhalladsp.com/my-account/downloads/)

- [Spitfire](https://labs.spitfireaudio.com/download)

- [Route system sounds to Apollo Virtual Channels](https://www.youtube.com/watch?v=9K3D7kNb5DI): Audio MIDI Setup > Universal Audio Thunderbolt > Output > Configure Speakers > VIRTUAL 1/2 > Apply > Done

- Ableton Settings
  - Themes & Colors >
    - Theme > Immaterial
  - Plug-Ins >
    - Use Audio Units v2 / v3 > On
    - Use VST2 / VST3 Plug-In > Off

# Factory Reset

```shell
cd ~/.dotfiles && ./save.sh
```

- Save documents to SSD (`Pham`)

- Export `rayconfig` settings

- [System Settings](https://support.apple.com/en-us/102664) > General > Transfer or Reset > Erase All Content and Settings
