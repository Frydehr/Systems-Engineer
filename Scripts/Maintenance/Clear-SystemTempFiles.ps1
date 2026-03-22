<#
.SYNOPSIS
    Cleans up temporary files and system caches to reclaim disk space.
#>
Write-Host "Starting System Cleanup..." -ForegroundColor Cyan

$TempTarget = @(
    "$env:TEMP\*",
    "C:\Windows\Temp\*",
    "C:\Windows\Prefetch\*",
    "C:\Users\*\AppData\Local\Microsoft\Windows\Explorer\thumbcache_*.db"
)

foreach ($Path in $TempTarget) {
    Write-Host "Cleaning $Path..." -ForegroundColor Gray
    Get-Item $Path -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host "Cleanup Complete." -ForegroundColor Green
