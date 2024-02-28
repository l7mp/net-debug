###########
# BUILD
# Build turncat
FROM golang:1.21-alpine as builder

WORKDIR /app
RUN apk add --no-cache git tar wget upx
RUN wget https://github.com/l7mp/stunner/archive/refs/tags/v0.18.0.tar.gz -O stunner.tar.gz \
    && tar --strip-components=1 -zxf stunner.tar.gz -C .
RUN apkArch="$(apk --print-arch)"; \
      case "$apkArch" in \
        aarch64) export GOARCH='arm64' ;; \
        *) export GOARCH='amd64' ;; \
      esac; \
    CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -trimpath -o turncat cmd/turncat/main.go
RUN upx --best --lzma turncat

####
# NET-DEBUG
FROM alpine:3.19

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
    && apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    tcpreplay

RUN curl -Lo /usr/bin/websocat \
    https://github.com/vi/websocat/releases/download/v1.12.0/websocat.$(apk --print-arch)-unknown-linux-musl \
    && chmod a+x /usr/bin/websocat

# RUN /usr/sbin/sysctl -w net.ipv4.ip_forward=0

COPY --from=builder /app/turncat /usr/bin/

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"