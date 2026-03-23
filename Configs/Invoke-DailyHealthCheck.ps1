# 1. Init
$Config = Get-Content "$PSScriptRoot\configs\settings.json" | ConvertFrom-Json
$Servers = Get-Content "$PSScriptRoot\configs\servers.txt"
$MasterReport = @()

# 2 & 3. Connect and Execute
foreach ($Server in $Servers) {
    if (Test-Connection -ComputerName $Server -Count 1 -Quiet) {
        
        # Run the Uptime Test we beefed up
        $UptimeResult = .\scripts\maintenance\Test-ServerUptime.ps1 -ComputerName $Server -MaxDays $Config.Infrastructure.MaxUptime
        $MasterReport += $UptimeResult

    } else {
        # Handle Offline Servers
        $MasterReport += [PSCustomObject]@{
            ComputerName = $Server
            Status       = "OFFLINE"
            Pass         = $false
        }
    }
}

# 4. Process (Convert to HTML Table)
$HtmlBody = $MasterReport | ConvertTo-Html -Fragment

# 5. Notify
# (Logic to send email using $Config.EmailSettings)
