#!/bin/bash
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

app=$(yabai -m query --windows --window 2>/dev/null | jq -r '.app // empty')
if [ -z "$app" ]; then
  app="${INFO:-}"
fi
if [ -z "$app" ]; then
  app=$(osascript -e 'tell application "System Events" to name of first application process whose frontmost is true' 2>/dev/null)
fi

sketchybar --set "$NAME" label="${app:-Desktop}"
