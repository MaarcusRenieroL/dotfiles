#!/usr/bin/env bash
# ==============================================================================
# macOS System & UI Defaults
# Tailored for fast keyboard-driven workflow, Neovim, yabai, and Ghostty
# ==============================================================================

set -eo pipefail

echo "==> Configuring macOS system defaults..."

# Close any open System Settings panes to avoid overriding changes
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

# ------------------------------------------------------------------------------
# Keyboard & Input
# ------------------------------------------------------------------------------
echo "❯ Tuning keyboard repeat rate and disabling press-and-hold..."
# Fast key repeat rate (1 = 15ms) and short initial delay (10 = 150ms)
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Disable press-and-hold for accented keys (critical for Vim h/j/k/l navigation)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Disable automatic spelling correction and substitutions
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# ------------------------------------------------------------------------------
# Finder
# ------------------------------------------------------------------------------
echo "❯ Tuning Finder..."
# Show hidden files and all filename extensions
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show path bar at the bottom
defaults write com.apple.finder ShowPathbar -bool true

# Disable warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Use list view in all Finder windows by default (Nlsv, clmv, Flwv)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ------------------------------------------------------------------------------
# Dock & Mission Control
# ------------------------------------------------------------------------------
echo "❯ Tuning Dock & Mission Control..."
# Auto-hide dock instantly without delay
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15

# Do not show recent apps in Dock
defaults write com.apple.dock show-recents -bool false

# Do not automatically rearrange Spaces based on most recent use (vital for yabai/sketchybar)
defaults write com.apple.dock mru-spaces -bool false

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# ------------------------------------------------------------------------------
# Screenshots
# ------------------------------------------------------------------------------
echo "❯ Setting up screenshots directory..."
mkdir -p "${HOME}/Desktop/screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Desktop/screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# ------------------------------------------------------------------------------
# Restart Affected Services
# ------------------------------------------------------------------------------
echo "❯ Restarting Finder and Dock..."
killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true

echo "✓ macOS defaults applied successfully!"
echo "Note: Some changes (e.g., keyboard repeat) may require logging out or restarting."
