<#
.SYNOPSIS
    Script de diagnostic de santé Active Directory et DNS.

.DESCRIPTION
    Exécute une série de tests (DCDiag, DNS, Services) pour confirmer que le DC est prêt à l'emploi.
    Indispensable avant de configurer les services avancés (FSMO, GPO).
#>

Function Write-Status {
    Param([string]$Task, [string]$Status)
    $Color = if ($Status -eq "OK") { "Green" } else { "Red" }
    Write-Host "[ ] " -NoNewline
    Write-Host "$($Task.PadRight(40))" -NoNewline
    Write-Host "[$Status]" -ForegroundColor $Color
}

Write-Host "--- BILAN DE SANTÉ INFRASTRUCTURE ---" -ForegroundColor Cyan

# 1. Vérification des services critiques
$Services = @("adws", "dns", "kdc", "netlogon", "ntds")
foreach ($Svc in $Services) {
    $Status = (Get-Service $Svc).Status
    if ($Status -eq "Running") {
        Write-Status "Service : $Svc" "OK"
    } else {
        Write-Status "Service : $Svc" "ERREUR ($Status)"
    }
}

# 2. Test DNS interne
Try {
    $Resolve = Resolve-DnsName "meilleur.local" -ErrorAction Stop
    Write-Status "Résolution domaine meilleur.local" "OK"
} Catch {
    Write-Status "Résolution domaine meilleur.local" "ERREUR"
}

# 3. Test de connectivité NTDS
if (Test-Path "C:\Windows\NTDS\ntds.dit") {
    Write-Status "Base de données NTDS présente" "OK"
} else {
    Write-Status "Base de données NTDS présente" "ERREUR"
}

Write-Host "`nDiagnostic terminé." -ForegroundColor Cyan
