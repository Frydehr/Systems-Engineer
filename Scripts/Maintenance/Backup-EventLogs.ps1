<#
.SYNOPSIS
    Exports and clears System and Application event logs.
#>
$BackupDir = "C:\Maintenance\LogBackups\$(Get-Date -Format 'yyyy-MM-dd')"
if (!(Test-Path $BackupDir)) { New-Item -ItemType Directory -Path $BackupDir | Out-Null }

$Logs = @("System", "Application")

foreach ($Log in $Logs) {
    $Path = "$BackupDir\$Log.evtx"
    Write-Host "Exporting $Log log to $Path..." -ForegroundColor Cyan
    
    # Exporting
    Get-WinEvent -ListLog $Log | ForEach-Object { $_.ClearLog($Path) }
}

Write-Host "Logs backed up and cleared." -ForegroundColor Green
