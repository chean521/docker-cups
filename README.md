![Docker Pulls](https://img.shields.io/docker/pulls/kaneymhf/docker-cups) [![](https://images.microbadger.com/badges/image/kaneymhf/docker-cups.svg)](https://microbadger.com/images/kaneymhf/docker-cups "Get your own image badge on microbadger.com") ![Docker Stars](https://img.shields.io/docker/stars/kaneymhf/docker-cups) [![](https://images.microbadger.com/badges/version/kaneymhf/docker-cups.svg)](https://microbadger.com/images/kaneymhf/docker-cups "Get your own version badge on microbadger.com") 

# CUPS print server image

## Overview
Docker image including CUPS print server and printing drivers (installed from the Debian packages)

# Docker Informations

* This image expose the following port

| Port | Usage |
|:----:|:-----:|
|  631/tcp  | CUPS TCP Port |

* The following volume is exposed by this image

|         Volume        |          Usage          |
|:---------------------:|:-----------------------:|
|  /etc/cups  | CUPS config folder  |
| /mnt/backends | Additional CUPS Backends config folder |
|  /mnt/drivers  | Aditional drivers needed to be installed |
| /var/log/cups |  CUPS logs folder |
| /var/spool/cups | CUPS Spool files | 

__Note__: The **/mnt/drivers** must have a **install.sh** script to install the additional drivers

__Note__: The admin user/password for the Cups server is `print`/`print`

### Included package
* cups, cups-client, cups-filters
* foomatic-db
* printer-driver-all
* openprinting-ppds
* hpijs-ppds, hp-ppd
* sudo, whois
* ttf-liberation-fonts, font-config
* gcc, python, pkpgcounter, snmp, libpqxx

# Usage

## Example run command:
```bash
docker run --name cups --restart unless-stopped  --net host\
  -v /path/to/configs:/etc/cups \
  -v /path/to/backends:/mnt/backends \
  -v /path/to/logs:/var/log/cups \
  -v /path/to/drivers:/mnt/drivers \
  -v /path/to/spool:/var/spool/cups \
  -p 631:631 \
  kaneymhf/docker-cups-simpres:latest
```


## Docker-compose Example

```yml
version: "3.2"

services:
  cups:
    image: kaneymhf/docker-cups-simpres:latest
    ports:
      - target: 631
        published: 631
        protocol: tcp
        mode: host
    volumes:
      - /path/to/drivers:/mnt/drivers
      - /path/to/configs:/etc/cups
      - /path/to/backends:/mnt/backends
      - /path/to/logs:/var/log/cups
      - /path/to/spool:/var/spool/cups
      - /etc/localtime:/etc/localtime:ro
      - /etc/timezone:/etc/timezone:ro
```

## Add printers to the Cups server
1. Connect to the Cups server at [http://127.0.0.1:631](http://127.0.0.1:631)
2. Add printers: Administration > Printers > Add Printer
