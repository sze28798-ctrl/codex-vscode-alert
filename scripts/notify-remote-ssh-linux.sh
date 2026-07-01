#!/usr/bin/env sh
set -eu

REASON="${1:-done}"
MESSAGE="${2:-}"
ALERT_URL="${CODEX_VSCODE_ALERT_URL:-http://127.0.0.1:37991/notify}"

if [ -z "$MESSAGE" ]; then
  if [ "$REASON" = "approval" ]; then
    MESSAGE="Codex needs your approval."
  else
    MESSAGE="Codex task complete."
  fi
fi

if ! command -v curl >/dev/null 2>&1; then
  printf 'curl is required to notify the local Windows listener.\n' >&2
  exit 1
fi

json_escape() {
  JSON_VALUE=$1 awk '
    BEGIN {
      s = ENVIRON["JSON_VALUE"]
      for (i = 1; i <= length(s); i++) {
        c = substr(s, i, 1)
        if (c == "\\") {
          printf "\\\\"
        } else if (c == "\"") {
          printf "\\\""
        } else if (c == "\r") {
          printf "\\r"
        } else if (c == "\n") {
          printf "\\n"
        } else if (c == "\t") {
          printf "\\t"
        } else {
          printf "%s", c
        }
      }
    }
  '
}

payload=$(printf '{"reason":"%s","message":"%s"}' "$(json_escape "$REASON")" "$(json_escape "$MESSAGE")")

if curl --fail --silent --show-error \
  --request POST \
  --header 'Content-Type: application/json' \
  --data "$payload" \
  "$ALERT_URL" >/dev/null; then
  printf '%s\n' "$MESSAGE"
else
  printf 'Could not reach Agent VS Code Alert listener at %s.\n' "$ALERT_URL" >&2
  printf 'Start the Windows listener and SSH reverse tunnel, then try again.\n' >&2
  exit 1
fi
