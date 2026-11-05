function New-IntuneRoleAssignmentSafe {
    param(
        [string]$AssignmentName,
        [string]$RoleDefinitionId,
        [string]$MemberGroupId,
        [string]$ScopeGroupId,
        [string]$ScopeTagId
    )

    # kontrola duplicit
    $existing = (
        Invoke-MgGraphRequest `
            -Method GET `
            -Uri "https://graph.microsoft.com/beta/deviceManagement/roleAssignments"
    ).value |
    Where-Object {
        $_.displayName -eq $AssignmentName
    }

    if ($existing)
    {
        Write-Host "SKIPPED: $AssignmentName already exists"
        return $existing.id
    }

    $body = @{
        displayName     = $AssignmentName
        description     = $AssignmentName
        members         = @($MemberGroupId)
        scopeMembers    = @($ScopeGroupId)
        roleScopeTagIds = @($ScopeTagId)
        roleDefinition@odata.bind = "https://graph.microsoft.com/beta/deviceManagement/roleDefinitions('$RoleDefinitionId')"
    }

    $assignment = Invoke-MgGraphRequest `
        -Method POST `
        -Uri "https://graph.microsoft.com/beta/deviceManagement/roleAssignments" `
        -Body ($body | ConvertTo-Json -Depth 20) `
        -ContentType "application/json"

    return $assignment.id
}
