$bios = Get-CimInstance -ClassName Win32_BIOS

$result = @{
    BIOSVersion = $bios.SMBIOSBIOSVersion
}

return $result | ConvertTo-Json -Compress
