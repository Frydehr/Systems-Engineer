<#
.SYNOPSIS
    Checks the number of messages waiting in the local SMTP pickup/queue folder.
#>
$QueuePath = "C:\inetpub\mailroot\Queue"
$Count = (Get-ChildItem $QueuePath).Count
if ($Count -gt 50) {
    Write-Warning "SMTP Queue is high: $Count messages pending."
} else {
    Write-Host "Mail Queue: $Count" -ForegroundColor Green
}
