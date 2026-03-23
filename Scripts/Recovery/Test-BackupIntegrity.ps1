<#
.SYNOPSIS
    Validates that backup files are recent and have a non-zero file size.
#>
param (
    [Parameter(Mandatory=$true)][string]$BackupPath,
    [int]$MaxAgeDays = 1
)

$Files = Get-ChildItem -Path $BackupPath -Include *.bak, *.zip, *.vhdx -Recurse
$Results = foreach ($File in $Files) {
    $IsRecent = $File.LastWriteTime -gt (Get-Date).AddDays(-$MaxAgeDays)
    $IsNotEmpty = $File.Length -gt 0

    [PSCustomObject]@{
        FileName   = $File.Name
        LastSync   = $File.LastWriteTime
        SizeMB     = [Math]::Round($File.Length / 1MB, 2)
        Status     = if ($IsRecent -and $IsNotEmpty) { "✅ Healthy" } else { "❌ Critical: Check Logs" }
    }
}

$Results | Out-GridView -Title "Backup Integrity Report"
