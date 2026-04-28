<#
.SYNOPSIS
    Script client pour la jonction automatisée au domaine.

.DESCRIPTION
    Renomme la machine selon un préfixe défini et la joint au domaine meilleur.local.
    Place automatiquement l'ordinateur dans l'OU 'Ordinateurs' d'AIRLINES.
#>

Param(
    [Parameter(Mandatory=$true)]
    [string]$NewComputerName
)

$Domain = "meilleur.local"
$OUPath = "OU=Ordinateurs,OU=AIRLINES,DC=meilleur,DC=local"

Write-Host "--- JONCTION AU DOMAINE ---" -ForegroundColor Cyan

# 1. Renommage (si nécessaire)
if ($env:COMPUTERNAME -ne $NewComputerName) {
    Write-Host "Renommage du PC : $env:COMPUTERNAME -> $NewComputerName" -ForegroundColor Yellow
    Rename-Computer -NewName $NewComputerName -Force
    Write-Host "Le PC doit être redémarré avant la jonction. Relancez le script après reboot." -ForegroundColor Red
    # Exit ici car le changement de nom nécessite un reboot pour être effectif pour l'AD
    return
}

# 2. Jonction
Try {
    Write-Host "Jonction au domaine $Domain dans l'OU $OUPath..." -ForegroundColor Yellow
    # Note: Demande les credentials de l'admin du domaine
    Add-Computer -DomainName $Domain -OUPath $OUPath -Restart -Force
} Catch {
    Write-Error "Échec de la jonction : $($_.Exception.Message)"
}
