ARG STUNNER_VERSION=2.0.0

###########
# STUNNER
# stunnerd is released as a container image only
FROM l7mp/stunnerd:$STUNNER_VERSION AS stunnerd

###########
# BUILD
# Download and compress external binaries
FROM alpine:3.24 AS builder

ARG STUNNER_VERSION
ENV WEBSOCAT_VERSION=v1.14.1

WORKDIR /app
RUN apk add --no-cache curl upx

RUN curl -Lo websocat \
     https://github.com/vi/websocat/releases/download/$WEBSOCAT_VERSION/websocat.$(apk --print-arch)-unknown-linux-musl \
    && chmod a+x websocat \
    && upx --best --lzma websocat

RUN apkArch="$(apk --print-arch)"; \
      case "$apkArch" in \
        x86_64) export ARCH='amd64' ;; \
        aarch64) export ARCH='arm64' ;; \
        *) echo "unsupported architecture: $apkArch" >&2; exit 1 ;; \
    esac; \
    curl -Lo mediactl \
     https://github.com/l7mp/stunner/releases/download/v$STUNNER_VERSION/mediactl-v$STUNNER_VERSION-linux-$ARCH \
    && chmod a+x mediactl \
    && upx --best --lzma mediactl

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
COPY --from=builder /app/stunnerd /app/mediactl /usr/bin/

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
