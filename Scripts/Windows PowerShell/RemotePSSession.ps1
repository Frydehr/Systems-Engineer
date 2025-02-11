#Use this script to create a remote PS Session              #		
                                                            #
#Author: Spencer McConnell                                  #
                                                            #
#Run "$PSVersionTable" to confirm PSVersion 5 or greater.   #
#############################################################
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#
#|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||#

#Script Parameters ##########################################
[CmdletBinding()]
param (
        [Parameter( Mandatory=$true)]
        [string]$Server
		)
##############################################################

#Script Header Variables #####################################
$UserCredential = Get-Credential

#The run script is below
##############################################################

Enter-PSSession -ComputerName $Server -Credential $UserCredential
