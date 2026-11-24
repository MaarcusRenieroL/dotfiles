# dotfiles default location
export DOTFILES="$HOME/dotfiles"

# config locations
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export ZSH_CONFIG="$DOTFILES/zsh"

# Homebrew environment
if [ -x "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x "/usr/local/bin/brew" ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# editors and programs
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less -FRX"

export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship.toml"
export LG_CONFIG_FILE="$XDG_CONFIG_HOME/lazygit/config.yml,$XDG_CONFIG_HOME/lazygit/theme.yml"
export BAT_CONFIG_PATH="$XDG_CONFIG_HOME/bat/config"
export RIPGREP_CONFIG_PATH="$DOTFILES/ripgrep/ripgreprc"
[ -d "$HOME/.oh-my-zsh" ] && export ZSH="$HOME/.oh-my-zsh"

# fzf
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
  export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude .git"
else
  export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/.git/*'"
  export FZF_ALT_C_COMMAND="find . -type d -not -path '*/.git/*'"
fi
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS=" \
--color=bg+:#1e3a29,bg:#0d120e,spinner:#4ade80,hl:#22c55e \
--color=fg:#e2ece4,header:#22c55e,info:#eab308,pointer:#4ade80 \
--color=marker:#4ade80,fg+:#f0fdf4,prompt:#4ade80,hl+:#4ade80 \
--border=rounded --prompt='❯ ' --pointer='▶' --marker='✓'"

# path
path_prepend() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) [ -d "$1" ] && export PATH="$1:$PATH" ;;
  esac
}

export PNPM_HOME="$HOME/Library/pnpm"
path_prepend "$PNPM_HOME/bin"
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.scanforge/bin"
path_prepend "/opt/homebrew/opt/node@24/bin"

# java
if [ -d "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home" ]; then
  export JAVA_HOME="/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
  path_prepend "$JAVA_HOME/bin"
fi

[ -f "$ZSH_CONFIG/local.zsh" ] && source "$ZSH_CONFIG/local.zsh"
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
