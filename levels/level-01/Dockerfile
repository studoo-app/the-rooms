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

# Copy motd file \
COPY levels/level-01/config-files/motd.txt /etc/motd


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

# Copy the briefing file into the user's home directory
COPY levels/level-01/level-files/briefing.txt docs/briefing.txt

# Copy Challenge files
#COPY level-files/backup_credentials.txt .secrets/backup_credentials.txt
#COPY level-files/level2_access.txt .secrets/.hidden/level2_access.txt

COPY levels/level-01/level-files/backup_credentials.txt .secrets/backup_credentials.txt
COPY levels/level-01/level-files/level2_access.txt .secrets/.hidden/key.txt

# Expose SSH port
EXPOSE 22

# Start the SSH daemon
CMD ["/usr/sbin/sshd", "-D"]