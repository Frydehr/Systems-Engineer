<#
.SYNOPSIS
    Retrieves a comprehensive audit of an Active Directory user account.
#>
param([Parameter(Mandatory=$true)][string]$UserName)

try {
    $User = Get-ADUser -Identity $UserName -Properties MemberOf, PasswordLastSet, LockedOut, LastLogonDate, PasswordExpired -ErrorAction Stop
    
    $Audit = [PSCustomObject]@{
        Name            = $User.Name
        Enabled         = $User.Enabled
        LockedOut       = $User.LockedOut
        PasswordExpired = $User.PasswordExpired
        LastLogon       = $User.LastLogonDate
        Groups          = ($User.MemberOf | ForEach-Object { (Get-ADGroup $_).Name }) -join ", "
    }
    
    $Audit | Format-List
}
catch {
    Write-Error "User $UserName not found in Active Directory."
}
