#!/usr/bin/env bash

set -euo pipefail

videos_dir="${HOME}/Videos"

notify() {
  if command -v notify-send >/dev/null 2>&1; then
    notify-send "$@"
  fi
}

refresh_waybar() {
  pkill -RTMIN+8 waybar >/dev/null 2>&1 || true
}

if pgrep -x wf-recorder >/dev/null; then
  pkill -INT -x wf-recorder
  exit 0
fi

mkdir -p "$videos_dir"

geometry="$(slurp)" || exit 0
recording_file="${videos_dir}/recording_$(date +%Y%m%d_%H%M%S).mp4"

wf-recorder -a -g "$geometry" -f "$recording_file" &
recorder_pid=$!

sleep 0.2
refresh_waybar

set +e
wait "$recorder_pid"
recorder_status=$?
set -e

refresh_waybar

if [[ -f "$recording_file" ]]; then
  notify "Recording saved" "$recording_file"
fi

exit "$recorder_status"
