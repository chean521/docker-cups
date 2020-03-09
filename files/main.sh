#!/bin/bash

cd /mnt/backends

for filename in *; do
    cp $filename /usr/lib/cups/backend/$filename
    chmod 700 /usr/lib/cups/backend/$filename
    chown root:root /usr/lib/cups/backend/$filename
done

if [ -e /mnt/drivers/install.sh ]
then
    /mnt/drivers/install.sh
fi

/usr/sbin/cupsd -f
