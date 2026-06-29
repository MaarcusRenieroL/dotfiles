# ~/.zshrc — interactive shell setup only.
# Environment / PATH live in ~/.zshenv so they're available everywhere.

# --- oh-my-zsh ---------------------------------------------------------------
ZSH_THEME=""   # prompt is handled by starship (see end of file)

plugins=(
  git
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
# --cmd cd makes `cd` zoxide-powered while preserving real cd semantics.
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh --cmd cd)"
