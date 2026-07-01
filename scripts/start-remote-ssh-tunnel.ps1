param(
    [Parameter(Mandatory = $true)]
    [string]$RemoteHost,
    [int]$Port = 37991
)

$ErrorActionPreference = "Stop"

$remoteForward = "127.0.0.1:$Port`:127.0.0.1:$Port"

Write-Host "Opening SSH reverse tunnel:"
Write-Host "  remote 127.0.0.1:$Port -> local 127.0.0.1:$Port"
Write-Host "Keep this window open while the remote Linux agent is running."

ssh -N -R $remoteForward $RemoteHost
