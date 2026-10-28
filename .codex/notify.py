#!/usr/bin/env python3
"""Send desktop completion notifications; Codex manages terminal titles."""
import json
import subprocess
import sys


def load_payload() -> dict:
    raw = sys.stdin.read().strip()
    if not raw:
        return {}
    try:
        data = json.loads(raw)
    except json.JSONDecodeError:
        return {}
    return data if isinstance(data, dict) else {}


def main() -> int:
    payload = load_payload()
    if payload.get("hook_event_name") != "Stop":
        return 0

    message = str(payload.get("last_assistant_message") or "Turn complete").strip()
    try:
        subprocess.run(
            ["notify-send", "Agent Update", message or "Turn complete"],
            check=False,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            timeout=0.75,
        )
    except (OSError, subprocess.TimeoutExpired):
        pass
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
