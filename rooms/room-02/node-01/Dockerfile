FROM debian:12-slim

# Get the username and password from build arguments
ARG USER
ARG PASS
ARG ZIP_PASS
ARG FLAG
ARG NEXT_HOST=""
ARG NEXT_USER=""
ARG NEXT_PASS=""

# Update package lists and install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    iputils-ping \
    net-tools \
    openssh-server \
    sudo \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Create directory for SSH daemon
RUN mkdir /var/run/sshd

# Create the user and set password
RUN useradd -m -s /bin/bash $USER
RUN echo "$USER:$PASS" | chpasswd
RUN usermod -aG sudo $USER

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

# Set working directory to the user's home
WORKDIR /home/$USER

# Create challenge directories
RUN mkdir .keys
RUN mkdir -p .confidential/.hidden
RUN mkdir docs

# Adjust permissions
RUN chown -R $USER:$USER .keys
RUN chown -R $USER:$USER .confidential
RUN chmod -R 700 .confidential

# Copy the briefing file into the user's home directory
#COPY levels/level-02/level-files/briefing.txt docs/briefing.txt

# Copy Challenge files
COPY rooms/room-02/node-01/keys/decoy .keys
COPY rooms/room-02/node-01/keys/valid .confidential/.hidden
RUN chown -R $USER:$USER .confidential/.hidden

# Expose SSH port
EXPOSE 22

# Start the SSH daemon
CMD ["/usr/sbin/sshd", "-D"]