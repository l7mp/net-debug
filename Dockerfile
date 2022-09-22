# Set the base image to Debian stable
FROM debian:stable-slim

# Update the repository sources list once more
RUN apt-get update

# Install deb packages
RUN apt-get install -qq -y tcpdump iproute2 procps \
    bridge-utils curl ebtables host iftop socat \
    iperf iproute2 iptables less nano net-tools \
    nmap tcpreplay traceroute wget ethtool iputils-ping && apt-get clean

RUN curl -Lo /websocat.deb https://github.com/vi/websocat/releases/download/v1.4.0/websocat_1.4.0_ssl1.1_amd64.deb && dpkg -i /websocat.deb && rm -f /websocat.deb

# RUN /usr/sbin/sysctl -w net.ipv4.ip_forward=0

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"