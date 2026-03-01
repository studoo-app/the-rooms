# Documentation : Le Port Knocking

## 📚 Introduction

Le **port knocking** est une technique de sécurité réseau qui permet de dissimuler des services (comme SSH) derrière un pare-feu en les gardant fermés jusqu'à ce qu'une séquence spécifique de tentatives de connexion soit détectée.

### Principe de base

Imaginez une porte secrète qui ne s'ouvre que si vous frappez selon un rythme précis : 3 coups rapides, 2 coups lents, 1 coup fort. Le port knocking fonctionne sur le même principe avec les ports réseau.

---

## 🔍 Fonctionnement

### Mécanisme

1. **État initial** : Tous les ports sensibles (ex: SSH sur le port 22) sont **fermés** au niveau du pare-feu
2. **Séquence de knock** : Le client tente de se connecter à une séquence de ports prédéfinie (ex: 7000, 8000, 9000)
3. **Détection** : Un démon (knockd) surveille les logs du pare-feu et détecte la séquence
4. **Ouverture** : Si la séquence est correcte, le pare-feu ouvre temporairement le port pour l'adresse IP source
5. **Connexion** : Le client peut maintenant se connecter au service
6. **Fermeture** : Après un délai ou une séquence de fermeture, le port se referme

### Schéma conceptuel

```
Client                    Pare-feu                  Serveur
  |                          |                         |
  |--[SYN] Port 7000-------->|                         |
  |--[SYN] Port 8000-------->|                         |
  |--[SYN] Port 9000-------->| [Détection séquence]    |
  |                          |--[Règle iptables]------>|
  |                          | Port 22 OUVERT pour IP  |
  |--[SSH] Port 22---------->|------------------------>|
  |<-------------------------|<------------------------|
  |      Connexion établie                             |
```

---

## 🛠️ Configuration pratique

### Installation sur Debian/Ubuntu

```bash
sudo apt update
sudo apt install knockd
```

### Configuration du serveur

Fichier : `/etc/knockd.conf`

```ini
[options]
    UseSyslog

[openSSH]
    sequence    = 7000,8000,9000
    seq_timeout = 5
    command     = /sbin/iptables -A INPUT -s %IP% -p tcp --dport 22 -j ACCEPT
    tcpflags    = syn

[closeSSH]
    sequence    = 9000,8000,7000
    seq_timeout = 5
    command     = /sbin/iptables -D INPUT -s %IP% -p tcp --dport 22 -j ACCEPT
    tcpflags    = syn
```

**Explications :**
- `sequence` : Ordre des ports à frapper
- `seq_timeout` : Temps maximum entre chaque knock (en secondes)
- `command` : Commande iptables à exécuter
- `%IP%` : Variable remplacée par l'IP source
- `tcpflags = syn` : Détecte uniquement les paquets SYN

### Activation du service

```bash
# Modifier /etc/default/knockd
KNOCKD_OPTS="-i eth0"  # Interface réseau à surveiller

# Démarrer le service
sudo systemctl enable knockd
sudo systemctl start knockd
```

### Configuration initiale du pare-feu

```bash
# Bloquer SSH par défaut
sudo iptables -A INPUT -p tcp --dport 22 -j DROP

# Sauvegarder les règles
sudo iptables-save > /etc/iptables/rules.v4
```

---

## 💻 Utilisation côté client

### Avec knock (outil dédié)

```bash
# Installation
sudo apt install knockd

# Utilisation
knock <ip_serveur> 7000 8000 9000

# Connexion SSH
ssh user@<ip_serveur>

# Fermeture du port (optionnel)
knock <ip_serveur> 9000 8000 7000
```

### Avec nmap

```bash
# Envoyer la séquence de knock
for port in 7000 8000 9000; do
    nmap -Pn --max-retries 0 -p $port <ip_serveur>
done

# Se connecter
ssh user@<ip_serveur>
```

### Avec netcat

```bash
# Méthode manuelle
nc -z <ip_serveur> 7000
nc -z <ip_serveur> 8000
nc -z <ip_serveur> 9000

# Puis connexion SSH
ssh user@<ip_serveur>
```

### Script bash automatisé

