# Agent VS Code Alert

Lightweight reminders for AI coding agents when a task completes or a command needs approval.

- Windows Local: flashes the VS Code taskbar icon with `FlashWindowEx`.
- macOS Local: shows a system notification through `osascript`.
- VS Code Remote SSH: Windows Client + Linux Server: a remote Linux trigger calls a local Windows listener through an SSH reverse tunnel, then the Windows listener flashes VS Code.
- Agents: call the notification scripts from their own global instruction, rule, hook, or lifecycle system.
- Codex support is included through a global `~/.codex/AGENTS.md` rule and an optional setup/troubleshooting skill.

No VS Code extension is required.

## Install With Your Agent

### Ask an Agent to Install

Open your coding agent and say:

```text
Install Agent VS Code Alert from https://github.com/sze28798-ctrl/codex-vscode-alert.

First detect my environment:

1. If the agent is running on Windows, install the Windows local version.
2. If the agent is running on macOS, install the macOS local version.
3. If the agent is running on a remote Linux server through VS Code Remote SSH, install the remote Linux trigger and tell me to run the local Windows listener and SSH reverse tunnel on my PC.

After installation, configure my agent's global instruction, rule, hook, or lifecycle config so it reminds me when:
- a task is complete;
- command approval is required.
```

The agent should clone this repository, run the installer that matches the setup, then add the reminder commands to its global instruction, rule, hook, or lifecycle configuration.

For Codex, the installers update `~/.codex/AGENTS.md` automatically. For other agents, use the equivalent global instruction:

```text
When finishing a task, run the installed notify script with the task-complete reason.
Before requesting command approval, run the installed notify script with the approval reason.
```

The exact global-instruction file depends on the agent. The notification scripts themselves are not Codex-specific.

## Supported Setups

### Windows Local

Use this when your agent runs on the same Windows machine as VS Code.

Behavior: flashes the local VS Code taskbar icon.

Installer:

```powershell
git clone https://github.com/sze28798-ctrl/codex-vscode-alert.git
cd codex-vscode-alert
.\scripts\install.ps1
```

Manual trigger:

```powershell
.\scripts\notify-codex-done.ps1 -Reason done
.\scripts\notify-codex-done.ps1 -Reason approval
```

### macOS Local

Use this when your agent runs on the same Mac as VS Code.

Behavior: shows a macOS notification.

Installer:

```sh
git clone https://github.com/sze28798-ctrl/codex-vscode-alert.git
cd codex-vscode-alert
./scripts/install.sh
```

Manual trigger:

```sh
./scripts/notify-codex-done.sh done
./scripts/notify-codex-done.sh approval
```

### VS Code Remote SSH: Windows Client + Linux Server

Use this when VS Code is open on your Windows PC, but the agent runs inside a Linux server through Remote SSH.

Behavior: the Linux agent sends a reminder to a local Windows listener through an SSH reverse tunnel, and the local Windows listener flashes the VS Code taskbar icon.

This setup needs two parts.

On the Windows PC, start the listener:

```powershell
cd codex-vscode-alert
.\scripts\start-windows-listener.ps1
```

In another Windows terminal, open a reverse tunnel to the Linux host used by VS Code Remote SSH:

```powershell
cd codex-vscode-alert
.\scripts\start-remote-ssh-tunnel.ps1 -RemoteHost your-ssh-host
```

On the remote Linux server, install the remote Linux trigger:

```sh
git clone https://github.com/sze28798-ctrl/codex-vscode-alert.git
cd codex-vscode-alert
./scripts/install-remote-ssh-linux.sh
```

Manual remote trigger:

```sh
./scripts/notify-remote-ssh-linux.sh done
./scripts/notify-remote-ssh-linux.sh approval
```

The remote Linux server cannot directly flash the Windows taskbar. The listener and reverse tunnel are what connect the remote agent back to your local VS Code window.

## What the Installers Do

The local Windows and macOS installers:

- copy scripts to `~/.codex/tools/codex-vscode-alert/scripts`;
- copy the skill to `~/.codex/skills/codex-vscode-alert`;
- add or update a protected `codex-vscode-alert` block in `~/.codex/AGENTS.md`.

The Remote SSH Linux installer:

- copies `notify-remote-ssh-linux.sh` to `~/.codex/tools/codex-vscode-alert/scripts`;
- copies the skill to `~/.codex/skills/codex-vscode-alert`;
- adds or updates a protected `codex-vscode-alert` block in the remote server's `~/.codex/AGENTS.md`.

For Codex, restart after installing so it reloads global instructions and skills. For other agents, reload whatever global configuration mechanism that agent uses.

## Skill

For Codex, `$codex-vscode-alert` is available after install for setup, migration, and troubleshooting. It is not intended to run on every task; the agent's global instruction or hook carries the recurring reminder rule.

## Test

```sh
npm test
```
