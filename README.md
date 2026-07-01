# Codex VS Code Alert

Lightweight Codex reminders for task completion and command approval.

- Windows: flashes the VS Code taskbar icon with `FlashWindowEx`.
- macOS: shows a system notification through `osascript`.
- Codex: installs a global `AGENTS.md` rule so future projects trigger reminders automatically.

No VS Code extension is required.

## Install

Windows:

```powershell
git clone https://github.com/<you>/codex-vscode-alert.git
cd codex-vscode-alert
.\scripts\install.ps1
```

macOS:

```sh
git clone https://github.com/<you>/codex-vscode-alert.git
cd codex-vscode-alert
./scripts/install.sh
```

The installer:

- copies scripts to `~/.codex/tools/codex-vscode-alert/scripts`;
- copies the skill to `~/.codex/skills/codex-vscode-alert`;
- adds or updates a protected `codex-vscode-alert` block in `~/.codex/AGENTS.md`.

Restart Codex after installing so it reloads global instructions and skills.

## Manual Use

Windows:

```powershell
.\scripts\notify-codex-done.ps1 -Reason done
.\scripts\notify-codex-done.ps1 -Reason approval
```

macOS:

```sh
./scripts/notify-codex-done.sh done
./scripts/notify-codex-done.sh approval
```

## Skill

After install, `$codex-vscode-alert` is available for setup, migration, and troubleshooting. It is not intended to run on every task; `AGENTS.md` carries the recurring reminder rule.

## Test

```sh
npm test
```
