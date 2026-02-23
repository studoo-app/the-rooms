FROM debian:12-slim

ARG USER
ARG PASS
ARG ZIP_PASS
ARG FLAG
ARG NEXT_HOST=""
ARG NEXT_USER=""
ARG NEXT_PASS=""

RUN apt-get update && apt-get install -y \
    curl \
    iputils-ping \
    net-tools \
    openssh-server \
    nmap \
    sudo \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd

RUN useradd -m -s /bin/bash $USER && \
    echo "$USER:$PASS" | chpasswd && \
    usermod -aG sudo $USER

RUN mkdir -p /tmp/secret && \
    echo "$FLAG" > /tmp/secret/flag.txt && \
    if [ -n "$NEXT_HOST" ] && [ -n "$NEXT_USER" ] && [ -n "$NEXT_PASS" ]; then \
        printf "=== Accès niveau suivant ===\nHost : %s\nUser : %s\nPass : %s\n" \
            "$NEXT_HOST" "$NEXT_USER" "$NEXT_PASS" > /tmp/secret/next_level.txt; \
    fi && \
    zip -j -P "$ZIP_PASS" /home/$USER/secret.zip /tmp/secret/* && \
    chown $USER:$USER /home/$USER/secret.zip && \
    rm -rf /tmp/secret

WORKDIR /home/$USER

# Create challenge directories# Copy the briefing file into the user's home directory
RUN mkdir docs && chown $USER:$USER docs && chmod 700 docs
COPY rooms/room-04/node-00/briefing.txt docs/briefing.txt
COPY rooms/room-04/node-00/acces-ssh.txt docs/acces-ssh.txt

# Expose SSH port
EXPOSE 22

# Start the SSH daemon
CMD ["/usr/sbin/sshd", "-D"]