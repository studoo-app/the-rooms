FROM debian:12-slim

# Get the username and password from build arguments
ARG USER
ARG PASS
ARG SECRET_KEY

# Update package lists and install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    iputils-ping \
    net-tools \
    openssh-server \
    nmap \
    && rm -rf /var/lib/apt/lists/*

# Copy motd file
#COPY levels/level-03/config-files/motd.txt /etc/motd


# Create directory for SSH daemon
RUN mkdir /var/run/sshd

# Copy custom sshd_config
COPY rooms/room-02/node-02/sshd_config /etc/ssh/sshd_config

# Create the user and set password
RUN useradd -m -s /bin/bash $USER
RUN echo "$USER:$PASS" | chpasswd
RUN usermod -aG sudo $USER

# Set working directory to the user's home
WORKDIR /home/$USER

RUN mkdir docs

# Create secret-key file

RUN echo "$SECRET_KEY" > docs/secret-key.txt


# Create challenge directories
RUN mkdir .ssh

# Copy SSH keys for level access
COPY rooms/room-02/node-02/keys/key.pub .ssh/authorized_keys
RUN chmod 600 .ssh/authorized_keys
RUN chown -R $USER:$USER .ssh
RUN chmod 700 .ssh

# Expose SSH port
EXPOSE 22

# Start the SSH daemon
CMD ["/usr/sbin/sshd", "-D"]