param(
    [int]$Port = 37991,
    [string]$HostName = "127.0.0.1"
)

$ErrorActionPreference = "Stop"

$prefix = "http://$HostName`:$Port/"
$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add($prefix)

Write-Host "Agent VS Code Alert listener is running at $prefix"
Write-Host "Press Ctrl+C to stop."

$listener.Start()

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        $reason = "done"
        if ($request.QueryString["reason"]) {
            $reason = $request.QueryString["reason"]
        }

        if ($request.HttpMethod -eq "POST" -and $request.HasEntityBody) {
            $reader = [System.IO.StreamReader]::new($request.InputStream, $request.ContentEncoding)
            try {
                $body = $reader.ReadToEnd()
                if ($body -match '"reason"\s*:\s*"([^"]+)"') {
                    $reason = $Matches[1]
                }
            } finally {
                $reader.Dispose()
            }
        }

        $notifyScript = Join-Path $PSScriptRoot "notify-codex-done.ps1"
        if (Test-Path -LiteralPath $notifyScript) {
            & $notifyScript -Reason $reason
        } else {
            $flashScript = Join-Path $PSScriptRoot "flash-vscode.ps1"
            & $flashScript
        }

        $message = "ok"
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($message)
        $response.StatusCode = 200
        $response.ContentType = "text/plain; charset=utf-8"
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
        $response.Close()
    }
} finally {
    if ($listener.IsListening) {
        $listener.Stop()
    }
    $listener.Close()
}
