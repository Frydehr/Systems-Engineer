<#
.SYNOPSIS
    Emails a specific file (like a daily log) as an attachment.
#>
param(
    [string]$FilePath = "C:\Logs\DailyReport.csv",
    [string]$To = "manager@contoso.com"
)
if (Test-Path $FilePath) {
    Send-MailMessage -To $To -From "reports@contoso.com" -Subject "Daily Log Export" -Body "Please find the attached log file." -Attachments $FilePath -SmtpServer "smtp.contoso.com"
} else {
    Write-Error "File not found: $FilePath"
}
