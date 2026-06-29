#!/usr/bin/env bash
# Shared helpers for the install scripts. Source this; don't execute it.

DOTFILES="${DOTFILES:-$HOME/dotfiles}"

if [ -t 1 ]; then
  C_BOLD=$'\033[1m'; C_RED=$'\033[31m'; C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'; C_BLUE=$'\033[34m'; C_RESET=$'\033[0m'
else
  C_BOLD=''; C_RED=''; C_GREEN=''; C_YELLOW=''; C_BLUE=''; C_RESET=''
fi

info() { printf '%s %s\n' "${C_BLUE}::${C_RESET}" "$*"; }
ok()   { printf '%s %s\n' "${C_GREEN}✓${C_RESET}" "$*"; }
warn() { printf '%s %s\n' "${C_YELLOW}!${C_RESET}" "$*" >&2; }
err()  { printf '%s %s\n' "${C_RED}✗${C_RESET}" "$*" >&2; }
hr()   { printf '\n%s\n' "${C_BOLD}== $* ==${C_RESET}"; }

have() { command -v "$1" >/dev/null 2>&1; }

confirm() {
  # confirm "prompt" -> returns 0 on y/Y
  local reply
  printf '%s [y/N] ' "$1"
  read -r reply
  [[ "$reply" =~ ^[Yy]$ ]]
}

# link_file SRC DEST — create an idempotent symlink, backing up real files.
link_file() {
  local src="$1" dest="$2"
  if [ ! -e "$src" ]; then
    err "missing source: $src"
    return 1
  fi
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ]; then
    if [ "$(readlink "$dest")" = "$src" ]; then
      ok "ok: $dest"
      return 0
    fi
    rm "$dest"
  elif [ -e "$dest" ]; then
    mv "$dest" "${dest}.bak-$(date +%Y%m%d%H%M%S)"
    warn "backed up existing $dest"
  fi
  ln -s "$src" "$dest"
  ok "link: ${dest/#$HOME/~} -> ${src/#$HOME/~}"
}

# backup_if_real DEST — move a non-symlink file out of the way (for stow).
backup_if_real() {
  local dest="$1"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "${dest}.bak-$(date +%Y%m%d%H%M%S)"
    warn "backed up existing $dest"
  fi
}
