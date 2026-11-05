Connect-MgGraph -Scopes "DeviceManagementRBAC.ReadWrite.All","Group.Read.All"

# ============================================================
# Pomocné funkce
# ============================================================

function Get-IntuneRoleDefinition {
    param([string]$DisplayName)

    (Invoke-MgGraphRequest `
        -Method GET `
        -Uri "https://graph.microsoft.com/beta/deviceManagement/roleDefinitions").value |
        Where-Object { $_.displayName -eq $DisplayName }
}

function Get-ScopeTag {
    param([string]$DisplayName)

    (Invoke-MgGraphRequest `
        -Method GET `
        -Uri "https://graph.microsoft.com/beta/deviceManagement/roleScopeTags").value |
        Where-Object { $_.displayName -eq $DisplayName }
}

function Get-EntraGroup {
    param([string]$DisplayName)

    Get-MgGroup -Filter "displayName eq '$DisplayName'"
}

function New-IntuneRoleAssignment {
    param(
        [string]$AssignmentName,
        [string]$RoleName,
        [string]$ScopeTagName,
        [string]$GroupName
    )

    Write-Host "Creating assignment $AssignmentName"

    $role      = Get-IntuneRoleDefinition $RoleName
    $scopeTag  = Get-ScopeTag $ScopeTagName
    $group     = Get-EntraGroup $GroupName

    $body = @{
        "@odata.type" = "#microsoft.graph.deviceAndAppManagementRoleAssignment"
        displayName   = $AssignmentName
        description   = $AssignmentName
        members       = @($group.Id)
        scopeMembers  = @()
        scopeType     = "resourceScope"
        roleDefinition@odata.bind = "https://graph.microsoft.com/beta/deviceManagement/roleDefinitions('$($role.id)')"
        roleScopeTags = @($scopeTag.id)
    } | ConvertTo-Json -Depth 10

    Invoke-MgGraphRequest `
        -Method POST `
        -Uri "https://graph.microsoft.com/beta/deviceManagement/roleAssignments" `
        -Body $body `
        -ContentType "application/json"
}

# ============================================================
# L1
# ============================================================

New-IntuneRoleAssignment `
    -AssignmentName "L1 Support Assignment" `
    -RoleName "Help Desk Operator" `
    -ScopeTagName "L1 Support" `
    -GroupName "INTUNE-RBAC-L1-Support"

# ============================================================
# L2
# ============================================================

New-IntuneRoleAssignment `
    -AssignmentName "L2 Policy Manager" `
    -RoleName "Policy and Profile Manager" `
    -ScopeTagName "L2 Support" `
    -GroupName "INTUNE-RBAC-L2-Support"

New-IntuneRoleAssignment `
    -AssignmentName "L2 Endpoint Security" `
    -RoleName "Endpoint Security Manager" `
    -ScopeTagName "L2 Support" `
    -GroupName "INTUNE-RBAC-L2-Support"

# ============================================================
# L3
# ============================================================

New-IntuneRoleAssignment `
    -AssignmentName "L3 Intune Admin" `
    -RoleName "Intune Administrator" `
    -ScopeTagName "L3 Support" `
    -GroupName "INTUNE-RBAC-L3-Support"
