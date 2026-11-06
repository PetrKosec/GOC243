$PolicyName = "BIOS Custom Compliance Policy"

Connect-MgGraph -Scopes `
"DeviceManagementConfiguration.ReadWrite.All",
"DeviceManagementScripts.ReadWrite.All" `
-NoWelcome

# --------------------------------------------------
# Detection Script
# --------------------------------------------------

$DetectionScript = @'
$bios = Get-CimInstance -ClassName Win32_BIOS

$result = @{
    BIOSVersion = $bios.SMBIOSBIOSVersion
}

$result | ConvertTo-Json -Compress
'@

# --------------------------------------------------
# JSON Rules
# --------------------------------------------------

$RulesJson = @'
{
  "Rules": [
    {
      "SettingName": "BIOSVersion",
      "Operator": "GreaterEquals",
      "DataType": "Version",
      "Operand": "1.25.0",
      "MoreInfoUrl": "https://contoso.com/compliance/bios",
      "RemediationStrings": [
        {
          "Language": "en_US",
          "Title": "BIOS version is not compliant",
          "Description": "Update BIOS to version 1.25.0 or later."
        }
      ]
    }
  ]
}
'@

# --------------------------------------------------
# Create Compliance Script
# --------------------------------------------------

$ScriptBody = @{
    displayName = "BIOS Version Detection"
    description = "Detect BIOS version"
    publisher = "Košec Solutions s.r.o."
    version = "1.0"
    runAsAccount = "system"
    runAs32Bit = $false
    enforceSignatureCheck = $false
    detectionScriptContent = [Convert]::ToBase64String(
        [Text.Encoding]::UTF8.GetBytes($DetectionScript)
    )
} | ConvertTo-Json -Depth 10

$ComplianceScript = Invoke-MgGraphRequest `
    -Method POST `
    -Uri "https://graph.microsoft.com/beta/deviceManagement/deviceComplianceScripts" `
    -Body $ScriptBody `
    -ContentType "application/json"

# --------------------------------------------------
# Create Compliance Policy
# --------------------------------------------------

$PolicyBody = @{
    "@odata.type" = "#microsoft.graph.windows10CompliancePolicy"
    displayName = $PolicyName
    description = "Custom BIOS Compliance Policy"
} | ConvertTo-Json -Depth 10

$Policy = Invoke-MgGraphRequest `
    -Method POST `
    -Uri "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies" `
    -Body $PolicyBody `
    -ContentType "application/json"

# --------------------------------------------------
# Link Custom Compliance
# --------------------------------------------------

$CustomComplianceBody = @{
    deviceComplianceScriptId = $ComplianceScript.id
    rulesContent = [Convert]::ToBase64String(
        [Text.Encoding]::UTF8.GetBytes($RulesJson)
    )
} | ConvertTo-Json -Depth 5

Invoke-MgGraphRequest `
    -Method POST `
    -Uri "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies/$($Policy.id)/assignCustomComplianceScript"
    -Body $CustomComplianceBody `
    -ContentType "application/json"

Write-Host "Compliance Script ID: $($ComplianceScript.id)"
Write-Host "Policy ID: $($Policy.id)"
