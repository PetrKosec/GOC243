# Parametry
$VMName  = "CLOUD01"
$VMPath  = "E:\MACHINES-goc243\$VMName"
$VHDPath = "$VMPath\$VMName.vhdx"
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
    
# Kontrola
Get-VM $VMName
Get-VMTPM $VMName
