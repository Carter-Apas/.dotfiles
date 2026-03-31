#!/usr/bin/env bash

set -eu

if tailscale status --json 2>/dev/null | jq -rc '
  if .BackendState == "Running" and (.TailscaleIPs | length > 0) and (.Self.Online // false) then
    {
      text: " ",
      alt: "connected",
      class: ["connected"],
      tooltip: "Tailscale connected"
    }
  else
    {
      text: " ",
      alt: "disconnected",
      class: ["disconnected"],
      tooltip: "Tailscale disconnected"
    }
  end
'; then
  exit 0
fi

printf '%s\n' '{"text":" ","alt":"disconnected","class":["disconnected"],"tooltip":"Tailscale disconnected"}'
