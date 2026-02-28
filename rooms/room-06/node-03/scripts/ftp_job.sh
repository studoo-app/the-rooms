#!/bin/bash
# Connexion FTP et transfert de fichiers (trafic "intéressant" à capturer)

LOG=/var/log/ftp_job.log
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$DATE] Connexion FTP vers $FTP_HOST..." >> $LOG

lftp -u "$FTP_USER","$FTP_PASS" "$FTP_HOST" <<EOF >> $LOG 2>&1
ls
put /etc/hostname
get welcome.txt -o /tmp/welcome.txt
bye
EOF

echo "[$DATE] Job FTP termine." >> $LOG
