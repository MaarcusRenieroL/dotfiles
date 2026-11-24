#!/usr/bin/env bash
# ==============================================================================
# Dotfiles Installer, Uninstaller & Doctor
# Theme: Zoro Santoryu Edition
# Supported OS: macOS (Darwin), Linux (Debian/Ubuntu, Arch, Fedora)
# ==============================================================================

set -eo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${HOME}/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# --- Color Scheme (Zoro Palette) -----------------------------------------------
BOLD="\033[1m"
RESET="\033[0m"
DIM="\033[2m"
GREEN="\033[38;2;74;222;128m"   # #4ade80 (Emerald)
CYAN="\033[38;2;56;189;248m"    # #38bdf8 (Katana Cyan)
PURPLE="\033[38;2;168;85;247m"  # #a855f7 (Enma Violet)
RED="\033[38;2;225;29;72m"      # #e11d48 (Crimson Red)
YELLOW="\033[38;2;234;179;8m"   # #eab308 (Gold / Warning)
MUTED="\033[38;2;154;154;154m"  # #9a9a9a (Muted Slate)

log_banner() {
  cat << "EOF"
  ______ _____  _____ ______ _____ _      ______ _____ 
  |  _  \  _  ||_   _||  ___|_   _| |    |  ____/  ___|
  | | | | | | |  | |  | |_    | | | |    | |__  \ `--. 
  | | | | | | |  | |  |  _|   | | | |    |  __|  `--. \
  | |/ /\ \_/ /  | |  | |    _| |_| |____| |____/\__/ /
  |___/  \___/   \_/  \_|    \___/\_____/\______/\____/ 
EOF
  printf "${PURPLE}%s${RESET}\n\n" "       ⚔️  Zoro Santoryu Development Environment ⚔️"
}

log_info()    { printf "${CYAN}❯${RESET} %s\n" "$*"; }
log_success() { printf "${GREEN}✓${RESET} %s\n" "$*"; }
log_warn()    { printf "${YELLOW}!${RESET} %s\n" "$*"; }
log_error()   { printf "${RED}✗${RESET} %s\n" "$*"; }
log_step()    { printf "\n${BOLD}${GREEN}==>${RESET} ${BOLD}%s${RESET}\n" "$*"; }

# --- OS Detection --------------------------------------------------------------
detect_os() {
  OS_TYPE="unknown"
  DISTRO="unknown"

  case "$(uname -s)" in
    Darwin)
      OS_TYPE="macos"
      ;;
    Linux)
      OS_TYPE="linux"
      if [ -f /etc/os-release ]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        DISTRO="${ID:-linux}"
      fi
      ;;
    *)
      OS_TYPE="unsupported"
      ;;
  esac
}

# --- Safe Symlinking -----------------------------------------------------------
link_item() {
  local src="$1"
  local dest="$2"

  if [ ! -e "$src" ]; then
    log_warn "Source not found, skipping: $src"
    return 0
  fi

  # If dest is already the correct symlink
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    log_success "Already linked: ${dest} -> ${src}"
    return 0
  fi

  # If destination exists (regular file, directory, or broken/other symlink)
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mkdir -p "$BACKUP_DIR"
    local backup_path="${BACKUP_DIR}/$(basename "$dest")_$(date +%s)"
    mv "$dest" "$backup_path"
    log_info "Backed up existing ${dest} to ${backup_path}"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -sfn "$src" "$dest"
  log_success "Linked: ${dest} -> ${src}"
}

unlink_item() {
  local src="$1"
  local dest="$2"

  if [ -L "$dest" ]; then
    local current_target
    current_target="$(readlink "$dest" || true)"
    if [[ "$current_target" == "$src"* ]] || [[ "$current_target" == *dotfiles* ]]; then
      rm -f "$dest"
      log_success "Removed symlink: ${dest}"
    else
      log_warn "Symlink ${dest} does not point to dotfiles (${current_target}); skipped"
    fi
  elif [ -e "$dest" ]; then
    log_warn "${dest} is not a symlink; leaving untouched"
  fi
}

