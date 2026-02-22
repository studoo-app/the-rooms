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
    hashcat \
    exiftool \
    && rm -rf /var/lib/apt/lists/*

# Create directory for SSH daemon
RUN mkdir /var/run/sshd

# Create the user and set password
RUN useradd -m -s /bin/bash $USER
RUN echo "$USER:$PASS" | chpasswd
RUN usermod -aG sudo $USER

# Set working directory to the user's home
WORKDIR /home/$USER

# Copy the briefing file into the user's home directory
#COPY levels/level-05/level-files/briefing.txt docs/briefing.txt

# Copy Challenge files

COPY rooms/room-05/node-01/company_infos docs/company_infos
COPY rooms/room-05/node-01/employees docs/employees
COPY rooms/room-05/node-01/security docs/security

# Change image metadata with exiftool
RUN exiftool -overwrite_original \
  -DateTimeOriginal="2019:04:15 14:32:05" \
  -GPSLatitude=35.689339 -GPSLatitudeRef=N \
  -GPSLongitude=139.692083 -GPSLongitudeRef=E \
  docs/employees/alice_martin/photo_vacances_023.jpg

# Expose SSH port
EXPOSE 22

# Start the SSH daemon
CMD ["/usr/sbin/sshd", "-D"]