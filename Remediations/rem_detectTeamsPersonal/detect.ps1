########################################################################################################################
#
#   Author: Marek Bubeník
#   Date: 18.10.2023
#   Description: Detect if the device has Teams Personal installed and removes it
#   Notes: This is a detection script
#
########################################################################################################################

try {
    $TeamsApp = Get-AppxPackage "*Teams*" -AllUsers -ErrorAction SilentlyContinue
    if ($TeamsApp.Name -eq "MicrosoftTeams") {
        Write-Host "Detected"
        Exit 1
    } else {
         Write-Host "Not Detected"
        Exit  0
    }
}
catch {
    $errMsg = $_.Exception.Message
    return $errMsg
    Exit 1
}