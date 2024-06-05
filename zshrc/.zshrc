# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

alias lsg="colorls -A --git --sort-dirs --group-directories-first"
alias ls="colorls -A --sort-dirs --group-directories-first"
alias cd="z"
alias c="clear"
alias v="nvim"
alias e="exit"

alias sz="source ~/.zshrc"
alias ts="tmux source ~/.config/tmux/tmux.conf"

alias g="git"
alias gs="git status"
alias ga="git add ."
alias gcm="git commit -m"
alias gca="git commit --amend"
alias gp="git push"
alias gl="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gco="git checkout"
alias gp="git push"
alias gps="git push --set-upstream origin main"
alias gpu="git pull origin"
alias grao="git remote add origin "
alias grro="git remote remove origin"

alias prd="pnpm run dev"
alias prb="pnpm run build"
alias pi="pnpm install"
alias pa="pnpm add"

alias tns="tmux new -s "
alias tat="tmux attach -t "
alias tls="tmux ls"
alias tks="tmux kill-session -t "
alias td="tmux detach"

HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
