#!/usr/bin/env bash

set -euo pipefail

state_dir="${XDG_CACHE_HOME:-$HOME/.cache}/waybar"
mkdir -p "$state_dir"

root_source="$(findmnt -no SOURCE / 2>/dev/null || true)"
device=""

if [[ "$root_source" == /dev/* ]]; then
  path="$root_source"
  while [[ -n "$path" && -e "$path" ]]; do
    name="$(lsblk -ndo NAME "$path" 2>/dev/null | head -n 1 || true)"
    parent="$(lsblk -ndo PKNAME "$path" 2>/dev/null | head -n 1 || true)"

    if [[ -z "$parent" ]]; then
      device="$name"
      break
    fi

    path="/dev/$parent"
  done
fi

if [[ -z "$device" ]]; then
  device="$(basename "$root_source")"
fi

read_stats() {
  awk -v device="$device" '$3 == device { print $6, $10, $13; exit }' /proc/diskstats
}

stats="$(read_stats)"
if [[ -z "$stats" ]]; then
  printf '%s\n' '{"text":"  n/a","tooltip":"Disk activity unavailable"}'
  exit 0
fi

read -r read_sectors written_sectors io_ms <<<"$stats"
now_ms="$(date +%s%3N)"
state_file="$state_dir/disk-io-$device.state"

if [[ -r "$state_file" ]]; then
  read -r prev_time prev_read_sectors prev_written_sectors prev_io_ms <"$state_file" || true
else
  prev_time="$now_ms"
  prev_read_sectors="$read_sectors"
  prev_written_sectors="$written_sectors"
  prev_io_ms="$io_ms"
fi

printf '%s %s %s %s\n' "$now_ms" "$read_sectors" "$written_sectors" "$io_ms" >"$state_file"

elapsed_ms=$((now_ms - prev_time))
if (( elapsed_ms <= 0 )); then
  elapsed_ms=1
fi

read_delta=$((read_sectors - prev_read_sectors))
write_delta=$((written_sectors - prev_written_sectors))
io_delta=$((io_ms - prev_io_ms))

if (( read_delta < 0 )); then
  read_delta=0
fi

if (( write_delta < 0 )); then
  write_delta=0
fi

if (( io_delta < 0 )); then
  io_delta=0
fi

awk \
  -v device="$device" \
  -v elapsed_ms="$elapsed_ms" \
  -v read_delta="$read_delta" \
  -v write_delta="$write_delta" \
  -v io_delta="$io_delta" \
  'BEGIN {
    busy = (io_delta / elapsed_ms) * 100
    if (busy > 100) busy = 100

    read_mib = (read_delta * 512) / 1048576 / (elapsed_ms / 1000)
    write_mib = (write_delta * 512) / 1048576 / (elapsed_ms / 1000)

    printf "{\"text\":\"󰓅  %.0f%%\",\"tooltip\":\"Disk activity on %s\\nRead: %.1f MiB/s\\nWrite: %.1f MiB/s\"}\n", busy, device, read_mib, write_mib
  }'
