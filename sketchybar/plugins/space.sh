#!/bin/bash
# $1 = space index. Shows "<n> <name>"; the focused space also lists its open apps.
source "$CONFIG_DIR/colors.sh"
idx=$1

name=$(awk -F= -v i="$idx" '$1==i {print $2}' "$CONFIG_DIR/spaces.conf" 2>/dev/null)
name=${name:-space}

focused=$([ "$(yabai -m query --spaces --space 2>/dev/null | jq -r .index)" = "$idx" ] && echo true)
apps=$(yabai -m query --windows --space "$idx" 2>/dev/null |
  jq -r '[.[] | select(."is-hidden"==false and ."is-minimized"==false) | .app] | unique | join(", ")')

if [ "$focused" = "true" ]; then
  label="$name"; [ -n "$apps" ] && label="$name · $apps"
  sketchybar --set "$NAME" icon.color=$BG label="$label" label.color=$BG background.color=$ACCENT
elif [ -n "$apps" ]; then
  sketchybar --set "$NAME" icon.color=$MUTED label="$name" label.color=$MUTED background.color=$TRANSPARENT
else
  sketchybar --set "$NAME" icon.color=$DIM label="$name" label.color=$DIM background.color=$TRANSPARENT
fi
