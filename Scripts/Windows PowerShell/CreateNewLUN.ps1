#Use this script to Create a New LUN								#
																	#
#Author: Spencer McConnell											#
																	#
#Don't forget to set VARIABLES 1st! 								#
																	#
#Run "$PSVersionTable" to confirm PSVersion 5 or greater.			#
																	#
#Set LUN Settings Below												#
																	#
$LunSize = 250GB 	#Use GB or TB									#
																	#
#Set VM Settings Below												#
$LunName = "Enter Lun Name"	#Set the name of the new VM				#
#####################################################################
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#
#|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||#
#                		SET VARIABLES ABOVE!						#

Write-Host "Only Continue if you Set the VARIABLES" -ForegroundColor Magenta
Pause

# Checking for Unity Module
if (!(Get-Module -Name "Unity-Powershell"))
{ 
	Install-PackageProvider -Name NuGet -Force
	Install-PackageProvider -Name NuGet -Force
	Update-Module -Name PowerShellGet
	Install-Module Unity-Powershell -Scope CurrentUser
	Import-Module Unity-Powershell
}

#Connect to EMC Unity Array
Write-Host "You are about to connect to the EMC Unity Array" -ForegroundColor Yellow
Write-Host "Please Login using your 'Domain Admin Account@hq.usres.com'" -ForegroundColor Yellow
pause
Connect-Unity -Server unity01

#Create LUN
Write-Host "Creating New LUN" -ForegroundColor Cyan
#########################################################################################################<------Confirm and list all needed hosts See chart below
New-UnityLun -Name $LunName -Pool pool_1 -Size $LunSize -host Host_1,Host_2,Host_3,Host_4,Host_5,Host_6 #<------Confirm and list all needed hosts See chart below
#########################################################################################################<------Confirm and list all needed hosts See chart below
#	Id           Name                OsType         Type		#<------Confirm and list all needed hosts See chart
#	--           ----                ------         ----		#<------Confirm and list all needed hosts See chart
#	Host_1       -		             Windows Server HostManual	#<------Confirm and list all needed hosts See chart
#	Host_2       -		             Windows Server HostManual	#<------Confirm and list all needed hosts See chart
#	Host_3       -		             Windows Server HostManual	#
#	Host_4       -		             Windows Server HostManual	#
#	Host_5       -		             Windows Server HostManual	#
#	Host_6       -		             Windows Server HostManua1	#
#	Host_7       -		             Windows Server HostManual	#
#	Host_8       -		             Windows Server HostManual	#
#	Host_10      -				     Windows Server HostManual  #
#	Host_11      -				     Windows Server HostManual	#
#	Host_12      -		           	 Windows Server HostManual	#
#	Host_13      -		       		 Windows Server HostManual	#
#	Host_14      - 		       		 Windows Server HostManual	#
#	Host_15      -		       		 Windows Server HostManual	#
#	Host_16      -		       		 Windows Server HostManual	#
#	VNXSanCopy_9 -					                VNXSanCopy	#
#################################################################
Write-Host "LUN Created - Disconnecting from Unity" -ForegroundColor Cyan
Pause
Disconnect-Unity 

Write-Host "Script Complete"
