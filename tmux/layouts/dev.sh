#!/usr/bin/env bash
# Spin up a dev layout in the current window:
#   ┌──────────────┬────────┐
#   │              │ shell  │
#   │     nvim     ├────────┤
#   │              │ server │
#   └──────────────┴────────┘
# A project can override this with an executable .tmux-layout.sh in its root.
dir="${1:-$PWD}"
cd "$dir" || exit 1

if [ -x "$dir/.tmux-layout.sh" ]; then exec "$dir/.tmux-layout.sh"; fi

server=""
if [ -f justfile ]; then server="just dev"
elif [ -f package.json ]; then server="pnpm dev"
elif [ -f pom.xml ]; then server="mvn spring-boot:run"
fi

tmux split-window -h -p 30 -c "$dir"
tmux split-window -v -p 50 -c "$dir"
[ -n "$server" ] && tmux send-keys "$server"   # typed, not run — Enter to start
tmux select-pane -t 1
tmux send-keys "nvim ." C-m
