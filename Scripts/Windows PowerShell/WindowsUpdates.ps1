#Use this script to install Microsoft Updates							#
																		#
#Author: Spencer McConnell												#
																		#
																		#
#Run "$PSVersionTable" to confirm PSVersion 5 or greater.				#
#########################################################################
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#
# ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||#

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Checking for Microsoft Update Module
if (!(Get-Module -Name "PSWindowsUpdate"))
{ 
	#Checking for NuGet Package Provider
	if(!(Get-PackageProvider -Name "NuGet"))
	{	
		Write-host "Setting up Package Provider Connection" -ForegroundColor Magenta
		Install-PackageProvider -Name NuGet -Force
		Update-Module -Name PowerShellGet
	}
	Write-Host "Installing Windows Update Module" -ForegroundColor Magenta
	Install-Module PSWindowsUpdate
}

#Installing Updates
Get-WindowsUpdate -Install -AcceptAll -IgnoreReboot
Write-Host "Script Complete" -ForegroundColor Yellow