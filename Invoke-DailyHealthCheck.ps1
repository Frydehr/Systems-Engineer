<#
.SYNOPSIS
    The Master Controller for the Enterprise Systems Engineering Toolkit.
.DESCRIPTION
    Orchestrates sub-module scripts, aggregates health data, and generates 
    a unified status report.
#>

# 1. Initialization & Config Loading
$ConfigPath = Join-Path $PSScriptRoot "configs\settings.json"
$ServerPath = Join-Path $PSScriptRoot "configs\servers.txt"

if (Test-Path $ConfigPath) {
    $Settings = Get-Content $ConfigPath | ConvertFrom-Json
    $Servers  = Get-Content $ServerPath
    Write-Host "--- [ $($Settings.GlobalSettings.CompanyName) Health Check ] ---" -ForegroundColor Cyan
} else {
    Write-Error "Configuration missing at $ConfigPath. Exiting."
    return
}

# 2. Results Container
$MasterReport = @()

# 3. Execution Loop
foreach ($Server in $Servers) {
    Write-Host "Checking: $Server..." -ForegroundColor Gray
    
    if (Test-Connection -ComputerName $Server -Count 1 -Quiet) {
        
        # Call the Uptime Script (Adjust path if needed)
        # We capture the output object directly into our report
        $Uptime = & "$PSScriptRoot\scripts\maintenance\Test-ServerUptime.ps1" -ComputerName $Server -MaxDays $Settings.Infrastructure.LowDiskThresholdGB
        $MasterReport += $Uptime

    } else {
        # Handle Offline Servers gracefully
        $MasterReport += [PSCustomObject]@{
            ComputerName = $Server
            UptimeDays   = "N/A"
            Pass         = $false
            Status       = "OFFLINE"
        }
    }
}

# 4. Generate Simple HTML Summary (Basic Version)
$Header = "<style>
    body { font-family: Calibri, sans-serif; }
    table { border-collapse: collapse; width: 100%; }
    th { background-color: #0078D4; color: white; padding: 8px; }
    td { border: 1px solid #ddd; padding: 8px; }
    .False { color: red; font-weight: bold; }
    .True { color: green; }
</style>"

$HtmlBody = $MasterReport | ConvertTo-Html -Head $Header -PreContent "<h2>Daily Infrastructure Health Report</h2>"

# 5. Send Notification (If configured)
if ($Settings.EmailSettings.SmtpServer -ne "smtp.yourserver.com") {
    Write-Host "Sending Report to $($Settings.EmailSettings.ToAddress)..." -ForegroundColor Green
    # Send-MailMessage -To $Settings.EmailSettings.ToAddress -From $Settings.EmailSettings.FromAddress -Subject "Daily Health Check" -Body $HtmlBody -BodyAsHtml -SmtpServer $Settings.EmailSettings.SmtpServer
} else {
    # If no SMTP is set up yet, save to logs folder instead
    $LogFile = Join-Path $PSScriptRoot "logs\HealthReport_$(Get-Date -Format 'yyyyMMdd').html"
    $HtmlBody | Out-File $LogFile
    Write-Host "Email not configured. Report saved to: $LogFile" -ForegroundColor Yellow
}

Write-Host "Health Check Complete." -ForegroundColor Cyan
