########################################################################################################################
#
#   Author: Marek Bubeník
#   Date: 18.10.2023
#   Description: Detect if the device has Teams Personal installed and removes it
#   Notes: This is a remediation script
#
########################################################################################################################

try {
    #Kill Teams Personal EXE if running
    $isTeamsRunning = Get-Process -Name *msteams*
    if($isTeamsRunning){
        #TASKKILL /IM msteams.exe /f
        Stop-Process -Name *msteams*
    }
    Get-AppxPackage | Where-Object Name -like "*MicrosoftTeams*" | Remove-AppxPackage
    Write-Host "Personal Teams uninstalled"
    Exit 0
}
catch {
    $errMsg = $_.Exception.Message
    return $errMsg
    Exit 1
}

