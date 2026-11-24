#!/bin/bash
# Click handler: toggle <item>'s popup and fill it with fresh data.
# Also closes popups on mouse.exited.global (items subscribe in sketchybarrc).
item="$1"
if [ "$SENDER" = "mouse.exited.global" ]; then sketchybar --set "$item" popup.drawing=off; exit 0; fi

case "$item" in
  clock)
    sketchybar --set clock.date label="$(date '+%A, %d %B %Y')" \
               --set clock.week label="week $(date +%V) · day $(date +%j)" \
               --set clock.up label="up $(uptime | sed -E 's/.*up ([^,]*(, [0-9]+:[0-9]+)?),.*/\1/' | sed 's/,//')" ;;
  battery)
    t=$(pmset -g batt | grep -o '[0-9]*:[0-9]* remaining' || echo "no estimate")
    c=$(ioreg -rn AppleSmartBattery | awk '/"CycleCount"/ {print $3}')
    sketchybar --set battery.time label="$t" --set battery.cycles label="${c:-?} cycles" ;;
  wifi)
    ip=$(ipconfig getifaddr en0 2>/dev/null || echo "no ip")
    gw=$(route -n get default 2>/dev/null | awk '/gateway/ {print $2}')
    sketchybar --set wifi.ip label="ip  $ip" --set wifi.gw label="gw  ${gw:-none}" ;;
esac
sketchybar --set "$item" popup.drawing=toggle
