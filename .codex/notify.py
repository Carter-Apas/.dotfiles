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
    message = message or "Turn complete"
    if sys.platform == "darwin":
        # Pass notification text as data so quotes and newlines stay literal.
        command = [
            "osascript", "-e",
            "on run argv\n"
            "display notification (item 1 of argv) with title (item 2 of argv)\n"
            "end run",
            message, "Agent Update",
        ]
    else:
        command = ["notify-send", "--", "Agent Update", message]
    try:
        subprocess.run(
            command,
            check=False,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            timeout=3,
        )
    except (OSError, subprocess.TimeoutExpired):
        pass
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
