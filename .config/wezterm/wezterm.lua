local wezterm = require 'wezterm'

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.audible_bell = "Disabled"

config.font = wezterm.font 'Flexi IBM VGA True'
config.font_size = 16
config.bold_brightens_ansi_colors = false

config.hide_tab_bar_if_only_one_tab = true

return config
