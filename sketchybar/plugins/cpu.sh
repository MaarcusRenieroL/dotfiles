#!/bin/bash
source "$CONFIG_DIR/colors.sh"
CPU=$(ps -A -o %cpu | awk '{s+=$1} END {printf "%d", s/'"$(sysctl -n hw.ncpu)"'}')
COLOR=$MUTED; [ "$CPU" -gt 60 ] && COLOR=$WARN; [ "$CPU" -gt 85 ] && COLOR=$DANGER
sketchybar --set "$NAME" label="${CPU}%" icon.color=$COLOR
