FROM debian:bookworm-slim

LABEL maintainer="Maykon H Facincani <maykon.facincani@uftm.edu.br>"
LABEL version="2.0"
LABEL description="CUPS Ready to SiMPres Backend"

ENV ADDRESS *

# Install nodejs
RUN apt update && apt install -y curl
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -

# Install Packages (basic tools, cups, basic drivers, HP drivers)
RUN apt-get update \
&& apt-get install -y \
  sudo \
  whois \
  cups \
  cups-client \
  cups-bsd \
  cups-filters \
  foomatic-db-compressed-ppds \
  printer-driver-all \
  openprinting-ppds \
  hpijs-ppds \
  hp-ppd \
  hplip \
  build-essential \
  python3 \
  ink \
  snmp \
  python3-pil \
  libpqxx-dev \
  fontconfig \
  fonts-liberation \
  nodejs \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

# Add user and disable sudo password checking
RUN useradd \
  --groups=sudo,lp,lpadmin \
  --create-home \
  --home-dir=/home/print \
  --shell=/bin/bash \
  --password=$(mkpasswd print) \
  print \
&& sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers

# Configure the service's to be reachable
RUN /usr/sbin/cupsd \
  && while [ ! -f /var/run/cups/cupsd.pid ]; do sleep 1; done \
  && cupsctl --remote-admin --remote-any --share-printers \
  && kill $(cat /var/run/cups/cupsd.pid)

RUN sed -i 's/.*enable\-dbus=.*/enable\-dbus\=no/' /etc/avahi/avahi-daemon.conf

ADD files/main.sh /root/main.sh
ADD files/healthcheck.js /root/healthcheck.js
ADD files/dummy /usr/lib/cups/backend/dummy

ADD files/cups /etc/cups

RUN chmod 700 /usr/lib/cups/backend/dummy
RUN chown root:root /usr/lib/cups/backend/dummy
RUN chmod +x /root/main.sh

RUN mkdir /etc/cups.orig
RUN cp -rap /etc/cups/* /etc/cups.orig/.


VOLUME /etc/cups
VOLUME /mnt/backends
VOLUME /mnt/drivers
VOLUME /var/log/cups
VOLUME /var/spool/cups

EXPOSE 631

HEALTHCHECK --interval=10s --timeout=2s CMD node /root/healthcheck.js || killall -9 cupsd

ENTRYPOINT "/root/main.sh" /usr/sbin/cupsd -f

