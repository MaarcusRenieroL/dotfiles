# eza
alias ls="eza --icons=always --color=always --group-directories-first"
alias ll="eza -la --icons=always --git --group-directories-first"
alias tree="eza --tree --icons=always"

alias cat="bat"

alias grep="rg"
alias find="fd"

alias c="clear"
alias z="cd"
alias sz="source ~/.zshrc"

# git 
alias g="git"
alias gi="git init"
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit -m"
alias gca="git commit -am"
alias gs="git status"
alias gst="git status"
alias gp="git push"
alias gpl="git pull"
alias gd="git diff"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gco-="git checkout -"
alias gb="git branch"
alias gl="git log --oneline --graph --decorate"
alias gcam="git commit --amend --no-edit"
alias gundo="git reset --soft HEAD~1"
alias gclean="git clean -fd"

# tmux
alias ta="tmux attach"
alias tls="tmux ls"
alias tn="tmux new -s"
alias tk="tmux kill-session -t"
alias tks="tmux kill-server"
alias td="tmux detach"

# pnpm
alias pi="pnpm install"
alias pr="pnpm run"
alias pd="pnpm dev"
alias px="pnpm dlx"
alias pb="pnpm build"
alias pt="pnpm test"
alias pl="pnpm lint"
alias pc="pnpm typecheck"

# systems
alias ports="lsof -iTCP -sTCP:LISTEN -P -n"
alias myip="curl -s ifconfig.me"
alias path='echo $PATH | tr ":" "\n"'
alias dot="cd $DOTFILES"
alias projects="cd $HOME/Desktop/projects"

# reloads
alias sb="sketchybar --reload"

# config edits
alias zshconfig="nvim $ZSH_CONFIG/.zshrc"
alias aliasconfig="nvim $ZSH_CONFIG/aliases.zsh"
alias funcsconfig="nvim $ZSH_CONFIG/functions.zsh"
alias ghosttyconfig="nvim ~/.config/ghostty/config"
alias starshipconfig="nvim $STARSHIP_CONFIG"
