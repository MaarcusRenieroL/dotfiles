# Functions — sourced from .zshrc

# mkcd / take : make a directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}
take() {
  mkdir -p "$1" && cd "$1"
}

# fp : fuzzy-jump to a zoxide-tracked project
fp() {
  local dir
  dir="$(zoxide query -l | fzf --prompt='project > ')" && cd "$dir"
}

# cdf : fuzzy-cd into any dir under projects/ or dotfiles
cdf() {
  local dir
  if command -v fd >/dev/null 2>&1; then
    dir="$(fd --type d --hidden --exclude .git . "$HOME/Desktop/projects" "$DOTFILES" 2>/dev/null | fzf --prompt='cd > ')"
  else
    dir="$(find "$HOME/Desktop/projects" "$DOTFILES" -type d -not -path '*/.git/*' 2>/dev/null | fzf --prompt='cd > ')"
  fi
  [ -n "$dir" ] && cd "$dir"
}

# fkill : fuzzy-pick a process and kill it
fkill() {
  local pid
  pid="$(ps -Ao pid,comm | fzf --prompt='kill > ' | awk '{print $1}')" && kill "$pid"
}
