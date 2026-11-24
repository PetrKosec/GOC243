Install-Module Microsoft.Graph -Scope CurrentUser
Connect-MgGraph -Scopes "Group.Read.All", "Directory.Read.All"

# Získání všech skupin
$groups = Get-MgGroup -All

# Filtrování pouze dynamických skupin
$dynamicGroups = $groups | Where-Object { $_.GroupTypes -contains "DynamicMembership" }

# Výpis názvu a pravidla členství
$export = foreach ($group in $dynamicGroups) {
    $rule = Get-MgGroup -GroupId $group.Id -Property MembershipRule | Select-Object -ExpandProperty MembershipRule
    [PSCustomObject]@{
        DisplayName     = $group.DisplayName
        Description     = $group.Description
        MembershipRule  = $rule
        GroupId         = $group.Id
    }
}

# Uložení do CSV
$export |   -Path "./DynamickeSkupiny.csv" -NoTypeInformation -Encoding UTF8
