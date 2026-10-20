#!/bin/bash
source "$CONFIG_DIR/colors.sh"

w=$(yabai -m query --windows --window 2>/dev/null)
title=$(echo "$w" | jq -r '.title // empty')
app=$(echo "$w" | jq -r '.app // empty')

if [ -n "$title" ]; then
  label="$title"
elif [ -n "$app" ]; then
  label="$app"
else
  label="${INFO:-Desktop}"
fi

sketchybar --set "$NAME" label="$label" drawing=on
