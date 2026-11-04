-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then config = wezterm.config_builder() end

-- Follow the system appearance; the GUI API is unavailable in the mux server.
local appearance = wezterm.gui and wezterm.gui.get_appearance() or 'Light'
local dark = appearance:find('Dark') ~= nil
config.color_scheme = dark and 'Ayu Mirage' or 'Ayu Light (Gogh)'
config.use_fancy_tab_bar = false
config.tab_max_width = 80
config.enable_wayland = false

local bg = dark and '#1f2430' or '#F8F9FA'
local fg = dark and '#cccac2' or '#5c6166'
local muted = dark and '#707a8c' or '#808080'
config.colors = {
  tab_bar = {
    background = bg,
    active_tab = {
      bg_color = dark and '#274364' or bg,
      fg_color = fg,
      intensity = 'Bold',
    },
    inactive_tab = { bg_color = bg, fg_color = muted },
    inactive_tab_hover = { bg_color = dark and '#232a34' or '#e7eaed', fg_color = fg },
    new_tab = { bg_color = bg, fg_color = muted },
    new_tab_hover = { bg_color = dark and '#232a34' or '#e7eaed', fg_color = fg },
  },
}

config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

config.keys = {
  {
    key = 'w',
    mods = 'CTRL',
    action = wezterm.action.CloseCurrentPane { confirm = true }
  }, {
  key = 't',
  mods = 'CTRL',
  action = wezterm.action.SpawnTab 'CurrentPaneDomain'
}, { key = 'y', mods = 'CTRL', action = wezterm.action.ActivateCopyMode }
}

config.window_background_opacity = 1

-- and finally, return the configuration to wezterm
return config
