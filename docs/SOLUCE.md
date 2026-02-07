![separe](https://github.com/studoo-app/.github/blob/main/profile/studoo-banner-logo.png)
# Hackathon 2026 - The Rooms - SOLUTION
[![Version](https://img.shields.io/badge/Version-2026-blue)]()

## Solution détaillée

### Niveau 1: Exploration systèmes Linux

- lister les fichiers et dossiers cachés avec `ls -la`
- trouver le dossier caché `.secrets/.hidden` et accéder à son contenu
- trouver le fichier `key` et l'utiliser pour se connecter en SSH au niveau suivant
- Le fichier backup_credentials.txt est un leurre, il contient des informations fausses pour détourner les participants


### Niveau 2: Authentification SSH par clé privée

- lister les fichiers et dossiers cachés avec `ls -la`
- trouver le dossier caché `.confidential/.hidden` et accéder à son contenu
- trouver le fichier `key_rsa` et l'utiliser pour se connecter en SSH au niveau suivant
- Le dossier `.keys` est un leurre, il contient des clés privées qui ne fonctionnent pas

**Commande pour se connecter en SSH avec la clé privée:**
```bash
ssh -i key_rsa lvl03@10.100.3.2
```

### Niveau 3: Détecter le / les cryptages utilisés et décoder des messages

**WORK IN PROGRESS**

### Niveau 4: Naviguer dans le labyrinthe et trouver la sortie

- Pour trouver la sortie du labyrinthe, il faut se suivre les IPs se terminant par des nombre premiers dans l'ordre croissant
- Il est possible de trouver ces IPs en analysant les fichiers de configuration SSH des différents nœuds du labyrinthe, chaque fichier conntient une restriction d'accès à une IP spécifique
- Voici la liste des IPs à suivre pour trouver la sortie du labyrinthe:
  - 10.100.4.17 (node 0)
  - 10.100.4.23 (node 1)
  - 10.100.4.31 (node 3)
  - 10.100.4.37 (node 5)
- Les autres IPs sont des leurres, elles ne mènent à rien ou à des impasses

### Niveau 5: Utiliser le social engineering pour obtenir des informations et cracker un mot de passe

### Niveau 6: Trouver la bonne séquence

### Niveau 7: Attaquer la base de données d'un site web

### Niveau 8: Fragment Hunt

L'idée ici est de récupérer des fragments d'informations détenues dans les 4 machines gardiennes. 
Chaque machine contient:
 - Une partie de la sequence de port knocking 
 - Une partie de la passphrase de la clé ssh

- Premier Gardien
  - WIP
  - WIP
- Deuxième Gardien
  - WIP
  - WIP
- Troisième Gardien
  - WIP
  - WIP
- Quatrième Gardien
  - WIP
  - WIP
  
  **WORK IN PROGRESS**

### Niveau 9: The End

## Fichier 