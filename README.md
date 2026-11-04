# Dotfiles

Managed with GNU STOW

`cd .dotfiles`

`stow .`

Desktop appearance: after stowing, run `~/.local/bin/theme apply` once to
initialize the Waybar and Rofi palettes. Fish already adds `~/.local/bin` to PATH;
add it to PATH if you use another shell.

- `theme dark` — Ayu Mirage across WezTerm, Neovim, Waybar, and Rofi.
- `theme light` — restore the existing Ayu light themes.
- `theme toggle` — switch between them.
- `theme status` — print the system appearance.
- `theme apply` — apply palettes for the current system appearance.
- `theme menu` — open the appearance popup on Arch (requires Rofi).

On Hyprland, press **Super + Shift + T** or click **◐** in Waybar to open the
popup. Right-click the Waybar button to toggle directly.

The OS appearance is the source of truth: GNOME's `color-scheme` setting on Linux
(read and written with `gsettings`), or Apple's Dark Mode setting on macOS (via
`osascript`). There is no separate saved mode file. An unset/default Linux
preference uses the light palette.

WezTerm follows the system appearance through its native API. Neovim reads
`~/.local/bin/theme status` at startup and when OS appearance notifications arrive.
On Linux it uses `gsettings monitor`; on macOS a small CoreFoundation helper
listens for appearance notifications. Each Neovim instance owns one monitor
process and stops it on exit. There are no theme files to watch or polling loops.

The macOS helper needs Xcode Command Line Tools (`xcode-select --install`) for its
first build; the executable is cached under `~/.cache/nvim/` (or `XDG_CACHE_HOME`).
If monitoring is unavailable, the startup theme still applies. A remote Neovim
installation without the theme command falls back to light. Restart existing
Neovim sessions once after installing this integration.

Hyprland reads the GNOME preference when its configuration loads. Switching also
applies the Waybar/Rofi palettes, reloads Waybar and Hyprland, and requests
WezTerm's normal config reload.

Applications with their own theme settings may need to follow the system or be
restarted. After changing appearance outside the command, use `theme apply` to
refresh Waybar/Rofi, or log in again. Runtime palette files live in
`~/.config/desktop-theme/current/` (or under `XDG_CONFIG_HOME`) and are ignored by
Git. Rofi, Waybar, and Hyprland are Linux-only.

For NVIM installation on remote server (debian based)
  - Clone repo in home dir
  - chmod +x ./.dotfiles/.install-scripts/install-nvim.sh
  - sudo ./.dotfiles/.install-scripts/install-nvim.sh

