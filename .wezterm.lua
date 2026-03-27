-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then config = wezterm.config_builder() end

-- Tab title logic Start --

local tab_title_state = {}

local function cwd_uri_to_path(cwd_uri)
  if not cwd_uri then return nil end

  if type(cwd_uri) == 'userdata' then return cwd_uri.file_path end

  local path = cwd_uri:gsub('^file://[^/]*', '')
  return path:gsub('%%(%x%x)',
    function(hex) return string.char(tonumber(hex, 16)) end)
end

local function last_path_segment(path)
  if not path or path == '' then return nil end

  if path == '/' then return '/' end

  path = path:gsub('[\\/]+$', '')
  return path:match('([^/\\]+)$')
end

local function padded_title(title, max_width)
  if max_width and max_width > 2 then
    title = wezterm.truncate_right(title, max_width - 2)
  end

  return string.format(' %s ', title)
end

local function default_tab_title(tab)
  local cwd = cwd_uri_to_path(tab.active_pane.current_working_dir)
  local title = last_path_segment(cwd)

  if title and #title > 0 then return title, cwd end

  return tab.active_pane.title, cwd
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title, cwd = default_tab_title(tab)
  local explicit_title = tab.tab_title
  local state = tab_title_state[tab.tab_id] or {}
  tab_title_state[tab.tab_id] = state

  if explicit_title and #explicit_title > 0 then
    if explicit_title ~= state.last_explicit_title then
      state.last_explicit_title = explicit_title
      state.explicit_title_cwd = cwd
    elseif state.explicit_title_cwd and cwd and cwd ~=
        state.explicit_title_cwd then
      state.explicit_title_cwd = false
    end

    if not cwd or cwd == state.explicit_title_cwd then
      return padded_title(explicit_title, max_width)
    end
  else
    state.last_explicit_title = nil
    state.explicit_title_cwd = nil
  end

  return padded_title(title, max_width)
end)

-- Tab title logic End --

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Ayu Light (Gogh)"
-- config.color_scheme = "Catppuccin Latte"

config.use_fancy_tab_bar = false
config.tab_max_width = 32

config.enable_wayland = false

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
      strikethrough = false
    },
    inactive_tab = {
      bg_color = '#F8F9FA',
      fg_color = '#c0c0c0'

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab`.
    },
    background = '#F8F9FA',
    new_tab = { bg_color = '#F8F9FA', fg_color = '#808080' }
  }
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

config.window_background_opacity = .8

-- and finally, return the configuration to wezterm
return config
