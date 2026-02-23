# 🔐 Documentation — SSSS (Shamir's Secret Sharing)

> **ssss** est une implémentation Linux du schéma de partage de secret de Shamir.  
> Il permet de diviser un secret en **N fragments**, dont seuls **T sont nécessaires** pour reconstruire l'original (T ≤ N).

---

## Table des matières

1. [Concept mathématique](#1-concept-mathématique)
2. [Installation](#2-installation)
3. [Syntaxe et options](#3-syntaxe-et-options)
4. [Exemples d'utilisation](#4-exemples-dutilisation)
5. [Limites et contraintes](#5-limites-et-contraintes)
6. [Combinaison avec OpenSSL](#6-combinaison-avec-openssl)
7. [Cas d'usage CTF](#7-cas-dusage-ctf)
8. [Erreurs fréquentes](#8-erreurs-fréquentes)
9. [Référence rapide](#9-référence-rapide)

---

## 1. Concept mathématique

Le schéma de Shamir repose sur un principe simple : **il faut au moins T points pour définir un polynôme de degré T-1**.

Le secret est encodé comme le terme constant d'un polynôme aléatoire. N points de ce polynôme sont distribués comme fragments. Avec T points ou plus, le polynôme est reconstituable par interpolation de Lagrange. Avec T-1 points ou moins, aucune information sur le secret n'est révélée.

```
Exemple avec T=3, N=5 :

Secret S = f(0) = 42

f(x) = 42 + 7x + 3x²   (polynôme de degré 2, coefficients aléatoires)

Fragment 1 → f(1) = 52
Fragment 2 → f(2) = 68
Fragment 3 → f(3) = 90   ← 3 fragments suffisent à retrouver f(0) = 42
Fragment 4 → f(4) = 118
Fragment 5 → f(5) = 152
```

**Propriété clé : sécurité parfaite**  
Posséder T-1 fragments ne donne aucune information statistique sur le secret. C'est une sécurité théoriquement parfaite (information-theoretically secure).

---

## 2. Installation

### Debian / Ubuntu
```bash
apt-get install ssss
```

### Arch Linux
```bash
pacman -S ssss
```

### Compilation depuis les sources
```bash
apt-get install build-essential libgmp-dev
wget http://point-at-infinity.org/ssss/ssss-0.5.tar.gz
tar xzf ssss-0.5.tar.gz
cd ssss-0.5 && make && make install
```

### Vérification
```bash
ssss-split --help
ssss-combine --help
```

---

## 3. Syntaxe et options

### `ssss-split` — Diviser un secret

```
ssss-split -t <seuil> -n <fragments> [options]
```

| Option | Description | Exemple |
|--------|-------------|---------|
| `-t T` | Seuil minimal de fragments pour reconstruire | `-t 3` |
| `-n N` | Nombre total de fragments à générer | `-n 5` |
| `-s S` | Taille du champ de Galois en bits (détermine la taille max du secret) | `-s 128` |
| `-q` | Mode silencieux — sortie uniquement sur stdout | `-q` |
| `-Q` | Mode très silencieux — sans aucun message | `-Q` |
| `-x` | Entrée/sortie en hexadécimal | `-x` |
| `-D` | Désactive la vérification de déduplication des fragments | `-D` |

---

### `ssss-combine` — Reconstruire un secret

```
ssss-combine -t <seuil> [options]
```

| Option | Description | Exemple |
|--------|-------------|---------|
| `-t T` | Nombre de fragments à saisir | `-t 3` |
| `-q` | Mode silencieux — affiche uniquement le secret | `-q` |
| `-Q` | Mode très silencieux | `-Q` |
| `-x` | Entrée/sortie en hexadécimal | `-x` |
| `-D` | Désactive la vérification de déduplication | `-D` |

---

## 4. Exemples d'utilisation

### Exemple 1 — 3 fragments sur 5 suffisent (2/5 ne suffit pas)

```bash
# Génération
echo "monSecret" | ssss-split -t 3 -n 5 -q

# Sortie :
# 1-a3f2c1d4e5b678...
# 2-b7e3a2f1c8d9ab...
# 3-c1d5f3a2e7b412...
# 4-d8e2c4f1a3b967...
# 5-e4a1d3c2f5b823...
```

```bash
# Reconstruction avec 3 fragments (au choix)
ssss-combine -t 3 -q
# Entrer :
# 1-a3f2c1d4e5b678...
# 3-c1d5f3a2e7b412...
# 5-e4a1d3c2f5b823...
# Résultat : monSecret
```

---

### Exemple 2 — 8 fragments sur 8 (tous obligatoires)

```bash
echo "cléSecrète28chars" | ssss-split -t 8 -n 8 -s 128 -q
```

---

### Exemple 3 — Depuis un fichier

```bash
# Lire le secret depuis un fichier
cat secret.txt | ssss-split -t 3 -n 5 -q > fragments.txt

# Vérifier les fragments générés
cat fragments.txt
```

---

### Exemple 4 — Reconstruction depuis un fichier

```bash
# Si les fragments sont stockés dans un fichier
ssss-combine -t 3 -q < fragments_choisis.txt
```

---

### Exemple 5 — Utilisation en script bash

```bash
#!/bin/bash
SECRET="monSecretCourt"

# Générer et capturer les fragments
FRAGS=$(echo "$SECRET" | ssss-split -t 3 -n 5 -s 128 -q 2>&1)

# Accéder à un fragment spécifique
FRAG1=$(echo "$FRAGS" | sed -n '1p')
FRAG2=$(echo "$FRAGS" | sed -n '2p')
FRAG3=$(echo "$FRAGS" | sed -n '3p')

echo "Fragment 1 : $FRAG1"

# Reconstruire
RECONSTRUIT=$(printf "%s\n%s\n%s\n" "$FRAG1" "$FRAG2" "$FRAG3" | ssss-combine -t 3 -q 2>&1)
echo "Secret reconstruit : $RECONSTRUIT"
```

> ⚠️ **Important** : `ssss-split` écrit sur `stderr` par défaut. En script, toujours utiliser `2>&1` pour capturer la sortie complète.

---

## 5. Limites et contraintes

### Taille maximale du secret selon `-s`

| Paramètre `-s` | Taille max du secret | Recommandation |
|----------------|----------------------|----------------|
| `-s 128`       | **16 caractères**    | Clés courtes, tokens |
| `-s 256`       | **32 caractères**    | Clés moyennes |
| `-s 512`       | **64 caractères**    | Usage général |
| `-s 1024`      | **128 caractères**   | Longues chaînes |

```bash
# Tester la limite
python3 -c "print('A' * 16)" | ssss-split -t 2 -n 3 -s 128 -q   # ✓ OK
python3 -c "print('A' * 17)" | ssss-split -t 2 -n 3 -s 128 -q   # ✗ FATAL: input string too long
```

### Caractères acceptés

`ssss` accepte uniquement des **caractères ASCII imprimables**. Les caractères spéciaux, accents, emoji ou binaire brut provoqueront des erreurs ou une reconstruction incorrecte.

```bash
echo "motDePassé"  | ssss-split -t 2 -n 3 -q   # ⚠️ accent → problème possible
echo "motDePasse"  | ssss-split -t 2 -n 3 -q   # ✓ OK
```

### Ordre des fragments

Les fragments peuvent être saisis **dans n'importe quel ordre** lors de la reconstruction, tant que le bon nombre est fourni.

### Fragments dupliqués

Fournir deux fois le même fragment provoque une erreur (sauf avec `-D`).

---

## 6. Combinaison avec OpenSSL

Pour des secrets longs (flags, phrases, fichiers), la bonne pratique est de :

1. Générer une **clé courte aléatoire** compatible avec ssss
2. **Chiffrer le secret long** avec cette clé via OpenSSL
3. **Splitter la clé courte** avec ssss
4. Distribuer les fragments + le fichier chiffré

### Chiffrement

```bash
# Générer une clé de 28 caractères hex (safe pour -s 128)
CLE=$(openssl rand -hex 14)
echo "Clé : $CLE"

# Chiffrer le secret long
echo "FLAG{mon_super_flag_très_long_2024}" | \
    openssl enc -aes-256-cbc -pbkdf2 -pass pass:"$CLE" | \
    base64 > flag.enc

# Splitter la clé en 8 fragments
echo "$CLE" | ssss-split -t 8 -n 8 -s 128 -q
```

### Déchiffrement

```bash
# Reconstruire la clé
CLE_RECONSTRUITE=$(ssss-combine -t 8 -q 2>&1)

# Déchiffrer le flag
cat flag.enc | base64 -d | \
    openssl enc -d -aes-256-cbc -pbkdf2 -pass pass:"$CLE_RECONSTRUITE"
```

---

## 7. Cas d'usage CTF

### Architecture recommandée

```
FLAG (longueur libre)
    │
    ▼
openssl enc  ──▶  flag.enc (stocké sur le serveur)
    │
    ▼
Clé courte (≤ 16 chars)
    │
    ▼
ssss-split -t 8 -n 8
    │
    ├── fragment_1.key  ──▶  Niveau 1 (exploration Linux)
    ├── fragment_2.key  ──▶  Niveau 2 (SSH)
    ├── fragment_3.key  ──▶  Niveau 3 (cryptographie)
    ├── fragment_4.key  ──▶  Niveau 4 (réseau)
    ├── fragment_5.key  ──▶  Niveau 5 (social engineering)
    ├── fragment_6.key  ──▶  Niveau 6 (port knocking)
    ├── fragment_7.key  ──▶  Niveau 7 (SQL injection)
    └── fragment_8.key  ──▶  Niveau 8 (fragment hunt)
```

### Utilisation d'un fragment comme mot de passe SSH

```bash
# Côté setup
FRAG=$(cat /root/fragments/fragment_3.key)
echo "room3:${FRAG}" | chpasswd

# Côté étudiant
ssh room3@serveur
# Password: <contenu du fragment 3>
```

### Reconstruction finale

```bash
# Étape 1 — Reconstruire la clé
ssss-combine -t 8 -q
# → saisir les 8 fragments un par un

# Étape 2 — Déchiffrer le flag
cat /root/flag.enc | base64 -d | openssl enc -d -aes-256-cbc -pbkdf2 -pass pass:"<CLÉ>"
# → FLAG{...}
```

---

## 8. Erreurs fréquentes

| Erreur | Cause | Solution |
|--------|-------|----------|
| `FATAL: input string too long` | Secret dépasse la limite de `-s` | Réduire le secret ou augmenter `-s`, ou utiliser OpenSSL |
| Fichiers fragments vides en script | `ssss-split` écrit sur stderr | Ajouter `2>&1` à la capture |
| `FATAL: string is not in hex format` | Option `-x` manquante côté combine | Ajouter `-x` si split fait avec `-x` |
| Mauvais secret reconstruit | Fragment mal copié (espace, retour ligne) | Vérifier avec `cat -A fragment.key` |
| `FATAL: shares must be distinct` | Fragment dupliqué fourni | Fournir T fragments différents |
| Variable `$FRAGS` vide dans Docker | Isolation des shells entre RUN | Générer dans `entrypoint.sh` |

---

## 9. Référence rapide

```bash
# Splitter en N fragments, T nécessaires
echo "secret" | ssss-split -t T -n N -s 128 -q

# Reconstruire depuis T fragments
ssss-combine -t T -q

# Taille max selon -s
# -s 128  →  16 chars max
# -s 256  →  32 chars max
# -s 512  →  64 chars max
# -s 1024 → 128 chars max

# Générer une clé compatible ssss
openssl rand -hex 14   # → 28 chars hex, safe pour -s 128

# Pipeline complet : chiffrer + splitter
CLE=$(openssl rand -hex 14)
echo "SECRET LONG" | openssl enc -aes-256-cbc -pbkdf2 -pass pass:"$CLE" | base64 > secret.enc
echo "$CLE" | ssss-split -t 3 -n 5 -s 128 -q

# Pipeline complet : recombiner + déchiffrer
CLE=$(ssss-combine -t 3 -q 2>&1)
cat secret.enc | base64 -d | openssl enc -d -aes-256-cbc -pbkdf2 -pass pass:"$CLE"
```

---

> **Ressources**
> - Page officielle : http://point-at-infinity.org/ssss/
> - GTFOBins (contexte CTF) : https://gtfobins.github.io
> - RFC sur le schéma de Shamir : https://tools.ietf.org/html/rfc3447