#!/bin/bash
# Now playing — hidden unless Spotify is actively playing.
track=$(osascript -e 'if application "Spotify" is running then tell application "Spotify" to if player state is playing then return (artist of current track) & " – " & (name of current track)' 2>/dev/null)
if [ -n "$track" ]; then sketchybar --set "$NAME" drawing=on label="$track"; else sketchybar --set "$NAME" drawing=off; fi
