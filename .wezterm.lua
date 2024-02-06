-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {
}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Ayu Light (Gogh)"
--config.color_scheme = "Catppuccin Latte"

config.use_fancy_tab_bar = false

config.colors = {
  tab_bar = {
    active_tab = {
          -- The color of the background area for the tab
          bg_color = '#F8F9FA',
          -- The color of the text for the tab
          fg_color = 'black',

          -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
          -- label shown for this tab.
          -- The default is "Normal"
          intensity = 'Bold',

          -- Specify whether you want "None", "Single" or "Double" underline for
          -- label shown for this tab.
          -- The default is "None"
          underline = 'None',

          -- Specify whether you want the text to be italic (true) or not (false)
          -- for this tab.  The default is false.
          italic = false,

          -- Specify whether you want the text to be rendered with strikethrough (true)
          -- or not for this tab.  The default is false.
          strikethrough = false,
        },
    inactive_tab = {
          bg_color = '#F8F9FA',
          fg_color = '#c0c0c0',


          -- The same options that were listed under the `active_tab` section above
          -- can also be used for `inactive_tab`.
        },
    background = '#F8F9FA',
    new_tab = {
        bg_color = '#F8F9FA',
        fg_color = '#808080',
    }
  },
}


config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.keys = {
  {
    key = 'w',
    mods = 'CTRL',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  {
    key = 'c',
    mods = 'CTRL',
    action = wezterm.action.CopyTo 'ClipboardAndPrimarySelection',
  },
  {
    key = 't',
    mods = 'CTRL',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
}


config.window_background_opacity = .8

-- and finally, return the configuration to wezterm
return config
