#!/usr/bin/env bash
# Apply the Zoro look outside of plain dotfiles: macOS appearance, app icons,
# VS Code theme, Firefox chrome. Re-runnable.
#   bash scripts/rice.sh                 apply everything
#   bash scripts/rice.sh --reset-icons   put the stock app icons back
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"
[ "$(uname -s)" = "Darwin" ] || { err "macOS only"; exit 1; }

icon_tool() { # $1 = apply|reset
  swift - "$1" "$DOTFILES/icons" <<'SWIFT'
import AppKit
let mode = CommandLine.arguments[1], dir = CommandLine.arguments[2]
let files = (try? FileManager.default.contentsOfDirectory(atPath: dir))?.filter { $0.hasSuffix(".png") } ?? []
for f in files.sorted() {
  let name = String(f.dropLast(4)), app = "/Applications/\(name).app"
  guard FileManager.default.fileExists(atPath: app) else { continue }
  let img: NSImage? = mode == "apply" ? NSImage(contentsOfFile: "\(dir)/\(f)") : nil
  let ok = NSWorkspace.shared.setIcon(img, forFile: app, options: [])
  print("\(ok ? "ok  " : "FAIL") \(name)")
}
SWIFT
  killall Dock Finder 2>/dev/null || true
}

if [ "${1:-}" = "--reset-icons" ]; then
  hr "Restoring stock app icons"; icon_tool reset; exit 0
fi

hr "macOS appearance"
defaults write -g AppleInterfaceStyle -string "Dark"
defaults write -g AppleAccentColor -int 3                       # green
defaults write -g AppleHighlightColor -string "0.752941 0.964706 0.678431 Green"
defaults write -g _HIHideMenuBar -bool true                     # sketchybar replaces it
killall SystemUIServer Dock 2>/dev/null || true
ok "dark mode, green accent, menu bar auto-hidden (log out/in to fully apply)"

hr "App icons"
icon_tool apply

hr "Terminal.app (Apple)"
open -g "$DOTFILES/apple/Zoro.terminal"; sleep 2
defaults write com.apple.Terminal "Default Window Settings" -string "Zoro"
defaults write com.apple.Terminal "Startup Window Settings" -string "Zoro"
ok "Terminal.app profile 'Zoro' imported and set as default"

hr "VS Code"
mkdir -p "$HOME/.vscode/extensions"
ln -sfn "$DOTFILES/vscode/zoro-theme" "$HOME/.vscode/extensions/maarcus.zoro-theme-0.0.1"
VSC_USER="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSC_USER"
if [ -e "$VSC_USER/settings.json" ] && [ ! -L "$VSC_USER/settings.json" ]; then
  warn "VS Code settings.json already exists — merge $DOTFILES/vscode/settings.json by hand"
else
  ln -sfn "$DOTFILES/vscode/settings.json" "$VSC_USER/settings.json"
  ok "linked VS Code settings"
fi
