#!/bin/bash
source "$CONFIG_DIR/colors.sh"
idx=$1

focused=$([ "$(yabai -m query --spaces --space 2>/dev/null | jq -r .index)" = "$idx" ] && echo true)
windows=$(yabai -m query --windows --space "$idx" 2>/dev/null | jq '[.[] | select(."is-hidden"==false and ."is-minimized"==false)] | length')

if [ "$focused" = "true" ]; then
  sketchybar --set "$NAME" icon.color=$BG background.color=$ACCENT background.drawing=on
elif [ "${windows:-0}" -gt 0 ]; then
  sketchybar --set "$NAME" icon.color=$FG background.color=$TRANSPARENT background.drawing=off
else
  sketchybar --set "$NAME" icon.color=$DIM background.color=$TRANSPARENT background.drawing=off
fi
