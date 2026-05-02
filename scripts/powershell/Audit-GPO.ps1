<#
.SYNOPSIS
    Advanced GPO & Security Audit Script (CNIL Standards).
    Part of Titouan's tasks for PAT 2026.
#>

$ErrorActionPreference = "Stop"

function Write-Header($text) {
    Write-Host "`n" + ("-" * 50) -ForegroundColor Gray
    Write-Host " $text" -ForegroundColor Black -BackgroundColor Yellow
    Write-Host ("-" * 50) -ForegroundColor Gray
}

# Check for Modules
if (!(Get-Module -ListAvailable ActiveDirectory)) {
    Write-Host "CRITICAL: ActiveDirectory module missing." -ForegroundColor Red
    exit 1
}
if (!(Get-Module -ListAvailable GroupPolicy)) {
    Write-Host "CRITICAL: GroupPolicy module missing." -ForegroundColor Red
    exit 1
}

try {
    Write-Header "SECURITY & GPO AUDIT (CNIL COMPLIANCE)"

    Write-Host "`n[1] DOMAIN PASSWORD POLICY" -ForegroundColor Cyan
    $policy = Get-ADDefaultDomainPasswordPolicy
    [PSCustomObject]@{
        "Min Length"      = $policy.MinPasswordLength
        "Complexity"      = $policy.PasswordComplexityEnabled
        "History Count"   = $policy.PasswordHistoryCount
        "Lockout Threshold" = $policy.LockoutThreshold
    } | Format-Table

    Write-Host "`n[2] GPO INVENTORY" -ForegroundColor Cyan
    Get-GPO -All | Select-Object DisplayName, GpoStatus | Format-Table -AutoSize

    Write-Host "`n[3] SEARCHING FOR SPECIFIC POLICIES" -ForegroundColor Cyan
    $criticalGPOs = @("CNIL-Hardening", "Firefox-ESR-Deploy", "USB-Block")
    foreach ($name in $criticalGPOs) {
        $gpo = Get-GPO -Name $name -ErrorAction SilentlyContinue
        if ($gpo) {
            Write-Host "[OK] Found: $name" -ForegroundColor Green
        } else {
            Write-Host "[MISSING] GPO: $name (Action required by Titouan)" -ForegroundColor Red
        }
    }

    Write-Host "`n[4] LOCAL FIREWALL STATUS" -ForegroundColor Cyan
    Get-NetFirewallProfile | Select-Object Name, Enabled | Format-Table

} catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
}