# --- Package Installations -----------------------------------------------------
install_packages_macos() {
  log_step "Installing macOS packages via Homebrew"

  if ! command -v brew >/dev/null 2>&1; then
    log_info "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ -x "/opt/homebrew/bin/brew" ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x "/usr/local/bin/brew" ]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi

  if [ -f "${DOTFILES_DIR}/Brewfile" ]; then
    log_info "Installing packages, casks and fonts via Brewfile..."
    brew bundle --file="${DOTFILES_DIR}/Brewfile" || log_warn "Some Brewfile packages may need manual attention"
  else
    log_info "Adding Homebrew taps..."
    brew tap felixkratz/formulae 2>/dev/null || true
    brew tap koekeishiya/formulae 2>/dev/null || true

    local formulae=(
      yabai
      skhd
      sketchybar
      borders
      ghostty
      tmux
      neovim
      starship
      zsh-autosuggestions
      zsh-syntax-highlighting
      fzf-tab
      fzf
      zoxide
      eza
      bat
      ripgrep
      fd
      lazygit
      btop
      fastfetch
    )

    log_info "Installing CLI tools and window management formulae..."
    for pkg in "${formulae[@]}"; do
      if brew list "$pkg" >/dev/null 2>&1; then
        log_success "$pkg is already installed"
      else
        log_info "Installing $pkg..."
        brew install "$pkg" || log_warn "Failed to install $pkg via brew"
      fi
    done

    log_info "Installing recommended Nerd Fonts..."
    brew tap homebrew/cask-fonts 2>/dev/null || brew tap homebrew/cask || true
    for font in font-jetbrains-mono-nerd-font font-geist-mono-nerd-font; do
      if brew list --cask "$font" >/dev/null 2>&1; then
        log_success "$font is already installed"
      else
        log_info "Installing $font..."
        brew install --cask "$font" 2>/dev/null || log_warn "Could not install $font automatically"
      fi
    done
  fi
}

install_packages_linux() {
  log_step "Installing Linux packages (${DISTRO})"

  case "$DISTRO" in
    ubuntu|debian|pop|linuxmint)
      log_info "Updating apt cache and installing dependencies..."
      sudo apt update -y
      sudo apt install -y git curl zsh tmux neovim fzf ripgrep fd-find btop jq

      # Tools with specific installation methods if not in apt
      command -v eza >/dev/null 2>&1 || log_warn "Please install 'eza' via cargo or distro repo"
      command -v bat >/dev/null 2>&1 || sudo apt install -y bat || true
      command -v zoxide >/dev/null 2>&1 || curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh || true
      command -v starship >/dev/null 2>&1 || curl -sS https://starship.rs/install.sh | sh -s -- -y || true
      command -v fastfetch >/dev/null 2>&1 || sudo apt install -y fastfetch || true
      ;;
    arch|manjaro|endeavouros)
      log_info "Installing via pacman..."
      sudo pacman -Syu --noconfirm git curl zsh tmux neovim fzf ripgrep fd eza bat zoxide starship btop fastfetch jq || true
      ;;
    fedora)
      log_info "Installing via dnf..."
      sudo dnf install -y git curl zsh tmux neovim fzf ripgrep fd-find eza bat zoxide starship btop fastfetch jq || true
      ;;
    *)
      log_warn "Unknown Linux distribution ($DISTRO). Attempting to use Homebrew on Linux if present..."
      if command -v brew >/dev/null 2>&1; then
        brew install tmux neovim starship fzf zoxide eza bat ripgrep fd git-delta lazygit btop fastfetch jq
      else
        log_warn "Please install zsh, tmux, neovim, fzf, starship, zoxide, eza, bat, ripgrep manually."
      fi
      ;;
  esac

  log_info "Note: macOS window management utilities (yabai, skhd, sketchybar, borders) are skipped on Linux."
}

