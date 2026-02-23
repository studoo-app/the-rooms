apt-get update
apt-get upgrade -y
systemctl restart ssh
systemctl restart nginx
tail -f /var/log/auth.log
grep "Failed password" /var/log/auth.log
grep "Accepted" /var/log/auth.log
find / -name "*fragment*" 2>/dev/null
find /home -type f -name ".*history"
cat /home/developer/.bash_history
cat /home/admin/.bash_history
echo "Les fragments sont: 9000 et Charlie"
useradd -m -s /bin/bash testuser
passwd testuser
userdel -r testuser
history -c
