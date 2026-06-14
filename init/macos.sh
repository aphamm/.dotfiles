#!/usr/bin/env bash
# macOS system preferences

set -e

echo "==> Configuring macOS preferences..."

# Close System Preferences to prevent overriding
osascript -e 'tell application "System Preferences" to quit'

# Appearance: auto light/dark, green accent, scroll bars on scroll
defaults write -g AppleInterfaceStyleSwitchesAutomatically -bool true
defaults delete -g AppleInterfaceStyle 2>/dev/null || true
defaults write NSGlobalDomain AppleAccentColor -int 3
defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600 Green"
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

# Menu bar
defaults write NSGlobalDomain _HIHideMenuBar -bool true

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock static-only -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 24

# Sound: disable boot sound
sudo nvram SystemAudioVolume=" "

# Keyboard: disable auto-correct and smart punctuation
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Keyboard: fast key repeat
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Trackpad
defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool true
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 1.5
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0
defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 0

# Siri: disable
defaults write com.apple.assistant.support "Assistant Enabled" -bool false
defaults write com.apple.Siri StatusMenuVisible -bool false

# Finder
chflags nohidden ~/Library
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
defaults write com.apple.finder WarnOnEmptyTrash -bool false
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool false
defaults write com.apple.finder FXRemoveOldTrashItems -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false

# Screenshots
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# Other
defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
defaults write com.apple.LaunchServices LSQuarantine -bool false
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Bluetooth audio quality
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Max (editable)" 80
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" 80
defaults write com.apple.BluetoothAudioAgent "Apple Initial Bitpool (editable)" 80
defaults write com.apple.BluetoothAudioAgent "Apple Initial Bitpool Min (editable)" 80
defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool" 80
defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Max" 80
defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Min" 80

# Locale
defaults write NSGlobalDomain AppleLanguages -array "en"
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Inches"
defaults write NSGlobalDomain AppleMetricUnits -bool false

# Sleep/Power
sudo pmset -a lidwake 1
sudo pmset -a displaysleep 5
sudo pmset -b sleep 10
sudo pmset -c sleep 0
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
defaults write com.apple.ActivityMonitor ShowCategory -int 0
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# Apply changes to running apps (rest take effect on logout/restart)
killall Dock Finder SystemUIServer 2>/dev/null || true

echo "==> macOS preferences configured!"
echo "    Note: Some changes require logout/restart to take effect."
