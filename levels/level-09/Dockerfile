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
    knockd \
    && rm -rf /var/lib/apt/lists/*

# Copy motd file TODO: provide motd file for level 9
#COPY levels/level-04/node-1/config-files/motd.txt /etc/motd


# Create directory for SSH daemon
RUN mkdir /var/run/sshd

# Copy custom sshd_config
COPY levels/level-09/config-files/sshd_config /etc/ssh/sshd_config

# Create the user and set password
RUN useradd -m -s /bin/bash $USER
RUN echo "$USER:$PASS" | chpasswd
RUN usermod -aG sudo $USER

# Set working directory to the user's home
WORKDIR /home/$USER

# Create challenge directories and copy files
RUN mkdir docs .ssh

# Adjust permissions
RUN chown -R $USER:$USER .ssh
RUN chmod 700 .ssh

# Copy the briefing file into the user's home directory
COPY levels/level-09/level-files/briefing.txt docs/briefing.txt
COPY levels/level-09/level-files/knockd.conf /etc/knockd.conf

# Copy SSH keys for level access
COPY levels/level-09/level-files/key.pub .ssh/authorized_keys
RUN chmod 600 .ssh/authorized_keys

# Expose SSH port
EXPOSE 22

# Start the SSH daemon
CMD ["/usr/sbin/sshd", "-D"]