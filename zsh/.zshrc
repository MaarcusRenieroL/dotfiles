export XDG_CONFIG_HOME="$HOME/dotfiles"
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less -FRX"
export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/.git/*'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="find . -type d -not -path '*/.git/*'"
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

HISTSIZE=50000
SAVEHIST=50000
HISTFILE="$HOME/.zsh_history"

setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# completion
autoload -Uz compinit
compinit

alias v='nvim'
alias e='exit'
alias c='clear'
alias reload='source ~/.zshrc'

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
alias lg="lazygit"
alias lgc="lazygit -c"

if command -v eza >/dev/null 2>&1; then
  alias ls="eza --icons --group-directories-first"
  alias ll="eza -la --icons --git --group-directories-first"
  alias la="eza -a --icons --group-directories-first"
  alias lt="eza --tree --level=2 --icons --group-directories-first"
  alias lta="eza --tree --level=2 -a --icons --group-directories-first"
else
  alias ls="ls -la"
fi

alias ta="tmux attach"
alias tls="tmux ls"
alias tn="tmux new -s"
alias tk="tmux kill-session -t"
alias tks="tmux kill-server"
alias td="tmux detach"

alias pi="pnpm install"
alias pr="pnpm run"
alias pd="pnpm dev"
alias px="pnpm dlx"

alias ports="lsof -iTCP -sTCP:LISTEN -P -n"
alias myip="curl ifconfig.me"
alias path='echo $PATH | tr ":" "\n"'

mkcd() {
  mkdir -p "$1" && cd "$1"
}

take() {
  mkdir -p "$1" && cd "$1"
}

fp() {
  local dir
  dir="$(zoxide query -l | fzf --prompt='project > ')" && cd "$dir"
}

fkill() {
  local pid
  pid="$(ps -Ao pid,comm | fzf --prompt='kill > ' | awk '{print $1}')" && kill "$pid"
}

command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)

# pnpm
export PNPM_HOME="/Users/maarcusrenierol/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# scanforge
export PATH="/Users/maarcusrenierol/.scanforge/bin:$PATH"
