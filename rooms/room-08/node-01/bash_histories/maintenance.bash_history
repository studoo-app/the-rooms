ping 8.8.8.8
ping google.com
ifconfig
ip addr show
ip route
netstat -rn
ftp backup.local
# user: maintenance
# pass: Maint2024!
ls
cd backup
ls -la
get important_file.txt
get fragment_backup.enc
bye
cat important_file.txt
# "Fragment complet trouvé: Port 9000, Passphrase Charlie"
# "À utiliser avec la clé SSH pour accès final"
openssl enc -d -aes-256-cbc -in fragment_backup.enc -out fragment.txt
# Password: guardian2024
cat fragment.txt
# Port: 9000
# Pass: Charlie
nc -lvp 4444
# Listener pour reverse shell
dd if=/dev/zero of=/tmp/largefile bs=1M count=100
rm /tmp/largefile
history
