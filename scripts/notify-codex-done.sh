#!/usr/bin/env sh
set -eu

REASON="${1:-done}"
MESSAGE="${2:-}"

if [ -z "$MESSAGE" ]; then
  if [ "$REASON" = "approval" ]; then
    MESSAGE="Codex needs your approval."
  else
    MESSAGE="Codex task complete."
  fi
fi

osascript -e "display notification \"$MESSAGE\" with title \"Codex\""
printf '%s\n' "$MESSAGE"
