Install-Module PowerShellGet
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

Install-Module Microsoft.Graph -Scope CurrentUser -Repository PSGallery -Force
