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

# Progress calculation
pos_sec=${tpos%.*}
dur_sec=${tdur%.*}
pos_sec=${pos_sec:-0}
dur_sec=${dur_sec:-1}

pos_min=$((pos_sec / 60))
pos_rem=$((pos_sec % 60))
printf -v pos_str "%d:%02d" $pos_min $pos_rem

dur_min=$((dur_sec / 60))
dur_rem=$((dur_sec % 60))
printf -v dur_str "%d:%02d" $dur_min $dur_rem

if [ "$dur_sec" -gt 0 ]; then
  pct=$((pos_sec * 100 / dur_sec))
else
  pct=0
fi

filled=$((pct * 12 / 100))
[ "$filled" -gt 12 ] && filled=12
[ "$filled" -lt 0 ] && filled=0
empty=$((12 - filled))

bar=""
for ((i=0; i<filled; i++)); do bar+="━"; done
bar+="●"
for ((i=0; i<empty; i++)); do bar+="─"; done

progress_str="$pos_str  $bar  $dur_str"

# Player state styling
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

# Update bar item and popup card items
sketchybar --set spotify drawing=on \
                         icon="$icon" \
                         icon.color="$icon_color" \
                         label="$bar_label" \
           --set spotify.cover background.image="$COVER_FILE" \
                               background.image.drawing=on \
                               background.drawing=on \
           --set spotify.title label="${tname:-No Title}" \
           --set spotify.artist label="${tartist:-Unknown Artist}" \
           --set spotify.album label="${talbum:-Unknown Album}" \
           --set spotify.progress label="$progress_str" \
           --set spotify.play icon="$play_icon" label="$play_label"
