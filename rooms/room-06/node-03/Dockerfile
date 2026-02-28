FROM debian:12-slim

ARG FTP_USER
ARG FTP_PASS
ARG FTP_HOST

RUN apt-get update && apt-get install -y \
    ftp \
    lftp \
    curl \
    iputils-ping \
    net-tools \
    cron \
    iproute2 \
    && rm -rf /var/lib/apt/lists/*

# Variables d'environnement disponibles pour les scripts
ENV FTP_USER=${FTP_USER}
ENV FTP_PASS=${FTP_PASS}
ENV FTP_HOST=${FTP_HOST}

# Copier les scripts
COPY /rooms/room-06/node-03/scripts/ftp_job.sh /usr/local/bin/ftp_job.sh
COPY /rooms/room-06/node-03/scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/ftp_job.sh /usr/local/bin/entrypoint.sh

# Crontab : connexion FTP toutes les 5 minutes
COPY /rooms/room-06/node-03/crontab /etc/cron.d/ftp-client
RUN chmod 0644 /etc/cron.d/ftp-client && \
    crontab /etc/cron.d/ftp-client

CMD ["/usr/local/bin/entrypoint.sh"]
