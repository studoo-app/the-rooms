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
    sqlmap \
    iptables \
    tcpdump \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy motd file
COPY levels/level-07/config-files/motd.txt /etc/motd


# Create directory for SSH daemon
RUN mkdir /var/run/sshd

# Copy custom sshd_config
#COPY levels/level-05/level-files/sshd_config /etc/ssh/sshd_config

# Create the user and set password
RUN useradd -m -s /bin/bash $USER
RUN echo "$USER:$PASS" | chpasswd
RUN usermod -aG sudo $USER

# Set working directory to the user's home
WORKDIR /home/$USER

# Copy the briefing file into the user's home directory
COPY levels/level-07/level-files/briefing.txt docs/briefing.txt

# Copy Challenge files
COPY levels/level-07/level-files/knockd.conf /etc/knockd.conf
COPY levels/level-07/level-files/start.sh /start.sh
RUN chmod +x /start.sh

# Expose SSH port
EXPOSE 22

# Start the SSH daemon
CMD ["/start.sh"]