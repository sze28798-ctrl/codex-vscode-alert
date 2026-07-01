param(
    [int]$Count = 8
)

$ErrorActionPreference = "Stop"

Add-Type @"
using System;
using System.Text;
using System.Runtime.InteropServices;

public static class TaskbarFlash {
    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

    [StructLayout(LayoutKind.Sequential)]
    public struct FLASHWINFO {
        public UInt32 cbSize;
        public IntPtr hwnd;
        public UInt32 dwFlags;
        public UInt32 uCount;
        public UInt32 dwTimeout;
    }

    [DllImport("user32.dll")]
    public static extern bool FlashWindowEx(ref FLASHWINFO pwfi);

    [DllImport("user32.dll")]
    public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);

    [DllImport("user32.dll")]
    public static extern bool IsWindowVisible(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint processId);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern int GetWindowTextLength(IntPtr hWnd);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder text, int count);

    public const UInt32 FLASHW_ALL = 3;
    public const UInt32 FLASHW_TIMERNOFG = 12;
}
"@

$targetProcesses = @{}
Get-Process -ErrorAction SilentlyContinue |
    Where-Object { $_.ProcessName -in @("Code", "Code - Insiders", "VSCodium", "Cursor") } |
    ForEach-Object { $targetProcesses[[uint32]$_.Id] = $_.ProcessName }

$windowHandles = New-Object System.Collections.Generic.List[IntPtr]

$callback = [TaskbarFlash+EnumWindowsProc]{
    param([IntPtr]$hWnd, [IntPtr]$lParam)

    if (-not [TaskbarFlash]::IsWindowVisible($hWnd)) {
        return $true
    }

    $titleLength = [TaskbarFlash]::GetWindowTextLength($hWnd)
    if ($titleLength -le 0) {
        return $true
    }

    [uint32]$processId = 0
    [TaskbarFlash]::GetWindowThreadProcessId($hWnd, [ref]$processId) | Out-Null
    if ($targetProcesses.ContainsKey($processId)) {
        $windowHandles.Add($hWnd)
    }

    return $true
}

[TaskbarFlash]::EnumWindows($callback, [IntPtr]::Zero) | Out-Null

foreach ($handle in $windowHandles) {
    $info = New-Object TaskbarFlash+FLASHWINFO
    $info.cbSize = [System.Runtime.InteropServices.Marshal]::SizeOf($info)
    $info.hwnd = $handle
    $info.dwFlags = [TaskbarFlash]::FLASHW_ALL -bor [TaskbarFlash]::FLASHW_TIMERNOFG
    $info.uCount = [uint32]$Count
    $info.dwTimeout = 0
    [TaskbarFlash]::FlashWindowEx([ref]$info) | Out-Null
}

Write-Host "Flashed $($windowHandles.Count) VS Code window(s)."
