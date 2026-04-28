<#
.SYNOPSIS
    Génération de la hiérarchie des Unités Organisationnelles (OU).

.DESCRIPTION
    Crée une structure d'OU standardisée (Airlines Standard) pour séparer les objets par type et par département.
    Empêche la suppression accidentelle par défaut.
#>

Import-Module ActiveDirectory

$BaseOU = "OU=AIRLINES,DC=meilleur,DC=local"

# Liste des sous-OU à créer
$OUs = @(
    "OU=Administrateurs,$BaseOU",
    "OU=Utilisateurs,$BaseOU",
    "OU=Ordinateurs,$BaseOU",
    "OU=Groupes,$BaseOU",
    "OU=Serveurs,$BaseOU",
    "OU=RH,OU=Utilisateurs,$BaseOU",
    "OU=IT,OU=Utilisateurs,$BaseOU",
    "OU=Direction,OU=Utilisateurs,$BaseOU"
)

# Création de l'OU Racine si elle n'existe pas
If (-not (Get-ADOrganizationalUnit -Filter "Name -eq 'AIRLINES'")) {
    New-ADOrganizationalUnit -Name "AIRLINES" -Path "DC=meilleur,DC=local" -ProtectedFromAccidentalDeletion $true
}

# Création des sous-OUs
ForEach ($OUPath in $OUs) {
    $OUName = ($OUPath -split ",")[0].Replace("OU=","")
    $ParentPath = ($OUPath -split ",",2)[1]
    
    If (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$OUPath'")) {
        Write-Host "Création de l'OU : $OUName dans $ParentPath" -ForegroundColor Green
        New-ADOrganizationalUnit -Name $OUName -Path $ParentPath -ProtectedFromAccidentalDeletion $true
    } Else {
        Write-Host "L'OU $OUName existe déjà." -ForegroundColor Yellow
    }
}
