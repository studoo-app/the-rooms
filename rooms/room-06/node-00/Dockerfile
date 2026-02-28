FROM debian:12-slim

ARG USER
ARG PASS

RUN apt-get update && apt-get install -y \
    tcpdump \
    tshark \
    bettercap \
    net-tools \
    curl \
    iputils-ping \
    nmap \
    dnsutils \
    iproute2 \
    openssh-server \
    sudo \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd

RUN useradd -m -s /bin/bash $USER && \
    echo "$USER:$PASS" | chpasswd && \
    usermod -aG sudo $USER

WORKDIR /home/$USER

COPY rooms/room-06/node-00/rockyou.txt rockyou.txt

RUN chown -R $USER:$USER /home/$USER && chmod -R 700 /home/$USER

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]