#!/usr/bin/env zsh

ICON_PADDING_RIGHT=5

case $INFO in
"Code")
    ICON_PADDING_RIGHT=4
    ICON=󰨞
    ;;
"Calendar" | "Notion Calendar")
    ICON_PADDING_RIGHT=3
    ICON=
    ;;
"Discord")
    ICON=
    ;;
"Finder")
    ICON=󰀶
    ;;
"WhatsApp")
    ICON_PADDING_RIGHT=3
    ICON=
    ;;
"Notion")
    ICON_PADDING_RIGHT=6
    ICON=󰎚
    ;;
"Preview")
    ICON_PADDING_RIGHT=3
    ICON=
    ;;
"Spotify")
    ICON_PADDING_RIGHT=2
    ICON=
    ;;
"TextEdit")
    ICON_PADDING_RIGHT=4
    ICON=
    ;;
"Ghostty")
    ICON_PADDING_RIGHT=4
    ICON=
    ;;
"Safari")
    ICON_PADDING_RIGHT=5
    ICON=󰖟
    ;;
"Firefox")
    ICON_PADDING_RIGHT=5
    ICON=󰈹
    ;;
"Mail")
    ICON_PADDING_RIGHT=4
    ICON=
    ;;
"Prime Video")
    ICON_PADDING_RIGHT=4
    ICON=󰐊
    ;;
"Simulator")
    ICON_PADDING_RIGHT=3
    ICON=
    ;;
"Insomnia")
    ICON_PADDING_RIGHT=3
    ICON=󰒓
    ;;
"Todoist")
    ICON_PADDING_RIGHT=3
    ICON=󰄴
    ;;
"IntelliJ IDEA")
    ICON_PADDING_RIGHT=4
    ICON=
    ;;
"WebStorm")
    ICON_PADDING_RIGHT=4
    ICON=
    ;;
"GitKraken")
    ICON_PADDING_RIGHT=4
    ICON=
    ;;
"LocalSend")
    ICON_PADDING_RIGHT=3
    ICON=󰄡
    ;;
"Microsoft Word")
    ICON_PADDING_RIGHT=4
    ICON=󰈬
    ;;
"Microsoft Excel")
    ICON_PADDING_RIGHT=4
    ICON=󰈛
    ;;
"Microsoft PowerPoint")
    ICON_PADDING_RIGHT=4
    ICON=󰈧
    ;;
"Docker")
    ICON_PADDING_RIGHT=3
    ICON=
    ;;
"Telegram")
    ICON_PADDING_RIGHT=3
    ICON=
    ;;
"OBS")
    ICON_PADDING_RIGHT=3
    ICON=
    ;;
"Wondershare Media Converter")
    ICON_PADDING_RIGHT=3
    ICON=󰕧
    ;;
*)
    ICON_PADDING_RIGHT=2
    ICON=
    ;;
esac

sketchybar --set $NAME icon=$ICON icon.padding_right=$ICON_PADDING_RIGHT
sketchybar --set $NAME.name label="$INFO"
