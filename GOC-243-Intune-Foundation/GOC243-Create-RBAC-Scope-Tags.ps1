# Připojení k Microsoft Graph
Connect-MgGraph -Scopes "RoleManagement.ReadWrite.Directory","DeviceManagementRBAC.ReadWrite.All"

# Scope Tags k vytvoření
$scopeTags = @(
    "L1 Support",
    "L2 Support",
    "L3 Support",
    "EMEA",
    "APAC",
    "AMER"
)

foreach ($tagName in $scopeTags) {

    $body = @{
        displayName = $tagName
        description = "Scope Tag for $tagName"
    } | ConvertTo-Json

    Invoke-MgGraphRequest `
        -Method POST `
        -Uri "https://graph.microsoft.com/beta/deviceManagement/roleScopeTags" `
        -Body $body `
        -ContentType "application/json"

    Write-Host "Created Scope Tag: $tagName"
}
