#!/bin/bash
## Check if configs exists
CUPS_CFG="/etc/cups"

if [ "$(ls -A $CUPS_CFG)" ]; then
    printf "CUPS directory is not empty, skipping\n"
else
    cp -rap /etc/cups.orig/* /etc/cups/.
    printf "Configuration files copied\n"
fi


## Copy backends
BACKENDS="/mnt/backends"
if [ -d "$BACKENDS" ]; then

    if [ "$(ls -A $BACKENDS)" ]; then
        cd $BACKENDS
        for filename in *; do
            cp $filename /usr/lib/cups/backend/$filename
            chmod 700 /usr/lib/cups/backend/$filename
            chown root:root /usr/lib/cups/backend/$filename
            printf "Backend $filename installed\n"
        done
        printf "All backends installed\n"
    else
        printf "Backend directory found, but don't have any backend inside"
    fi
else
    printf "Backend directory not found"
fi

printf "Installing drivers\n"

if [ -e /mnt/drivers/install.sh ]; then
    /mnt/drivers/install.sh
fi

# Starts CUPS
/usr/sbin/cupsd -f
