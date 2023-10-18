########################################################################################################################
#
#   Author: Marek Bubeník
#   Date: 18.10.2023
#   Description: Detect if the device has Windows 11 widgets installed and removes them
#   Notes: This is a remediation script
#
########################################################################################################################

try {
    # Remove the installed package for each user
    Get-AppxPackage -AllUsers | Where-Object {$_.Name -like "*WebExperience*"} | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
    # Remove the provisioned package for new users
    $AppxRemoval = Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -like "*WebExperience*"} 
    ForEach ( $App in $AppxRemoval) {
        Remove-AppxProvisionedPackage -Online -PackageName $App.PackageName
    }
    Get-Process -Name Explorer | Stop-Process
    exit 0
}
catch {
    $errMsg = $_.Exception.Message
    return $errMsg
    Exit 1
}
