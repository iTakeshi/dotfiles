local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Sonokai (Gogh)'
config.colors = {
  cursor_bg = 'green',
}

config.font = wezterm.font_with_fallback {
  {
    family = 'Fantasque Sans Mono',
    weight = 'Regular',
    harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
  },
}
config.font_size = 15
config.adjust_window_size_when_changing_font_size = false

config.window_padding = {
  left = 1,
  right = 1,
  top = 1,
  bottom = 1,
}

config.enable_tab_bar = false

return config
