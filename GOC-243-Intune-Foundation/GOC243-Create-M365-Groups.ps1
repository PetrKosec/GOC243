# Microsoft Graph
Connect-MgGraph -Scopes "Group.ReadWrite.All"

# L1 Support
New-MgGroup `
    -DisplayName "L1 Support" `
    -Description "First line support team" `
    -MailEnabled:$true `
    -MailNickname "L1Support" `
    -SecurityEnabled:$false `
    -GroupTypes @("Unified")

# L2 Support
New-MgGroup `
    -DisplayName "L2 Support" `
    -Description "Second line support team" `
    -MailEnabled:$true `
    -MailNickname "L2Support" `
    -SecurityEnabled:$false `
    -GroupTypes @("Unified")

# L3 Support
New-MgGroup `
    -DisplayName "L3 Support" `
    -Description "Third line support team" `
    -MailEnabled:$true `
    -MailNickname "L3Support" `
    -SecurityEnabled:$false `
    -GroupTypes @("Unified")
