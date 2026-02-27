![separe](https://github.com/studoo-app/.github/blob/main/profile/studoo-banner-logo.png)
# Hackathon 2026 - The Rooms
[![Version](https://img.shields.io/badge/Version-2026-blue)]()

![wallapper](docs/images/wallpaper-1.jpg)

## Description
Bienvenue dans "The Rooms", un labyrinthe virtuel conçu pour tester et améliorer vos compétences en cybersécurité. 
Chaque niveau nécessite l'application de diverses techniques et compétences en cybersécurité ou informatique
pour déverouiller et accéder au niveau suivant.

## Objectifs Pédagogiques

- Maîtriser les techniques SSH 
- Développer des compétences en reconnaissance réseau
- Pratiquer la cryptographie appliquée
- Comprendre le social engineering
- Exploiter des vulnérabilités web (SQLi)
- Assembler des informations fragmentées
- Développer une méthodologie d'audit systématique

## Description des niveaux

| Niveau | Objectif | Compétences développées |
|--------|--|--|
| Niveau 1 | savoir explorer et détecter les dosseirs cachés | Exploration systèmes Linux |
| Niveau 2 | Authentification SSH par clé privée | ssh avancé |
| Niveau 3 | Détecter le / les cryptages utilisés et décoder des messages | Cryptographie |
| Niveau 4 | Naviguer dans le labyrinthe et trouver la sortie | Exploration réseau et retro engineering de configuration SSH |
| Niveau 5 | Utiliser le social engineering pour obtenir des informations et cracker un mot de passe | Social engineering |
| Niveau 6 | Trouver la bonne séquence | Port knocking |
| Niveau 7 | Attaquer la base de données d'un site web | Injection sql |
| Niveau 8 | Analyser les fichiers disponibles pour avancer |  Analyse de logs, port knocking, élevation de privilèges|
| Niveau 9 | The End | Reconstruction de clé |

## Démarrage et accès au Hub

### Démarrage des containers

Sur le serveur hôte, lancez la commande suivante pour démarrer les containers Docker :

```bash
    docker compose up -d
```

### Accès au Hub

```bash
    ssh -p 2222 challenger@<ip_address>
 
    # Password : welcome
```

