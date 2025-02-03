local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "GruvboxDark"

config.font = wezterm.font_with_fallback({ "UbuntuSansMono Nerd Font", "JetBrainsMono Nerd Font" })
config.font_size = 12

config.enable_tab_bar = false
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_background_opacity = 0.9

config.audible_bell = "Disabled"

local d = os.getenv("XDG_CURRENT_DESKTOP") or ""
if d ~= "Hyprland" then
  config.adjust_window_size_when_changing_font_size = true
  config.initial_cols = 120
  config.initial_rows = 50
  config.use_resize_increments = true
  config.window_decorations = (d == "ubuntu:GNOME") and "NONE" or "RESIZE"
end

wezterm.on("format-window-title", function()
  return "wezterm"
end)

return config
