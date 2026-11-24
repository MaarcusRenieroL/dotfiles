#!/usr/bin/env bash
# Toggle a floating drop-down terminal running a persistent tmux session "scratch".
# The window is found by its title; yabai rule (yabairc) keeps it floating/sticky.
TITLE="scratchpad"
id=$(yabai -m query --windows | jq -r --arg t "$TITLE" '.[] | select(.title==$t) | .id' | head -1)

if [ -z "$id" ]; then
  open -na Ghostty --args --title="$TITLE" -e /opt/homebrew/bin/tmux new-session -As scratch
  exit 0
fi

if [ "$(yabai -m query --windows --window "$id" | jq '."has-focus"')" = "true" ]; then
  yabai -m window "$id" --minimize
else
  yabai -m window "$id" --deminimize 2>/dev/null
  yabai -m window "$id" --focus
fi
