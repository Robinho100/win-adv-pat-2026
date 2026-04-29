<#
.SYNOPSIS
    GPO Security Audit & Verification.
    Part of Titouan's tasks for PAT 2026.
#>

Write-Host "--- [CHECKING PASSWORD POLICY] ---" -ForegroundColor Orange
Get-ADDefaultDomainPasswordPolicy

Write-Host "`n--- [LISTING ALL GPOs] ---" -ForegroundColor Orange
Get-GPO -All | Select-Object DisplayName, Status, GpoStatus

Write-Host "`n--- [FIREWALL STATUS] ---" -ForegroundColor Orange
Get-NetFirewallProfile | Select-Object Name, Enabled
