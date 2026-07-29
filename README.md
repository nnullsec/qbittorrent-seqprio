# qbittorrent-seqprio
Forces qbittorrent to use sequential and first&amp;last piece first download options for every added torrent

## Installation

### Using curl

```bash
curl -fL https://raw.githubusercontent.com/nnullsec/qbittorrent-seqprio/main/install.sh \
  -o /tmp/install.sh \
  && sudo mv /tmp/install.sh /volume1/docker/qbittorrent/install.sh \
  && sudo chmod 755 /volume1/docker/qbittorrent/install.sh \
  && sudo /volume1/docker/qbittorrent/install.sh
```

### Using wget

```bash
wget https://raw.githubusercontent.com/nnullsec/qbittorrent-seqprio/main/install.sh \
  -O /tmp/install.sh \
  && sudo mv /tmp/install.sh /volume1/docker/qbittorrent/install.sh \
  && sudo chmod 755 /volume1/docker/qbittorrent/install.sh \
  && sudo /volume1/docker/qbittorrent/install.sh
```
