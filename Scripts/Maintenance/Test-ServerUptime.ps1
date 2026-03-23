<#
.SYNOPSIS
    Reports system uptime for local or remote computers.
.DESCRIPTION
    Retrieves the last boot time, calculates total uptime, and returns a 
    custom object with status levels for reporting.
.PARAMETER ComputerName
    The target system(s) to check. Defaults to localhost.
.PARAMETER MaxDays
    Uptime threshold before marking as 'Critical'. Default is 30 days.
#>
param(
    [Parameter(ValueFromPipeline=$true)]
    [string[]]$ComputerName = "localhost",
    
    [int]$MaxDays = 30
)

process {
    foreach ($Computer in $ComputerName) {
        try {
            $OS = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $Computer -ErrorAction Stop
            $LastBoot = $OS.LastBootUpTime
            $Uptime   = (Get-Date) - $LastBoot

            # Determine Status Level
            $Status = if ($Uptime.Days -ge $MaxDays) { "Critical" } else { "Healthy" }

            # Create an Object (This is what makes it "Professional")
            [PSCustomObject]@{
                ComputerName = $Computer
                LastBoot     = $LastBoot
                UptimeDays   = $Uptime.Days
                UptimeTotal  = "$($Uptime.Days)d $($Uptime.Hours)h $($Uptime.Minutes)m"
                Status       = $Status
                Threshold    = $MaxDays
                Timestamp    = Get-Date
            }
        }
        catch {
            Write-Warning "Failed to connect to $Computer: $($_.Exception.Message)"
        }
    }
}
