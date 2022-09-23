<p align="left">
 <a href="https://hub.docker.com/repository/docker/l7mp/net-debug" alt="Docker pulls">
  <img src="https://img.shields.io/docker/pulls/l7mp/net-debug" /></a>
 <a href="https://discord.gg/DyPgEsbwzc" alt="Discord">
  <img alt="Discord" src="https://img.shields.io/discord/945255818494902282" /></a>
</p>

# net-debug

## Description

Assorted network debugging goodies, like `tcpdump`, `socat`/`websocat`, `iperf`, `nmap`, `nslookup`, `dig`, `tcpreplay`, and `ping`/`traceroute`, all packaged in a self-contained Debian image. The intended use is to sideload the container as a sidecar to Kubernetes pods in order to debug network reachability and performance issues.

## Usage example

The following snippet starts a net-debug container in nost namespace:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: net-debug-host
spec:
  selector:
    matchLabels:
      app: net-debug-host
  replicas: 1
  template:
    metadata:
      labels:
        app: net-debug-host
    spec:
      hostNetwork: true
      containers:
      - name: net-debug
        image: l7mp/net-debug
```

## License

MIT License - see [LICENSE](LICENSE) for full text.