# --- Link Configurations -------------------------------------------------------
setup_symlinks() {
  log_step "Creating configuration symlinks"

  # Core cross-platform configurations
  link_item "${DOTFILES_DIR}/zsh/.zshrc" "${HOME}/.zshrc"
  link_item "${DOTFILES_DIR}/zsh/.zshenv" "${HOME}/.zshenv"
  link_item "${DOTFILES_DIR}/tmux/.tmux.conf" "${HOME}/.tmux.conf"
  link_item "${DOTFILES_DIR}/git/.gitconfig" "${HOME}/.gitconfig"
  link_item "${DOTFILES_DIR}/git/.gitignore_global" "${HOME}/.gitignore_global"

  link_item "${DOTFILES_DIR}/nvim" "${HOME}/.config/nvim"
  link_item "${DOTFILES_DIR}/starship/starship.toml" "${HOME}/.config/starship.toml"
  link_item "${DOTFILES_DIR}/bat" "${HOME}/.config/bat"
  link_item "${DOTFILES_DIR}/btop" "${HOME}/.config/btop"
  link_item "${DOTFILES_DIR}/fastfetch" "${HOME}/.config/fastfetch"
  link_item "${DOTFILES_DIR}/lazygit" "${HOME}/.config/lazygit"
  # Ghostty: handle directory or top-level symlink
  if [ -d "${HOME}/.config/ghostty" ] && [ ! -L "${HOME}/.config/ghostty" ]; then
    link_item "${DOTFILES_DIR}/ghostty/config" "${HOME}/.config/ghostty/config"
    mkdir -p "${HOME}/.config/ghostty/themes"
    link_item "${DOTFILES_DIR}/ghostty/themes/zoro" "${HOME}/.config/ghostty/themes/zoro"
  else
    link_item "${DOTFILES_DIR}/ghostty" "${HOME}/.config/ghostty"
  fi

  # macOS-specific configurations
  if [ "$OS_TYPE" = "macos" ]; then
    mkdir -p "${HOME}/.config/yabai" "${HOME}/.config/skhd" "${HOME}/.config/borders"
    link_item "${DOTFILES_DIR}/yabai/yabairc" "${HOME}/.config/yabai/yabairc"
    link_item "${DOTFILES_DIR}/skhd/skhdrc" "${HOME}/.config/skhd/skhdrc"
    link_item "${DOTFILES_DIR}/borders/bordersrc" "${HOME}/.config/borders/bordersrc"
    link_item "${DOTFILES_DIR}/sketchybar" "${HOME}/.config/sketchybar"

    # Ensure skhd helper scripts are executable
    chmod +x "${DOTFILES_DIR}/skhd/scripts/"*.sh 2>/dev/null || true

    # Enable Mission Control Switch-to-Desktop shortcuts (1-9) with Option (Alt) modifier (524288)
    python3 -c "
import plistlib, os
path = os.path.expanduser('~/Library/Preferences/com.apple.symbolichotkeys.plist')
if os.path.exists(path):
    with open(path, 'rb') as f:
        pl = plistlib.load(f)
    kc = [18, 19, 20, 21, 23, 22, 26, 28, 25]
    hk = pl.setdefault('AppleSymbolicHotKeys', {})
    for i, c in enumerate(kc):
        hk[str(118 + i)] = {'enabled': True, 'value': {'parameters': [65535, c, 524288], 'type': 'standard'}}
    with open(path, 'wb') as f:
        plistlib.dump(pl, f)
" 2>/dev/null || true
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u 2>/dev/null || true
  fi
}

