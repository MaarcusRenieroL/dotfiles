# Dotfiles

```sh
brew bundle install --file brew/Brewfile
stow tmux zsh git wezterm
```

Most app configs are read directly from `~/dotfiles/<workflow>/<config_file>` through `XDG_CONFIG_HOME=~/dotfiles`.
