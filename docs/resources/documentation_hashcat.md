# Documentation Hashcat

## Présentation

**Hashcat** est un outil de récupération de mots de passe considéré comme le plus rapide du marché. Il exploite la puissance du GPU (carte graphique) pour accélérer les attaques de cracking de hachages cryptographiques. Il supporte plus de 300 types de hachages et plusieurs modes d'attaque.

---

## Installation

### Linux (Debian/Ubuntu)
```bash
sudo apt update
sudo apt install hashcat
```

### Vérification de la version
```bash
hashcat --version
```

### Vérification des drivers GPU
```bash
hashcat -I
```
Cette commande affiche les périphériques GPU détectés et leur compatibilité avec hashcat.

---

## Modes d'attaque

Hashcat met à disposition plusieurs modes d'attaque, chacun adapté à un contexte précis.

| Mode | Description | Option |
|------|-------------|--------|
| **0** | Dictionnaire | `-a 0` |
| **1** | Combinaison | `-a 1` |
| **3** | Brute-force | `-a 3` |
| **4** | Hybrid : Dictionnaire + masque | `-a 4` |
| **5** | Hybrid : Masque + dictionnaire | `-a 5` |
| **6** | Hybrid : Dictionnaire + dictionnaire | `-a 6` |

### Masques (Brute-force)

Les masques permettent de définir le jeu de caractères utilisé dans l'attaque brute-force.

| Placeholder | Jeu de caractères |
|-------------|-------------------|
| `?l` | Lettres minuscules (a–z) |
| `?u` | Lettres majuscules (A–Z) |
| `?d` | Chiffres (0–9) |
| `?s` | Caractères spéciaux |
| `?a` | Alphanumériaque + spéciaux (`?l?u?d?s`) |
| `?w` | Mot de passe par défaut du clavier |

---

## Types de hachages courants

| Code `-m` | Algorithme | Exemple de hachage |
|-----------|------------|---------------------|
| `0` | MD5 | `d41d8cd98f00b204e9800998ecf8427e` |
| `100` | SHA-1 | `da39a3ee5e6b4b0d3255bfef95601890afd80709` |
| `1400` | SHA-256 | `e3b0c44298fc1c149afbf4c8996fb924...` |
| `1800` | SHA-512 (Unix) | `$6$rounds=...` |
| `3200` | bcrypt | `$2a$12$...` |
| `5600` | NetNTLMv2 | Capture réseau Windows |
| `13400` | KeePass | Fichier `.kdbx` |
| `22400` | SQLCipher | Base de données chiffrée |

Pour voir la liste complète :
```bash
hashcat --help | grep -i "hash-mode"
```
ou visiter la page officielle : [https://hashcat.net/wiki/doku.php?id=example_hashes](https://hashcat.net/wiki/doku.php?id=example_hashes)

---

## Exemples d'utilisation

### Attaque par dictionnaire sur un hachage MD5
```bash
hashcat -m 0 -a 0 hash.txt rockyou.txt
```

### Attaque brute-force sur SHA-256 (mots de passe de 8 caractères alphanumériques)
```bash
hashcat -m 1400 -a 3 hash.txt "?a?a?a?a?a?a?a?a"
```

### Attaque hybrid : dictionnaire + masque (ex : mot + 3 chiffres)
```bash
hashcat -m 0 -a 4 hash.txt wordlist.txt "?d?d?d"
```

### Attaque sur un fichier de hachages NTLM (Windows)
```bash
hashcat -m 5600 -a 0 ntlm_hashes.txt rockyou.txt
```

### Reprise d'une attaque interrompue
```bash
hashcat --restore
```

---

## Options utiles

| Option | Description |
|--------|-------------|
| `--force` | Ignore les avertissements (utile en lab) |
| `--show` | Affiche les mots de passe déjà trouvés |
| `-o output.txt` | Sauvegarde les résultats dans un fichier |
| `--potfile-disable` | Désactive le fichier de résultats en cache |
| `-O` | Mode optimisé (plus rapide, longueur de mot de passe limitée) |
| `--benchmark` | Test de performance du GPU |

---

## Conseils pour un CTF / Lab

- Utilisez **rockyou.txt** comme dictionnaire de base (très complet pour les mots de passe courants).
- En cas de hash inconnu, utilisez l'outil **`hash-identifier`** pour identifier le type.
- Activez le mode **optimisé (`-O`)** quand vous savez que le mot de passe est court.
- En environment Docker sans GPU, hashcat peut être remplacé par **John the Ripper** en mode CPU comme alternative.
- Consultez la page `--help` régulièrement : les codes `-m` changent entre les versions.

---

*Documentation rédigée à des fins éducatives dans le cadre de la formation BTS SIO.*
