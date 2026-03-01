# Documentation SSH

## 1. Introduction

**SSH** (*Secure Shell*) est un protocole de communication sécurisé permettant de se connecter à distance à un serveur, d'exécuter des commandes et de transférer des fichiers de manière chiffrée.

- **Port par défaut** : 22
- **Protocole** : TCP
- **Chiffrement** : AES, ChaCha20, etc.
- **Authentification** : Par mot de passe ou par clé publique/privée

---

## 2. Installation

### Client SSH

```bash
# Debian / Ubuntu
sudo apt install openssh-client

# Fedora / RHEL
sudo dnf install openssh-clients
```

### Serveur SSH

```bash
# Debian / Ubuntu
sudo apt install openssh-server
sudo systemctl start ssh
sudo systemctl enable ssh

# Fedora / RHEL
sudo dnf install openssh-server
sudo systemctl start sshd
sudo systemctl enable sshd
```

---

## 3. Connexion de base

### Syntaxe

```bash
ssh [options] [utilisateur@]hôte [commande]
```

### Exemples

```bash
ssh user@192.168.1.10                    # connexion simple
ssh user@192.168.1.10 -p 2222            # port personnalisé
ssh root@example.com                     # connexion en tant que root
ssh user@192.168.1.10 "ls -la"           # exécute une commande et se déconnecte
```

---

## 4. Authentification par clés SSH

L'authentification par clés est plus sécurisée que les mots de passe et permet l'automatisation.

### 4.1 Génération d'une paire de clés

```bash
ssh-keygen -t ed25519 -C "mon-email@example.com"
# ou pour RSA (legacy)
ssh-keygen -t rsa -b 4096 -C "mon-email@example.com"
```

**Fichiers générés** :
- `~/.ssh/id_ed25519` : clé privée (à protéger !)
- `~/.ssh/id_ed25519.pub` : clé publique (à partager)

### 4.2 Copie de la clé publique sur le serveur

```bash
ssh-copy-id user@192.168.1.10
# ou manuellement
cat ~/.ssh/id_ed25519.pub | ssh user@192.168.1.10 "cat >> ~/.ssh/authorized_keys"
```

### 4.3 Connexion sans mot de passe

```bash
ssh user@192.168.1.10   # connexion automatique avec la clé
```

### 4.4 Utilisation d'une clé spécifique

```bash
ssh -i ~/.ssh/ma_cle_privee user@192.168.1.10
```

---

## 5. Configuration SSH (`~/.ssh/config`)

Le fichier de configuration permet de simplifier les connexions répétitives.

### Exemple de configuration

```
# Serveur de production
Host prod
    HostName 192.168.1.10
    User admin
    Port 2222
    IdentityFile ~/.ssh/prod_key

# Serveur de développement
Host dev
    HostName dev.example.com
    User developer
    ForwardAgent yes

# Bastion jump
Host bastion
    HostName bastion.example.com
    User jumpuser
    Port 22

# Serveur interne via bastion
Host internal
    HostName 10.0.0.5
    User admin
    ProxyJump bastion
```

### Utilisation

```bash
ssh prod        # équivalent à ssh admin@192.168.1.10 -p 2222 -i ~/.ssh/prod_key
ssh internal    # se connecte via le bastion automatiquement
```

---

## 6. Tunneling SSH (Port Forwarding)

### 6.1 Local Port Forwarding

Redirige un port local vers un port distant via SSH.

```bash
ssh -L [bind_address:]local_port:destination:destination_port user@ssh_server
```

**Exemple** : Accéder à un serveur web interne (port 80) via SSH

```bash
ssh -L 8080:localhost:80 user@192.168.1.10
# Accès via http://localhost:8080
```

**Cas d'usage** : Accéder à des services internes (bases de données, interfaces web, etc.)

### 6.2 Remote Port Forwarding

Redirige un port distant vers un port local.

```bash
ssh -R [bind_address:]remote_port:destination:destination_port user@ssh_server
```

**Exemple** : Exposer un serveur local au serveur distant

