# ==========================================================
# BIOS Custom Compliance Script Upload
# ==========================================================

$ScriptName  = "BIOS Version Detection"
$Publisher   = "Košec Solutions s.r.o."
$Version     = "1.0"

$Scopes = @(
    "DeviceManagementConfiguration.ReadWrite.All",
    "DeviceManagementManagedDevices.ReadWrite.All",
    "DeviceManagementScripts.ReadWrite.All"
)

Connect-MgGraph -Scopes $Scopes -NoWelcome

# Detection Script
$DetectionScript = @'
$bios = Get-CimInstance -ClassName Win32_BIOS

$result = @{
    BIOSVersion = $bios.SMBIOSBIOSVersion
}

return $result | ConvertTo-Json -Compress
'@

$ScriptContent = [Convert]::ToBase64String(
    [Text.Encoding]::UTF8.GetBytes($DetectionScript)
)

$Body = @{
    displayName = $ScriptName
    description = "Detect BIOS version for custom compliance."
    publisher = $Publisher
    version = $Version
    runAsAccount = "system"
    runAs32Bit = $false
    enforceSignatureCheck = $false
    detectionScriptContent = $ScriptContent
} | ConvertTo-Json -Depth 10

$Script = Invoke-MgGraphRequest `
    -Method POST `
    -Uri "https://graph.microsoft.com/beta/deviceManagement/deviceComplianceScripts" `
    -Body $Body `
    -ContentType "application/json"

Write-Host "Created Script ID: $($Script.id)"
