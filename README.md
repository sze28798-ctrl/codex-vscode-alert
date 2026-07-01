# Agent VS Code Alert

Lightweight reminders for AI coding agents when a task completes or a command needs approval.

- Windows: flashes the VS Code taskbar icon with `FlashWindowEx`.
- macOS: shows a system notification through `osascript`.
- Agents: call the notification scripts from their own global instruction, rule, hook, or lifecycle system.
- Codex support is included through a global `~/.codex/AGENTS.md` rule and an optional setup/troubleshooting skill.

No VS Code extension is required.

## Install

### Ask an Agent to Install

Open your coding agent in any folder and say:

```text
Install Agent VS Code Alert from https://github.com/sze28798-ctrl/codex-vscode-alert.

Clone the repository, run the correct installer for my operating system, and configure my agent so future task-completion and command-approval reminders run globally.
```

The agent should clone this repository, run `scripts/install.ps1` on Windows or `scripts/install.sh` on macOS, then add the reminder commands to its global instruction, rule, hook, or lifecycle configuration.

For Codex, the installer handles this automatically by adding a protected `codex-vscode-alert` block to `~/.codex/AGENTS.md`. For other agents, use the equivalent global instruction:

```text
When finishing a task, run the installed notify-codex-done script with the task-complete reason.
Before requesting command approval, run the installed notify-codex-done script with the approval reason.
```

The exact global-instruction file depends on the agent. The notification scripts themselves are not Codex-specific.

### Manual Install

Windows:

```powershell
git clone https://github.com/sze28798-ctrl/codex-vscode-alert.git
cd codex-vscode-alert
.\scripts\install.ps1
```

macOS:

```sh
git clone https://github.com/sze28798-ctrl/codex-vscode-alert.git
cd codex-vscode-alert
./scripts/install.sh
```

The installer:

- copies scripts to `~/.codex/tools/codex-vscode-alert/scripts`;
- copies the skill to `~/.codex/skills/codex-vscode-alert`;
- adds or updates a protected `codex-vscode-alert` block in `~/.codex/AGENTS.md`.

For Codex, restart after installing so it reloads global instructions and skills. For other agents, reload whatever global configuration mechanism that agent uses.

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

For Codex, `$codex-vscode-alert` is available after install for setup, migration, and troubleshooting. It is not intended to run on every task; the agent's global instruction or hook carries the recurring reminder rule.

## Test

```sh
npm test
```
