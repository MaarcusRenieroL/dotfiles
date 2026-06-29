#!/usr/bin/env bash
# One-command bootstrap for a fresh (or existing) macOS machine.
# Idempotent — safe to run repeatedly.
#
#   ./install.sh            full setup (prompts before macOS defaults)
#   ./install.sh --macos    also apply macOS defaults without prompting
#   ./install.sh --no-macos skip macOS defaults entirely
#   ./install.sh --help
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES
# shellcheck source=scripts/lib.sh
source "$DOTFILES/scripts/lib.sh"

MACOS_MODE="prompt"   # prompt | yes | no
for arg in "$@"; do
  case "$arg" in
    --macos)    MACOS_MODE="yes" ;;
    --no-macos) MACOS_MODE="no" ;;
    --help|-h)
      grep '^#' "$0" | sed 's/^# \{0,1\}//; 1d'
      exit 0 ;;
    *) err "unknown flag: $arg"; exit 1 ;;
  esac
done

[ "$(uname -s)" = "Darwin" ] || { err "This setup targets macOS."; exit 1; }

# --- 1. Homebrew -------------------------------------------------------------
hr "Homebrew"
if ! have brew; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Ensure brew is on PATH for the rest of this script (Apple Silicon path).
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
ok "brew $(brew --version | head -1 | awk '{print $2}')"

# --- 2. Packages -------------------------------------------------------------
hr "Brew bundle"
brew bundle --file "$DOTFILES/brew/Brewfile"
ok "Brewfile satisfied."

# --- 3. oh-my-zsh + plugins --------------------------------------------------
hr "oh-my-zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing oh-my-zsh (unattended)..."
  RUNZSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
clone_plugin() {
  local repo="$1" dir="$ZSH_CUSTOM/plugins/$2"
  if [ -d "$dir" ]; then ok "plugin $2"; else git clone --depth=1 "$repo" "$dir" && ok "plugin $2"; fi
}
clone_plugin https://github.com/zsh-users/zsh-autosuggestions     zsh-autosuggestions
clone_plugin https://github.com/zsh-users/zsh-syntax-highlighting zsh-syntax-highlighting

# --- 4. tmux plugin manager --------------------------------------------------
hr "tmux (tpm)"
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
  ok "tpm installed"
else
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  ok "tpm installed (open tmux and press prefix + I to install plugins)"
fi

# --- 5. Symlinks -------------------------------------------------------------
bash "$DOTFILES/scripts/link.sh"

# --- 6. macOS defaults -------------------------------------------------------
hr "macOS defaults"
case "$MACOS_MODE" in
  yes) bash "$DOTFILES/scripts/macos.sh" ;;
  no)  info "Skipped (--no-macos)." ;;
  prompt)
    if confirm "Apply opinionated macOS defaults (keyboard, Finder, Dock)?"; then
      bash "$DOTFILES/scripts/macos.sh"
    else
      info "Skipped. Run later with: make macos"
    fi ;;
esac

# --- 7. Health check ---------------------------------------------------------
bash "$DOTFILES/scripts/doctor.sh" || true

hr "Done"
ok "Open a new terminal (or run: exec zsh) to load everything."
