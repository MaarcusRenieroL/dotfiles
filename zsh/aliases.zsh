# Aliases — sourced from .zshrc

# --- Core --------------------------------------------------------------------
alias v='nvim'
alias e='exit'
alias c='clear'
alias reload='exec zsh'
# `cd` is provided by zoxide (--cmd cd) and behaves like cd + smart jump.

# --- Git ---------------------------------------------------------------------
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

# --- Listing (eza) -----------------------------------------------------------
if command -v eza >/dev/null 2>&1; then
  alias ls="eza --icons --group-directories-first"
  alias ll="eza -la --icons --git --group-directories-first"
  alias la="eza -a --icons --group-directories-first"
  alias lt="eza --tree --level=2 --icons --group-directories-first"
  alias lta="eza --tree --level=2 -a --icons --group-directories-first"
else
  alias ll="ls -la"
  alias la="ls -a"
fi

# --- tmux --------------------------------------------------------------------
alias ta="tmux attach"
alias tls="tmux ls"
alias tn="tmux new -s"
alias tk="tmux kill-session -t"
alias tks="tmux kill-server"
alias td="tmux detach"

# --- pnpm --------------------------------------------------------------------
alias pi="pnpm install"
alias pr="pnpm run"
alias pd="pnpm dev"
alias px="pnpm dlx"
alias pb="pnpm build"
alias pt="pnpm test"
alias pl="pnpm lint"
alias pc="pnpm typecheck"

# --- System / navigation -----------------------------------------------------
alias ports="lsof -iTCP -sTCP:LISTEN -P -n"
alias myip="curl -s ifconfig.me"
alias path='echo $PATH | tr ":" "\n"'
alias dot="cd $DOTFILES"
alias projects="cd $HOME/Desktop/projects"

if [ -d "$HOME/Desktop/projects/raycast-destroyer" ]; then
  alias rd="cd $HOME/Desktop/projects/raycast-destroyer"
fi
