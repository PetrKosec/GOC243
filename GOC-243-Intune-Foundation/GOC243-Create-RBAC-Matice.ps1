Connect-MgGraph -Scopes `
"DeviceManagementRBAC.ReadWrite.All",
"Group.ReadWrite.All"

# =====================================================
# Vytvoření skupin
# =====================================================

$groups = @(
"INTUNE-RBAC-L1-EMEA",
"INTUNE-RBAC-L1-APAC",
"INTUNE-RBAC-L1-AMER",
"INTUNE-RBAC-L2-EMEA",
"INTUNE-RBAC-L2-APAC",
"INTUNE-RBAC-L2-AMER",
"INTUNE-RBAC-L3-EMEA",
"INTUNE-RBAC-L3-APAC",
"INTUNE-RBAC-L3-AMER"
)

foreach ($group in $groups)
{
    if (-not (Get-MgGroup -Filter "displayName eq '$group'"))
    {
        New-MgGroup `
            -DisplayName $group `
            -MailEnabled:$false `
            -MailNickname ($group.Replace("-","")) `
            -SecurityEnabled
    }
}

# =====================================================
# Helper Functions
# =====================================================

function Get-RoleDefinitionId {
    param($RoleName)

    (
        Invoke-MgGraphRequest `
            -Method GET `
            -Uri "https://graph.microsoft.com/beta/deviceManagement/roleDefinitions"
    ).value |
    Where-Object displayName -eq $RoleName |
    Select-Object -ExpandProperty id
}

function Get-ScopeTagId {
    param($TagName)

    (
        Invoke-MgGraphRequest `
            -Method GET `
            -Uri "https://graph.microsoft.com/beta/deviceManagement/roleScopeTags"
    ).value |
    Where-Object displayName -eq $TagName |
    Select-Object -ExpandProperty id
}

function Get-GroupId {
    param($GroupName)

    (
        Get-MgGroup `
        -Filter "displayName eq '$GroupName'"
    ).Id
}

function New-IntuneAssignment {
    param(
        $AssignmentName,
        $RoleName,
        $GroupName,
        $ScopeTagName
    )

    $roleId = Get-RoleDefinitionId $RoleName
    $groupId = Get-GroupId $GroupName
    $scopeTagId = Get-ScopeTagId $ScopeTagName

    $body = @{
        displayName = $AssignmentName
        description = $AssignmentName
        members = @($groupId)
        scopeMembers = @()
        roleScopeTagIds = @($scopeTagId)
        roleDefinition@odata.bind = "https://graph.microsoft.com/beta/deviceManagement/roleDefinitions('$roleId')"
    }

    Invoke-MgGraphRequest `
        -Method POST `
        -Uri "https://graph.microsoft.com/beta/deviceManagement/roleAssignments" `
        -Body ($body | ConvertTo-Json -Depth 10) `
        -ContentType "application/json"

    Write-Host "Created: $AssignmentName"
}

# =====================================================
# L1
# =====================================================

New-IntuneAssignment "L1 EMEA" "Help Desk Operator" "INTUNE-RBAC-L1-EMEA" "EMEA"
New-IntuneAssignment "L1 APAC" "Help Desk Operator" "INTUNE-RBAC-L1-APAC" "APAC"
New-IntuneAssignment "L1 AMER" "Help Desk Operator" "INTUNE-RBAC-L1-AMER" "AMER"

# =====================================================
# L2
# =====================================================

foreach ($region in @("EMEA","APAC","AMER"))
{
    New-IntuneAssignment `
        "L2 Policy $region" `
        "Policy and Profile Manager" `
        "INTUNE-RBAC-L2-$region" `
        $region

    New-IntuneAssignment `
        "L2 Security $region" `
        "Endpoint Security Manager" `
        "INTUNE-RBAC-L2-$region" `
        $region
}

# =====================================================
# L3
# =====================================================

New-IntuneAssignment "L3 EMEA" "Intune Administrator" "INTUNE-RBAC-L3-EMEA" "EMEA"
New-IntuneAssignment "L3 APAC" "Intune Administrator" "INTUNE-RBAC-L3-APAC" "APAC"
New-IntuneAssignment "L3 AMER" "Intune Administrator" "INTUNE-RBAC-L3-AMER" "AMER"
