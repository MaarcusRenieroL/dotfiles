# Homebrew prefix
if [[ -z "$HOMEBREW_PREFIX" ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    HOMEBREW_PREFIX="/opt/homebrew"
  elif [[ -x /usr/local/bin/brew ]]; then
    HOMEBREW_PREFIX="/usr/local"
  fi
fi

# History
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="$HOME/.zsh_history"

setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# History substring / beginning search
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^[[A' up-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search
bindkey '^P' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search
[[ -n "$terminfo[kcuu1]" ]] && bindkey "$terminfo[kcuu1]" up-line-or-beginning-search
[[ -n "$terminfo[kcud1]" ]] && bindkey "$terminfo[kcud1]" down-line-or-beginning-search

# Directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Completion
[[ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]] && fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)

autoload -Uz compinit
# Cache compdump for 24h for fast startup
if [[ -n $(find "${ZDOTDIR:-$HOME}/.zcompdump" -mtime -1 2>/dev/null) ]]; then
  compinit -C
else
  compinit
fi

# Plugins (Oh-My-Zsh fallback or standalone Homebrew-installed plugins)
if [[ -n "$ZSH" && -f "$ZSH/oh-my-zsh.sh" ]]; then
  ZSH_THEME=""   # prompt is handled by starship
  plugins=(
    git
    fzf-tab
    zsh-autosuggestions
    zsh-syntax-highlighting
  )
  source "$ZSH/oh-my-zsh.sh"
else
  # fzf-tab (must load after compinit, before autosuggestions/syntax-highlighting)
  if [[ -f "$HOMEBREW_PREFIX/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh" ]]; then
    source "$HOMEBREW_PREFIX/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh"
  elif [[ -f "$HOMEBREW_PREFIX/share/fzf-tab/fzf-tab.zsh" ]]; then
    source "$HOMEBREW_PREFIX/share/fzf-tab/fzf-tab.zsh"
  fi

  # zsh-autosuggestions
  if [[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  fi
fi

# fzf-tab & completion styling
zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins commands functions
zstyle ':completion:*:aliases' verbose yes

# Preview alias definitions and command paths
zstyle ':fzf-tab:complete:(-command-):*' fzf-preview 'which -- $word 2>/dev/null'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --icons --color=always $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --style=numbers --line-range=:40 $realpath 2>/dev/null || eza -1 --color=always $realpath 2>/dev/null'

# fzf-tab popup styling (Zoro palette)
zstyle ':fzf-tab:*' fzf-flags \
  --color=bg+:#1e3a29,bg:#0d120e,spinner:#4ade80,hl:#22c55e \
  --color=fg:#e2ece4,header:#22c55e,info:#eab308,pointer:#4ade80 \
  --color=marker:#4ade80,fg+:#f0fdf4,prompt:#4ade80,hl+:#4ade80 \
  --border=rounded --prompt='❯ ' --pointer='▶'

# Aliases and functions
for _f in "$ZSH_CONFIG"/aliases.zsh "$ZSH_CONFIG"/functions.zsh; do
  [ -r "$_f" ] && source "$_f"
done
unset _f

# Tool initializations
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh --cmd cd)"

# zsh-syntax-highlighting (must be loaded at the very end of .zshrc)
if [[ -z "$ZSH" || ! -f "$ZSH/oh-my-zsh.sh" ]]; then
  if [[ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  fi
fi

# Load fastfetch on terminal startup
if [[ -o interactive ]] && [[ -t 1 ]] && [[ "$TERM" != "dumb" ]] && command -v fastfetch >/dev/null 2>&1; then
  fastfetch
fi
