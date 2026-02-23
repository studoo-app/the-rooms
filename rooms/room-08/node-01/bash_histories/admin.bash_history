sudo su
cd /root
ls -la
cat .secret_note
# Contenu: "La deuxième partie commence par C et finit par e"
cat .credentials
systemctl status nginx
systemctl status ssh
tail -f /var/log/nginx/access.log
grep "fragment" /var/log/nginx/access.log
grep "9000" /var/log/auth.log
ssh maintenance@192.168.10.50
# Connexion établie
exit
echo "Q2hhcmxpZQ==" | base64 -d
# Résultat: Charlie
last -f /var/log/wtmp
lastlog
w
who
ps aux | grep ssh
netstat -tulpn
ss -tulpn
history
