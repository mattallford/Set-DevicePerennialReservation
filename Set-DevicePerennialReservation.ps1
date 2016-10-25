<#
.Synopsis
   Sets a perennial reservation on a device connected to ESXi host(s) to true or false

.DESCRIPTION
   Set-DevicePerennialReservation sets the perennially reserved settings of device(s) connected to ESXi host(s) to either true or false
   You can pipe Get-RDMDevice also written by me into Set-PerennialReservation
   See the following KB for additional information - https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=1016106

.EXAMPLE
   Set-DevicePerennialReservation -ScsiCanonicalName naa.60003ff44dc75adcb00b344794826ba4 -ESXiHosts ESXi01 -PerenniallyReserved:$true
   Sets the device naa.60003ff44dc75adcb00b344794826ba4 on ESXi host ESXi01 to perenially reserved

.EXAMPLE
   Set-DevicePerennialReservation -ScsiCanonicalName naa.60003ff44dc75adcb00b344794826ba4 -ESXiHosts (Get-VMHost -Location cluster1) -PerenniallyReserved:$true
   Sets the device naa.60003ff44dc75adcb00b344794826ba4 on all ESXi hosts in Cluster1 to perenially reserved

.EXAMPLE
   Get-RDMDevice | Set-DevicePerennialReservation -ESXiHosts (Get-VMHost -Location Cluster1) -PerenniallyReserved:$true
   Uses another function called Get-RDMDevice to get all RDM devices in the environment, and then pipes that to Set-DevicePerennialReservation to set all of the devices to
   perenially reserved on all ESXi hosts within the location cluster1

.LINK
http://blog.allford.id.au

.NOTES
Written By: Matt Allford
Twitter:	http://twitter.com/mattallford
#>
function Set-DevicePerennialReservation
{
    [CmdletBinding()]
    Param
    (

        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [String]$ScsiCanonicalName,

        [Parameter(Mandatory=$true)]
        $ESXiHosts,

        [Parameter(Mandatory=$true)]
        [Bool]$PerenniallyReserved
    )

    Process
    {
 
        foreach ($ESXiHost in $ESXiHosts){
            try
            {
                #Import the ESXCLI commands for the ESXi host
                Write-Verbose "Importing ESXcli commands for $($ESXiHost)"
                $esxcli = Get-EsxCli -VMHost $ESXiHost -V2
            }
            catch
            {
                #Throw error if received when importing ESXCLI
                throw $_
            }

            #Loop through each device specified in $ScsiCanonicalName to set the required reservation
            foreach ($Device in $ScsiCanonicalName){
                if ($PerenniallyReserved){
                    try
                    {
                        #If $PerenniallyReserved is true, use esxcli to set the perennial reservation on the current device
                        Write-Verbose "Setting $Device to perenially reserved true on host $ESXiHost"
                        $esxcli.Storage.Core.Device.Setconfig($false,"$Device",$true)
                    }
                    catch
                    {
                        throw $_
                    }
                }ELSEIF($PerenniallyReserved -eq $false){
                     try
                    {
                        #If $PerenniallyReserved is false, use esxcli to set the perennial reservation on the current device
                        Write-Verbose "Setting $Device to perenially reserved false on host $ESXiHost"
                        $esxcli.Storage.Core.Device.Setconfig($false,"$Device",$false)
                    }
                    catch
                    {
                        throw $_
                    }


                }#End IF
            }#End Foreach    
        }#End Foreach
    }#End Process
}#End Function