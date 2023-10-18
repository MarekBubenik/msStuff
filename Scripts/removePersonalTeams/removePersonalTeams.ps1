########################################################################################################################
#
#   Author: Marek Bubeník
#   Date: 18.10.2023
#   Description: Remove built-in Teams application on Windows 11 devices
#   Notes: Wrapped in Win32 app or called it manually  & .\removePersonalTeams.ps1
#
########################################################################################################################

# Assign the location for logs
$atosFolder = "$($env:ProgramData)\ATOS\RemovePersonalTeams\Logs\"

function Write-Logs() {
    param
    (
        [Parameter(Mandatory=$true)] [string] $Message
    )
    try {
        #Get the current date
        $LogDate = (Get-Date).tostring("yyyyMMdd")

        #Frame Log File with Current Directory and date
        $LogFile = $atosFolder +"RPT_logs_"+$LogDate+".log"
        
        #Add Content to the Log File
        $TimeStamp = (Get-Date).toString("dd/MM/yyyy_HH:mm:ss:fff")
        $TextLine = "$TimeStamp - $Message"
        Add-Content -Path $LogFile -Value $TextLine
    }
    catch {
        Write-host -f Red "Error:" $_.Exception.Message
        Write-Logs "Error creating logs, check Write-Logs function."
        exit 1
    }
}

function New-AtosFolder() {
    if (Test-Path $atosFolder) {
        Write-Host "Folder already exists, skipping..."
    }
    else
    {
        New-Item $atosFolder -ItemType Directory
        Write-Host "`n"
        Write-Host "Folder Created successfully."
    }
 }

New-AtosFolder

# Check if Personal Teams is present, proceed with deletion if detected
If ($null -eq (Get-AppxPackage -Name MicrosoftTeams -AllUsers)) {
    Write-Logs "The built-in Microsoft Teams Personal App is not present, exiting..."
    exit 0
}
Else {
    Try { 
        Get-AppxPackage -Name MicrosoftTeams -AllUsers | Remove-AppPackage -AllUsers
        Write-Logs "The built-in Microsoft Teams Personal App has been removed."
    }
    catch {
        Write-host -f Red "Error:" $_.Exception.Message
        Write-Logs "Error removing Microsoft Teams Personal App."
        exit 1
    }
}