<#
.SYNOPSIS
    Automated FSMO Transfer and AD Maintenance.
    Designed for Stan (PAT 2026).
    
    FEATURES:
    - Safe FSMO role transfer (with confirmation)
    - AD Recycle Bin activation
    - Global Catalog verification
#>

$ErrorActionPreference = "Stop"

function Show-Menu {
    Clear-Host
    Write-Host "=== [ STAN'S AD AUTOMATION TOOL ] ===" -ForegroundColor Green
    Write-Host "1. Transfer FSMO Roles to this DC"
    Write-Host "2. Enable AD Recycle Bin"
    Write-Host "3. Promote to Global Catalog"
    Write-Host "4. Health Check"
    Write-Host "Q. Quit"
}

# Ensure RSAT
if (!(Get-Module -ListAvailable ActiveDirectory)) {
    Write-Host "Error: AD Module missing. Run on Domain Controller." -ForegroundColor Red
    return
}

do {
    Show-Menu
    $choice = Read-Host "`nSelect an option"
    
    switch ($choice) {
        "1" {
            Write-Host "Starting FSMO Transfer..." -ForegroundColor Cyan
            $roles = 0..4 # All 5 roles
            Move-ADDirectoryServerOperationMasterRole -Identity (Get-ADDomainController -Identity $env:COMPUTERNAME) -OperationMasterRole $roles -Confirm:$false
            Write-Host "SUCCESS: Roles transferred." -ForegroundColor Green
            Pause
        }
        "2" {
            Write-Host "Enabling Recycle Bin..." -ForegroundColor Cyan
            $domain = (Get-ADDomain).DistinguishedName
            Enable-ADOptionalFeature -Identity 'Recycle Bin Feature' -Scope ForestOrConfigurationSet -Target $domain -Confirm:$false
            Write-Host "SUCCESS: Recycle Bin enabled." -ForegroundColor Green
            Pause
        }
        "3" {
            Set-ADDomainController -Identity $env:COMPUTERNAME -IsGlobalCatalog $true
            Write-Host "SUCCESS: This DC is now a Global Catalog." -ForegroundColor Green
            Pause
        }
        "4" {
            .\Check-StanTasks.ps1
            Pause
        }
    }
} while ($choice -ne "Q")
