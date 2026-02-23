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
    if [ -n "$NEXT_HOST" ] && [ -n "$NEXT_USER" ] && [ -n "$NEXT_PASS" ]; then \
        printf "=== Accès niveau suivant ===\nHost : %s\nUser : %s\nPass : %s\n" \
            "$NEXT_HOST" "$NEXT_USER" "$NEXT_PASS" > /tmp/secret/next_level.txt; \
    fi && \
    zip -j -P "$ZIP_PASS" /home/$USER/secret.zip /tmp/secret/* && \
    chown $USER:$USER /home/$USER/secret.zip && \
    rm -rf /tmp/secret

WORKDIR /home/$USER

# Create challenge directories
RUN mkdir messages && chown $USER:$USER messages && chmod 700 messages
RUN mkdir .vault && chown $USER:$USER .vault && chmod 700 .vault
RUN mkdir dicts && chown $USER:$USER dicts && chmod 700 dicts

# Copy Challenge files

# Copy files for the cipher challenge
COPY rooms/room-03/messages/encrypted_credentials.enc .vault/encrypted_credentials.enc
COPY rooms/room-03/rockyou.txt dicts/rockyou.txt

# Create secret-key file

RUN echo "$ZIP_PASS" > .secrets/.hidden/secret-key.txt


EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]