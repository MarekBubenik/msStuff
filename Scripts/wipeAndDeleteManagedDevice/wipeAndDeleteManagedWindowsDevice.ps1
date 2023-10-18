########################################################################################################################
#
#   Author: Marek Bubeník
#   Date: 18.10.2023
#   Description: Initiate device wipe, delete and removal of HH from Autopilot via PowerShell MSGraph
#   Notes: .\wipeAndDeleteManagedWindowsDevice.ps1
#
########################################################################################################################

# Connect-MgGraph -scopes "DeviceManagementServiceConfig.ReadWrite.All, DeviceManagementManagedDevices.ReadWrite.All"

# Supply with serial number of the device
$deviceSerialNumber = "VMware-560000000000000000000000000000000000000"
$trimDeviceSerialNumber = $deviceSerialNumber -replace '\s',''      # Removes spaces from the serial number, if needed

function GatherDeviceId
{
    Write-Host "Gathering device ID..."
    (Get-MgDeviceManagementManagedDevice | Where-Object {$_.SerialNumber -eq $trimDeviceSerialNumber}).Id
}

function GatherDeviceAutopilotId
{
    Write-Host "Gathering device Autopilot ID..."
    if ($managedDeviceId)
    {
        (Get-MgDeviceManagementWindowsAutopilotDeviceIdentity | Where-Object {$_.ManagedDeviceId -like $managedDeviceId}).Id
    } else {
        (Get-MgDeviceManagementWindowsAutopilotDeviceIdentity | Where-Object {$_.SerialNumber -like $deviceSerialNumber}).Id
    }

}

$managedDeviceId = GatherDeviceId
$autopilotDeviceId = GatherDeviceAutopilotId

function PerformAction() {

    if ($managedDeviceId){

        Write-Host "#########################################################"
        Write-Host "#### The wipe and deletion of the device has started ####"
        Write-Host "#########################################################"

        # Initiate a wipe
        Invoke-MgGraphRequest -Method POST -Uri https://graph.microsoft.com/v1.0/deviceManagement/managedDevices/$managedDeviceId/wipe
        # Wait for a bit for the wipe to be processed
        Write-Host "Waiting for the wipe action to be initiated..."
        Start-Sleep -Seconds 60

        # Delete managed device
        Remove-MgDeviceManagementManagedDevice -ManagedDeviceId $managedDeviceId
        # Wait for a bit for the delete process to be done
        Write-Host "Waiting for the delete action to be finished..."
        Start-Sleep -Seconds 10
    } else {}
    
    try {

        Write-Host "###########################################################"
        Write-Host "#### Deletion from the Autopilot inventory has started ####"
        Write-Host "###########################################################"

        # Removes Autopilot device identity = HardwareHash
        Remove-MgDeviceManagementWindowsAutopilotDeviceIdentity -WindowsAutopilotDeviceIdentityId $autopilotDeviceId
        Write-Host "Device has been removed from the Autopilot inventory."
        # Write-Host "Give it couple of minutes and the device will be removed from the Microsoft Entra ID too."
        Write-Host "Exiting..."
    }
    catch {
        Write-host -f Red "Error:" $_.Exception.Message
    }
}

PerformAction

# TODO delete from MS Entra ID too



# get serial number
# (Invoke-MgGraphRequest -Method GET -Uri https://graph.microsoft.com/v1.0/deviceManagement/managedDevices/$deviceId).serialNumber
# Initiate a wipe
#Invoke-MgGraphRequest -Method POST -Uri https://graph.microsoft.com/v1.0/deviceManagement/managedDevices/$deviceId/wipe
# Deletes managed device
#Remove-MgDeviceManagementManagedDevice -ManagedDeviceId $managedDeviceId
#Remove-MgDeviceManagementWindowsAutopilotDeviceIdentity -WindowsAutopilotDeviceIdentityId 
#Get-MgDeviceManagementWindowsAutopilotDeviceIdentity | Where-Object {$_.ManagedDeviceId -like $managedDeviceId}
