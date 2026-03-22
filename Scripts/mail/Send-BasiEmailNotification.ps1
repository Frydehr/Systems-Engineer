<#
.SYNOPSIS
    Sends a basic email notification via SMTP.

.DESCRIPTION
    A standardized script for sending automated alerts. 
    Note: Ensure your SMTP relay allows connections from this host.

.PARAMETER SmtpServer
    The FQDN or IP of your mail server.
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$SmtpServer = "smtp.yourserver.com",

    [Parameter(Mandatory=$true)]
    [string]$To,

    [Parameter(Mandatory=$true)]
    [string]$From,

    [Parameter(Mandatory=$true)]
    [string]$Subject,

    [Parameter(Mandatory=$false)]
    [string]$Body = "Default System Notification Body"
)

try {
    Write-Host "Attempting to send email to $To..." -ForegroundColor Cyan
    
    # Note: Send-MailMessage is deprecated; consider Graph API for M365 environments.
    Send-MailMessage -SmtpServer $SmtpServer `
                     -To $To `
                     -From $From `
                     -Subject $Subject `
                     -Body $Body `
                     -ErrorAction Stop

    Write-Host "Success: Message sent." -ForegroundColor Green
}
catch {
    Write-Error "Failed to send email. Error: $_"
}
