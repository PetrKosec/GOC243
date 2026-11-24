# Get devices running Windows
Get-MgDeviceManagementManagedDevice -Filter "operatingSystem eq 'Windows'" | Select-Object DeviceName, OperatingSystem

# Get non-compliant devices
Get-MgDeviceManagementManagedDevice -Filter "complianceState eq 'noncompliant'" | Select-Object DeviceName, ComplianceState
