#!/usr/bin/env zsh

# Get the current space index
SPACE_INDEX=$(yabai -m query --spaces --space | jq '.index')

# Get frontmost window/app details
FRONT_APP_INFO=$(yabai -m query --windows --window)
FRONT_APP=$(echo "$FRONT_APP_INFO" | jq -r '.app')
IS_FULLSCREEN=$(echo "$FRONT_APP_INFO" | jq '.["has-fullscreen-zoom"] or .["has-fullscreen"]')

# Default app label
APP_LABEL=""

# Only show app name if it's not fullscreen
if [[ "$IS_FULLSCREEN" == "false" || "$IS_FULLSCREEN" == "null" ]]; then
  APP_LABEL=" • $FRONT_APP"
fi

# Map space index to icon and label
case $SPACE_INDEX in
  1)
    ICON="🌐"
    LABEL="Browsing"
    ;;
  2)
    ICON=""
    LABEL="Dev"
    ;;
  3)
    ICON="🧪"
    LABEL="Testing"
    ;;
  4)
    ICON=""
    LABEL="Social"
    ;;
  *)
    ICON=""
    LABEL="Unknown"
    ;;
esac

# Set in sketchybar
sketchybar --set "$NAME" \
    icon="$ICON" \
    label="$LABEL" \
    icon.padding_left=6 \
    icon.padding_right=6 \
    label.padding_left=5 \
    label.padding_right=10
