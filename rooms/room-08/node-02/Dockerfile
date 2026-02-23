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


# Create directory for SSH daemon
RUN mkdir /var/run/sshd

# Copy custom sshd_config
COPY rooms/room-08/node-02/sshd_config /etc/ssh/sshd_config

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
COPY rooms/room-08/node-02/knockd.conf /etc/knockd.conf

# Copy SSH keys for level access
COPY rooms/room-08/node-02/key.pub .ssh/authorized_keys
RUN chmod 600 .ssh/authorized_keys

# Expose SSH port
EXPOSE 22

# Start the SSH daemon
CMD ["/usr/sbin/sshd", "-D"]