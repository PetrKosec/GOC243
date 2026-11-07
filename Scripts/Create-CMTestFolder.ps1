$FolderPath = "C:\Test"

if (-not (Test-Path -Path $FolderPath))
{
    New-Item -Path $FolderPath -ItemType Directory -Force | Out-Null
    Write-Output "Folder created: $FolderPath"
}
else
{
    Write-Output "Folder already exists: $FolderPath"
}
