# ~/.zshrc — interactive shell setup only.
# Environment / PATH live in ~/.zshenv so they're available everywhere.

# --- oh-my-zsh ---------------------------------------------------------------
ZSH_THEME=""   # prompt is handled by starship (see end of file)

plugins=(
  git
  fzf-tab
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# --- History -----------------------------------------------------------------
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="$HOME/.zsh_history"

setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# --- Completion --------------------------------------------------------------
autoload -Uz compinit
compinit

# --- Aliases & functions (modular) -------------------------------------------
for _f in "$ZSH_CONFIG"/aliases.zsh "$ZSH_CONFIG"/functions.zsh; do
  [ -r "$_f" ] && source "$_f"
done
unset _f

# --- Tool init (keep zoxide LAST per its own recommendation) -----------------
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)
# atuin owns ctrl-r (after fzf, so it wins); up-arrow stays normal history
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh --disable-up-arrow)"
command -v mise >/dev/null 2>&1 && eval "$(mise activate zsh)"
# --cmd cd makes `cd` zoxide-powered while preserving real cd semantics.
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh --cmd cd)"

# Zoro palette — fzf, syntax highlighting, eza, fzf-tab flags (generated: `make theme`)
[ -r "$DOTFILES/theme/out/zsh.zsh" ] && source "$DOTFILES/theme/out/zsh.zsh"
alias neofetch='fastfetch'

# fzf-tab behaviour
zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --icons --color=always $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --style=numbers --line-range=:40 $realpath 2>/dev/null || eza -1 --color=always $realpath 2>/dev/null'
