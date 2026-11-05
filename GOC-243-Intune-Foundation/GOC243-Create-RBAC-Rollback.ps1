$CreatedAssignments = @()

try
{
    $CreatedAssignments += New-IntuneRoleAssignmentSafe ...
    $CreatedAssignments += New-IntuneRoleAssignmentSafe ...
    $CreatedAssignments += New-IntuneRoleAssignmentSafe ...
}
catch
{
    Write-Warning "ERROR DETECTED"
    Write-Warning "ROLLBACK STARTED"

    foreach ($id in $CreatedAssignments)
    {
        try
        {
            Invoke-MgGraphRequest `
                -Method DELETE `
                -Uri "https://graph.microsoft.com/beta/deviceManagement/roleAssignments/$id"
        }
        catch
        {
            Write-Warning "Unable to remove assignment $id"
        }
    }

    throw
}
