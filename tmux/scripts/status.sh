#!/usr/bin/env bash
# Status-right extras: git branch of the active pane, running containers, now playing.
# Usage: status.sh <pane_current_path>
dir="${1:-$PWD}"
accent="#[fg=#34d399]"; muted="#[fg=#8c99a8]"; violet="#[fg=#a78bfa]"; blue="#[fg=#60a5fa]"
out=""

branch=$(git -C "$dir" symbolic-ref --short HEAD 2>/dev/null || git -C "$dir" rev-parse --short HEAD 2>/dev/null)
[ -n "$branch" ] && out+="${violet} ${branch}${muted}  "

if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  n=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')
  [ "$n" != "0" ] && out+="${blue} ${n}${muted}  "
fi

track=$(osascript -e 'if application "Spotify" is running then tell application "Spotify" to if player state is playing then return (artist of current track) & " – " & (name of current track)' 2>/dev/null)
[ -n "$track" ] && out+="${accent}♪ ${track:0:36}${muted}  "

printf '%s' "$out"
