#!/usr/bin/env sh
set -eu

CODEX_HOME_DIR="${CODEX_HOME:-"$HOME/.codex"}"
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
SOURCE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INSTALL_ROOT="$CODEX_HOME_DIR/tools/codex-vscode-alert"
SCRIPT_DEST="$INSTALL_ROOT/scripts"
SKILL_DEST="$CODEX_HOME_DIR/skills/codex-vscode-alert"
AGENTS_PATH="$CODEX_HOME_DIR/AGENTS.md"

mkdir -p "$SCRIPT_DEST" "$CODEX_HOME_DIR/skills"
cp "$SOURCE_ROOT/scripts/notify-codex-done.sh" "$SCRIPT_DEST/"
cp "$SOURCE_ROOT/scripts/notify-codex-done.ps1" "$SCRIPT_DEST/" 2>/dev/null || true
cp "$SOURCE_ROOT/scripts/flash-vscode.ps1" "$SCRIPT_DEST/" 2>/dev/null || true
rm -rf "$SKILL_DEST"
cp -R "$SOURCE_ROOT/skills/codex-vscode-alert" "$SKILL_DEST"

NOTIFY_SCRIPT="$SCRIPT_DEST/notify-codex-done.sh"
BLOCK="$(cat <<EOF
<!-- BEGIN codex-vscode-alert -->
## Codex VS Code Alert

When finishing a task, run:

\`\`\`sh
"$NOTIFY_SCRIPT" done
\`\`\`

Before requesting command approval, run:

\`\`\`sh
"$NOTIFY_SCRIPT" approval
\`\`\`
<!-- END codex-vscode-alert -->
EOF
)"

mkdir -p "$CODEX_HOME_DIR"
if [ ! -f "$AGENTS_PATH" ]; then
  printf '# Global Codex Instructions\n\n%s\n' "$BLOCK" > "$AGENTS_PATH"
elif grep -q '<!-- BEGIN codex-vscode-alert -->' "$AGENTS_PATH"; then
  awk -v block="$BLOCK" '
    /<!-- BEGIN codex-vscode-alert -->/ { print block; skip=1; next }
    /<!-- END codex-vscode-alert -->/ { skip=0; next }
    !skip { print }
  ' "$AGENTS_PATH" > "$AGENTS_PATH.tmp"
  mv "$AGENTS_PATH.tmp" "$AGENTS_PATH"
else
  printf '\n%s\n' "$BLOCK" >> "$AGENTS_PATH"
fi

chmod +x "$SCRIPT_DEST/notify-codex-done.sh"
printf 'Installed scripts to %s\n' "$SCRIPT_DEST"
printf 'Installed skill to %s\n' "$SKILL_DEST"
printf 'Updated %s\n' "$AGENTS_PATH"
