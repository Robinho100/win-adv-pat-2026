<#
.SYNOPSIS
    Configuration avancée du service DNS pour le domaine meilleur.local.

.DESCRIPTION
    Ce script automatise la création des zones de recherche inversée et la configuration des redirecteurs DNS (Cloudflare/Google) pour assurer la résolution externe.
    Il inclut également des paramètres de nettoyage (scavenging) pour maintenir une zone propre.
#>

Import-Module DNSServer

$NetworkRange = "192.168.1.0/24" # À adapter selon l'infra réelle
$ReverseZoneName = "1.168.192.in-addr.arpa"
$Forwarders = @("1.1.1.1", "8.8.8.8")

Function Write-Log {
    Param([string]$Message)
    Write-Host "[DNS-CONFIG] $Message" -ForegroundColor Yellow
}

Try {
    # 1. Création de la zone de recherche inversée
    If (-not (Get-DnsServerZone -Name $ReverseZoneName -ErrorAction SilentlyContinue)) {
        Write-Log "Création de la zone inversée : $ReverseZoneName"
        Add-DnsServerPrimaryZone -Name $ReverseZoneName -ReplicationScope Forest
    } Else {
        Write-Log "La zone inversée existe déjà."
    }

    # 2. Configuration des redirecteurs
    Write-Log "Configuration des redirecteurs externes : $Forwarders"
    Set-DnsServerForwarder -IPAddress $Forwarders -PassThru

    # 3. Activation du nettoyage (Scavenging)
    Write-Log "Activation du nettoyage automatique des enregistrements obsolètes."
    Set-DnsServerScavenging -ScavengingState $true -ScavengingInterval 07.00:00:00

    Write-Log "Configuration DNS terminée avec succès."
}
Catch {
    Write-Error "Échec de la configuration DNS : $($_.Exception.Message)"
}
