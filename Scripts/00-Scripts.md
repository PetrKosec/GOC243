### Scripts and remediations
```
• Remediations - povolit v Tenant administration - Connectors and tokens - Windows data
• Platform scripts
```
```
C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\
• IntuneManagementExtension
• AgentExecutor.log
• ClientHealth.log
```

### PowerShell Scripts

#### PREREQ:
	• max 200 KB (ASCII)
	• time out after 30 minutes
	• assigned to device (every new user except on multi-session SKU)
	• scripts don’t run on Surface Hubs or Windows S mode
	• device must be joined to Entra ID
	• No access to Windows Push Notification Services (WNS)
	• bitsadmin /util /setieproxy
	• MDMDeviceWithAAD
```
%programfiles(x86)%\Microsoft Intune Management Extension
C:\ProgramData\Microsoft\IntuneManagementExtension\Logs
```
AgentExecutor.log
```
write-output "Script worked" | out-file c:\scripts\output.txt
psexec -i -s

Write-Error -Message "Forced Fail" -Category OperationStopped
mkdir "C:\Temp"
echo "Forced Fail" | Out-File C:\Temp\Fail.txt
```

Intune Management \ Policies \ Scripts
