########################################################################################################################
#
#   Author: Marek Bubeník
#   Date: 18.10.2023
#   Description: Detect if the device has Windows 10 widgets installed and removes them
#   Notes: This is a detection script
#
########################################################################################################################

try {
    $detection = Get-AppxPackage -AllUsers | Where-Object {$_.Name -like "*WebExperience*"}
    if ($detection.Name -eq "MicrosoftWindows.Client.WebExperience") {
        Write-Host "WindgetsFound"
        exit 1
    } else {
        Write-Host "WindgetsNotFound"
        exit 0
    }
}
catch {
    $errMsg = $_.Exception.Message
    return $errMsg
    Exit 1
}