```bash
ssh -R 9090:localhost:80 user@192.168.1.10
# Le serveur distant peut accéder à votre serveur local via localhost:9090
```

**Cas d'usage** : Contourner les pare-feu, démonstration de services locaux

### 6.3 Dynamic Port Forwarding (SOCKS Proxy)

Crée un proxy SOCKS pour router tout le trafic via SSH.

```bash
ssh -D 1080 user@192.168.1.10
```

**Configuration du navigateur** : Utiliser `localhost:1080` comme proxy SOCKS5

**Cas d'usage** : Navigation anonymisée, contournement de restrictions réseau

### 6.4 Maintien du tunnel en arrière-plan

```bash
ssh -fN -L 8080:localhost:80 user@192.168.1.10
```

- `-f` : passe en arrière-plan
- `-N` : n'exécute pas de commande (tunnel uniquement)

---

## 7. Transfert de fichiers

### 7.1 SCP (Secure Copy)

```bash
# Copie locale → distante
scp fichier.txt user@192.168.1.10:/tmp/

# Copie distante → locale
scp user@192.168.1.10:/tmp/fichier.txt ./

# Copie récursive (dossier)
scp -r /mon/dossier user@192.168.1.10:/destination/

# Port personnalisé
scp -P 2222 fichier.txt user@192.168.1.10:/tmp/
```

### 7.2 SFTP (SSH File Transfer Protocol)

Mode interactif pour transférer des fichiers :

```bash
sftp user@192.168.1.10
```

**Commandes SFTP** :
```
put fichier.txt          # upload
get fichier.txt          # download
ls                       # liste distante
lls                      # liste locale
cd /chemin               # change répertoire distant
lcd /chemin              # change répertoire local
mkdir dossier            # créer dossier distant
rm fichier               # supprimer fichier distant
exit                     # quitter
```

### 7.3 Rsync via SSH

Plus efficace pour les synchronisations :

```bash
rsync -avz -e ssh /local/dir user@192.168.1.10:/remote/dir
rsync -avz -e "ssh -p 2222" user@192.168.1.10:/remote/dir /local/dir
```

---

## 8. Options SSH utiles

| Option | Description |
|--------|-------------|
| `-p PORT` | Port SSH personnalisé |
| `-i FILE` | Clé privée à utiliser |
| `-v` / `-vv` / `-vvv` | Mode verbeux (débogage) |
| `-N` | Ne pas exécuter de commande (tunnels) |
| `-f` | Passer en arrière-plan |
| `-C` | Active la compression |
| `-X` | Forwarding X11 (interface graphique) |
| `-A` | Forward SSH agent |
| `-o Option=Value` | Option de configuration |
| `-J host` | ProxyJump (bastion) |

### Exemples combinés

```bash
ssh -vv -p 2222 user@192.168.1.10        # débogage + port personnalisé
ssh -N -f -L 8080:localhost:80 user@192.168.1.10  # tunnel en arrière-plan
ssh -J bastion user@internal-server      # connexion via bastion
```

---

## 9. Configuration du serveur SSH

Le fichier de configuration principal est `/etc/ssh/sshd_config`.

### Paramètres de sécurité recommandés

```bash
# Port personnalisé (éviter 22)
Port 2222

# Désactiver la connexion root
PermitRootLogin no

# Authentification par clés uniquement
PasswordAuthentication no
PubkeyAuthentication yes

# Limiter les utilisateurs autorisés
AllowUsers user1 user2

# Désactiver les protocoles faibles
Protocol 2

# Timeout de session
ClientAliveInterval 300
ClientAliveCountMax 2

# Bannière personnalisée
Banner /etc/ssh/banner.txt
```

### Redémarrer le service après modification

```bash
sudo systemctl restart ssh      # Debian/Ubuntu
sudo systemctl restart sshd     # RHEL/Fedora
```

---

## 10. SSH Agent (gestion des clés)

L'agent SSH garde les clés en mémoire pour éviter de retaper la passphrase.

### Démarrage de l'agent

```bash
eval $(ssh-agent)
```

### Ajout d'une clé

