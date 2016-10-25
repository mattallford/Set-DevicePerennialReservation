# Set-DevicePerennialReservation
Set-DevicePerennialReservation is a powershell function that sets the perennial reservation for devices specified in the ScsiCanonicalName paramater to either true or false
This function can be piped to from another function I have writted, Get-RDMDevice

Requires the VMware PowerCLI cmdlets - Always run the latest where possible

This is a function, so dot source the PS1 which will then enable you to use the function.
For example:
1. Download and save the ps1 to c:\scripts
2. Run the following to dot source the script and import the function:
. C:\Scripts\Set-DevicePerennialReservation.ps1
3. You can now run Set-DevicePerennialReservation

# Parameters
-ScsiCanonicalName. Set the location to limit the scope of virtual machines that are checked for RDM configurations
-ESXiHosts. Specifiy the ESXi host(s) to run the command against. See script examples
-PerenniallyReserved. Boolean, so set to $true or $false to set the perenially reserved flag for the deivce to true or false

# Example Usage
   Set-DevicePerennialReservation -ScsiCanonicalName naa.60003ff44dc75adcb00b344794826ba4 -ESXiHosts ESXi01 -PerenniallyReserved:$true
   Sets the device naa.60003ff44dc75adcb00b344794826ba4 on ESXi host ESXi01 to perenially reserved
   
   Set-DevicePerennialReservation -ScsiCanonicalName naa.60003ff44dc75adcb00b344794826ba4 -ESXiHosts (Get-VMHost -Location cluster1) -PerenniallyReserved:$true
   Sets the device naa.60003ff44dc75adcb00b344794826ba4 on all ESXi hosts in Cluster1 to perenially reserved

   Get-RDMDevice | Set-DevicePerennialReservation -ESXiHosts (Get-VMHost -Location Cluster1) -PerenniallyReserved:$true
   Uses another function called Get-RDMDevice to get all RDM devices in the environment, and then pipes that to Set-DevicePerennialReservation to set all of the devices to
   perenially reserved on all ESXi hosts within the location cluster1

# Change Log
V1.00, 26-10-2016 - Initial Version

#Future ideas
