#!/usr/bin/env bash
# One-command uninstall for dotfiles setup.
# Reverses what install.sh did.
#
#   ./uninstall.sh            remove dotfiles (keeps Homebrew packages)
#   ./uninstall.sh --brew     also remove Homebrew packages
#   ./uninstall.sh --help
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES
# shellcheck source=scripts/lib.sh
source "$DOTFILES/scripts/lib.sh"

BREW_MODE="no"   # yes | no
for arg in "$@"; do
  case "$arg" in
    --brew)     BREW_MODE="yes" ;;
    --help|-h)
      grep '^#' "$0" | sed 's/^# \{0,1\}//; 1d'
      exit 0 ;;
    *) err "unknown flag: $arg"; exit 1 ;;
  esac
done

[ "$(uname -s)" = "Darwin" ] || { err "This setup targets macOS."; exit 1; }

# --- 1. Remove Symlinks --------------------------------------------------
hr "Removing symlinks"
bash "$DOTFILES/scripts/unlink.sh" || true
ok "Symlinks removed."

# --- 2. Remove oh-my-zsh and plugins ------------------------------------
hr "Removing oh-my-zsh"
if [ -d "$HOME/.oh-my-zsh" ]; then
  info "Removing oh-my-zsh..."
  rm -rf "$HOME/.oh-my-zsh"
  ok "oh-my-zsh removed."
else
  ok "oh-my-zsh not found."
fi

# --- 3. Remove tmux plugin manager ----------------------------------------
hr "Removing tmux (tpm)"
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
  info "Removing tpm..."
  rm -rf "$HOME/.tmux/plugins/tpm"
  ok "tpm removed."
else
  ok "tpm not found."
fi

# --- 4. Remove Homebrew packages (optional) --------------------------------
hr "Homebrew packages"
if [ "$BREW_MODE" = "yes" ]; then
  if confirm "Remove all Homebrew packages from Brewfile?"; then
    info "Removing packages..."
    brew bundle --file "$DOTFILES/brew/Brewfile" --no-lock --cleanup --force
    ok "Homebrew packages removed."
  fi
else
  info "Skipped (use --brew to remove packages)."
fi

hr "Done"
ok "Dotfiles uninstalled. Run: exec zsh"
