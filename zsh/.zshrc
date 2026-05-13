# default config directory
export XDG_CONFIG_HOME=~/dotfiles

# history
HISTSIZE=1000 # commands kept in current session memory
SAVEHIST=1000 # commands written to disk
HISTFILE=~/.zsh_history # file storing history

setopt HIST_IGNORE_DUPS # avoids duplicate spam
setopt SHARE_HISTORY # shares history across terminals

# completion
autoload -Uz compinit
compinit

# aliases
alias ls='ls -la'
alias v='nvim'

# starship
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init zsh)"

# pnpm
export PNPM_HOME="/Users/maarcusrenierol/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# scanforge
export PATH="/Users/maarcusrenierol/.scanforge/bin:$PATH"