```bash
#!/bin/bash
# knock.sh

SERVER=$1
shift
PORTS=$@

for PORT in $PORTS; do
    nmap -Pn --max-retries 0 -p $PORT $SERVER >/dev/null 2>&1
    sleep 0.2
done

echo "Séquence envoyée à $SERVER"
```

Usage : `./knock.sh 192.168.1.10 7000 8000 9000`

---

## 🔒 Avantages et inconvénients

### ✅ Avantages

1. **Sécurité par l'obscurité** : Les services ne sont pas visibles lors d'un scan de ports
2. **Protection contre les attaques par force brute** : Le service n'est pas accessible sans la séquence
3. **Réduction de la surface d'attaque** : Moins de services exposés = moins de vulnérabilités
4. **Léger** : Consommation minimale de ressources
5. **Protection contre les scans** : Les scanners automatiques ne détecteront pas le service

### ❌ Inconvénients

1. **Sécurité par l'obscurité** : Ne remplace pas une authentification forte
2. **Vulnérable au sniffing** : La séquence peut être capturée sur le réseau
3. **Complexité** : Ajoute une étape supplémentaire pour se connecter
4. **Pas de chiffrement** : La séquence transite en clair
5. **Single-Packet Authorization** : Des techniques plus modernes existent (SPA)

---

## 🎯 Cas d'usage

### Scénarios appropriés

- **Serveurs personnels** : Protection d'un serveur SSH personnel
- **Bastions/Jump hosts** : Première couche de défense pour un serveur de rebond
- **Honeypots** : Dissimuler les vrais services tout en exposant des leurres
- **Environnements de test** : Protection temporaire pendant des tests

### Scénarios inappropriés

- **Production critique** : Privilégier des VPN ou des solutions plus robustes
- **Accès fréquents** : Peut devenir fastidieux pour un usage quotidien
- **Environnements multi-utilisateurs** : Gestion complexe des accès

---

## 🔐 Sécurisation avancée

### Port knocking avec SPA (Single Packet Authorization)

**Fwknop** est une alternative plus sécurisée :

```bash
# Installation
sudo apt install fwknop-server fwknop-client

# Génération de clés
fwknop --key-gen

# Utilisation client
fwknop -A tcp/22 -a <ip_serveur>
```

**Avantages de SPA :**
- Authentification cryptographique
- Timestamp pour éviter le replay
- Tout dans un seul paquet

### Bonnes pratiques

1. **Changer régulièrement la séquence** de ports
2. **Utiliser des ports aléatoires** (éviter 1234, 5678...)
3. **Combiner avec d'autres mécanismes** : fail2ban, authentification par clé SSH
4. **Logger les tentatives** de knock pour détecter les attaques
5. **Timeout court** : Refermer le port après 30 secondes si non utilisé

---

## 🧪 Exercice pratique

### Objectif
Mettre en place un système de port knocking sur un serveur SSH

### Étapes

1. Installer et configurer knockd sur un serveur
2. Configurer une séquence de 4 ports de votre choix
3. Tester depuis un client avec différentes méthodes
4. Observer les logs du système
5. Implémenter une séquence de fermeture

### Questions

1. Que se passe-t-il si on frappe les ports dans le mauvais ordre ?
2. Comment pourrait-on améliorer la sécurité de cette technique ?
3. Quels outils d'attaque pourraient détecter le port knocking ?

---

## 📖 Références

- [Knockd - Official Documentation](http://www.zeroflux.org/projects/knock)
- [Fwknop - Single Packet Authorization](https://www.cipherdyne.org/fwknop/)
- [iptables - Netfilter Documentation](https://www.netfilter.org/documentation/)

---

## 🎓 Pour aller plus loin

### Détection du port knocking

Lors d'un pentest, vous pourriez rencontrer du port knocking. Indices :
- Ports fermés qui ne répondent pas normalement
- Absence de services visibles sur des ports standards
- Analyse des logs de connexion

### Outils de détection

```bash
# Observer le trafic réseau
sudo tcpdump -i eth0 -n 'tcp[tcpflags] & tcp-syn != 0'

# Scanner avec timing spécifique
nmap -sT --scan-delay 1s -p1-65535 <target>
```

---

**Document créé pour le cours de cybersécurité BTS SIO**  
*Version 1.0 - 2025*
