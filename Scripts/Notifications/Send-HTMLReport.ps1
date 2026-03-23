<#
.SYNOPSIS
    Converts PowerShell objects into a clean HTML table and emails them.
#>
param(
    [Parameter(Mandatory=$true)][PSObject[]]$Data,
    [string]$Subject = "Automated System Report",
    [string]$To = "admin@contoso.com"
)
$Header = "<style>TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}TH{border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #CAF0F8;}TD{border-width: 1px;padding: 3px;border-style: solid;border-color: black;}</style>"
$Body = $Data | ConvertTo-Html -Head $Header | Out-String
Send-MailMessage -To $To -From "monitoring@contoso.com" -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer "smtp.contoso.com"
