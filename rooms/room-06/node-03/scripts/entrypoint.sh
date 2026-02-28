#!/bin/bash
# Exporter les variables d'environnement pour cron
# (cron ne récupère pas les variables Docker automatiquement)

printenv | grep -E "FTP_|PATH" > /etc/environment

echo "Demarrage du daemon cron..."
exec cron -f
