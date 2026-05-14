# default config directory
export XDG_CONFIG_HOME=~/dotfiles
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

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
alias e='exit'
alias cd='z'
alias c='clear'

# =========================
# Git aliases
# =========================

alias g="git"

alias gs="git status"
alias ga="git add"
alias gaa="git add ."
alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit --amend"
alias gcan="git commit --amend --no-edit"

alias gp="git push"
alias gpf="git push --force-with-lease"
alias gl="git pull"
alias gpl="git pull --rebase"

alias gb="git branch"
alias gba="git branch -a"
alias gbd="git branch -d"
alias gbD="git branch -D"

alias gco="git checkout"
alias gcb="git checkout -b"
alias gsw="git switch"
alias gswc="git switch -c"

alias gd="git diff"
alias gds="git diff --staged"

alias gr="git restore"
alias grs="git restore --staged"

alias gst="git stash"
alias gstp="git stash pop"
alias gstl="git stash list"

alias glog="git log --oneline --graph --decorate --all"
alias glol="git log --oneline"

alias ls="eza --icons"
alias ll="eza -la --icons --git"
alias la="eza -a --icons"
alias lt="eza --tree --level=2 --icons"
alias lta="eza --tree --level=2 -a --icons"

alias ta="tmux attach"
alias tls="tmux ls"
alias tn="tmux new -s"
alias tk="tmux kill-session -t"
alias tks="tmux kill-server"

alias pi="pnpm install"
alias pr="pnpm run"
alias pd="pnpm dev"

alias ports="lsof -i -P -n | grep LISTEN"
alias myip="curl ifconfig.me"
alias path='echo $PATH | tr ":" "\n"'

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
