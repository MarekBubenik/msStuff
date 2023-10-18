#########################################################################################################
#     
#   Author: Marek Bubeník
#   Date: 18.10.2023
#   Description: If the device has Fast Boot enabled - registry key is HiberbootEnabled - disable it
#   Notes: This is a detection script                                                            
#                                                                                                       
#########################################################################################################

try {
    # Detect Fast Boot registry property
    # 1 = Enabled, 0 = Disabled
    $value = Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name HiberbootEnabled
    if ($value -eq 1) {
        Write-Host "FastBootEnabled"
        exit 1
    } else {
        Write-Host "FastBootDisabled"
        exit 0
    }
}
catch {
    $errMsg = $_.Exception.Message
    return $errMsg
    exit 1
}


