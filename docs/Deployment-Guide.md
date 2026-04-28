# 📖 Guide de Déploiement Technique

Ce document détaille la procédure pour utiliser les scripts d'automatisation et garantir une infrastructure conforme aux attentes du projet PAT 2026.

## 🚀 Étape 1 : Promotion du DC
Le script `Setup-ADDS.ps1` automatise l'installation binaire et la promotion.

**Usage :**
```powershell
.\scripts\powershell\Setup-ADDS.ps1 -DomainName "meilleur.local" -NetbiosName "MEILLEUR"
```
*   **Impact :** Le serveur redémarrera automatiquement pour finaliser la promotion.
*   **Logs :** Consultables dans `logs/ADDS_Deployment.log`.

## 🏗️ Étape 2 : Structuration de l'AD
Une fois le DC opérationnel, lancez `Create-OUStructure.ps1` pour générer l'arborescence.

**Usage :**
```powershell
.\scripts\powershell\Create-OUStructure.ps1
```
*   **Structure cible :** Une OU racine `AIRLINES` contenant des sous-OUs segmentées par usage (Utilisateurs, Ordinateurs, Serveurs) et par département (RH, IT, Direction).
*   **Sécurité :** Toutes les OUs sont protégées contre la suppression accidentelle.

## 🛡️ Best Practices Appliquées
1.  **Modularité :** Les scripts sont séparés par responsabilité (Installation vs Configuration).
2.  **Idempotence :** Le script de structure d'OU peut être relancé sans créer de doublons ou d'erreurs.
3.  **Traçabilité :** Chaque action majeure de l'installation est loguée avec un timestamp.
