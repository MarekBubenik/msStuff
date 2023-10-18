# 
# Author: Marek Bubeník
# Desc: Registred app (PowerShell) retrieves SharePoint sites that the desired user owns
# Usage: .\findSharePointSitesOwners.ps1 domain.sharepoint.com desired.user@domain.com
#
# Prerequisites:
# --------------
# This app has to be registred via AzureAD App registrations 
# Setup API permissions for the app as stated: "Group.Read.All, Sites.Read.All, User.Read.All"
# Create a self-signed certificate (.cer for example) or make one via PKI (basically we need private and public key)
# Upload the certificate, and copy paste info from the portal description to variables below
# These steps are important because the MSGraph permission scope "Site.Read.All" is only accessable to a Service Principal (Application)
#
# Info:
# -----
# Depends on HOW SharePoint sites has been created.
# There are TWO types of SharePoint sites:
#       - Team site
#       - Communication site
# When the "Team site" is created - the owner is the Microsoft365 group - consequently the owner of the group is the same person who created the site.
# When the "Communication site" is created - the owner is the person themselves.
#
# Tip:
# ----
# If you have access to the person's account and can login as them, paste "contentclass:STS_Site" in the search box of home site and 
# you will see all the sites they are member of :) could be useful
#
#
#############################################################################################################################################################

# Comment out & $PSScriptRoot\secrets.ps1 for your usage or create one with variables + command below
& $PSScriptRoot\secrets.ps1

# Connect this app to the tenant using MSGraph via certificate (see notes above)
#$AppId
#$TenantId
#$Certificate = Get-ChildItem Cert:\CurrentUser\My\AD88888888888000000000000000000000
#Connect-MgGraph -TenantId $TenantId -AppId $AppId -Certificate $Certificate

# Pass the argument for the specific sharepoint domain to look through
$sharepointDomain = $args[0]

# Pass the argument for the desired person to search against
$desiredUser = $args[1]

# pastMana() formats sites IDs, retrieve top site IDs so they can be further manipulated with
function pastMana($water) {
    try {
        # https://stackoverflow.com/questions/19168475/powershell-to-remove-text-from-a-string
        $oldLife = $water.split(',')[1].split(',')[0] #-replace ".*,"
        return $oldLife
    }
    catch {
        Write-Host "pastMana error"
    }
}

# presentMana() calls pastMana, returned IDs are used to identify Team sites owners
# presentMana() returns Team site/M365 group owners
function presentMana($mana) {
    try {
        # Call pastMana to format site IDs
        $newLife = pastMana($mana)

        # Retrieve owner IDs of the SharePoint sites
        $groupOwnerId = foreach ($id in $newLife)
        {
            (Invoke-GraphRequest GET https://graph.microsoft.com/v1.0/sites/$id/drive).owner.Values.id
            #(Invoke-GraphRequest GET https://graph.microsoft.com/v1.0/sites/$newId/drive).owner | Select-Object @{Name="groupOwnerId";Expression={$_.Values.id}}
        }

        # Translate owner IDs to userPrincipalName
        $groupOwnerName = foreach ($id in $groupOwnerId)
        {
            (Get-MgGroupOwner -GroupId $id).AdditionalProperties.userPrincipalName 2>$null
            #Get-MgGroupOwner -GroupId $id | Select-Object @{name="GroupOwner"; Expression={$_.AdditionalProperties.userPrincipalName}} 2>$null
        }

        return $groupOwnerName
    }
    catch {
        Write-Host "presentMana error"
    }
}

# futureMana() calls pastMana, returned IDs are used to identify Communication sites owners
# futureMana() returns personal owners (users)
function futureMana($mana) {
    try {
        # Call pastMana to format site IDs
        $newLife = pastMana($mana)

        # Retrieve owner userPrincipalName (in comm sites its called email ¯\_(ツ)_/¯) of the SharePoint Communication site
        $commSiteOwnerName = foreach ($id in $newLife)
        {
            (Invoke-GraphRequest GET https://graph.microsoft.com/v1.0/sites/$id/drive).owner.Values.email
            #(Invoke-GraphRequest GET https://graph.microsoft.com/v1.0/sites/$newId/drive).owner | Select-Object @{Name="groupOwnerId";Expression={$_.Values.id}}
        }

        # OLD
        # Translate owner IDs to userPrincipalName
        # $commSiteOwnerName = foreach ($id in $groupOwnerId)
        # {
        #     (Get-MgUser -UserId $id).UserPrincipalName 2>$null
        #     #Get-MgUser -UserId $id | Select-Object @{name="PersonalOwner"; Expression={$_.UserPrincipalName}} 2>$null  
        # }

        return $commSiteOwnerName
    }
    catch {
        Write-Host "futureMana error"
    }
}

# exportTeamSiteOwners() act on group owners, exportCommSiteOwners() act on personally owned sites
function exportTeamSiteOwners() {
    try {
        Get-MgSite | Where-Object WebUrl -like https://$sharepointDomain/sites/* |
        Select-Object @{Name="SharePointTeamSite          ";Expression={$_.DisplayName}}, @{Name="GroupOwner";Expression={presentMana($_.Id)}} |
        Where-Object GroupOwner -eq $desiredUser | Out-File .\SharePointTeamSiteOwnership_$($desiredUser)_$(get-date -f yyyy-MM-dd).txt
    }
    catch {
        Write-Host "exportTeamSiteOwners error"
    }
}
function exportCommSiteOwners() {
    try {
        Get-MgSite | Where-Object WebUrl -like https://$sharepointDomain/sites/* |
        Select-Object @{Name="SharePointCommunicationSite          ";Expression={$_.DisplayName}}, @{Name="PersonalOwner";Expression={futureMana($_.Id)}} |
        Where-Object PersonalOwner -eq $desiredUser | Out-File .\SharePointCommSiteOwnership_$($desiredUser)_$(get-date -f yyyy-MM-dd).txt
    }
    catch {
        Write-Host "exportCommSiteOwners error"
    }
}

exportTeamSiteOwners
exportCommSiteOwners
