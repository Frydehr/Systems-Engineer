#Use this script to Create and cluster new VM.  					#
																	#
#Author: Spencer McConnell											#
																	#
#      			 MUST BE RUN ON A CLUSTER HOST SYSTEM!		   		#
																	#
#Don't forget to set VARIABLES 1st! 								#						
																	#	
#Run "$PSVersionTable" to confirm PSVersion 5 or greater.			#
																	#
#Set VM Settings Below												#
$VMName = "Enter VM Name"	#Set the name of the new VM				#
$RAM = 8192MB 				#Set RAM size in MB						#	
$NIC = "VM External"												#
$CPU = 4					#How Many Cores							#
#####################################################################	
$Baseimage = "C:\ClusterStorage\Volume216\VMTemplates\SyspreppedVHDsForNewVMs\WS2016Image-SYS-5-22-2020.vhdx"#
##############################################################################################################
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#
#|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||#
#                		SET VARIABLES ABOVE!						#

Write-host "Script must run locally on HyperV Host!!!!" -ForegroundColor Red
Write-host "Make sure to run scripts 1 and 2 prior to this one"
Write-Host "Only Continue if you Set the VARIABLES" -ForegroundColor Magenta
Pause


$folder = "C:\ClusterStorage"
Get-childitem $folder Volume* -recurse | Where-Object {$_.CreationTime -gt (Get-Date).Date } > "c:\temp\volume.log"
$result3 = Get-Item -Path "C:\Temp\volume.log" | Get-Content -Tail 3
Write-Output = $result3
$Volume = Read-host "Enter the Volume number listed above or the known Volume number for VM LUN"
$Volume = "Volume" + $Volume

$vmstorage = "C:\ClusterStorage\$Volume\$VMName"
$vhdpath = "C:\ClusterStorage\$Volume\$VMName\$VMName.OS.vhdx"


#Stage OS Template VHD for new VM
Write-Host "Copying W2K16G2BASE.vhdx..........." -ForegroundColor Green
copy-item $Baseimage -Destination $vhdpath -force
$acl2 = Get-Acl $vhdpath
$acl2.SetAccessRuleProtection($false,$true)
$acl2 | Set-Acl $vhdpath
Write-Host "Created $VMName OS VHD" -ForegroundColor Green

#Create New VM
Write-Host "Creating $VMName VM" -ForegroundColor Magenta
new-vm -name $VMName -MemoryStartupBytes $RAM -VHDPath $vhdpath -Path $vmstorage -Generation 2 -bootdevice VHD -SwitchName $NIC
set-vm -name $VMName -ProcessorCount $CPU -SmartPagingFilePath $vmstorage
set-vmprocessor $VMName -CompatibilityForMigrationEnabled $true
Write-Host "$VMName VM Created" -ForegroundColor Magenta

#Adding VM To Cluster
Write-Host "The Next step will Cluster the VM" -ForegroundColor Cyan
Write-host "This will not work in a remote session" -ForegroundColor Cyan
Write-Host "If you are in a remote PS Session complete this step Manually from the local cluster Host" -ForegroundColor Cyan
pause

Write-Host "Adding $VMName to Cluster" -ForegroundColor Cyan
Add-ClusterVirtualMachineRole -VirtualMachine $VMName -Name $VMName
Write-Host "$VMName is now clustered - Maybe ?!?!?!?!?" -ForegroundColor Cyan

Write-Host "Script Complete"