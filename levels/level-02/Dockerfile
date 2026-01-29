FROM debian:12

# Get the username from build arguments
ARG USER

# Update package lists and install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    iputils-ping \
    net-tools \
    openssh-server \
    nmap \
    && rm -rf /var/lib/apt/lists/*

# Copy motd file
COPY levels/level-02/config-files/motd.txt /etc/motd


# Create directory for SSH daemon
RUN mkdir /var/run/sshd

# Create the user and set password (default: password)
# TODO : [LEVEL-02] change default password
RUN useradd -m -s /bin/bash $USER
RUN echo "$USER:password" | chpasswd
RUN usermod -aG sudo $USER

# Set working directory to the user's home
WORKDIR /home/$USER

# Create challenge directories
RUN mkdir .keys
RUN mkdir -p .confidential/.hidden
RUN mkdir docs

# Adjust permissions
RUN chown -R $USER:$USER .keys
RUN chown -R $USER:$USER .confidential
RUN chmod -R 700 .confidential

# Copy the briefing file into the user's home directory
COPY levels/level-02/level-files/briefing.txt docs/briefing.txt

# Copy Challenge files
COPY levels/level-02/level-files/decoy .keys
COPY levels/level-02/level-files/valid .confidential/.hidden/

# Expose SSH port
EXPOSE 22

# Start the SSH daemon
CMD ["/usr/sbin/sshd", "-D"]