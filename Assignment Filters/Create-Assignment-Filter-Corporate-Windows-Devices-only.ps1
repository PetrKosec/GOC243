Connect-MgGraph -Scopes "DeviceManagementConfiguration.ReadWrite.All"

$body = @{
    "@odata.type" = "#microsoft.graph.deviceAndAppManagementAssignmentFilter"
    displayName   = "Windows - Corporate (PowerShell)"
    description   = "Corporate Windows devices only"
    platform      = "windows10AndLater"
    rule          = '(device.deviceOwnership -eq "Corporate")'
    roleScopeTags = @("0")
} | ConvertTo-Json -Depth 5

Invoke-MgGraphRequest `
    -Method POST `
    -Uri "https://graph.microsoft.com/beta/deviceManagement/assignmentFilters" `
    -Body $body `
    -ContentType "application/json"
