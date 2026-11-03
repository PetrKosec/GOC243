# Parametry
$VMName  = "CLOUD02"
$VMPath  = "E:\MACHINES-goc243\$VMName"
$VHDPath = "$VMPath\$VMName.vhdx"
$ISOPath = "E:\Temp\Windows11_Client_x64_en-us_26300_9457.iso"
$Switch  = "External"

# Vytvoření adresáře
New-Item -Path $VMPath -ItemType Directory -Force | Out-Null

# Vytvoření VM
New-VM `
    -Name $VMName `
    -Generation 2 `
    -MemoryStartupBytes 8GB `
    -Path $VMPath `
    -NewVHDPath $VHDPath `
    -NewVHDSizeBytes 60GB `
    -SwitchName $Switch

# CPU
Set-VMProcessor `
    -VMName $VMName `
    -Count 4

# Dynamická paměť
# Set-VMMemory `
#    -VMName $VMName `
#    -DynamicMemoryEnabled $true `
#    -StartupBytes 8GB `
#    -MinimumBytes 4GB `
#    -MaximumBytes 16GB

# Statická RAM 8 GB
Set-VMMemory `
    -VMName $VMName `
    -DynamicMemoryEnabled $false
    
# Secure Boot
Set-VMFirmware `
    -VMName $VMName `
    -EnableSecureBoot On `
    -SecureBootTemplate MicrosoftWindows

# Šifrovací podpora pro vTPM
Set-VMKeyProtector `
    -VMName $VMName `
    -NewLocalKeyProtector

# Povolení TPM
Enable-VMTPM `
    -VMName $VMName

Set-VMProcessor `
    -VMName $VMName `
    -ExposeVirtualizationExtensions $true

# Připojení ISO
Add-VMDvdDrive `
    -VMName $VMName `
    -Path $ISOPath

# Nastavení bootu z DVD
$DVD = Get-VMDvdDrive -VMName $VMName

Set-VMFirmware `
    -VMName $VMName `
    -FirstBootDevice $DVD

# Vygenerovat MAC a nastavit ji jako statickou
$MacAddress = (Get-VMNetworkAdapter -VMName $VMName).MacAddress

Set-VMNetworkAdapter `
    -VMName $VMName `
    -StaticMacAddress $MacAddress
    
# Kontrola
Get-VM $VMName
