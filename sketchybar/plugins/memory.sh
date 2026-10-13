#!/bin/bash
source "$CONFIG_DIR/colors.sh"
FREE=$(memory_pressure | awk '/free percentage/ {print $5}' | tr -d '%')
USED=$((100 - ${FREE:-0}))
COLOR=$MUTED; [ "$USED" -gt 70 ] && COLOR=$WARN; [ "$USED" -gt 90 ] && COLOR=$DANGER
sketchybar --set "$NAME" label="${USED}%" icon.color=$COLOR
