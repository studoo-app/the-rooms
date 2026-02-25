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
    knockd \
    iptables \
    tcpdump \
    curl \
    && rm -rf /var/lib/apt/lists/*

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

RUN mkdir docs

# Create secret-key file

RUN echo "$SECRET_KEY" > docs/secret-key.txt

# Copy Challenge files
COPY rooms/room-06/node-02/knockd.conf /etc/knockd.conf

RUN chown -R $USER:$USER /home/$USER && chmod -R 700 /home/$USER


COPY rooms/room-06/node-02/start.sh /start.sh
RUN chmod +x /start.sh

# Expose SSH port
EXPOSE 22

# Start the SSH daemon
CMD ["/start.sh"]