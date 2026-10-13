# Dotfiles tasks — `just` to list. Mirrors the Makefile.
dotfiles := env_var("HOME") / "dotfiles"

default:
    @just --list

link:
    bash {{dotfiles}}/scripts/link.sh

brew:
    brew bundle --file {{dotfiles}}/brew/Brewfile

rice:
    bash {{dotfiles}}/scripts/rice.sh

theme:
    bash {{dotfiles}}/theme/apply.sh

doctor:
    bash {{dotfiles}}/scripts/doctor.sh

nvim-sync:
    nvim --headless "+Lazy! sync" +qa

tmux-plugins:
    ~/.tmux/plugins/tpm/bin/install_plugins
