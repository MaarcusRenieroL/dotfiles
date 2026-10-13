#!/bin/bash
source "$CONFIG_DIR/colors.sh"
if [ "$1" = "cycle" ]; then
  case "$(yabai -m query --spaces --space | jq -r .type)" in
    bsp) yabai -m space --layout stack ;;
    stack) yabai -m space --layout float ;;
    *) yabai -m space --layout bsp ;;
  esac
fi
case "$(yabai -m query --spaces --space | jq -r .type)" in
  bsp)   ICON=󰙀; LABEL=bsp ;;
  stack) ICON=󰓩; LABEL=stack ;;
  *)     ICON=󰖲; LABEL=float ;;
esac
sketchybar --set layout icon="$ICON" label="$LABEL"
