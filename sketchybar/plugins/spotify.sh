#!/bin/bash
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

# Query current Spotify playback info
IFS='@' read -r pstate tname tartist < <(osascript -e '
if application "Spotify" is running then
  tell application "Spotify"
    set pstate to player state as string
    set tname to name of current track
    set tartist to artist of current track
    return pstate & "@" & tname & "@" & tartist
  end tell
else
  return "stopped"
end if' 2>/dev/null)

if [ -z "$pstate" ] || [ "$pstate" = "stopped" ]; then
  sketchybar --set spotify drawing=off
  exit 0
fi

if [ "$pstate" = "playing" ]; then
  bar_icon="󰓇"
  bar_icon_color="$ACCENT"
else
  bar_icon="󰓇"
  bar_icon_color="$MUTED"
fi

bar_label="${tartist:-Unknown} – ${tname:-Unknown}"

sketchybar --set spotify drawing=on \
                         icon="$bar_icon" \
                         icon.color="$bar_icon_color" \
                         label="$bar_label"
