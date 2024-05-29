###########
# BUILD
# Download and compress external binaries
FROM alpine:3.20 as builder

ENV TURNCAT_VERSION=v0.19.0
ENV WEBSOCAT_VERSION=v1.13.0

WORKDIR /app
RUN apk add --no-cache curl upx
RUN echo $(apk --print-arch)
RUN curl -Lo websocat \
     https://github.com/vi/websocat/releases/download/$WEBSOCAT_VERSION/websocat.$(apk --print-arch)-unknown-linux-musl \
    && chmod a+x websocat \
    && upx --best --lzma websocat

RUN apkArch="$(apk --print-arch)"; \
      case "$apkArch" in \
        aarch64) export ARCH='arm64' ;; \
        *) export ARCH='amd64' ;; \
    esac; \
    curl -Lo turncat \
     https://github.com/l7mp/stunner/releases/download/$TURNCAT_VERSION/turncat-$TURNCAT_VERSION-linux-$ARCH \
    && chmod a+x turncat \
    && upx --best --lzma turncat

####
# NET-DEBUG
FROM alpine:3.20

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
    tcpreplay

# RUN /usr/sbin/sysctl -w net.ipv4.ip_forward=0

COPY --from=builder /app/websocat /usr/bin/
COPY --from=builder /app/turncat /usr/bin/

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"