<#
.SYNOPSIS
    Advanced AD Health & FSMO Audit Script.
    Part of Stan's tasks for PAT 2026.
#>

$ErrorActionPreference = "Stop"

function Write-Header($text) {
    Write-Host "`n" + ("=" * 40) -ForegroundColor Gray
    Write-Host " $text" -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host ("=" * 40) -ForegroundColor Gray
}

# Check for RSAT
if (!(Get-Module -ListAvailable ActiveDirectory)) {
    Write-Host "CRITICAL: ActiveDirectory module not found. Please run on DC or install RSAT." -ForegroundColor Red
    exit 1
}

try {
    Write-Header "AD INFRASTRUCTURE AUDIT"

    Write-Host "`n[1] FSMO ROLES" -ForegroundColor Cyan
    $fsmo = Get-ADForest | Select-Object SchemaMaster, DomainNamingMaster
    $domainFsmo = Get-ADDomain | Select-Object PDCEmulator, RIDMaster, InfrastructureMaster
    
    [PSCustomObject]@{
        "Schema Master"        = $fsmo.SchemaMaster
        "Domain Naming Master" = $fsmo.DomainNamingMaster
        "PDC Emulator"         = $domainFsmo.PDCEmulator
        "RID Master"           = $domainFsmo.RIDMaster
        "Infrastructure"       = $domainFsmo.InfrastructureMaster
    } | Format-List

    Write-Host "`n[2] GLOBAL CATALOG STATUS" -ForegroundColor Cyan
    Get-ADDomainController -Filter * | Select-Object Name, IsGlobalCatalog, Site | Format-Table -AutoSize

    Write-Host "`n[3] FUNCTIONAL LEVELS" -ForegroundColor Cyan
    $domain = Get-ADDomain
    $forest = Get-ADForest
    Write-Host "Domain ($($domain.Name)): $($domain.DomainMode)"
    Write-Host "Forest ($($forest.Name)): $($forest.ForestMode)"

    Write-Host "`n[4] AD RECYCLE BIN" -ForegroundColor Cyan
    $recycleBin = Get-ADOptionalFeature -Filter 'Name -like "Recycle Bin Feature"'
    if ($recycleBin.EnabledScopes) {
        Write-Host "STATUS: ENABLED" -ForegroundColor Green
    } else {
        Write-Host "STATUS: DISABLED (Action required by Stan)" -ForegroundColor Yellow
    }

} catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
}
