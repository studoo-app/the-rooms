#!/bin/bash

echo "[*] Configuration du serveur Port Knocking..."

# Démarrage SSH
service ssh start
echo "[+] SSH démarré"

# Configuration iptables - Bloquer SSH par défaut
iptables -A INPUT -p tcp --dport 22 -j DROP
echo "[+] Règle iptables: SSH bloqué par défaut"

# Autoriser le loopback
iptables -A INPUT -i lo -j ACCEPT
echo "[+] Loopback autorisé"

# Autoriser les connexions établies
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
echo "[+] Connexions établies autorisées"

# Activer knockd
knockd -d -i eth0
echo "[+] knockd démarré sur eth0"


# Garder le conteneur actif
tail -f /dev/null
