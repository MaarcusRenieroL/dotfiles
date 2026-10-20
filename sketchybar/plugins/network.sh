#!/bin/bash
source "$CONFIG_DIR/colors.sh"

CACHE="/tmp/sketchybar_net"
IFACE=$(route -n get default 2>/dev/null | awk '/interface:/ {print $2}')
IFACE=${IFACE:-en0}

read -r in_bytes out_bytes < <(netstat -I "$IFACE" -b 2>/dev/null | awk 'NR>1 {i+=$7; o+=$10} END {print i, o}')
now=$(date +%s)

if [ -f "$CACHE" ]; then
  read -r prev_time prev_in prev_out < "$CACHE"
  dt=$((now - prev_time))
  if [ "$dt" -gt 0 ]; then
    down_rate=$(( (in_bytes - prev_in) / dt ))
    up_rate=$(( (out_bytes - prev_out) / dt ))
  else
    down_rate=0
    up_rate=0
  fi
else
  down_rate=0
  up_rate=0
fi

echo "$now $in_bytes $out_bytes" > "$CACHE"

format_speed() {
  local bytes=$1
  if [ "$bytes" -ge 1048576 ]; then
    printf "%.1fM" "$(echo "scale=1; $bytes/1048576" | bc 2>/dev/null || echo "$((bytes/1048576))")"
  elif [ "$bytes" -ge 1024 ]; then
    printf "%dK" "$(( bytes / 1024 ))"
  else
    printf "%dB" "$bytes"
  fi
}

down_str=$(format_speed "$down_rate")
up_str=$(format_speed "$up_rate")

sketchybar --set "$NAME" icon=󰛳 icon.color=$ACCENT label="↓$down_str ↑$up_str"
