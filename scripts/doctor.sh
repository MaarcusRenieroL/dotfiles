#!/usr/bin/env bash
# Health check for the dotfiles setup. Read-only — changes nothing.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

FAILS=0
WARNS=0

pass() { ok "$*"; }
fail() { err "$*"; FAILS=$((FAILS + 1)); }
soft() { warn "$*"; WARNS=$((WARNS + 1)); }

check_cmd() { have "$1" && pass "$1 installed" || fail "$1 missing (brew bundle)"; }

# Pass if DEST is a symlink resolving to SRC (handles relative stow links).
check_link() {
  local src="$1" dest="$2"
  if [ -L "$dest" ] && [ "$dest" -ef "$src" ]; then
    pass "link ${dest/#$HOME/~}"
  elif [ -e "$dest" ]; then
    fail "link ${dest/#$HOME/~} does not point at ${src/#$HOME/~}"
  else
    fail "missing link ${dest/#$HOME/~}"
  fi
}

hr "Tooling"
for c in git nvim tmux starship zoxide fzf eza fd bat delta lazygit stow gh node pnpm; do
  check_cmd "$c"
done
for c in yabai skhd borders; do
  have "$c" && pass "$c installed" || soft "$c missing (macOS WM, optional)"
done

hr "Home symlinks (stow)"
check_link "$DOTFILES/zsh/.zshenv"          "$HOME/.zshenv"
check_link "$DOTFILES/zsh/.zshrc"           "$HOME/.zshrc"
check_link "$DOTFILES/tmux/.tmux.conf"      "$HOME/.tmux.conf"
check_link "$DOTFILES/git/.gitconfig"       "$HOME/.gitconfig"
check_link "$DOTFILES/git/.gitignore_global" "$HOME/.gitignore_global"
check_link "$DOTFILES/wezterm/.wezterm.lua" "$HOME/.wezterm.lua"

hr "Service configs (~/.config)"
check_link "$DOTFILES/yabai/yabairc"     "$HOME/.config/yabai/yabairc"
check_link "$DOTFILES/skhd/skhdrc"       "$HOME/.config/skhd/skhdrc"
check_link "$DOTFILES/borders/bordersrc" "$HOME/.config/borders/bordersrc"

hr "Shell environment"
[ "${XDG_CONFIG_HOME:-}" = "$DOTFILES" ] \
  && pass "XDG_CONFIG_HOME=$DOTFILES" \
  || soft "XDG_CONFIG_HOME not set to $DOTFILES (open a new shell after install)"
[ -d "$HOME/.oh-my-zsh" ] && pass "oh-my-zsh installed" || fail "oh-my-zsh missing"
for p in zsh-autosuggestions zsh-syntax-highlighting; do
  [ -d "$HOME/.oh-my-zsh/custom/plugins/$p" ] && pass "omz plugin $p" || fail "omz plugin $p missing"
done

hr "Git / delta"
if git config --get-regexp '^delta\.catppuccin-mocha\.' >/dev/null 2>&1; then
  pass "delta theme 'catppuccin-mocha' resolves"
else
  fail "delta theme 'catppuccin-mocha' not found (git include broken)"
fi

hr "Fonts"
if ls ~/Library/Fonts/JetBrainsMono* >/dev/null 2>&1 \
   || system_profiler SPFontsDataType 2>/dev/null | grep -qi "JetBrains Mono"; then
  pass "JetBrains Mono present"
else
  soft "JetBrains Mono not found (brew bundle installs the cask)"
fi

hr "Summary"
if [ "$FAILS" -eq 0 ]; then
  ok "All critical checks passed (${WARNS} warning(s))."
else
  err "${FAILS} failure(s), ${WARNS} warning(s). Re-run 'make install' to fix links/tools."
  exit 1
fi
