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
    nmap \
    && rm -rf /var/lib/apt/lists/*


# Create directory for SSH daemon
RUN mkdir /var/run/sshd

# Copy custom sshd_config
#COPY levels/level-03/level-files/sshd_config /etc/ssh/sshd_config

# Create the user and set password
RUN useradd -m -s /bin/bash $USER
RUN echo "$USER:$PASS" | chpasswd
RUN usermod -aG sudo $USER

# Set working directory to the user's home
WORKDIR /home/$USER

# Create challenge directories# Copy the briefing file into the user's home directory
RUN mkdir docs && chown $USER:$USER docs && chmod 700 docs
COPY rooms/room-04/node-00/briefing.txt docs/briefing.txt
COPY rooms/room-04/node-00/acces-ssh.txt docs/acces-ssh.txt

# Expose SSH port
EXPOSE 22

# Start the SSH daemon
CMD ["/usr/sbin/sshd", "-D"]