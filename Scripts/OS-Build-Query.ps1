Connect-MgGraph -Scopes "DeviceManagementManagedDevices.Read.All"

Get-MgDeviceManagementManagedDevice -Filter "operatingSystem eq 'Windows'" -All |
  Group-Object { if ($_.OsVersion -like "10.0.26300*") { "26H2" }
                 elseif ($_.OsVersion -like "10.0.26200*") { "25H2" }
                 elseif ($_.OsVersion -like "10.0.26100*") { "24H2" }
                 else { "Other" } } |
  Select-Object Name, Count