remove_symlinks() {
  log_step "Removing dotfiles symlinks"

  unlink_item "${DOTFILES_DIR}/zsh/.zshrc" "${HOME}/.zshrc"
  unlink_item "${DOTFILES_DIR}/zsh/.zshenv" "${HOME}/.zshenv"
  unlink_item "${DOTFILES_DIR}/tmux/.tmux.conf" "${HOME}/.tmux.conf"
  unlink_item "${DOTFILES_DIR}/git/.gitconfig" "${HOME}/.gitconfig"
  unlink_item "${DOTFILES_DIR}/git/.gitignore_global" "${HOME}/.gitignore_global"

  unlink_item "${DOTFILES_DIR}/nvim" "${HOME}/.config/nvim"
  unlink_item "${DOTFILES_DIR}/starship/starship.toml" "${HOME}/.config/starship.toml"
  unlink_item "${DOTFILES_DIR}/bat" "${HOME}/.config/bat"
  unlink_item "${DOTFILES_DIR}/btop" "${HOME}/.config/btop"
  unlink_item "${DOTFILES_DIR}/fastfetch" "${HOME}/.config/fastfetch"
  unlink_item "${DOTFILES_DIR}/lazygit" "${HOME}/.config/lazygit"
  unlink_item "${DOTFILES_DIR}/ghostty" "${HOME}/.config/ghostty"
  unlink_item "${DOTFILES_DIR}/ghostty/config" "${HOME}/.config/ghostty/config"
  unlink_item "${DOTFILES_DIR}/ghostty/themes/zoro" "${HOME}/.config/ghostty/themes/zoro"

  if [ "$OS_TYPE" = "macos" ]; then
    unlink_item "${DOTFILES_DIR}/yabai/yabairc" "${HOME}/.config/yabai/yabairc"
    unlink_item "${DOTFILES_DIR}/skhd/skhdrc" "${HOME}/.config/skhd/skhdrc"
    unlink_item "${DOTFILES_DIR}/borders/bordersrc" "${HOME}/.config/borders/bordersrc"
    unlink_item "${DOTFILES_DIR}/sketchybar" "${HOME}/.config/sketchybar"
  fi
}

# --- Post-Install Setups -------------------------------------------------------
post_install() {
  log_step "Running post-install setups"

  # 1. Bat cache rebuild
  if command -v bat >/dev/null 2>&1; then
    log_info "Rebuilding bat theme cache for Zoro syntax highlighting..."
    bat cache --build >/dev/null 2>&1 || true
    log_success "Bat theme cache built"
  fi

  # 2. Tmux Plugin Manager (TPM)
  local tpm_dir="${HOME}/.tmux/plugins/tpm"
  if [ ! -d "$tpm_dir" ]; then
    log_info "Installing Tmux Plugin Manager (TPM)..."
    git clone --quiet https://github.com/tmux-plugins/tpm "$tpm_dir"
  fi

  if [ -x "${tpm_dir}/bin/install_plugins" ]; then
    log_info "Installing tmux plugins via TPM..."
    tmux start-server 2>/dev/null || true
    "${tpm_dir}/bin/install_plugins" >/dev/null 2>&1 || true
    log_success "Tmux plugins installed"
  fi

  # 3. macOS Service Advice
  if [ "$OS_TYPE" = "macos" ]; then
    log_step "macOS Services"
    log_info "To enable and start the Zoro window management services, run:"
    printf "  ${CYAN}brew services start yabai${RESET}\n"
    printf "  ${CYAN}brew services start skhd${RESET}\n"
    printf "  ${CYAN}brew services start borders${RESET}\n"
    printf "  ${CYAN}brew services start sketchybar${RESET}\n\n"
    log_info "Make sure to grant Accessibility permissions to yabai, skhd, and Ghostty in:"
    printf "  ${MUTED}System Settings > Privacy & Security > Accessibility${RESET}\n"
  fi
}

# --- Main Actions --------------------------------------------------------------
do_install() {
  log_banner
  log_info "Target System: ${BOLD}${OS_TYPE}${RESET} (${DISTRO})"

  if [ "$OS_TYPE" = "macos" ]; then
    install_packages_macos
  elif [ "$OS_TYPE" = "linux" ]; then
    install_packages_linux
  else
    log_error "Unsupported operating system: $(uname -s)"
    exit 1
  fi

  setup_symlinks
  post_install

  log_step "Installation Completed!"
  log_success "Dotfiles have been successfully configured."
  if [ -d "$BACKUP_DIR" ]; then
    log_info "Any overwritten configurations were preserved in: ${BACKUP_DIR}"
  fi
  printf "\n${PURPLE}⚔️  Open a new terminal or run 'source ~/.zshrc' to begin!${RESET}\n\n"
}

