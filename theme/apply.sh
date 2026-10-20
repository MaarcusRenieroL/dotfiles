#!/usr/bin/env bash
# Regenerate every themed config from theme/palette.env, then reload what's running.
set -euo pipefail
DOTFILES="${DOTFILES:-$HOME/dotfiles}"
python3 -I "$DOTFILES/theme/apply.py"

command -v sketchybar >/dev/null && sketchybar --reload 2>/dev/null || true
command -v tmux >/dev/null && tmux source-file ~/.tmux.conf 2>/dev/null || true
pgrep -x borders >/dev/null && { pkill borders; (bash "$DOTFILES/borders/bordersrc" >/dev/null 2>&1 &); } || true
echo "done — restart Ghostty/nvim/new shells to pick up the new colours"
