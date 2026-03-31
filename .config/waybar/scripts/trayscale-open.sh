#!/usr/bin/env bash

set -eu

if hyprctl clients | rg -q '^\s*class: dev\.deedles\.Trayscale$'; then
  hyprctl dispatch focuswindow 'class:^(dev\.deedles\.Trayscale)$' >/dev/null 2>&1
  exit 0
fi

if pgrep -x trayscale >/dev/null 2>&1; then
  item_service="$(
    busctl --user list | awk '
      $1 ~ /^org\.freedesktop\.StatusNotifierItem-/ && $0 ~ /trayscale/ {
        print $1
        exit
      }
    '
  )"

  if [ -n "$item_service" ]; then
    busctl --user call \
      "$item_service" \
      /StatusNotifierItem \
      org.kde.StatusNotifierItem \
      Activate \
      ii 0 0 >/dev/null 2>&1
    exit 0
  fi
fi

trayscale >/dev/null 2>&1 &
