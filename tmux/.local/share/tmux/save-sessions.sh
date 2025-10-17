#!/usr/bin/env zsh

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/tmux"
SESSION_FILE="$STATE_DIR/sessions.csv"
DELIMITER=":"

mkdir -p "$STATE_DIR"

if tmux has-session 2>/dev/null; then
  tmux list-windows -a -F "#S${DELIMITER}#W${DELIMITER}#{pane_current_path}" > "$SESSION_FILE"
fi
