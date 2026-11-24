#!/usr/bin/env bash
# Status-right extras: git branch of the active pane, running containers.
# Usage: status.sh <pane_current_path>
dir="${1:-$PWD}"
out=""

branch=$(git -C "$dir" symbolic-ref --short HEAD 2>/dev/null || git -C "$dir" rev-parse --short HEAD 2>/dev/null)
if [ -n "$branch" ]; then
  out+="#[fg=#1e2833]#[bg=default]#[fg=#a78bfa]#[bg=#1e2833]#[bold] ${branch}#[fg=#1e2833]#[bg=default] "
fi

if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  n=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')
  if [ -n "$n" ] && [ "$n" != "0" ]; then
    out+="#[fg=#1e2833]#[bg=default]#[fg=#38bdf8]#[bg=#1e2833]#[bold]󰡨 ${n}#[fg=#1e2833]#[bg=default] "
  fi
fi

printf '%s' "$out"
