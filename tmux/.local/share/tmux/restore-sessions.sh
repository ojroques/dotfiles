#!/usr/bin/env zsh

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/tmux"
SESSION_FILE="$STATE_DIR/sessions.csv"
DELIMITER=":"

if [[ ! -r "$SESSION_FILE" ]]; then
  exit 0
fi

while IFS="$DELIMITER" read -r session_name _; do
  if tmux has-session -t "$session_name" 2>/dev/null; then
    tmux kill-session -t "$session_name"
  fi
done < "$SESSION_FILE"

while IFS="$DELIMITER" read -r session_name _ start_directory; do
  if [[ -d "$start_directory" ]]; then
    if ! tmux has-session -t "$session_name" 2>/dev/null; then
      tmux new-session -d -s "$session_name" -c "$start_directory"
    else
      tmux new-window -t "$session_name" -c "$start_directory"
    fi
  fi
done < "$SESSION_FILE"
