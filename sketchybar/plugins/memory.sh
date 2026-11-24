#!/bin/bash
source "$CONFIG_DIR/colors.sh"
FREE=$(memory_pressure | awk '/free percentage/ {print $5}' | tr -d '%')
USED=$((100 - ${FREE:-0}))
ICON_COLOR=${ENMA:-$MUTED}
[ "$USED" -gt 70 ] && ICON_COLOR=$WARN
[ "$USED" -gt 90 ] && ICON_COLOR=$DANGER
sketchybar --set "$NAME" label="${USED}%" icon=󰍛 icon.color=$ICON_COLOR
