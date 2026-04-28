<#
.SYNOPSIS
    Déploiement automatisé du rôle AD DS et promotion du Contrôleur de Domaine.

.DESCRIPTION
    Ce script installe les outils d'administration et le rôle AD DS, puis configure une nouvelle forêt Active Directory.
    Il inclut une gestion des erreurs robuste et un journal d'audit.

.PARAMETER DomainName
    Le nom complet du domaine (ex: meilleur.local).

.PARAMETER NetbiosName
    Le nom NETBIOS du domaine (ex: MEILLEUR).

.EXAMPLE
    .\Setup-ADDS.ps1 -DomainName "meilleur.local" -NetbiosName "MEILLEUR"
#>

Param(
    [Parameter(Mandatory=$true)]
    [string]$DomainName,

    [Parameter(Mandatory=$true)]
    [string]$NetbiosName
)

$LogFile = "..\..\logs\ADDS_Deployment.log"

Function Write-Log {
    Param([string]$Message)
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[$TimeStamp] $Message" | Out-File -FilePath $LogFile -Append
    Write-Host "[$TimeStamp] $Message" -ForegroundColor Cyan
}

Try {
    Write-Log "--- Début de l'installation du rôle AD DS ---"
    
    # 1. Installation des fonctionnalités
    Write-Log "Installation des outils et du rôle binaire..."
    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -ErrorAction Stop
    
    # 2. Configuration de la forêt
    Write-Log "Promotion du serveur en DC (Nouvelle Forêt : $DomainName)..."
    # Note: Le mot de passe de restauration (SafeModeAdministratorPassword) est fixé par défaut pour la démo.
    # Dans un environnement réel, il serait passé via un objet sécurisé.
    $SafePassword = ConvertTo-SecureString "P@ssword2026!" -AsPlainText -Force
    
    Install-ADDSForest `
        -DomainName $DomainName `
        -DomainNetbiosName $NetbiosName `
        -ForestMode WinThreshold `
        -DomainMode WinThreshold `
        -InstallDns:$true `
        -SafeModeAdministratorPassword $SafePassword `
        -Force:$true `
        -NoRebootOnCompletion:$false

    Write-Log "Déploiement terminé avec succès. Redémarrage requis."
}
Catch {
    Write-Log "ERREUR CRITIQUE : $($_.Exception.Message)"
    Exit 1
}
