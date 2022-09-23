# Set the base image to Debian stable
FROM debian:stable-slim

# Update the repository sources list and install deb packages
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
     tcpdump \
     iproute2 \
     procps \
     bridge-utils \
     curl \
     wget \
     iptables \
     ebtables \
     host \
     iftop \
     socat \
     iperf \
     less \
     nano \
     net-tools \
     dnsutils \
     nmap \
     tcpreplay \
     traceroute \
     ethtool \
     iputils-ping \
     bmon \
    && apt-get clean

RUN curl -Lo /websocat.deb https://github.com/vi/websocat/releases/download/v1.4.0/websocat_1.4.0_ssl1.1_amd64.deb \
    && dpkg -i /websocat.deb \
    && rm -f /websocat.deb

# RUN /usr/sbin/sysctl -w net.ipv4.ip_forward=0

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"