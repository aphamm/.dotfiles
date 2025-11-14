Dotfiles are configuration files for programs - maintaining versioning, reproducibility, and clarity about what’s truly indispensable. Why not write one for the most important game we play every single day: life. Given the law of cosmic mean reversion, if I were to respawn tommorow here is my [minimal generating set](https://math.stackexchange.com/questions/3089880/minimal-generating-set) for life - the indispensable programmable elements able to span the state space of my desired reality. This is an evergreen endeavor.

# Physical Dotfiles

- Technology
  - MacBook Air 2025 (M4)
  - iPhone 17
  - AirPods Pro 2
  - SSD

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
    - Options >
      - Prevent automatic sleeping on power adapter when the display is off > On
      - Optimize video streaming while on battery > On
  - Control Center >
    - All Control Center Modules (Except for Wi-Fi) > Don't Show in Menu Bar
    - Accessibility Shortcuts > Show in Control Center
    - Battery >
      - Show Percentage > On
    - Music Recognition > Show in Control Center
    - Menu Bar Only >
      - Spotlight > Don't Show in Menu Bar
  - Displays >
    - Automatically adjust brightness > Off
    - Night Shift >
      - Schedule > 6PM to 6AM
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
        - Show Finder search window > Off

- Finder Settings

  - General >
    - Show these items on the desktop > None
    - New Finder windows show > pham
  - Sidebar >
    - Favorites > AirDrop, Applications, Downloads, austin
    - iCloud > iCloud Drive
    - Locations > pham's MacBook Air, External disks
  - Advanced >
    - Show warning before removing from iCloud Drive > Off
    - Remove items from the Trash after 30 days > On

- Flux Settings

  - Sunset > 2700K (Tungsten)
  - Bedtime > 1200K
  - 4:00AM is when I wake up

## Software

- [Ableton Suite 12](https://ableton.centercode.com/project/home.html?cap=ea2ce822-bd02-401d-ba44-6c068717bc68)

- [UAD Software](https://help.uaudio.com/hc/en-us/articles/360057137692-Apple-Silicon-M1-M2-Compatibility-Info?_gl=1*1qpuawn*_ga*MTYzMjUzNzU0Ny4xNjgwMDI1NTUz*_ga_CPJ5176QFT*MTY4MDAyNTU2NC4xLjEuMTY4MDAyNTkwNy4wLjAuMA..)

- [Soundtoys](https://accounts.soundtoys.com/#/licenses)

- [Soothe2](https://oeksound.com/downloads/)

- [Splice (Serum 2 & RC2)](https://splice.com/plugins/your-plugins)

- [Valhalla](https://valhalladsp.com/my-account/downloads/)

- [Route system sounds to Apollo Virtual Channels](https://www.youtube.com/watch?v=9K3D7kNb5DI): Audio MIDI Setup > Universal Audio Thunderbolt > Output > Configure Speakers > VIRTUAL 1/2 > Apply > Done

- Ableton Settings
  - Plug-Ins >
    - Use Audio Units v2 / v3 > On
    - Use VST2 / VST3 Plug-In > Off

- [Davinci Resolve](https://apps.cloud.blackmagicdesign.com/davinci-resolve)

## Privacy
Inspired by the following [post](https://karpathy.bearblog.dev/digital-hygiene/).

- Password Manager: [Apple Passwords](https://apps.apple.com/us/app/passwords/id6473799789)
- Search Engine: Google
  - [My Google Activity](https://myactivity.google.com/myactivity?hl=en) >
    - Web & App Activity > Turn Off & Delete
    - Timeline > Turn Off & Delte
    - YouTube History > Auto-delete 3 Months

# Preparing for a Factory Reset

```shell
cd ~/.dotfiles && ./save.sh
```

- Save documents to SSD (`Pham`)

- Export `rayconfig` settings

- [System Settings](https://support.apple.com/en-us/102664) > General > Transfer or Reset > Erase All Content and Settings