```bash
ssh-add ~/.ssh/id_ed25519
ssh-add -l    # liste les clés chargées
```

### Forward de l'agent (utiliser ses clés sur un serveur distant)

```bash
ssh -A user@192.168.1.10
```

> **Attention** : Le forward d'agent peut présenter des risques si le serveur distant est compromis.

---

## 11. ProxyJump et bastion

Le **ProxyJump** permet de se connecter à un serveur via un ou plusieurs intermédiaires.

### Syntaxe

```bash
ssh -J bastion_user@bastion_host target_user@target_host
```

### Exemple multi-saut

```bash
ssh -J bastion1,bastion2 user@target
```

### Configuration dans `~/.ssh/config`

```
Host bastion
    HostName bastion.example.com
    User jumpuser

Host target
    HostName 10.0.0.5
    User admin
    ProxyJump bastion
```

Connexion simplifiée :
```bash
ssh target
```

---

## 12. Commandes utiles de diagnostic

```bash
# Tester la connexion avec verbosité
ssh -vvv user@192.168.1.10

# Vérifier les clés publiques acceptées sur le serveur
ssh-keyscan 192.168.1.10

# Lister les connexions SSH actives (serveur)
who
w
last

# Vérifier les logs SSH (serveur)
sudo tail -f /var/log/auth.log         # Debian/Ubuntu
sudo tail -f /var/log/secure           # RHEL/Fedora

# Tuer une session SSH bloquée
~.    # (tilde + point dans le terminal)
```

---

## 13. Sécurité SSH

### Bonnes pratiques

1. **Utiliser des clés SSH** plutôt que des mots de passe
2. **Désactiver l'authentification root** (`PermitRootLogin no`)
3. **Changer le port par défaut** (22 → autre)
4. **Utiliser fail2ban** pour bloquer les tentatives de brute-force
5. **Limiter les utilisateurs autorisés** (`AllowUsers` ou `AllowGroups`)
6. **Utiliser une passphrase** pour protéger les clés privées
7. **Désactiver les protocoles faibles** (SSHv1)
8. **Configurer un timeout de session** (`ClientAliveInterval`)
9. **Activer l'audit** des connexions et commandes

### Installation de fail2ban

```bash
sudo apt install fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

Configuration dans `/etc/fail2ban/jail.local` :
```ini
[sshd]
enabled = true
port = 2222
maxretry = 3
bantime = 3600
```

---

## 14. Exemples pratiques

### Copie sécurisée de fichiers avec compression

```bash
tar czf - /mon/dossier | ssh user@192.168.1.10 "cat > backup.tar.gz"
```

### Exécution de scripts distants

```bash
ssh user@192.168.1.10 'bash -s' < local_script.sh
```

### Monitoring en temps réel via SSH

```bash
ssh user@192.168.1.10 "tail -f /var/log/syslog"
```

### Montage distant avec SSHFS

```bash
sudo apt install sshfs
sshfs user@192.168.1.10:/remote/path /local/mount
# Démontage
fusermount -u /local/mount
```

---

## 15. Résolution de problèmes courants

| Problème | Solution |
|----------|----------|
| `Permission denied (publickey)` | Vérifier les permissions de `~/.ssh` (700) et `~/.ssh/authorized_keys` (600) |
| `Connection refused` | Vérifier que le service SSH est actif et le pare-feu autorise le port |
| `Host key verification failed` | Supprimer l'ancienne clé : `ssh-keygen -R hostname` |
| Connexion lente | Désactiver DNS lookup : `UseDNS no` dans `sshd_config` |
| Tunnel ne fonctionne pas | Vérifier `AllowTcpForwarding yes` sur le serveur |

---

## 16. Ressources

- Manuel SSH : `man ssh`, `man sshd_config`, `man ssh_config`
- Documentation officielle : [https://www.openssh.com/manual.html](https://www.openssh.com/manual.html)
- Guide de sécurité SSH : [https://infosec.mozilla.org/guidelines/openssh](https://infosec.mozilla.org/guidelines/openssh)
