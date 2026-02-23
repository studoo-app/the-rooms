#!/bin/bash

echo "[*] Configuration du serveur Port Knocking..."

# Démarrage SSH
service ssh start
echo "[+] SSH démarré"

# Configuration iptables - Bloquer SSH par défaut
sudo iptables -A INPUT -p tcp --dport 22 -j DROP
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
echo ""
echo "=========================================="
echo "Serveur Port Knocking opérationnel!"
echo "=========================================="
echo "Séquence d'ouverture: 7000 -> 8000 -> 9000"
echo "Séquence de fermeture: 9000 -> 8000 -> 7000"
echo "=========================================="
echo ""

# Garder le conteneur actif
tail -f /dev/null
