FROM debian:12-slim

ARG FTP_USER
ARG FTP_PASS

RUN apt-get update && apt-get install -y \
    vsftpd \
    net-tools \
    iproute2 \
    && rm -rf /var/lib/apt/lists/*

# Créer l'utilisateur FTP
RUN useradd -m -s /bin/bash $FTP_USER && \
    echo "$FTP_USER:$FTP_PASS" | chpasswd

# Créer le répertoire de données FTP
RUN mkdir -p /home/$FTP_USER/ftp && \
    chown $FTP_USER:$FTP_USER /home/$FTP_USER/ftp && \
    echo "Bienvenue sur le serveur FTP" > /home/$FTP_USER/ftp/welcome.txt

# Configuration vsftpd
COPY /rooms/room-06/node-02/vsftpd.conf /etc/vsftpd.conf

EXPOSE 21

CMD ["/usr/sbin/vsftpd", "/etc/vsftpd.conf"]
