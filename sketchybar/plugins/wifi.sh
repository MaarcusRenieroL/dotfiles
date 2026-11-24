#!/bin/bash
# The old `airport` tool is gone on recent macOS, so just report connectivity.
source "$CONFIG_DIR/colors.sh"
if route -n get default >/dev/null 2>&1; then
  sketchybar --set "$NAME" icon=󰤨 icon.color=$ACCENT label.drawing=off
else
  sketchybar --set "$NAME" icon=󰤮 icon.color=$DANGER label="offline" label.drawing=on
fi
