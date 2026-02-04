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
    hashcat \
    && rm -rf /var/lib/apt/lists/*

# Copy motd file TODO: provide motd file for node 4-6
#COPY levels/level-04/node-6/config-files/motd.txt /etc/motd


# Create directory for SSH daemon
RUN mkdir /var/run/sshd

# Copy custom sshd_config
COPY levels/level-04/node-6/sshd_config /etc/ssh/sshd_config

# Create the user and set password
RUN useradd -m -s /bin/bash $USER
RUN echo "$USER:$PASS" | chpasswd
RUN usermod -aG sudo $USER

# Set working directory to the user's home
WORKDIR /home/$USER

# Create challenge directories
# Copy the files into the user's home directory
RUN mkdir docs && chown $USER:$USER docs && chmod 700 docs
COPY levels/level-04/node-6/level-files/next-password.txt docs/next-password.txt

# Expose SSH port
EXPOSE 22

# Start the SSH daemon
CMD ["/usr/sbin/sshd", "-D"]