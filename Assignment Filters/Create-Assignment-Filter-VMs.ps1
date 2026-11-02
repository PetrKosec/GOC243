# Přihlášení k Microsoft Graph
Connect-MgGraph -Scopes "DeviceManagementConfiguration.ReadWrite.All"

# Definice filtru
$filter = @{
    displayName = "GOC243 - Virtuální stroje"
    description = "Cílení na zařízení, která jsou VM"
    platform = "windows10AndLater"
    rule = '(device.deviceModel -contains "Virtual")'
}

# Převedení na JSON
$filterJson = $filter | ConvertTo-Json -Depth 10

# Vytvoření filtru
$createdFilter = Invoke-MgGraphRequest -Method POST `
    -Uri "https://graph.microsoft.com/beta/deviceManagement/assignmentFilters" `
    -Body $filterJson `
    -ContentType "application/json"

# Výstup ID filtru
$createdFilter.id

rule = '(device.deviceModel -eq "Microsoft Virtual Machine") or (device.deviceModel -eq "VMware Virtual Platform")'
