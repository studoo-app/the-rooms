FROM debian:12-slim

ARG USER
ARG PASS
ARG FLAG

# ============================================================
# INSTALLATION DES PAQUETS
# ============================================================
RUN apt-get update && apt-get install -y \
    curl \
    iputils-ping \
    net-tools \
    openssh-server \
    sudo \
    zip \
    unzip \
    ssss \
    vim \
    findutils \
    && rm -rf /var/lib/apt/lists/*

# ============================================================
# CONFIGURATION SSH — root interdit de se connecter
# ============================================================
RUN mkdir /var/run/sshd && \
    echo "PermitRootLogin no"            >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes"    >> /etc/ssh/sshd_config

# ============================================================
# CRÉATION DE L'UTILISATEUR
# ============================================================
RUN useradd -m -s /bin/bash ${USER} && \
    echo "${USER}:${PASS}" | chpasswd

# ============================================================
# ssss RÉSERVÉ À ROOT UNIQUEMENT
# ============================================================
RUN chown root:root /usr/bin/ssss-combine && \
    chmod 700 /usr/bin/ssss-combine

# ============================================================
# FAILLE SUDO — misconfiguration vim (GTFOBins)
# L'utilisateur peut lancer vim en root sans mot de passe
# Exploitation : sudo vim -c ':!/bin/bash'
# ============================================================
RUN echo "${USER} ALL=(root) NOPASSWD: /usr/bin/vim" >> /etc/sudoers

# ============================================================
# GÉNÉRATION DES 8 FRAGMENTS SSSS À PARTIR DU FLAG
# Chaque fragment est placé dans une room distincte
# Lisible par root uniquement (chmod 400)
# ============================================================


WORKDIR /home/${USER}


EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]