do_uninstall() {
  log_banner
  log_step "Uninstalling Dotfiles"

  remove_symlinks

  if [ "$OS_TYPE" = "macos" ]; then
    log_info "Stopping active macOS window services (if running)..."
    brew services stop yabai 2>/dev/null || true
    brew services stop skhd 2>/dev/null || true
    brew services stop borders 2>/dev/null || true
    brew services stop sketchybar 2>/dev/null || true
  fi

  log_success "Symlinks removed and services stopped."
  log_info "Package uninstallation is left to the user (e.g., 'brew uninstall ...')."
}

do_doctor() {
  log_banner
  log_step "Health Check (Doctor)"
  log_info "Running diagnostics on current environment...\n"

  local all_good=true

  printf "${BOLD}%-20s %-12s %-30s${RESET}\n" "COMPONENT" "STATUS" "DETAILS"
  printf "${MUTED}%-20s %-12s %-30s${RESET}\n" "--------------------" "------------" "------------------------------"

  check_cmd() {
    local cmd="$1"
    local desc="$2"
    if command -v "$cmd" >/dev/null 2>&1; then
      local path
      path="$(command -v "$cmd")"
      printf "%-20s ${GREEN}%-12s${RESET} %-30s\n" "$cmd" "[INSTALLED]" "$path"
    else
      printf "%-20s ${RED}%-12s${RESET} %-30s\n" "$cmd" "[MISSING]" "$desc"
      all_good=false
    fi
  }

  check_link() {
    local name="$1"
    local dest="$2"
    local expected="$3"

    if [ -L "$dest" ]; then
      local target
      target="$(readlink "$dest")"
      if [[ "$target" == *"$expected"* ]]; then
        printf "%-20s ${GREEN}%-12s${RESET} %-30s\n" "$name" "[LINKED]" "-> $target"
        return 0
      else
        printf "%-20s ${YELLOW}%-12s${RESET} %-30s\n" "$name" "[MISMATCH]" "-> $target"
        all_good=false
        return 0
      fi
    elif [ -d "$dest" ] && [ -L "$dest/config" ]; then
      local target
      target="$(readlink "$dest/config")"
      if [[ "$target" == *"$expected"* ]]; then
        printf "%-20s ${GREEN}%-12s${RESET} %-30s\n" "$name" "[LINKED]" "config -> $target"
        return 0
      fi
    elif [ -e "$dest" ]; then
      printf "%-20s ${YELLOW}%-12s${RESET} %-30s\n" "$name" "[NOT SYMLINK]" "Regular file/directory"
      all_good=false
      return 0
    else
      printf "%-20s ${RED}%-12s${RESET} %-30s\n" "$name" "[MISSING]" "Path does not exist"
      all_good=false
      return 0
    fi
  }

  printf "\n${BOLD}[ CLI Tools & Binaries ]${RESET}\n"
  check_cmd "zsh" "Default Shell"
  check_cmd "tmux" "Terminal Multiplexer"
  check_cmd "nvim" "Neovim IDE"
  check_cmd "starship" "Prompt Theme"
  check_cmd "fzf" "Fuzzy Finder"
  check_cmd "zoxide" "Smarter cd"
  check_cmd "eza" "Modern ls replacement"
  check_cmd "bat" "Cat with syntax highlighting"
  check_cmd "rg" "Ripgrep search"
  check_cmd "fd" "Simple fast find"
  check_cmd "lazygit" "Git TUI"
  check_cmd "btop" "System Monitor"
  check_cmd "fastfetch" "System Fetcher"

  if [ "$OS_TYPE" = "macos" ]; then
    printf "\n${BOLD}[ macOS Window Management ]${RESET}\n"
    check_cmd "yabai" "Tiling window manager"
    check_cmd "skhd" "Hotkey daemon"
    check_cmd "sketchybar" "Status bar"
    check_cmd "borders" "JankyBorders"
  fi

  printf "\n${BOLD}[ Symlink Health ]${RESET}\n"
  check_link ".zshrc" "${HOME}/.zshrc" "dotfiles/zsh/.zshrc"
  check_link ".zshenv" "${HOME}/.zshenv" "dotfiles/zsh/.zshenv"
  check_link ".tmux.conf" "${HOME}/.tmux.conf" "dotfiles/tmux/.tmux.conf"
  check_link ".gitconfig" "${HOME}/.gitconfig" "dotfiles/git/.gitconfig"
  check_link "nvim" "${HOME}/.config/nvim" "dotfiles/nvim"
  check_link "starship.toml" "${HOME}/.config/starship.toml" "dotfiles/starship/starship.toml"
  check_link "bat" "${HOME}/.config/bat" "dotfiles/bat"
  check_link "btop" "${HOME}/.config/btop" "dotfiles/btop"
  check_link "fastfetch" "${HOME}/.config/fastfetch" "dotfiles/fastfetch"
  check_link "lazygit" "${HOME}/.config/lazygit" "dotfiles/lazygit"
  check_link "ghostty" "${HOME}/.config/ghostty" "dotfiles/ghostty"

  if [ "$OS_TYPE" = "macos" ]; then
    check_link "yabairc" "${HOME}/.config/yabai/yabairc" "dotfiles/yabai/yabairc"
    check_link "skhdrc" "${HOME}/.config/skhd/skhdrc" "dotfiles/skhd/skhdrc"
    check_link "bordersrc" "${HOME}/.config/borders/bordersrc" "dotfiles/borders/bordersrc"
    check_link "sketchybar" "${HOME}/.config/sketchybar" "dotfiles/sketchybar"
  fi

  if [ "$OS_TYPE" = "macos" ]; then
    printf "\n${BOLD}[ macOS Services Status ]${RESET}\n"
    for svc in yabai skhd borders sketchybar; do
      if brew services list 2>/dev/null | grep "^${svc}" | grep -q "started"; then
        printf "%-20s ${GREEN}%-12s${RESET} %-30s\n" "$svc" "[RUNNING]" "brew service active"
      else
        printf "%-20s ${YELLOW}%-12s${RESET} %-30s\n" "$svc" "[STOPPED]" "Run 'brew services start $svc'"
      fi
    done
  fi

  printf "\n"
  if [ "$all_good" = true ]; then
    log_success "All system checks passed! Your Zoro environment is in peak condition. ⚔️"
  else
    log_warn "Some components or links need attention. Run './install.sh' to repair symlinks or missing packages."
  fi
  printf "\n"
}

