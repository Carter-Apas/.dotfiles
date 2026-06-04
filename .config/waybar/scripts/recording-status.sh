#!/usr/bin/env bash

set -euo pipefail

if ! pgrep -x wf-recorder >/dev/null; then
  exit 1
fi

printf '%s\n' '{"text":"●","alt":"recording","class":["recording"],"tooltip":"Recording"}'
