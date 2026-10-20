#!/bin/bash
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
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

# Query full Spotify metadata
IFS='@' read -r pstate tname tartist talbum tpos tdur tart < <(osascript -e '
if application "Spotify" is running then
  tell application "Spotify"
    set pstate to player state as string
    set tname to name of current track
    set tartist to artist of current track
    set talbum to album of current track
    set tpos to player position as string
    set tdur to ((duration of current track) / 1000) as string
    try
      set tart to artwork url of current track
    on error
      set tart to ""
    end try
    return pstate & "@" & tname & "@" & tartist & "@" & talbum & "@" & tpos & "@" & tdur & "@" & tart
  end tell
else
  return "stopped"
end if' 2>/dev/null)

if [ -z "$pstate" ] || [ "$pstate" = "stopped" ]; then
  sketchybar --set spotify drawing=off popup.drawing=off
  exit 0
fi

# Album Artwork
COVER_FILE="/tmp/spotify_cover.jpg"
URL_FILE="/tmp/spotify_cover_url"
if [ -n "$tart" ]; then
  cached_url=$(cat "$URL_FILE" 2>/dev/null || echo "")
  if [ "$tart" != "$cached_url" ] || [ ! -f "$COVER_FILE" ]; then
    curl -s "$tart" -o "$COVER_FILE" 2>/dev/null
    echo "$tart" > "$URL_FILE"
  fi
fi

# Player state icons
if [ "$pstate" = "playing" ]; then
  bar_icon="󰓇"
  bar_icon_color="$ACCENT"
  play_icon="󰏤"
else
  bar_icon="󰓇"
  bar_icon_color="$MUTED"
  play_icon="󰐊"
fi

bar_label="${tartist:-Unknown} – ${tname:-Unknown}"
popup_title="${tname:-No Track} • ${tartist:-Unknown}"

# Update bar item and popup horizontal player
sketchybar --set spotify drawing=on \
                         icon="$bar_icon" \
                         icon.color="$bar_icon_color" \
                         label="$bar_label" \
           --set spotify.cover background.image="$COVER_FILE" \
                               background.image.drawing=on \
                               background.drawing=on \
           --set spotify.title label="$popup_title" \
           --set spotify.play icon="$play_icon"
