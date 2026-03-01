# Documentation Nmap

## 1. Introduction

**Nmap** (*Network Mapper*) est un outil open-source de découverte réseau et d'audit de sécurité. Il permet de scanner des hôtes, identifier les services en cours d'exécution et détecter les versions de logiciels installés sur un réseau.

---

## 2. Installation

```bash
# Debian / Ubuntu
sudo apt install nmap

# Fedora / RHEL
sudo dnf install nmap

# Vérification de la version
nmap --version
```

---

## 3. Syntaxe de base

```
nmap [options] [cible]
```

La cible peut être une adresse IP, un nom d'hôte, un sous-réseau (CIDR) ou un fichier contenant une liste d'IPs.

---

## 4. Scans fondamentaux

### 4.1 Scan simple (par défaut)

Effectue un scan SYN sur les 1000 ports les plus courants.

```bash
nmap 192.168.1.1
```

### 4.2 Scan de réseau (découverte d'hôtes)

Détecte les machines actives sur un sous-réseau sans scanner les ports.

```bash
nmap -sn 192.168.1.0/24
```

### 4.3 Scan de tous les ports

```bash
nmap -p- 192.168.1.1          # ports 1 à 65535
nmap -p 1-10000 192.168.1.1   # plage personnalisée
nmap -p 22,80,443 192.168.1.1 # ports spécifiques
```

---

## 5. Types de scans

| Option | Type de scan | Description |
|--------|-------------|-------------|
| `-sT` | TCP Connect | Scan complet TCP (pas besoin de root) |
| `-sS` | TCP SYN (Stealth) | Scan furtif, ne termine pas la connexion (root requis) |
| `-sU` | UDP | Scan des ports UDP |
| `-sA` | ACK | Utilisé pour détecter les firewalls |
| `-sF` | FIN | Envoie un paquet FIN pour tester les filtres |
| `-sV` | Version | Détecte les versions des services |
| `-sO` | IP Protocol | Détecte les protocoles IP supportés |

### Exemple combiné

```bash
nmap -sS -sU -p- 192.168.1.1
```

---

## 6. Détection de versions et du système d'exploitation

```bash
nmap -sV 192.168.1.1             # versions des services
nmap -O 192.168.1.1              # détection du système d'exploitation
nmap -sV -O --version-intensity 5 192.168.1.1  # combinaison approfondie
```

> **Note :** La détection du SO (`-O`) nécessite au moins un port TCP ouvert et des privileges root.

---

## 7. Scripts NSE (Nmap Scripting Engine)

Le moteur de scripts NSE permet d'exécuter des tests avancés (vulnérabilités, brute-force, énumération, etc.).

### Exécution de scripts

```bash
nmap --script=http-title 192.168.1.1                    # titre de la page web
nmap --script=ssh-brute 192.168.1.1                     # tentative brute-force SSH
nmap --script=smb-vuln* 192.168.1.1                     # vulnérabilités SMB
nmap --script=default 192.168.1.1                       # scripts par défaut (safe)
nmap --script=vuln 192.168.1.1                          # scripts de détection de vulnérabilités
```

### Catégories de scripts disponibles

`auth`, `broadcast`, `brute`, `default`, `dos`, `exploit`, `fuzzer`, `intrusive`, `malware`, `safe`, `vuln`

### Passer des arguments à un script

```bash
nmap --script=http-brute --script-args=userdb=users.txt,passdb=pass.txt 192.168.1.1
```

---

## 8. Scan rapide et parallélisme

```bash
nmap -T4 192.168.1.0/24          # template de timing rapide (T0 à T5)
nmap -T5 --min-parallelism=50 192.168.1.0/24   # scan très agressif
nmap --min-rate=1000 192.168.1.1  # au moins 1000 paquets/sec
```

| Template | Nom | Usage recommandé |
|----------|-----|-----------------|
| `-T0` | Paranoid | IDS furtif |
| `-T1` | Sneaky | Très lent |
| `-T2` | Polite | Éviter la surcharge |
| `-T3` | Normal | Par défaut |
| `-T4` | Aggressive | Réseau rapide et fiable |
| `-T5` | Insane | Très rapide, risque de paquets perdus |

---

## 9. Évasion de firewalls

```bash
nmap -f 192.168.1.1                        # fragmentation des paquets
nmap --mtu 16 192.168.1.1                  # taille MTU personnalisée
nmap -S 10.0.0.5 192.168.1.1              # usurpation d'IP source
nmap --decoy RND:10 192.168.1.1            # décoys aléatoires
nmap --source-port 80 192.168.1.1          # port source spécifique
nmap --data-length 32 192.168.1.1          # ajout de données aléatoires
```

---

## 10. Sauvegarde des résultats

```bash
nmap -oN output.txt   192.168.1.1   # format texte lisible
nmap -oX output.xml   192.168.1.1   # format XML
nmap -oG output.gnmap 192.168.1.1   # format Grepable
nmap -oA output       192.168.1.1   # les trois formats simultanément
```

---

## 11. Lecture depuis un fichier cible

```bash
nmap -iL targets.txt   # scanne toutes les IPs listées dans le fichier
```

---

## 12. Exemples pratiques

### Reconnaissance complète d'un hôte

```bash
nmap -sS -sV -O -p- --script=default -T4 --reason -vv 192.168.1.1
```

### Scan réseau rapide avec détection de services

```bash
nmap -sV -T4 -p 22,80,443,3389,8080 192.168.1.0/24
```

### Détection de vulnérabilités sur un sous-réseau

```bash
nmap --script=vuln -T4 192.168.1.0/24
```

### Scan UDP des ports courants

```bash
nmap -sU -p 53,67,68,69,123,161,162,500,514,623 192.168.1.1
```

---

## 13. Options utiles divers

| Option | Description |
|--------|-------------|
| `-v` / `-vv` | Verbosité accrue |
| `--reason` | Affiche la raison du statut de chaque port |
| `--open` | Affiche uniquement les ports ouverts |
| `-n` | Désactive la résolution DNS |
| `-Pn` | Désactive la détection d'hôtes (traite la cible comme active) |
| `--traceroute` | Effectue un traceroute vers chaque hôte |
| `-h` | Affiche l'aide complète |

---

## 14. Ressources

- Site officiel : [https://nmap.org](https://nmap.org)
- Documentation NSE : [https://nmap.org/nse/](https://nmap.org/nse/)
- Base de scripts : [https://scripts.nmap.org](https://scripts.nmap.org)
