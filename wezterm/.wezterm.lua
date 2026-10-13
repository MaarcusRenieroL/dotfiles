local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({
	"GeistMono Nerd Font Mono",
	"Symbols Nerd Font Mono",
})
config.font_size = 16
config.colors = dofile(os.getenv("HOME") .. "/dotfiles/theme/out/wezterm.lua")

config.window_background_opacity = 0.97
config.macos_window_background_blur = 30
config.window_padding = { left = 16, right = 16, top = 14, bottom = 14 }
config.native_macos_fullscreen_mode = false
config.window_decorations = "RESIZE"

config.cursor_blink_rate = 700

config.use_fancy_tab_bar = false
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

return config
