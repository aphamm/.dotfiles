# Dotfiles 📁

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
# install Command Line Tools
touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
CLT=$(softwareupdate -l | sed -n 's/.*Label: \(Command Line Tools.*\)/\1/p' | tail -1)
softwareupdate -i "$CLT" --verbose
rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress

# verify before cloning
xcode-select -p && git --version

# generate ssh key, start ssh-agent, add key to agent, copy to clipboard
ssh-keygen -t ed25519 -C "austinpham77@gmail.com" && \
  eval "$(ssh-agent -s)" && \
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519 && \
  pbcopy < ~/.ssh/id_ed25519.pub
```

Save ssh key to [GitHub](https://github.com/settings/keys) then...

```shell
git clone --recurse-submodules git@github.com:aphamm/.dotfiles.git ~/.dotfiles && \
  cd ~/.dotfiles && ./init.sh
```

# Manual Configs 🤮

- Retrieve documents from SSD (`Pham`)
- Import `rayconfig` settings with password `austinpham`

- System Preferences (not automatable via CLI)
  - Accessibility > Display >
    - Color > Red
    - Color Filter > On
    - Filter Type > Color Tint
    - Intensity > High
  - Control Center >
    - All Modules (Except Wi-Fi) > Don't Show in Menu Bar
    - Accessibility Shortcuts > Show in Control Center
    - Music Recognition > Show in Control Center
    - Spotlight > Don't Show in Menu Bar
  - Displays >
    - Arrange > External Display on Top
    - External Display > Use as > Main display
    - Automatically adjust brightness > Off
    - Night Shift > Sunset to Sunrise, More Warm
  - Spotlight > All Off
    - Help Apple Improve Search > Off
  - Notifications
    - Allow notifications when the screen is locked > Off
  - Focus > Share across devices > On
  - Screen Time > Share across devices > Off
  - Privacy & Security > Full Disk Access >
    - Terminal > On
  - Keyboard >
    - Press 🌐 key to > Do Nothing
    - Keyboard Shortcuts >
    - Screenshots >
      - Save picture of screen as a file > Off
      - Copy picture of screen to the clipboard > Off
      - Save picture of selected area as file > Shift Command 3
      - Copy picture of selected area to clipboard > Shift Command 4
    - Services > Text >
      - Convert Text to Simplified Chinese > Off
      - Convert Text to Traditional Chinese > Off
    - Spotlight >
      - Show Spotlight search > Off
      - Show Finder search window > Off

- Finder
  - General >
    - Show these items on the desktop > None
    - New Finder windows show > austin
  - Sidebar >
    - Favorites > AirDrop, Applications, Downloads, apham (home)
    - iCloud > iCloud Drive
    - Locations > austin's MacBook Air, External disks, Connected servers
    - Tags > None

- Apple Music >
  - General >
    - Library >
      - Download Dolby Atmos > On
      - Always check for available downloads > On
  - Playback
    - Crossfade > 12 seconds
    - Sound Enhancer > high
    - Sound Check > On
    - Loseless Audio
      - Enable Lossless Audio > On
      - Streaming + Download > Lossless
    - Spatial Audio > Dolby Atmos > Always On
  - Advanced >
    - Add songs to Library when adding to >
      - Playlist > On
      - Favorites > On
    - Automatically update artwork for imported songs > On

## Software

- [Terminal]
  - Profiles > Keyboard
    - Use option as Meta key > On
- [Helium](https://helium.computer)
- [Spokenly](https://apps.apple.com/us/app/spokenly-voice-to-text-ai-app/id6740315592)
  - General Settings
    - Launch at login > On
    - Show in Dock > Off
    - Show in Status Bar > Off
    - Use Escape to cancel recording > On
    - Microphone Priorty Settings > MacBook Air Microphone
    - Audio & Feedback > All Off
    - Local Whisper Configuration >
      - Language > English
      - Prompt > "No need to capitalize. Keep it casual."
    - Local-only mode > On
  - Dication Models > Local
    - Nvidia Parakeet Tdt 0.6B V2 (Best for English)
  - Keyboard Controls
    - Activation Keys > Toggle, Fn

## Music

- [Ableton Suite 12](https://ableton.centercode.com/project/home.html?cap=ea2ce822-bd02-401d-ba44-6c068717bc68)

- [UAD Software](https://help.uaudio.com/hc/en-us/articles/360057137692-Apple-Silicon-M1-M2-Compatibility-Info)

- [Soundtoys](https://accounts.soundtoys.com/#/licenses)

- [Soothe2](https://oeksound.com/downloads/)

- [Splice (Serum 2 & RC2)](https://splice.com/plugins/your-plugins)

- [Valhalla](https://valhalladsp.com/my-account/downloads/)

- [Route system sounds to Apollo Virtual Channels](https://www.youtube.com/watch?v=9K3D7kNb5DI): Audio MIDI Setup > Universal Audio Thunderbolt > Output > Configure Speakers > VIRTUAL 1/2 > Apply > Done

- Ableton Settings
  - Plug-Ins >
    - Use Audio Units v2 / v3 > On
    - Use VST2 / VST3 Plug-In > Off

## Privacy

Inspired by the following [post](https://karpathy.bearblog.dev/digital-hygiene/).

- Password Manager: [Apple Passwords](https://apps.apple.com/us/app/passwords/id6473799789)
- Search Engine: Google
  - [My Google Activity](https://myactivity.google.com/myactivity?hl=en) >
    - Web & App Activity > Turn Off & Delete
    - Timeline > Turn Off & Delete
    - YouTube History > Auto-delete 3 Months

# Preparing for a Factory Reset

```shell
cd ~/.dotfiles && just save   # refresh Brewfile, then commit + push
```

- Clear out `~/Documents` and `~/Downloads`

- Export `rayconfig` settings

- [System Settings](https://support.apple.com/en-us/102664) > General > Transfer or Reset > Erase All Content and Settings
