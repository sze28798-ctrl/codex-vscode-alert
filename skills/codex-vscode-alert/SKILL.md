---
name: codex-vscode-alert
description: Use when installing, configuring, or troubleshooting Codex VS Code taskbar alerts, command-approval alerts, task-completion reminders, or the codex-vscode-alert scripts.
---

# Codex VS Code Alert

Use this skill only for setup, migration, or troubleshooting. Daily task-completion and command-approval reminders are enforced by the user's global `AGENTS.md` after installation.

## Install

Windows:

```powershell
.\scripts\install.ps1
```

macOS:

```sh
./scripts/install.sh
```

The installer copies scripts to `~/.codex/tools/codex-vscode-alert`, copies this skill to `~/.codex/skills/codex-vscode-alert`, and updates `~/.codex/AGENTS.md` inside a protected `BEGIN/END codex-vscode-alert` block.

## Manual Commands

Windows task complete:

```powershell
~/.codex/tools/codex-vscode-alert/scripts/notify-codex-done.ps1 -Reason done
```

Windows approval needed:

```powershell
~/.codex/tools/codex-vscode-alert/scripts/notify-codex-done.ps1 -Reason approval
```

macOS task complete:

```sh
~/.codex/tools/codex-vscode-alert/scripts/notify-codex-done.sh done
```

macOS approval needed:

```sh
~/.codex/tools/codex-vscode-alert/scripts/notify-codex-done.sh approval
```

## Troubleshooting

- If Windows does not flash, run `scripts/flash-vscode.ps1 -Count 3` while VS Code is in the background.
- If macOS does not show an alert, verify notifications are enabled for the terminal app running Codex.
- If new Codex sessions do not remind, inspect `~/.codex/AGENTS.md` and confirm the protected block exists.
- If the skill does not appear, restart Codex after installation.
