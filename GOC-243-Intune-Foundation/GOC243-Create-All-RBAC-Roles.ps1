Connect-MgGraph -Scopes `
    "DeviceManagementRBAC.ReadWrite.All",
    "Group.ReadWrite.All",
    "RoleManagement.ReadWrite.Directory"

# ------------------------------------------------------------------
# Scope Tags
# ------------------------------------------------------------------

$scopeTags = @(
    "L1 Support",
    "L2 Support",
    "L3 Support",
    "EMEA",
    "APAC",
    "AMER"
)

foreach ($tag in $scopeTags)
{
    $body = @{
        displayName = $tag
        description = $tag
    } | ConvertTo-Json

    Invoke-MgGraphRequest `
        -Method POST `
        -Uri "https://graph.microsoft.com/beta/deviceManagement/roleScopeTags" `
        -Body $body `
        -ContentType "application/json"
}

# ------------------------------------------------------------------
# Security Groups
# ------------------------------------------------------------------

$groups = @(
    "INTUNE-RBAC-L1-Support",
    "INTUNE-RBAC-L2-Support",
    "INTUNE-RBAC-L3-Support",
    "INTUNE-RBAC-EMEA",
    "INTUNE-RBAC-APAC",
    "INTUNE-RBAC-AMER"
)

foreach($group in $groups)
{
    New-MgGroup `
        -DisplayName $group `
        -MailEnabled:$false `
        -MailNickname ($group.Replace("-","")) `
        -SecurityEnabled
}
