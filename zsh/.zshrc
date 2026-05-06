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
