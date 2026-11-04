# Requires:
# Microsoft.Graph.Authentication
# Microsoft.Graph.Groups
# Microsoft.Graph.DeviceManagement.Enrollment

$Scopes = @(
    "Group.ReadWrite.All",
    "DeviceManagementServiceConfig.ReadWrite.All"
)

Connect-MgGraph -Scopes $Scopes

# =====================================================
# Dynamic Device Groups (Autopilot Group Tags)
# =====================================================

$DynamicGroups = @(
    @{
        DisplayName = "INTUNE-Phase-LAB"
        Description = "Autopilot devices with Group Tag LAB"
        MailNickname = "INTUNEPhaseLAB"

        MembershipRule = '(device.devicePhysicalIds -any (_ -contains "[OrderID]:LAB"))'
    }
    @{
        DisplayName = "INTUNE-Phase-PRODUCTION"
        Description = "Autopilot devices with Group Tag PRODUCTION"
        MailNickname = "INTUNEPhasePRODUCTION"

        MembershipRule = '(device.devicePhysicalIds -any (_ -contains "[OrderID]:PRODUCTION"))'
    }
)

foreach ($Group in $DynamicGroups)
{
    $Existing = Get-MgGroup -Filter "displayName eq '$($Group.DisplayName)'"

    if (-not $Existing)
    {
        New-MgGroup `
            -DisplayName $Group.DisplayName `
            -Description $Group.Description `
            -MailEnabled:$false `
            -MailNickname $Group.MailNickname `
            -SecurityEnabled:$true `
            -GroupTypes @("DynamicMembership") `
            -MembershipRule $Group.MembershipRule `
            -MembershipRuleProcessingState "On"

        Write-Host "Created Dynamic Group: $($Group.DisplayName)" -ForegroundColor Green
    }
}

# =====================================================
# Assigned Security Groups (Deployment Rings)
# =====================================================

$RingGroups = @(
    @{
        DisplayName = "INTUNE-Ring-1"
        Description = "Pilot ring"
        MailNickname = "INTUNERing1"
    }
    @{
        DisplayName = "INTUNE-Ring-2"
        Description = "Early adopters"
        MailNickname = "INTUNERing2"
    }
    @{
        DisplayName = "INTUNE-Ring-3"
        Description = "Broad deployment"
        MailNickname = "INTUNERing3"
    }
)

foreach ($Group in $RingGroups)
{
    $Existing = Get-MgGroup -Filter "displayName eq '$($Group.DisplayName)'"

    if (-not $Existing)
    {
        New-MgGroup `
            -DisplayName $Group.DisplayName `
            -Description $Group.Description `
            -MailEnabled:$false `
            -MailNickname $Group.MailNickname `
            -SecurityEnabled:$true

        Write-Host "Created Ring Group: $($Group.DisplayName)" -ForegroundColor Green
    }
}

# =====================================================
# Microsoft 365 Support Groups
# =====================================================

$M365Groups = @(
    @{
        DisplayName = "M365-L1-Support"
        Description = "First line support"
        MailNickname = "M365L1Support"
    }
    @{
        DisplayName = "M365-L2-Support"
        Description = "Second line support"
        MailNickname = "M365L2Support"
    }
    @{
        DisplayName = "M365-L3-Support"
        Description = "Third line support"
        MailNickname = "M365L3Support"
    }
)

foreach ($Group in $M365Groups)
{
    $Existing = Get-MgGroup -Filter "displayName eq '$($Group.DisplayName)'"

    if (-not $Existing)
    {
        New-MgGroup `
            -DisplayName $Group.DisplayName `
            -Description $Group.Description `
            -MailEnabled:$true `
            -MailNickname $Group.MailNickname `
            -SecurityEnabled:$false `
            -GroupTypes @("Unified")

        Write-Host "Created M365 Group: $($Group.DisplayName)" -ForegroundColor Green
    }
}

# =====================================================
# Optional - Assign Group Tags to devices
# =====================================================
# Uncomment and edit to assign tags automatically.

<#
$LabSerials = @(
    "ABC123456",
    "DEF123456"
)

$ProdSerials = @(
    "XYZ123456",
    "UVW123456"
)

$Devices = Get-MgDeviceManagementWindowsAutopilotDeviceIdentity -All

foreach($Device in $Devices)
{
    if($Device.SerialNumber -in $LabSerials)
    {
        Update-MgDeviceManagementWindowsAutopilotDeviceIdentity `
            -WindowsAutopilotDeviceIdentityId $Device.Id `
            -GroupTag "LAB"

        Write-Host "$($Device.SerialNumber) => LAB"
    }

    if($Device.SerialNumber -in $ProdSerials)
    {
        Update-MgDeviceManagementWindowsAutopilotDeviceIdentity `
            -WindowsAutopilotDeviceIdentityId $Device.Id `
            -GroupTag "PRODUCTION"

        Write-Host "$($Device.SerialNumber) => PRODUCTION"
    }
}
#>

Write-Host ""
Write-Host "Completed." -ForegroundColor Cyan
