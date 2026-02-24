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
    echo "$SECRET_PART" > /tmp/secret/key_part.txt && \
    if [ -n "$NEXT_HOST" ] && [ -n "$NEXT_USER" ] && [ -n "$NEXT_PASS" ]; then \
        printf "=== Accès niveau suivant ===\nHost : %s\nUser : %s\nPass : %s\n" \
            "$NEXT_HOST" "$NEXT_USER" "$NEXT_PASS" > /tmp/secret/next_level.txt; \
    fi && \
    zip -j -P "$ZIP_PASS" /home/$USER/secret.zip /tmp/secret/* && \
    chown $USER:$USER /home/$USER/secret.zip && \
    rm -rf /tmp/secret

WORKDIR /home/$USER

# Copy the briefing file
COPY rooms/room-07/node-01/niveau-07-jacqueline.txt briefing.txt

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]