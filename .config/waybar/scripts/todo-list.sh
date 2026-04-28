#!/usr/bin/env bash

set -euo pipefail

TODO_FILE="${HOME}/todo.md"

ensure_todo_file() {
  if [[ -f "$TODO_FILE" ]]; then
    return
  fi

  cat >"$TODO_FILE" <<'EOF'
# Todo

- [ ] First task
EOF
}

print_status() {
  ensure_todo_file

  printf '{"text":"","tooltip":"Todo list\\n%s"}\n' "$TODO_FILE"
}

open_todo() {
  ensure_todo_file
  nohup wezterm start -- nvim "$TODO_FILE" >/dev/null 2>&1 &
}

case "${1:-status}" in
  status)
    print_status
    ;;
  open)
    open_todo
    ;;
  *)
    echo "usage: $0 [status|open]" >&2
    exit 1
    ;;
esac
