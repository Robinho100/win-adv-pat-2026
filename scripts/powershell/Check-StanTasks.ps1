<#
.SYNOPSIS
    Checks and displays FSMO roles and Global Catalog status.
    Part of Stan's tasks for PAT 2026.
#>

Write-Host "--- [CHECKING FSMO ROLES] ---" -ForegroundColor Cyan
netdom query fsmo

Write-Host "`n--- [CHECKING GLOBAL CATALOG STATUS] ---" -ForegroundColor Cyan
Get-ADDomainController -Filter * | Select-Object Name, IsGlobalCatalog, Site

Write-Host "`n--- [DOMAIN & FOREST FUNCTIONAL LEVELS] ---" -ForegroundColor Cyan
Get-ADDomain | Select-Object Name, DomainMode
Get-ADForest | Select-Object Name, ForestMode

Write-Host "`n--- [AD RECYCLE BIN STATUS] ---" -ForegroundColor Cyan
Get-ADOptionalFeature -Filter 'Name -like "Recycle Bin Feature"' | Select-Object Name, EnabledScopes
