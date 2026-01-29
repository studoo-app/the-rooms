FROM debian:12

# Get the username from build arguments
ARG USER

# Update package lists and install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    iputils-ping \
    net-tools \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

# Copy motd file \
COPY lobby/motd.txt /etc/motd

# Create directory for SSH daemon
RUN mkdir /var/run/sshd

# Create the user and set password (default: password)
# TODO : [Lobby] change default password
RUN useradd -m -s /bin/bash $USER
RUN echo "$USER:password" | chpasswd
RUN usermod -aG sudo $USER

# Set working directory to the user's home
WORKDIR /home/$USER

# Copy the briefing file into the user's home directory
COPY lobby/briefing.txt briefing.txt

# Expose SSH port
EXPOSE 22

# Start the SSH daemon
CMD ["/usr/sbin/sshd", "-D"]