# Projet Windows Advanced - PAT 2026

## 📌 Présentation du Projet
Ce projet s'inscrit dans le cadre du module **Windows Advanced (PAT 2026)**. L'objectif est de mettre en place une infrastructure Active Directory complexe, sécurisée et optimisée, répondant aux standards industriels et aux préconisations de la CNIL.

## 👥 Équipe & Répartition des Tâches
L'équipe est composée de 3 membres, chacun responsable d'un pilier de l'infrastructure :

### 🔵 Robin (Responsable Infrastructure & Coeur AD)
- **Installation & Provisioning :** Mise en place du contrôleur de domaine principal.
- **Gestion des Postes :** Intégration et configuration de Windows 11.
- **Identités :** Gestion des SID et structures d'Unités Organisationnelles (OU).
- **DNS :** Configuration avancée des zones et résolutions.

### 🟢 Stan (Responsable Rôles & Services)
- **FSMO :** Gestion et transfert des 5 rôles Flexible Single Master Operation.
- **Catalogue Global :** Optimisation des recherches inter-domaines.
- **Domaine :** Configuration et maintenance du domaine `meilleur.local`.

### 🟠 Titouan (Responsable Sécurité & Applicatif)
- **GPO CNIL :** Implémentation des politiques de sécurité basées sur les recommandations de la CNIL.
- **Déploiement Logiciel :** Packaging et déploiement de Firefox ESR via GPO.
- **Hardening :** Sécurisation globale des terminaux et du réseau.

## 📂 Structure du Repo
- `/docs` : Documentation technique détaillée par responsable.
- `/scripts` : Scripts PowerShell pour l'automatisation.
- `/reports` : Livrables, captures d'écran et rapports de soutenance.

## 🚀 Roadmap
1. [ ] Initialisation de l'AD et DNS (Robin)
2. [ ] Configuration du domaine `meilleur.local` (Stan)
3. [ ] Mise en place des GPO de base (Titouan)
4. [ ] Transfert des rôles FSMO (Stan)
5. [ ] Déploiement Firefox ESR (Titouan)
6. [ ] Tests d'intégration et audit de sécurité final.
