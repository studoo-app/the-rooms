FROM debian:12-slim

# Get the username and password from build arguments
ARG USER
ARG PASS

# Update package lists and install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    iputils-ping \
    net-tools \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*


# Create directory for SSH daemon
RUN mkdir /var/run/sshd

# Create the user and set password
RUN useradd -m -s /bin/bash $USER
RUN echo "$USER:$PASS" | chpasswd
RUN usermod -aG sudo $USER

# Set working directory to the user's home
WORKDIR /home/$USER

# Create challenge directories
RUN mkdir messages && chown $USER:$USER messages && chmod 700 messages
RUN mkdir .vault && chown $USER:$USER .vault && chmod 700 .vault
RUN mkdir dicts && chown $USER:$USER dicts && chmod 700 dicts

# Copy Challenge files

# Copy files for the cipher challenge
COPY rooms/room-03/node-01/messages/encrypted_credentials.enc .vault/encrypted_credentials.enc
COPY rooms/room-03/node-01/rockyou.txt dicts/rockyou.txt

# Expose SSH port
EXPOSE 22

# Start the SSH daemon
CMD ["/usr/sbin/sshd", "-D"]