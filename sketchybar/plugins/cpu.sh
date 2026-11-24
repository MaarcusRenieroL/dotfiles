#!/bin/bash
source "$CONFIG_DIR/colors.sh"
CPU=$(ps -A -o %cpu | awk '{s+=$1} END {printf "%d", s/'"$(sysctl -n hw.ncpu)"'}')
ICON_COLOR=${GOLD:-$WARN}
[ "$CPU" -gt 60 ] && ICON_COLOR=$WARN
[ "$CPU" -gt 85 ] && ICON_COLOR=$DANGER
sketchybar --set "$NAME" label="${CPU}%" icon=󰻠 icon.color=$ICON_COLOR
