<p align="left">
 <a href="https://hub.docker.com/repository/docker/l7mp/net-debug" alt="Docker pulls">
  <img src="https://img.shields.io/docker/pulls/l7mp/net-debug" /></a>
 <a href="https://discord.gg/DyPgEsbwzc" alt="Discord">
  <img alt="Discord" src="https://img.shields.io/discord/945255818494902282" /></a>
</p>

# net-debug

## Description

Assorted network debugging goodies, like `tcpdump`, `socat`/`websocat`, `iperf`, `nmap`, `nslookup`, `dig`, `tcpreplay`, and `ping`/`traceroute`, all packaged in a self-contained Docker image. The intended use is to sideload the container as a sidecar to Kubernetes pods in order to debug network reachability and performance issues.

## Usage examples

### Create a Deployment

Config: [yaml](examples/net-debug.yaml)

Usage:
```console
kubectl apply -f examples/net-debug.yaml
```

### Create a Deployment in host network
Config: [yaml](examples/net-debug-host.yaml)

Usage:
```console
kubectl apply -f examples/net-debug-host.yaml
```

### Create a DeamonSet in host network

Config: [yaml](examples/net-debug-daemonset.yaml)

Usage:
```console
kubectl apply -f examples/net-debug-dameonset.yaml
```

## Help

Development is coordinated in Discord, feel free to [join](https://discord.gg/DyPgEsbwzc).

## License

MIT License - see [LICENSE](LICENSE) for full text.
