<#
.SYNOPSIS
    Archives files older than a specified number of days to a ZIP file.
#>
param(
    [string]$SourcePath = "C:\Logs",
    [string]$DestinationPath = "C:\Archive",
    [int]$DaysOld = 90
)

$Threshold = (Get-Date).AddDays(-$DaysOld)
$FilesToArchive = Get-ChildItem -Path $SourcePath -File | Where-Object { $_.LastWriteTime -lt $Threshold }

if ($FilesToArchive) {
    $ArchiveName = "Archive_$(Get-Date -Format 'yyyyMMdd').zip"
    Compress-Archive -Path $FilesToArchive.FullName -DestinationPath "$DestinationPath\$ArchiveName" -Force
    $FilesToArchive | Remove-Item -Force
    Write-Host "Archived $($FilesToArchive.Count) files." -ForegroundColor Green
}
