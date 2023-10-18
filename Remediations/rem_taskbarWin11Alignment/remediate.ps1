########################################################################################################################
#
#   Author: Marek Bubeník
#   Date: 18.10.2023
#   Description: Change the taskbar alignment on Windows 11 devices
#   Notes: This is a remediation script
#
########################################################################################################################

function Test-RegistryValue {
    param (
     [parameter(Mandatory=$true)]
     [ValidateNotNullOrEmpty()]$Path,
    
    [parameter(Mandatory=$true)]
     [ValidateNotNullOrEmpty()]$Value
    )
    
    try {
        Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop | Out-Null
        return $true
    }catch {
        return $false
    }
}

$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$value = "TaskbarAl"

if(Test-Path $path){
    try{
        Set-ItemProperty -Path $path -Name $value -Value 0 -Force
        Exit 0
    }catch{
        Exit 1
    }
}else{
    Exit 1
}
