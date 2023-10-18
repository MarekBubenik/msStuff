#########################################################################################################
#     
#   Author: Marek Bubeník
#   Date: 18.10.2023
#   Description: If the device has Fast Boot enabled - registry key is HiberbootEnabled - disable it
#   Notes: This is a remediation script                                                            
#                                                                                                       
#########################################################################################################

try {
    # Remediate Fast Boot registry property
    # 1 = Enabled, 0 = Disabled
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Value 0
    Write-Host "FastBootDisabled"
    exit 0
}
catch {
    $errMsg = $_.Exception.Message
    return $errMsg
    exit 1
}


