#Připojení k Microsoft Graph
Connect-MgGraph -Scopes "DeviceManagementRBAC.ReadWrite.All"
 
# Scope Tags k vytvoření
$scopeTags = @(
@{
displayName = "GOC243 - L1 Support"
description = "GOPAS Courseware"
},
@{
displayName = "GOC243 - L2 Support"
description = "GOPAS Courseware"
}
)
 
foreach ($tag in $scopeTags) {
 
# Kontrola existence Scope Tagu
$existingTag = Invoke-MgGraphRequest `
-Method GET `
-Uri "https://graph.microsoft.com/beta/deviceManagement/roleScopeTags" |
Select-Object -ExpandProperty value |
Where-Object { $_.displayName -eq $tag.displayName }
 
if ($existingTag) {
Write-Host "Scope Tag '$($tag.displayName)' již existuje." -ForegroundColor Yellow
continue
}
 
$body = @{
displayName = $tag.displayName
description = $tag.description
} | ConvertTo-Json
 
try {
Invoke-MgGraphRequest `
-Method POST `
-Uri "https://graph.microsoft.com/beta/deviceManagement/roleScopeTags" `
-Body $body `
-ContentType "application/json"
 
Write-Host "Scope Tag '$($tag.displayName)' byl vytvořen." -ForegroundColor Green
}
catch {
Write-Host "Chyba při vytváření Scope Tagu '$($tag.displayName)': $_" -ForegroundColor Red
}
}
 
# Odpojení
Disconnect-MgGraph
Instalace modulu Graph (pokud
