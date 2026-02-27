FROM debian:12-slim

ARG USER
ARG PASS
ARG ZIP_PASS
ARG FLAG
ARG NEXT_HOST=""
ARG NEXT_USER=""
ARG NEXT_PASS=""
ARG SECRET_PART

RUN apt-get update && apt-get install -y \
    curl \
    iputils-ping \
    net-tools \
    openssh-server \
    sudo \
    zip \
    nmap \
    unzip \
    knockd \
    vim \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd

RUN useradd -m -s /bin/bash $USER && \
    echo "$USER:$PASS" | chpasswd

#COPY rooms/room-08/node-01/sshd_config /etc/ssh/sshd_config

# ============================================================
# SUDO MISCONFIGURATION - activer UNE seule ligne à la fois
# ============================================================

# OPTION A : tous les droits sans mot de passe (classique GTFOBins)
# RUN echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER

# OPTION B : sudo find (GTFOBins : sudo find . -exec /bin/sh \; -quit)
# RUN echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/find" > /etc/sudoers.d/$USER

# OPTION C : sudo vim (GTFOBins : sudo vim -c ':!/bin/sh')
RUN echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/vim" > /etc/sudoers.d/$USER

# OPTION D : sudo less (GTFOBins : sudo less /etc/passwd -> !/bin/sh)
# RUN echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/less" > /etc/sudoers.d/$USER

# OPTION E : sudo cat uniquement - lecture seule, cohérent avec la narration
# RUN echo "$USER ALL=(ALL) NOPASSWD: /bin/cat" > /etc/sudoers.d/$USER

# OPTION F : sudo cp (permet de copier des fichiers sensibles)
# RUN echo "$USER ALL=(ALL) NOPASSWD: /bin/cp" > /etc/sudoers.d/$USER

# OPTION G : sudo python3 (GTFOBins : sudo python3 -c 'import os; os.system("/bin/sh")')
# RUN echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/python3" > /etc/sudoers.d/$USER

RUN chmod 0440 /etc/sudoers.d/$USER

# ============================================================
# FICHIERS ROOT
# ============================================================

RUN mkdir -p /root/docs

COPY rooms/room-08/node-01/bash_histories/root_history          /root/.bash_history
COPY rooms/room-08/node-01/docs/notes_infra.txt       /root/docs/notes_infra.txt
COPY rooms/room-08/node-01/docs/serveurs_reseau.txt   /root/docs/serveurs_reseau.txt

RUN chmod 700 /root/docs && \
    chmod 600 /root/.bash_history && \
    chmod 600 /root/docs/notes_infra.txt && \
    chmod 600 /root/docs/serveurs_reseau.txt

# ============================================================
# FICHIERS HUGUETTE
# ============================================================

RUN mkdir -p /home/$USER/docs && \
    mkdir -p /home/$USER/.ssh

COPY rooms/room-08/node-01/bash_histories/huguette_history                /home/$USER/.bash_history
COPY rooms/room-08/node-01/docs/notes_perso.txt   /home/$USER/docs/notes_perso.txt
COPY rooms/room-08/node-01/docs/todo.txt          /home/$USER/docs/todo.txt
COPY rooms/room-08/node-01/key                     /home/$USER/.ssh/key

# ============================================================
# BRIEFING
# ============================================================

COPY rooms/room-08/node-01/niveau-08-huguette.txt               /home/$USER/briefing.txt

# ============================================================
# FLAG + ZIP
# ============================================================

RUN mkdir -p /tmp/secret && \
    echo "$FLAG" > /tmp/secret/flag.txt && \
    echo "$SECRET_PART" > /tmp/secret/key_part.txt && \
    if [ -n "$NEXT_HOST" ] && [ -n "$NEXT_USER" ] && [ -n "$NEXT_PASS" ]; then \
        printf "=== Acces niveau suivant ===\nHost : %s\nUser : %s\nPass : %s\n" \
            "$NEXT_HOST" "$NEXT_USER" "$NEXT_PASS" > /tmp/secret/next_level.txt; \
    fi && \
    zip -j -P "$ZIP_PASS" /home/$USER/secret.zip /tmp/secret/* && \
    rm -rf /tmp/secret

# ============================================================
# PERMISSIONS FINALES
# ============================================================

RUN chown -R $USER:$USER /home/$USER && \
    chmod 700 /home/$USER && \
    chmod 700 /home/$USER/docs && \
    chmod 600 /home/$USER/.bash_history && \
    chmod 600 /home/$USER/docs/notes_perso.txt && \
    chmod 600 /home/$USER/docs/todo.txt && \
    chmod 644 /home/$USER/briefing.txt && \
    chown $USER:$USER /home/$USER/secret.zip

WORKDIR /home/$USER

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]