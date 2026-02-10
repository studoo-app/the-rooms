FROM debian:12

# Get the username and password from build arguments
ARG USER
ARG PASS

# Update package lists and install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    iputils-ping \
    net-tools \
    openssh-server \
    nmap \
    && rm -rf /var/lib/apt/lists/*

# Copy motd file
COPY levels/level-03/config-files/motd.txt /etc/motd


# Create directory for SSH daemon
RUN mkdir /var/run/sshd

# Copy custom sshd_config
COPY levels/level-03/level-files/sshd_config /etc/ssh/sshd_config

# Create the user and set password
RUN useradd -m -s /bin/bash $USER
RUN echo "$USER:$PASS" | chpasswd
RUN usermod -aG sudo $USER

# Set working directory to the user's home
WORKDIR /home/$USER

# Create challenge directories
RUN mkdir .ssh
RUN mkdir messages && chown $USER:$USER messages && chmod 700 messages
RUN mkdir .vault && chown $USER:$USER .vault && chmod 700 .vault
RUN mkdir dicts && chown $USER:$USER dicts && chmod 700 dicts

# Adjust permissions
RUN chown -R $USER:$USER .ssh
RUN chmod 700 .ssh

# Copy the briefing file into the user's home directory
COPY levels/level-03/level-files/briefing.txt docs/briefing.txt

# Copy Challenge files

# Copy SSH keys for level access
COPY levels/level-03/level-files/keys/level_3_access_rsa.pub .ssh/authorized_keys
RUN chmod 600 .ssh/authorized_keys

# Copy files for the cipher challenge
COPY levels/level-03/level-files/messages/encrypted_credentials.enc .vault/encrypted_credentials.enc
COPY levels/level-03/level-files/rockyou.txt dicts/rockyou.txt

# Expose SSH port
EXPOSE 22

# Start the SSH daemon
CMD ["/usr/sbin/sshd", "-D"]