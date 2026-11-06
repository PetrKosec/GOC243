# Vytvoření adresářové struktury na E:\
# Nejprve ověří existenci složek

$folders = @(
    "E:\SOURCES",
    "E:\SOURCES\APPs",
    "E:\SOURCES\Scripts",
    "E:\SOURCES\ISO",
    "E:\SOURCES\APPs\Microsoft",
    "E:\SOURCES\APPs\7-ZIP",
    "E:\SOURCES\APPs\7-ZIP\26.01",
    "E:\SOURCES\APPs\7-ZIP\25.01"
)

foreach ($folder in $folders) {
    if (-not (Test-Path -Path $folder)) {
        New-Item -Path $folder -ItemType Directory -Force | Out-Null
        Write-Host "[CREATED] $folder" -ForegroundColor Green
    }
    else {
        Write-Host "[EXISTS ] $folder" -ForegroundColor Yellow
    }
}

Write-Host "`nKontrola dokončena." -ForegroundColor Cyan