show_help() {
  log_banner
  printf "${BOLD}Usage:${RESET} ./install.sh [COMMAND]\n\n"
  printf "${BOLD}Commands:${RESET}\n"
  printf "  ${GREEN}install${RESET}     (Default) Installs packages, creates symlinks, and sets up themes\n"
  printf "  ${RED}uninstall${RESET}   Removes all dotfiles symlinks and stops services\n"
  printf "  ${CYAN}doctor${RESET}      Runs diagnostic health check on packages, symlinks, and services\n"
  printf "  ${PURPLE}macos${RESET}       Applies optimized macOS system and UI defaults\n"
  printf "  ${YELLOW}help${RESET}        Displays this help message\n\n"
}

# --- Entry Point ---------------------------------------------------------------
detect_os

case "${1:-install}" in
  install|--install|-i)
    do_install
    ;;
  uninstall|--uninstall|-u)
    do_uninstall
    ;;
  doctor|--doctor|-d)
    do_doctor
    ;;
  macos|--macos|-m)
    if [ "$OS_TYPE" = "macos" ]; then
      "${DOTFILES_DIR}/macos/defaults.sh"
    else
      log_warn "macOS defaults can only be run on macOS."
    fi
    ;;
  help|--help|-h)
    show_help
    ;;
  *)
    log_error "Unknown command: $1"
    show_help
    exit 1
    ;;
esac
