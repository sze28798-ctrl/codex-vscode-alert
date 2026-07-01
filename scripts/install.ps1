param(
    [string]$CodexHome = "",
    [string]$SourceRoot = ""
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($CodexHome)) {
    if (-not [string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
        $CodexHome = $env:CODEX_HOME
    } else {
        $CodexHome = Join-Path $env:USERPROFILE ".codex"
    }
}

if ([string]::IsNullOrWhiteSpace($SourceRoot)) {
    $SourceRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

$installRoot = Join-Path $CodexHome "tools\codex-vscode-alert"
$scriptDest = Join-Path $installRoot "scripts"
$skillDest = Join-Path $CodexHome "skills\codex-vscode-alert"
$agentsPath = Join-Path $CodexHome "AGENTS.md"

New-Item -ItemType Directory -Force -Path $scriptDest | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $skillDest) | Out-Null

Copy-Item -Path (Join-Path $SourceRoot "scripts\notify-codex-done.ps1") -Destination $scriptDest -Force
Copy-Item -Path (Join-Path $SourceRoot "scripts\flash-vscode.ps1") -Destination $scriptDest -Force

if (Test-Path -Path $skillDest) {
    Remove-Item -Path $skillDest -Recurse -Force
}
Copy-Item -Path (Join-Path $SourceRoot "skills\codex-vscode-alert") -Destination $skillDest -Recurse -Force

$notifyScript = Join-Path $scriptDest "notify-codex-done.ps1"
$block = @"
<!-- BEGIN codex-vscode-alert -->
## Codex VS Code Alert

When finishing a task, run:

```powershell
& "$notifyScript" -Reason done
```

Before requesting command approval, run:

```powershell
& "$notifyScript" -Reason approval
```
<!-- END codex-vscode-alert -->
"@

New-Item -ItemType Directory -Force -Path $CodexHome | Out-Null
if (Test-Path -Path $agentsPath) {
    $agents = Get-Content -Raw -Path $agentsPath
} else {
    $agents = "# Global Codex Instructions`r`n"
}

$pattern = '(?s)<!-- BEGIN codex-vscode-alert -->.*?<!-- END codex-vscode-alert -->'
if ($agents -match $pattern) {
    $agents = [regex]::Replace($agents, $pattern, $block.Trim())
} else {
    $agents = $agents.TrimEnd() + "`r`n`r`n" + $block.Trim() + "`r`n"
}

Set-Content -Path $agentsPath -Value $agents -Encoding UTF8

Write-Host "Installed scripts to $scriptDest"
Write-Host "Installed skill to $skillDest"
Write-Host "Updated $agentsPath"
