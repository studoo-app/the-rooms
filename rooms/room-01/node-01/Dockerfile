FROM debian:12-slim
# Get the username and password from build arguments
ARG USER
ARG PASS
ARG SECRET_KEY

# Update package lists and install necessary packages
RUN apt-get update && apt-get install -y \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

# Copy motd file \
#COPY levels/level-01/config-files/motd.txt /etc/motd

# Create directory for SSH daemon

RUN mkdir /var/run/sshd

# Create the user and set password

RUN useradd -m -s /bin/bash $USER
RUN echo "$USER:$PASS" | chpasswd
RUN usermod -aG sudo $USER

# Set working directory to the user's home
WORKDIR /home/$USER

# Create challenge directories

RUN mkdir docs
RUN mkdir -p .secrets/.hidden

# Copy Challenge files

COPY rooms/room-01/node-01/backup_credentials.txt .secrets/backup_credentials.txt

# Create secret-key file

RUN echo "$SECRET_KEY" > .secrets/.hidden/secret-key.txt

# Expose SSH port

EXPOSE 22

# Start the SSH daemon

CMD ["/usr/sbin/sshd", "-D"]