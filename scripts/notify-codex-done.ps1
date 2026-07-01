param(
    [ValidateSet("done", "approval")]
    [string]$Reason = "done",
    [string]$Message = "",
    [int]$Count = 8
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($Message)) {
    if ($Reason -eq "approval") {
        $Message = "Codex needs your approval."
    } else {
        $Message = "Codex task complete."
    }
}

$flashScript = Join-Path $PSScriptRoot "flash-vscode.ps1"
& $flashScript -Count $Count
Write-Host $Message
