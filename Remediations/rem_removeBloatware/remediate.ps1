########################################################################################################################
#
#   Author: Marek Bubeník
#   Date: 18.10.2023
#   Description: Uninstall bloatware apps from Windows devices
#   Notes: This is a remediation script
#
########################################################################################################################

$appxs = @(
    "DuoLingo-LearnLanguagesforFree", "EclipseManager", "Flipboard.Flipboard",
"Microsoft.3DBuilder", "Microsoft.Appconnector", "Microsoft.BingFinance", "Microsoft.BingNews",
"Microsoft.BingSports", "Microsoft.BingTranslator", "Microsoft.BingWeather", "Microsoft.CommsPhone",
"Microsoft.ConnectivityStore", "Microsoft.Freshpaint", "Microsoft.Getstarted",
"Microsoft.MicrosoftSolitaireCollection", "Microsoft.MicrosoftOfficeHub", "Microsoft.Messaging",
"Microsoft.NetworkSpeedTest", "Microsoft.Office.OneNote", "Microsoft.Office.Sway",
"Microsoft.OneConnect", "Microsoft.People", "Microsoft.SkypeApp", "Microsoft.Windowscommunicationsapps",
"Microsoft.Microsoft.WindowsFeedbackHub", "Microsoft.WindowsMaps", "Microsoft.WindowsPhone",
"Microsoft.WindowsSoundRecorder", "Microsoft.XboxApp", "Microsoft.XboxGameCallableUI",
"Microsoft.XboxGameOverlay", "Microsoft.XboxGamingOverlay", "Microsoft.XboxIdentityProvider",
"Microsoft.XboxSpeechToTextOverlay", "Microsoft.Xbox.TCUI", "Microsoft.ZuneMusic",
"Microsoft.ZuneVideo", "PicsArt-PhotoStudio", "6Wunderkinder.WunderList")

foreach($app in $appxs){
    $appxPackage = Get-AppxPackage "*$app*"
    if($appxPackage){
        $appxPackage | Remove-AppxPackage -ErrorAction SilentlyContinue | Out-Null
    }
}