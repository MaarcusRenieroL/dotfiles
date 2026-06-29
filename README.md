# dotfiles

macOS development environment — zsh, Neovim, tmux, WezTerm, and a yabai/skhd/borders
tiling setup. Catppuccin Mocha throughout.

## Quick start

```sh
git clone git@github.com:MaarcusRenieroL/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` is idempotent — run it any time. It will:

1. Install Homebrew (if missing) and everything in [`brew/Brewfile`](brew/Brewfile)
2. Install oh-my-zsh + plugins and tmux's `tpm`
3. Symlink all configs (see linking model below)
4. Optionally apply macOS defaults (prompts)
5. Run a health check

Then open a new terminal (or `exec zsh`). In tmux, press `prefix + I` once to install plugins.

## Everyday commands

```sh
make            # list targets
make doctor     # verify links, tools, fonts, services
make link       # re-create symlinks only
make brew       # install Brewfile packages
make update     # upgrade brew + nvim (Lazy) + tmux plugins
make dump       # snapshot installed brew packages back into the Brewfile
make macos      # (re)apply macOS defaults
```

## Linking model

macOS makes one thing awkward: GUI/launchd services don't inherit your shell's
environment, so they can't see `XDG_CONFIG_HOME`. This setup uses three rules:

| What | How | Why |
|------|-----|-----|
| `.zshenv`, `.zshrc`, `.tmux.conf`, `.gitconfig`, `.gitignore_global`, `.wezterm.lua` | **GNU stow** → `$HOME` | These tools only read from `$HOME` |
| nvim, starship, lazygit, neofetch | read **in place** from `~/dotfiles` via `XDG_CONFIG_HOME` | Set once in `.zshenv`; no links to maintain |
| yabai, skhd, borders | symlinked into `~/.config/<app>` | launchd services can't see `XDG_CONFIG_HOME` |

`XDG_CONFIG_HOME=$HOME/dotfiles` is exported from [`zsh/.zshenv`](zsh/.zshenv), which
every shell sources. Each stow package has a `.stow-local-ignore` so helper files
(`zsh/aliases.zsh`, `git/themes/…`) never leak into `$HOME`.

## Layout

```
dotfiles/
├── install.sh            # bootstrap
├── Makefile              # task runner
├── brew/Brewfile         # packages
├── scripts/              # lib, link, macos, doctor
├── zsh/                  # .zshenv (env+PATH), .zshrc, aliases.zsh, functions.zsh
├── git/                  # .gitconfig, .gitignore_global, themes/ (delta)
├── nvim/                 # Neovim (lazy.nvim)
├── tmux/  wezterm/       # terminal + multiplexer
├── yabai/ skhd/ borders/ # tiling WM + hotkeys + window borders
└── starship/ lazygit/ neofetch/
```

## Machine-local overrides

Anything secret or machine-specific stays out of git:

- `zsh/local.zsh` — extra env/aliases, sourced automatically by `.zshenv`
- `git/local.gitconfig` — e.g. a work email, included automatically by `.gitconfig`

Both are gitignored and optional.

## Notes

- Key prefix is `C-s` in tmux; window manager hotkeys live in [`skhd/skhdrc`](skhd/skhdrc).
- `cd` is zoxide-powered (`--cmd cd`) — it still works as plain `cd` but learns your jumps.
- Run `make doctor` first whenever something feels off; it pinpoints broken links/tools.
