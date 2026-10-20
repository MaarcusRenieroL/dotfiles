#!/bin/bash
source "$CONFIG_DIR/colors.sh"

action="${1:-update}"

case "$action" in
  prev)
    osascript -e 'tell application "Spotify" to previous track' 2>/dev/null
    sleep 0.2
    ;;
  next)
    osascript -e 'tell application "Spotify" to next track' 2>/dev/null
    sleep 0.2
    ;;
  playpause)
    osascript -e 'tell application "Spotify" to playpause' 2>/dev/null
    sleep 0.2
    ;;
  popup)
    if [ "$SENDER" = "mouse.exited.global" ]; then
      sketchybar --set spotify popup.drawing=off
      exit 0
    fi
    sketchybar --set spotify popup.drawing=toggle
    ;;
esac

# Update Spotify state & labels
info=$(osascript -e '
if application "Spotify" is running then
  tell application "Spotify"
    return (player state as string) & "|" & (name of current track) & "|" & (artist of current track) & "|" & (album of current track)
  end tell
else
  return "stopped"
end if' 2>/dev/null)

if [ -z "$info" ] || [ "$info" = "stopped" ]; then
  sketchybar --set spotify drawing=off popup.drawing=off
  exit 0
fi

IFS='|' read -r pstate tname tartist talbum <<< "$info"

if [ "$pstate" = "playing" ]; then
  icon="󰓇"
  icon_color="$ACCENT"
  play_icon="󰏤"
  play_label="Pause"
else
  icon="󰓇"
  icon_color="$MUTED"
  play_icon="󰐊"
  play_label="Play"
fi

bar_label="${tartist:-Unknown} – ${tname:-Unknown}"

sketchybar --set spotify drawing=on \
                         icon="$icon" \
                         icon.color="$icon_color" \
                         label="$bar_label" \
           --set spotify.title label="${tname:-No Title}" \
           --set spotify.artist label="${tartist:-Unknown Artist}" \
           --set spotify.album label="${talbum:-Unknown Album}" \
           --set spotify.play icon="$play_icon" label="$play_label"
