#!/usr/bin/env python3
import json
import os
import subprocess
import sys
from pathlib import Path


DEFAULT_PROJECT = "codex"
EVENT_STATUS = {
    "SessionStart": ("🟢", ""),
    "UserPromptSubmit": ("🟠", ""),
    "Stop": ("🟢", ""),
}


def load_payload() -> dict:
    raw = sys.stdin.read().strip()
    if not raw:
        return {}

    try:
        data = json.loads(raw)
    except json.JSONDecodeError:
        return {}

    return data if isinstance(data, dict) else {}


def project_name(payload: dict) -> str:
    cwd = str(payload.get("cwd") or "").strip()
    if not cwd:
        return DEFAULT_PROJECT

    name = Path(cwd).name.strip()
    return name or DEFAULT_PROJECT


def run_git(args: list[str], cwd: str) -> str:
    if not cwd:
        return ""

    try:
        result = subprocess.run(
            ["git", *args],
            check=False,
            cwd=cwd,
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True,
        )
    except OSError:
        return ""

    if result.returncode != 0:
        return ""

    return result.stdout.strip()


def repo_name_from_remote(remote_url: str) -> str:
    remote_url = remote_url.strip()
    if not remote_url:
        return ""

    name = remote_url.rsplit("/", 1)[-1]
    name = name.rsplit(":", 1)[-1]
    if name.endswith(".git"):
        name = name[:-4]
    return name.strip()


def project_label(payload: dict) -> str:
    cwd = str(payload.get("cwd") or "").strip()
    fallback = project_name(payload)
    if not cwd:
        return fallback

    repo = repo_name_from_remote(run_git(["remote", "get-url", "origin"], cwd))
    branch = run_git(["rev-parse", "--abbrev-ref", "HEAD"], cwd)

    if repo and branch:
        return f"{repo}:{branch}"

    if repo:
        return repo

    return fallback


def set_tab_title(title: str) -> None:
    cmd = ["wezterm", "cli", "set-tab-title"]
    pane_id = os.environ.get("WEZTERM_PANE", "").strip()
    if pane_id and pane_id != "0":
        cmd.extend(["--pane-id", pane_id])
    cmd.append(title)
    subprocess.run(
        cmd, check=False, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
    )


def send_desktop_notification(payload: dict) -> None:
    if payload.get("hook_event_name") != "Stop":
        return

    message = str(payload.get("last_assistant_message") or "Turn complete").strip()
    if not message:
        message = "Turn complete"

    subprocess.run(
        ["notify-send", "Agent Update", message],
        check=False,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )


def main() -> int:
    payload = load_payload()
    event = str(payload.get("hook_event_name") or "").strip()
    status = EVENT_STATUS.get(event)
    if not status:
        return 0

    project = project_label(payload)
    state, marker = status
    title = f"{project}: {state}"
    if marker:
        title = f"{marker} {title}"

    set_tab_title(title)
    send_desktop_notification(payload)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
