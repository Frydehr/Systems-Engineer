<#
.SYNOPSIS
    Sends a high-priority email alert with "CRITICAL" formatting.
#>
param([string]$ErrorMessage)
$Params = @{
    To = "oncall@contoso.com"
    From = "alerts@contoso.com"
    Subject = "!!! CRITICAL SYSTEM ALERT !!!"
    Body = "The following error occurred at $(Get-Date): `n`n $ErrorMessage"
    Priority = "High"
    SmtpServer = "smtp.contoso.com"
}
Send-MailMessage @Params
Write-Host "Critical Alert Sent." -ForegroundColor Red
