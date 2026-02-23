ls -la /var/www/
cd /var/www/html
vim index.php
cat /etc/passwd
whoami
id
groups
mysql -u root -p
# Password: dev2024
use hackathon;
show tables;
select * from users;
select * from secrets;
exit
echo "UGFydGllIDE6IDkwMDA=" | base64 -d
# Résultat: Partie 1: 9000
curl http://localhost/api/fragment
curl http://localhost/api/fragment?key=9000
wget http://backup-server.local/secrets.tar.gz
tar -xzvf secrets.tar.gz
ls -la secrets/
cat secrets/note.txt
# "La première partie est 9000"
rm -rf secrets/
rm secrets.tar.gz
history | grep fragment
history | tail -20
history -c
# Nettoyage effectué
