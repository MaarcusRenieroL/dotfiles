#!/usr/bin/env bash
# Opinionated, reversible macOS defaults. Re-runnable.
# Run directly: bash scripts/macos.sh   (or via: make macos)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

[ "$(uname -s)" = "Darwin" ] || { err "macOS only"; exit 1; }

hr "Applying macOS defaults"

# Keyboard: fast key repeat + disable press-and-hold so holding a key repeats
# (important for vim motions).
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2
defaults write -g ApplePressAndHoldEnabled -bool false

# Disable "natural" scrolling.
defaults write -g com.apple.swipescrolldirection -bool false

# Finder: show extensions, hidden files, path + status bars, no .DS_Store on
# network/USB volumes, search current folder, list view by default.
defaults write -g AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Screenshots: PNG into ~/Screenshots, no drop shadow.
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# Dock: autohide fast, no recent apps, snappier Mission Control.
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15
defaults write com.apple.dock show-recents -bool false

# Save/print panels expanded by default.
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g PMPrintingExpandedStateForPrint -bool true

# Faster window resize animations.
defaults write -g NSWindowResizeTime -float 0.001

killall Finder Dock SystemUIServer 2>/dev/null || true

ok "macOS defaults applied (some changes need a logout/restart)."
