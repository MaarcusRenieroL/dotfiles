#!/usr/bin/env bash
# Create all symlinks. Idempotent — safe to re-run.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

hr "Linking dotfiles"

# 1) Home-directory dotfiles via GNU stow.
#    Each package's .stow-local-ignore keeps non-$HOME files (themes, modules)
#    from leaking into $HOME.
HOME_PACKAGES=(zsh tmux git wezterm)

# Files stow will place in $HOME — back up any real (non-symlink) versions
# first so stow never aborts on a conflict.
HOME_TARGETS=(
  "$HOME/.zshenv" "$HOME/.zshrc"
  "$HOME/.tmux.conf"
  "$HOME/.gitconfig" "$HOME/.gitignore_global"
  "$HOME/.wezterm.lua"
)
for t in "${HOME_TARGETS[@]}"; do backup_if_real "$t"; done

if have stow; then
  stow --dir "$DOTFILES" --target "$HOME" --restow "${HOME_PACKAGES[@]}"
  ok "stowed: ${HOME_PACKAGES[*]}"
else
  err "stow not found — run 'brew bundle' first (or 'make brew')"
  exit 1
fi

# 2) launchd services (yabai/skhd/borders) can't see the shell's
#    XDG_CONFIG_HOME, so link their configs into the real ~/.config.
link_file "$DOTFILES/yabai/yabairc"     "$HOME/.config/yabai/yabairc"
link_file "$DOTFILES/skhd/skhdrc"       "$HOME/.config/skhd/skhdrc"
link_file "$DOTFILES/borders/bordersrc" "$HOME/.config/borders/bordersrc"

# Ghostty is a GUI app too — it can't see the shell's XDG_CONFIG_HOME, so link
# its config into the real ~/.config (where it falls back to looking).
link_file "$DOTFILES/ghostty/config" "$HOME/.config/ghostty/config"

# 3) Everything else (nvim, starship, lazygit, neofetch) is read in place
#    from $DOTFILES via XDG_CONFIG_HOME, which ~/.zshenv exports. No links needed.

ok "Linking complete."
