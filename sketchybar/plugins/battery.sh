#!/bin/bash
source "$CONFIG_DIR/colors.sh"
INFO=$(pmset -g batt)
PCT=$(echo "$INFO" | grep -o '[0-9]*%' | head -1 | tr -d '%')
[ -z "$PCT" ] && { sketchybar --set "$NAME" drawing=off; exit 0; }
if echo "$INFO" | grep -q 'AC Power'; then ICON=󰂄; COLOR=$ACCENT
elif [ "$PCT" -gt 80 ]; then ICON=󰁹; COLOR=$MUTED
elif [ "$PCT" -gt 50 ]; then ICON=󰂀; COLOR=$MUTED
elif [ "$PCT" -gt 20 ]; then ICON=󰁼; COLOR=$WARN
else ICON=󰁺; COLOR=$DANGER; fi
sketchybar --set "$NAME" drawing=on icon="$ICON" icon.color=$COLOR label="${PCT}%"
