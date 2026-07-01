---
name: codex-vscode-alert
description: Use when installing, configuring, or troubleshooting Codex VS Code taskbar alerts, command-approval alerts, task-completion reminders, or the codex-vscode-alert scripts.
---

# Codex VS Code Alert

Use this skill only for setup, migration, or troubleshooting. Daily task-completion and command-approval reminders are enforced by the user's global `AGENTS.md` after installation.

## Install

Windows Local:

```powershell
.\scripts\install.ps1
```

macOS Local:

```sh
./scripts/install.sh
```

VS Code Remote SSH: Windows Client + Linux Server:

```powershell
.\scripts\start-windows-listener.ps1
.\scripts\start-remote-ssh-tunnel.ps1 -RemoteHost your-ssh-host
```

```sh
./scripts/install-remote-ssh-linux.sh
```

The local installers copy scripts to `~/.codex/tools/codex-vscode-alert`, copy this skill to `~/.codex/skills/codex-vscode-alert`, and update `~/.codex/AGENTS.md` inside a protected `BEGIN/END codex-vscode-alert` block. The remote SSH Linux installer configures the remote Linux trigger; the Windows listener and SSH reverse tunnel must be running locally for the remote trigger to flash the Windows VS Code taskbar icon.

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

Remote SSH Linux task complete:

```sh
~/.codex/tools/codex-vscode-alert/scripts/notify-remote-ssh-linux.sh done
```

Remote SSH Linux approval needed:

```sh
~/.codex/tools/codex-vscode-alert/scripts/notify-remote-ssh-linux.sh approval
```

## Troubleshooting

- If Windows does not flash, run `scripts/flash-vscode.ps1 -Count 3` while VS Code is in the background.
- If macOS does not show an alert, verify notifications are enabled for the terminal app running Codex.
- If Remote SSH does not flash Windows, confirm `scripts/start-windows-listener.ps1` and `scripts/start-remote-ssh-tunnel.ps1 -RemoteHost your-ssh-host` are both running on Windows.
- If new Codex sessions do not remind, inspect `~/.codex/AGENTS.md` and confirm the protected block exists.
- If the skill does not appear, restart Codex after installation.
