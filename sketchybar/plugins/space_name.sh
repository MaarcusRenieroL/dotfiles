#!/bin/bash
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

sid=$(yabai -m query --spaces --space 2>/dev/null | jq -r .index 2>/dev/null)
sid=${sid:-1}

name=$(awk -F= -v i="$sid" '$1==i {print $2}' "$CONFIG_DIR/spaces.conf" 2>/dev/null)
name=${name:-"space $sid"}

sketchybar --set "$NAME" label="$name"
