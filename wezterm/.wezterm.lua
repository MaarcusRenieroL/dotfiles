local wezterm = require 'wezterm'

local config = wezterm.config_builder();

-- font
config.font = wezterm.font 'GeistMono Nerd Font Propo'
config.font_size = 16

-- theme
config.color_scheme = 'Catppuccin Mocha'

-- window
config.window_background_opacity = 0.92
config.window_padding = { left = 20, right = 20, top = 20, bottom = 20 }
config.native_macos_fullscreen_mode = false
config.window_decorations = 'RESIZE'

-- cursor
config.cursor_blink_rate = 700

-- tabs
config.use_fancy_tab_bar = false
config.enable_tab_bar = false

-- scrollback 
config.scrollback_lines = 1000

-- term
config.term = 'xterm-256color'

-- leader
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

return config
