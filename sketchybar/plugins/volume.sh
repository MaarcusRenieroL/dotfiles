#!/bin/bash
source "$CONFIG_DIR/colors.sh"
VOL=${INFO:-$(osascript -e 'output volume of (get volume settings)')}
if [ "$VOL" = "0" ] || [ "$VOL" = "missing value" ]; then ICON=󰝟; COLOR=$DANGER; else
  COLOR=$MUTED
  if [ "$VOL" -lt 30 ]; then ICON=󰕿; elif [ "$VOL" -lt 70 ]; then ICON=󰖀; else ICON=󰕾; fi
fi
sketchybar --set "$NAME" icon="$ICON" icon.color=$COLOR label="${VOL}%"
