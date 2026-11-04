# Microsoft Graph
Connect-MgGraph -Scopes "Group.ReadWrite.All"

$Groups = @(
    @{
        DisplayName = "GOC243-INTUNE-Phase-LAB"
        Description = "Lab and test devices for Intune deployments"
        MailNickname = "INTUNEPhaseLAB"
    },
    @{
        DisplayName = "GOC243-INTUNE-Phase-PRODUCTION"
        Description = "Production devices for Intune deployments"
        MailNickname = "INTUNEPhasePRODUCTION"
    },
    @{
        DisplayName = "GOC243-INTUNE-Ring-1"
        Description = "Pilot ring (IT administrators)"
        MailNickname = "INTUNERing1"
    },
    @{
        DisplayName = "GOC243-INTUNE-Ring-2"
        Description = "Early adopters and power users"
        MailNickname = "INTUNERing2"
    },
    @{
        DisplayName = "GOC243-INTUNE-Ring-3"
        Description = "Broad production deployment"
        MailNickname = "INTUNERing3"
    }
)

foreach ($Group in $Groups) {
    try {
        New-MgGroup `
            -DisplayName $Group.DisplayName `
            -Description $Group.Description `
            -MailEnabled:$false `
            -MailNickname $Group.MailNickname `
            -SecurityEnabled:$true

        Write-Host "Created: $($Group.DisplayName)" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed: $($Group.DisplayName)" -ForegroundColor Red
        Write-Host $_.Exception.Message
    }
}
