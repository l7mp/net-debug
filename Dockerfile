FROM alpine:latest

RUN apk add --no-cache \
    bmon \
    bridge-utils \
    curl \
    bind-tools \
    ebtables \
    ethtool \
    iftop \
    iperf \
    iproute2 \
    iptables \
    iputils \
    less \
    nano \
    net-tools \
    nmap \
    procps \
    socat \
    tcpdump \
    traceroute \
    wget \
    && apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    tcpreplay

RUN curl -Lo /usr/bin/websocat \
    https://github.com/vi/websocat/releases/download/v1.11.0/websocat.$(apk --print-arch)-unknown-linux-musl \
    && chmod a+x /usr/bin/websocat

# RUN /usr/sbin/sysctl -w net.ipv4.ip_forward=0

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"