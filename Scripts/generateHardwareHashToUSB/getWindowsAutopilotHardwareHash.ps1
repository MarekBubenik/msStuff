$env:Path += ";C:\Program Files\WindowsPowerShell\Scripts"
#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
Install-PackageProvider -Name NuGet -Force
Install-Script -Name Get-WindowsAutopilotInfo -Force
Get-WindowsAutopilotInfo.ps1 -OutputFile "D:\Export\AutopilotHWID.csv"