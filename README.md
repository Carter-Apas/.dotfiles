# Dotfiles

Managed with GNU STOW

`cd .dotfiles`

`stow .`

Desktop appearance: after stowing, run `~/.local/bin/theme apply` once to
initialize the desktop palettes. Fish already adds `~/.local/bin` to PATH;
add it to PATH if you use another shell.

- `theme dark` — Ayu Mirage across WezTerm, Neovim, Waybar, Rofi, Dunst, and Hyprland.
- `theme light` — restore the existing Ayu light themes.
- `theme toggle` — switch between them.
- `theme status` — print the system appearance.
- `theme apply` — apply palettes for the current system appearance.
- `theme render` — generate palettes without reloading applications.
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

Desktop colours are defined in `~/.config/desktop-theme/palettes/light.sh` and
`dark.sh`, with shared colours in `common.sh`. Edit these files to change colours
across Waybar, Rofi, Dunst, and Hyprland, then run `theme apply`. Palette roles can
reference earlier values, such as `yellow="$accent"`, to keep them in sync.
The palette files are trusted Bash configuration, compatible with Bash 3.2 on macOS.

The theme command fills the `{{role}}` placeholders in `desktop-theme/templates/`
and writes app-specific files to `desktop-theme/current/`. The templates contain
the mappings and formats; the palettes contain the colour values. Existing
differences, such as Rofi's light-mode blue accent, have their own palette roles.
WezTerm and Neovim continue to use their installed Ayu themes.

Hyprland loads its generated Lua palette, generating the imports on first launch
if needed. Switching reloads Waybar, Dunst, and Hyprland, and requests WezTerm's
normal config reload. Dunst's layout and timeouts live in `dunst/dunstrc`; its
generated palette also gives WezTerm notifications normal styling and a 10-second
timeout, overriding WezTerm's critical/never-expire defaults.

Applications with their own theme settings may need to follow the system or be
restarted. After changing appearance outside the command, use `theme apply` to
refresh the desktop palettes, or log in again. Runtime palette files live in
`~/.config/desktop-theme/current/` (or under `XDG_CONFIG_HOME`) and are ignored by
Git. Rofi, Waybar, Dunst, and Hyprland are Linux-only.

To check palette rendering and Linux/macOS switching without changing the desktop,
run `python3 -m unittest discover -s ~/.config/desktop-theme/tests`.

For NVIM installation on remote server (debian based)
  - Clone repo in home dir
  - chmod +x ./.dotfiles/.install-scripts/install-nvim.sh
  - sudo ./.dotfiles/.install-scripts/install-nvim.sh

