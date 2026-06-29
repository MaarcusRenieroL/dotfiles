# ~/.zshenv — sourced by EVERY zsh (login, interactive, scripts).
# Keep this limited to environment + PATH so non-interactive shells and
# tools that read XDG_CONFIG_HOME behave consistently.

# --- Dotfiles location -------------------------------------------------------
export DOTFILES="$HOME/dotfiles"

# Most CLI/TUI apps read their config from here (nvim, starship, lazygit,
# neofetch, borders, ...). See README for the linking model.
export XDG_CONFIG_HOME="$DOTFILES"
export ZSH_CONFIG="$DOTFILES/zsh"

# --- Core programs -----------------------------------------------------------
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less -FRX"

export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export ZSH="$HOME/.oh-my-zsh"

# --- fzf ---------------------------------------------------------------------
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
  export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude .git"
else
  export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/.git/*'"
  export FZF_ALT_C_COMMAND="find . -type d -not -path '*/.git/*'"
fi
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# --- PATH --------------------------------------------------------------------
# path_prepend <dir> : add to front of PATH once, only if it exists.
path_prepend() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) [ -d "$1" ] && export PATH="$1:$PATH" ;;
  esac
}

export PNPM_HOME="$HOME/Library/pnpm"
path_prepend "$PNPM_HOME"
path_prepend "$HOME/.scanforge/bin"
path_prepend "/opt/homebrew/opt/node@24/bin"

# --- Machine-local overrides (never committed) -------------------------------
[ -f "$ZSH_CONFIG/local.zsh" ] && source "$ZSH_CONFIG/local.zsh"
