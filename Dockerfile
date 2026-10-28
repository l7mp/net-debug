ARG STUNNERD_VERSION=2.0.0

###########
# STUNNERD
# stunnerd is released as a container image only
FROM l7mp/stunnerd:$STUNNERD_VERSION AS stunnerd

###########
# BUILD
# Download and compress external binaries
FROM alpine:3.24 AS builder

ENV WEBSOCAT_VERSION=v1.14.1

WORKDIR /app
RUN apk add --no-cache curl upx

RUN curl -Lo websocat \
     https://github.com/vi/websocat/releases/download/$WEBSOCAT_VERSION/websocat.$(apk --print-arch)-unknown-linux-musl \
    && chmod a+x websocat \
    && upx --best --lzma websocat

COPY --from=stunnerd /usr/bin/stunnerd .
RUN upx --best --lzma stunnerd

####
# NET-DEBUG
FROM alpine:3.24

RUN apk add --no-cache \
    bash \
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
    tar \
    wget \
    tcpreplay \
    minio-client

COPY --from=builder /app/websocat /usr/bin/
COPY --from=builder /app/stunnerd /usr/bin/

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
