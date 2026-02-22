FROM debian:12-slim

ARG USER
ARG PASS

RUN apt-get update && apt-get install -y \
    curl \
    iputils-ping \
    net-tools \
    openssh-server \
    sudo \
    zip \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd

RUN useradd -m -s /bin/bash $USER && \
    echo "$USER:$PASS" | chpasswd && \
    usermod -aG sudo $USER

WORKDIR /home/$USER

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]