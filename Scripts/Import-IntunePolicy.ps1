param(
    [Parameter(Mandatory)]
    [string]$Path,

    [ValidateSet("Skip","Update")]
    [string]$ExistAction = "Skip"
)

Connect-MgGraph -Scopes DeviceManagementConfiguration.ReadWrite.All

$Files = Get-ChildItem -Path $Path -Filter *.json

foreach ($File in $Files) {

    Write-Host ""
    Write-Host "========================================="
    Write-Host "Processing $($File.Name)"
    Write-Host "========================================="

    try {

        $Policy = Get-Content $File.FullName -Raw | ConvertFrom-Json
        $PolicyName = $Policy.name

        Write-Host "Policy: $PolicyName"

        # Odebrání read-only atributů
        @(
            "@odata.context",
            "id",
            "createdDateTime",
            "lastModifiedDateTime"
        ) | ForEach-Object {
            $Policy.PSObject.Properties.Remove($_)
        }

        $ExistingPolicies = Invoke-MgGraphRequest `
            -Method GET `
            -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies"

        $ExistingPolicy = $ExistingPolicies.value |
            Where-Object { $_.name -eq $PolicyName }

        if ($ExistingPolicy) {

            Write-Host "Policy already exists."

            switch ($ExistAction) {

                "Skip" {

                    Write-Host "SKIPPED" -ForegroundColor Yellow
                    continue
                }

                "Update" {

                    Write-Host "Updating existing policy..." -ForegroundColor Cyan

                    $Body = $Policy | ConvertTo-Json -Depth 50

                    Invoke-MgGraphRequest `
                        -Method PUT `
                        -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$($ExistingPolicy.id)" `
                        -Body $Body `
                        -ContentType "application/json"

                    Write-Host "UPDATED" -ForegroundColor Green
                    continue
                }
            }
        }

        # Nová politika
        $Body = $Policy | ConvertTo-Json -Depth 50

        Invoke-MgGraphRequest `
            -Method POST `
            -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies" `
            -Body $Body `
            -ContentType "application/json"

        Write-Host "CREATED" -ForegroundColor Green
    }
    catch {

        Write-Host "FAILED" -ForegroundColor Red
        Write-Host $_.Exception.Message
    }
}
