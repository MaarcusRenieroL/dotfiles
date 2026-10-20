#!/usr/bin/env bash
# Build tiny launcher apps with the Zoro icons for Apple's built-in apps.
# macOS locks the real apps' icons, so these are stand-ins: pin the launchers in the Dock
# (instead of the originals) and they open the real app. Safe: nothing outside ~/Applications changes.
#   bash scripts/apple-launchers.sh            build/refresh launchers
#   bash scripts/apple-launchers.sh --remove   delete them
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
OUT="$HOME/Applications/Apple Launchers"

if [ "${1:-}" = "--remove" ]; then rm -rf "$OUT"; ok "removed $OUT"; exit 0; fi

[ -d "$DOTFILES/icons/apple/icns" ] || bash "$DOTFILES/icons/make-icns.sh"
mkdir -p "$OUT"
n=0
for icns in "$DOTFILES"/icons/apple/icns/*.icns; do
  name="$(basename "$icns" .icns)"
  if ! open -Ra "$name" 2>/dev/null; then warn "skip $name (app not found)"; continue; fi
  app="$OUT/$name.app"
  rm -rf "$app"
  osacompile -o "$app" -e "do shell script \"open -a '$name'\"" 2>/dev/null
  cp "$icns" "$app/Contents/Resources/applet.icns"
  # no Dock bounce / menu bar presence for the launcher itself
  plutil -insert LSUIElement -bool true "$app/Contents/Info.plist" 2>/dev/null || true
  rm -f "$app/Contents/Resources/Assets.car"
  codesign --force --deep --sign - "$app" >/dev/null 2>&1   # editing the plist invalidated the applet signature
  touch "$app"
  n=$((n+1))
done
ok "built $n launchers in $OUT"
