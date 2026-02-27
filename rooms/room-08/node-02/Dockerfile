FROM debian:12-slim

ARG USER
ARG PASS
ARG SECRET_KEY

RUN apt-get update && apt-get install -y \
    curl \
    iputils-ping \
    net-tools \
    openssh-server \
    iptables \
    nmap \
    sudo \
    knockd \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd

RUN useradd -m -s /bin/bash $USER && \
    echo "$USER:$PASS" | chpasswd

# ============================================================
# SUDO MISCONFIGURATION - activer UNE seule ligne à la fois
# ============================================================

# OPTION A : tous les droits sans mot de passe (classique GTFOBins)
# RUN echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER

# OPTION B : sudo find (GTFOBins : sudo find . -exec /bin/sh \; -quit)
RUN echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/find" > /etc/sudoers.d/$USER

# OPTION C : sudo vim (GTFOBins : sudo vim -c ':!/bin/sh')
# RUN echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/vim" > /etc/sudoers.d/$USER

# OPTION D : sudo less (GTFOBins : sudo less /etc/passwd -> !/bin/sh)
# RUN echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/less" > /etc/sudoers.d/$USER

# OPTION E : sudo cat uniquement - lecture seule
# RUN echo "$USER ALL=(ALL) NOPASSWD: /bin/cat" > /etc/sudoers.d/$USER

# OPTION F : sudo cp (permet de copier des fichiers sensibles)
# RUN echo "$USER ALL=(ALL) NOPASSWD: /bin/cp" > /etc/sudoers.d/$USER

# OPTION G : sudo python3 (GTFOBins : sudo python3 -c 'import os; os.system("/bin/sh")')
# RUN echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/python3" > /etc/sudoers.d/$USER

RUN chmod 0440 /etc/sudoers.d/$USER

# ============================================================
# FICHIERS ROOT
# ============================================================

RUN mkdir -p /root/docs && \
    echo "$SECRET_KEY" > /root/docs/secret-key.txt && \
    chmod 700 /root/docs && \
    chmod 600 /root/docs/secret-key.txt

# ============================================================
# CONFIGURATION SSH
# ============================================================

COPY rooms/room-08/node-02/sshd_config /etc/ssh/sshd_config

# ============================================================
# CONFIGURATION KNOCKD
# ============================================================

COPY rooms/room-08/node-02/knockd.conf /etc/knockd.conf

RUN chmod 600 /etc/knockd.conf

# ============================================================
# CLES SSH
# ============================================================

RUN mkdir -p /home/$USER/.ssh

COPY rooms/room-08/node-02/key.pub /home/$USER/.ssh/authorized_keys

# ============================================================
# PERMISSIONS FINALES
# ============================================================

RUN chown -R $USER:$USER /home/$USER && \
    chmod 700 /home/$USER/.ssh && \
    chmod 600 /home/$USER/.ssh/authorized_keys


COPY rooms/room-08/node-02/start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22

CMD ["/start.sh"]