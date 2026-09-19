#!/usr/bin/env bash
# Remove symlinks created by link.sh
set -euo pipefail

DOTFILES="${DOTFILES:=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
export DOTFILES
# shellcheck source=scripts/lib.sh
source "$DOTFILES/scripts/lib.sh"

# List of symlink targets to remove
symlinks=(
  "$HOME/.zshenv"
  "$HOME/.zshrc"
  "$HOME/.tmux.conf"
  "$HOME/.gitconfig"
  "$HOME/.gitignore_global"
  "$HOME/.wezterm.lua"
  "$HOME/.config/yabai/yabairc"
  "$HOME/.config/skhd/skhdrc"
  "$HOME/.config/borders/bordersrc"
)

for link in "${symlinks[@]}"; do
  if [ -L "$link" ]; then
    rm "$link"
    ok "removed $link"
  elif [ -e "$link" ]; then
    info "not a symlink (keeping): $link"
  fi
done
