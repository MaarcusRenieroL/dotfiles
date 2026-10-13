#!/bin/bash
# Focused window title (falls back to the app name)
source "$CONFIG_DIR/colors.sh"
w=$(yabai -m query --windows --window 2>/dev/null)
app=$(echo "$w" | jq -r '.app // empty')
title=$(echo "$w" | jq -r '.title // empty')
if [ -z "$app" ]; then app="${INFO:-}"; fi
# the focused space's pill already names the app, so show just the window title
label="${title:-$app}"
sketchybar --set "$NAME" label="$label"

# Hide the title if it would run under the notch (14" MacBook Pro notch starts ~x=660).
NOTCH_LEFT="${NOTCH_LEFT:-640}"
right=$(sketchybar --query "$NAME" | jq -r '.bounding_rects | to_entries[0].value | (.origin[0] + .size[0])' 2>/dev/null)
if [ -n "$right" ] && [ "${right%.*}" -gt "$NOTCH_LEFT" ]; then
  sketchybar --set "$NAME" drawing=off
else
  sketchybar --set "$NAME" drawing=on
fi
